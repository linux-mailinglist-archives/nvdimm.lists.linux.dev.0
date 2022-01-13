Return-Path: <nvdimm+bounces-2473-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AF148CF55
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jan 2022 00:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id EAA923E102B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jan 2022 23:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FB72CBF;
	Wed, 12 Jan 2022 23:48:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980812CAA;
	Wed, 12 Jan 2022 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642031290; x=1673567290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X6CjwOFFFHc6OVo8FaPhu6pmolHF36k6t/VbYpwK0WU=;
  b=eSuyXUhsTnjbSJy2no4wL1Q8AI+BUfQTWwJEA/OxTScndP1dAZYYsUf+
   s74mAeVNaqP6l243bl5U+mTSHgj5XwdaYghJW+7IFIX4y4vN1h6DYZax6
   8JtJ1wMoIt1ynpTwFxrUiEU/KcLn4AY6hL18J5esxh6DMk/uUCoIfNcpi
   Pvt/68SroLIruVaEkXyQZiyOEAZGX+Nyhy/InjqwbczNM2SH3BfwVtm4y
   k3uTiM4IMW+ewci+j74G+e0MHlDJHMbeeH8tXRaSJF2vtEjwVb+Cr/G6A
   A/KbEaDY/0mtwLmebvZf8/h4mOyGoXj0bCgeoFKm6/r7gGnKKffkDn1bT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243673318"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243673318"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="670324202"
Received: from jmaclean-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.136.131])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:09 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 10/15] cxl/region: HB port config verification
Date: Wed, 12 Jan 2022 15:47:44 -0800
Message-Id: <20220112234749.1965960-11-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220112234749.1965960-1-ben.widawsky@intel.com>
References: <20220112234749.1965960-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Host bridge root port verification determines if the device ordering in
an interleave set can be programmed through the host bridges and
switches.

The algorithm implemented here is based on the CXL Type 3 Memory Device
Software Guide, chapter 2.13.15

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 .clang-format           |   1 +
 drivers/cxl/core/port.c |   1 +
 drivers/cxl/cxl.h       |   2 +
 drivers/cxl/region.c    | 122 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/.clang-format b/.clang-format
index 55f628f21722..96c282b63e7b 100644
--- a/.clang-format
+++ b/.clang-format
@@ -171,6 +171,7 @@ ForEachMacros:
   - 'for_each_cpu_wrap'
   - 'for_each_cxl_decoder_target'
   - 'for_each_cxl_endpoint'
+  - 'for_each_cxl_endpoint_hb'
   - 'for_each_dapm_widgets'
   - 'for_each_dev_addr'
   - 'for_each_dev_scope'
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 67f3345d44ef..99589f23f1ff 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -585,6 +585,7 @@ struct cxl_dport *cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&dport->list);
+	INIT_LIST_HEAD(&dport->verify_link);
 	dport->dport = get_device(dport_dev);
 	dport->port_id = port_id;
 	dport->component_reg_phys = component_reg_phys;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c62e93e8a369..4de4c0ee8eb2 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -316,6 +316,7 @@ struct cxl_port {
  * @port: reference to cxl_port that contains this downstream port
  * @list: node for a cxl_port's list of cxl_dport instances
  * @link_name: the name of the sysfs link from @port to @dport
+ * @verify_link: node used for hb root port verification
  */
 struct cxl_dport {
 	struct device *dport;
@@ -324,6 +325,7 @@ struct cxl_dport {
 	struct cxl_port *port;
 	struct list_head list;
 	char link_name[CXL_TARGET_STRLEN];
+	struct list_head verify_link;
 };
 
 /**
diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index c01b1ab9f757..1f8919ad8dcc 100644
--- a/drivers/cxl/region.c
+++ b/drivers/cxl/region.c
@@ -4,6 +4,7 @@
 #include <linux/genalloc.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/sort.h>
 #include <linux/pci.h>
 #include "cxlmem.h"
 #include "region.h"
@@ -37,6 +38,12 @@
 	     idx < region_ways(region);                                        \
 	     ep = (region)->config.targets[++idx])
 
+#define for_each_cxl_endpoint_hb(ep, region, hb, idx)                          \
+	for (idx = 0, (ep) = (region)->config.targets[idx];                    \
+	     idx < region_ways(region);                                        \
+	     idx++, (ep) = (region)->config.targets[idx])                      \
+		if (get_hostbridge(ep) == (hb))
+
 #define for_each_cxl_decoder_target(dport, decoder, idx)                      \
 	for (idx = 0, dport = (decoder)->target[idx];                         \
 	     idx < (decoder)->nr_targets;                                     \
@@ -285,6 +292,59 @@ static bool region_xhb_config_valid(const struct cxl_region *region,
 	return true;
 }
 
+static struct cxl_dport *get_rp(struct cxl_memdev *ep)
+{
+	struct cxl_port *port, *parent_port = port = ep->port;
+	struct cxl_dport *dport;
+
+	while (!is_cxl_root(port)) {
+		parent_port = to_cxl_port(port->dev.parent);
+		if (parent_port->depth == 1)
+			list_for_each_entry(dport, &parent_port->dports, list)
+				if (dport->dport == port->uport->parent->parent)
+					return dport;
+		port = parent_port;
+	}
+
+	BUG();
+	return NULL;
+}
+
+static int get_num_root_ports(const struct cxl_region *region)
+{
+	struct cxl_memdev *endpoint;
+	struct cxl_dport *dport, *tmp;
+	int num_root_ports = 0;
+	LIST_HEAD(root_ports);
+	int idx;
+
+	for_each_cxl_endpoint(endpoint, region, idx) {
+		struct cxl_dport *root_port = get_rp(endpoint);
+
+		if (list_empty(&root_port->verify_link)) {
+			list_add_tail(&root_port->verify_link, &root_ports);
+			num_root_ports++;
+		}
+	}
+
+	list_for_each_entry_safe(dport, tmp, &root_ports, verify_link)
+		list_del_init(&dport->verify_link);
+
+	return num_root_ports;
+}
+
+static bool has_switch(const struct cxl_region *region)
+{
+	struct cxl_memdev *ep;
+	int i;
+
+	for_each_cxl_endpoint(ep, region, i)
+		if (ep->port->depth > 2)
+			return true;
+
+	return false;
+}
+
 /**
  * region_hb_rp_config_valid() - determine root port ordering is correct
  * @rootd: root decoder for this @region
@@ -298,7 +358,67 @@ static bool region_xhb_config_valid(const struct cxl_region *region,
 static bool region_hb_rp_config_valid(const struct cxl_region *region,
 				      const struct cxl_decoder *rootd)
 {
-	/* TODO: */
+	const int num_root_ports = get_num_root_ports(region);
+	struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
+	int hb_count, i;
+
+	hb_count = get_unique_hostbridges(region, hbs);
+
+	/*
+	 * Are all devices in this region on the same CXL Host Bridge
+	 * Root Port?
+	 */
+	if (num_root_ports == 1 && !has_switch(region))
+		return true;
+
+	for (i = 0; i < hb_count; i++) {
+		int idx, position_mask;
+		struct cxl_dport *rp;
+		struct cxl_port *hb;
+
+		/* Get next CXL Host Bridge this region spans */
+		hb = hbs[i];
+
+		/*
+		 * Calculate the position mask: NumRootPorts = 2^PositionMask
+		 * for this region.
+		 *
+		 * XXX: pos_mask is actually (1 << PositionMask)  - 1
+		 */
+		position_mask = (1 << (ilog2(num_root_ports))) - 1;
+
+		/*
+		 * Calculate the PortGrouping for each device on this CXL Host
+		 * Bridge Root Port:
+		 * PortGrouping = RegionLabel.Position & PositionMask
+		 */
+		list_for_each_entry(rp, &hb->dports, list) {
+			struct cxl_memdev *ep;
+			int port_grouping = -1;
+
+			for_each_cxl_endpoint_hb(ep, region, hb, idx) {
+				/* Only endpoints under the same root port */
+				if (get_rp(ep) != rp)
+					continue;
+
+				if (port_grouping == -1) {
+					port_grouping = idx & position_mask;
+					continue;
+				}
+
+				/*
+				 * Do all devices in the region connected to this CXL
+				 * Host Bridge Root Port have the same PortGrouping?
+				 */
+				if ((idx & position_mask) != port_grouping) {
+					dev_dbg(&region->dev,
+						"One or more devices are not connected to the correct Host Bridge Root Port\n");
+					return false;
+				}
+			}
+		}
+	}
+
 	return true;
 }
 
-- 
2.34.1


