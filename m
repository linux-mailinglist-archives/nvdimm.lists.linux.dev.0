Return-Path: <nvdimm+bounces-2573-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 838664976B4
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jan 2022 01:31:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C12BD1C0F48
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jan 2022 00:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A714B2CB5;
	Mon, 24 Jan 2022 00:31:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971842CA7
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984284; x=1674520284;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2DqZACrxPiU5SVR8TgyzgrmTDRlGpisXtfWG0ZvZ/rc=;
  b=iJMBpveRdKEMHYu0QA7XzMFpTN1wH7kb+Tvw7MOWoZWQxDwl3l90zzAt
   ssAHUyTj3yLcktdfJGToOLspT7y+1ImfF8YYill9CX7DlPA/j79Im9dFv
   +kRamAVcG5vjhRnNH8zQo27LhYSREo+DRy+pAHnmK81PedJ4feohc1DXz
   ffyoW/V0Zhj23lWf7XwhGweJGFkAdsnCmV0nyr7DjdpM2isFDsnP1BezJ
   DsABO1NpT6CCjHQZ612u8K+E0/DKnaY+aPXsSmmIBojUTwm0wMOLP0amO
   aJ8JV7hHwRQknqH08e75abtA1MV819clY/bAZGF5sxN5iGRp2U+rGGv8C
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309256032"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309256032"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="494436553"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:24 -0800
Subject: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:31:24 -0800
Message-ID: <164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

While CXL memory targets will have their own memory target node,
individual memory devices may be affinitized like other PCI devices.
Emit that attribute for memdevs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |    9 +++++++++
 drivers/cxl/core/memdev.c               |   17 +++++++++++++++++
 tools/testing/cxl/test/cxl.c            |    1 +
 3 files changed, 27 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 87c0e5e65322..0b51cfec0c66 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -34,6 +34,15 @@ Description:
 		capability. Mandatory for CXL devices, see CXL 2.0 8.1.12.2
 		Memory Device PCIe Capabilities and Extended Capabilities.
 
+What:		/sys/bus/cxl/devices/memX/numa_node
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) If NUMA is enabled and the platform has affinitized the
+		host PCI device for this memory device, emit the CPU node
+		affinity for this device.
+
 What:		/sys/bus/cxl/devices/*/devtype
 Date:		June, 2021
 KernelVersion:	v5.14
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 1e574b052583..b2773664e407 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -99,11 +99,19 @@ static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(serial);
 
+static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%d\n", dev_to_node(dev));
+}
+static DEVICE_ATTR_RO(numa_node);
+
 static struct attribute *cxl_memdev_attributes[] = {
 	&dev_attr_serial.attr,
 	&dev_attr_firmware_version.attr,
 	&dev_attr_payload_max.attr,
 	&dev_attr_label_storage_size.attr,
+	&dev_attr_numa_node.attr,
 	NULL,
 };
 
@@ -117,8 +125,17 @@ static struct attribute *cxl_memdev_ram_attributes[] = {
 	NULL,
 };
 
+static umode_t cxl_memdev_visible(struct kobject *kobj, struct attribute *a,
+				  int n)
+{
+	if (!IS_ENABLED(CONFIG_NUMA) && a == &dev_attr_numa_node.attr)
+		return 0;
+	return a->mode;
+}
+
 static struct attribute_group cxl_memdev_attribute_group = {
 	.attrs = cxl_memdev_attributes,
+	.is_visible = cxl_memdev_visible,
 };
 
 static struct attribute_group cxl_memdev_ram_attribute_group = {
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 40ed567952e6..cd2f20f2707f 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -583,6 +583,7 @@ static __init int cxl_test_init(void)
 		if (!pdev)
 			goto err_mem;
 		pdev->dev.parent = &port->dev;
+		set_dev_node(&pdev->dev, i % 2);
 
 		rc = platform_device_add(pdev);
 		if (rc) {


