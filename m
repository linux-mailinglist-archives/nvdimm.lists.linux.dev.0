Return-Path: <nvdimm+bounces-9299-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B43489C1052
	for <lists+linux-nvdimm@lfdr.de>; Thu,  7 Nov 2024 22:01:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D68C81C22ABA
	for <lists+linux-nvdimm@lfdr.de>; Thu,  7 Nov 2024 21:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A50218313;
	Thu,  7 Nov 2024 20:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DKABXUZl"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CF721B444
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013133; cv=none; b=G0wdgWfPy8GDzA+eQeISIzWf/koDzWEJ9menJ1BIiEOeWNe7QqZc0syIchoBQo0bTp7XXqkBn0B32/zrdzIBrq7xWWWPuCSrv88jHn61KJ5hiyQ2tuNNm14y1AIlQsm+b6OLK5jiz00OHxQvyc4+1Wd7vX53QJoRvv/FuZQwZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013133; c=relaxed/simple;
	bh=mP/39uB6KFgSJCccrYcbJwHbhU4pRB9iVaDNiG2eUEc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V/Cm1c1LtHZvs+w/IJRs0n17zpVHZ99zw3Z4PZ7nQGp900+/gOqe6nGHVwGRyDO/Cc0CVPCYSDutD1p9v4kiaKooALGnke8mCN1fVki8rlTG6epChoi/GPu0n0nGHrgOqzJUKfBhO/XMFUE52H7DRDDQGVcWCOauwOd/wipIAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DKABXUZl; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013131; x=1762549131;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=mP/39uB6KFgSJCccrYcbJwHbhU4pRB9iVaDNiG2eUEc=;
  b=DKABXUZljbOKYORfOipNfNcxuOn0C5GUQ0OLmviYsZwIB2nH+bnB5aSX
   aYHgku69KYwwaHLTKmwxlySe8/UuR19xuHY6WC4uY8khOt1v927f5oIPn
   qckyzg6nzywJAvpkuEwIUSkIEGFY0uefXzUsrUrYwxkZw8fHXKVpUDvIR
   wQkt54VWWjAmKFSfLg9LZYvZTG9kBOFgAVB/g8BUswq17HFyAtnwysGiW
   zY0vQ9X56LR6Kcz+r3Ux9eA8dA2/WZVNCjfuqgmUDfZJtaOn9mKOwLt3I
   IJDyS0xslN2kFrZCKUFgggHiiCRaTPz37xyxDBpnI7+XDHmvpCN7wjfcn
   A==;
X-CSE-ConnectionGUID: 7YqvJDl1TdGAzmpOHkao+Q==
X-CSE-MsgGUID: XaZRpEeNT/KF9eDNsWZfXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41440996"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41440996"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:50 -0800
X-CSE-ConnectionGUID: 4OIGDRDwQ6+rZQBfQxRvDA==
X-CSE-MsgGUID: ZabFLpwESY2qQ+uMAipGaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122745966"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:49 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:27 -0600
Subject: [PATCH v7 09/27] cxl/core: Separate region mode from decoder mode
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-9-56a84e66bc36@intel.com>
References: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
In-Reply-To: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Li Ming <ming4.li@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=11182;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=VIK7W0grb8am/P99hC4l92sVeGLL2N2lFNNyt2pqocQ=;
 b=BukvqYgzmGlAbB65ljUXpRIlXYfBuyQmrLxBpkCVfcdrzK1fbqGwl8Pe3oQjhAX6kss2OxsSP
 pbus6cHglmiA7BYxu0Wmjl08ESSw980MN0Gynry4S8krmKuwqwpbsQ7
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Until now region modes and decoder modes were equivalent in that both
modes were either PMEM or RAM.  The addition of Dynamic
Capacity partitions defines up to 8 DC partitions per device.

The region mode is thus no longer equivalent to the endpoint decoder
mode.  IOW the endpoint decoders may have modes of DC0-DC7 while the
region mode is simply DC.

Define a new region mode enumeration which applies to regions separate
from the decoder mode.  Adjust the code to process these modes
independently.

There is no equal to decoder mode dead in region modes.  Avoid
constructing regions with decoders which have been flagged as dead.

Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/cdat.c   |  6 ++--
 drivers/cxl/core/region.c | 77 ++++++++++++++++++++++++++++++++++-------------
 drivers/cxl/cxl.h         | 26 ++++++++++++++--
 3 files changed, 83 insertions(+), 26 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index ef1621d40f0542e85b01f243f888cd0368111885..b5d30c5bf1e20725d13b4397a7ba90662bcd8766 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -571,17 +571,17 @@ static bool dpa_perf_contains(struct cxl_dpa_perf *perf,
 }
 
 static struct cxl_dpa_perf *cxled_get_dpa_perf(struct cxl_endpoint_decoder *cxled,
-					       enum cxl_decoder_mode mode)
+					       enum cxl_region_mode mode)
 {
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
 	struct cxl_dpa_perf *perf;
 
 	switch (mode) {
-	case CXL_DECODER_RAM:
+	case CXL_REGION_RAM:
 		perf = &mds->ram_perf;
 		break;
-	case CXL_DECODER_PMEM:
+	case CXL_REGION_PMEM:
 		perf = &mds->pmem_perf;
 		break;
 	default:
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 02437e716b7e04493bb7a2b7d14649a2414c1cb7..b3beab787faeb552850ac3839472319fcf8f2835 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -144,7 +144,7 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 	rc = down_read_interruptible(&cxl_region_rwsem);
 	if (rc)
 		return rc;
-	if (cxlr->mode != CXL_DECODER_PMEM)
+	if (cxlr->mode != CXL_REGION_PMEM)
 		rc = sysfs_emit(buf, "\n");
 	else
 		rc = sysfs_emit(buf, "%pUb\n", &p->uuid);
@@ -457,7 +457,7 @@ static umode_t cxl_region_visible(struct kobject *kobj, struct attribute *a,
 	 * Support tooling that expects to find a 'uuid' attribute for all
 	 * regions regardless of mode.
 	 */
-	if (a == &dev_attr_uuid.attr && cxlr->mode != CXL_DECODER_PMEM)
+	if (a == &dev_attr_uuid.attr && cxlr->mode != CXL_REGION_PMEM)
 		return 0444;
 	return a->mode;
 }
@@ -620,7 +620,7 @@ static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
 
-	return sysfs_emit(buf, "%s\n", cxl_decoder_mode_name(cxlr->mode));
+	return sysfs_emit(buf, "%s\n", cxl_region_mode_name(cxlr->mode));
 }
 static DEVICE_ATTR_RO(mode);
 
@@ -646,7 +646,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
 
 	/* ways, granularity and uuid (if PMEM) need to be set before HPA */
 	if (!p->interleave_ways || !p->interleave_granularity ||
-	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
+	    (cxlr->mode == CXL_REGION_PMEM && uuid_is_null(&p->uuid)))
 		return -ENXIO;
 
 	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
@@ -1863,6 +1863,17 @@ static int cxl_region_sort_targets(struct cxl_region *cxlr)
 	return rc;
 }
 
+static bool cxl_modes_compatible(enum cxl_region_mode rmode,
+				 enum cxl_decoder_mode dmode)
+{
+	if (rmode == CXL_REGION_RAM && dmode == CXL_DECODER_RAM)
+		return true;
+	if (rmode == CXL_REGION_PMEM && dmode == CXL_DECODER_PMEM)
+		return true;
+
+	return false;
+}
+
 static int cxl_region_attach(struct cxl_region *cxlr,
 			     struct cxl_endpoint_decoder *cxled, int pos)
 {
@@ -1882,9 +1893,11 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		return rc;
 	}
 
-	if (cxled->mode != cxlr->mode) {
-		dev_dbg(&cxlr->dev, "%s region mode: %d mismatch: %d\n",
-			dev_name(&cxled->cxld.dev), cxlr->mode, cxled->mode);
+	if (!cxl_modes_compatible(cxlr->mode, cxled->mode)) {
+		dev_dbg(&cxlr->dev, "%s region mode: %s mismatch decoder: %s\n",
+			dev_name(&cxled->cxld.dev),
+			cxl_region_mode_name(cxlr->mode),
+			cxl_decoder_mode_name(cxled->mode));
 		return -EINVAL;
 	}
 
@@ -2446,7 +2459,7 @@ static int cxl_region_calculate_adistance(struct notifier_block *nb,
  * devm_cxl_add_region - Adds a region to a decoder
  * @cxlrd: root decoder
  * @id: memregion id to create, or memregion_free() on failure
- * @mode: mode for the endpoint decoders of this region
+ * @mode: mode of this region
  * @type: select whether this is an expander or accelerator (type-2 or type-3)
  *
  * This is the second step of region initialization. Regions exist within an
@@ -2457,7 +2470,7 @@ static int cxl_region_calculate_adistance(struct notifier_block *nb,
  */
 static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 					      int id,
-					      enum cxl_decoder_mode mode,
+					      enum cxl_region_mode mode,
 					      enum cxl_decoder_type type)
 {
 	struct cxl_port *port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
@@ -2511,16 +2524,17 @@ static ssize_t create_ram_region_show(struct device *dev,
 }
 
 static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
-					  enum cxl_decoder_mode mode, int id)
+					  enum cxl_region_mode mode, int id)
 {
 	int rc;
 
 	switch (mode) {
-	case CXL_DECODER_RAM:
-	case CXL_DECODER_PMEM:
+	case CXL_REGION_RAM:
+	case CXL_REGION_PMEM:
 		break;
 	default:
-		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
+		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %s\n",
+			cxl_region_mode_name(mode));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2537,7 +2551,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 }
 
 static ssize_t create_region_store(struct device *dev, const char *buf,
-				   size_t len, enum cxl_decoder_mode mode)
+				   size_t len, enum cxl_region_mode mode)
 {
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
 	struct cxl_region *cxlr;
@@ -2558,7 +2572,7 @@ static ssize_t create_pmem_region_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-	return create_region_store(dev, buf, len, CXL_DECODER_PMEM);
+	return create_region_store(dev, buf, len, CXL_REGION_PMEM);
 }
 DEVICE_ATTR_RW(create_pmem_region);
 
@@ -2566,7 +2580,7 @@ static ssize_t create_ram_region_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
-	return create_region_store(dev, buf, len, CXL_DECODER_RAM);
+	return create_region_store(dev, buf, len, CXL_REGION_RAM);
 }
 DEVICE_ATTR_RW(create_ram_region);
 
@@ -3209,6 +3223,22 @@ static int match_region_by_range(struct device *dev, void *data)
 	return rc;
 }
 
+static enum cxl_region_mode
+cxl_decoder_to_region_mode(enum cxl_decoder_mode mode)
+{
+	switch (mode) {
+	case CXL_DECODER_NONE:
+		return CXL_REGION_NONE;
+	case CXL_DECODER_RAM:
+		return CXL_REGION_RAM;
+	case CXL_DECODER_PMEM:
+		return CXL_REGION_PMEM;
+	case CXL_DECODER_MIXED:
+	default:
+		return CXL_REGION_MIXED;
+	}
+}
+
 /* Establish an empty region covering the given HPA range */
 static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 					   struct cxl_endpoint_decoder *cxled)
@@ -3217,12 +3247,17 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 	struct cxl_port *port = cxlrd_to_port(cxlrd);
 	struct range *hpa = &cxled->cxld.hpa_range;
 	struct cxl_region_params *p;
+	enum cxl_region_mode mode;
 	struct cxl_region *cxlr;
 	struct resource *res;
 	int rc;
 
+	if (cxled->mode == CXL_DECODER_DEAD)
+		return ERR_PTR(-EINVAL);
+
+	mode = cxl_decoder_to_region_mode(cxled->mode);
 	do {
-		cxlr = __create_region(cxlrd, cxled->mode,
+		cxlr = __create_region(cxlrd, mode,
 				       atomic_read(&cxlrd->region_id));
 	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
 
@@ -3425,9 +3460,9 @@ static int cxl_region_probe(struct device *dev)
 		return rc;
 
 	switch (cxlr->mode) {
-	case CXL_DECODER_PMEM:
+	case CXL_REGION_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);
-	case CXL_DECODER_RAM:
+	case CXL_REGION_RAM:
 		/*
 		 * The region can not be manged by CXL if any portion of
 		 * it is already online as 'System RAM'
@@ -3439,8 +3474,8 @@ static int cxl_region_probe(struct device *dev)
 			return 0;
 		return devm_cxl_add_dax_region(cxlr);
 	default:
-		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
-			cxlr->mode);
+		dev_dbg(&cxlr->dev, "unsupported region mode: %s\n",
+			cxl_region_mode_name(cxlr->mode));
 		return -ENXIO;
 	}
 }
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 0d8b810a51f04de299e88ee8b29136bff11ed93e..5d74eb4ffab3ea2656c8e3c0563b8d7b69d76232 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -388,6 +388,27 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 	return "mixed";
 }
 
+enum cxl_region_mode {
+	CXL_REGION_NONE,
+	CXL_REGION_RAM,
+	CXL_REGION_PMEM,
+	CXL_REGION_MIXED,
+};
+
+static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
+{
+	static const char * const names[] = {
+		[CXL_REGION_NONE] = "none",
+		[CXL_REGION_RAM] = "ram",
+		[CXL_REGION_PMEM] = "pmem",
+		[CXL_REGION_MIXED] = "mixed",
+	};
+
+	if (mode >= CXL_REGION_NONE && mode <= CXL_REGION_MIXED)
+		return names[mode];
+	return "mixed";
+}
+
 /*
  * Track whether this decoder is reserved for region autodiscovery, or
  * free for userspace provisioning.
@@ -515,7 +536,8 @@ struct cxl_region_params {
  * struct cxl_region - CXL region
  * @dev: This region's device
  * @id: This region's id. Id is globally unique across all regions
- * @mode: Endpoint decoder allocation / access mode
+ * @mode: Region mode which defines which endpoint decoder modes the region is
+ *        compatible with
  * @type: Endpoint decoder target type
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
@@ -528,7 +550,7 @@ struct cxl_region_params {
 struct cxl_region {
 	struct device dev;
 	int id;
-	enum cxl_decoder_mode mode;
+	enum cxl_region_mode mode;
 	enum cxl_decoder_type type;
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;

-- 
2.47.0


