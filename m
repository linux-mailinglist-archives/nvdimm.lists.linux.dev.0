Return-Path: <nvdimm+bounces-8994-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E4C993AE0
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Oct 2024 01:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76D99B24998
	for <lists+linux-nvdimm@lfdr.de>; Mon,  7 Oct 2024 23:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E3A1DE88C;
	Mon,  7 Oct 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="daBnL+bK"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC16192D99
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343032; cv=none; b=gLPX/5jsm+VzCCrDwTNauAWAUvFoAHlCxs/cHOIJ5pgCT/kuy2zKwEzwY+3mNnMVaNMDWDx42RivHnZvN/ZparquYnOXPEaV/gwto2GPxv4mfKZxrUxQ3DiLESeloq7KmA8IXBY4y/F9GxzpU2kAchtp+EZCohwrC0Sr9HQ8zI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343032; c=relaxed/simple;
	bh=d81qokaVaP1HU4jgDHr7l2xMzISghKZiYMCJp+z2Ghk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rR8QEsym6kE3V7JZOQ40j5XwUquUiFJlU9Lqhj+4GHQ9HRzagh+3YNC8tyGLJfz6qmWDUOXp5lls2AZNLEi0cv0xAHMI/amyoH+u2DNOVALaCvtI+1PSu3a5uiE5FfW8SSQ6S140cBhYz7Aj/F7L/LV0QLdKe+vjuSaAm09znZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=daBnL+bK; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343031; x=1759879031;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=d81qokaVaP1HU4jgDHr7l2xMzISghKZiYMCJp+z2Ghk=;
  b=daBnL+bKwQe56Ugn/Eru8ao9Anbc32OgFV+tNb3K3YJpegGTWYFHscas
   V0YzvbJAaUny3JEyNWl95asja/eDyt0pCuYD5qRrDir0h+qxurj9wK+5m
   rXfJ/Z9Ir9EpjC0xixJPNS6VosGeLiNqePhlnflLiJHGVpFMIhIwmSWo1
   Xbd4CU1iCpdNFQlyMH3D14Ik7BHmwrQehrtFbeDLyRpoPPwgqB2kV4R2f
   L9B8b91XgX2w1GeRYNX/xSmY6JzrT94NUgs+/cPITG4ThPMuubl5VNh/f
   eqjYb0Pnlix65DYQGrVUL6fZUQu7nhcpHyeE7/1lVGPjt3yLON1duvcW+
   A==;
X-CSE-ConnectionGUID: FaXRXro5QVWp8cRnsJuB4w==
X-CSE-MsgGUID: Sc6JRN54Si6Ee2nz/47bEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45036899"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="45036899"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:48 -0700
X-CSE-ConnectionGUID: gYfaYytIQwKDsm1ddjIrJQ==
X-CSE-MsgGUID: z0L/ATEGRsGlEv0XYUHjWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75309063"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:44 -0700
From: ira.weiny@intel.com
Date: Mon, 07 Oct 2024 18:16:17 -0500
Subject: [PATCH v4 11/28] cxl/hdm: Add dynamic capacity size support to
 endpoint decoders
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-11-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=13256;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=AKOUBR29/UkN+84Eyx/sDTP5H3ODQQSk62B0KPiHJuE=;
 b=K4WmGm8iuEtjenjeh+STr0L+uU9pQKubDqwjps1wO1L9OOIY0v8u4xy9dS/JZ/R4H0Ju370tY
 8wzGILbjvssDN4oWaI5ytibsnTnAg6V/E52WZMNYhsYeZzP5duHLrsP
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

To support Dynamic Capacity Devices (DCD) endpoint decoders will need to
map DC partitions (regions).  In addition to assigning the size of the
DC partition, the decoder must assign any skip value from the previous
decoder.  This must be done within a contiguous DPA space.

Two complications arise with Dynamic Capacity regions which did not
exist with Ram and PMEM partitions.  First, gaps in the DPA space can
exist between and around the DC partitions.  Second, the Linux resource
tree does not allow a resource to be marked across existing nodes within
a tree.

For clarity, below is an example of an 60GB device with 10GB of RAM,
10GB of PMEM and 10GB for each of 2 DC partitions.  The desired CXL
mapping is 5GB of RAM, 5GB of PMEM, and 5GB of DC1.

     DPA RANGE
     (dpa_res)
0GB        10GB       20GB       30GB       40GB       50GB       60GB
|----------|----------|----------|----------|----------|----------|

RAM         PMEM                  DC0                   DC1
 (ram_res)  (pmem_res)            (dc_res[0])           (dc_res[1])
|----------|----------|   <gap>  |----------|   <gap>  |----------|

 RAM        PMEM                                        DC1
|XXXXX|----|XXXXX|----|----------|----------|----------|XXXXX-----|
0GB   5GB  10GB  15GB 20GB       30GB       40GB       50GB       60GB

The previous skip resource between RAM and PMEM was always a child of
the RAM resource and fit nicely [see (S) below].  Because of this
simplicity this skip resource reference was not stored in any CXL state.
On release the skip range could be calculated based on the endpoint
decoders stored values.

Now when DC1 is being mapped 4 skip resources must be created as
children.  One for the PMEM resource (A), two of the parent DPA resource
(B,D), and one more child of the DC0 resource (C).

0GB        10GB       20GB       30GB       40GB       50GB       60GB
|----------|----------|----------|----------|----------|----------|
                           |                     |
|----------|----------|    |     |----------|    |     |----------|
        |          |       |          |          |
       (S)        (A)     (B)        (C)        (D)
	v          v       v          v          v
|XXXXX|----|XXXXX|----|----------|----------|----------|XXXXX-----|
       skip       skip  skip        skip      skip

Expand the calculation of DPA free space and enhance the logic to
support this more complex skipping.  To track the potential of multiple
skip resources an xarray is attached to the endpoint decoder.  The
existing algorithm between RAM and PMEM is consolidated within the new
one to streamline the code even though the result is the storage of a
single skip resource in the xarray.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[djiang: s/skip_res/skip_xa/]
---
 drivers/cxl/core/hdm.c  | 196 ++++++++++++++++++++++++++++++++++++++++++++----
 drivers/cxl/core/port.c |   2 +
 drivers/cxl/cxl.h       |   2 +
 3 files changed, 184 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 3df10517a327..8c7f941eaba1 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -223,6 +223,25 @@ void cxl_dpa_debug(struct seq_file *file, struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dpa_debug, CXL);
 
+static void cxl_skip_release(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_dev_state *cxlds = cxled_to_memdev(cxled)->cxlds;
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct device *dev = &port->dev;
+	unsigned long index;
+	void *entry;
+
+	xa_for_each(&cxled->skip_xa, index, entry) {
+		struct resource *res = entry;
+
+		dev_dbg(dev, "decoder%d.%d: releasing skipped space; %pr\n",
+			port->id, cxled->cxld.id, res);
+		__release_region(&cxlds->dpa_res, res->start,
+				 resource_size(res));
+		xa_erase(&cxled->skip_xa, index);
+	}
+}
+
 /*
  * Must be called in a context that synchronizes against this decoder's
  * port ->remove() callback (like an endpoint decoder sysfs attribute)
@@ -233,15 +252,11 @@ static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
 	struct cxl_port *port = cxled_to_port(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct resource *res = cxled->dpa_res;
-	resource_size_t skip_start;
 
 	lockdep_assert_held_write(&cxl_dpa_rwsem);
 
-	/* save @skip_start, before @res is released */
-	skip_start = res->start - cxled->skip;
 	__release_region(&cxlds->dpa_res, res->start, resource_size(res));
-	if (cxled->skip)
-		__release_region(&cxlds->dpa_res, skip_start, cxled->skip);
+	cxl_skip_release(cxled);
 	cxled->skip = 0;
 	cxled->dpa_res = NULL;
 	put_device(&cxled->cxld.dev);
@@ -268,6 +283,105 @@ static void devm_cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
 	__cxl_dpa_release(cxled);
 }
 
+static int dc_mode_to_region_index(enum cxl_decoder_mode mode)
+{
+	return mode - CXL_DECODER_DC0;
+}
+
+static int cxl_request_skip(struct cxl_endpoint_decoder *cxled,
+			    resource_size_t skip_base, resource_size_t skip_len)
+{
+	struct cxl_dev_state *cxlds = cxled_to_memdev(cxled)->cxlds;
+	const char *name = dev_name(&cxled->cxld.dev);
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct resource *dpa_res = &cxlds->dpa_res;
+	struct device *dev = &port->dev;
+	struct resource *res;
+	int rc;
+
+	res = __request_region(dpa_res, skip_base, skip_len, name, 0);
+	if (!res)
+		return -EBUSY;
+
+	rc = xa_insert(&cxled->skip_xa, skip_base, res, GFP_KERNEL);
+	if (rc) {
+		__release_region(dpa_res, skip_base, skip_len);
+		return rc;
+	}
+
+	dev_dbg(dev, "decoder%d.%d: skipped space; %pr\n",
+		port->id, cxled->cxld.id, res);
+	return 0;
+}
+
+static int cxl_reserve_dpa_skip(struct cxl_endpoint_decoder *cxled,
+				resource_size_t base, resource_size_t skipped)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	resource_size_t skip_base = base - skipped;
+	struct device *dev = &port->dev;
+	resource_size_t skip_len = 0;
+	int rc, index;
+
+	if (resource_size(&cxlds->ram_res) && skip_base <= cxlds->ram_res.end) {
+		skip_len = cxlds->ram_res.end - skip_base + 1;
+		rc = cxl_request_skip(cxled, skip_base, skip_len);
+		if (rc)
+			return rc;
+		skip_base += skip_len;
+	}
+
+	if (skip_base == base) {
+		dev_dbg(dev, "skip done ram!\n");
+		return 0;
+	}
+
+	if (resource_size(&cxlds->pmem_res) &&
+	    skip_base <= cxlds->pmem_res.end) {
+		skip_len = cxlds->pmem_res.end - skip_base + 1;
+		rc = cxl_request_skip(cxled, skip_base, skip_len);
+		if (rc)
+			return rc;
+		skip_base += skip_len;
+	}
+
+	index = dc_mode_to_region_index(cxled->mode);
+	for (int i = 0; i <= index; i++) {
+		struct resource *dcr = &cxlds->dc_res[i];
+
+		if (skip_base < dcr->start) {
+			skip_len = dcr->start - skip_base;
+			rc = cxl_request_skip(cxled, skip_base, skip_len);
+			if (rc)
+				return rc;
+			skip_base += skip_len;
+		}
+
+		if (skip_base == base) {
+			dev_dbg(dev, "skip done DC region %d!\n", i);
+			break;
+		}
+
+		if (resource_size(dcr) && skip_base <= dcr->end) {
+			if (skip_base > base) {
+				dev_err(dev, "Skip error DC region %d; skip_base %pa; base %pa\n",
+					i, &skip_base, &base);
+				return -ENXIO;
+			}
+
+			skip_len = dcr->end - skip_base + 1;
+			rc = cxl_request_skip(cxled, skip_base, skip_len);
+			if (rc)
+				return rc;
+			skip_base += skip_len;
+		}
+	}
+
+	return 0;
+}
+
 static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 			     resource_size_t base, resource_size_t len,
 			     resource_size_t skipped)
@@ -305,13 +419,12 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 	}
 
 	if (skipped) {
-		res = __request_region(&cxlds->dpa_res, base - skipped, skipped,
-				       dev_name(&cxled->cxld.dev), 0);
-		if (!res) {
-			dev_dbg(dev,
-				"decoder%d.%d: failed to reserve skipped space\n",
-				port->id, cxled->cxld.id);
-			return -EBUSY;
+		int rc = cxl_reserve_dpa_skip(cxled, base, skipped);
+
+		if (rc) {
+			dev_dbg(dev, "decoder%d.%d: failed to reserve skipped space; %pa - %pa\n",
+				port->id, cxled->cxld.id, &base, &skipped);
+			return rc;
 		}
 	}
 	res = __request_region(&cxlds->dpa_res, base, len,
@@ -319,14 +432,20 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 	if (!res) {
 		dev_dbg(dev, "decoder%d.%d: failed to reserve allocation\n",
 			port->id, cxled->cxld.id);
-		if (skipped)
-			__release_region(&cxlds->dpa_res, base - skipped,
-					 skipped);
+		cxl_skip_release(cxled);
 		return -EBUSY;
 	}
 	cxled->dpa_res = res;
 	cxled->skip = skipped;
 
+	for (int mode = CXL_DECODER_DC0; mode <= CXL_DECODER_DC7; mode++) {
+		int index = dc_mode_to_region_index(mode);
+
+		if (resource_contains(&cxlds->dc_res[index], res)) {
+			cxled->mode = mode;
+			goto success;
+		}
+	}
 	if (resource_contains(&cxlds->pmem_res, res))
 		cxled->mode = CXL_DECODER_PMEM;
 	else if (resource_contains(&cxlds->ram_res, res))
@@ -337,6 +456,9 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 		cxled->mode = CXL_DECODER_MIXED;
 	}
 
+success:
+	dev_dbg(dev, "decoder%d.%d: %pr mode: %d\n", port->id, cxled->cxld.id,
+		cxled->dpa_res, cxled->mode);
 	port->hdm_end++;
 	get_device(&cxled->cxld.dev);
 	return 0;
@@ -466,8 +588,8 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 
 int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, unsigned long long size)
 {
-	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	resource_size_t free_ram_start, free_pmem_start;
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_port *port = cxled_to_port(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct device *dev = &cxled->cxld.dev;
@@ -524,12 +646,54 @@ int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, unsigned long long size)
 		else
 			skip_end = start - 1;
 		skip = skip_end - skip_start + 1;
+	} else if (cxl_decoder_mode_is_dc(cxled->mode)) {
+		int dc_index = dc_mode_to_region_index(cxled->mode);
+
+		for (p = cxlds->dc_res[dc_index].child, last = NULL; p; p = p->sibling)
+			last = p;
+
+		if (last) {
+			/*
+			 * Some capacity in this DC partition is already allocated,
+			 * that allocation already handled the skip.
+			 */
+			start = last->end + 1;
+			skip = 0;
+		} else {
+			/* Calculate skip */
+			resource_size_t skip_start, skip_end;
+
+			start = cxlds->dc_res[dc_index].start;
+
+			if ((resource_size(&cxlds->pmem_res) == 0) || !cxlds->pmem_res.child)
+				skip_start = free_ram_start;
+			else
+				skip_start = free_pmem_start;
+			/*
+			 * If any dc region is already mapped, then that allocation
+			 * already handled the RAM and PMEM skip.  Check for DC region
+			 * skip.
+			 */
+			for (int i = dc_index - 1; i >= 0 ; i--) {
+				if (cxlds->dc_res[i].child) {
+					skip_start = cxlds->dc_res[i].child->end + 1;
+					break;
+				}
+			}
+
+			skip_end = start - 1;
+			skip = skip_end - skip_start + 1;
+		}
+		avail = cxlds->dc_res[dc_index].end - start + 1;
 	} else {
 		dev_dbg(dev, "mode not set\n");
 		rc = -EINVAL;
 		goto out;
 	}
 
+	dev_dbg(dev, "DPA Allocation start: %pa len: %#llx Skip: %pa\n",
+		&start, size, &skip);
+
 	if (size > avail) {
 		dev_dbg(dev, "%pa exceeds available %s capacity: %pa\n", &size,
 			cxl_decoder_mode_name(cxled->mode), &avail);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index e666ec6a9085..85b912c11f04 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -419,6 +419,7 @@ static void cxl_endpoint_decoder_release(struct device *dev)
 	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
 
 	__cxl_decoder_release(&cxled->cxld);
+	xa_destroy(&cxled->skip_xa);
 	kfree(cxled);
 }
 
@@ -1899,6 +1900,7 @@ struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
 		return ERR_PTR(-ENOMEM);
 
 	cxled->pos = -1;
+	xa_init(&cxled->skip_xa);
 	cxld = &cxled->cxld;
 	rc = cxl_decoder_init(port, cxld);
 	if (rc)	 {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f931ebdd36d0..8b7099c38a40 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -446,6 +446,7 @@ enum cxl_decoder_state {
  * @cxld: base cxl_decoder_object
  * @dpa_res: actively claimed DPA span of this decoder
  * @skip: offset into @dpa_res where @cxld.hpa_range maps
+ * @skip_xa: array of skipped resources from the previous decoder end
  * @mode: which memory type / access-mode-partition this decoder targets
  * @state: autodiscovery state
  * @pos: interleave position in @cxld.region
@@ -454,6 +455,7 @@ struct cxl_endpoint_decoder {
 	struct cxl_decoder cxld;
 	struct resource *dpa_res;
 	resource_size_t skip;
+	struct xarray skip_xa;
 	enum cxl_decoder_mode mode;
 	enum cxl_decoder_state state;
 	int pos;

-- 
2.46.0


