Return-Path: <nvdimm+bounces-7419-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ECDE84FF07
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 Feb 2024 22:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BB7EB22566
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 Feb 2024 21:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70CA18053;
	Fri,  9 Feb 2024 21:39:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E40149DFA;
	Fri,  9 Feb 2024 21:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707514761; cv=none; b=eZBWgs+FQBeq9R5724IvkWDaatbdh/OjNlbHevo1T9e94Ryo4aVtyqbg/xAM1Tcf2Qa7e2jBEnVPrsdUgLUpeWmiifD2O2OEPk0ivsNHPqRGlB3xGh5SU+UuxS8wkOnKymCxT7sGEJFGo/oxigAkRDOlejm8//cKd3bsVkktiBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707514761; c=relaxed/simple;
	bh=3wiobEGADXfcwTi/LrKkeo5tF5A+iP49SAtIbsQWldQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b8MjR4Y/RUTbO5Xlr2kHGs2ZnygB+fwkZYlapsEVVN1CNi3jh8ysTa36YTkKHqTlzHPasrUwTAH+dcRlz+nMbzcVW2KqAhw/mf6egzvLf4e9QvGRCFYgvN4heezwiPfc6K5Y1Ll54JcM5M/+Tmx+fcDIvgLL7bkgeE0j1Jdy5X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08939C433C7;
	Fri,  9 Feb 2024 21:39:20 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH] ndctl: cxl: Remove dependency for attributes derived from IDENTIFY command
Date: Fri,  9 Feb 2024 14:39:17 -0700
Message-ID: <20240209213917.2288994-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A memdev may optionally not host a mailbox and therefore not able to execute
the IDENTIFY command. Currently the kernel emits empty strings for some of
the attributes instead of making them invisible in order to keep backward
compatibility for CXL CLI. Remove dependency of CXL CLI on the existance of
these attributes and only expose them if they exist. Without the dependency
the kernel will be able to make the non-existant attributes invisible.

Link: https://lore.kernel.org/all/20230606121534.00003870@Huawei.com/
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/lib/libcxl.c | 48 ++++++++++++++++++++++++++----------------------
 cxl/memdev.c     | 15 ++++++++++-----
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 1537a33d370e..f807ec4ed4e6 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1251,28 +1251,30 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	memdev->minor = minor(st.st_rdev);
 
 	sprintf(path, "%s/pmem/size", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->pmem_size = strtoull(buf, NULL, 0);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->pmem_size = strtoull(buf, NULL, 0);
 
 	sprintf(path, "%s/ram/size", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->ram_size = strtoull(buf, NULL, 0);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->ram_size = strtoull(buf, NULL, 0);
 
 	sprintf(path, "%s/payload_max", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->payload_max = strtoull(buf, NULL, 0);
-	if (memdev->payload_max < 0)
-		goto err_read;
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->payload_max = strtoull(buf, NULL, 0);
+		if (memdev->payload_max < 0)
+			goto err_read;
+	} else {
+		memdev->payload_max = -1;
+	}
 
 	sprintf(path, "%s/label_storage_size", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->lsa_size = strtoull(buf, NULL, 0);
-	if (memdev->lsa_size == ULLONG_MAX)
-		goto err_read;
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->lsa_size = strtoull(buf, NULL, 0);
+		if (memdev->lsa_size == ULLONG_MAX)
+			goto err_read;
+	} else {
+		memdev->lsa_size = ULLONG_MAX;
+	}
 
 	sprintf(path, "%s/serial", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -1299,12 +1301,11 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	host[0] = '\0';
 
 	sprintf(path, "%s/firmware_version", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-
-	memdev->firmware_version = strdup(buf);
-	if (!memdev->firmware_version)
-		goto err_read;
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->firmware_version = strdup(buf);
+		if (!memdev->firmware_version)
+			goto err_read;
+	}
 
 	memdev->dev_buf = calloc(1, strlen(cxlmem_base) + 50);
 	if (!memdev->dev_buf)
@@ -4543,6 +4544,9 @@ static int lsa_op(struct cxl_memdev *memdev, int op, void *buf,
 	if (length == 0)
 		return 0;
 
+	if (memdev->payload_max < 0)
+		return -EINVAL;
+
 	label_iter_max = memdev->payload_max - sizeof(struct cxl_cmd_set_lsa);
 	while (remaining) {
 		cur_len = min((size_t)label_iter_max, remaining);
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 81f07991da06..feab7ea76e78 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -473,10 +473,13 @@ static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
 	size_t size;
 	int rc;
 
-	if (param.len)
+	if (param.len) {
 		size = param.len;
-	else
+	} else {
 		size = cxl_memdev_get_label_size(memdev);
+		if (size == ULLONG_MAX)
+			return -EINVAL;
+	}
 
 	if (cxl_memdev_nvdimm_bridge_active(memdev)) {
 		log_err(&ml,
@@ -547,11 +550,13 @@ static int action_read(struct cxl_memdev *memdev, struct action_context *actx)
 	char *buf;
 	int rc;
 
-	if (param.len)
+	if (param.len) {
 		size = param.len;
-	else
+	} else {
 		size = cxl_memdev_get_label_size(memdev);
-
+		if (size == ULLONG_MAX)
+			return -EINVAL;
+	}
 	buf = calloc(1, size);
 	if (!buf)
 		return -ENOMEM;
-- 
2.43.0


