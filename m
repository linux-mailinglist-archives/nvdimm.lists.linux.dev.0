Return-Path: <nvdimm+bounces-5183-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E10B462CC7F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 22:18:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53632280C1B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 21:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF3D122B3;
	Wed, 16 Nov 2022 21:18:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78859122A9
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 21:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668633488; x=1700169488;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f5YG+uIWnLHJyHDG0GXZgolJd39mYA+YNYTqCRa+xMU=;
  b=bWi4j8esokeQd+FGb1jEXekmtra2Y9jJiZo5OdbkCbU1aQYZ6PHsQ6/G
   D0+o5tynTUIQHSSiZKcNrQDjfNZFZiEMUo7iLhNwuu8M7aRgjZK10yJdO
   Nr4xRNP18B1dehxz8cJCvPSN+veAXafyrnpGa/82NXM6jLrOlqBPAumXT
   RMueZNVbQat86HHLpz8DYyl0V7BsrExRkp9inqjzhxheMKJ2NzRc3ouo1
   100r8VQd6fXkaG6a+VytuS8dJNZfUblIpRmc//bQQWRdtHmdXsnYEos6L
   AxYfLXJjJeQTAWBiSn4EgNkP5C8fO5C7vPrKw62JqpsYL9F3O8nuJCII0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="313821154"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="313821154"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:18:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590346575"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590346575"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:18:07 -0800
Subject: [PATCH v5 04/18] tools/testing/cxl: Add "Set Passphrase" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net,
 benjamin.cheatham@amd.com
Date: Wed, 16 Nov 2022 14:18:06 -0700
Message-ID: 
 <166863348691.80269.7361954266795277528.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device supporting the "Set Passphrase"
operation. The operation supports setting of either a user or a master
passphrase.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c       |   81 ++++++++++++++++++++++++++++++++++++
 tools/testing/cxl/test/mem_pdata.h |    6 +++
 2 files changed, 87 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 9002a3ae3ea5..0fac0ca81290 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -154,6 +154,84 @@ static int mock_get_security_state(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static void master_plimit_check(struct cxl_mock_mem_pdata *mdata)
+{
+	if (mdata->master_limit == PASS_TRY_LIMIT)
+		return;
+	mdata->master_limit++;
+	if (mdata->master_limit == PASS_TRY_LIMIT)
+		mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
+}
+
+static void user_plimit_check(struct cxl_mock_mem_pdata *mdata)
+{
+	if (mdata->user_limit == PASS_TRY_LIMIT)
+		return;
+	mdata->user_limit++;
+	if (mdata->user_limit == PASS_TRY_LIMIT)
+		mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
+}
+
+static int mock_set_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_set_pass *set_pass;
+
+	if (cmd->size_in != sizeof(*set_pass))
+		return -EINVAL;
+
+	if (cmd->size_out != 0)
+		return -EINVAL;
+
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	set_pass = cmd->payload_in;
+	switch (set_pass->type) {
+	case CXL_PMEM_SEC_PASS_MASTER:
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		/*
+		 * CXL spec rev3.0 8.2.9.8.6.2, The master pasphrase shall only be set in
+		 * the security disabled state when the user passphrase is not set.
+		 */
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		if (memcmp(mdata->master_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			master_plimit_check(mdata);
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->master_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PASS_SET;
+		return 0;
+
+	case CXL_PMEM_SEC_PASS_USER:
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		if (memcmp(mdata->user_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			user_plimit_check(mdata);
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->user_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PASS_SET;
+		return 0;
+
+	default:
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+	}
+	return -EINVAL;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -250,6 +328,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_SECURITY_STATE:
 		rc = mock_get_security_state(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_SET_PASSPHRASE:
+		rc = mock_set_passphrase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/cxl/test/mem_pdata.h b/tools/testing/cxl/test/mem_pdata.h
index 6a7b111147eb..8eb2dffc9156 100644
--- a/tools/testing/cxl/test/mem_pdata.h
+++ b/tools/testing/cxl/test/mem_pdata.h
@@ -5,6 +5,12 @@
 
 struct cxl_mock_mem_pdata {
 	u32 security_state;
+	u8 user_pass[NVDIMM_PASSPHRASE_LEN];
+	u8 master_pass[NVDIMM_PASSPHRASE_LEN];
+	int user_limit;
+	int master_limit;
 };
 
+#define PASS_TRY_LIMIT 3
+
 #endif



