Return-Path: <nvdimm+bounces-5184-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8043162CC80
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 22:18:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C365280C41
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 21:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F39122B0;
	Wed, 16 Nov 2022 21:18:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5712290
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 21:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668633494; x=1700169494;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ldKkSTrHg9AZi6xAg2GgEjlZKHkwfBvvW8OnrjIbADc=;
  b=SKNFN87ShHWHevvTmbTHmFMHDMBq3c0Q49IJwAFKMRjkej0mBNx+dxIf
   RH8OWZivXCziL5MkP1dCidjgUWzmTQcyby3EztMpoeK5P0tzLAIQoAVxW
   wYz3kP2+1VFPkrqj9MoHlofTaYGbiuE5N8eYmoYMIN229QLLuabIDxZ/z
   uJ6CT3MPm5QDpB+yMoVs+SBlpWbpwmx8114fQZUewjwzCVsCkC0yAY5gr
   175nhH2lg9LCogq3GcxkWA6aSEbjzuIBw3N12cbB+Q1WcHUiHNjWYbY46
   dmi40ybxdA2ioJ2fqjGaThQxj9Q9Wz6vz/tfJLOTbyNq+he6zbvdOxXvI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="312686220"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="312686220"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:18:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590346581"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590346581"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:18:13 -0800
Subject: [PATCH v5 05/18] cxl/pmem: Add Disable Passphrase security command
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net,
 benjamin.cheatham@amd.com
Date: Wed, 16 Nov 2022 14:18:13 -0700
Message-ID: 
 <166863349311.80269.236166040458200044.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Create callback function to support the nvdimm_security_ops ->disable()
callback. Translate the operation to send "Disable Passphrase" security
command for CXL memory device. The operation supports disabling a
passphrase for the CXL persistent memory device. In the original
implementation of nvdimm_security_ops, this operation only supports
disabling of the user passphrase. This is due to the NFIT version of
disable passphrase only supported disabling of user passphrase. The CXL
spec allows disabling of the master passphrase as well which
nvidmm_security_ops does not support yet. In this commit, the callback
function will only support user passphrase.

See CXL rev3.0 spec section 8.2.9.8.6.3 for reference.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |    8 ++++++++
 drivers/cxl/security.c       |   26 ++++++++++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 4 files changed, 36 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index cc08383499e6..2563325db0f6 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -67,6 +67,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(GET_SCAN_MEDIA, 0, CXL_VARIABLE_PAYLOAD, 0),
 	CXL_CMD(GET_SECURITY_STATE, 0, 0x4, 0),
 	CXL_CMD(SET_PASSPHRASE, 0x60, 0, 0),
+	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 725b08148524..9ad92f975b78 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -275,6 +275,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
 	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
+	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -390,6 +391,13 @@ struct cxl_set_pass {
 	u8 new_pass[NVDIMM_PASSPHRASE_LEN];
 } __packed;
 
+/* disable passphrase input payload */
+struct cxl_disable_pass {
+	u8 type;
+	u8 reserved[31];
+	u8 pass[NVDIMM_PASSPHRASE_LEN];
+} __packed;
+
 enum {
 	CXL_PMEM_SEC_PASS_MASTER = 0,
 	CXL_PMEM_SEC_PASS_USER,
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 5365646230c3..85b4c1f86881 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -70,9 +70,35 @@ static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
 	return rc;
 }
 
+static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
+				     const struct nvdimm_key_data *key_data)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_disable_pass dis_pass;
+	int rc;
+
+	/*
+	 * While the CXL spec defines the ability to erase the master passphrase,
+	 * the original nvdimm security ops does not provide that capability.
+	 * The sysfs attribute exposed to user space assumes disable is for user
+	 * passphrase only. In order to preserve the user interface, this callback
+	 * will only support disable of user passphrase. The disable master passphrase
+	 * ability will need to be added as a new callback.
+	 */
+	dis_pass.type = CXL_PMEM_SEC_PASS_USER;
+	memcpy(dis_pass.pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_DISABLE_PASSPHRASE,
+			       &dis_pass, sizeof(dis_pass), NULL, 0);
+	return rc;
+}
+
 static const struct nvdimm_security_ops __cxl_security_ops = {
 	.get_flags = cxl_pmem_get_security_flags,
 	.change_key = cxl_pmem_security_change_key,
+	.disable = cxl_pmem_security_disable,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index 9da047e9b038..f6d383a80f22 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -43,6 +43,7 @@
 	___C(GET_SCAN_MEDIA, "Get Scan Media Results"),                   \
 	___C(GET_SECURITY_STATE, "Get Security State"),			  \
 	___C(SET_PASSPHRASE, "Set Passphrase"),				  \
+	___C(DISABLE_PASSPHRASE, "Disable Passphrase"),			  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a



