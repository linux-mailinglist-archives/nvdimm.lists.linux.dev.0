Return-Path: <nvdimm+bounces-2465-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A4648CF47
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jan 2022 00:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 8E56C3E0F69
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jan 2022 23:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68002CAB;
	Wed, 12 Jan 2022 23:48:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92DA2CA2;
	Wed, 12 Jan 2022 23:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642031284; x=1673567284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v+UW4m504aj7Y2/rdh0uUTe2dZa+1eAla8ODkXKHIW8=;
  b=WWt1WufeQ9rIi4BC+CmElU02bf56bGTxKU5VtdNY/bp/CId8YXnjLT+Z
   9xZ+Y9bRnLFw6/FQlhY9wcEgYrqPp4crWMxJy8qI6CwdOioGnNCN8+1MX
   fuf1lSeu56npxorg+NbV6L9PPzn0zrFfgS284pUxtC0/oINCjOGPBC+rV
   QAhCaZg06A6XANMDLQU05/P5bY6AJZNrEJCp5mb57d9kro565Y9NhVmip
   /glIcA8htOKczwfbarOmErxVfT8c4d/BLmVW8uI1V+lAbqqxZa54ZAh/d
   C3Dl45KMVisRWWKrlk5/HxiddmpLViZvQJnzZoQPr0+V9nY/otcTMGHSS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243673291"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243673291"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="670324172"
Received: from jmaclean-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.136.131])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:03 -0800
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
Subject: [PATCH v2 02/15] cxl/core: Track port depth
Date: Wed, 12 Jan 2022 15:47:36 -0800
Message-Id: <20220112234749.1965960-3-ben.widawsky@intel.com>
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

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/port.c | 7 ++++++-
 drivers/cxl/cxl.h       | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 5a1ffadd5d0d..ecab7cfa88f0 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -436,13 +436,18 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 {
 	struct cxl_port *port;
 	struct device *dev;
-	int rc;
+	int rc, depth = parent_port ? parent_port->depth + 1 : 0;
 
 	port = cxl_port_alloc(uport, component_reg_phys, parent_port);
 	if (IS_ERR(port))
 		return port;
 
+	if (dev_WARN_ONCE(&port->dev, parent_port && !depth,
+			  "Invalid parent port depth\n"))
+		return ERR_PTR(-ENODEV);
+
 	port->host = host;
+	port->depth = depth;
 	dev = &port->dev;
 	if (is_cxl_memdev(uport))
 		rc = dev_set_name(dev, "endpoint%d", port->id);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 276b93316e7f..6eeb82711443 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -272,6 +272,7 @@ struct cxl_walk_context {
  * @decoder_ida: allocator for decoder ids
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
+ * @depth: How deep this port is relative to the root. depth 0 is the root.
  */
 struct cxl_port {
 	struct device dev;
@@ -283,6 +284,7 @@ struct cxl_port {
 	struct ida decoder_ida;
 	resource_size_t component_reg_phys;
 	bool dead;
+	unsigned int depth;
 };
 
 /**
-- 
2.34.1


