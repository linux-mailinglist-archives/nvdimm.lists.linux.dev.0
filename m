Return-Path: <nvdimm+bounces-37-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5112338BE8D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 170373E104A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9832BB2;
	Fri, 21 May 2021 05:52:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B902BA4
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HdmvgJROhl6kPeDfaduRB36OpJcd6Ty0AlrUBeid1ug=; b=k/Bn+FBfFbzw80Zi1xhWGbDnkG
	TjN1P3AO/oLHSNhl+yzfe2D6kzIxe7qb0Dm4s5MiZoMZV0dc49LFhmLihpiJZ3pfOYG5F8P6F3IYW
	d9IUViwvD/rska5r9G7s1x2xMn2SEnXTDStsJq8bIkEUSdMY8F61fpo9tG+UKEPT9zOQJxoLhokkh
	dk+OJ2HRBg7Akbzy+9HJR5885BMqLRFl6cOzhqaSN5QiqmviCOLF/or/HZR4MjNqQL5xUhjtB2/Mr
	FW7Ad7lrU+Da0o+zUn+9VmFXuSBpzhX9zv+bTABlNcvqf3MwmCQWylTB/S1Lp2r54ft/KeYZsRlYi
	wSRrRNYw==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4c-00Gq0B-11; Fri, 21 May 2021 05:51:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>,
	Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>,
	Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-block@vger.kernel.org,
	dm-devel@redhat.com,
	linux-m68k@lists.linux-m68k.org,
	linux-xtensa@linux-xtensa.org,
	drbd-dev@lists.linbit.com,
	linuxppc-dev@lists.ozlabs.org,
	linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [PATCH 10/26] zram: convert to blk_alloc_disk/blk_cleanup_disk
Date: Fri, 21 May 2021 07:51:00 +0200
Message-Id: <20210521055116.1053587-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Convert the zram driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index cf8deecc39ef..006416cc4969 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1890,7 +1890,6 @@ static const struct attribute_group *zram_disk_attr_groups[] = {
 static int zram_add(void)
 {
 	struct zram *zram;
-	struct request_queue *queue;
 	int ret, device_id;
 
 	zram = kzalloc(sizeof(struct zram), GFP_KERNEL);
@@ -1906,27 +1905,20 @@ static int zram_add(void)
 #ifdef CONFIG_ZRAM_WRITEBACK
 	spin_lock_init(&zram->wb_limit_lock);
 #endif
-	queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!queue) {
-		pr_err("Error allocating disk queue for device %d\n",
-			device_id);
-		ret = -ENOMEM;
-		goto out_free_idr;
-	}
 
 	/* gendisk structure */
-	zram->disk = alloc_disk(1);
+	zram->disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!zram->disk) {
 		pr_err("Error allocating disk structure for device %d\n",
 			device_id);
 		ret = -ENOMEM;
-		goto out_free_queue;
+		goto out_free_idr;
 	}
 
 	zram->disk->major = zram_major;
 	zram->disk->first_minor = device_id;
+	zram->disk->minors = 1;
 	zram->disk->fops = &zram_devops;
-	zram->disk->queue = queue;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
@@ -1969,8 +1961,6 @@ static int zram_add(void)
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
 
-out_free_queue:
-	blk_cleanup_queue(queue);
 out_free_idr:
 	idr_remove(&zram_index_idr, device_id);
 out_free_dev:
@@ -2000,8 +1990,7 @@ static int zram_remove(struct zram *zram)
 	pr_info("Removed device: %s\n", zram->disk->disk_name);
 
 	del_gendisk(zram->disk);
-	blk_cleanup_queue(zram->disk->queue);
-	put_disk(zram->disk);
+	blk_cleanup_disk(zram->disk);
 	kfree(zram);
 	return 0;
 }
-- 
2.30.2


