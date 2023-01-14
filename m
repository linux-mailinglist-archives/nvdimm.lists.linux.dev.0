Return-Path: <nvdimm+bounces-5603-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD0D66AA5E
	for <lists+linux-nvdimm@lfdr.de>; Sat, 14 Jan 2023 10:21:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3248280A90
	for <lists+linux-nvdimm@lfdr.de>; Sat, 14 Jan 2023 09:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B074ECB;
	Sat, 14 Jan 2023 09:20:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF36EC0
	for <nvdimm@lists.linux.dev>; Sat, 14 Jan 2023 09:20:53 +0000 (UTC)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id GcFKpBC5RvDxRGcFKplSye; Sat, 14 Jan 2023 09:50:39 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 14 Jan 2023 09:50:39 +0100
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	nvdimm@lists.linux.dev
Subject: [PATCH v2] nvdimm: Use kstrtobool() instead of strtobool()
Date: Sat, 14 Jan 2023 09:50:21 +0100
Message-Id: <7565f107952e31fad2bc825b8c533df70c498537.1673686195.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch was already sent as a part of a serie ([1]) that axed all usages
of strtobool().
Most of the patches have been merged in -next.

I synch'ed with latest -next and re-send the remaining ones as individual
patches.

Changes in v2:
  - synch with latest -next.

[1]: https://lore.kernel.org/all/cover.1667336095.git.christophe.jaillet@wanadoo.fr/
---
 drivers/nvdimm/namespace_devs.c | 3 ++-
 drivers/nvdimm/pmem.c           | 3 ++-
 drivers/nvdimm/region_devs.c    | 5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index c60ec0b373c5..07177eadc56e 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2,6 +2,7 @@
 /*
  * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
  */
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/sort.h>
@@ -1338,7 +1339,7 @@ static ssize_t force_raw_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	bool force_raw;
-	int rc = strtobool(buf, &force_raw);
+	int rc = kstrtobool(buf, &force_raw);
 
 	if (rc)
 		return rc;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 80ded5a2838a..f2a336c6d8c6 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
+#include <linux/kstrtox.h>
 #include <linux/vmalloc.h>
 #include <linux/blk-mq.h>
 #include <linux/pfn_t.h>
@@ -408,7 +409,7 @@ static ssize_t write_cache_store(struct device *dev,
 	bool write_cache;
 	int rc;
 
-	rc = strtobool(buf, &write_cache);
+	rc = kstrtobool(buf, &write_cache);
 	if (rc)
 		return rc;
 	dax_write_cache(pmem->dax_dev, write_cache);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 83dbf398ea84..f5872de7ea5a 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -5,6 +5,7 @@
 #include <linux/scatterlist.h>
 #include <linux/memregion.h>
 #include <linux/highmem.h>
+#include <linux/kstrtox.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
@@ -275,7 +276,7 @@ static ssize_t deep_flush_store(struct device *dev, struct device_attribute *att
 		const char *buf, size_t len)
 {
 	bool flush;
-	int rc = strtobool(buf, &flush);
+	int rc = kstrtobool(buf, &flush);
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (rc)
@@ -530,7 +531,7 @@ static ssize_t read_only_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	bool ro;
-	int rc = strtobool(buf, &ro);
+	int rc = kstrtobool(buf, &ro);
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (rc)
-- 
2.34.1


