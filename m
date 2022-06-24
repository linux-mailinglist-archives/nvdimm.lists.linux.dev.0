Return-Path: <nvdimm+bounces-3999-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id A9684558FAD
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 06:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 653BB2E0A19
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 04:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF15723D3;
	Fri, 24 Jun 2022 04:20:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724DA23B8;
	Fri, 24 Jun 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044417; x=1687580417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cynHFOPTZEzPT0SWJhn9Y1PKFyxrjTTRzNjEWfvWhdE=;
  b=KLUM+Igk6XSGeqDusKY/vQ8TUc/i9clWRzJaluluK1yo3uq8BBv7VLKw
   Y1uWYTj5jiTGJ2I3zHcIPsuO7CdIEZqLpZnDjuA88jWI0fdYI9BxH4dq7
   nYStNJgRNRForRvqd4dTZDuTn/iKci6MH719W9t2n73sBzxWpkmMmF3dE
   xno1GIxPtZkTE9zHmq83p/Mp5emXQmfGOdGx/X0kMxxtGaivv9kbeg63W
   fHjaNU7CGpZxCD2i5riVs/LmAZQe8NLUaRpwOs15rWyNiP6c+/IWMUbIU
   M7aYrqaLDk/n1FcP//G83Dc3FrYZBNZNZ4RwvJwNL3uBewnmolc5FqUjC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912801"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912801"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092935"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:12 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Ben Widawsky <bwidawsk@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 36/46] cxl/region: Add interleave ways attribute
Date: Thu, 23 Jun 2022 21:19:40 -0700
Message-Id: <20220624041950.559155-11-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ben Widawsky <bwidawsk@kernel.org>

Add an ABI to allow the number of devices that comprise a region to be
set.

Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
[djbw: reword changelog]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  21 ++++
 drivers/cxl/core/region.c               | 128 ++++++++++++++++++++++++
 drivers/cxl/cxl.h                       |  33 ++++++
 3 files changed, 182 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index d30c95a758a9..46d5295c1149 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -273,3 +273,24 @@ Description:
 		(RW) Write a unique identifier for the region. This field must
 		be set for persistent regions and it must not conflict with the
 		UUID of another region.
+
+
+What:		/sys/bus/cxl/devices/regionZ/interleave_granularity
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) Set the number of consecutive bytes each device in the
+		interleave set will claim. The possible interleave granularity
+		values are determined by the CXL spec and the participating
+		devices.
+
+
+What:		/sys/bus/cxl/devices/regionZ/interleave_ways
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) Configures the number of devices participating in the
+		region is set by writing this value. Each device will provide
+		1/interleave_ways of storage for the region.
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f75978f846b9..78af42454760 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/uuid.h>
 #include <linux/idr.h>
+#include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
 
@@ -21,6 +22,8 @@
  *
  * Region configuration has ordering constraints. UUID may be set at any time
  * but is only visible for persistent regions.
+ * 1. Interleave granularity
+ * 2. Interleave size
  */
 
 /*
@@ -119,8 +122,129 @@ static umode_t cxl_region_visible(struct kobject *kobj, struct attribute *a,
 	return a->mode;
 }
 
+static ssize_t interleave_ways_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	ssize_t rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%d\n", p->interleave_ways);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+
+static ssize_t interleave_ways_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev->parent);
+	struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	int rc, val;
+	u8 iw;
+
+	rc = kstrtoint(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	rc = ways_to_cxl(val, &iw);
+	if (rc)
+		return rc;
+
+	/*
+	 * Even for x3, x9, and x12 interleaves the region interleave must be a
+	 * power of 2 multiple of the host bridge interleave.
+	 */
+	if (!is_power_of_2(val / cxld->interleave_ways) ||
+	    (val % cxld->interleave_ways)) {
+		dev_dbg(&cxlr->dev, "invalid interleave: %d\n", val);
+		return -EINVAL;
+	}
+
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	if (p->state >= CXL_CONFIG_INTERLEAVE_ACTIVE) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	p->interleave_ways = val;
+out:
+	up_read(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	return len;
+}
+static DEVICE_ATTR_RW(interleave_ways);
+
+static ssize_t interleave_granularity_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	ssize_t rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%d\n", p->interleave_granularity);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+
+static ssize_t interleave_granularity_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev->parent);
+	struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	int rc, val;
+	u16 ig;
+
+	rc = kstrtoint(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	rc = granularity_to_cxl(val, &ig);
+	if (rc)
+		return rc;
+
+	/* region granularity must be >= root granularity */
+	if (val < cxld->interleave_granularity)
+		return -EINVAL;
+
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	if (p->state >= CXL_CONFIG_INTERLEAVE_ACTIVE) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	p->interleave_granularity = val;
+out:
+	up_read(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	return len;
+}
+static DEVICE_ATTR_RW(interleave_granularity);
+
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
+	&dev_attr_interleave_ways.attr,
+	&dev_attr_interleave_granularity.attr,
 	NULL,
 };
 
@@ -212,6 +336,8 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 					      enum cxl_decoder_type type)
 {
 	struct cxl_port *port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
+	struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
+	struct cxl_region_params *p;
 	struct cxl_region *cxlr;
 	struct device *dev;
 	int rc;
@@ -219,8 +345,10 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	cxlr = cxl_region_alloc(cxlrd, id);
 	if (IS_ERR(cxlr))
 		return cxlr;
+	p = &cxlr->params;
 	cxlr->mode = mode;
 	cxlr->type = type;
+	p->interleave_granularity = cxld->interleave_granularity;
 
 	dev = &cxlr->dev;
 	rc = dev_set_name(dev, "region%d", id);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 46a9f8acc602..13ee04b00e0c 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -7,6 +7,7 @@
 #include <linux/libnvdimm.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
+#include <linux/log2.h>
 #include <linux/io.h>
 
 /**
@@ -92,6 +93,31 @@ static inline int cxl_to_ways(u8 eniw, unsigned int *val)
 	return 0;
 }
 
+static inline int granularity_to_cxl(int g, u16 *ig)
+{
+	if (g > SZ_16K || g < 256 || !is_power_of_2(g))
+		return -EINVAL;
+	*ig = ilog2(g) - 8;
+	return 0;
+}
+
+static inline int ways_to_cxl(int ways, u8 *iw)
+{
+	if (ways > 16)
+		return -EINVAL;
+	if (is_power_of_2(ways)) {
+		*iw = ilog2(ways);
+		return 0;
+	}
+	if (ways % 3)
+		return -EINVAL;
+	ways /= 3;
+	if (!is_power_of_2(ways))
+		return -EINVAL;
+	*iw = ilog2(ways) + 8;
+	return 0;
+}
+
 /* CXL 2.0 8.2.8.1 Device Capabilities Array Register */
 #define CXLDEV_CAP_ARRAY_OFFSET 0x0
 #define   CXLDEV_CAP_ARRAY_CAP_ID 0
@@ -291,11 +317,14 @@ struct cxl_root_decoder {
 /*
  * enum cxl_config_state - State machine for region configuration
  * @CXL_CONFIG_IDLE: Any sysfs attribute can be written freely
+ * @CXL_CONFIG_INTERLEAVE_ACTIVE: region size has been set, no more
+ * changes to interleave_ways or interleave_granularity
  * @CXL_CONFIG_ACTIVE: All targets have been added the region is now
  * active
  */
 enum cxl_config_state {
 	CXL_CONFIG_IDLE,
+	CXL_CONFIG_INTERLEAVE_ACTIVE,
 	CXL_CONFIG_ACTIVE,
 };
 
@@ -303,12 +332,16 @@ enum cxl_config_state {
  * struct cxl_region_params - region settings
  * @state: allow the driver to lockdown further parameter changes
  * @uuid: unique id for persistent regions
+ * @interleave_ways: number of endpoints in the region
+ * @interleave_granularity: capacity each endpoint contributes to a stripe
  *
  * State transitions are protected by the cxl_region_rwsem
  */
 struct cxl_region_params {
 	enum cxl_config_state state;
 	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
 };
 
 /**
-- 
2.36.1


