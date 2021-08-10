Return-Path: <nvdimm+bounces-774-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 186493E4034
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E02F03E1468
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2242FB9;
	Mon,  9 Aug 2021 06:37:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36383177
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5GeLbZw0Yv1lQLd3rAhgAT1DbZZKRB8/pKmJLH8S+KQ=; b=bs/QxkDxhZQQpdXtyEQfieWBoB
	3aEC1Q+8T4OgI9zYNEw6b9baGQiiPD67NBCcw7iaERn+PaGn3+Izuv9t+P++BAUL1p05EIEggtYFc
	qU602tI7E6fwx9SDsvTzGMcLew4WNXpA49RcykmkroWElAI2CiE1qeqrYX/rq2iFI56mpXAAy4tes
	qyIeLuPbYhuLAuceHBSFjhBSTD/qYuq70akVQi33SZPmRhkD66mxDlqGGKUBEP0vF5t2fg/g8Brfg
	guFUwWBlUB0EWrx3HvMQRpDu1O6LNsP+etJhqxhL5wgTeEg7PX01+XLFDEemsGm6f/HYyGmBicjrx
	oYWRXouQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyrd-00AhzV-Fc; Mon, 09 Aug 2021 06:34:38 +0000
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
Subject: [PATCH 26/30] iomap: rework unshare flag
Date: Mon,  9 Aug 2021 08:12:40 +0200
Message-Id: <20210809061244.1196573-27-hch@lst.de>
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

Instead of another internal flags namespace inside of buffered-io.c,
just pass a UNSHARE hint in the main iomap flags field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 23 +++++++++--------------
 include/linux/iomap.h  |  1 +
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index cfeec6b0ed2293..ef902cc89accca 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -508,10 +508,6 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
 EXPORT_SYMBOL_GPL(iomap_migrate_page);
 #endif /* CONFIG_MIGRATION */
 
-enum {
-	IOMAP_WRITE_F_UNSHARE		= (1 << 0),
-};
-
 static void
 iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 {
@@ -541,7 +537,7 @@ iomap_read_page_sync(loff_t block_start, struct page *page, unsigned poff,
 }
 
 static int __iomap_write_begin(struct iomap_iter *iter, loff_t pos,
-		unsigned len, int flags, struct page *page)
+		unsigned len, struct page *page)
 {
 	struct iomap *srcmap = iomap_iter_srcmap(iter);
 	struct iomap_page *iop = iomap_page_create(iter->inode, page);
@@ -560,13 +556,13 @@ static int __iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 		if (plen == 0)
 			break;
 
-		if (!(flags & IOMAP_WRITE_F_UNSHARE) &&
+		if (!(iter->flags & IOMAP_UNSHARE) &&
 		    (from <= poff || from >= poff + plen) &&
 		    (to <= poff || to >= poff + plen))
 			continue;
 
 		if (iomap_block_needs_zeroing(iter, block_start)) {
-			if (WARN_ON_ONCE(flags & IOMAP_WRITE_F_UNSHARE))
+			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
 			zero_user_segments(page, poff, from, to, poff + plen);
 		} else {
@@ -596,7 +592,7 @@ static int iomap_write_begin_inline(struct iomap_iter *iter,
 }
 
 static int iomap_write_begin(struct iomap_iter *iter, loff_t pos, unsigned len,
-		unsigned flags, struct page **pagep)
+		struct page **pagep)
 {
 	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
 	struct iomap *srcmap = iomap_iter_srcmap(iter);
@@ -628,7 +624,7 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos, unsigned len,
 	else if (srcmap->flags & IOMAP_F_BUFFER_HEAD)
 		status = __block_write_begin_int(page, pos, len, NULL, srcmap);
 	else
-		status = __iomap_write_begin(iter, pos, len, flags, page);
+		status = __iomap_write_begin(iter, pos, len, page);
 
 	if (unlikely(status))
 		goto out_unlock;
@@ -759,7 +755,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			break;
 		}
 
-		status = iomap_write_begin(iter, pos, bytes, 0, &page);
+		status = iomap_write_begin(iter, pos, bytes, &page);
 		if (unlikely(status))
 			break;
 
@@ -836,8 +832,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		unsigned long bytes = min_t(loff_t, PAGE_SIZE - offset, length);
 		struct page *page;
 
-		status = iomap_write_begin(iter, pos, bytes,
-				IOMAP_WRITE_F_UNSHARE, &page);
+		status = iomap_write_begin(iter, pos, bytes, &page);
 		if (unlikely(status))
 			return status;
 
@@ -865,7 +860,7 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		.inode		= inode,
 		.pos		= pos,
 		.len		= len,
-		.flags		= IOMAP_WRITE,
+		.flags		= IOMAP_WRITE | IOMAP_UNSHARE,
 	};
 	int ret;
 
@@ -882,7 +877,7 @@ static s64 __iomap_zero_iter(struct iomap_iter *iter, loff_t pos, u64 length)
 	unsigned offset = offset_in_page(pos);
 	unsigned bytes = min_t(u64, PAGE_SIZE - offset, length);
 
-	status = iomap_write_begin(iter, pos, bytes, 0, &page);
+	status = iomap_write_begin(iter, pos, bytes, &page);
 	if (status)
 		return status;
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 6784a8b6471449..f53c40e9d799fb 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -140,6 +140,7 @@ struct iomap_page_ops {
 #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
 #define IOMAP_NOWAIT		(1 << 5) /* do not block */
 #define IOMAP_OVERWRITE_ONLY	(1 << 6) /* only pure overwrites allowed */
+#define IOMAP_UNSHARE		(1 << 7) /* unshare_file_range */
 
 struct iomap_ops {
 	/*
-- 
2.30.2


