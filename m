Return-Path: <nvdimm+bounces-768-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FFBA3E4005
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 78A061C0619
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308732FB9;
	Mon,  9 Aug 2021 06:31:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7373D177
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rr1TBrtAW6uK814JxOdxbEPDzzGpS5RSnuJuhzD7kuk=; b=WrWuKLLraKlp1EPyVGo4sc70t5
	UrmkLSVv28yXMR9XnM1w35b5jICQ3P9KG6BCnf+f8bKdMzAmAA6tcSpRjzE7vdDmTRvYhk7AuOa9A
	mv7wgjMqgSOc7o3Sn39gCQRPsC0f6txYNZ4gyxCtpBu6K7vm4CRTuG7bO97b6LHxHK2CRBEyhkS0J
	sFHQNM6ZRp8W3CC4Kmq6I0AyK1VxrxpQpbqiAfPyPlsOtWS8Mm+E+uJlfygv0GNEgQ4ZmHtv0e0Th
	TaXVNsV+BFSoVJfhtjMriGJ1zC8HztHZUyYQeqohvlEyWrQOtwQ9js3J1UaE2KWnXvUUtvmDMTFo0
	ZMDFhCAw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCym6-00AhWa-Rp; Mon, 09 Aug 2021 06:28:58 +0000
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
Subject: [PATCH 20/30] iomap: switch iomap_seek_hole to use iomap_iter
Date: Mon,  9 Aug 2021 08:12:34 +0200
Message-Id: <20210809061244.1196573-21-hch@lst.de>
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

Rewrite iomap_seek_hole to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/seek.c | 51 +++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index ce6fb810854fec..fed8f9005f9e46 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Red Hat, Inc.
- * Copyright (c) 2018 Christoph Hellwig.
+ * Copyright (c) 2018-2021 Christoph Hellwig.
  */
 #include <linux/module.h>
 #include <linux/compiler.h>
@@ -10,21 +10,20 @@
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
 
-static loff_t
-iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
-		      void *data, struct iomap *iomap, struct iomap *srcmap)
+static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter,
+		loff_t *hole_pos)
 {
-	loff_t offset = start;
+	loff_t length = iomap_length(iter);
 
-	switch (iomap->type) {
+	switch (iter->iomap.type) {
 	case IOMAP_UNWRITTEN:
-		offset = mapping_seek_hole_data(inode->i_mapping, start,
-				start + length, SEEK_HOLE);
-		if (offset == start + length)
+		*hole_pos = mapping_seek_hole_data(iter->inode->i_mapping,
+				iter->pos, iter->pos + length, SEEK_HOLE);
+		if (*hole_pos == iter->pos + length)
 			return length;
-		fallthrough;
+		return 0;
 	case IOMAP_HOLE:
-		*(loff_t *)data = offset;
+		*hole_pos = iter->pos;
 		return 0;
 	default:
 		return length;
@@ -32,26 +31,28 @@ iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
 }
 
 loff_t
-iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
+iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
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
-				  ops, &offset, iomap_seek_hole_actor);
-		if (ret < 0)
-			return ret;
-		if (ret == 0)
-			break;
-		offset += ret;
-	}
-
-	return offset;
+	iter.len = size - pos;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_seek_hole_iter(&iter, &pos);
+	if (ret < 0)
+		return ret;
+	if (iter.len) /* found hole before EOF */
+		return pos;
+	return size;
 }
 EXPORT_SYMBOL_GPL(iomap_seek_hole);
 
-- 
2.30.2


