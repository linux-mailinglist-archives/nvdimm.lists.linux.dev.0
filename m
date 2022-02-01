Return-Path: <nvdimm+bounces-2727-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAA6F4A5419
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 01:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 62C3A3E0EC3
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 00:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AAA3FE0;
	Tue,  1 Feb 2022 00:34:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1374E2CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 00:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643675681; x=1675211681;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fjf5FB26voT1T0ARPJIzRUTIpVRARtKXAGh8m512xik=;
  b=EvmhFnAmbKLMBckZ5N11xjTSKb4qcjcxber0idTqilier37o8THcHPc7
   udF0gUR+7rMqMA3Gzy2XIe5t3MuvEx6iaOBjDKKYKk9sxpGjge3Eo6cZA
   4xuBMQX/yRy2soiVMpYQg6m0/n5lLG6c86O7uCnIbKT2Aral/YINUASCp
   ALovAzKGSosYYP+G7ADvn7gde3UhkOX/UhSWjkajX+TDFHnPLmO1EBYGH
   fQIY/bw5sdbrmUIJz0QrlSx9LmIalhiNGay9oPzzyOTUBC3cbKTi+ZD3S
   V5fw046kaKU//WO+n8THaWoKuZj+yqOJ0JJXM5S7ycQFm+t6crOkKqzs7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="234983265"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="234983265"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 16:34:40 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="522864865"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 16:34:40 -0800
Subject: [PATCH v6 18/40] cxl/pmem: Introduce a find_cxl_root() helper
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 31 Jan 2022 16:34:40 -0800
Message-ID: <164367562182.225521.9488555616768096049.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164324151672.3935633.11277011056733051668.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164324151672.3935633.11277011056733051668.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for switch port enumeration while also preserving the
potential for multi-domain / multi-root CXL topologies. Introduce a
'struct device' generic mechanism for retrieving a root CXL port, if one
is registered. Note that the only known multi-domain CXL configurations
are running the cxl_test unit test on a system that also publishes an
ACPI0017 device.

With this in hand the nvdimm-bridge lookup can be with
device_find_child() instead of bus_find_device() + custom mocked lookup
infrastructure in cxl_test.

The mechanism looks for a 2nd level port since the root level topology
is platform-firmware specific and the 2nd level down follows standard
PCIe topology expectations. The cxl_acpi 2nd level is associated with a
PCIe Root Port.

Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v5:
- Shorten 'match_cxl_root_child' name to improve line wrapping
  (Jonathan)

 drivers/cxl/core/pmem.c       |   14 ++++++++----
 drivers/cxl/core/port.c       |   49 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h             |    1 +
 tools/testing/cxl/Kbuild      |    2 --
 tools/testing/cxl/mock_pmem.c |   24 --------------------
 5 files changed, 60 insertions(+), 30 deletions(-)
 delete mode 100644 tools/testing/cxl/mock_pmem.c

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 40b3f5030496..8de240c4d96b 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -57,24 +57,30 @@ bool is_cxl_nvdimm_bridge(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_nvdimm_bridge, CXL);
 
-__mock int match_nvdimm_bridge(struct device *dev, const void *data)
+static int match_nvdimm_bridge(struct device *dev, void *data)
 {
 	return is_cxl_nvdimm_bridge(dev);
 }
 
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd)
 {
+	struct cxl_port *port = find_cxl_root(&cxl_nvd->dev);
 	struct device *dev;
 
-	dev = bus_find_device(&cxl_bus_type, NULL, cxl_nvd, match_nvdimm_bridge);
+	if (!port)
+		return NULL;
+
+	dev = device_find_child(&port->dev, NULL, match_nvdimm_bridge);
+	put_device(&port->dev);
+
 	if (!dev)
 		return NULL;
+
 	return to_cxl_nvdimm_bridge(dev);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_find_nvdimm_bridge, CXL);
 
-static struct cxl_nvdimm_bridge *
-cxl_nvdimm_bridge_alloc(struct cxl_port *port)
+static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_port *port)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct device *dev;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2a4230d685d5..af7a515e4572 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -455,6 +455,55 @@ int devm_cxl_register_pci_bus(struct device *host, struct device *uport,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_register_pci_bus, CXL);
 
+/* Find a 2nd level CXL port that has a dport that is an ancestor of @match */
+static int match_root_child(struct device *dev, const void *match)
+{
+	const struct device *iter = NULL;
+	struct cxl_port *port, *parent;
+	struct cxl_dport *dport;
+
+	if (!is_cxl_port(dev))
+		return 0;
+
+	port = to_cxl_port(dev);
+	if (is_cxl_root(port))
+		return 0;
+
+	parent = to_cxl_port(port->dev.parent);
+	if (!is_cxl_root(parent))
+		return 0;
+
+	cxl_device_lock(&port->dev);
+	list_for_each_entry(dport, &port->dports, list) {
+		iter = match;
+		while (iter) {
+			if (iter == dport->dport)
+				goto out;
+			iter = iter->parent;
+		}
+	}
+out:
+	cxl_device_unlock(&port->dev);
+
+	return !!iter;
+}
+
+struct cxl_port *find_cxl_root(struct device *dev)
+{
+	struct device *port_dev;
+	struct cxl_port *root;
+
+	port_dev = bus_find_device(&cxl_bus_type, NULL, dev, match_root_child);
+	if (!port_dev)
+		return NULL;
+
+	root = to_cxl_port(port_dev->parent);
+	get_device(&root->dev);
+	put_device(port_dev);
+	return root;
+}
+EXPORT_SYMBOL_NS_GPL(find_cxl_root, CXL);
+
 static struct cxl_dport *find_dport(struct cxl_port *port, int id)
 {
 	struct cxl_dport *dport;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 4d4cc8292137..61b0db526fa2 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -304,6 +304,7 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 
 int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
 		  resource_size_t component_reg_phys);
+struct cxl_port *find_cxl_root(struct device *dev);
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 bool is_root_decoder(struct device *dev);
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 3299fb0977b2..ddaee8a2c418 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -32,6 +32,4 @@ cxl_core-y += $(CXL_CORE_SRC)/memdev.o
 cxl_core-y += $(CXL_CORE_SRC)/mbox.o
 cxl_core-y += config_check.o
 
-cxl_core-y += mock_pmem.o
-
 obj-m += test/
diff --git a/tools/testing/cxl/mock_pmem.c b/tools/testing/cxl/mock_pmem.c
deleted file mode 100644
index f7315e6f52c0..000000000000
--- a/tools/testing/cxl/mock_pmem.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
-#include <cxl.h>
-#include "test/mock.h"
-#include <core/core.h>
-
-int match_nvdimm_bridge(struct device *dev, const void *data)
-{
-	int index, rc = 0;
-	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
-	const struct cxl_nvdimm *cxl_nvd = data;
-
-	if (ops) {
-		if (dev->type == &cxl_nvdimm_bridge_type &&
-		    (ops->is_mock_dev(dev->parent->parent) ==
-		     ops->is_mock_dev(cxl_nvd->dev.parent->parent)))
-			rc = 1;
-	} else
-		rc = dev->type == &cxl_nvdimm_bridge_type;
-
-	put_cxl_mock_ops(index);
-
-	return rc;
-}


