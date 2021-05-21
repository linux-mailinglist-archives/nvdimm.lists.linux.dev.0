Return-Path: <nvdimm+bounces-35-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDBD38BE61
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id D88163E101D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBA52BA6;
	Fri, 21 May 2021 05:52:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670E6D2E
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bO+oXGA9WmLEETtk0wIIo+77NnlxzsiBizrGZOlgSHY=; b=m5qs8ZX/0IIcCGIriH5FAt4d8x
	mJi3+aQdE0lI+0AErD2TqsZzVR7CQ0mAKWx+Tj57wA1w6G6ElqkXfbNZtkvJcAVgydB1Zox2iMnJM
	UTScAS+nU7ct3D/7dlzYrENbQ0TLttsm/U2UkUXWyGwBBTEaJmTTo4+cWZ9uoYH12bKzM0TxtZHcK
	OWqHZCJEENW+2b/mQRmu2ADenLPb46vnthTba9uApwmH6oQRclZ5TGqhV+url+xVyuaoPVKkYfFan
	f2ZZzjRx0KjG2RhZMGH1gtDaSc7etxxqUI1vt/bPC3/24C76SF4PMzqQyXxlxdZQwmZ+ZVIer5ZMe
	9Xwdq0uQ==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4W-00Gpz2-CI; Fri, 21 May 2021 05:51:44 +0000
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
Subject: [PATCH 08/26] pktcdvd: convert to blk_alloc_disk/blk_cleanup_disk
Date: Fri, 21 May 2021 07:50:58 +0200
Message-Id: <20210521055116.1053587-9-hch@lst.de>
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

Convert the pktcdvd driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index bd3556585122..f69b5c69c2a6 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2711,19 +2711,17 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	pd->write_congestion_off = write_congestion_off;
 
 	ret = -ENOMEM;
-	disk = alloc_disk(1);
+	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
 		goto out_mem;
 	pd->disk = disk;
 	disk->major = pktdev_major;
 	disk->first_minor = idx;
+	disk->minors = 1;
 	disk->fops = &pktcdvd_ops;
 	disk->flags = GENHD_FL_REMOVABLE;
 	strcpy(disk->disk_name, pd->name);
 	disk->private_data = pd;
-	disk->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!disk->queue)
-		goto out_mem2;
 
 	pd->pkt_dev = MKDEV(pktdev_major, idx);
 	ret = pkt_new_dev(pd, dev);
@@ -2746,7 +2744,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	return 0;
 
 out_mem2:
-	put_disk(disk);
+	blk_cleanup_disk(disk);
 out_mem:
 	mempool_exit(&pd->rb_pool);
 	kfree(pd);
@@ -2796,8 +2794,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 	pkt_dbg(1, pd, "writer unmapped\n");
 
 	del_gendisk(pd->disk);
-	blk_cleanup_queue(pd->disk->queue);
-	put_disk(pd->disk);
+	blk_cleanup_disk(pd->disk);
 
 	mempool_exit(&pd->rb_pool);
 	kfree(pd);
-- 
2.30.2


