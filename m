Return-Path: <nvdimm+bounces-5139-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E96A628A77
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Nov 2022 21:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6820F1C20923
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Nov 2022 20:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50E68485;
	Mon, 14 Nov 2022 20:33:13 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8217779FA
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 20:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668457991; x=1699993991;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/KG3rMooqDz/BAjzdEiljJjcyA8/cH3LsLEumvkdptE=;
  b=mtNsBJpoVQwNwJA2G2hQhNlONB5DSYjN4sc8bniKWu4msbsGxMLdQWiy
   vG6ld27oCSormsaYjyj/ARrAsyzYe1rNwyWYsnkt/gPRKkp+oYX9GPBUq
   bCjDzCEHREvXA6Iwsg2dr+sMsyE5/LXmFkUIUy+AdxbLXCvTbOsgy2D+k
   ekD5qnP4yqsJETifYo1uOnGsZReJwQ55VBeyQZvH0UGJiDdCCLe7UKO9y
   wmOpmXCTCy9Ky3BO2BRR9TgHSJzzVXX4F1Xdz5xL9+m4qRbhwuw3CWYzG
   WPfoMxMACjFbWs4EMI2+Xrr5ASSlX3TBoTpOxFP/UoZ0r9nlfdZaTnOAn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="312080866"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="312080866"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:33:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="640919882"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="640919882"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:33:10 -0800
Subject: [PATCH v4 01/18] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Mon, 14 Nov 2022 13:33:10 -0700
Message-ID: 
 <166845799004.2496228.5617534534519053073.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add nvdimm_security_ops support for CXL memory device with the introduction
of the ->get_flags() callback function. This is part of the "Persistent
Memory Data-at-rest Security" command set for CXL memory device support.
The ->get_flags() function provides the security state of the persistent
memory device defined by the CXL 3.0 spec section 8.2.9.8.6.1.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/Makefile         |    2 +-
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |    8 ++++++
 drivers/cxl/pmem.c           |    6 +++--
 drivers/cxl/security.c       |   56 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 tools/testing/cxl/Kbuild     |    1 +
 7 files changed, 72 insertions(+), 3 deletions(-)
 create mode 100644 drivers/cxl/security.c

diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
index a78270794150..db321f48ba52 100644
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_CXL_PORT) += cxl_port.o
 cxl_mem-y := mem.o
 cxl_pci-y := pci.o
 cxl_acpi-y := acpi.o
-cxl_pmem-y := pmem.o
+cxl_pmem-y := pmem.o security.o
 cxl_port-y := port.o
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 16176b9278b4..8f4be61a76b5 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -65,6 +65,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(GET_SCAN_MEDIA_CAPS, 0x10, 0x4, 0),
 	CXL_CMD(SCAN_MEDIA, 0x11, 0, 0),
 	CXL_CMD(GET_SCAN_MEDIA, 0, CXL_VARIABLE_PAYLOAD, 0),
+	CXL_CMD(GET_SECURITY_STATE, 0, 0x4, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 88e3a8e54b6a..25d1d8fa7d1e 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -273,6 +273,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS	= 0x4303,
 	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
 	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
+	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -372,6 +373,13 @@ struct cxl_mem_command {
 #define CXL_CMD_FLAG_FORCE_ENABLE BIT(0)
 };
 
+#define CXL_PMEM_SEC_STATE_USER_PASS_SET	0x01
+#define CXL_PMEM_SEC_STATE_MASTER_PASS_SET	0x02
+#define CXL_PMEM_SEC_STATE_LOCKED		0x04
+#define CXL_PMEM_SEC_STATE_FROZEN		0x08
+#define CXL_PMEM_SEC_STATE_USER_PLIMIT		0x10
+#define CXL_PMEM_SEC_STATE_MASTER_PLIMIT	0x20
+
 int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
 		      size_t in_size, void *out, size_t out_size);
 int cxl_dev_state_identify(struct cxl_dev_state *cxlds);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 7dc0a2fa1a6b..24bec4ca3866 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -11,6 +11,8 @@
 #include "cxlmem.h"
 #include "cxl.h"
 
+extern const struct nvdimm_security_ops *cxl_security_ops;
+
 /*
  * Ordered workqueue for cxl nvdimm device arrival and departure
  * to coordinate bus rescans when a bridge arrives and trigger remove
@@ -75,8 +77,8 @@ static int cxl_nvdimm_probe(struct device *dev)
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
-	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
-			       cmd_mask, 0, NULL);
+	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
+				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
 	if (!nvdimm) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
new file mode 100644
index 000000000000..806173084216
--- /dev/null
+++ b/drivers/cxl/security.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/libnvdimm.h>
+#include <asm/unaligned.h>
+#include <linux/module.h>
+#include <linux/async.h>
+#include <linux/slab.h>
+#include "cxlmem.h"
+#include "cxl.h"
+
+static unsigned long cxl_pmem_get_security_flags(struct nvdimm *nvdimm,
+						 enum nvdimm_passphrase_type ptype)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	unsigned long security_flags = 0;
+	u32 sec_out;
+	int rc;
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_SECURITY_STATE, NULL, 0,
+			       &sec_out, sizeof(sec_out));
+	if (rc < 0)
+		return 0;
+
+	if (ptype == NVDIMM_MASTER) {
+		if (sec_out & CXL_PMEM_SEC_STATE_MASTER_PASS_SET)
+			set_bit(NVDIMM_SECURITY_UNLOCKED, &security_flags);
+		else
+			set_bit(NVDIMM_SECURITY_DISABLED, &security_flags);
+		if (sec_out & CXL_PMEM_SEC_STATE_MASTER_PLIMIT)
+			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);
+		return security_flags;
+	}
+
+	if (sec_out & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+		if (sec_out & CXL_PMEM_SEC_STATE_FROZEN ||
+		    sec_out & CXL_PMEM_SEC_STATE_USER_PLIMIT)
+			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);
+
+		if (sec_out & CXL_PMEM_SEC_STATE_LOCKED)
+			set_bit(NVDIMM_SECURITY_LOCKED, &security_flags);
+		else
+			set_bit(NVDIMM_SECURITY_UNLOCKED, &security_flags);
+	} else {
+		set_bit(NVDIMM_SECURITY_DISABLED, &security_flags);
+	}
+
+	return security_flags;
+}
+
+static const struct nvdimm_security_ops __cxl_security_ops = {
+	.get_flags = cxl_pmem_get_security_flags,
+};
+
+const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index c71021a2a9ed..cdc6049683ce 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -41,6 +41,7 @@
 	___C(GET_SCAN_MEDIA_CAPS, "Get Scan Media Capabilities"),         \
 	___C(SCAN_MEDIA, "Scan Media"),                                   \
 	___C(GET_SCAN_MEDIA, "Get Scan Media Results"),                   \
+	___C(GET_SECURITY_STATE, "Get Security State"),			  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 500be85729cc..e4048a05b6ab 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -26,6 +26,7 @@ cxl_acpi-y += config_check.o
 obj-m += cxl_pmem.o
 
 cxl_pmem-y := $(CXL_SRC)/pmem.o
+cxl_pmem-y += $(CXL_SRC)/security.o
 cxl_pmem-y += config_check.o
 
 obj-m += cxl_port.o



