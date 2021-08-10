Return-Path: <nvdimm+bounces-763-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C053E3FE7
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C623E1C0F41
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C059A2FB8;
	Mon,  9 Aug 2021 06:26:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B1717F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5mmSDcz0zlNa1bJPvEzM77FyPN1YuawnYHfKP4XtUdQ=; b=WqaXL+CLIvil7cs+NVP0Wzxl3p
	El2/twZ8DW0kIx/tt+BYcYzFNh2q6LR2iCQK+EzFZE2HWM+wcUE5XYUaCGIuKtjg2zLNaLWnvcMNE
	BdFuIMMAqYWy8zTRoSh/Ugzqbb7mA43DQlVF0bVjSJtt083j9NuLDLdUJFugFca53OWaZCvvvY50G
	7vB0Ql8XoTwFNxkVO7+YYtzle8deuLUKKy0MiVVVmbjiSsffk1fmdiInQp3SdFeeIWn/gmOJVXvgs
	HMuzrNq8ChqP7uSajuzAQ1WrctHj8a2ylrQ7/ssDDBpePCSZAD7FyPIDgG1H3A8z54tB9SWEnXDbB
	ZXlXU9Eg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyi0-00AhEN-Tl; Mon, 09 Aug 2021 06:24:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	cluster-devel@redhat.com
Subject: [PATCH 15/30] iomap: switch iomap_zero_range to use iomap_iter
Date: Mon,  9 Aug 2021 08:12:29 +0200
Message-Id: <20210809061244.1196573-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809061244.1196573-1-hch@lst.de>
References: <20210809061244.1196573-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Switch iomap_zero_range to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4f525727462f33..3a23f7346938fb 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -896,11 +896,12 @@ static s64 iomap_zero(struct inode *inode, loff_t pos, u64 length,
 	return iomap_write_end(inode, pos, bytes, bytes, page, iomap, srcmap);
 }
 
-static loff_t iomap_zero_range_actor(struct inode *inode, loff_t pos,
-		loff_t length, void *data, struct iomap *iomap,
-		struct iomap *srcmap)
+static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
-	bool *did_zero = data;
+	struct iomap *iomap = &iter->iomap;
+	struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
 	loff_t written = 0;
 
 	/* already zeroed?  we're done. */
@@ -910,10 +911,11 @@ static loff_t iomap_zero_range_actor(struct inode *inode, loff_t pos,
 	do {
 		s64 bytes;
 
-		if (IS_DAX(inode))
+		if (IS_DAX(iter->inode))
 			bytes = dax_iomap_zero(pos, length, iomap);
 		else
-			bytes = iomap_zero(inode, pos, length, iomap, srcmap);
+			bytes = iomap_zero(iter->inode, pos, length, iomap,
+					   srcmap);
 		if (bytes < 0)
 			return bytes;
 
@@ -931,19 +933,17 @@ int
 iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		const struct iomap_ops *ops)
 {
-	loff_t ret;
-
-	while (len > 0) {
-		ret = iomap_apply(inode, pos, len, IOMAP_ZERO,
-				ops, did_zero, iomap_zero_range_actor);
-		if (ret <= 0)
-			return ret;
-
-		pos += ret;
-		len -= ret;
-	}
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= len,
+		.flags		= IOMAP_ZERO,
+	};
+	int ret;
 
-	return 0;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_zero_iter(&iter, did_zero);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_zero_range);
 
-- 
2.30.2


