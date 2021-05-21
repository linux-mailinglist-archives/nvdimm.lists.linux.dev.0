Return-Path: <nvdimm+bounces-30-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F0738BE34
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id DC0AA3E0FA4
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89F26D2B;
	Fri, 21 May 2021 05:51:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBB46D00
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1KdYzfXqf/AERVzTv9z5UW/YMYv05Ana4DxpCQVjBTA=; b=xq9A9Z8erGEHVAGm0y4W1ssW4B
	bb/K9MUHbMuoVGNlfX9cJCB14iacwKSwXk7TdvCpIx2RxxICboV5tmPE4X/N9SZq5B4dzwR/5N/Fy
	N8DTXkQ+12tJv83iu+WgSF6sZJFAldFQ0/6VETpIPNgv5mQuK/C7Ku8InIiAIj86nkVr5QzS88P3O
	QfkTjhwZz9jT+G8mbiPnuWamP+iJ2j1NKF53nRqZ/I/4rjpt2kep8q5iwHsBl3rPvXHX0RZCEq31O
	2aH4CE8oZZ+ivSh8MVwEJEMnmnARX7PDrb47eGLTaD7dDzvMN71vZxbD8VJkcoTnpS1yrvC7YAnxS
	9MpO4XSg==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4K-00Gpxo-3Z; Fri, 21 May 2021 05:51:32 +0000
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
Subject: [PATCH 04/26] block: add a flag to make put_disk on partially initalized disks safer
Date: Fri, 21 May 2021 07:50:54 +0200
Message-Id: <20210521055116.1053587-5-hch@lst.de>
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

Add a flag to indicate that __device_add_disk did grab a queue reference
so that disk_release only drops it if we actually had it.  This sort
out one of the major pitfals with partially initialized gendisk that
a lot of drivers did get wrong or still do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 7 +++++--
 include/linux/genhd.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index eec266c9318d..e4974af3d729 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -541,7 +541,10 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	 * Take an extra ref on queue which will be put on disk_release()
 	 * so that it sticks around as long as @disk is there.
 	 */
-	WARN_ON_ONCE(!blk_get_queue(disk->queue));
+	if (blk_get_queue(disk->queue))
+		set_bit(GD_QUEUE_REF, &disk->state);
+	else
+		WARN_ON_ONCE(1);
 
 	disk_add_events(disk);
 	blk_integrity_add(disk);
@@ -1116,7 +1119,7 @@ static void disk_release(struct device *dev)
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
-	if (disk->queue)
+	if (test_bit(GD_QUEUE_REF, &disk->state) && disk->queue)
 		blk_put_queue(disk->queue);
 	kfree(disk);
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7e9660ea967d..a5443f0b139d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -153,6 +153,7 @@ struct gendisk {
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
 #define GD_READ_ONLY			1
+#define GD_QUEUE_REF			2
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-- 
2.30.2


