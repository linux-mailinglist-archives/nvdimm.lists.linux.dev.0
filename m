Return-Path: <nvdimm+bounces-2690-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D51E4A4C60
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 17:45:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 500D53E0EA0
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 16:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED2D2CA8;
	Mon, 31 Jan 2022 16:44:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD7F2C9C
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643647493; x=1675183493;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+POaOO8XVYIqdbNVEX/O2EMlRpfK8xfi285k4duKeZ4=;
  b=R48bw2d1livlAVRqVDgGhLtlWeLRTZ4OwZNw5dOb7QgENCwvRUPnuUBF
   Cv2a4SwehNxK3BCwV6Lz5cVEhSjPAxOWu/ufdXiWvwa/upKbt45YxFA+o
   vRwyfQdmWlUXfo4/Gd7HS2xEDyX8MzWnOQvuNTwnjKzmPmVTkIUC9bYhi
   coTty3dlCgn2yOD9KQEqpusfE2n/vW7N/svE3erLZqKm8VdQSfR4QxiUG
   2fGgbZF0agzz2iAgduUeTPSo6RL3NTObWnUIIJwCtlLymQiqPkz4pSgGs
   1+9rU+wlCUN9MHHzQLNxJX8xBDY8b4VF7huzViXkzGrt+wogGzwWtIucT
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="234894482"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="234894482"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 08:44:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="582716956"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 08:44:52 -0800
Subject: [PATCH v4 17/40] cxl/port: Introduce cxl_port_to_pci_bus()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 31 Jan 2022 08:44:52 -0800
Message-ID: <164364745633.85488.9744017377155103992.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298420951.3018233.1498794101372312682.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298420951.3018233.1498794101372312682.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add a helper for converting a PCI enumerated cxl_port into the pci_bus
that hosts its dports. For switch ports this is trivial, but for root
ports there is no generic way to go from a platform defined host bridge
device, like ACPI0016 to its corresponding pci_bus. Rather than spill
ACPI goop outside of the cxl_acpi driver, just arrange for it to
register an xarray translation from the uport device to the
corresponding pci_bus.

This is in preparation for centralizing dport enumeration in the core.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- fixup inconsistent whitespace per clang-format default (Jonathan)

 drivers/cxl/acpi.c      |   14 +++++++++-----
 drivers/cxl/core/port.c |   37 +++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |    3 +++
 3 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 93d1dc56892a..ab2b76532272 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -225,17 +225,21 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 		return 0;
 	}
 
+	/*
+	 * Note that this lookup already succeeded in
+	 * to_cxl_host_bridge(), so no need to check for failure here
+	 */
+	pci_root = acpi_pci_find_root(bridge->handle);
+	rc = devm_cxl_register_pci_bus(host, match, pci_root->bus);
+	if (rc)
+		return rc;
+
 	port = devm_cxl_add_port(host, match, dport->component_reg_phys,
 				 root_port);
 	if (IS_ERR(port))
 		return PTR_ERR(port);
 	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
 
-	/*
-	 * Note that this lookup already succeeded in
-	 * to_cxl_host_bridge(), so no need to check for failure here
-	 */
-	pci_root = acpi_pci_find_root(bridge->handle);
 	ctx = (struct cxl_walk_context){
 		.dev = host,
 		.root = pci_root->bus,
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 5188d47180f1..8b68cea578c4 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -25,6 +25,7 @@
  */
 
 static DEFINE_IDA(cxl_port_ida);
+static DEFINE_XARRAY(cxl_root_buses);
 
 static ssize_t devtype_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
@@ -420,6 +421,42 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_port, CXL);
 
+struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port)
+{
+	/* There is no pci_bus associated with a CXL platform-root port */
+	if (is_cxl_root(port))
+		return NULL;
+
+	if (dev_is_pci(port->uport)) {
+		struct pci_dev *pdev = to_pci_dev(port->uport);
+
+		return pdev->subordinate;
+	}
+
+	return xa_load(&cxl_root_buses, (unsigned long)port->uport);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_port_to_pci_bus, CXL);
+
+static void unregister_pci_bus(void *uport)
+{
+	xa_erase(&cxl_root_buses, (unsigned long)uport);
+}
+
+int devm_cxl_register_pci_bus(struct device *host, struct device *uport,
+			      struct pci_bus *bus)
+{
+	int rc;
+
+	if (dev_is_pci(uport))
+		return -EINVAL;
+
+	rc = xa_insert(&cxl_root_buses, (unsigned long)uport, bus, GFP_KERNEL);
+	if (rc)
+		return rc;
+	return devm_add_action_or_reset(host, unregister_pci_bus, uport);
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_register_pci_bus, CXL);
+
 static struct cxl_dport *find_dport(struct cxl_port *port, int id)
 {
 	struct cxl_dport *dport;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 47c256ad105f..4e8d504546c5 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -289,6 +289,9 @@ static inline bool is_cxl_root(struct cxl_port *port)
 
 bool is_cxl_port(struct device *dev);
 struct cxl_port *to_cxl_port(struct device *dev);
+int devm_cxl_register_pci_bus(struct device *host, struct device *uport,
+			      struct pci_bus *bus);
+struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
 				   struct cxl_port *parent_port);


