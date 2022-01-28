Return-Path: <nvdimm+bounces-2656-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB9D49EFA5
	for <lists+linux-nvdimm@lfdr.de>; Fri, 28 Jan 2022 01:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id A5F153E0F67
	for <lists+linux-nvdimm@lfdr.de>; Fri, 28 Jan 2022 00:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655323FFA;
	Fri, 28 Jan 2022 00:27:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB9E3FE5;
	Fri, 28 Jan 2022 00:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643329648; x=1674865648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Kaes42dLpbACpMEACjZ5MpAsHsOTY/I4nfdu15eLrk=;
  b=OaMAW6V7U2r/CHd7039E4pErdnZ/jjFLWY9KoAeovgVtAlqpS8SZ8aP4
   lWtF2lcDt1nJmLCVSxcMFBoKg5guSypgPbI2EgC3eT63nCf/V/lZ89LrK
   zrXbCdtKNkqdX3AZxUtBto4B/2tl4MuZEUoBUWrWyesTsYcGygNSMMPyt
   6lBTdmDv6QV5W/9GknfVGawvOXICZvwQUBopJGTHZfKNhEXClzQJVcTEA
   c8NBDxfR93QACw7SKarHIP9xJB3c8mxs8+AyXNt2wePdBNBPWP1FgmP+b
   tnIOEh1lM73P9O5q52CBlByyb6xi0tVnGCowpFVM3P40zyMbYahfqQpTJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226982078"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="226982078"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="674909636"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:26 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 08/14] cxl/region: HB port config verification
Date: Thu, 27 Jan 2022 16:27:01 -0800
Message-Id: <20220128002707.391076-9-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128002707.391076-1-ben.widawsky@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
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
Software Guide, chapter 2.13.15. The current version of the guide does
not yet support x3 interleave configurations, and so that's not
supported here either.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 .clang-format           |   1 +
 drivers/cxl/core/port.c |   1 +
 drivers/cxl/cxl.h       |   2 +
 drivers/cxl/region.c    | 127 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/.clang-format b/.clang-format
index 1221d53be90b..5e20206f905e 100644
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
index 0847e6ce19ef..1d81c5f56a3e 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -706,6 +706,7 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&dport->list);
+	INIT_LIST_HEAD(&dport->verify_link);
 	dport->dport = dport_dev;
 	dport->port_id = port_id;
 	dport->component_reg_phys = component_reg_phys;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index a291999431c7..ed984465b59c 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -350,6 +350,7 @@ struct cxl_port {
  * @component_reg_phys: downstream port component registers
  * @port: reference to cxl_port that contains this downstream port
  * @list: node for a cxl_port's list of cxl_dport instances
+ * @verify_link: node used for hb root port verification
  */
 struct cxl_dport {
 	struct device *dport;
@@ -357,6 +358,7 @@ struct cxl_dport {
 	resource_size_t component_reg_phys;
 	struct cxl_port *port;
 	struct list_head list;
+	struct list_head verify_link;
 };
 
 /**
diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index 562c8720da56..d2f6c990c8a8 100644
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
@@ -36,6 +37,12 @@
 	for (idx = 0, ep = (region)->config.targets[idx];                      \
 	     idx < region_ways(region); ep = (region)->config.targets[++idx])
 
+#define for_each_cxl_endpoint_hb(ep, region, hb, idx)                          \
+	for (idx = 0, (ep) = (region)->config.targets[idx];                    \
+	     idx < region_ways(region);                                        \
+	     idx++, (ep) = (region)->config.targets[idx])                      \
+		if (get_hostbridge(ep) == (hb))
+
 #define for_each_cxl_decoder_target(dport, decoder, idx)                       \
 	for (idx = 0, dport = (decoder)->target[idx];                          \
 	     idx < (decoder)->nr_targets - 1;                                  \
@@ -299,6 +306,59 @@ static bool region_xhb_config_valid(const struct cxl_region *cxlr,
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
+static int get_num_root_ports(const struct cxl_region *cxlr)
+{
+	struct cxl_memdev *endpoint;
+	struct cxl_dport *dport, *tmp;
+	int num_root_ports = 0;
+	LIST_HEAD(root_ports);
+	int idx;
+
+	for_each_cxl_endpoint(endpoint, cxlr, idx) {
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
+static bool has_switch(const struct cxl_region *cxlr)
+{
+	struct cxl_memdev *ep;
+	int i;
+
+	for_each_cxl_endpoint(ep, cxlr, i)
+		if (ep->port->depth > 2)
+			return true;
+
+	return false;
+}
+
 /**
  * region_hb_rp_config_valid() - determine root port ordering is correct
  * @cxlr: Region to validate
@@ -312,7 +372,72 @@ static bool region_xhb_config_valid(const struct cxl_region *cxlr,
 static bool region_hb_rp_config_valid(const struct cxl_region *cxlr,
 				      const struct cxl_decoder *rootd)
 {
-	/* TODO: */
+	const int num_root_ports = get_num_root_ports(cxlr);
+	struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
+	int hb_count, i;
+
+	hb_count = get_unique_hostbridges(cxlr, hbs);
+
+	/* TODO: Switch support */
+	if (has_switch(cxlr))
+		return false;
+
+	/*
+	 * Are all devices in this region on the same CXL Host Bridge
+	 * Root Port?
+	 */
+	if (num_root_ports == 1 && !has_switch(cxlr))
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
+		 *
+		 * The following nest iterators effectively iterate over each
+		 * root port in the region.
+		 *   for_each_unique_rootport(rp, cxlr)
+		 */
+		list_for_each_entry(rp, &hb->dports, list) {
+			struct cxl_memdev *ep;
+			int port_grouping = -1;
+
+			for_each_cxl_endpoint_hb(ep, cxlr, hb, idx) {
+				if (get_rp(ep) != rp)
+					continue;
+
+				if (port_grouping == -1)
+					port_grouping = idx & position_mask;
+
+				/*
+				 * Do all devices in the region connected to this CXL
+				 * Host Bridge Root Port have the same PortGrouping?
+				 */
+				if ((idx & position_mask) != port_grouping) {
+					dev_dbg(&cxlr->dev,
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
2.35.0


