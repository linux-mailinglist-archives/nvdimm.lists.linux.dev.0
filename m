Return-Path: <nvdimm+bounces-545-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD5D3CD23F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 34DFD1C0DF6
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E377C2FB6;
	Mon, 19 Jul 2021 10:52:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA1F29D6
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Hvw30GJ0evzuhY4uOcydQGq4CnCpbv168ctwEXBAMa8=; b=OzLt7+8QxKnaWa9kXqH2SHZzw+
	cA9FAAKFo9qd7tFotPAkq6BVXtegxLInJAJut1HmzWdgECwWcp68LeFdDjzQlzOmak1vihKI/4ZeN
	Y8B6mFIEEEkZJmYp7FWTussjIlF5mFZ0tYYxcGq1Q+AK7l2jkr5HWR87VlF+0F7T3/3RFOuiS9RTA
	nrPdZ7Jtj7/0n9oAeNWdXZbtuCrFg+CpfHJ3NtFVn1301iIe/v1bNxAeqMV3vmGSmTBzw6T/qbWNb
	peM+vkvVILA0ZSLszjsgRhHG+AdiAoODtD3CY52UDywVo0hltpImyF/i1od6qJPbtj/Xo/ibtCRel
	SwQrRO+Q==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5QqE-006lPa-Sw; Mon, 19 Jul 2021 10:49:59 +0000
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
Subject: [PATCH 12/27] iomap: switch iomap_zero_range to use iomap_iter
Date: Mon, 19 Jul 2021 12:35:05 +0200
Message-Id: <20210719103520.495450-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
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
index 59781c72c278e5..e5832ffb413cb6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -885,11 +885,12 @@ static s64 iomap_zero(struct inode *inode, loff_t pos, u64 length,
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
@@ -899,10 +900,11 @@ static loff_t iomap_zero_range_actor(struct inode *inode, loff_t pos,
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
 
@@ -920,19 +922,17 @@ int
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


