Return-Path: <nvdimm+bounces-6349-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 144987517F4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jul 2023 07:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76723281BB3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jul 2023 05:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D9253A7;
	Thu, 13 Jul 2023 05:20:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AEBF539F
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 05:20:26 +0000 (UTC)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id JoHLqljqIGqNMJoHLqvxHU; Thu, 13 Jul 2023 06:50:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1689223813;
	bh=OIO6SGvjdu5q95AKttYaweX2kv13SEJFYyGhl5Ix5MU=;
	h=From:To:Cc:Subject:Date;
	b=D6aJTxES5TE1G/CFp5XvTb2PZdxCaLGx3SH+sJG8S/01CDdGPONxOBpZdrpkunkVD
	 j2kIr5AYo6oMJzAvJbwvk0DJDXE5C+EsU9AyXbFAbOfHIvzC+MPVDTQkWPjZk04DIf
	 Gm7jJdIsKKaR58N13iaubLsUn4Drc61jYeOkFihkH7U5KF0FWVIuzjD/tmrTsy4cFM
	 8TbqmO9/Jc6cEhaSpSYy/ZeAbXfbzYKzK8ZLPHM8+MsxLZ1/5nOdK5s6cgYn+iMGao
	 OQU5UJ3u2F9WP4iraRqwd1vwuu+9Kp0ZAH2ct02IXzMDxCdlX1p+oXGFmKzkIitESW
	 8ecSApggwqb0Q==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 Jul 2023 06:50:13 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: akpm@linux-foundation.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	nvdimm@lists.linux.dev
Subject: [PATCH v3] nvdimm: Use kstrtobool() instead of strtobool()
Date: Thu, 13 Jul 2023 06:50:09 +0200
Message-Id: <75a5ff07902e34fad9bc821b8c533d070c498537.1673686195.git.christophe.jaillet@wanadoo.fr>
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

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch was already sent as a part of a serie ([1]) that axed all usages
of strtobool().
Most of the patches have been merged in -next.

I synch'ed with latest -next and re-send the remaining ones as individual
patches.

Even if R-b and told that it was applied for v6.3, it is still not in -next.
This is the very last patch of the initial serie that remains un-applied.

After it, strtobool() can be removed from linux/kstrtox.h.

Changes in v3:
  - synch with latest -next.
  - Adding R-b tag
  - Adding in cc: akpm@linux-foundation.org

Changes in v2:
  - synch with latest -next.
  - https://lore.kernel.org/all/7565f107952e31fad2bc825b8c533df70c498537.1673686195.git.christophe.jaillet@wanadoo.fr/

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
@@ -385,7 +386,7 @@ static ssize_t write_cache_store(struct device *dev,
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


