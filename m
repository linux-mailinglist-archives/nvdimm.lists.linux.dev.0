Return-Path: <nvdimm+bounces-546-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EFB3CD242
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 86A1B1C0F3B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678022FB8;
	Mon, 19 Jul 2021 10:53:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713272FB0
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=mfDC9AyIOq9CpDiYSEkbApVrpp8Ee9nE0KGnM0t7tyg=; b=HlXHGWMxc7XLDLqKRRlQF8gQEj
	XNtbkq4LAO0DRORvkBy7b4fLHZSinDG6Tfl4vJVUtJtcdiavWHFAo9oOwG0mVthjL2XkP0H4454Uz
	M/7/XfBeiiIl8ViJSWi0i3olRiruiDzegBLegr8e6KEqCDcMb3vp6rMlRq/gQDsRjw6FAcjFK51Q+
	KNlIIzIkqZuUJPAAaGub+Nv3L6cde+enBozOX+liGMfucs+X9RBgrZVO8cVhu2GdCKhob7b8vzWUv
	tIJ07f+RR083SVsTg9cYvPYgeg80rYhkWJQGCBTzU1kkD3kwnHguATPPW3aDwMi/I/eo91vBdKekL
	3Z5+6p0A==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5QrJ-006lWj-Rf; Mon, 19 Jul 2021 10:51:01 +0000
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
Subject: [PATCH 13/27] iomap: switch iomap_page_mkwrite to use iomap_iter
Date: Mon, 19 Jul 2021 12:35:06 +0200
Message-Id: <20210719103520.495450-14-hch@lst.de>
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

Switch iomap_page_mkwrite to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e5832ffb413cb6..c273b5d88dd8a8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -950,15 +950,15 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 }
 EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
-static loff_t
-iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap, struct iomap *srcmap)
+static loff_t iomap_page_mkwrite_iter(struct iomap_iter *iter,
+		struct page *page)
 {
-	struct page *page = data;
+	loff_t length = iomap_length(iter);
 	int ret;
 
-	if (iomap->flags & IOMAP_F_BUFFER_HEAD) {
-		ret = __block_write_begin_int(page, pos, length, NULL, iomap);
+	if (iter->iomap.flags & IOMAP_F_BUFFER_HEAD) {
+		ret = __block_write_begin_int(page, iter->pos, length, NULL,
+					      &iter->iomap);
 		if (ret)
 			return ret;
 		block_commit_write(page, 0, length);
@@ -972,29 +972,24 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 
 vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 {
+	struct iomap_iter iter = {
+		.inode		= file_inode(vmf->vma->vm_file),
+		.flags		= IOMAP_WRITE | IOMAP_FAULT,
+	};
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vmf->vma->vm_file);
-	unsigned long length;
-	loff_t offset;
 	ssize_t ret;
 
 	lock_page(page);
-	ret = page_mkwrite_check_truncate(page, inode);
+	ret = page_mkwrite_check_truncate(page, iter.inode);
 	if (ret < 0)
 		goto out_unlock;
-	length = ret;
-
-	offset = page_offset(page);
-	while (length > 0) {
-		ret = iomap_apply(inode, offset, length,
-				IOMAP_WRITE | IOMAP_FAULT, ops, page,
-				iomap_page_mkwrite_actor);
-		if (unlikely(ret <= 0))
-			goto out_unlock;
-		offset += ret;
-		length -= ret;
-	}
+	iter.pos = page_offset(page);
+	iter.len = ret;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_page_mkwrite_iter(&iter, page);
 
+	if (ret < 0)
+		goto out_unlock;
 	wait_for_stable_page(page);
 	return VM_FAULT_LOCKED;
 out_unlock:
-- 
2.30.2


