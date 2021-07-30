Return-Path: <nvdimm+bounces-682-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162D53DB6A1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jul 2021 12:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id BC46E3E14E0
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jul 2021 10:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4803634A9;
	Fri, 30 Jul 2021 10:02:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D080A3483
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 10:02:28 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AMRBiS6u+ze944rzB4eEYS/Vi7skDntV00zEX?=
 =?us-ascii?q?/kB9WHVpmszxra6TdZMgpHvJYVcqKRYdcL+7WJVoLUmxyXcX2/h1AV7BZniEhI?=
 =?us-ascii?q?LAFugLhuGO/9SKIUzDH4BmupuIC5IOauEYE2IK9vrS0U2pFco62tmb/OSNjefa?=
 =?us-ascii?q?9X1kSgZncMhbnn5EIzfeAktrXxNHGJZ8MJKd4/BMrz2mdW9SQd+8AhA+LpD+ju?=
 =?us-ascii?q?yOhJT7egQHGhJizAGPiAmj4Ln8HwPd/jp2aUIo/Ysf?=
X-IronPort-AV: E=Sophos;i="5.84,281,1620662400"; 
   d="scan'208";a="112074026"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Jul 2021 18:02:26 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id C023B4D0D4A3;
	Fri, 30 Jul 2021 18:02:20 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 30 Jul 2021 18:02:17 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 30 Jul 2021 18:02:15 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 30 Jul 2021 18:02:13 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@lst.de>, <agk@redhat.com>, <snitzer@redhat.com>
Subject: [PATCH RESEND v6 7/9] dm: Introduce ->rmap() to find bdev offset
Date: Fri, 30 Jul 2021 18:01:56 +0800
Message-ID: <20210730100158.3117319-8-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: C023B4D0D4A3.A24E5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Pmem device could be a target of mapped device.  In order to find out
the global location on a mapped device, we introduce this to translate
offset from target device to mapped device.

Currently, we implement it on linear target, which is easy to do the
translation.  Other targets will be supported in the future.  However,
some targets may not support it because of the non-linear mapping.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 block/genhd.c                 | 56 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-linear.c        | 20 +++++++++++++
 include/linux/device-mapper.h |  5 ++++
 include/linux/genhd.h         |  1 +
 4 files changed, 82 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index af4d2ab4a633..7a595da0cbec 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -669,6 +669,62 @@ void blk_request_module(dev_t devt)
 		request_module("block-major-%d", MAJOR(devt));
 }
 
+/*
+ * bdget_disk - do bdget() by gendisk and partition number
+ * @disk: gendisk of interest
+ * @partno: partition number
+ *
+ * Find partition @partno from @disk, do bdget() on it.
+ *
+ * CONTEXT:
+ * Don't care.
+ *
+ * RETURNS:
+ * Resulting block_device on success, NULL on failure.
+ */
+static inline struct block_device *bdget_disk(struct gendisk *disk, int partno)
+{
+	struct block_device *bdev = NULL;
+
+	rcu_read_lock();
+	bdev = xa_load(&disk->part_tbl, partno);
+	if (bdev && !bdgrab(bdev))
+		bdev = NULL;
+	rcu_read_unlock();
+
+	return bdev;
+}
+
+/**
+ * bdget_disk_sector - get block device by given sector number
+ * @disk: gendisk of interest
+ * @sector: sector number
+ *
+ * RETURNS: the found block device where sector locates in
+ */
+struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector)
+{
+	struct block_device *part = NULL, *p;
+	unsigned long idx;
+
+	rcu_read_lock();
+	xa_for_each(&disk->part_tbl, idx, p) {
+		if (p->bd_partno == 0)
+			continue;
+		if (p->bd_start_sect <= sector &&
+			sector < p->bd_start_sect + bdev_nr_sectors(p)) {
+			part = p;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	if (!part)
+		part = disk->part0;
+
+	return bdget_disk(disk, part->bd_partno);
+}
+EXPORT_SYMBOL(bdget_disk_sector);
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index c91f1e2e2f65..d28577bd358b 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -5,6 +5,7 @@
  */
 
 #include "dm.h"
+#include "dm-core.h"
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
@@ -119,6 +120,24 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
+static int linear_rmap(struct dm_target *ti, sector_t offset,
+		       rmap_callout_fn fn, void *data)
+{
+	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct mapped_device *md = ti->table->md;
+	struct block_device *bdev;
+	sector_t disk_sect = offset - dm_target_offset(ti, lc->start);
+	int rc = -ENODEV;
+
+	bdev = bdget_disk_sector(md->disk, offset);
+	if (!bdev)
+		return rc;
+
+	rc = fn(ti, bdev, disk_sect, data);
+	bdput(bdev);
+	return rc;
+}
+
 static int linear_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
@@ -235,6 +254,7 @@ static struct target_type linear_target = {
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
 	.map    = linear_map,
+	.rmap   = linear_rmap,
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 7457d49acf9a..4069983c4618 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -58,6 +58,10 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
  * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio);
+typedef int (*rmap_callout_fn) (struct dm_target *ti, struct block_device *bdev,
+				sector_t sect, void *data);
+typedef int (*dm_rmap_fn) (struct dm_target *ti, sector_t offset,
+			   rmap_callout_fn fn, void *data);
 typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
 					    struct request *rq,
 					    union map_info *map_context,
@@ -184,6 +188,7 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_rmap_fn rmap;
 	dm_clone_and_map_request_fn clone_and_map_rq;
 	dm_release_clone_request_fn release_clone_rq;
 	dm_endio_fn end_io;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 13b34177cc85..7de6fdc14de6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -223,6 +223,7 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
 }
 
 extern void del_gendisk(struct gendisk *gp);
+extern struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector);
 
 void set_disk_ro(struct gendisk *disk, bool read_only);
 
-- 
2.32.0




