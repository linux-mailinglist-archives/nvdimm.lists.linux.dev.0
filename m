Return-Path: <nvdimm+bounces-41-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F3738BEA4
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 161B01C0F10
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF592BA4;
	Fri, 21 May 2021 05:52:24 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938F2BAB
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0RRqRr3mXJO2Ltpsb28euSdgSg07f0NC5QBt8ZO/n70=; b=YcXSW1gnCLEme161Dx7XfccPf1
	zO8OQkJSl/bkHgc7eiHANqmbFDtrWLuHr+omsOGEqwToc4gQDOeCcet0ay4h9iOpnkykUp4cUFudc
	YbCns/tVeye/L3n1qDMfo9BzablMFCmqhi3DIkWtJgfEXw+qFe97BtcsFalaeukN3bghnTTywj2J+
	x4LyzzcfA19SZk5ZoZ9vGCULNnoAvZ1lfjXLZefmveiveW3IIntcTBUb6c7iO5VS2ISvcTruCRNYv
	HtrRWAJikjcH4NxQNLn8u6dFncBQlrYLKaUKkKqLBP8VeojEAsVtVpqsuPtC/74ri/HwNIAwBrkc0
	ZPge7Nmw==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4o-00Gq3c-AO; Fri, 21 May 2021 05:52:02 +0000
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
Subject: [PATCH 14/26] md: convert to blk_alloc_disk/blk_cleanup_disk
Date: Fri, 21 May 2021 07:51:04 +0200
Message-Id: <20210521055116.1053587-15-hch@lst.de>
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

Convert the md driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49f897fbb89b..d806be8cc210 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5598,12 +5598,10 @@ static void md_free(struct kobject *ko)
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
-	if (mddev->gendisk)
+	if (mddev->gendisk) {
 		del_gendisk(mddev->gendisk);
-	if (mddev->queue)
-		blk_cleanup_queue(mddev->queue);
-	if (mddev->gendisk)
-		put_disk(mddev->gendisk);
+		blk_cleanup_disk(mddev->gendisk);
+	}
 	percpu_ref_exit(&mddev->writes_pending);
 
 	bioset_exit(&mddev->bio_set);
@@ -5711,20 +5709,13 @@ static int md_alloc(dev_t dev, char *name)
 		goto abort;
 
 	error = -ENOMEM;
-	mddev->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!mddev->queue)
+	disk = blk_alloc_disk(NUMA_NO_NODE);
+	if (!disk)
 		goto abort;
 
-	blk_set_stacking_limits(&mddev->queue->limits);
-
-	disk = alloc_disk(1 << shift);
-	if (!disk) {
-		blk_cleanup_queue(mddev->queue);
-		mddev->queue = NULL;
-		goto abort;
-	}
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
+	disk->minors = 1 << shift;
 	if (name)
 		strcpy(disk->disk_name, name);
 	else if (partitioned)
@@ -5733,7 +5724,9 @@ static int md_alloc(dev_t dev, char *name)
 		sprintf(disk->disk_name, "md%d", unit);
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
-	disk->queue = mddev->queue;
+
+	mddev->queue = disk->queue;
+	blk_set_stacking_limits(&mddev->queue->limits);
 	blk_queue_write_cache(mddev->queue, true, true);
 	/* Allow extended partitions.  This makes the
 	 * 'mdp' device redundant, but we can't really
-- 
2.30.2


