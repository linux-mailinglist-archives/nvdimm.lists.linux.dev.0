Return-Path: <nvdimm+bounces-46-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1E138BEAA
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 489D13E115F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E28C2BD6;
	Fri, 21 May 2021 05:52:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7247C2BD0
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KHHZw3fJkb5lyIBH/y6U6F8KkPbsCmVPB+g7PKF3Z6o=; b=NaUBiOvZ1MiDe2/hyhzsLhJYY2
	cwExPApTCPwU6iWE8GCK+lMo2qgBs9hT/ZNqSqjMa6S6QQeqGTsGjDc9wY94PATlgDfoA6GxwuhY+
	S/v0G7SydFsc6gjF+rymV3/sYmu3GbVhenVRTlaNyLcezNDOcvwl38gxEVk7qzYPSqPlJ9a4AXnYI
	v6e9yGZeCYldwLFqKXmb/iHJFJJTntW1nCFh6XT3cMndCj3swRnYosPplAJ1CCzERBqCd69/niB/x
	3awnmhYkCsMQKpyRu46wJM3MId9bJi5KkWqP5K4nXAs94dRvmvDNz6Y5Y2kzKArkRCv5GgAKfLUxn
	qkj6SXRg==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy54-00Gq9J-Po; Fri, 21 May 2021 05:52:19 +0000
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
Subject: [PATCH 19/26] nfblock: convert to blk_alloc_disk/blk_cleanup_disk
Date: Fri, 21 May 2021 07:51:09 +0200
Message-Id: <20210521055116.1053587-20-hch@lst.de>
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

Convert the nfblock driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/m68k/emu/nfblock.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index ba808543161a..9a8394e96388 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -55,7 +55,6 @@ struct nfhd_device {
 	int id;
 	u32 blocks, bsize;
 	int bshift;
-	struct request_queue *queue;
 	struct gendisk *disk;
 };
 
@@ -119,32 +118,24 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	dev->bsize = bsize;
 	dev->bshift = ffs(bsize) - 10;
 
-	dev->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (dev->queue == NULL)
-		goto free_dev;
-
-	blk_queue_logical_block_size(dev->queue, bsize);
-
-	dev->disk = alloc_disk(16);
+	dev->disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!dev->disk)
-		goto free_queue;
+		goto free_dev;
 
 	dev->disk->major = major_num;
 	dev->disk->first_minor = dev_id * 16;
+	dev->disk->minors = 16;
 	dev->disk->fops = &nfhd_ops;
 	dev->disk->private_data = dev;
 	sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
 	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
-	dev->disk->queue = dev->queue;
-
+	blk_queue_logical_block_size(dev->disk->queue, bsize);
 	add_disk(dev->disk);
 
 	list_add_tail(&dev->list, &nfhd_list);
 
 	return 0;
 
-free_queue:
-	blk_cleanup_queue(dev->queue);
 free_dev:
 	kfree(dev);
 out:
@@ -186,8 +177,7 @@ static void __exit nfhd_exit(void)
 	list_for_each_entry_safe(dev, next, &nfhd_list, list) {
 		list_del(&dev->list);
 		del_gendisk(dev->disk);
-		put_disk(dev->disk);
-		blk_cleanup_queue(dev->queue);
+		blk_cleanup_disk(dev->disk);
 		kfree(dev);
 	}
 	unregister_blkdev(major_num, "nfhd");
-- 
2.30.2


