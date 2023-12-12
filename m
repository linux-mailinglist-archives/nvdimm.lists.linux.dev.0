Return-Path: <nvdimm+bounces-7052-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B52E580F617
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Dec 2023 20:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 404861F215FB
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Dec 2023 19:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9CB8004F;
	Tue, 12 Dec 2023 19:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nj+fiqIv"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF81280057
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 19:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702408130; x=1733944130;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=zYL68s17Ug9RUUMduHTMgqPyJT0UZnz1m+I7vUoJDyM=;
  b=nj+fiqIv7nQlcnderjt3jAS5NrAIjjp5eQTmu75kZDkDIeZDQ6C+d2RY
   rqvD7Qlt/4xIRx3Ray0nA+eXAlzxfxoyBsbbf6HlQxzsIhke+7gqgI6dH
   5REj1ppz1IRGWKBgoai0gpwGjx/KuNpewuTY6O2dRQ+Suss54VR7tT2+U
   XicY7n6HjPhCoxygB7pCSEMxIf43kqLv+tPydscQR2TTT3Ovizec8c5uG
   hUtgrwlhkNdYq0i/J8z1w+WWnE7JDIWswAx6+3FCSa8f0frNXuv2RUeN6
   xEOVDuTA2rs/lXg6padQlbScrogdfwvosTvKniZ9WvzD7UWUBQP3S4OgB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="13550596"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="13550596"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 11:08:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="844017861"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="844017861"
Received: from cmperez2-mobl2.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.66.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 11:08:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 12 Dec 2023 12:08:31 -0700
Subject: [PATCH v4 2/3] dax/bus: Introduce guard(device) for
 device_{lock,unlock} flows
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231212-vv-dax_abi-v4-2-1351758f0c92@intel.com>
References: <20231212-vv-dax_abi-v4-0-1351758f0c92@intel.com>
In-Reply-To: <20231212-vv-dax_abi-v4-0-1351758f0c92@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, Joao Martins <joao.m.martins@oracle.com>
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=6772;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=zYL68s17Ug9RUUMduHTMgqPyJT0UZnz1m+I7vUoJDyM=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKkV6/eaxBQWhvSfm7/rjF+CpubEQxa3FHT1g45I+RXON
 0i+++VKRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACbyTZyR4c7DK18Pe/HM8gh3
 fuIheEm77Cp7lJSx7ouLa+fJTbhRYM3IsPxk3tINju8qjq+63c7Ke00hjNUze9XSsO4VerY8Lne
 bOQE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Introduce a guard(device) macro to lock a 'struct device', and unlock it
automatically when going out of scope using Scope Based Resource
Management semantics. A lot of the sysfs attribute writes in
drivers/dax/bus.c benefit from a cleanup using these, so change these
where applicable.

Cc: Joao Martins <joao.m.martins@oracle.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 include/linux/device.h |   2 +
 drivers/dax/bus.c      | 109 +++++++++++++++++++------------------------------
 2 files changed, 44 insertions(+), 67 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index d7a72a8749ea..a83efd9ae949 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1131,6 +1131,8 @@ void set_secondary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 void device_set_of_node_from_dev(struct device *dev, const struct device *dev2);
 void device_set_node(struct device *dev, struct fwnode_handle *fwnode);
 
+DEFINE_GUARD(device, struct device *, device_lock(_T), device_unlock(_T))
+
 static inline int dev_num_vf(struct device *dev)
 {
 	if (dev->bus && dev->bus->num_vf)
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ff1ab5fa105..ce1356ac6dc2 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -296,9 +296,8 @@ static ssize_t available_size_show(struct device *dev,
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 	unsigned long long size;
 
-	device_lock(dev);
+	guard(device)(dev);
 	size = dax_region_avail_size(dax_region);
-	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", size);
 }
@@ -314,10 +313,9 @@ static ssize_t seed_show(struct device *dev,
 	if (is_static(dax_region))
 		return -EINVAL;
 
-	device_lock(dev);
+	guard(device)(dev);
 	seed = dax_region->seed;
 	rc = sprintf(buf, "%s\n", seed ? dev_name(seed) : "");
-	device_unlock(dev);
 
 	return rc;
 }
@@ -333,10 +331,9 @@ static ssize_t create_show(struct device *dev,
 	if (is_static(dax_region))
 		return -EINVAL;
 
-	device_lock(dev);
+	guard(device)(dev);
 	youngest = dax_region->youngest;
 	rc = sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");
-	device_unlock(dev);
 
 	return rc;
 }
@@ -345,7 +342,14 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t len)
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
+	struct dev_dax_data data = {
+		.dax_region = dax_region,
+		.size = 0,
+		.id = -1,
+		.memmap_on_memory = false,
+	};
 	unsigned long long avail;
+	struct dev_dax *dev_dax;
 	ssize_t rc;
 	int val;
 
@@ -358,38 +362,26 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
 	if (val != 1)
 		return -EINVAL;
 
-	device_lock(dev);
+	guard(device)(dev);
 	avail = dax_region_avail_size(dax_region);
 	if (avail == 0)
-		rc = -ENOSPC;
-	else {
-		struct dev_dax_data data = {
-			.dax_region = dax_region,
-			.size = 0,
-			.id = -1,
-			.memmap_on_memory = false,
-		};
-		struct dev_dax *dev_dax = devm_create_dev_dax(&data);
+		return -ENOSPC;
 
-		if (IS_ERR(dev_dax))
-			rc = PTR_ERR(dev_dax);
-		else {
-			/*
-			 * In support of crafting multiple new devices
-			 * simultaneously multiple seeds can be created,
-			 * but only the first one that has not been
-			 * successfully bound is tracked as the region
-			 * seed.
-			 */
-			if (!dax_region->seed)
-				dax_region->seed = &dev_dax->dev;
-			dax_region->youngest = &dev_dax->dev;
-			rc = len;
-		}
-	}
-	device_unlock(dev);
+	dev_dax = devm_create_dev_dax(&data);
+	if (IS_ERR(dev_dax))
+		return PTR_ERR(dev_dax);
 
-	return rc;
+	/*
+	 * In support of crafting multiple new devices
+	 * simultaneously multiple seeds can be created,
+	 * but only the first one that has not been
+	 * successfully bound is tracked as the region
+	 * seed.
+	 */
+	if (!dax_region->seed)
+		dax_region->seed = &dev_dax->dev;
+	dax_region->youngest = &dev_dax->dev;
+	return len;
 }
 static DEVICE_ATTR_RW(create);
 
@@ -481,12 +473,9 @@ static int __free_dev_dax_id(struct dev_dax *dev_dax)
 static int free_dev_dax_id(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
-	int rc;
 
-	device_lock(dev);
-	rc = __free_dev_dax_id(dev_dax);
-	device_unlock(dev);
-	return rc;
+	guard(device)(dev);
+	return __free_dev_dax_id(dev_dax);
 }
 
 static int alloc_dev_dax_id(struct dev_dax *dev_dax)
@@ -908,9 +897,8 @@ static ssize_t size_show(struct device *dev,
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	unsigned long long size;
 
-	device_lock(dev);
+	guard(device)(dev);
 	size = dev_dax_size(dev_dax);
-	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", size);
 }
@@ -1080,15 +1068,12 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	device_lock(dax_region->dev);
-	if (!dax_region->dev->driver) {
-		device_unlock(dax_region->dev);
+	guard(device)(dax_region->dev);
+	if (!dax_region->dev->driver)
 		return -ENXIO;
-	}
-	device_lock(dev);
+
+	guard(device)(dev);
 	rc = dev_dax_resize(dax_region, dev_dax, val);
-	device_unlock(dev);
-	device_unlock(dax_region->dev);
 
 	return rc == 0 ? len : rc;
 }
@@ -1138,18 +1123,14 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 
 	rc = -ENXIO;
-	device_lock(dax_region->dev);
-	if (!dax_region->dev->driver) {
-		device_unlock(dax_region->dev);
+	guard(device)(dax_region->dev);
+	if (!dax_region->dev->driver)
 		return rc;
-	}
-	device_lock(dev);
 
+	guard(device)(dev);
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
 		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
-	device_unlock(dev);
-	device_unlock(dax_region->dev);
 
 	return rc == 0 ? len : rc;
 }
@@ -1196,26 +1177,20 @@ static ssize_t align_store(struct device *dev, struct device_attribute *attr,
 	if (!dax_align_valid(val))
 		return -EINVAL;
 
-	device_lock(dax_region->dev);
-	if (!dax_region->dev->driver) {
-		device_unlock(dax_region->dev);
+	guard(device)(dax_region->dev);
+	if (!dax_region->dev->driver)
 		return -ENXIO;
-	}
 
-	device_lock(dev);
-	if (dev->driver) {
-		rc = -EBUSY;
-		goto out_unlock;
-	}
+	guard(device)(dev);
+	if (dev->driver)
+		return -EBUSY;
 
 	align_save = dev_dax->align;
 	dev_dax->align = val;
 	rc = dev_dax_validate_align(dev_dax);
 	if (rc)
 		dev_dax->align = align_save;
-out_unlock:
-	device_unlock(dev);
-	device_unlock(dax_region->dev);
+
 	return rc == 0 ? len : rc;
 }
 static DEVICE_ATTR_RW(align);

-- 
2.41.0


