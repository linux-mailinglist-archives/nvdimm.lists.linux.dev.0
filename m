Return-Path: <nvdimm+bounces-3275-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE264D3FDC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 04:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0DB813E0E72
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 03:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED10917F0;
	Thu, 10 Mar 2022 03:49:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBF57A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 03:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646884172; x=1678420172;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ut3afCH5XKJ5zRQELtGjJ2XbRWVTTiwIQnhlWJ678XQ=;
  b=JPvdvUlHsSPV6YQhMvkUyzv7acfYtYqcoxJk1sUuS5LJN93ngF2nuUG7
   GaSqjjFOXMbUGOgdy0jnfJJI2IfVB9kOLKAhKl1vla/i6WFlN+SstOEOY
   LJGh2xjey4UcxeKHUYSadmOAengvFQVSR7vbuodaPkg/cWu00nnmC0+ph
   EtNWfPnBiRW09APta+nOKwogl8IkFfDvGKTKtG503yCeb4i5Dk0GhadKt
   ebjSSFMGorM6uCqgBtIQigN3abInfHZoLDYxi6VfR/m8jnciW7onVpg4o
   q3l6jOAARaAFjETNaSbBvm7fmCSwrksX0wmAb9mT8SGBQ7+KhRAyOdw6y
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="255339520"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="255339520"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:32 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="554433405"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:32 -0800
Subject: [PATCH 3/6] nvdimm/namespace: Delete blk namespace consideration in
 shared paths
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: robert.hu@linux.intel.com, vishal.l.verma@intel.com, hch@lst.de,
 linux-acpi@vger.kernel.org
Date: Wed, 09 Mar 2022 19:49:32 -0800
Message-ID: <164688417214.2879318.4698377272678028573.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Given is_namespace_blk() is never true outside of the NVDIMM unit tests
delete the support from namespace device management.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |  152 ++-------------------------------------
 1 file changed, 9 insertions(+), 143 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index b57a2d36c517..5c76547c9b84 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -46,7 +46,6 @@ static void namespace_blk_release(struct device *dev)
 }
 
 static bool is_namespace_pmem(const struct device *dev);
-static bool is_namespace_blk(const struct device *dev);
 static bool is_namespace_io(const struct device *dev);
 
 static int is_uuid_busy(struct device *dev, void *data)
@@ -57,10 +56,6 @@ static int is_uuid_busy(struct device *dev, void *data)
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		uuid2 = nspm->uuid;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		uuid2 = nsblk->uuid;
 	} else if (is_nd_btt(dev)) {
 		struct nd_btt *nd_btt = to_nd_btt(dev);
 
@@ -178,12 +173,6 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		else
 			sprintf(name, "pmem%d%s", nd_region->id,
 					suffix ? suffix : "");
-	} else if (is_namespace_blk(&ndns->dev)) {
-		struct nd_namespace_blk *nsblk;
-
-		nsblk = to_nd_namespace_blk(&ndns->dev);
-		sprintf(name, "ndblk%d.%d%s", nd_region->id, nsblk->id,
-				suffix ? suffix : "");
 	} else {
 		return NULL;
 	}
@@ -201,10 +190,6 @@ const uuid_t *nd_dev_to_uuid(struct device *dev)
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		return nspm->uuid;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		return nsblk->uuid;
 	} else
 		return &uuid_null;
 }
@@ -229,10 +214,6 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		ns_altname = &nspm->alt_name;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		ns_altname = &nsblk->alt_name;
 	} else
 		return -ENXIO;
 
@@ -264,24 +245,6 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 	return rc;
 }
 
-static resource_size_t nd_namespace_blk_size(struct nd_namespace_blk *nsblk)
-{
-	struct nd_region *nd_region = to_nd_region(nsblk->common.dev.parent);
-	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
-	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_label_id label_id;
-	resource_size_t size = 0;
-	struct resource *res;
-
-	if (!nsblk->uuid)
-		return 0;
-	nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
-	for_each_dpa_resource(ndd, res)
-		if (strcmp(res->name, label_id.id) == 0)
-			size += resource_size(res);
-	return size;
-}
-
 static bool __nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
 {
 	struct nd_region *nd_region = to_nd_region(nsblk->common.dev.parent);
@@ -363,16 +326,6 @@ static int nd_namespace_label_update(struct nd_region *nd_region,
 			return 0;
 
 		return nd_pmem_namespace_label_update(nd_region, nspm, size);
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-		resource_size_t size = nd_namespace_blk_size(nsblk);
-
-		if (size == 0 && nsblk->uuid)
-			/* delete allocation */;
-		else if (!nsblk->uuid || !nsblk->lbasize)
-			return 0;
-
-		return nd_blk_namespace_label_update(nd_region, nsblk, size);
 	} else
 		return -ENXIO;
 }
@@ -405,10 +358,6 @@ static ssize_t alt_name_show(struct device *dev,
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		ns_altname = nspm->alt_name;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		ns_altname = nsblk->alt_name;
 	} else
 		return -ENXIO;
 
@@ -966,12 +915,6 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		uuid = nspm->uuid;
 		id = nspm->id;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		uuid = nsblk->uuid;
-		flags = NSLABEL_FLAG_LOCAL;
-		id = nsblk->id;
 	}
 
 	/*
@@ -1067,10 +1010,6 @@ static ssize_t size_store(struct device *dev,
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		uuid = &nspm->uuid;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		uuid = &nsblk->uuid;
 	}
 
 	if (rc == 0 && val == 0 && uuid) {
@@ -1095,8 +1034,6 @@ resource_size_t __nvdimm_namespace_capacity(struct nd_namespace_common *ndns)
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		return resource_size(&nspm->nsio.res);
-	} else if (is_namespace_blk(dev)) {
-		return nd_namespace_blk_size(to_nd_namespace_blk(dev));
 	} else if (is_namespace_io(dev)) {
 		struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
 
@@ -1152,12 +1089,8 @@ static uuid_t *namespace_to_uuid(struct device *dev)
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		return nspm->uuid;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		return nsblk->uuid;
-	} else
-		return ERR_PTR(-ENXIO);
+	}
+	return ERR_PTR(-ENXIO);
 }
 
 static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
@@ -1183,7 +1116,6 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 				 struct device *dev, uuid_t *new_uuid,
 				 uuid_t **old_uuid)
 {
-	u32 flags = is_namespace_blk(dev) ? NSLABEL_FLAG_LOCAL : 0;
 	struct nd_label_id old_label_id;
 	struct nd_label_id new_label_id;
 	int i;
@@ -1214,8 +1146,8 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 			return -EBUSY;
 	}
 
-	nd_label_gen_id(&old_label_id, *old_uuid, flags);
-	nd_label_gen_id(&new_label_id, new_uuid, flags);
+	nd_label_gen_id(&old_label_id, *old_uuid, 0);
+	nd_label_gen_id(&new_label_id, new_uuid, 0);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
@@ -1261,10 +1193,6 @@ static ssize_t uuid_store(struct device *dev,
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		ns_uuid = &nspm->uuid;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		ns_uuid = &nsblk->uuid;
 	} else
 		return -ENXIO;
 
@@ -1321,13 +1249,6 @@ static const unsigned long pmem_lbasize_supported[] = { 512, 4096, 0 };
 static ssize_t sector_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		return nd_size_select_show(nsblk->lbasize,
-				blk_lbasize_supported, buf);
-	}
-
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
@@ -1345,12 +1266,7 @@ static ssize_t sector_size_store(struct device *dev,
 	unsigned long *lbasize;
 	ssize_t rc = 0;
 
-	if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		lbasize = &nsblk->lbasize;
-		supported = blk_lbasize_supported;
-	} else if (is_namespace_pmem(dev)) {
+	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		lbasize = &nspm->lbasize;
@@ -1390,11 +1306,6 @@ static ssize_t dpa_extents_show(struct device *dev,
 
 		uuid = nspm->uuid;
 		flags = 0;
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		uuid = nsblk->uuid;
-		flags = NSLABEL_FLAG_LOCAL;
 	}
 
 	if (!uuid)
@@ -1627,10 +1538,7 @@ static umode_t namespace_visible(struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 
-	if (a == &dev_attr_resource.attr && is_namespace_blk(dev))
-		return 0;
-
-	if (is_namespace_pmem(dev) || is_namespace_blk(dev)) {
+	if (is_namespace_pmem(dev)) {
 		if (a == &dev_attr_size.attr)
 			return 0644;
 
@@ -1682,11 +1590,6 @@ static bool is_namespace_pmem(const struct device *dev)
 	return dev ? dev->type == &namespace_pmem_device_type : false;
 }
 
-static bool is_namespace_blk(const struct device *dev)
-{
-	return dev ? dev->type == &namespace_blk_device_type : false;
-}
-
 static bool is_namespace_io(const struct device *dev)
 {
 	return dev ? dev->type == &namespace_io_device_type : false;
@@ -1769,18 +1672,6 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 		nspm = to_nd_namespace_pmem(&ndns->dev);
 		if (uuid_not_set(nspm->uuid, &ndns->dev, __func__))
 			return ERR_PTR(-ENODEV);
-	} else if (is_namespace_blk(&ndns->dev)) {
-		struct nd_namespace_blk *nsblk;
-
-		nsblk = to_nd_namespace_blk(&ndns->dev);
-		if (uuid_not_set(nsblk->uuid, &ndns->dev, __func__))
-			return ERR_PTR(-ENODEV);
-		if (!nsblk->lbasize) {
-			dev_dbg(&ndns->dev, "sector size not set\n");
-			return ERR_PTR(-ENODEV);
-		}
-		if (!nd_namespace_blk_validate(nsblk))
-			return ERR_PTR(-ENODEV);
 	}
 
 	return ndns;
@@ -1790,16 +1681,12 @@ EXPORT_SYMBOL(nvdimm_namespace_common_probe);
 int devm_namespace_enable(struct device *dev, struct nd_namespace_common *ndns,
 		resource_size_t size)
 {
-	if (is_namespace_blk(&ndns->dev))
-		return 0;
 	return devm_nsio_enable(dev, to_nd_namespace_io(&ndns->dev), size);
 }
 EXPORT_SYMBOL_GPL(devm_namespace_enable);
 
 void devm_namespace_disable(struct device *dev, struct nd_namespace_common *ndns)
 {
-	if (is_namespace_blk(&ndns->dev))
-		return;
 	devm_nsio_disable(dev, to_nd_namespace_io(&ndns->dev));
 }
 EXPORT_SYMBOL_GPL(devm_namespace_disable);
@@ -2225,7 +2112,6 @@ static int add_namespace_resource(struct nd_region *nd_region,
 
 	for (i = 0; i < count; i++) {
 		uuid_t *uuid = namespace_to_uuid(devs[i]);
-		struct resource *res;
 
 		if (IS_ERR(uuid)) {
 			WARN_ON(1);
@@ -2234,20 +2120,9 @@ static int add_namespace_resource(struct nd_region *nd_region,
 
 		if (!nsl_uuid_equal(ndd, nd_label, uuid))
 			continue;
-		if (is_namespace_blk(devs[i])) {
-			res = nsblk_add_resource(nd_region, ndd,
-					to_nd_namespace_blk(devs[i]),
-					nsl_get_dpa(ndd, nd_label));
-			if (!res)
-				return -ENXIO;
-			nd_dbg_dpa(nd_region, ndd, res, "%d assign\n", count);
-		} else {
-			dev_err(&nd_region->dev,
-				"error: conflicting extents for uuid: %pUb\n",
-				uuid);
-			return -ENXIO;
-		}
-		break;
+		dev_err(&nd_region->dev,
+			"error: conflicting extents for uuid: %pUb\n", uuid);
+		return -ENXIO;
 	}
 
 	return i;
@@ -2305,20 +2180,11 @@ static int cmp_dpa(const void *a, const void *b)
 {
 	const struct device *dev_a = *(const struct device **) a;
 	const struct device *dev_b = *(const struct device **) b;
-	struct nd_namespace_blk *nsblk_a, *nsblk_b;
 	struct nd_namespace_pmem *nspm_a, *nspm_b;
 
 	if (is_namespace_io(dev_a))
 		return 0;
 
-	if (is_namespace_blk(dev_a)) {
-		nsblk_a = to_nd_namespace_blk(dev_a);
-		nsblk_b = to_nd_namespace_blk(dev_b);
-
-		return memcmp(&nsblk_a->res[0]->start, &nsblk_b->res[0]->start,
-				sizeof(resource_size_t));
-	}
-
 	nspm_a = to_nd_namespace_pmem(dev_a);
 	nspm_b = to_nd_namespace_pmem(dev_b);
 


