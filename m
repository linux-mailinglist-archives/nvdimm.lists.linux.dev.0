Return-Path: <nvdimm+bounces-2578-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0058B4976BE
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jan 2022 01:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id B367A3E1436
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jan 2022 00:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E086E2CB6;
	Mon, 24 Jan 2022 00:31:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BD2CA7
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984312; x=1674520312;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UOt1RmkH36sMFykRBR92PUgZMphO1zeepPOf4BuhQR4=;
  b=lw5Z9hV/DR753uobBjxFesoZl+xCaVF6ppgETRJ4tjtCQftbKtDXeBeo
   LrUVgxgxd9nHDc0MabramxDW4YffXVvwJ5lFCLbPzP1L783tiCFKVfFWZ
   sBQBEYrzrI/ILiuagA9m9oI45j6gJ/g9o1/WvIsRL99+M5ZntIReleup3
   ItXfELNA5juOQGYvQHu5qlH/YiulUU1CTndVzIzluVnE6VngwKUkETmDG
   mdee7Tht1xdzCbdIZXarRvqqGRu8nh4ZUDNchlrxmywLDNzCaHg0/V/6C
   uBUJap3+w7GvTVEwMk5cTXxMfcnLF4207DPKv7ei8R83foYZqcTVRr7nO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309256082"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309256082"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="478862961"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:51 -0800
Subject: [PATCH v3 36/40] tools/testing/cxl: Mock dvsec_ranges()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:31:51 -0800
Message-ID: <164298431119.3018233.17175518196764977542.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

For test purposes, pretend that that CXL DVSEC ranges are not in active
use and the device is ready CXL.mem operation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 36ef337c775c..b6b726eff3e2 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -248,6 +248,14 @@ static void label_area_release(void *lsa)
 	vfree(lsa);
 }
 
+static void mock_validate_dvsec_ranges(struct cxl_dev_state *cxlds)
+{
+	struct cxl_endpoint_dvsec_info *info;
+
+	info = &cxlds->info;
+	info->mem_enabled = true;
+}
+
 static int cxl_mock_mem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -285,6 +293,8 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
+	mock_validate_dvsec_ranges(cxlds);
+
 	cxlmd = devm_cxl_add_memdev(cxlds);
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);


