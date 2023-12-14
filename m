Return-Path: <nvdimm+bounces-7078-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0737812987
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Dec 2023 08:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50BF02820CE
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Dec 2023 07:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2025313AE9;
	Thu, 14 Dec 2023 07:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C7uwzNTV"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7D812E6B
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 07:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702539495; x=1734075495;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=g9l8RslOMp5ad/gXCRHw+j360xuk1nb3+acdwFrlL50=;
  b=C7uwzNTVTywtool/TQErXDmXkluI00xVPpGzgIaJbTUWA1QBEUflALII
   Vr35Cmu5Bj1V/xUr3wz6HFXDqPjxhqQiRyD7Yq3f8RfBy4oPJhOxpCtyf
   pfB7pyMtSGBSdaOrLv6tpzn5vZQvHEkjHAX9GcwQQLYmuMrYlkFHbweoQ
   G3m6HVQznd9PJ89rt8v00U1MTEbAofH3vGE2Czjf5/RTJeWH/x0QQY5oV
   xswWm0m8sOPlm6q5BD5RQPqKF/zxKGN1FSx3VX3LgZBH2v0NFu0x6uV+w
   LRrlDMz9lIL+RvfGTYWNHn2eOWDXBHHMAgl2Qz5a676h6bHEoHU7Vi8yB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="481275517"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="481275517"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 23:38:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="723972064"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="723972064"
Received: from llblake-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.191.124])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 23:38:12 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 14 Dec 2023 00:37:55 -0700
Subject: [PATCH v5 2/4] dax/bus: Use guard(device) in sysfs attribute
 helpers
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231214-vv-dax_abi-v5-2-3f7b006960b4@intel.com>
References: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
In-Reply-To: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, 
 Joao Martins <joao.m.martins@oracle.com>
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=7001;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=g9l8RslOMp5ad/gXCRHw+j360xuk1nb3+acdwFrlL50=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKlVGx4ZxJv18x/TfPRo6pLQrU05Fp3PElasO7C0qM1kr
 5tHY3xlRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZySoGRoZ9jz78FO0WOfBHN
 z7hkJdKzWZrxycoHdT8NjQSDuFZGHmZk+Kn/VmUD14viH/ymS1fZFjwx1PJr9J8nFCC9Yf3cLpa
 H7AA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Use the guard(device) macro to lock a 'struct device', and unlock it
automatically when going out of scope using Scope Based Resource
Management semantics. A lot of the sysfs attribute writes in
drivers/dax/bus.c benefit from a cleanup using these, so change these
where applicable.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 143 ++++++++++++++++++++++--------------------------------
 1 file changed, 59 insertions(+), 84 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ff1ab5fa105..6226de131d17 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -294,13 +294,10 @@ static ssize_t available_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
-	unsigned long long size;
 
-	device_lock(dev);
-	size = dax_region_avail_size(dax_region);
-	device_unlock(dev);
+	guard(device)(dev);
 
-	return sprintf(buf, "%llu\n", size);
+	return sprintf(buf, "%llu\n", dax_region_avail_size(dax_region));
 }
 static DEVICE_ATTR_RO(available_size);
 
@@ -309,17 +306,14 @@ static ssize_t seed_show(struct device *dev,
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 	struct device *seed;
-	ssize_t rc;
 
 	if (is_static(dax_region))
 		return -EINVAL;
 
-	device_lock(dev);
+	guard(device)(dev);
 	seed = dax_region->seed;
-	rc = sprintf(buf, "%s\n", seed ? dev_name(seed) : "");
-	device_unlock(dev);
 
-	return rc;
+	return sprintf(buf, "%s\n", seed ? dev_name(seed) : "");
 }
 static DEVICE_ATTR_RO(seed);
 
@@ -328,24 +322,28 @@ static ssize_t create_show(struct device *dev,
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 	struct device *youngest;
-	ssize_t rc;
 
 	if (is_static(dax_region))
 		return -EINVAL;
 
-	device_lock(dev);
+	guard(device)(dev);
 	youngest = dax_region->youngest;
-	rc = sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");
-	device_unlock(dev);
 
-	return rc;
+	return sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");
 }
 
 static ssize_t create_store(struct device *dev, struct device_attribute *attr,
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
 
@@ -358,38 +356,25 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
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
+	 * In support of crafting multiple new devices simultaneously multiple
+	 * seeds can be created, but only the first one that has not been
+	 * successfully bound is tracked as the region seed.
+	 */
+	if (!dax_region->seed)
+		dax_region->seed = &dev_dax->dev;
+	dax_region->youngest = &dev_dax->dev;
+
+	return len;
 }
 static DEVICE_ATTR_RW(create);
 
@@ -481,12 +466,9 @@ static int __free_dev_dax_id(struct dev_dax *dev_dax)
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
@@ -908,9 +890,8 @@ static ssize_t size_show(struct device *dev,
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	unsigned long long size;
 
-	device_lock(dev);
+	guard(device)(dev);
 	size = dev_dax_size(dev_dax);
-	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", size);
 }
@@ -1080,17 +1061,16 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
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
+	if (rc)
+		return rc;
 
-	return rc == 0 ? len : rc;
+	return len;
 }
 static DEVICE_ATTR_RW(size);
 
@@ -1137,21 +1117,20 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	if (rc)
 		return rc;
 
-	rc = -ENXIO;
-	device_lock(dax_region->dev);
-	if (!dax_region->dev->driver) {
-		device_unlock(dax_region->dev);
-		return rc;
-	}
-	device_lock(dev);
+	guard(device)(dax_region->dev);
+	if (!dax_region->dev->driver)
+		return -ENXIO;
 
+	guard(device)(dev);
 	to_alloc = range_len(&r);
-	if (alloc_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
-	device_unlock(dev);
-	device_unlock(dax_region->dev);
+	if (!alloc_is_aligned(dev_dax, to_alloc))
+		return -ENXIO;
 
-	return rc == 0 ? len : rc;
+	rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	if (rc)
+		return rc;
+
+	return len;
 }
 static DEVICE_ATTR_WO(mapping);
 
@@ -1196,27 +1175,23 @@ static ssize_t align_store(struct device *dev, struct device_attribute *attr,
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
-	if (rc)
+	if (rc) {
 		dev_dax->align = align_save;
-out_unlock:
-	device_unlock(dev);
-	device_unlock(dax_region->dev);
-	return rc == 0 ? len : rc;
+		return rc;
+	}
+
+	return len;
 }
 static DEVICE_ATTR_RW(align);
 

-- 
2.41.0


