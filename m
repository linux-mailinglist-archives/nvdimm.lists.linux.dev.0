Return-Path: <nvdimm+bounces-6578-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D7978BD68
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Aug 2023 06:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DED151C20986
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Aug 2023 04:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFF8ED1;
	Tue, 29 Aug 2023 04:01:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FBAEC0
	for <nvdimm@lists.linux.dev>; Tue, 29 Aug 2023 04:01:21 +0000 (UTC)
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-26934bc3059so3322091a91.1
        for <nvdimm@lists.linux.dev>; Mon, 28 Aug 2023 21:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1693281681; x=1693886481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vW2xZrgOBf7/lcfCHTYPKJqiFUoci6FDNrP7hA/F5mY=;
        b=N4OjkWgHlNm2j+1sJQ/VfYSaViy1jFytlyQldIKp/1RVYyqLDfa9yHV/jsQU3l6nom
         07Xnja18i+9oKhTgew9NY6am5zPtY0ZrMNPwbn9xv/Ko26wleErRFr//r1j6kxWQrZD+
         elhQbaBTb2bWEPTgQn3v8SMtBpn+g9zI66kOZ6BmqO8K05ivfOwNmW+XgLSLzwPY2buE
         NqCUSbLHQc7hrruuE/j73gdu1OQNy7QcobHfCbFFAlcuob3B4wrPbvotw144wSOlEbH/
         vvDtZVJvU1oLwpc1w0TLiFNrE0qFzMXEM6DSDJZJnasJbGv4YLu5KUs0XMZMJQPDb0FX
         JRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693281681; x=1693886481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vW2xZrgOBf7/lcfCHTYPKJqiFUoci6FDNrP7hA/F5mY=;
        b=ZwHN2tDc9GgpFkH4x+AafX5nm3z7cuTa6ckn9cvrC5CfU3lqRg34netPL7j7SIDOVG
         BEfyyrayx8oV4mtsVWudL40pp21ISu4CborsVTS1rhygIyz0Eh5wW1Wqdy22XQtue6zK
         rNKIQD7F6NKzvY1FQ36yIu32Ykak6XKYFWk+UQ82o7U9K/sEKJ0Df3YACd1QJ8caD9Qg
         FhyYsopCFhWnCvTYE89BNj2l4vPieMmemWB6avIgBlWiDcll17wsiXxKCNAiJ6jSPt7j
         sPnpS4l5Ept0UTTwt84ClhlnkiLXsJSCEoXT28f5D3W2nVWEgZul/nYwZudu1ioDi6Gs
         PkYg==
X-Gm-Message-State: AOJu0YxoAUr3ug6QOOM5PCLxmD0oHfgcfu6QqGSpqVm9fH+RbudS65qX
	5TT/bidYOYwlXBSv68Rhw+MfJA==
X-Google-Smtp-Source: AGHT+IGWoGnsHFtszBF+Q8YxqB32W7pP7GM/+pMqWGPpzcZTlPbv9SDSMuD+nBTjjNKxZd3XIUYTZg==
X-Received: by 2002:a17:90a:e2ce:b0:269:3757:54bb with SMTP id fr14-20020a17090ae2ce00b00269375754bbmr2123024pjb.11.1693281680391;
        Mon, 28 Aug 2023 21:01:20 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([8.210.91.195])
        by smtp.googlemail.com with ESMTPSA id a6-20020a17090a008600b00268188ea4b9sm8551079pja.19.2023.08.28.21.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 21:01:20 -0700 (PDT)
From: Xueshi Hu <xueshi.hu@smartx.com>
To: hch@infradead.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	jayalk@intworks.biz,
	daniel@ffwll.ch,
	deller@gmx.de,
	bcrl@kvack.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.com,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	miklos@szeredi.hu,
	mike.kravetz@oracle.com,
	muchun.song@linux.dev,
	djwong@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	hughd@google.com
Cc: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	Xueshi Hu <xueshi.hu@smartx.com>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3] fs: clean up usage of noop_dirty_folio
Date: Tue, 29 Aug 2023 12:00:29 +0800
Message-Id: <20230829040029.473810-1-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In folio_mark_dirty(), it can automatically fallback to
noop_dirty_folio() if a_ops->dirty_folio is not registered.

In anon_aops, dev_dax_aops and fb_deferred_io_aops, replacing .dirty_folio
with NULL makes them identical to default (empty_aops) and since we never
compare ->a_ops pointer with either of those, we can remove them
completely.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
Changes in v3:
- correct the rationale of removal three empty aops
- v2: https://lore.kernel.org/linux-mm/20230828144242.GZ3390869@ZenIV/T/#t

Changes in v2:
- make noop_dirty_folio() inline as suggested by Matthew
- v1: https://lore.kernel.org/linux-mm/ZOxAfrz9etoVUfLQ@infradead.org/T/#m073d45909b1df03ff09f382557dc4e84d0607c49

 drivers/dax/device.c                |  5 -----
 drivers/video/fbdev/core/fb_defio.c |  5 -----
 fs/aio.c                            |  1 -
 fs/ext2/inode.c                     |  1 -
 fs/ext4/inode.c                     |  1 -
 fs/fuse/dax.c                       |  1 -
 fs/hugetlbfs/inode.c                |  1 -
 fs/libfs.c                          |  5 -----
 fs/xfs/xfs_aops.c                   |  1 -
 include/linux/pagemap.h             |  1 -
 mm/page-writeback.c                 | 18 +++++-------------
 mm/secretmem.c                      |  1 -
 mm/shmem.c                          |  1 -
 mm/swap_state.c                     |  1 -
 14 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 30665a3ff6ea..018aa9f88ec7 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -345,10 +345,6 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
-static const struct address_space_operations dev_dax_aops = {
-	.dirty_folio	= noop_dirty_folio,
-};
-
 static int dax_open(struct inode *inode, struct file *filp)
 {
 	struct dax_device *dax_dev = inode_dax(inode);
@@ -358,7 +354,6 @@ static int dax_open(struct inode *inode, struct file *filp)
 	dev_dbg(&dev_dax->dev, "trace\n");
 	inode->i_mapping = __dax_inode->i_mapping;
 	inode->i_mapping->host = __dax_inode;
-	inode->i_mapping->a_ops = &dev_dax_aops;
 	filp->f_mapping = inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 	filp->f_sb_err = file_sample_sb_err(filp);
diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 274f5d0fa247..08be3592281f 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -221,10 +221,6 @@ static const struct vm_operations_struct fb_deferred_io_vm_ops = {
 	.page_mkwrite	= fb_deferred_io_mkwrite,
 };
 
-static const struct address_space_operations fb_deferred_io_aops = {
-	.dirty_folio	= noop_dirty_folio,
-};
-
 int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_ops = &fb_deferred_io_vm_ops;
@@ -307,7 +303,6 @@ void fb_deferred_io_open(struct fb_info *info,
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
-	file->f_mapping->a_ops = &fb_deferred_io_aops;
 	fbdefio->open_count++;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_open);
diff --git a/fs/aio.c b/fs/aio.c
index 77e33619de40..4cf386f9cb1c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -484,7 +484,6 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 #endif
 
 static const struct address_space_operations aio_ctx_aops = {
-	.dirty_folio	= noop_dirty_folio,
 	.migrate_folio	= aio_migrate_folio,
 };
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 75983215c7a1..ce191bdf1c78 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -971,7 +971,6 @@ const struct address_space_operations ext2_aops = {
 static const struct address_space_operations ext2_dax_aops = {
 	.writepages		= ext2_dax_writepages,
 	.direct_IO		= noop_direct_IO,
-	.dirty_folio		= noop_dirty_folio,
 };
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 43775a6ca505..67c1710c01b0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3561,7 +3561,6 @@ static const struct address_space_operations ext4_da_aops = {
 static const struct address_space_operations ext4_dax_aops = {
 	.writepages		= ext4_dax_writepages,
 	.direct_IO		= noop_direct_IO,
-	.dirty_folio		= noop_dirty_folio,
 	.bmap			= ext4_bmap,
 	.swap_activate		= ext4_iomap_swap_activate,
 };
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 8e74f278a3f6..50ca767cbd5e 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1326,7 +1326,6 @@ bool fuse_dax_inode_alloc(struct super_block *sb, struct fuse_inode *fi)
 static const struct address_space_operations fuse_dax_file_aops  = {
 	.writepages	= fuse_dax_writepages,
 	.direct_IO	= noop_direct_IO,
-	.dirty_folio	= noop_dirty_folio,
 };
 
 static bool fuse_should_enable_dax(struct inode *inode, unsigned int flags)
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7b17ccfa039d..5404286f0c13 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1266,7 +1266,6 @@ static void hugetlbfs_destroy_inode(struct inode *inode)
 static const struct address_space_operations hugetlbfs_aops = {
 	.write_begin	= hugetlbfs_write_begin,
 	.write_end	= hugetlbfs_write_end,
-	.dirty_folio	= noop_dirty_folio,
 	.migrate_folio  = hugetlbfs_migrate_folio,
 	.error_remove_page	= hugetlbfs_error_remove_page,
 };
diff --git a/fs/libfs.c b/fs/libfs.c
index 5b851315eeed..982f220a9ee3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -627,7 +627,6 @@ const struct address_space_operations ram_aops = {
 	.read_folio	= simple_read_folio,
 	.write_begin	= simple_write_begin,
 	.write_end	= simple_write_end,
-	.dirty_folio	= noop_dirty_folio,
 };
 EXPORT_SYMBOL(ram_aops);
 
@@ -1231,16 +1230,12 @@ EXPORT_SYMBOL(kfree_link);
 
 struct inode *alloc_anon_inode(struct super_block *s)
 {
-	static const struct address_space_operations anon_aops = {
-		.dirty_folio	= noop_dirty_folio,
-	};
 	struct inode *inode = new_inode_pseudo(s);
 
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
 	inode->i_ino = get_next_ino();
-	inode->i_mapping->a_ops = &anon_aops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 451942fb38ec..300acea9ee63 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -590,6 +590,5 @@ const struct address_space_operations xfs_address_space_operations = {
 
 const struct address_space_operations xfs_dax_aops = {
 	.writepages		= xfs_dax_writepages,
-	.dirty_folio		= noop_dirty_folio,
 	.swap_activate		= xfs_iomap_swapfile_activate,
 };
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 716953ee1ebd..9de3be51dee2 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1074,7 +1074,6 @@ bool folio_clear_dirty_for_io(struct folio *folio);
 bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
 int __set_page_dirty_nobuffers(struct page *page);
-bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 #ifdef CONFIG_MIGRATION
 int filemap_migrate_folio(struct address_space *mapping, struct folio *dst,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d3f42009bb70..d2d739109bfe 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2585,17 +2585,6 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	return ret;
 }
 
-/*
- * For address_spaces which do not use buffers nor write back.
- */
-bool noop_dirty_folio(struct address_space *mapping, struct folio *folio)
-{
-	if (!folio_test_dirty(folio))
-		return !folio_test_set_dirty(folio);
-	return false;
-}
-EXPORT_SYMBOL(noop_dirty_folio);
-
 /*
  * Helper function for set_page_dirty family.
  *
@@ -2799,10 +2788,13 @@ bool folio_mark_dirty(struct folio *folio)
 		 */
 		if (folio_test_reclaim(folio))
 			folio_clear_reclaim(folio);
-		return mapping->a_ops->dirty_folio(mapping, folio);
+		if (mapping->a_ops->dirty_folio)
+			return mapping->a_ops->dirty_folio(mapping, folio);
 	}
 
-	return noop_dirty_folio(mapping, folio);
+	if (!folio_test_dirty(folio))
+		return !folio_test_set_dirty(folio);
+	return false;
 }
 EXPORT_SYMBOL(folio_mark_dirty);
 
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 86442a15d12f..3fe1c35f9c8d 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -157,7 +157,6 @@ static void secretmem_free_folio(struct folio *folio)
 }
 
 const struct address_space_operations secretmem_aops = {
-	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
 	.migrate_folio	= secretmem_migrate_folio,
 };
diff --git a/mm/shmem.c b/mm/shmem.c
index d963c747dabc..9bdef68a088a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4090,7 +4090,6 @@ static int shmem_error_remove_page(struct address_space *mapping,
 
 const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
-	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_TMPFS
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f8ea7015bad4..3666439487db 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -30,7 +30,6 @@
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_MIGRATION
 	.migrate_folio	= migrate_folio,
 #endif
-- 
2.40.1


