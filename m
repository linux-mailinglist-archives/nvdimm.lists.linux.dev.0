Return-Path: <nvdimm+bounces-9361-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2A29CF446
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Nov 2024 19:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27869B3ED6F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Nov 2024 18:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13431E0DBE;
	Fri, 15 Nov 2024 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nj8CcPFY"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6411D9346
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696050; cv=none; b=sDjkdpn6+MtQj3+ZaGNSGJYUfzlzhOUOKWrzlx44KZ6u5aMsXUl4ziMq3bKeI8/Iz/mnIjXLTKC1mVj0q2/2nkpUIP4MPpT/NKEPZmVu11q3MeTyH17Blpo+A3D41BPrq7zqDGty+uHfhMROBLYx8fgDwRVi1Hj+dMrXH1FXGog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696050; c=relaxed/simple;
	bh=nX4+TBmzT/8S/6xSSe7TLFYuuRvqvwN/md0J6OgzWuI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KXiAP/iRYwRxCCLoybs4m6IEsQ7fIU9N8pHfuALuH2tkqNMHg3yr3cjZENBSavn5QcvHWVlVgYet5UIps3kFl3RUKBXOMA8qJxjc3GgMnntOsc06sPf884RDt6/mrcSZnuSG3/r9riOaoXQueVQhDBHM0++iYN0bc3aqI3/Dgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nj8CcPFY; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696048; x=1763232048;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=nX4+TBmzT/8S/6xSSe7TLFYuuRvqvwN/md0J6OgzWuI=;
  b=Nj8CcPFY3skRN6hBe3A3J2K+SbpSQRrPqkPfZqoWZMVPBp9ibphEr66r
   5NB4JJhLjZa2AUQeCtCcI7Cmxq4bM3NFKrqH1iuvvgshdiJ+EwcZrfdGp
   mvGAru+Yn85ual40avC71wwulY5go859Ai1TT0deT0REthdU97nIyVIkc
   eWuT8544hXacLOd9tAyiVa3wKeLGrEvnptCqX0+dEFKda21kmtS8R4JwU
   wBa6h4G95jPuA+oH42nQB+5FHtSDwmL4465/Hsn3TnIkU9tl6GuDkYjLj
   PziPJC08yQBQ8FsG9K9KHr3lTCyC/Rzoj1sMugejxfDMBt3AxY+DdWy9H
   A==;
X-CSE-ConnectionGUID: mKi74f82SeuEQIOLbu342A==
X-CSE-MsgGUID: BaM2WLdUSMaWa2Z5uAUzOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31127893"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31127893"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:43 -0800
X-CSE-ConnectionGUID: dAwR9vm+RFeOkHCQBEZi6g==
X-CSE-MsgGUID: N1gTmxJ5RDqeo2FeBSoKOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="88522617"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:42 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 15 Nov 2024 12:40:36 -0600
Subject: [ndctl PATCH v3 3/9] libcxl: Separate region mode from decoder
 mode
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-dcd-region2-v3-3-326cd4e34dcd@intel.com>
References: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696034; l=9745;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=nX4+TBmzT/8S/6xSSe7TLFYuuRvqvwN/md0J6OgzWuI=;
 b=BJMvuXuv3JOZyWsNfYSFz8WNEk/50j06Xziu8Hzs0oUtdWC6pyDxHQTsFYosl6Vih1I+6nL5d
 Ak3xLAi9sjKBgx3t22R7da1Jqq27qVbgKpzwYH5t8cpctXl0tjxhx+l
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

With the introduction of DCD, region mode and decoder mode no longer
remain a 1:1 relation.  An interleaved region may be made up of Dynamic
Capacity partitions with different indexes on each of the target
devices.

Introduce a new region mode enumeration and access function to libcxl.

To maintain compatibility with existing software the region mode values
are defined the same as the current decoder mode.  In addition
cxl_region_get_mode() is retained.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[Alison/iweiny: Ensure correct libcxl symbol export version]
[Alison/iweiny: Add new libcxl interfaces to documentation]
[iweiny: Add deprecated cxl_region_get_mode() documentation]
---
 Documentation/cxl/lib/libcxl.txt | 20 ++++++++++++++++++--
 cxl/lib/libcxl.c                 | 25 +++++++++++++++----------
 cxl/lib/libcxl.sym               |  5 +++++
 cxl/lib/private.h                |  2 +-
 cxl/libcxl.h                     | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 40598a08b9f4840f79e3ab43f62f412d8b2136ed..d5c3558aacecb08d7f5754fdcc77d6e743560601 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -553,11 +553,20 @@ struct cxl_region *cxl_region_get_next(struct cxl_region *region);
 
 ===== REGION: Attributes
 ----
+enum cxl_region_mode {
+	CXL_REGION_MODE_NONE = CXL_DECODER_MODE_NONE,
+	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
+	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
+	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+};
+const char *cxl_region_mode_name(enum cxl_region_mode mode);
+enum cxl_region_mode cxl_region_mode_from_ident(const char *ident);
+enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region);
+
 int cxl_region_get_id(struct cxl_region *region);
 const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
-enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
@@ -576,8 +585,12 @@ int cxl_region_clear_all_targets(struct cxl_region *region);
 int cxl_region_decode_commit(struct cxl_region *region);
 int cxl_region_decode_reset(struct cxl_region *region);
 struct daxctl_region *cxl_region_get_daxctl_region(struct cxl_region *region);
-----
 
+DEPRECATED:
+
+enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
+
+----
 A region's resource attribute is the Host Physical Address at which the region's
 address space starts. The region's address space is a subset of the parent root
 decoder's address space.
@@ -601,6 +614,9 @@ where its properties can be interrogated by daxctl. The helper
 cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
 can be used with other libdaxctl APIs.
 
+Regions now have a mode distinct from decoders.  cxl_region_get_mode() is
+deprecated in favor of cxl_region_get_region_mode().
+
 include::../../copyright.txt[]
 
 SEE ALSO
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef3acdc2fb3c4ec6c13be5feb802e817d0d..35a40091e8f5813c1b3ef2ffb931c9ec584b02ad 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -431,10 +431,10 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
 		if (!memdev)
 			continue;
 
-		if (region->mode == CXL_DECODER_MODE_RAM) {
+		if (region->mode == CXL_REGION_MODE_RAM) {
 			if (root_decoder->qos_class != memdev->ram_qos_class)
 				return true;
-		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
+		} else if (region->mode == CXL_REGION_MODE_PMEM) {
 			if (root_decoder->qos_class != memdev->pmem_qos_class)
 				return true;
 		}
@@ -619,9 +619,9 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	sprintf(path, "%s/mode", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
-		region->mode = CXL_DECODER_MODE_NONE;
+		region->mode = CXL_REGION_MODE_NONE;
 	else
-		region->mode = cxl_decoder_mode_from_ident(buf);
+		region->mode = cxl_region_mode_from_ident(buf);
 
 	sprintf(path, "%s/modalias", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
@@ -748,11 +748,16 @@ CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
 	return region->start;
 }
 
-CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+CXL_EXPORT enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region)
 {
 	return region->mode;
 }
 
+CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+{
+	return (enum cxl_decoder_mode)cxl_region_get_region_mode(region);
+}
+
 CXL_EXPORT unsigned int
 cxl_region_get_interleave_ways(struct cxl_region *region)
 {
@@ -2700,7 +2705,7 @@ cxl_decoder_get_region(struct cxl_decoder *decoder)
 }
 
 static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
-						    enum cxl_decoder_mode mode)
+						    enum cxl_region_mode mode)
 {
 	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
 	char *path = decoder->dev_buf;
@@ -2708,9 +2713,9 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 	struct cxl_region *region;
 	int rc;
 
-	if (mode == CXL_DECODER_MODE_PMEM)
+	if (mode == CXL_REGION_MODE_PMEM)
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
-	else if (mode == CXL_DECODER_MODE_RAM)
+	else if (mode == CXL_REGION_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
@@ -2754,13 +2759,13 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 CXL_EXPORT struct cxl_region *
 cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
 {
-	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_PMEM);
+	return cxl_decoder_create_region(decoder, CXL_REGION_MODE_PMEM);
 }
 
 CXL_EXPORT struct cxl_region *
 cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 {
-	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
+	return cxl_decoder_create_region(decoder, CXL_REGION_MODE_RAM);
 }
 
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 0c155a40ad4765106f0eab1745281d462af782fe..17a660f508ad1e053af2992824535ccf7ce877b2 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -288,3 +288,8 @@ global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
 } LIBCXL_7;
+
+LIBCXL_9 {
+global:
+	cxl_region_get_region_mode;
+} LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910e93359b53cac34427acfe84c7abcb78b0..0f45be89b6a00477d13fb6d7f1906213a3073c48 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -171,7 +171,7 @@ struct cxl_region {
 	unsigned int interleave_ways;
 	unsigned int interleave_granularity;
 	enum cxl_decode_state decode_state;
-	enum cxl_decoder_mode mode;
+	enum cxl_region_mode mode;
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0a5fd0e13cc24e0032d4a83d780278fbe0038d32..06b87a0924faafec6c80eca83ea7551d4e117256 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -303,6 +303,39 @@ int cxl_memdev_is_enabled(struct cxl_memdev *memdev);
 	for (endpoint = cxl_endpoint_get_first(port); endpoint != NULL;        \
 	     endpoint = cxl_endpoint_get_next(endpoint))
 
+enum cxl_region_mode {
+	CXL_REGION_MODE_NONE = CXL_DECODER_MODE_NONE,
+	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
+	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
+	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+};
+
+static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
+{
+	static const char *names[] = {
+		[CXL_REGION_MODE_NONE] = "none",
+		[CXL_REGION_MODE_MIXED] = "mixed",
+		[CXL_REGION_MODE_PMEM] = "pmem",
+		[CXL_REGION_MODE_RAM] = "ram",
+	};
+
+	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
+		mode = CXL_REGION_MODE_NONE;
+	return names[mode];
+}
+
+static inline enum cxl_region_mode
+cxl_region_mode_from_ident(const char *ident)
+{
+	if (strcmp(ident, "ram") == 0)
+		return CXL_REGION_MODE_RAM;
+	else if (strcmp(ident, "volatile") == 0)
+		return CXL_REGION_MODE_RAM;
+	else if (strcmp(ident, "pmem") == 0)
+		return CXL_REGION_MODE_PMEM;
+	return CXL_REGION_MODE_NONE;
+}
+
 struct cxl_region;
 struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
 struct cxl_region *cxl_region_get_next(struct cxl_region *region);
@@ -318,6 +351,8 @@ const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
+enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region);
+/* Deprecated: use cxl_region_get_region_mode() */
 enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);

-- 
2.47.0


