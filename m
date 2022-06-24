Return-Path: <nvdimm+bounces-3997-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 546CD558FAB
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 06:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11089280CB4
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 04:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56A723CC;
	Fri, 24 Jun 2022 04:20:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631B623BE;
	Fri, 24 Jun 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044416; x=1687580416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJ+bHfjcyMc1b9C/HvSsIpbtbXqAWfkW73dd39hPy0w=;
  b=OzGnmuBOX/HGeMIJAT1K8Z7QHP0bo6gIO9mOc6uXEL5v2ELnXDoTu8xr
   IotdHPQduWLiQfiruA/1xGi6XcUw8K8Owqnli+7HELaUWcECurKFFfGch
   NLGtuPN+ulYkHz/GHfD5EDAl0DlDrgMdE59oo3rzdKsRw68nGjZi1etAk
   qja+n0BP1kkD0VwaEl4k+wiWQ65B1zo9Tx0ufAhrA5//F+dOj/M+LhNzK
   rhnuICx4gnc7MfidU/5P9Y4epLPy0t0p5K8cRi89W/DQ2b1s1NAqU/pQC
   Iz06YASpWFYkm2gNxLO8JdA/Q2SdyKZbgCiVdbNBsWk7Yr8KQfYx6tAW6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912800"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912800"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092932"
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
Subject: [PATCH 35/46] cxl/region: Add a 'uuid' attribute
Date: Thu, 23 Jun 2022 21:19:39 -0700
Message-Id: <20220624041950.559155-10-dan.j.williams@intel.com>
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

The process of provisioning a region involves triggering the creation of
a new region object, pouring in the configuration, and then binding that
configured object to the region driver to start is operation. For
persistent memory regions the CXL specification mandates that it
identified by a uuid. Add an ABI for userspace to specify a region's
uuid.

Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
[djbw: simplify locking]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  10 +++
 drivers/cxl/core/region.c               | 115 ++++++++++++++++++++++++
 drivers/cxl/cxl.h                       |  25 ++++++
 3 files changed, 150 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 9a4856066631..d30c95a758a9 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -263,3 +263,13 @@ Contact:	linux-cxl@vger.kernel.org
 Description:
 		(WO) Write a string in the form 'regionZ' to delete that region,
 		provided it is currently idle / not bound to a driver.
+
+
+What:		/sys/bus/cxl/devices/regionZ/uuid
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) Write a unique identifier for the region. This field must
+		be set for persistent regions and it must not conflict with the
+		UUID of another region.
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f2a0ead20ca7..f75978f846b9 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -5,6 +5,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/uuid.h>
 #include <linux/idr.h>
 #include <cxl.h>
 #include "core.h"
@@ -17,10 +18,123 @@
  * Memory ranges, Regions represent the active mapped capacity by the HDM
  * Decoder Capability structures throughout the Host Bridges, Switches, and
  * Endpoints in the topology.
+ *
+ * Region configuration has ordering constraints. UUID may be set at any time
+ * but is only visible for persistent regions.
+ */
+
+/*
+ * All changes to the interleave configuration occur with this lock held
+ * for write.
  */
+static DECLARE_RWSEM(cxl_region_rwsem);
 
 static struct cxl_region *to_cxl_region(struct device *dev);
 
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	ssize_t rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%pUb\n", &p->uuid);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+
+static int is_dup(struct device *match, void *data)
+{
+	struct cxl_region_params *p;
+	struct cxl_region *cxlr;
+	uuid_t *uuid = data;
+
+	if (!is_cxl_region(match))
+		return 0;
+
+	lockdep_assert_held(&cxl_region_rwsem);
+	cxlr = to_cxl_region(match);
+	p = &cxlr->params;
+
+	if (uuid_equal(&p->uuid, uuid)) {
+		dev_dbg(match, "already has uuid: %pUb\n", uuid);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	uuid_t temp;
+	ssize_t rc;
+
+	if (len != UUID_STRING_LEN + 1)
+		return -EINVAL;
+
+	rc = uuid_parse(buf, &temp);
+	if (rc)
+		return rc;
+
+	if (uuid_is_null(&temp))
+		return -EINVAL;
+
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+
+	rc = -EBUSY;
+	if (p->state >= CXL_CONFIG_ACTIVE)
+		goto out;
+
+	rc = bus_for_each_dev(&cxl_bus_type, NULL, &temp, is_dup);
+	if (rc < 0)
+		goto out;
+
+	uuid_copy(&p->uuid, &temp);
+out:
+	up_write(&cxl_region_rwsem);
+
+	if (rc)
+		return rc;
+	return len;
+}
+static DEVICE_ATTR_RW(uuid);
+
+static umode_t cxl_region_visible(struct kobject *kobj, struct attribute *a,
+				  int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	if (a == &dev_attr_uuid.attr && cxlr->mode != CXL_DECODER_PMEM)
+		return 0;
+	return a->mode;
+}
+
+static struct attribute *cxl_region_attrs[] = {
+	&dev_attr_uuid.attr,
+	NULL,
+};
+
+static const struct attribute_group cxl_region_group = {
+	.attrs = cxl_region_attrs,
+	.is_visible = cxl_region_visible,
+};
+
+static const struct attribute_group *region_groups[] = {
+	&cxl_base_attribute_group,
+	&cxl_region_group,
+	NULL,
+};
+
 static void cxl_region_release(struct device *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
@@ -32,6 +146,7 @@ static void cxl_region_release(struct device *dev)
 static const struct device_type cxl_region_type = {
 	.name = "cxl_region",
 	.release = cxl_region_release,
+	.groups = region_groups
 };
 
 bool is_cxl_region(struct device *dev)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 49b73b2e44a9..46a9f8acc602 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -288,18 +288,43 @@ struct cxl_root_decoder {
 	struct cxl_switch_decoder cxlsd;
 };
 
+/*
+ * enum cxl_config_state - State machine for region configuration
+ * @CXL_CONFIG_IDLE: Any sysfs attribute can be written freely
+ * @CXL_CONFIG_ACTIVE: All targets have been added the region is now
+ * active
+ */
+enum cxl_config_state {
+	CXL_CONFIG_IDLE,
+	CXL_CONFIG_ACTIVE,
+};
+
+/**
+ * struct cxl_region_params - region settings
+ * @state: allow the driver to lockdown further parameter changes
+ * @uuid: unique id for persistent regions
+ *
+ * State transitions are protected by the cxl_region_rwsem
+ */
+struct cxl_region_params {
+	enum cxl_config_state state;
+	uuid_t uuid;
+};
+
 /**
  * struct cxl_region - CXL region
  * @dev: This region's device
  * @id: This region's id. Id is globally unique across all regions
  * @mode: Endpoint decoder allocation / access mode
  * @type: Endpoint decoder target type
+ * @params: active + config params for the region
  */
 struct cxl_region {
 	struct device dev;
 	int id;
 	enum cxl_decoder_mode mode;
 	enum cxl_decoder_type type;
+	struct cxl_region_params params;
 };
 
 /**
-- 
2.36.1


