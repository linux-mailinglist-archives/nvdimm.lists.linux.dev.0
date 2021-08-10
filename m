Return-Path: <nvdimm+bounces-769-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id D25A93E400F
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F3C8B1C09FE
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9602FB9;
	Mon,  9 Aug 2021 06:31:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8054177
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HqL4dtQBlH8r6XqvjdbNTjPZJFfVuAPYGFgDwuehvTk=; b=KwrH912KmcDa7SaL/mMA1QAp02
	snbcEUyXVl/3hAinxA5L8GyXI66lZuHGGHfx2aDqPiZfnQnS2CVaPCkrPlUb7DYAvvLI/hcsGLQ7g
	S9isFFS3KRsYumTOPUmIm1x/n4fAHPXtGXDjoVNvcpLCByIH9vYihrY/xypQJjaG4nnLpKOHcQQdU
	lrqFLRTDWpCLWiuZk40Hn8zdjvT7uMf7wbCkdSKbxYqp2pZZGQw+NCDdyxZpm1uOpIo8HxVcP3X5d
	xpOVclfp1mdUCnTJM17VHk+806cTq0EaFcDM6/ZZ8Mw43p/YL8O2yLLRJeAzqWam2NAbk6/Mgp99Q
	8/Wv6NJw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyn8-00Aha5-C5; Mon, 09 Aug 2021 06:30:01 +0000
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
Subject: [PATCH 21/30] iomap: switch iomap_seek_data to use iomap_iter
Date: Mon,  9 Aug 2021 08:12:35 +0200
Message-Id: <20210809061244.1196573-22-hch@lst.de>
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

Rewrite iomap_seek_data to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/seek.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index fed8f9005f9e46..a845c012b50c67 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -56,47 +56,48 @@ iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_seek_hole);
 
-static loff_t
-iomap_seek_data_actor(struct inode *inode, loff_t start, loff_t length,
-		      void *data, struct iomap *iomap, struct iomap *srcmap)
+static loff_t iomap_seek_data_iter(const struct iomap_iter *iter,
+		loff_t *hole_pos)
 {
-	loff_t offset = start;
+	loff_t length = iomap_length(iter);
 
-	switch (iomap->type) {
+	switch (iter->iomap.type) {
 	case IOMAP_HOLE:
 		return length;
 	case IOMAP_UNWRITTEN:
-		offset = mapping_seek_hole_data(inode->i_mapping, start,
-				start + length, SEEK_DATA);
-		if (offset < 0)
+		*hole_pos = mapping_seek_hole_data(iter->inode->i_mapping,
+				iter->pos, iter->pos + length, SEEK_DATA);
+		if (*hole_pos < 0)
 			return length;
-		fallthrough;
+		return 0;
 	default:
-		*(loff_t *)data = offset;
+		*hole_pos = iter->pos;
 		return 0;
 	}
 }
 
 loff_t
-iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
+iomap_seek_data(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
 {
 	loff_t size = i_size_read(inode);
-	loff_t ret;
+	struct iomap_iter iter = {
+		.inode	= inode,
+		.pos	= pos,
+		.flags	= IOMAP_REPORT,
+	};
+	int ret;
 
 	/* Nothing to be found before or beyond the end of the file. */
-	if (offset < 0 || offset >= size)
+	if (pos < 0 || pos >= size)
 		return -ENXIO;
 
-	while (offset < size) {
-		ret = iomap_apply(inode, offset, size - offset, IOMAP_REPORT,
-				  ops, &offset, iomap_seek_data_actor);
-		if (ret < 0)
-			return ret;
-		if (ret == 0)
-			return offset;
-		offset += ret;
-	}
-
+	iter.len = size - pos;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_seek_data_iter(&iter, &pos);
+	if (ret < 0)
+		return ret;
+	if (iter.len) /* found data before EOF */
+		return pos;
 	/* We've reached the end of the file without finding data */
 	return -ENXIO;
 }
-- 
2.30.2


