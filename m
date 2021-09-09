Return-Path: <nvdimm+bounces-1201-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 057524044C5
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 07:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 266891C0F7F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 05:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BC43FE5;
	Thu,  9 Sep 2021 05:12:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573D63FDF
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:12:28 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="220360530"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="220360530"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:12:16 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="693854183"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:12:15 -0700
Subject: [PATCH v4 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 vishal.l.verma@intel.com, nvdimm@lists.linux.dev, ben.widawsky@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:12:15 -0700
Message-ID: <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Commit 0b9159d0ff21 ("cxl/pci: Store memory capacity values") missed
updating the kernel-doc for 'struct cxl_mem' leading to the following
warnings:

./scripts/kernel-doc -v drivers/cxl/cxlmem.h 2>&1 | grep warn
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'total_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'volatile_only_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'persistent_only_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'partition_align_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_volatile_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_persistent_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_volatile_bytes' not described in 'cxl_mem'
drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_persistent_bytes' not described in 'cxl_mem'

Also, it is redundant to describe those same parameters in the
kernel-doc for cxl_mem_get_partition_info(). Given the only user of that
routine updates the values in @cxlm, just do that implicitly internal to
the helper.

Cc: Ira Weiny <ira.weiny@intel.com>
Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxlmem.h |   15 +++++++++++++--
 drivers/cxl/pci.c    |   35 +++++++++++------------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index d5334df83fb2..c6fce966084a 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -78,8 +78,19 @@ devm_cxl_add_memdev(struct cxl_mem *cxlm,
  * @mbox_mutex: Mutex to synchronize mailbox access.
  * @firmware_version: Firmware version for the memory device.
  * @enabled_cmds: Hardware commands found enabled in CEL.
- * @pmem_range: Persistent memory capacity information.
- * @ram_range: Volatile memory capacity information.
+ * @pmem_range: Active Persistent memory capacity configuration
+ * @ram_range: Active Volatile memory capacity configuration
+ * @total_bytes: sum of all possible capacities
+ * @volatile_only_bytes: hard volatile capacity
+ * @persistent_only_bytes: hard persistent capacity
+ * @partition_align_bytes: soft setting for configurable capacity
+ * @active_volatile_bytes: sum of hard + soft volatile
+ * @active_persistent_bytes: sum of hard + soft persistent
+ * @next_volatile_bytes: volatile capacity change pending device reset
+ * @next_persistent_bytes: persistent capacity change pending device reset
+ *
+ * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
+ * details on capacity parameters.
  */
 struct cxl_mem {
 	struct device *dev;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index c1e1d12e24b6..8077d907e7d3 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1262,11 +1262,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
 
 /**
  * cxl_mem_get_partition_info - Get partition info
- * @cxlm: The device to act on
- * @active_volatile_bytes: returned active volatile capacity
- * @active_persistent_bytes: returned active persistent capacity
- * @next_volatile_bytes: return next volatile capacity
- * @next_persistent_bytes: return next persistent capacity
+ * @cxlm: cxl_mem instance to update partition info
  *
  * Retrieve the current partition info for the device specified.  If not 0, the
  * 'next' values are pending and take affect on next cold reset.
@@ -1275,11 +1271,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
  *
  * See CXL @8.2.9.5.2.1 Get Partition Info
  */
-static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
-				      u64 *active_volatile_bytes,
-				      u64 *active_persistent_bytes,
-				      u64 *next_volatile_bytes,
-				      u64 *next_persistent_bytes)
+static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
 {
 	struct cxl_mbox_get_partition_info {
 		__le64 active_volatile_cap;
@@ -1294,15 +1286,14 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
 	if (rc)
 		return rc;
 
-	*active_volatile_bytes = le64_to_cpu(pi.active_volatile_cap);
-	*active_persistent_bytes = le64_to_cpu(pi.active_persistent_cap);
-	*next_volatile_bytes = le64_to_cpu(pi.next_volatile_cap);
-	*next_persistent_bytes = le64_to_cpu(pi.next_volatile_cap);
-
-	*active_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*active_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*next_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*next_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
+	cxlm->active_volatile_bytes =
+		le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->active_persistent_bytes =
+		le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->next_volatile_bytes =
+		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->next_persistent_bytes =
+		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
 
 	return 0;
 }
@@ -1443,11 +1434,7 @@ static int cxl_mem_create_range_info(struct cxl_mem *cxlm)
 		return 0;
 	}
 
-	rc = cxl_mem_get_partition_info(cxlm,
-					&cxlm->active_volatile_bytes,
-					&cxlm->active_persistent_bytes,
-					&cxlm->next_volatile_bytes,
-					&cxlm->next_persistent_bytes);
+	rc = cxl_mem_get_partition_info(cxlm);
 	if (rc < 0) {
 		dev_err(cxlm->dev, "Failed to query partition information\n");
 		return rc;


