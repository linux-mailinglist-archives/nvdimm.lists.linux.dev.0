Return-Path: <nvdimm+bounces-1212-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0184044D3
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 07:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1B7A11C0FDE
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 05:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7BD3FE9;
	Thu,  9 Sep 2021 05:13:24 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8FB3FDF
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:13:23 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="207793948"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="207793948"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:13:16 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="466239230"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:13:15 -0700
Subject: [PATCH v4 19/21] cxl/mbox: Move command definitions to common
 location
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:13:15 -0700
Message-ID: <163116439547.2460985.10457111177103589574.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for cxl_test to mock responses to mailbox command
requests, move some definitions from core/mbox.c to cxlmem.h.

No functional changes intended.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c |   45 +++++--------------------------------
 drivers/cxl/cxlmem.h    |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/pmem.c      |   11 ++-------
 3 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 82e79da195fa..576796a5d9f3 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -485,11 +485,7 @@ static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
 
 	while (remaining) {
 		u32 xfer_size = min_t(u32, remaining, cxlm->payload_size);
-		struct cxl_mbox_get_log {
-			uuid_t uuid;
-			__le32 offset;
-			__le32 length;
-		} __packed log = {
+		struct cxl_mbox_get_log log = {
 			.uuid = *uuid,
 			.offset = cpu_to_le32(offset),
 			.length = cpu_to_le32(xfer_size)
@@ -520,14 +516,11 @@ static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
  */
 static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
 {
-	struct cel_entry {
-		__le16 opcode;
-		__le16 effect;
-	} __packed * cel_entry;
+	struct cxl_cel_entry *cel_entry;
 	const int cel_entries = size / sizeof(*cel_entry);
 	int i;
 
-	cel_entry = (struct cel_entry *)cel;
+	cel_entry = (struct cxl_cel_entry *) cel;
 
 	for (i = 0; i < cel_entries; i++) {
 		u16 opcode = le16_to_cpu(cel_entry[i].opcode);
@@ -543,15 +536,6 @@ static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
 	}
 }
 
-struct cxl_mbox_get_supported_logs {
-	__le16 entries;
-	u8 rsvd[6];
-	struct gsl_entry {
-		uuid_t uuid;
-		__le32 size;
-	} __packed entry[];
-} __packed;
-
 static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
 {
 	struct cxl_mbox_get_supported_logs *ret;
@@ -578,10 +562,8 @@ enum {
 
 /* See CXL 2.0 Table 170. Get Log Input Payload */
 static const uuid_t log_uuid[] = {
-	[CEL_UUID] = UUID_INIT(0xda9c0b5, 0xbf41, 0x4b78, 0x8f, 0x79, 0x96,
-			       0xb1, 0x62, 0x3b, 0x3f, 0x17),
-	[VENDOR_DEBUG_UUID] = UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f,
-					0xd6, 0x07, 0x19, 0x40, 0x3d, 0x86),
+	[CEL_UUID] = DEFINE_CXL_CEL_UUID,
+	[VENDOR_DEBUG_UUID] = DEFINE_CXL_VENDOR_DEBUG_UUID,
 };
 
 /**
@@ -698,22 +680,7 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
 int cxl_mem_identify(struct cxl_mem *cxlm)
 {
 	/* See CXL 2.0 Table 175 Identify Memory Device Output Payload */
-	struct cxl_mbox_identify {
-		char fw_revision[0x10];
-		__le64 total_capacity;
-		__le64 volatile_capacity;
-		__le64 persistent_capacity;
-		__le64 partition_align;
-		__le16 info_event_log_size;
-		__le16 warning_event_log_size;
-		__le16 failure_event_log_size;
-		__le16 fatal_event_log_size;
-		__le32 lsa_size;
-		u8 poison_list_max_mer[3];
-		__le16 inject_poison_limit;
-		u8 poison_caps;
-		u8 qos_telemetry_caps;
-	} __packed id;
+	struct cxl_mbox_identify id;
 	int rc;
 
 	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_IDENTIFY, NULL, 0, &id,
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 468b7b8be207..3841d7fe73d7 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -171,6 +171,63 @@ enum cxl_opcode {
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
+#define DEFINE_CXL_CEL_UUID                                                    \
+	UUID_INIT(0xda9c0b5, 0xbf41, 0x4b78, 0x8f, 0x79, 0x96, 0xb1, 0x62,     \
+		  0x3b, 0x3f, 0x17)
+
+#define DEFINE_CXL_VENDOR_DEBUG_UUID                                           \
+	UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
+		  0x40, 0x3d, 0x86)
+
+struct cxl_mbox_get_supported_logs {
+	__le16 entries;
+	u8 rsvd[6];
+	struct cxl_gsl_entry {
+		uuid_t uuid;
+		__le32 size;
+	} __packed entry[];
+}  __packed;
+
+struct cxl_cel_entry {
+	__le16 opcode;
+	__le16 effect;
+} __packed;
+
+struct cxl_mbox_get_log {
+	uuid_t uuid;
+	__le32 offset;
+	__le32 length;
+} __packed;
+
+/* See CXL 2.0 Table 175 Identify Memory Device Output Payload */
+struct cxl_mbox_identify {
+	char fw_revision[0x10];
+	__le64 total_capacity;
+	__le64 volatile_capacity;
+	__le64 persistent_capacity;
+	__le64 partition_align;
+	__le16 info_event_log_size;
+	__le16 warning_event_log_size;
+	__le16 failure_event_log_size;
+	__le16 fatal_event_log_size;
+	__le32 lsa_size;
+	u8 poison_list_max_mer[3];
+	__le16 inject_poison_limit;
+	u8 poison_caps;
+	u8 qos_telemetry_caps;
+} __packed;
+
+struct cxl_mbox_get_lsa {
+	u32 offset;
+	u32 length;
+} __packed;
+
+struct cxl_mbox_set_lsa {
+	u32 offset;
+	u32 reserved;
+	u8 data[];
+} __packed;
+
 /**
  * struct cxl_mem_command - Driver representation of a memory device command
  * @info: Command information as it exists for the UAPI
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index bb30d3e55825..877b0a84e586 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -98,10 +98,7 @@ static int cxl_pmem_get_config_data(struct cxl_mem *cxlm,
 				    struct nd_cmd_get_config_data_hdr *cmd,
 				    unsigned int buf_len, int *cmd_rc)
 {
-	struct cxl_mbox_get_lsa {
-		u32 offset;
-		u32 length;
-	} get_lsa;
+	struct cxl_mbox_get_lsa get_lsa;
 	int rc;
 
 	if (sizeof(*cmd) > buf_len)
@@ -127,11 +124,7 @@ static int cxl_pmem_set_config_data(struct cxl_mem *cxlm,
 				    struct nd_cmd_set_config_hdr *cmd,
 				    unsigned int buf_len, int *cmd_rc)
 {
-	struct cxl_mbox_set_lsa {
-		u32 offset;
-		u32 reserved;
-		u8 data[];
-	} *set_lsa;
+	struct cxl_mbox_set_lsa *set_lsa;
 	int rc;
 
 	if (sizeof(*cmd) > buf_len)


