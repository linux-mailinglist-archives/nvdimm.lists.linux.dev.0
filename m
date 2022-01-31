Return-Path: <nvdimm+bounces-2706-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8E54A517D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 22:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 31B183E0F46
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 21:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811DC3FE5;
	Mon, 31 Jan 2022 21:33:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68512C82
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 21:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643664799; x=1675200799;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AKxtkV2nWEtyxc0yUPzos0ai3+HqJxpnpoG1PScXq/Q=;
  b=IAXE9QLaLPTQ0TuRXAm5t4sorcnYuRyVGcA2kUuS62engnaAj8rxNYif
   HJ1n8Tn/lyAFsXvPuaXuaRXqBV/umS5RPs/4uL+CWaY3HZesj/rEpa+Fk
   3cvATDZGvvqwsu3C7ht5dzZVHG4VDRw7InXogZ/ETHzZK9JhGTLk2ZufH
   vcuBC2kIoZ9zA+r6AR3KX9QYl3aN92aSTmfM+MrWr5jOzypWGw7TV0c6x
   BhODkQ5MXH0jw5hMNzFBN191BBSG2rj4G1jG/w7KgJ9pIBWiT2wf4rZa4
   gvFNa5U30mZJ4ZYelUKoi2BNu/R8A4nKyiN4pb89f9OpfF9pXstiV8DR+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="231126357"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="231126357"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 13:33:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="479361253"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 13:33:13 -0800
Subject: [PATCH v4 11/40] cxl/core/port: Clarify decoder creation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 31 Jan 2022 13:33:13 -0800
Message-ID: <164366463014.111117.9714595404002687111.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298417755.3018233.850001481653928773.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298417755.3018233.850001481653928773.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <ben.widawsky@intel.com>

Add wrappers for the creation of decoder objects at the root level and
switch level, and keep the core helper private to cxl/core/port.c. Root
decoders are static descriptors conveyed from platform firmware (e.g.
ACPI CFMWS). Switch decoders are CXL standard decoders enumerated via
the HDM decoder capability structure. The base address for the HDM
decoder capability structure may be conveyed either by PCIe or platform
firmware (ACPI CEDT.CHBS).

Additionally, the kdoc descriptions for these helpers and their
dependencies is updated.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
[djbw: fixup changelog, clarify kdoc]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Clarify 'switch' in cxl_switch_decoder_alloc() kdoc (Jonathan)
- Clarify 'root' in cxl_root_decoder_alloc() kdoc (Jonathan)
- Add comment explaing how is_cxl_root() works (Jonathan)
- Fixup changelog to mention doc additions (Jonathan)

 drivers/cxl/acpi.c      |    4 +-
 drivers/cxl/core/port.c |   83 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/cxl/cxl.h       |   16 ++++++++-
 3 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index da70f1836db6..0b267eabb15e 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -102,7 +102,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	for (i = 0; i < CFMWS_INTERLEAVE_WAYS(cfmws); i++)
 		target_map[i] = cfmws->interleave_targets[i];
 
-	cxld = cxl_decoder_alloc(root_port, CFMWS_INTERLEAVE_WAYS(cfmws));
+	cxld = cxl_root_decoder_alloc(root_port, CFMWS_INTERLEAVE_WAYS(cfmws));
 	if (IS_ERR(cxld))
 		return 0;
 
@@ -260,7 +260,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	 * dport. Disable the range until the first CXL region is enumerated /
 	 * activated.
 	 */
-	cxld = cxl_decoder_alloc(port, 1);
+	cxld = cxl_switch_decoder_alloc(port, 1);
 	if (IS_ERR(cxld))
 		return PTR_ERR(cxld);
 
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 63c76cb2a2ec..88ffec71464a 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -495,13 +495,26 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
 	return rc;
 }
 
-struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
+/**
+ * cxl_decoder_alloc - Allocate a new CXL decoder
+ * @port: owning port of this decoder
+ * @nr_targets: downstream targets accessible by this decoder. All upstream
+ *		ports and root ports must have at least 1 target.
+ *
+ * A port should contain one or more decoders. Each of those decoders enable
+ * some address space for CXL.mem utilization. A decoder is expected to be
+ * configured by the caller before registering.
+ *
+ * Return: A new cxl decoder to be registered by cxl_decoder_add()
+ */
+static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
+					     unsigned int nr_targets)
 {
 	struct cxl_decoder *cxld;
 	struct device *dev;
 	int rc = 0;
 
-	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE || nr_targets < 1)
+	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE || nr_targets == 0)
 		return ERR_PTR(-EINVAL);
 
 	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
@@ -519,20 +532,74 @@ struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 	device_set_pm_not_required(dev);
 	dev->parent = &port->dev;
 	dev->bus = &cxl_bus_type;
-
-	/* root ports do not have a cxl_port_type parent */
-	if (port->dev.parent->type == &cxl_port_type)
-		dev->type = &cxl_decoder_switch_type;
+	if (is_cxl_root(port))
+		cxld->dev.type = &cxl_decoder_root_type;
 	else
-		dev->type = &cxl_decoder_root_type;
+		cxld->dev.type = &cxl_decoder_switch_type;
 
 	return cxld;
 err:
 	kfree(cxld);
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_NS_GPL(cxl_decoder_alloc, CXL);
 
+/**
+ * cxl_root_decoder_alloc - Allocate a root level decoder
+ * @port: owning CXL root of this decoder
+ * @nr_targets: static number of downstream targets
+ *
+ * Return: A new cxl decoder to be registered by cxl_decoder_add(). A
+ * 'CXL root' decoder is one that decodes from a top-level / static platform
+ * firmware description of CXL resources into a CXL standard decode
+ * topology.
+ */
+struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
+					   unsigned int nr_targets)
+{
+	if (!is_cxl_root(port))
+		return ERR_PTR(-EINVAL);
+
+	return cxl_decoder_alloc(port, nr_targets);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_root_decoder_alloc, CXL);
+
+/**
+ * cxl_switch_decoder_alloc - Allocate a switch level decoder
+ * @port: owning CXL switch port of this decoder
+ * @nr_targets: max number of dynamically addressable downstream targets
+ *
+ * Return: A new cxl decoder to be registered by cxl_decoder_add(). A
+ * 'switch' decoder is any decoder that can be enumerated by PCIe
+ * topology and the HDM Decoder Capability. This includes the decoders
+ * that sit between Switch Upstream Ports / Switch Downstream Ports and
+ * Host Bridges / Root Ports.
+ */
+struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
+					     unsigned int nr_targets)
+{
+	if (is_cxl_root(port))
+		return ERR_PTR(-EINVAL);
+
+	return cxl_decoder_alloc(port, nr_targets);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_switch_decoder_alloc, CXL);
+
+/**
+ * cxl_decoder_add - Add a decoder with targets
+ * @cxld: The cxl decoder allocated by cxl_decoder_alloc()
+ * @target_map: A list of downstream ports that this decoder can direct memory
+ *              traffic to. These numbers should correspond with the port number
+ *              in the PCIe Link Capabilities structure.
+ *
+ * Certain types of decoders may not have any targets. The main example of this
+ * is an endpoint device. A more awkward example is a hostbridge whose root
+ * ports get hot added (technically possible, though unlikely).
+ *
+ * Context: Process context. Takes and releases the cxld's device lock.
+ *
+ * Return: Negative error code if the decoder wasn't properly configured; else
+ *	   returns 0.
+ */
 int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
 {
 	struct cxl_port *port;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index bfd95acea66c..621a70e023c1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -278,6 +278,17 @@ struct cxl_dport {
 	struct list_head list;
 };
 
+/*
+ * The platform firmware device hosting the root is also the top of the
+ * CXL port topology. All other CXL ports have another CXL port as their
+ * parent and their ->uport / host device is out-of-line of the port
+ * ancestry.
+ */
+static inline bool is_cxl_root(struct cxl_port *port)
+{
+	return port->uport == port->dev.parent;
+}
+
 struct cxl_port *to_cxl_port(struct device *dev);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
@@ -288,7 +299,10 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 bool is_root_decoder(struct device *dev);
-struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets);
+struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
+					   unsigned int nr_targets);
+struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
+					     unsigned int nr_targets);
 int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
 int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
 


