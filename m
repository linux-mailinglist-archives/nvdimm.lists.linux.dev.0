Return-Path: <nvdimm+bounces-7355-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CA184CFAE
	for <lists+linux-nvdimm@lfdr.de>; Wed,  7 Feb 2024 18:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7115E1C255FB
	for <lists+linux-nvdimm@lfdr.de>; Wed,  7 Feb 2024 17:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F2A8286B;
	Wed,  7 Feb 2024 17:21:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04C341C7C;
	Wed,  7 Feb 2024 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326464; cv=none; b=IQxzzZTZiNLAfxu2NuG255PYeVtLwCvikvenWQJPC6tG7WMLTo+5IJRG0FEI19VQyFYD2Kd2YUSJWc2DeoU7uqn+YUuHvTr/rtYDcVgP/2vIKE6TXVQk6sVsf9Cg1eALV0u5hZXO6ORkl05l2PcEQXPbOMD8b8rlKAUT4sYnIRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326464; c=relaxed/simple;
	bh=iZy9IXmSdihmk2WLsWllROg5OaWg9gfddrFM3afOmuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpxZHmhGSbJWHSE+iaZkRN06GwU8QnVgi/I4XyLH2bn/FDPf2nbE7wyp3rPQXkahUxe4p/J11wCKVsGEFwyLi0SP9kv/5KG22u1U2aeRYFDCouG3K9SUCOAW5BEa6utdgkvJPgow2ZFy8/qsSAEFwt7yyyiLAxhBGbrNPI2AGuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9148CC433F1;
	Wed,  7 Feb 2024 17:21:04 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Alison Schofield <alison.schofield@intel.com>
Subject: [NDCTL PATCH v6 2/4] ndctl: cxl: Add QoS class support for the memory device
Date: Wed,  7 Feb 2024 10:19:37 -0700
Message-ID: <20240207172055.1882900-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207172055.1882900-1-dave.jiang@intel.com>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add libcxl API to retrieve the QoS class tokens for the memory
devices. Two API calls are added. One for 'ram' or 'volatile'
mode and another for 'pmem' or 'persistent' mode. Support also added
for displaying the QoS class tokens through the 'cxl list' command.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/json.c         | 14 ++++++++++++++
 cxl/lib/libcxl.c   | 22 ++++++++++++++++++++++
 cxl/lib/libcxl.sym |  2 ++
 cxl/lib/private.h  |  2 ++
 cxl/libcxl.h       |  2 ++
 5 files changed, 42 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 48a43ddf14b0..9d22bdd2188a 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -791,6 +791,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdev, "pmem_size", jobj);
+
+		if (flags & UTIL_JSON_QOS_CLASS) {
+			jobj = json_object_new_int(
+					cxl_memdev_get_pmem_qos_class(memdev));
+			if (jobj)
+				json_object_object_add(jdev, "pmem_qos_class", jobj);
+		}
 	}
 
 	size = cxl_memdev_get_ram_size(memdev);
@@ -798,6 +805,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdev, "ram_size", jobj);
+
+		if (flags & UTIL_JSON_QOS_CLASS) {
+			jobj = json_object_new_int(
+					cxl_memdev_get_ram_qos_class(memdev));
+			if (jobj)
+				json_object_object_add(jdev, "ram_qos_class", jobj);
+		}
 	}
 
 	if (flags & UTIL_JSON_HEALTH) {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 9a1ac7001803..6c293f1dfc91 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1260,6 +1260,18 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->pmem_qos_class = atoi(buf);
+
+	sprintf(path, "%s/ram/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->ram_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->ram_qos_class = atoi(buf);
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1483,6 +1495,16 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
 	return memdev->ram_size;
 }
 
+CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->pmem_qos_class;
+}
+
+CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->ram_qos_class;
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 384fea2c25e3..465c78dc6c70 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -283,4 +283,6 @@ LIBCXL_8 {
 global:
 	cxl_memdev_wait_sanitize;
 	cxl_root_decoder_get_qos_class;
+	cxl_memdev_get_pmem_qos_class;
+	cxl_memdev_get_ram_qos_class;
 } LIBCXL_7;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 4847ff448f71..07dc8c784f1d 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -47,6 +47,8 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	int ram_qos_class;
+	int pmem_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index e5c08da77f77..a180f01cb05e 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -72,6 +72,8 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
+int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
-- 
2.43.0


