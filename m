Return-Path: <nvdimm+bounces-551-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C1A3CD250
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 5B1E01C0F5B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3426D10;
	Mon, 19 Jul 2021 10:58:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E556D00
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=L2dn47BW8cimA4OGCXzIvd0BRf0hak7es3Cdvb274Qs=; b=nHomzFZHdFHlfMS42qKgf9Udd/
	iBRpU4ViMMrrYu6MndRcg1H9xxzCxUZjNH6NVD1jBw1GzvGITB3lRolwAfaUkrmCaI6RmXSIo/Dko
	F/b0tKH3d6Pf+YxoZIqZ4EWuu/YzmCbrbDtaMowj5VLV9BmcMaAwgwXtoFpZ/FtoyfCAdaM1PVL0j
	3JfqIrwdne/VIpctpcGxGIrnLiEfHUhFWTs/cgplteOEgKQNnWCtPWy8I3zSYxJmGPFP1EqwOGIEc
	DEk9+NmCUULUId4XsWQfp8Y1WHOl6CaWtKRO6AI1ZqZ1rF/pRDbvxXlSTRaT5P3RR59Gw3MgzYaLx
	wmvwJzxQ==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5Qwj-006m1S-EQ; Mon, 19 Jul 2021 10:56:50 +0000
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
Subject: [PATCH 18/27] iomap: switch iomap_seek_data to use iomap_iter
Date: Mon, 19 Jul 2021 12:35:11 +0200
Message-Id: <20210719103520.495450-19-hch@lst.de>
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

Rewrite iomap_seek_data to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/seek.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index 7d6ed9af925e96..0a758e3851fcb7 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -55,23 +55,21 @@ iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_seek_hole);
 
-static loff_t
-iomap_seek_data_actor(struct inode *inode, loff_t start, loff_t length,
-		      void *data, struct iomap *iomap, struct iomap *srcmap)
+static loff_t iomap_seek_data_iter(const struct iomap_iter *iter, loff_t *pos)
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
+		*pos = mapping_seek_hole_data(iter->inode->i_mapping,
+				iter->pos, iter->pos + length, SEEK_DATA);
+		if (*pos < 0)
 			return length;
-		fallthrough;
+		return 0;
 	default:
-		*(loff_t *)data = offset;
+		*pos = iter->pos;
 		return 0;
 	}
 }
@@ -80,22 +78,24 @@ loff_t
 iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 {
 	loff_t size = i_size_read(inode);
-	loff_t ret;
+	struct iomap_iter iter = {
+		.inode	= inode,
+		.pos	= offset,
+		.flags	= IOMAP_REPORT,
+	};
+	int ret;
 
 	/* Nothing to be found before or beyond the end of the file. */
 	if (offset < 0 || offset >= size)
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
+	iter.len = size - offset;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_seek_data_iter(&iter, &offset);
+	if (ret < 0)
+		return ret;
+	if (iter.len)
+		return offset;
 	/* We've reached the end of the file without finding data */
 	return -ENXIO;
 }
-- 
2.30.2


