Return-Path: <nvdimm+bounces-3989-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id ED05A558F9C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 06:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 807772E0A53
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 04:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325F123A5;
	Fri, 24 Jun 2022 04:20:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6181FDD;
	Fri, 24 Jun 2022 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044410; x=1687580410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=doqMnMZaLZqXI5lHzZ/n37xKfTdx3Elte7spEgmJPmE=;
  b=XghDEbLuSnI6CFVL4z1vVhWUM7CBzkeJrJGd/ophCWe1plmlNzE1E3/K
   rPYRMOO4voSjEcPa5b7f0ZSKLZ6v8i0+mE1iEtYsOPYzYdY29POog02xs
   WNxDzjwWgMqBoJ5OGfF8axHCJ9Z46NL4AWK5t6o9WdiYCLw4TBvUrCLYQ
   7bhTIWAbEgnTTK6Y6UbK5PA/j/IAzOa9YQu+DiKFSPyu0tTGBpRKF6bmc
   meYPp8uoEFf1k2XZmKA2GPsOWMNTXssd9LWImhrZeIxfOasyPKC76Mxot
   DeEKMJO958n0kQTduGqFVCBBnEnUgFskOljxrf2+a2A13aa+94EBp1KAg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912779"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912779"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:09 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092896"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:08 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 26/46] cxl/port: Record parent dport when adding ports
Date: Thu, 23 Jun 2022 21:19:30 -0700
Message-Id: <20220624041950.559155-1-dan.j.williams@intel.com>
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

At the time that cxl_port instances are being created, cache the dport
from the parent port that points to this new child port. This will be
useful for region provisioning when walking the tree to calculate
decoder targets, and saves rewalking the dport list after the fact to
build this information.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c      |  3 +--
 drivers/cxl/core/port.c | 30 +++++++++++++++++-------------
 drivers/cxl/cxl.h       |  7 +++++--
 drivers/cxl/mem.c       | 10 ++++++----
 4 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 5972f380cdf2..09fe92177d03 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -212,8 +212,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	if (rc)
 		return rc;
 
-	port = devm_cxl_add_port(host, match, dport->component_reg_phys,
-				 root_port);
+	port = devm_cxl_add_port(host, match, dport->component_reg_phys, dport);
 	if (IS_ERR(port))
 		return PTR_ERR(port);
 	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c54e1dbf92cb..8f53f59dd0fa 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -526,7 +526,7 @@ static struct lock_class_key cxl_port_key;
 
 static struct cxl_port *cxl_port_alloc(struct device *uport,
 				       resource_size_t component_reg_phys,
-				       struct cxl_port *parent_port)
+				       struct cxl_dport *parent_dport)
 {
 	struct cxl_port *port;
 	struct device *dev;
@@ -548,9 +548,12 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	 * description.
 	 */
 	dev = &port->dev;
-	if (parent_port) {
-		dev->parent = &parent_port->dev;
+	if (parent_dport) {
+		struct cxl_port *parent_port = parent_dport->port;
+
 		port->depth = parent_port->depth + 1;
+		port->parent_dport = parent_dport;
+		dev->parent = &parent_port->dev;
 	} else
 		dev->parent = uport;
 
@@ -579,24 +582,24 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
  * @host: host device for devm operations
  * @uport: "physical" device implementing this upstream port
  * @component_reg_phys: (optional) for configurable cxl_port instances
- * @parent_port: next hop up in the CXL memory decode hierarchy
+ * @parent_dport: next hop up in the CXL memory decode hierarchy
  */
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
-				   struct cxl_port *parent_port)
+				   struct cxl_dport *parent_dport)
 {
 	struct cxl_port *port;
 	struct device *dev;
 	int rc;
 
-	port = cxl_port_alloc(uport, component_reg_phys, parent_port);
+	port = cxl_port_alloc(uport, component_reg_phys, parent_dport);
 	if (IS_ERR(port))
 		return port;
 
 	dev = &port->dev;
 	if (is_cxl_memdev(uport))
 		rc = dev_set_name(dev, "endpoint%d", port->id);
-	else if (parent_port)
+	else if (parent_dport)
 		rc = dev_set_name(dev, "port%d", port->id);
 	else
 		rc = dev_set_name(dev, "root%d", port->id);
@@ -998,7 +1001,7 @@ static void delete_endpoint(void *data)
 	struct cxl_port *parent_port;
 	struct device *parent;
 
-	parent_port = cxl_mem_find_port(cxlmd);
+	parent_port = cxl_mem_find_port(cxlmd, NULL);
 	if (!parent_port)
 		goto out;
 	parent = &parent_port->dev;
@@ -1133,8 +1136,8 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 {
 	struct device *dparent = grandparent(dport_dev);
 	struct cxl_port *port, *parent_port = NULL;
+	struct cxl_dport *dport, *parent_dport;
 	resource_size_t component_reg_phys;
-	struct cxl_dport *dport;
 	int rc;
 
 	if (!dparent) {
@@ -1148,7 +1151,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 		return -ENXIO;
 	}
 
-	parent_port = find_cxl_port(dparent, NULL);
+	parent_port = find_cxl_port(dparent, &parent_dport);
 	if (!parent_port) {
 		/* iterate to create this parent_port */
 		return -EAGAIN;
@@ -1167,7 +1170,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 	if (!port) {
 		component_reg_phys = find_component_registers(uport_dev);
 		port = devm_cxl_add_port(&parent_port->dev, uport_dev,
-					 component_reg_phys, parent_port);
+					 component_reg_phys, parent_dport);
 		/* retry find to pick up the new dport information */
 		if (!IS_ERR(port))
 			port = find_cxl_port_at(parent_port, dport_dev, &dport);
@@ -1274,9 +1277,10 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_enumerate_ports, CXL);
 
-struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd)
+struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
+				   struct cxl_dport **dport)
 {
-	return find_cxl_port(grandparent(&cxlmd->dev), NULL);
+	return find_cxl_port(grandparent(&cxlmd->dev), dport);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_mem_find_port, CXL);
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index e654251a54dd..55d34b1576f1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -325,6 +325,7 @@ struct cxl_nvdimm {
  * @id: id for port device-name
  * @dports: cxl_dport instances referenced by decoders
  * @endpoints: cxl_ep instances, endpoints that are a descendant of this port
+ * @parent_dport: dport that points to this port in the parent
  * @decoder_ida: allocator for decoder ids
  * @dpa_end: cursor to track highest allocated decoder for allocation ordering
  * @component_reg_phys: component register capability base address (optional)
@@ -337,6 +338,7 @@ struct cxl_port {
 	int id;
 	struct list_head dports;
 	struct list_head endpoints;
+	struct cxl_dport *parent_dport;
 	struct ida decoder_ida;
 	int dpa_end;
 	resource_size_t component_reg_phys;
@@ -391,11 +393,12 @@ int devm_cxl_register_pci_bus(struct device *host, struct device *uport,
 struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
-				   struct cxl_port *parent_port);
+				   struct cxl_dport *parent_dport);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
 int cxl_bus_rescan(void);
-struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd);
+struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
+				   struct cxl_dport **dport);
 bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);
 
 struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 7513bea55145..2786d3402c9e 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -26,14 +26,15 @@
  */
 
 static int create_endpoint(struct cxl_memdev *cxlmd,
-			   struct cxl_port *parent_port)
+			   struct cxl_dport *parent_dport)
 {
+	struct cxl_port *parent_port = parent_dport->port;
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint;
 	int rc;
 
 	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
-				     cxlds->component_reg_phys, parent_port);
+				     cxlds->component_reg_phys, parent_dport);
 	if (IS_ERR(endpoint))
 		return PTR_ERR(endpoint);
 
@@ -76,6 +77,7 @@ static int cxl_mem_probe(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_port *parent_port;
+	struct cxl_dport *dport;
 	struct dentry *dentry;
 	int rc;
 
@@ -100,7 +102,7 @@ static int cxl_mem_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	parent_port = cxl_mem_find_port(cxlmd);
+	parent_port = cxl_mem_find_port(cxlmd, &dport);
 	if (!parent_port) {
 		dev_err(dev, "CXL port topology not found\n");
 		return -ENXIO;
@@ -114,7 +116,7 @@ static int cxl_mem_probe(struct device *dev)
 		goto unlock;
 	}
 
-	rc = create_endpoint(cxlmd, parent_port);
+	rc = create_endpoint(cxlmd, dport);
 unlock:
 	device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);
-- 
2.36.1


