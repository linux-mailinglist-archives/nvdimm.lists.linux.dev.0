Return-Path: <nvdimm+bounces-3100-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC574C0273
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Feb 2022 20:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id EE1463E0F4C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Feb 2022 19:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB6A68E6;
	Tue, 22 Feb 2022 19:52:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C1A2F5C
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 19:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645559557; x=1677095557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTG5Smbf2n0RnE6NAt5Gg8jbLwJZPj7ZBnYfgHaACFI=;
  b=mJtCx4guzQUpwuHPyVeQGtUw42AA64ObqmUBdhI5iImeM31A6vM3KRsW
   BGozY3rO9KmzlNJQqdl9QObwB31JTGB/nu09yfc4qU/SAq1fwCCGfXUN9
   +uf/JSd/svTErSSLz79OlbF5B2Ok3XG5w9JfgBWptqIrqUQb3wnfrf66R
   jWg0CGz2jTRkMHtxlZOsP2cH8o/wmmo8ddSWW5agZRuLs6D71zZzz7kqM
   QJGVJNFHGRv1GhlEU7qyjtpyr7TmDUGoIe9hFHJN6JwkFmTlwdsSDaC+m
   RlWUXR36JD7nFFT2v2hBZWLJumKgPuBz594jf94MZ9NT26PgNYon+pSnz
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="315027644"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="315027644"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:52:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="683637807"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:52:36 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v6 2/6] libcxl: add accessors for capacity fields of the IDENTIFY command
Date: Tue, 22 Feb 2022 11:56:04 -0800
Message-Id: <58dec40b15a68f134466f61421751994735e55c1.1645558189.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645558189.git.alison.schofield@intel.com>
References: <cover.1645558189.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL PMEM provisioning model depends upon the values reported
in the CXL IDENTIFY mailbox command when changing the partitioning
between volatile and persistent capacity.

Add accessors to the libcxl API to retrieve the total, volatile only,
and persistent only capacities from the IDENTIFY command.

The fields are specified in multiples of 256MB per the CXL 2.0 spec.
Use the capacity multiplier to convert the raw data into bytes for user
consumption.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 +++
 cxl/libcxl.h       |  3 +++
 3 files changed, 50 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 4557a71de845..9413384b4b3b 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2277,6 +2277,17 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
 }
 
+static struct cxl_cmd_identify *
+cmd_to_identify(struct cxl_cmd *cmd)
+{
+	if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_IDENTIFY))
+		return NULL;
+
+	if (!cmd)
+		return NULL;
+	return cmd->output_payload;
+}
+
 CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
 		int fw_len)
 {
@@ -2321,6 +2332,39 @@ CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
 	return le32_to_cpu(id->lsa_size);
 }
 
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_total_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *c;
+
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->total_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_volatile_only_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *c;
+
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->volatile_capacity);
+}
+
+CXL_EXPORT unsigned long long
+cxl_cmd_identify_get_persistent_only_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *c;
+
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->persistent_capacity);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
 		int opcode)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 509e62daad4b..5ac6e9bbe981 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -160,4 +160,7 @@ global:
 	cxl_cmd_partition_get_active_persistent_size;
 	cxl_cmd_partition_get_next_volatile_size;
 	cxl_cmd_partition_get_next_persistent_size;
+	cxl_cmd_identify_get_total_size;
+	cxl_cmd_identify_get_volatile_only_size;
+	cxl_cmd_identify_get_persistent_only_size;
 } LIBCXL_1;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 2c0a8d199f0a..6e18e843d3ea 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -201,6 +201,9 @@ int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
 int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
+unsigned long long cxl_cmd_identify_get_total_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_volatile_only_size(struct cxl_cmd *cmd);
+unsigned long long cxl_cmd_identify_get_persistent_only_size(struct cxl_cmd *cmd);
 unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
-- 
2.31.1


