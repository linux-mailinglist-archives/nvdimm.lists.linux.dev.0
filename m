Return-Path: <nvdimm+bounces-3994-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE997558FA8
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 06:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C36D280C88
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 04:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7D623BC;
	Fri, 24 Jun 2022 04:20:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D67923B3;
	Fri, 24 Jun 2022 04:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044414; x=1687580414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TmO5WC2sgc0jo0rcoMKAabKd56FHXClv4MSAUMadPB8=;
  b=CbSsPBtefrTF6+TDsE6IR0KkrNJepRvkvFkIRv6NsX61NXMroZFJBOvA
   YSz7ot1qzu8qnQVqbMN/0SKKlJaT4uSj2lBJMTNGAlM3WFSitEhS4FRQZ
   EPrk2rUJh8iQXjS1LK0Nje81+L0zh1TMnMxV5q33hIAK/WvBJuOxUnjE1
   diTyjQPcP1bKFsZGsihPiZg0hIXp7HEDMmYPYuhQHwHgU//ZVgOo6FFmA
   WkPv5xgRvb6sWcQjoYYt8yTotOj8EeL/mKfFJhuFZGOHE81jNEfeuq8di
   syZlnw4/BGDH8otkp0l8+7yeg/eXw0gyL06sKAmkPhNbadZGaVDfK+unx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912793"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912793"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092921"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:11 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 32/46] cxl/mem: Enumerate port targets before adding endpoints
Date: Thu, 23 Jun 2022 21:19:36 -0700
Message-Id: <20220624041950.559155-7-dan.j.williams@intel.com>
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

The port scanning algorithm in devm_cxl_enumerate_ports() walks up the
topology and adds cxl_port objects starting from the root down to the
endpoint. When those ports are initially created they know all their
dports, but they do not know the downstream cxl_port instance that
represents the next descendant in the topology. Rework create_endpoint()
into devm_cxl_add_endpoint() that enumerates the downstream cxl_port
topology into each port's 'struct cxl_ep' record for each endpoint it
that the port is an ancestor.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  7 ++++++-
 drivers/cxl/mem.c       | 30 +-----------------------------
 3 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 08a380d20cf1..2e56903399c2 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1089,6 +1089,47 @@ static struct cxl_ep *cxl_ep_load(struct cxl_port *port,
 	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
 }
 
+int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
+			  struct cxl_dport *parent_dport)
+{
+	struct cxl_port *parent_port = parent_dport->port;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_port *endpoint, *iter, *down;
+	int rc;
+
+	/*
+	 * Now that the path to the root is established record all the
+	 * intervening ports in the chain.
+	 */
+	for (iter = parent_port, down = NULL; !is_cxl_root(iter);
+	     down = iter, iter = to_cxl_port(iter->dev.parent)) {
+		struct cxl_ep *ep;
+
+		ep = cxl_ep_load(iter, cxlmd);
+		ep->next = down;
+	}
+
+	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
+				     cxlds->component_reg_phys, parent_dport);
+	if (IS_ERR(endpoint))
+		return PTR_ERR(endpoint);
+
+	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
+
+	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
+	if (rc)
+		return rc;
+
+	if (!endpoint->dev.driver) {
+		dev_err(&cxlmd->dev, "%s failed probe\n",
+			dev_name(&endpoint->dev));
+		return -ENXIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_endpoint, CXL);
+
 static void cxl_detach_ep(void *data)
 {
 	struct cxl_memdev *cxlmd = data;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 0211cf0d3574..f761cf78cc05 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -371,11 +371,14 @@ struct cxl_dport {
 /**
  * struct cxl_ep - track an endpoint's interest in a port
  * @ep: device that hosts a generic CXL endpoint (expander or accelerator)
- * @dport: which dport routes to this endpoint on this port
+ * @dport: which dport routes to this endpoint on @port
+ * @next: cxl switch port across the link attached to @dport NULL if
+ *	  attached to an endpoint
  */
 struct cxl_ep {
 	struct device *ep;
 	struct cxl_dport *dport;
+	struct cxl_port *next;
 };
 
 /*
@@ -398,6 +401,8 @@ struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
 				   struct cxl_dport *parent_dport);
+int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
+			  struct cxl_dport *parent_dport);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
 int cxl_bus_rescan(void);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 2786d3402c9e..64ccf053d32c 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -25,34 +25,6 @@
  * in higher level operations.
  */
 
-static int create_endpoint(struct cxl_memdev *cxlmd,
-			   struct cxl_dport *parent_dport)
-{
-	struct cxl_port *parent_port = parent_dport->port;
-	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_port *endpoint;
-	int rc;
-
-	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
-				     cxlds->component_reg_phys, parent_dport);
-	if (IS_ERR(endpoint))
-		return PTR_ERR(endpoint);
-
-	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
-
-	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
-	if (rc)
-		return rc;
-
-	if (!endpoint->dev.driver) {
-		dev_err(&cxlmd->dev, "%s failed probe\n",
-			dev_name(&endpoint->dev));
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
 static void enable_suspend(void *data)
 {
 	cxl_mem_active_dec();
@@ -116,7 +88,7 @@ static int cxl_mem_probe(struct device *dev)
 		goto unlock;
 	}
 
-	rc = create_endpoint(cxlmd, dport);
+	rc = devm_cxl_add_endpoint(cxlmd, dport);
 unlock:
 	device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);
-- 
2.36.1


