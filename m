Return-Path: <nvdimm+bounces-47-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C60038BEAE
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 5CE0D3E108C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8D02BD9;
	Fri, 21 May 2021 05:52:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D257C2BCF
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZAV8JJrVAUnXoR6OurR4mkqtEg3WMlk+fF6tHo9g/7A=; b=RQ5YIAs+5mbK/6S6SBFGzZCoIL
	klS1hFKw/i99aVf05vtzIoxFkY9Pr4PV68y0ey4X1pxQeLS1H2oxzRVBvyxMkzTmtQ8Tjd+4x9Khu
	K6yj+9nam8JNpySJVCeLpQQSqwCFPjU4PCDX/OdiMX4O3i7h4UdjcJoKBF+x5YUvGod3RZR/ri1u2
	BqvyxGfPsXvxjbaujNo64BgtrBXZUF8OftT5Zr2U7XTw//ip/+RAmDe/baxIm9bt/TI8qX8nkYqhH
	q1Vso2McvdCTWgsaaG1voMKJyWtCve2lkdzuSMfNcr5tHawk3RWp5284MWXyV/KmX6NvgUxNrY5hk
	1N9pV/6A==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy58-00GqAV-Tf; Fri, 21 May 2021 05:52:23 +0000
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
Subject: [PATCH 20/26] simdisk: convert to blk_alloc_disk/blk_cleanup_disk
Date: Fri, 21 May 2021 07:51:10 +0200
Message-Id: <20210521055116.1053587-21-hch@lst.de>
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

Convert the simdisk driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/xtensa/platforms/iss/simdisk.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index fc09be7b1347..3cdfa00738e0 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -27,7 +27,6 @@
 struct simdisk {
 	const char *filename;
 	spinlock_t lock;
-	struct request_queue *queue;
 	struct gendisk *gd;
 	struct proc_dir_entry *procfile;
 	int users;
@@ -266,21 +265,13 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 	spin_lock_init(&dev->lock);
 	dev->users = 0;
 
-	dev->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (dev->queue == NULL) {
-		pr_err("blk_alloc_queue failed\n");
-		goto out_alloc_queue;
-	}
-
-	dev->gd = alloc_disk(SIMDISK_MINORS);
-	if (dev->gd == NULL) {
-		pr_err("alloc_disk failed\n");
-		goto out_alloc_disk;
-	}
+	dev->gd = blk_alloc_disk(NUMA_NO_NODE);
+	if (!dev->gd)
+		return -ENOMEM;
 	dev->gd->major = simdisk_major;
 	dev->gd->first_minor = which;
+	dev->gd->minors = SIMDISK_MINORS;
 	dev->gd->fops = &simdisk_ops;
-	dev->gd->queue = dev->queue;
 	dev->gd->private_data = dev;
 	snprintf(dev->gd->disk_name, 32, "simdisk%d", which);
 	set_capacity(dev->gd, 0);
@@ -288,12 +279,6 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 
 	dev->procfile = proc_create_data(tmp, 0644, procdir, &simdisk_proc_ops, dev);
 	return 0;
-
-out_alloc_disk:
-	blk_cleanup_queue(dev->queue);
-	dev->queue = NULL;
-out_alloc_queue:
-	return -ENOMEM;
 }
 
 static int __init simdisk_init(void)
@@ -343,10 +328,10 @@ static void simdisk_teardown(struct simdisk *dev, int which,
 	char tmp[2] = { '0' + which, 0 };
 
 	simdisk_detach(dev);
-	if (dev->gd)
+	if (dev->gd) {
 		del_gendisk(dev->gd);
-	if (dev->queue)
-		blk_cleanup_queue(dev->queue);
+		blk_cleanup_disk(dev->gd);
+	}
 	remove_proc_entry(tmp, procdir);
 }
 
-- 
2.30.2


