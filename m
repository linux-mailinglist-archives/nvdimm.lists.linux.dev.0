Return-Path: <nvdimm+bounces-2623-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1A949D674
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jan 2022 00:59:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 6A7083E0F09
	for <lists+linux-nvdimm@lfdr.de>; Wed, 26 Jan 2022 23:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5405F3FE0;
	Wed, 26 Jan 2022 23:59:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921872CA9
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 23:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643241549; x=1674777549;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y58xquDc3V7DyNC7NTUtBsYIcGV8ga/AGHousy1DxZo=;
  b=UnOt1f/X6xjC00vYoh5+xm16S8XDOIStEPFHahiZt4PDw5pzxq+svK2A
   ZXxfffSlgJU6tQXTSNgl7bmOX6ylDioJgYLZjskVovn2ZAPxx68KwYDAY
   l7Pexn6T30RlATqtQ1RHGEXtr2sAkyQE8+//NGS6s2qGho3rF68K3iWeb
   OOR+oXrKAEnD83tkkMquW+coep3b2fHUrYe+rQysQPOrX5kvImReviSv3
   C7E0ysNilnxTfttVsrodr8MWNNGQfm4Si3yxgLVIuTRQAj5BCEV+tWjbp
   EOFU6oyYuSRcbDfhuVAG3F4jvGPrLrcY6iLAMjMFSaSt/gooukVCRPgT5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="227365849"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="227365849"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 15:59:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="628482768"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 15:59:07 -0800
Subject: [PATCH v5 18/40] cxl/pmem: Introduce a find_cxl_root() helper
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Wed, 26 Jan 2022 15:59:07 -0800
Message-ID: <164324151672.3935633.11277011056733051668.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164322333437.3694981.17087130505938650994.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164322333437.3694981.17087130505938650994.stgit@dwillia2-desk3.amr.corp.intel.com>
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
is registered. Note that the only know multi-domain CXL configurations
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
Changes since v4:
- reset @iter each loop otherwise only the first dport can be scanned.

 drivers/cxl/core/pmem.c       |   14 ++++++++---
 drivers/cxl/core/port.c       |   50 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h             |    1 +
 tools/testing/cxl/Kbuild      |    2 --
 tools/testing/cxl/mock_pmem.c |   24 --------------------
 5 files changed, 61 insertions(+), 30 deletions(-)
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
index 4c921c49f967..6447f12ef71d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -457,6 +457,56 @@ int devm_cxl_register_pci_bus(struct device *host, struct device *uport,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_register_pci_bus, CXL);
 
+/* Find a 2nd level CXL port that has a dport that is an ancestor of @match */
+static int match_cxl_root_child(struct device *dev, const void *match)
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
+	port_dev =
+		bus_find_device(&cxl_bus_type, NULL, dev, match_cxl_root_child);
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
index 4e8d504546c5..7523e4d60953 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -298,6 +298,7 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 
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


