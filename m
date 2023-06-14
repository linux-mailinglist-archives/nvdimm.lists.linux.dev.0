Return-Path: <nvdimm+bounces-6144-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F148723120
	for <lists+linux-nvdimm@lfdr.de>; Mon,  5 Jun 2023 22:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9DD62813D8
	for <lists+linux-nvdimm@lfdr.de>; Mon,  5 Jun 2023 20:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E87261D8;
	Mon,  5 Jun 2023 20:21:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905E261CB
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 20:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685996473; x=1717532473;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=6joytIeXkxrGGxQ5Vs0F9aQ1D7WhdTy79hEq1u49ty4=;
  b=g5Nxz//RyTavuZswikRfT2m5uER7acOOk7F5bwwjRMdd/DWXl49nwPHU
   CGYPVd8B6xIfFpjdtYfgjVPxjDnVcfv0Yy1KWuBIrvpEOSmn5BKJu5hxp
   AcFuog41PGfy4wrkHgAdw+6+D2GYbNQNfYjxCwur0WHboUYMFVvgYcI5B
   u9wv8aXHSm+3EGqP2iJqRGFfHn7ZTnF4gGmFO+0a5/JHkRlEYtwSvdO8t
   o0mCzhsiJohYe1NpNRiB4r4nXCPiuQLZevmhs4mWqu2OIZivqOpqGU049
   IcDl4VLOiDbJQaYlTmTZELV2p+cXMotcyG1aS230z4uqh3kQgRxbUL9Rw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336093174"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336093174"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="832934304"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="832934304"
Received: from kmsalzbe-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.52.9])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:11 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 05 Jun 2023 14:21:04 -0600
Subject: [PATCH ndctl v2 2/5] cxl/list: print firmware info in memdev
 listings
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-vv-fw_update-v2-2-a778a15e860b@intel.com>
References: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
In-Reply-To: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=9661;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=6joytIeXkxrGGxQ5Vs0F9aQ1D7WhdTy79hEq1u49ty4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCl1zlsXzXrtflDv9Sw/ltlcP/8K/i2z/yufdEzY0Nhwx
 V216tU9HaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIw7UM/zOqTmnv+951kc9J
 fwPzU5Gcu43znrK+fHxZNtlZy6fKdhPD/2SR2o8cNkJxosVXXvjHyX7xu3/shUyXsVPcSlWP+/6
 MnAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add libcxl APIs to send a 'Get Firmware Info' mailbox command, and
accessors for its data fields. Add a json representation of this data,
and add an option to cxl-list to display it under memdev listings.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  | 21 +++++++++++++
 cxl/lib/libcxl.c   | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/filter.h       |  3 ++
 cxl/libcxl.h       |  7 +++++
 cxl/json.c         | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/list.c         |  3 ++
 cxl/lib/libcxl.sym |  6 ++++
 7 files changed, 214 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index d648992..590d719 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -9,6 +9,7 @@
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
 #include <util/size.h>
+#include <util/bitmap.h>
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
 
@@ -233,6 +234,26 @@ struct cxl_cmd_get_health_info {
 	le32 pmem_errors;
 } __attribute__((packed));
 
+/* CXL 3.0 8.2.9.3.1 Get Firmware Info */
+struct cxl_cmd_get_fw_info {
+	u8 num_slots;
+	u8 slot_info;
+	u8 activation_cap;
+	u8 reserved[13];
+	char slot_1_revision[0x10];
+	char slot_2_revision[0x10];
+	char slot_3_revision[0x10];
+	char slot_4_revision[0x10];
+} __attribute__((packed));
+
+#define CXL_FW_INFO_CUR_SLOT_MASK	GENMASK(2, 0)
+#define CXL_FW_INFO_NEXT_SLOT_MASK	GENMASK(5, 3)
+#define CXL_FW_INFO_NEXT_SLOT_SHIFT	(3)
+#define CXL_FW_INFO_HAS_LIVE_ACTIVATE	BIT(0)
+
+#define CXL_FW_VERSION_STR_LEN		16
+#define CXL_FW_MAX_SLOTS		4
+
 /* CXL 3.0 8.2.9.8.3.2 Get Alert Configuration */
 struct cxl_cmd_get_alert_config {
 	u8 valid_alerts;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 59e5bdb..90dce22 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3917,6 +3917,96 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_partition(struct cxl_memdev *memdev,
 	return cmd;
 }
 
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_fw_info(struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_FW_INFO);
+}
+
+static struct cxl_cmd_get_fw_info *cmd_to_get_fw_info(struct cxl_cmd *cmd)
+{
+	if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_GET_FW_INFO))
+		return NULL;
+
+	return cmd->output_payload;
+}
+
+CXL_EXPORT unsigned int cxl_cmd_fw_info_get_num_slots(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_fw_info *c = cmd_to_get_fw_info(cmd);
+
+	if (!c)
+		return 0;
+
+	return c->num_slots;
+}
+
+CXL_EXPORT unsigned int cxl_cmd_fw_info_get_active_slot(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_fw_info *c = cmd_to_get_fw_info(cmd);
+
+	if (!c)
+		return 0;
+
+	return c->slot_info & CXL_FW_INFO_CUR_SLOT_MASK;
+}
+
+CXL_EXPORT unsigned int cxl_cmd_fw_info_get_staged_slot(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_fw_info *c = cmd_to_get_fw_info(cmd);
+
+	if (!c)
+		return 0;
+
+	return (c->slot_info & CXL_FW_INFO_NEXT_SLOT_MASK) >>
+	       CXL_FW_INFO_NEXT_SLOT_SHIFT;
+}
+
+CXL_EXPORT bool cxl_cmd_fw_info_get_online_activate_capable(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_get_fw_info *c = cmd_to_get_fw_info(cmd);
+
+	if (!c)
+		return false;
+
+	return !!(c->activation_cap & CXL_FW_INFO_HAS_LIVE_ACTIVATE);
+}
+
+CXL_EXPORT int cxl_cmd_fw_info_get_fw_ver(struct cxl_cmd *cmd, int slot,
+					  char *buf, unsigned int len)
+{
+	struct cxl_cmd_get_fw_info *c = cmd_to_get_fw_info(cmd);
+	char *fw_ver;
+
+	if (!c)
+		return -ENXIO;
+	if (!len)
+		return -EINVAL;
+
+	switch(slot) {
+	case 1:
+		fw_ver = c->slot_1_revision;
+		break;
+	case 2:
+		fw_ver = c->slot_2_revision;
+		break;
+	case 3:
+		fw_ver = c->slot_3_revision;
+		break;
+	case 4:
+		fw_ver = c->slot_4_revision;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (fw_ver[0] == 0)
+		return -ENOENT;
+
+	memcpy(buf, fw_ver, min(len, (unsigned int)CXL_FW_VERSION_STR_LEN));
+
+	return 0;
+}
+
 CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
 {
 	struct cxl_memdev *memdev = cmd->memdev;
diff --git a/cxl/filter.h b/cxl/filter.h
index 595cde7..3f65990 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -27,6 +27,7 @@ struct cxl_filter_params {
 	bool human;
 	bool health;
 	bool partition;
+	bool fw;
 	bool alert_config;
 	bool dax;
 	int verbose;
@@ -81,6 +82,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_TARGETS;
 	if (param->partition)
 		flags |= UTIL_JSON_PARTITION;
+	if (param->fw)
+		flags |= UTIL_JSON_FIRMWARE;
 	if (param->alert_config)
 		flags |= UTIL_JSON_ALERT_CONFIG;
 	if (param->dax)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 54d9f10..99e1b76 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -68,6 +68,13 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
 		size_t offset);
 int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
 		size_t offset);
+struct cxl_cmd *cxl_cmd_new_get_fw_info(struct cxl_memdev *memdev);
+unsigned int cxl_cmd_fw_info_get_num_slots(struct cxl_cmd *cmd);
+unsigned int cxl_cmd_fw_info_get_active_slot(struct cxl_cmd *cmd);
+unsigned int cxl_cmd_fw_info_get_staged_slot(struct cxl_cmd *cmd);
+bool cxl_cmd_fw_info_get_online_activate_capable(struct cxl_cmd *cmd);
+int cxl_cmd_fw_info_get_fw_ver(struct cxl_cmd *cmd, int slot, char *buf,
+			       unsigned int len);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
diff --git a/cxl/json.c b/cxl/json.c
index e87bdd4..e6bb061 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -12,6 +12,84 @@
 #include "json.h"
 #include "../daxctl/json.h"
 
+#define CXL_FW_VERSION_STR_LEN	16
+#define CXL_FW_MAX_SLOTS	4
+
+static struct json_object *util_cxl_memdev_fw_to_json(
+		struct cxl_memdev *memdev, unsigned long flags)
+{
+	struct json_object *jobj;
+	struct json_object *jfw;
+	u32 field, num_slots;
+	struct cxl_cmd *cmd;
+	int rc, i;
+
+	jfw = json_object_new_object();
+	if (!jfw)
+		return NULL;
+	if (!memdev)
+		goto err_jobj;
+
+	cmd = cxl_cmd_new_get_fw_info(memdev);
+	if (!cmd)
+		goto err_jobj;
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		goto err_cmd;
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0)
+		goto err_cmd;
+
+	/* fw_info fields */
+	num_slots = cxl_cmd_fw_info_get_num_slots(cmd);
+	jobj = json_object_new_int(num_slots);
+	if (jobj)
+		json_object_object_add(jfw, "num_slots", jobj);
+
+	field = cxl_cmd_fw_info_get_active_slot(cmd);
+	jobj = json_object_new_int(field);
+	if (jobj)
+		json_object_object_add(jfw, "active_slot", jobj);
+
+	field = cxl_cmd_fw_info_get_staged_slot(cmd);
+	if (field > 0 && field <= num_slots) {
+		jobj = json_object_new_int(field);
+		if (jobj)
+			json_object_object_add(jfw, "staged_slot", jobj);
+	}
+
+	rc = cxl_cmd_fw_info_get_online_activate_capable(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jfw, "online_activate_capable", jobj);
+
+	for (i = 1; i <= CXL_FW_MAX_SLOTS; i++) {
+		char fw_ver[CXL_FW_VERSION_STR_LEN + 1];
+		char jkey[16];
+
+		rc = cxl_cmd_fw_info_get_fw_ver(cmd, i, fw_ver,
+						CXL_FW_VERSION_STR_LEN);
+		if (rc)
+			continue;
+		fw_ver[CXL_FW_VERSION_STR_LEN] = 0;
+		snprintf(jkey, 16, "slot_%d_version", i);
+		jobj = json_object_new_string(fw_ver);
+		if (jobj)
+			json_object_object_add(jfw, jkey, jobj);
+	}
+
+	cxl_cmd_unref(cmd);
+	return jfw;
+
+err_cmd:
+	cxl_cmd_unref(cmd);
+err_jobj:
+	json_object_put(jfw);
+	return NULL;
+
+}
+
 static struct json_object *util_cxl_memdev_health_to_json(
 		struct cxl_memdev *memdev, unsigned long flags)
 {
@@ -552,6 +630,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "partition_info", jobj);
 	}
 
+	if (flags & UTIL_JSON_FIRMWARE) {
+		jobj = util_cxl_memdev_fw_to_json(memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "firmware", jobj);
+	}
+
 	json_object_set_userdata(jdev, memdev, NULL);
 	return jdev;
 }
diff --git a/cxl/list.c b/cxl/list.c
index c01154e..93ba51e 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -53,6 +53,8 @@ static const struct option options[] = {
 		    "include memory device health information"),
 	OPT_BOOLEAN('I', "partition", &param.partition,
 		    "include memory device partition information"),
+	OPT_BOOLEAN('F', "firmware", &param.fw,
+		    "include memory device firmware information"),
 	OPT_BOOLEAN('A', "alert-config", &param.alert_config,
 		    "include alert configuration information"),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
@@ -116,6 +118,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 	case 3:
 		param.health = true;
 		param.partition = true;
+		param.fw = true;
 		param.alert_config = true;
 		param.dax = true;
 		/* fallthrough */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 1c6177c..16a8671 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -248,4 +248,10 @@ global:
 	cxl_region_get_mode;
 	cxl_decoder_create_ram_region;
 	cxl_region_get_daxctl_region;
+	cxl_cmd_new_get_fw_info;
+	cxl_cmd_fw_info_get_num_slots;
+	cxl_cmd_fw_info_get_active_slot;
+	cxl_cmd_fw_info_get_staged_slot;
+	cxl_cmd_fw_info_get_online_activate_capable;
+	cxl_cmd_fw_info_get_fw_ver;
 } LIBCXL_4;

-- 
2.40.1


