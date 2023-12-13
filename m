Return-Path: <nvdimm+bounces-7008-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E69E807FBA
	for <lists+linux-nvdimm@lfdr.de>; Thu,  7 Dec 2023 05:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D58F3281D55
	for <lists+linux-nvdimm@lfdr.de>; Thu,  7 Dec 2023 04:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343E8566E;
	Thu,  7 Dec 2023 04:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPvsPyus"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B52610A13
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 04:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701923781; x=1733459781;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=GLP9N2ferQtSs1kZ5RuoBDkk5vqBcdypuQXPjkQVI40=;
  b=CPvsPyusMMhxkfJlp80BWr7xDJC+hSJsVAZArUentj9dEJh4Xa1bAvSk
   9hfxq9PaJrH6M7Hc+pxj7qfohhhdgokenxYj7hgorR5uTy0H4Qt9R9+XO
   XOV1CfKbgWQL6zp4K13jyyusedMLsP9Rc0frrIfpZ2gwz9yqUbV2CdZXl
   E96H0cO43rtAI60lnJ8PgS1X5zXiX00ambwTfPCFeyt821jBV3ps0e9o1
   k9df62PIkH7GoTcZCnAxxtAbCd33Jrr9vNZrzqKFOmIQgnIZXms5Ep70h
   OfAttMxw1kP1gyNtqM+qEqblgMPTA7CIGu/7g8HcU+J7kBSA//vL+kGS6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1053227"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1053227"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:36:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="19570383"
Received: from apbrezen-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.160.175])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:36:18 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 06 Dec 2023 21:36:15 -0700
Subject: [PATCH v2 2/2] dax: add a sysfs knob to control memmap_on_memory
 behavior
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231206-vv-dax_abi-v2-2-f4f4f2336d08@intel.com>
References: <20231206-vv-dax_abi-v2-0-f4f4f2336d08@intel.com>
In-Reply-To: <20231206-vv-dax_abi-v2-0-f4f4f2336d08@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Vishal Verma <vishal.l.verma@intel.com>, 
 David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=3572;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=GLP9N2ferQtSs1kZ5RuoBDkk5vqBcdypuQXPjkQVI40=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKmF3gcKzPfKbereozs7go1h30Gr2z0vtixXrP9WH6aV0
 WHGt+ZHRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZyspDhN8uE/G1d5ypauhc5
 5IRuu+B2hOnShtvJ7DXprIF6ZywyzRn+8DjbsxYyqgbaKfAVlauEsdSHtL+9VmC32TWz50b1pt/
 8AA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add a sysfs knob for dax devices to control the memmap_on_memory setting
if the dax device were to be hotplugged as system memory.

The default memmap_on_memory setting for dax devices originating via
pmem or hmem is set to 'false' - i.e. no memmap_on_memory semantics, to
preserve legacy behavior. For dax devices via CXL, the default is on.
The sysfs control allows the administrator to override the above
defaults if needed.

Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c                       | 40 +++++++++++++++++++++++++++++++++
 Documentation/ABI/testing/sysfs-bus-dax | 13 +++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ff1ab5fa105..11abb57cc031 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1270,6 +1270,45 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t memmap_on_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
+}
+
+static ssize_t memmap_on_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
+	ssize_t rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	if (dev_dax->memmap_on_memory == val)
+		return len;
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+
+	device_lock(dev);
+	dev_dax->memmap_on_memory = val;
+	device_unlock(dev);
+
+	device_unlock(dax_region->dev);
+	return rc == 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1296,6 +1335,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index a61a7b186017..bb063a004e41 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -149,3 +149,16 @@ KernelVersion:	v5.1
 Contact:	nvdimm@lists.linux.dev
 Description:
 		(RO) The id attribute indicates the region id of a dax region.
+
+What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
+Date:		October, 2023
+KernelVersion:	v6.8
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Control the memmap_on_memory setting if the dax device
+		were to be hotplugged as system memory. This determines whether
+		the 'altmap' for the hotplugged memory will be placed on the
+		device being hotplugged (memmap_on+memory=1) or if it will be
+		placed on regular memory (memmap_on_memory=0). This attribute
+		must be set before the device is handed over to the 'kmem'
+		driver (i.e.  hotplugged into system-ram).

-- 
2.41.0


