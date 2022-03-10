Return-Path: <nvdimm+bounces-3280-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B9E4D3FE7
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 04:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id B7C063E0FDC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 03:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F2D817EE;
	Thu, 10 Mar 2022 03:50:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB51F7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646884215; x=1678420215;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TPcpoD4b7OXa0W6Dnh/jbHp6DBsYRIfEZPwVCMv8qtg=;
  b=n6SoePXkj4qrVKyMNNKDEJHK/hfHFBAvIdCnOL/sTyouOZshY6USkmo+
   zLFH8cKOpKTVc1hZNosbhK50o8SXrTQe/pWXoB4xGvcH/oRdetXlanpQG
   GFHverttvZbnkUgWRKTKL0XSWXIF6RX+Xj5wu2U5tizL6LFrVgoIUzJXJ
   du3s355oxZofIR23nnbzCTtnDXB5Y+CDcgz+0Vr1dNeFpAvC+Ca989sf1
   0RWvHr5NBwyFGJ6hb56fqMUfhSXBeczmHwOr0BfwBQxOID75JejQf7kk7
   XPC7Se0Cx/7OWYE94lq7coRVkJ6YWZcOIt8yXdMs9qyLTyM2Od1IP3oXs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235760068"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235760068"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:48 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="611602065"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:48 -0800
Subject: [PATCH 6/6] nvdimm/region: Delete nd_blk_region infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: robert.hu@linux.intel.com, vishal.l.verma@intel.com, hch@lst.de,
 linux-acpi@vger.kernel.org
Date: Wed, 09 Mar 2022 19:49:48 -0800
Message-ID: <164688418803.2879318.1302315202397235855.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that the nd_namespace_blk infrastructure is removed, delete all the
region machinery to coordinate provisioning aliased capacity between
PMEM and BLK.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c           |   11 +-
 drivers/nvdimm/bus.c               |    2 
 drivers/nvdimm/dimm_devs.c         |  204 ++----------------------------------
 drivers/nvdimm/label.c             |    6 -
 drivers/nvdimm/label.h             |    2 
 drivers/nvdimm/namespace_devs.c    |  127 ++--------------------
 drivers/nvdimm/nd-core.h           |   24 ----
 drivers/nvdimm/nd.h                |   12 --
 drivers/nvdimm/region.c            |   31 ++---
 drivers/nvdimm/region_devs.c       |  158 +++-------------------------
 include/linux/libnvdimm.h          |   24 ----
 include/uapi/linux/ndctl.h         |    2 
 tools/testing/nvdimm/test/ndtest.c |   67 +-----------
 13 files changed, 66 insertions(+), 604 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bea6a219fddd..fe61f617a943 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2036,10 +2036,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			cmd_mask |= nfit_mem->dsm_mask & NVDIMM_STANDARD_CMDMASK;
 		}
 
-		/* Quirk to ignore LOCAL for labels on HYPERV DIMMs */
-		if (nfit_mem->family == NVDIMM_FAMILY_HYPERV)
-			set_bit(NDD_NOBLK, &flags);
-
 		if (test_bit(NFIT_MEM_LSR, &nfit_mem->flags)) {
 			set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 			set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
@@ -2602,8 +2598,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 {
 	static struct nd_mapping_desc mappings[ND_MAX_MAPPINGS];
 	struct acpi_nfit_system_address *spa = nfit_spa->spa;
-	struct nd_blk_region_desc ndbr_desc;
-	struct nd_region_desc *ndr_desc;
+	struct nd_region_desc *ndr_desc, _ndr_desc;
 	struct nfit_memdev *nfit_memdev;
 	struct nvdimm_bus *nvdimm_bus;
 	struct resource res;
@@ -2619,10 +2614,10 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	memset(&res, 0, sizeof(res));
 	memset(&mappings, 0, sizeof(mappings));
-	memset(&ndbr_desc, 0, sizeof(ndbr_desc));
+	memset(&_ndr_desc, 0, sizeof(_ndr_desc));
 	res.start = spa->address;
 	res.end = res.start + spa->length - 1;
-	ndr_desc = &ndbr_desc.ndr_desc;
+	ndr_desc = &_ndr_desc;
 	ndr_desc->res = &res;
 	ndr_desc->provider_data = nfit_spa;
 	ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9dc7f3edd42b..a4b5f637e599 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -35,8 +35,6 @@ static int to_nd_device_type(struct device *dev)
 		return ND_DEVICE_DIMM;
 	else if (is_memory(dev))
 		return ND_DEVICE_REGION_PMEM;
-	else if (is_nd_blk(dev))
-		return ND_DEVICE_REGION_BLK;
 	else if (is_nd_dax(dev))
 		return ND_DEVICE_DAX_PMEM;
 	else if (is_nd_region(dev->parent))
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index dc7449a40003..ee507eed42b5 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,10 +18,6 @@
 
 static DEFINE_IDA(dimm_ida);
 
-static bool noblk;
-module_param(noblk, bool, 0444);
-MODULE_PARM_DESC(noblk, "force disable BLK / local alias support");
-
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
@@ -211,22 +207,6 @@ struct nvdimm *to_nvdimm(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm);
 
-struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr)
-{
-	struct nd_region *nd_region = &ndbr->nd_region;
-	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
-
-	return nd_mapping->nvdimm;
-}
-EXPORT_SYMBOL_GPL(nd_blk_region_to_dimm);
-
-unsigned long nd_blk_memremap_flags(struct nd_blk_region *ndbr)
-{
-	/* pmem mapping properties are private to libnvdimm */
-	return ARCH_MEMREMAP_PMEM;
-}
-EXPORT_SYMBOL_GPL(nd_blk_memremap_flags);
-
 struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping)
 {
 	struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -312,8 +292,7 @@ static ssize_t flags_show(struct device *dev,
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	return sprintf(buf, "%s%s%s\n",
-			test_bit(NDD_ALIASING, &nvdimm->flags) ? "alias " : "",
+	return sprintf(buf, "%s%s\n",
 			test_bit(NDD_LABELING, &nvdimm->flags) ? "label " : "",
 			test_bit(NDD_LOCKED, &nvdimm->flags) ? "lock " : "");
 }
@@ -612,8 +591,6 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 
 	nvdimm->dimm_id = dimm_id;
 	nvdimm->provider_data = provider_data;
-	if (noblk)
-		flags |= 1 << NDD_NOBLK;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
 	nvdimm->num_flush = num_flush;
@@ -726,133 +703,6 @@ static unsigned long dpa_align(struct nd_region *nd_region)
 	return nd_region->align / nd_region->ndr_mappings;
 }
 
-int alias_dpa_busy(struct device *dev, void *data)
-{
-	resource_size_t map_end, blk_start, new;
-	struct blk_alloc_info *info = data;
-	struct nd_mapping *nd_mapping;
-	struct nd_region *nd_region;
-	struct nvdimm_drvdata *ndd;
-	struct resource *res;
-	unsigned long align;
-	int i;
-
-	if (!is_memory(dev))
-		return 0;
-
-	nd_region = to_nd_region(dev);
-	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		nd_mapping  = &nd_region->mapping[i];
-		if (nd_mapping->nvdimm == info->nd_mapping->nvdimm)
-			break;
-	}
-
-	if (i >= nd_region->ndr_mappings)
-		return 0;
-
-	ndd = to_ndd(nd_mapping);
-	map_end = nd_mapping->start + nd_mapping->size - 1;
-	blk_start = nd_mapping->start;
-
-	/*
-	 * In the allocation case ->res is set to free space that we are
-	 * looking to validate against PMEM aliasing collision rules
-	 * (i.e. BLK is allocated after all aliased PMEM).
-	 */
-	if (info->res) {
-		if (info->res->start >= nd_mapping->start
-				&& info->res->start < map_end)
-			/* pass */;
-		else
-			return 0;
-	}
-
- retry:
-	/*
-	 * Find the free dpa from the end of the last pmem allocation to
-	 * the end of the interleave-set mapping.
-	 */
-	align = dpa_align(nd_region);
-	if (!align)
-		return 0;
-
-	for_each_dpa_resource(ndd, res) {
-		resource_size_t start, end;
-
-		if (strncmp(res->name, "pmem", 4) != 0)
-			continue;
-
-		start = ALIGN_DOWN(res->start, align);
-		end = ALIGN(res->end + 1, align) - 1;
-		if ((start >= blk_start && start < map_end)
-				|| (end >= blk_start && end <= map_end)) {
-			new = max(blk_start, min(map_end, end) + 1);
-			if (new != blk_start) {
-				blk_start = new;
-				goto retry;
-			}
-		}
-	}
-
-	/* update the free space range with the probed blk_start */
-	if (info->res && blk_start > info->res->start) {
-		info->res->start = max(info->res->start, blk_start);
-		if (info->res->start > info->res->end)
-			info->res->end = info->res->start - 1;
-		return 1;
-	}
-
-	info->available -= blk_start - nd_mapping->start;
-
-	return 0;
-}
-
-/**
- * nd_blk_available_dpa - account the unused dpa of BLK region
- * @nd_mapping: container of dpa-resource-root + labels
- *
- * Unlike PMEM, BLK namespaces can occupy discontiguous DPA ranges, but
- * we arrange for them to never start at an lower dpa than the last
- * PMEM allocation in an aliased region.
- */
-resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
-{
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
-	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
-	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct blk_alloc_info info = {
-		.nd_mapping = nd_mapping,
-		.available = nd_mapping->size,
-		.res = NULL,
-	};
-	struct resource *res;
-	unsigned long align;
-
-	if (!ndd)
-		return 0;
-
-	device_for_each_child(&nvdimm_bus->dev, &info, alias_dpa_busy);
-
-	/* now account for busy blk allocations in unaliased dpa */
-	align = dpa_align(nd_region);
-	if (!align)
-		return 0;
-	for_each_dpa_resource(ndd, res) {
-		resource_size_t start, end, size;
-
-		if (strncmp(res->name, "blk", 3) != 0)
-			continue;
-		start = ALIGN_DOWN(res->start, align);
-		end = ALIGN(res->end + 1, align) - 1;
-		size = end - start + 1;
-		if (size >= info.available)
-			return 0;
-		info.available -= size;
-	}
-
-	return info.available;
-}
-
 /**
  * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
  *			   contiguous unallocated dpa range.
@@ -900,24 +750,16 @@ resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
  * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
  * @nd_mapping: container of dpa-resource-root + labels
  * @nd_region: constrain available space check to this reference region
- * @overlap: calculate available space assuming this level of overlap
  *
  * Validate that a PMEM label, if present, aligns with the start of an
- * interleave set and truncate the available size at the lowest BLK
- * overlap point.
- *
- * The expectation is that this routine is called multiple times as it
- * probes for the largest BLK encroachment for any single member DIMM of
- * the interleave set.  Once that value is determined the PMEM-limit for
- * the set can be established.
+ * interleave set.
  */
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
-		struct nd_mapping *nd_mapping, resource_size_t *overlap)
+				      struct nd_mapping *nd_mapping)
 {
-	resource_size_t map_start, map_end, busy = 0, available, blk_start;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	resource_size_t map_start, map_end, busy = 0;
 	struct resource *res;
-	const char *reason;
 	unsigned long align;
 
 	if (!ndd)
@@ -929,46 +771,28 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 
 	map_start = nd_mapping->start;
 	map_end = map_start + nd_mapping->size - 1;
-	blk_start = max(map_start, map_end + 1 - *overlap);
 	for_each_dpa_resource(ndd, res) {
 		resource_size_t start, end;
 
 		start = ALIGN_DOWN(res->start, align);
 		end = ALIGN(res->end + 1, align) - 1;
 		if (start >= map_start && start < map_end) {
-			if (strncmp(res->name, "blk", 3) == 0)
-				blk_start = min(blk_start,
-						max(map_start, start));
-			else if (end > map_end) {
-				reason = "misaligned to iset";
-				goto err;
-			} else
-				busy += end - start + 1;
+			if (end > map_end) {
+				nd_dbg_dpa(nd_region, ndd, res,
+					   "misaligned to iset\n");
+				return 0;
+			}
+			busy += end - start + 1;
 		} else if (end >= map_start && end <= map_end) {
-			if (strncmp(res->name, "blk", 3) == 0) {
-				/*
-				 * If a BLK allocation overlaps the start of
-				 * PMEM the entire interleave set may now only
-				 * be used for BLK.
-				 */
-				blk_start = map_start;
-			} else
-				busy += end - start + 1;
+			busy += end - start + 1;
 		} else if (map_start > start && map_start < end) {
 			/* total eclipse of the mapping */
 			busy += nd_mapping->size;
-			blk_start = map_start;
 		}
 	}
 
-	*overlap = map_end + 1 - blk_start;
-	available = blk_start - map_start;
-	if (busy < available)
-		return ALIGN_DOWN(available - busy, align);
-	return 0;
-
- err:
-	nd_dbg_dpa(nd_region, ndd, res, "%s\n", reason);
+	if (busy < nd_mapping->size)
+		return ALIGN_DOWN(nd_mapping->size - busy, align);
 	return 0;
 }
 
@@ -999,7 +823,7 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 /**
  * nvdimm_allocated_dpa - sum up the dpa currently allocated to this label_id
  * @nvdimm: container of dpa-resource-root + labels
- * @label_id: dpa resource name of the form {pmem|blk}-<human readable uuid>
+ * @label_id: dpa resource name of the form pmem-<human readable uuid>
  */
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id)
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 8c972bcb2ac3..082253a3a956 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -334,8 +334,7 @@ char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
 {
 	if (!label_id || !uuid)
 		return NULL;
-	snprintf(label_id->id, ND_LABEL_ID_SIZE, "%s-%pUb",
-			flags & NSLABEL_FLAG_LOCAL ? "blk" : "pmem", uuid);
+	snprintf(label_id->id, ND_LABEL_ID_SIZE, "pmem-%pUb", uuid);
 	return label_id->id;
 }
 
@@ -406,7 +405,6 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		return 0; /* no label, nothing to reserve */
 
 	for_each_clear_bit_le(slot, free, nslot) {
-		struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
 		struct nd_namespace_label *nd_label;
 		struct nd_region *nd_region = NULL;
 		struct nd_label_id label_id;
@@ -421,8 +419,6 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 
 		nsl_get_uuid(ndd, nd_label, &label_uuid);
 		flags = nsl_get_flags(ndd, nd_label);
-		if (test_bit(NDD_NOBLK, &nvdimm->flags))
-			flags &= ~NSLABEL_FLAG_LOCAL;
 		nd_label_gen_id(&label_id, &label_uuid, flags);
 		res = nvdimm_allocate_dpa(ndd, &label_id,
 					  nsl_get_dpa(ndd, nd_label),
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 198ef1df298b..0650fb4b9821 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -193,7 +193,7 @@ struct nd_namespace_label {
 
 /**
  * struct nd_label_id - identifier string for dpa allocation
- * @id: "{blk|pmem}-<namespace uuid>"
+ * @id: "pmem-<namespace uuid>"
  */
 struct nd_label_id {
 	char id[ND_LABEL_ID_SIZE];
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index d1c190b02657..62b83b2e26e3 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -297,13 +297,11 @@ static int scan_free(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_label_id *label_id,
 		resource_size_t n)
 {
-	bool is_blk = strncmp(label_id->id, "blk", 3) == 0;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	int rc = 0;
 
 	while (n) {
 		struct resource *res, *last;
-		resource_size_t new_start;
 
 		last = NULL;
 		for_each_dpa_resource(ndd, res)
@@ -321,16 +319,7 @@ static int scan_free(struct nd_region *nd_region,
 			continue;
 		}
 
-		/*
-		 * Keep BLK allocations relegated to high DPA as much as
-		 * possible
-		 */
-		if (is_blk)
-			new_start = res->start + n;
-		else
-			new_start = res->start;
-
-		rc = adjust_resource(res, new_start, resource_size(res) - n);
+		rc = adjust_resource(res, res->start, resource_size(res) - n);
 		if (rc == 0)
 			res->flags |= DPA_RESOURCE_ADJUSTED;
 		nd_dbg_dpa(nd_region, ndd, res, "shrink %d\n", rc);
@@ -372,20 +361,12 @@ static resource_size_t init_dpa_allocation(struct nd_label_id *label_id,
 		struct nd_region *nd_region, struct nd_mapping *nd_mapping,
 		resource_size_t n)
 {
-	bool is_blk = strncmp(label_id->id, "blk", 3) == 0;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	resource_size_t first_dpa;
 	struct resource *res;
 	int rc = 0;
 
-	/* allocate blk from highest dpa first */
-	if (is_blk)
-		first_dpa = nd_mapping->start + nd_mapping->size - n;
-	else
-		first_dpa = nd_mapping->start;
-
 	/* first resource allocation for this label-id or dimm */
-	res = nvdimm_allocate_dpa(ndd, label_id, first_dpa, n);
+	res = nvdimm_allocate_dpa(ndd, label_id, nd_mapping->start, n);
 	if (!res)
 		rc = -EBUSY;
 
@@ -416,7 +397,6 @@ static void space_valid(struct nd_region *nd_region, struct nvdimm_drvdata *ndd,
 		resource_size_t n, struct resource *valid)
 {
 	bool is_reserve = strcmp(label_id->id, "pmem-reserve") == 0;
-	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
 	unsigned long align;
 
 	align = nd_region->align / nd_region->ndr_mappings;
@@ -429,21 +409,6 @@ static void space_valid(struct nd_region *nd_region, struct nvdimm_drvdata *ndd,
 	if (is_reserve)
 		return;
 
-	if (!is_pmem) {
-		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
-		struct nvdimm_bus *nvdimm_bus;
-		struct blk_alloc_info info = {
-			.nd_mapping = nd_mapping,
-			.available = nd_mapping->size,
-			.res = valid,
-		};
-
-		WARN_ON(!is_nd_blk(&nd_region->dev));
-		nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
-		device_for_each_child(&nvdimm_bus->dev, &info, alias_dpa_busy);
-		return;
-	}
-
 	/* allocation needs to be contiguous, so this is all or nothing */
 	if (resource_size(valid) < n)
 		goto invalid;
@@ -471,7 +436,6 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		resource_size_t n)
 {
 	resource_size_t mapping_end = nd_mapping->start + nd_mapping->size - 1;
-	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct resource *res, *exist = NULL, valid;
 	const resource_size_t to_allocate = n;
@@ -569,10 +533,6 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		}
 
 		if (strcmp(action, "allocate") == 0) {
-			/* BLK allocate bottom up */
-			if (!is_pmem)
-				valid.start += available - allocate;
-
 			new_res = nvdimm_allocate_dpa(ndd, label_id,
 					valid.start, allocate);
 			if (!new_res)
@@ -608,12 +568,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 			return 0;
 	}
 
-	/*
-	 * If we allocated nothing in the BLK case it may be because we are in
-	 * an initial "pmem-reserve pass".  Only do an initial BLK allocation
-	 * when none of the DPA space is reserved.
-	 */
-	if ((is_pmem || !ndd->dpa.child) && n == to_allocate)
+	if (n == to_allocate)
 		return init_dpa_allocation(label_id, nd_region, nd_mapping, n);
 	return n;
 }
@@ -672,7 +627,7 @@ int __reserve_free_pmem(struct device *dev, void *data)
 		if (nd_mapping->nvdimm != nvdimm)
 			continue;
 
-		n = nd_pmem_available_dpa(nd_region, nd_mapping, &rem);
+		n = nd_pmem_available_dpa(nd_region, nd_mapping);
 		if (n == 0)
 			return 0;
 		rem = scan_allocate(nd_region, nd_mapping, &label_id, n);
@@ -697,19 +652,6 @@ void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
 			nvdimm_free_dpa(ndd, res);
 }
 
-static int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
-		struct nd_mapping *nd_mapping)
-{
-	struct nvdimm *nvdimm = nd_mapping->nvdimm;
-	int rc;
-
-	rc = device_for_each_child(&nvdimm_bus->dev, nvdimm,
-			__reserve_free_pmem);
-	if (rc)
-		release_free_pmem(nvdimm_bus, nd_mapping);
-	return rc;
-}
-
 /**
  * grow_dpa_allocation - for each dimm allocate n bytes for @label_id
  * @nd_region: the set of dimms to allocate @n more bytes from
@@ -726,37 +668,14 @@ static int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
 static int grow_dpa_allocation(struct nd_region *nd_region,
 		struct nd_label_id *label_id, resource_size_t n)
 {
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
-	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
 	int i;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		resource_size_t rem = n;
-		int rc, j;
-
-		/*
-		 * In the BLK case try once with all unallocated PMEM
-		 * reserved, and once without
-		 */
-		for (j = is_pmem; j < 2; j++) {
-			bool blk_only = j == 0;
-
-			if (blk_only) {
-				rc = reserve_free_pmem(nvdimm_bus, nd_mapping);
-				if (rc)
-					return rc;
-			}
-			rem = scan_allocate(nd_region, nd_mapping,
-					label_id, rem);
-			if (blk_only)
-				release_free_pmem(nvdimm_bus, nd_mapping);
-
-			/* try again and allow encroachments into PMEM */
-			if (rem == 0)
-				break;
-		}
+		int rc;
 
+		rem = scan_allocate(nd_region, nd_mapping, label_id, rem);
 		dev_WARN_ONCE(&nd_region->dev, rem,
 				"allocation underrun: %#llx of %#llx bytes\n",
 				(unsigned long long) n - rem,
@@ -869,8 +788,8 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 		ndd = to_ndd(nd_mapping);
 
 		/*
-		 * All dimms in an interleave set, or the base dimm for a blk
-		 * region, need to be enabled for the size to be changed.
+		 * All dimms in an interleave set, need to be enabled
+		 * for the size to be changed.
 		 */
 		if (!ndd)
 			return -ENXIO;
@@ -1169,9 +1088,6 @@ static ssize_t resource_show(struct device *dev,
 }
 static DEVICE_ATTR_ADMIN_RO(resource);
 
-static const unsigned long blk_lbasize_supported[] = { 512, 520, 528,
-	4096, 4104, 4160, 4224, 0 };
-
 static const unsigned long pmem_lbasize_supported[] = { 512, 4096, 0 };
 
 static ssize_t sector_size_show(struct device *dev,
@@ -1823,10 +1739,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	/*
 	 * Fix up each mapping's 'labels' to have the validated pmem label for
 	 * that position at labels[0], and NULL at labels[1].  In the process,
-	 * check that the namespace aligns with interleave-set.  We know
-	 * that it does not overlap with any blk namespaces by virtue of
-	 * the dimm being enabled (i.e. nd_label_reserve_dpa()
-	 * succeeded).
+	 * check that the namespace aligns with interleave-set.
 	 */
 	nsl_get_uuid(ndd, nd_label, &uuid);
 	rc = select_pmem_id(nd_region, &uuid);
@@ -1931,8 +1844,7 @@ void nd_region_create_ns_seed(struct nd_region *nd_region)
 	 * disabled until memory becomes available
 	 */
 	if (!nd_region->ns_seed)
-		dev_err(&nd_region->dev, "failed to create %s namespace\n",
-				is_nd_blk(&nd_region->dev) ? "blk" : "pmem");
+		dev_err(&nd_region->dev, "failed to create namespace\n");
 	else
 		nd_device_register(nd_region->ns_seed);
 }
@@ -2028,16 +1940,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
 		struct nd_namespace_label *nd_label = label_ent->label;
 		struct device **__devs;
-		u32 flags;
 
 		if (!nd_label)
 			continue;
-		flags = nsl_get_flags(ndd, nd_label);
-		if (is_nd_blk(&nd_region->dev)
-				== !!(flags & NSLABEL_FLAG_LOCAL))
-			/* pass, region matches label type */;
-		else
-			continue;
 
 		/* skip labels that describe extents outside of the region */
 		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
@@ -2073,9 +1978,8 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 	}
 
-	dev_dbg(&nd_region->dev, "discovered %d %s namespace%s\n",
-			count, is_nd_blk(&nd_region->dev)
-			? "blk" : "pmem", count == 1 ? "" : "s");
+	dev_dbg(&nd_region->dev, "discovered %d namespace%s\n", count,
+		count == 1 ? "" : "s");
 
 	if (count == 0) {
 		struct nd_namespace_pmem *nspm;
@@ -2226,12 +2130,6 @@ static int init_active_labels(struct nd_region *nd_region)
 			if (!label_ent)
 				break;
 			label = nd_label_active(ndd, j);
-			if (test_bit(NDD_NOBLK, &nvdimm->flags)) {
-				u32 flags = nsl_get_flags(ndd, label);
-
-				flags &= ~NSLABEL_FLAG_LOCAL;
-				nsl_set_flags(ndd, label, flags);
-			}
 			label_ent->label = label;
 
 			mutex_lock(&nd_mapping->lock);
@@ -2275,7 +2173,6 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 		devs = create_namespace_io(nd_region);
 		break;
 	case ND_DEVICE_NAMESPACE_PMEM:
-	case ND_DEVICE_NAMESPACE_BLK:
 		devs = create_namespaces(nd_region);
 		break;
 	default:
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index e4af0719cf33..17febf9ac911 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -82,30 +82,12 @@ static inline void nvdimm_security_overwrite_query(struct work_struct *work)
 }
 #endif
 
-/**
- * struct blk_alloc_info - tracking info for BLK dpa scanning
- * @nd_mapping: blk region mapping boundaries
- * @available: decremented in alias_dpa_busy as aliased PMEM is scanned
- * @busy: decremented in blk_dpa_busy to account for ranges already
- * 	  handled by alias_dpa_busy
- * @res: alias_dpa_busy interprets this a free space range that needs to
- * 	 be truncated to the valid BLK allocation starting DPA, blk_dpa_busy
- * 	 treats it as a busy range that needs the aliased PMEM ranges
- * 	 truncated.
- */
-struct blk_alloc_info {
-	struct nd_mapping *nd_mapping;
-	resource_size_t available, busy;
-	struct resource *res;
-};
-
 bool is_nvdimm(struct device *dev);
 bool is_nd_pmem(struct device *dev);
 bool is_nd_volatile(struct device *dev);
-bool is_nd_blk(struct device *dev);
 static inline bool is_nd_region(struct device *dev)
 {
-	return is_nd_pmem(dev) || is_nd_blk(dev) || is_nd_volatile(dev);
+	return is_nd_pmem(dev) || is_nd_volatile(dev);
 }
 static inline bool is_memory(struct device *dev)
 {
@@ -142,14 +124,12 @@ resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
 					   struct nd_mapping *nd_mapping);
 resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
-		struct nd_mapping *nd_mapping, resource_size_t *overlap);
-resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
+				      struct nd_mapping *nd_mapping);
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
 int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
 		resource_size_t size);
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id);
-int alias_dpa_busy(struct device *dev, void *data);
 int nvdimm_num_label_slots(struct nvdimm_drvdata *ndd);
 void get_ndd(struct nvdimm_drvdata *ndd);
 resource_size_t __nvdimm_namespace_capacity(struct nd_namespace_common *ndns);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 8391bf2729bc..ec5219680092 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -295,9 +295,6 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
 	return nd_label->efi.uuid;
 }
 
-bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
-				 struct nd_namespace_label *nd_label,
-				 u64 isetcookie);
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
@@ -437,14 +434,6 @@ static inline bool nsl_validate_nlabel(struct nd_region *nd_region,
 	return nsl_get_nlabel(ndd, nd_label) == nd_region->ndr_mappings;
 }
 
-struct nd_blk_region {
-	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
-	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
-			void *iobuf, u64 len, int rw);
-	void *blk_provider_data;
-	struct nd_region nd_region;
-};
-
 /*
  * Lookup next in the repeating sequence of 01, 10, and 11.
  */
@@ -672,7 +661,6 @@ static inline int nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 	return -ENXIO;
 }
 #endif
-int nd_blk_region_init(struct nd_region *nd_region);
 int nd_region_activate(struct nd_region *nd_region);
 static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 		unsigned int len)
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index e0c34120df37..188560b1c110 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -15,6 +15,10 @@ static int nd_region_probe(struct device *dev)
 	static unsigned long once;
 	struct nd_region_data *ndrd;
 	struct nd_region *nd_region = to_nd_region(dev);
+	struct range range = {
+		.start = nd_region->ndr_start,
+		.end = nd_region->ndr_start + nd_region->ndr_size - 1,
+	};
 
 	if (nd_region->num_lanes > num_online_cpus()
 			&& nd_region->num_lanes < num_possible_cpus()
@@ -30,25 +34,13 @@ static int nd_region_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	rc = nd_blk_region_init(nd_region);
-	if (rc)
-		return rc;
-
-	if (is_memory(&nd_region->dev)) {
-		struct range range = {
-			.start = nd_region->ndr_start,
-			.end = nd_region->ndr_start + nd_region->ndr_size - 1,
-		};
-
-		if (devm_init_badblocks(dev, &nd_region->bb))
-			return -ENODEV;
-		nd_region->bb_state = sysfs_get_dirent(nd_region->dev.kobj.sd,
-						       "badblocks");
-		if (!nd_region->bb_state)
-			dev_warn(&nd_region->dev,
-					"'badblocks' notification disabled\n");
-		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &range);
-	}
+	if (devm_init_badblocks(dev, &nd_region->bb))
+		return -ENODEV;
+	nd_region->bb_state =
+		sysfs_get_dirent(nd_region->dev.kobj.sd, "badblocks");
+	if (!nd_region->bb_state)
+		dev_warn(dev, "'badblocks' notification disabled\n");
+	nvdimm_badblocks_populate(nd_region, &nd_region->bb, &range);
 
 	rc = nd_region_register_namespaces(nd_region, &err);
 	if (rc < 0)
@@ -158,4 +150,3 @@ void nd_region_exit(void)
 }
 
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_PMEM);
-MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_BLK);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 70ad891a76ba..0cb274c2b508 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -134,10 +134,7 @@ static void nd_region_release(struct device *dev)
 	}
 	free_percpu(nd_region->lane);
 	memregion_free(nd_region->id);
-	if (is_nd_blk(dev))
-		kfree(to_nd_blk_region(dev));
-	else
-		kfree(nd_region);
+	kfree(nd_region);
 }
 
 struct nd_region *to_nd_region(struct device *dev)
@@ -157,33 +154,12 @@ struct device *nd_region_dev(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(nd_region_dev);
 
-struct nd_blk_region *to_nd_blk_region(struct device *dev)
-{
-	struct nd_region *nd_region = to_nd_region(dev);
-
-	WARN_ON(!is_nd_blk(dev));
-	return container_of(nd_region, struct nd_blk_region, nd_region);
-}
-EXPORT_SYMBOL_GPL(to_nd_blk_region);
-
 void *nd_region_provider_data(struct nd_region *nd_region)
 {
 	return nd_region->provider_data;
 }
 EXPORT_SYMBOL_GPL(nd_region_provider_data);
 
-void *nd_blk_region_provider_data(struct nd_blk_region *ndbr)
-{
-	return ndbr->blk_provider_data;
-}
-EXPORT_SYMBOL_GPL(nd_blk_region_provider_data);
-
-void nd_blk_region_set_provider_data(struct nd_blk_region *ndbr, void *data)
-{
-	ndbr->blk_provider_data = data;
-}
-EXPORT_SYMBOL_GPL(nd_blk_region_set_provider_data);
-
 /**
  * nd_region_to_nstype() - region to an integer namespace type
  * @nd_region: region-device to interrogate
@@ -208,8 +184,6 @@ int nd_region_to_nstype(struct nd_region *nd_region)
 			return ND_DEVICE_NAMESPACE_PMEM;
 		else
 			return ND_DEVICE_NAMESPACE_IO;
-	} else if (is_nd_blk(&nd_region->dev)) {
-		return ND_DEVICE_NAMESPACE_BLK;
 	}
 
 	return 0;
@@ -332,14 +306,12 @@ static DEVICE_ATTR_RO(set_cookie);
 
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 {
-	resource_size_t blk_max_overlap = 0, available, overlap;
+	resource_size_t available;
 	int i;
 
 	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
 
- retry:
 	available = 0;
-	overlap = blk_max_overlap;
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
@@ -348,15 +320,7 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 		if (!ndd)
 			return 0;
 
-		if (is_memory(&nd_region->dev)) {
-			available += nd_pmem_available_dpa(nd_region,
-					nd_mapping, &overlap);
-			if (overlap > blk_max_overlap) {
-				blk_max_overlap = overlap;
-				goto retry;
-			}
-		} else if (is_nd_blk(&nd_region->dev))
-			available += nd_blk_available_dpa(nd_region);
+		available += nd_pmem_available_dpa(nd_region, nd_mapping);
 	}
 
 	return available;
@@ -364,26 +328,17 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 
 resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region)
 {
-	resource_size_t available = 0;
+	resource_size_t avail = 0;
 	int i;
 
-	if (is_memory(&nd_region->dev))
-		available = PHYS_ADDR_MAX;
-
 	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 
-		if (is_memory(&nd_region->dev))
-			available = min(available,
-					nd_pmem_max_contiguous_dpa(nd_region,
-								   nd_mapping));
-		else if (is_nd_blk(&nd_region->dev))
-			available += nd_blk_available_dpa(nd_region);
+		avail = min_not_zero(avail, nd_pmem_max_contiguous_dpa(
+						    nd_region, nd_mapping));
 	}
-	if (is_memory(&nd_region->dev))
-		return available * nd_region->ndr_mappings;
-	return available;
+	return avail * nd_region->ndr_mappings;
 }
 
 static ssize_t available_size_show(struct device *dev,
@@ -693,9 +648,8 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;
 
-	if ((type == ND_DEVICE_NAMESPACE_PMEM
-				|| type == ND_DEVICE_NAMESPACE_BLK)
-			&& a == &dev_attr_available_size.attr)
+	if (type == ND_DEVICE_NAMESPACE_PMEM &&
+	    a == &dev_attr_available_size.attr)
 		return a->mode;
 	else if (is_memory(dev) && nd_set)
 		return a->mode;
@@ -828,12 +782,6 @@ static const struct attribute_group *nd_region_attribute_groups[] = {
 	NULL,
 };
 
-static const struct device_type nd_blk_device_type = {
-	.name = "nd_blk",
-	.release = nd_region_release,
-	.groups = nd_region_attribute_groups,
-};
-
 static const struct device_type nd_pmem_device_type = {
 	.name = "nd_pmem",
 	.release = nd_region_release,
@@ -851,11 +799,6 @@ bool is_nd_pmem(struct device *dev)
 	return dev ? dev->type == &nd_pmem_device_type : false;
 }
 
-bool is_nd_blk(struct device *dev)
-{
-	return dev ? dev->type == &nd_blk_device_type : false;
-}
-
 bool is_nd_volatile(struct device *dev)
 {
 	return dev ? dev->type == &nd_volatile_device_type : false;
@@ -929,22 +872,6 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 	nvdimm_bus_unlock(dev);
 }
 
-int nd_blk_region_init(struct nd_region *nd_region)
-{
-	struct device *dev = &nd_region->dev;
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-
-	if (!is_nd_blk(dev))
-		return 0;
-
-	if (nd_region->ndr_mappings < 1) {
-		dev_dbg(dev, "invalid BLK region\n");
-		return -ENXIO;
-	}
-
-	return to_nd_blk_region(dev)->enable(nvdimm_bus, dev);
-}
-
 /**
  * nd_region_acquire_lane - allocate and lock a lane
  * @nd_region: region id and number of lanes possible
@@ -1007,24 +934,10 @@ EXPORT_SYMBOL(nd_region_release_lane);
 static unsigned long default_align(struct nd_region *nd_region)
 {
 	unsigned long align;
-	int i, mappings;
 	u32 remainder;
+	int mappings;
 
-	if (is_nd_blk(&nd_region->dev))
-		align = PAGE_SIZE;
-	else
-		align = MEMREMAP_COMPAT_ALIGN_MAX;
-
-	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-		struct nvdimm *nvdimm = nd_mapping->nvdimm;
-
-		if (test_bit(NDD_ALIASING, &nvdimm->flags)) {
-			align = MEMREMAP_COMPAT_ALIGN_MAX;
-			break;
-		}
-	}
-
+	align = MEMREMAP_COMPAT_ALIGN_MAX;
 	if (nd_region->ndr_size < MEMREMAP_COMPAT_ALIGN_MAX)
 		align = PAGE_SIZE;
 
@@ -1042,7 +955,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 {
 	struct nd_region *nd_region;
 	struct device *dev;
-	void *region_buf;
 	unsigned int i;
 	int ro = 0;
 
@@ -1060,36 +972,13 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		if (test_bit(NDD_UNARMED, &nvdimm->flags))
 			ro = 1;
 
-		if (test_bit(NDD_NOBLK, &nvdimm->flags)
-				&& dev_type == &nd_blk_device_type) {
-			dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not BLK capable\n",
-					caller, dev_name(&nvdimm->dev), i);
-			return NULL;
-		}
 	}
 
-	if (dev_type == &nd_blk_device_type) {
-		struct nd_blk_region_desc *ndbr_desc;
-		struct nd_blk_region *ndbr;
-
-		ndbr_desc = to_blk_region_desc(ndr_desc);
-		ndbr = kzalloc(sizeof(*ndbr) + sizeof(struct nd_mapping)
-				* ndr_desc->num_mappings,
-				GFP_KERNEL);
-		if (ndbr) {
-			nd_region = &ndbr->nd_region;
-			ndbr->enable = ndbr_desc->enable;
-			ndbr->do_io = ndbr_desc->do_io;
-		}
-		region_buf = ndbr;
-	} else {
-		nd_region = kzalloc(struct_size(nd_region, mapping,
-						ndr_desc->num_mappings),
-				    GFP_KERNEL);
-		region_buf = nd_region;
-	}
+	nd_region =
+		kzalloc(struct_size(nd_region, mapping, ndr_desc->num_mappings),
+			GFP_KERNEL);
 
-	if (!region_buf)
+	if (!nd_region)
 		return NULL;
 	nd_region->id = memregion_alloc(GFP_KERNEL);
 	if (nd_region->id < 0)
@@ -1153,7 +1042,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
  err_percpu:
 	memregion_free(nd_region->id);
  err_id:
-	kfree(region_buf);
+	kfree(nd_region);
 	return NULL;
 }
 
@@ -1166,17 +1055,6 @@ struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(nvdimm_pmem_region_create);
 
-struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
-		struct nd_region_desc *ndr_desc)
-{
-	if (ndr_desc->num_mappings > 1)
-		return NULL;
-	ndr_desc->num_lanes = min(ndr_desc->num_lanes, ND_MAX_LANES);
-	return nd_region_create(nvdimm_bus, ndr_desc, &nd_blk_device_type,
-			__func__);
-}
-EXPORT_SYMBOL_GPL(nvdimm_blk_region_create);
-
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc)
 {
@@ -1201,7 +1079,7 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 }
 /**
  * nvdimm_flush - flush any posted write queues between the cpu and pmem media
- * @nd_region: blk or interleaved pmem region
+ * @nd_region: interleaved pmem region
  */
 int generic_nvdimm_flush(struct nd_region *nd_region)
 {
@@ -1234,7 +1112,7 @@ EXPORT_SYMBOL_GPL(nvdimm_flush);
 
 /**
  * nvdimm_has_flush - determine write flushing requirements
- * @nd_region: blk or interleaved pmem region
+ * @nd_region: interleaved pmem region
  *
  * Returns 1 if writes require flushing
  * Returns 0 if writes do not require flushing
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 7074aa9af525..0d61e07b6827 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -25,8 +25,6 @@ struct badrange {
 };
 
 enum {
-	/* when a dimm supports both PMEM and BLK access a label is required */
-	NDD_ALIASING = 0,
 	/* unarmed memory devices may not persist writes */
 	NDD_UNARMED = 1,
 	/* locked memory devices should not be accessed */
@@ -35,8 +33,6 @@ enum {
 	NDD_SECURITY_OVERWRITE = 3,
 	/*  tracking whether or not there is a pending device reference */
 	NDD_WORK_PENDING = 4,
-	/* ignore / filter NSLABEL_FLAG_LOCAL for this DIMM, i.e. no aliasing */
-	NDD_NOBLK = 5,
 	/* dimm supports namespace labels */
 	NDD_LABELING = 6,
 
@@ -140,21 +136,6 @@ static inline void __iomem *devm_nvdimm_ioremap(struct device *dev,
 }
 
 struct nvdimm_bus;
-struct module;
-struct nd_blk_region;
-struct nd_blk_region_desc {
-	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
-	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
-			void *iobuf, u64 len, int rw);
-	struct nd_region_desc ndr_desc;
-};
-
-static inline struct nd_blk_region_desc *to_blk_region_desc(
-		struct nd_region_desc *ndr_desc)
-{
-	return container_of(ndr_desc, struct nd_blk_region_desc, ndr_desc);
-
-}
 
 /*
  * Note that separate bits for locked + unlocked are defined so that
@@ -257,7 +238,6 @@ struct nvdimm_bus *nvdimm_to_bus(struct nvdimm *nvdimm);
 struct nvdimm *to_nvdimm(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
 struct device *nd_region_dev(struct nd_region *nd_region);
-struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
@@ -295,10 +275,6 @@ struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
 void *nd_region_provider_data(struct nd_region *nd_region);
-void *nd_blk_region_provider_data(struct nd_blk_region *ndbr);
-void nd_blk_region_set_provider_data(struct nd_blk_region *ndbr, void *data);
-struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr);
-unsigned long nd_blk_memremap_flags(struct nd_blk_region *ndbr);
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 8cf1e4884fd5..17e02b64ea2e 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -189,7 +189,6 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of BLK namespaces) */
 #define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
 #define ND_DEVICE_NAMESPACE_PMEM 5  /* PMEM namespace (may alias with BLK) */
-#define ND_DEVICE_NAMESPACE_BLK 6   /* BLK namespace (may alias with PMEM) */
 #define ND_DEVICE_DAX_PMEM 7        /* Device DAX interface to pmem */
 
 enum nd_driver_flags {
@@ -198,7 +197,6 @@ enum nd_driver_flags {
 	ND_DRIVER_REGION_BLK      = 1 << ND_DEVICE_REGION_BLK,
 	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
 	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
-	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
 	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
 
diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 3ca7c32e9362..4d1a947367f9 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -338,62 +338,6 @@ static int ndtest_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
-static int ndtest_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
-		void *iobuf, u64 len, int rw)
-{
-	struct ndtest_dimm *dimm = ndbr->blk_provider_data;
-	struct ndtest_blk_mmio *mmio = dimm->mmio;
-	struct nd_region *nd_region = &ndbr->nd_region;
-	unsigned int lane;
-
-	if (!mmio)
-		return -ENOMEM;
-
-	lane = nd_region_acquire_lane(nd_region);
-	if (rw)
-		memcpy(mmio->base + dpa, iobuf, len);
-	else {
-		memcpy(iobuf, mmio->base + dpa, len);
-		arch_invalidate_pmem(mmio->base + dpa, len);
-	}
-
-	nd_region_release_lane(nd_region, lane);
-
-	return 0;
-}
-
-static int ndtest_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
-				    struct device *dev)
-{
-	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
-	struct nvdimm *nvdimm;
-	struct ndtest_dimm *dimm;
-	struct ndtest_blk_mmio *mmio;
-
-	nvdimm = nd_blk_region_to_dimm(ndbr);
-	dimm = nvdimm_provider_data(nvdimm);
-
-	nd_blk_region_set_provider_data(ndbr, dimm);
-	dimm->blk_region = to_nd_region(dev);
-
-	mmio = devm_kzalloc(dev, sizeof(struct ndtest_blk_mmio), GFP_KERNEL);
-	if (!mmio)
-		return -ENOMEM;
-
-	mmio->base = (void __iomem *) devm_nvdimm_memremap(
-		dev, dimm->address, 12, nd_blk_memremap_flags(ndbr));
-	if (!mmio->base) {
-		dev_err(dev, "%s failed to map blk dimm\n", nvdimm_name(nvdimm));
-		return -ENOMEM;
-	}
-	mmio->size = dimm->size;
-	mmio->base_offset = 0;
-
-	dimm->mmio = mmio;
-
-	return 0;
-}
-
 static struct nfit_test_resource *ndtest_resource_lookup(resource_size_t addr)
 {
 	int i;
@@ -523,17 +467,16 @@ static int ndtest_create_region(struct ndtest_priv *p,
 				struct ndtest_region *region)
 {
 	struct nd_mapping_desc mappings[NDTEST_MAX_MAPPING];
-	struct nd_blk_region_desc ndbr_desc;
+	struct nd_region_desc *ndr_desc, _ndr_desc;
 	struct nd_interleave_set *nd_set;
-	struct nd_region_desc *ndr_desc;
 	struct resource res;
 	int i, ndimm = region->mapping[0].dimm;
 	u64 uuid[2];
 
 	memset(&res, 0, sizeof(res));
 	memset(&mappings, 0, sizeof(mappings));
-	memset(&ndbr_desc, 0, sizeof(ndbr_desc));
-	ndr_desc = &ndbr_desc.ndr_desc;
+	memset(&_ndr_desc, 0, sizeof(_ndr_desc));
+	ndr_desc = &_ndr_desc;
 
 	if (!ndtest_alloc_resource(p, region->size, &res.start))
 		return -ENOMEM;
@@ -857,10 +800,8 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
 	struct device *dev = &priv->pdev.dev;
 	unsigned long dimm_flags = dimm->flags;
 
-	if (dimm->num_formats > 1) {
-		set_bit(NDD_ALIASING, &dimm_flags);
+	if (dimm->num_formats > 1)
 		set_bit(NDD_LABELING, &dimm_flags);
-	}
 
 	if (dimm->flags & PAPR_PMEM_UNARMED_MASK)
 		set_bit(NDD_UNARMED, &dimm_flags);


