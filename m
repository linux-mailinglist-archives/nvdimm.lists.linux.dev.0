Return-Path: <nvdimm+bounces-762-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 822FB3E3FE1
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 341D63E1439
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399842FB8;
	Mon,  9 Aug 2021 06:25:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104F17F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=apzfbAVQKWbGrKYMT3DIf/EpeYrpBdh35Pn+VTLrfXQ=; b=NcZFD3NNNPGQlPbrjZG1a1dc4G
	x3FGFiNiWHX5318wEvkztp4HGFYFdPDHODJ7nuVObRZNU47m8v7/U8FJ8WxM7yXsAZ/gteG6hd7Rv
	tQ9tzDFQ47cTVGGTZwZPmWSBOnr06RVmZXZ+GslaKRVK3YujwF7s4qcpqEKtCjJHSwp0h9Txkc/RQ
	Dn+r7GZ9JYGV1L5BAujplk8mlvGcnItTOtgmaMqycuvQn14GJovJ6fKwgIwR7ryugG0J4fS53H7MX
	CcJ0NTOZ7wcrnNOT9feUxU58AyuNR+9T8aT7KNZRAsul/M+uBcQIHNkLEB5ZeR2XsA2bfi+ikVTu1
	5iso1S7A==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyhG-00AhAq-Mc; Mon, 09 Aug 2021 06:23:52 +0000
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
Subject: [PATCH 14/30] iomap: switch iomap_file_unshare to use iomap_iter
Date: Mon,  9 Aug 2021 08:12:28 +0200
Message-Id: <20210809061244.1196573-15-hch@lst.de>
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

Switch iomap_file_unshare to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4c7e82928cc546..4f525727462f33 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -817,10 +817,12 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
-static loff_t
-iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap, struct iomap *srcmap)
+static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
+	struct iomap *iomap = &iter->iomap;
+	struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
 	long status = 0;
 	loff_t written = 0;
 
@@ -836,12 +838,12 @@ iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		unsigned long bytes = min_t(loff_t, PAGE_SIZE - offset, length);
 		struct page *page;
 
-		status = iomap_write_begin(inode, pos, bytes,
+		status = iomap_write_begin(iter->inode, pos, bytes,
 				IOMAP_WRITE_F_UNSHARE, &page, iomap, srcmap);
 		if (unlikely(status))
 			return status;
 
-		status = iomap_write_end(inode, pos, bytes, bytes, page, iomap,
+		status = iomap_write_end(iter->inode, pos, bytes, bytes, page, iomap,
 				srcmap);
 		if (WARN_ON_ONCE(status == 0))
 			return -EIO;
@@ -852,7 +854,7 @@ iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		written += status;
 		length -= status;
 
-		balance_dirty_pages_ratelimited(inode->i_mapping);
+		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
 	} while (length);
 
 	return written;
@@ -862,18 +864,17 @@ int
 iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops)
 {
-	loff_t ret;
-
-	while (len) {
-		ret = iomap_apply(inode, pos, len, IOMAP_WRITE, ops, NULL,
-				iomap_unshare_actor);
-		if (ret <= 0)
-			return ret;
-		pos += ret;
-		len -= ret;
-	}
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= len,
+		.flags		= IOMAP_WRITE,
+	};
+	int ret;
 
-	return 0;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_unshare_iter(&iter);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_file_unshare);
 
-- 
2.30.2


