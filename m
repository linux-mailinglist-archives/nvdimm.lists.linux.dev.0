Return-Path: <nvdimm+bounces-1205-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 856B54044CA
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 07:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A73461C0FAF
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 05:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EECB03FEA;
	Thu,  9 Sep 2021 05:12:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FDD3FE1
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:12:44 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="220712476"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="220712476"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:12:44 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="580698657"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:12:44 -0700
Subject: [PATCH v4 13/21] cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:12:44 -0700
Message-ID: <163116436415.2460985.10101824045493194813.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Define enabled_cmds as an embedded member of 'struct cxl_mem' rather
than a pointer to another dynamic allocation.

As this leaves only one user of cxl_cmd_count, just open code it and
delete the helper.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c |   12 +-----------
 drivers/cxl/cxlmem.h    |    2 +-
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 31e183991726..422999740649 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -315,8 +315,6 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
 	return 0;
 }
 
-#define cxl_cmd_count ARRAY_SIZE(cxl_mem_commands)
-
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
 		  struct cxl_mem_query_commands __user *q)
 {
@@ -332,7 +330,7 @@ int cxl_query_cmd(struct cxl_memdev *cxlmd,
 
 	/* returns the total number if 0 elements are requested. */
 	if (n_commands == 0)
-		return put_user(cxl_cmd_count, &q->n_commands);
+		return put_user(ARRAY_SIZE(cxl_mem_commands), &q->n_commands);
 
 	/*
 	 * otherwise, return max(n_commands, total commands) cxl_command_info
@@ -794,14 +792,6 @@ struct cxl_mem *cxl_mem_create(struct device *dev)
 
 	mutex_init(&cxlm->mbox_mutex);
 	cxlm->dev = dev;
-	cxlm->enabled_cmds =
-		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
-				   sizeof(unsigned long),
-				   GFP_KERNEL | __GFP_ZERO);
-	if (!cxlm->enabled_cmds) {
-		dev_err(dev, "No memory available for bitmap\n");
-		return ERR_PTR(-ENOMEM);
-	}
 
 	return cxlm;
 }
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 35fd16d12532..16201b7d82d2 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -126,7 +126,7 @@ struct cxl_mem {
 	size_t lsa_size;
 	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
 	char firmware_version[0x10];
-	unsigned long *enabled_cmds;
+	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
 
 	struct range pmem_range;
 	struct range ram_range;


