Return-Path: <nvdimm+bounces-8150-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0964D8FFBB9
	for <lists+linux-nvdimm@lfdr.de>; Fri,  7 Jun 2024 08:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B13F61F26411
	for <lists+linux-nvdimm@lfdr.de>; Fri,  7 Jun 2024 06:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1006715532A;
	Fri,  7 Jun 2024 05:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G9NdkSv2"
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D62F152182;
	Fri,  7 Jun 2024 05:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739994; cv=none; b=iwlMpWzTf8s8yyw8+2v+YTGtSjb5MvFPBthfDjZ+ONbUwr15wRW8uSvr0XAb0z5PiSe1gpYuKkEsHJNCq/+uvjt/ucTq2SCK2PFwHDvsEE/Exb06XD61KO4/dIaD7SVxFV1uXV2UyfCIYObS9CPZ7k7nrsJc+s1mYQrBqDhBZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739994; c=relaxed/simple;
	bh=9VkfGm/prDrXCDi1Zi26dI4VcSrOdga/GR1RZxs5Eb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0V/tWAT9//OLW2QamB8SOjQlQWyRZnbmP44eK0hh7Z/yruXj1dw7u3T6dcO7IdFVELUEqpHC7wBAM9KnTe89650i36ZVHSfL4ACxBF4gV9B7fNBtKlXWKf/2k0vTKtM3pxcajNm1CuDgnxj3gT1kYd4qRvnfudwloLrtI5BeGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G9NdkSv2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wIPo+VgXRJHic7p9pJeYefhTVAruq/pQ/ZFXFjpKKUE=; b=G9NdkSv2UOghXocefUux7wlYDM
	NQmRXvPG/qh+OP/PBg/BgSEFitjyG+DnNVHcBNXdjBmIZV+ZrYgnETbyjMNNCRzSVduwLFIVXbCS+
	MuBLx0EnBKPgoH2U+9mJG0K4r3ZuWWV/mrRAPrUmPVqhrbDpgKI260LYMZ7UuuYp3sc/KRM3sJn/h
	+lWeoCwSpp4DfO8lg5gI5StMW/unAmE5yWor19ruWyR67yG/qbAXeBZFfr/L2EyE3dGorYdlGTw13
	p48KrbMColrOGpUzkx8zA3dXqaSodwvj69HROj1vJX9vvnTfrakGoKLbWC8nTUIZg9rdsvpg51dcY
	kXpFsA1w==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSdg-0000000Ca9C-2EF9;
	Fri, 07 Jun 2024 05:59:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 09/11] block: bypass the STABLE_WRITES flag for protection information
Date: Fri,  7 Jun 2024 07:59:03 +0200
Message-ID: <20240607055912.3586772-10-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240607055912.3586772-1-hch@lst.de>
References: <20240607055912.3586772-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently registering a checksum-enabled (aka PI) integrity profile sets
the QUEUE_FLAG_STABLE_WRITE flag, and unregistering it clears the flag.
This can incorrectly clear the flag when the driver requires stable
writes even without PI, e.g. in case of iSCSI or NVMe/TCP with data
digest enabled.

Fix this by looking at the csum_type directly in bdev_stable_writes and
not setting the queue flag.  Also remove the blk_queue_stable_writes
helper as the only user in nvme wants to only look at the actual
QUEUE_FLAG_STABLE_WRITE flag as it inherits the integrity configuration
by other means.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c         |  6 ------
 drivers/nvme/host/multipath.c |  3 ++-
 include/linux/blkdev.h        | 12 ++++++++----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 1d2d371cd632d3..bec0d1df387ce9 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -379,9 +379,6 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tag_size = template->tag_size;
 	bi->pi_offset = template->pi_offset;
 
-	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
-		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
-
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	if (disk->queue->crypto_profile) {
 		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
@@ -404,9 +401,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	if (!bi->tuple_size)
 		return;
-
-	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
-		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d8b6b4648eaff9..12c59db02539e5 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -875,7 +875,8 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 		nvme_mpath_set_live(ns);
 	}
 
-	if (blk_queue_stable_writes(ns->queue) && ns->head->disk)
+	if (test_bit(QUEUE_FLAG_STABLE_WRITES, &ns->queue->queue_flags) &&
+	    ns->head->disk)
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES,
 				   ns->head->disk->queue);
 #ifdef CONFIG_BLK_DEV_ZONED
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bdd33388e1ced8..f9089750919c6b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -571,8 +571,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
-#define blk_queue_stable_writes(q) \
-	test_bit(QUEUE_FLAG_STABLE_WRITES, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_zone_resetall(q)	\
@@ -1300,8 +1298,14 @@ static inline bool bdev_synchronous(struct block_device *bdev)
 
 static inline bool bdev_stable_writes(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_STABLE_WRITES,
-			&bdev_get_queue(bdev)->queue_flags);
+	struct request_queue *q = bdev_get_queue(bdev);
+
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	/* BLK_INTEGRITY_CSUM_NONE is not available in blkdev.h */
+	if (q->integrity.csum_type != 0)
+		return true;
+#endif
+	return test_bit(QUEUE_FLAG_STABLE_WRITES, &q->queue_flags);
 }
 
 static inline bool bdev_write_cache(struct block_device *bdev)
-- 
2.43.0


