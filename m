Return-Path: <nvdimm+bounces-2729-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B49FE4A5476
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 02:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 3CA073E0F23
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 01:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC493FE0;
	Tue,  1 Feb 2022 01:07:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22722CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643677658; x=1675213658;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kz4C9IlNb2Cm94xa+CQu8e9k7HD3jDLPkjGVRQb5+zg=;
  b=OiaHM9WBoKdRRL2F/OTN5LvhQnTfaA4tvCYejmChOKDeQguCvWMPVKoj
   iSao52XTSIjcMMm6dp/dMWVsIcPG5mtc5z7u3SJ468NJ1OMBcuT14YlW7
   DoE1QFJaI2W6TMoujyfehl4jjFK3mX6HsrGYxIPFsphVp352s19J2Bf9/
   FelbsOMsqruJCROaH70iCDC3Cmr5sxf6wEwyZqHO3n2ctJuxSem4TC5y5
   5sxmkExVA+Z4EKVQCbHq7B89hp7aRQXCmqDxl0za28mtYAuAoVzX/mw6U
   jWpnpz5j11MxmmYOxPirZK/3p8aLiuRgwNdsIF3VRQvpSokJALU/mdzKg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="231168176"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="231168176"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 17:07:38 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="630223013"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 17:07:38 -0800
Subject: [PATCH v4 19/40] cxl/port: Up-level cxl_add_dport() locking
 requirements to the caller
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 31 Jan 2022 17:07:38 -0800
Message-ID: <164367759016.324231.105551648350470000.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for moving dport enumeration into the core, require the
port device lock to be acquired by the caller.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Fix a rebase oversight that left device_lock() instead of
  cxl_device_lock(). (Jonathan and Ben)

 drivers/cxl/acpi.c            |    2 ++
 drivers/cxl/core/port.c       |    3 +--
 tools/testing/cxl/mock_acpi.c |    4 ++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index ab2b76532272..5d848b77d8e8 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -342,7 +342,9 @@ static int add_host_bridge_dport(struct device *match, void *arg)
 		return 0;
 	}
 
+	cxl_device_lock(&root_port->dev);
 	rc = cxl_add_dport(root_port, match, uid, ctx.chbcr);
+	cxl_device_unlock(&root_port->dev);
 	if (rc) {
 		dev_err(host, "failed to add downstream port: %s\n",
 			dev_name(match));
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index af7a515e4572..369cc52e0837 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -519,7 +519,7 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 {
 	struct cxl_dport *dup;
 
-	cxl_device_lock(&port->dev);
+	device_lock_assert(&port->dev);
 	dup = find_dport(port, new->port_id);
 	if (dup)
 		dev_err(&port->dev,
@@ -528,7 +528,6 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 			dev_name(dup->dport));
 	else
 		list_add_tail(&new->list, &port->dports);
-	cxl_device_unlock(&port->dev);
 
 	return dup ? -EEXIST : 0;
 }
diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
index 4c8a493ace56..c953e3ab6494 100644
--- a/tools/testing/cxl/mock_acpi.c
+++ b/tools/testing/cxl/mock_acpi.c
@@ -57,7 +57,9 @@ static int match_add_root_port(struct pci_dev *pdev, void *data)
 
 	/* TODO walk DVSEC to find component register base */
 	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
+	cxl_device_lock(&port->dev);
 	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
+	cxl_device_unlock(&port->dev);
 	if (rc) {
 		dev_err(dev, "failed to add dport: %s (%d)\n",
 			dev_name(&pdev->dev), rc);
@@ -78,7 +80,9 @@ static int mock_add_root_port(struct platform_device *pdev, void *data)
 	struct device *dev = ctx->dev;
 	int rc;
 
+	cxl_device_lock(&port->dev);
 	rc = cxl_add_dport(port, &pdev->dev, pdev->id, CXL_RESOURCE_NONE);
+	cxl_device_unlock(&port->dev);
 	if (rc) {
 		dev_err(dev, "failed to add dport: %s (%d)\n",
 			dev_name(&pdev->dev), rc);


