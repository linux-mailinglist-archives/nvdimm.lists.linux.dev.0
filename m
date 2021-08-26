Return-Path: <nvdimm+bounces-1035-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC223F89CC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 16:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1BE3F1C0F93
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 14:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0A93FCC;
	Thu, 26 Aug 2021 14:08:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700D3FC8
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rSq1NSY3tDLMhc9/zg8drVX4eFZRs7BxvgldfW0phO0=; b=YpTNAz439ehJKUlInhKW0g4mvC
	JSzP6Su3qNNirE48Ni+dmxPJdQK99QIfPvnh0iq3EaW2C8V5kHaeN5CSpigXlqEtq/PU0oBZsqSdi
	hE0RA9qjAK3QQHbnOtCU5QUV1TsuL3+lIilnwQ7gzuLko1Y3yxoIl7grcUzSQ4cILpBvI/zysalun
	b9xRd97ZOJepqhbedJyAkiXTQisclO90qjDaqRfO0UXgsrqHFXOOIfE6RZBK38P6d+z2eCT8anoSY
	vf69MPCZhmHsfQwqLaAB3peTDiALLlQBmt2a/noMX7/8DsvpVoly/j0H2phcPuiRCLvCgkUZDWsr7
	OL2X5x2g==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJG0F-00DMd4-RO; Thu, 26 Aug 2021 14:05:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 9/9] dax: remove bdev_dax_supported
Date: Thu, 26 Aug 2021 15:55:10 +0200
Message-Id: <20210826135510.6293-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826135510.6293-1-hch@lst.de>
References: <20210826135510.6293-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

All callers already have a dax_device obtained from fs_dax_get_by_bdev
at hand, so just pass that to dax_supported() insted of doing another
lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c | 42 +-----------------------------------------
 fs/ext2/super.c     |  3 ++-
 fs/ext4/super.c     |  3 ++-
 fs/xfs/xfs_super.c  |  3 ++-
 include/linux/dax.h | 12 ------------
 5 files changed, 7 insertions(+), 56 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index eed02729add3..fc89e91beea7 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -220,47 +220,7 @@ bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(dax_supported);
 #endif /* CONFIG_FS_DAX */
-
-/**
- * __bdev_dax_supported() - Check if the device supports dax for filesystem
- * @bdev: block device to check
- * @blocksize: The block size of the device
- *
- * This is a library function for filesystems to check if the block device
- * can be mounted with dax option.
- *
- * Return: true if supported, false if unsupported
- */
-bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
-{
-	struct dax_device *dax_dev;
-	struct request_queue *q;
-	char buf[BDEVNAME_SIZE];
-	bool ret;
-
-	q = bdev_get_queue(bdev);
-	if (!q || !blk_queue_dax(q)) {
-		pr_debug("%s: error: request queue doesn't support dax\n",
-				bdevname(bdev, buf));
-		return false;
-	}
-
-	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
-	if (!dax_dev) {
-		pr_debug("%s: error: device does not support dax\n",
-				bdevname(bdev, buf));
-		return false;
-	}
-
-	ret = dax_supported(dax_dev, bdev, blocksize, 0,
-			i_size_read(bdev->bd_inode) / 512);
-
-	put_dax(dax_dev);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(__bdev_dax_supported);
-#endif
+#endif /* CONFIG_BLOCK */
 
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 21e09fbaa46f..26e69e48d7e0 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -949,7 +949,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (test_opt(sb, DAX)) {
-		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
+		if (!dax_supported(dax_dev, sb->s_bdev, blocksize, 0,
+				bdev_nr_sectors(sb->s_bdev))) {
 			ext2_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
 			clear_opt(sbi->s_mount_opt, DAX);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dfa09a277b56..a1726a8debce 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4435,7 +4435,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	if (bdev_dax_supported(sb->s_bdev, blocksize))
+	if (dax_supported(dax_dev, sb->s_bdev, blocksize, 0,
+			bdev_nr_sectors(sb->s_bdev)))
 		set_bit(EXT4_FLAGS_BDEV_IS_DAX, &sbi->s_ext4_flags);
 
 	if (sbi->s_mount_opt & EXT4_MOUNT_DAX_ALWAYS) {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a89bf601d97..f4384974e52a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -319,7 +319,8 @@ xfs_buftarg_is_dax(
 	struct super_block	*sb,
 	struct xfs_buftarg	*bt)
 {
-	return bdev_dax_supported(bt->bt_bdev, sb->s_blocksize);
+	return dax_supported(bt->bt_daxdev, bt->bt_bdev, sb->s_blocksize, 0,
+			bdev_nr_sectors(bt->bt_bdev));
 }
 
 STATIC int
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 32dce5763f2c..2619d94c308d 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -109,12 +109,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 struct writeback_control;
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
-bool __bdev_dax_supported(struct block_device *bdev, int blocksize);
-static inline bool bdev_dax_supported(struct block_device *bdev, int blocksize)
-{
-	return __bdev_dax_supported(bdev, blocksize);
-}
-
 bool generic_fsdax_supported(struct dax_device *dax_dev,
 		struct block_device *bdev, int blocksize, sector_t start,
 		sector_t sectors);
@@ -136,12 +130,6 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t st
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
 #else
-static inline bool bdev_dax_supported(struct block_device *bdev,
-		int blocksize)
-{
-	return false;
-}
-
 #define generic_fsdax_supported		NULL
 
 static inline bool dax_supported(struct dax_device *dax_dev,
-- 
2.30.2


