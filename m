Return-Path: <nvdimm+bounces-10177-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD29A865C6
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Apr 2025 20:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6B477AC970
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Apr 2025 18:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8546B27701F;
	Fri, 11 Apr 2025 18:48:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4858A268C7A;
	Fri, 11 Apr 2025 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744397324; cv=none; b=NfgH0FUWhjgA23MAjctI4RGxgW4dGAwL3/f50Vo09oYnKNaq/NTOYaCnN/6Iir8I8zM3po5qMBi6p+qZl7SvXDMTqGvKY2dVQyRQgNMJ0YtAS5aiGOjvMR+v3zlrpHY1TzqtT5gfxFbP0njW4zU1Lu9Z8c1u497MOKkcuXQlmg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744397324; c=relaxed/simple;
	bh=mlNt5tnFNQBOLqQdVx7PcIFthDSy1KAJS6tyXEOgIeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUCuqa2Mb2Gwhey6itBh6ApatFnWrTIdCVULzWmrbbnYt6ZaCHnSvyxzHLbU7iv65LPa24QdPsfsFUnLzNINpRIto7wJtBPE7+qQ1oRaVCZHquPtA7RqZo1WR66JP1VfkiorrNDae/HPxUU7K7tjnVCVYHMczIn9rR/Ouw2cuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA97C4CEE8;
	Fri, 11 Apr 2025 18:48:42 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v5 2/3] cxl: Enumerate major/minor of FWCTL char device
Date: Fri, 11 Apr 2025 11:47:36 -0700
Message-ID: <20250411184831.2367464-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250411184831.2367464-1-dave.jiang@intel.com>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add major/minor discovery for the FWCTL character device that is associated
with supprting CXL Features under 'struct cxl_fwctl'. A 'struct cxl_fwctl'
may be installed under cxl_memdev if CXL Features are supported and FWCTL
is enabled. Add libcxl API functions to retrieve the major and minor of the
FWCTL character device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v5:
- Add documentation. (Alison)
- Alloc path on stack. (Alison)
- Deal with out of entry and no match case. (Alison)
- Make fwctl operations part of 'struct cxl_fwctl' (Dan)
---
 Documentation/cxl/lib/libcxl.txt | 21 +++++++++
 cxl/lib/libcxl.c                 | 78 ++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  3 ++
 cxl/lib/private.h                |  8 ++++
 cxl/libcxl.h                     |  5 ++
 5 files changed, 115 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 25ff406c2920..1e00e2dd1abc 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -42,6 +42,7 @@ struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_host(struct cxl_memdev *memdev)
 struct cxl_memdev *cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint);
+struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
@@ -59,6 +60,9 @@ specific memdev.
 The host of a memdev is the PCIe Endpoint device that registered its CXL
 capabilities with the Linux CXL core.
 
+A memdev may host a 'struct cxl_fwctl' if CXL Features are supported and
+Firmware Contrl (FWCTL) is also enabled.
+
 === MEMDEV: Attributes
 ----
 int cxl_memdev_get_id(struct cxl_memdev *memdev);
@@ -185,6 +189,23 @@ device is in use. When CXL_SETPART_NEXTBOOT mode is set, the change
 in partitioning shall become the “next” configuration, to become
 active on the next device reset.
 
+FWCTL
+-----
+The object representing a Firmware Control (FWCTL) device is 'struct cxl_fwctl'.
+Library interfaces related to these devices have the prefix 'cxl_fwctl_'.
+These interfaces are associated with retrieving attributes related to the
+CXL FWCTL character device that is a child of the memdev.
+
+=== FWCTL: Attributes
+----
+int cxl_fwctl_get_major(struct cxl_memdev *memdev);
+int cxl_fwctl_get_minor(struct cxl_memdev *memdev);
+----
+
+The character device node for Feature (firmware) control can be found by
+default at /dev/fwctl/fwctl%d, or created with a major / minor returned
+from cxl_memdev_get_fwctl_{major,minor}().
+
 BUSES
 -----
 The CXL Memory space is CPU and Device coherent. The address ranges that
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index bab7343e8a4a..be54db1b9bb9 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -88,6 +88,7 @@ static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
 	free(memdev->host_path);
+	free(memdev->fwctl);
 	free(memdev);
 }
 
@@ -1253,6 +1254,64 @@ static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
 	return -ENOMEM;
 }
 
+static const char fwctl_prefix[] = "fwctl";
+static int get_feature_chardev(const char *base, char *chardev_path)
+{
+	char path[CXL_PATH_MAX];
+	struct dirent *entry;
+	bool found = false;
+	int rc = 0;
+	DIR *dir;
+
+	sprintf(path, "%s/fwctl/", base);
+	dir = opendir(path);
+	if (!dir)
+		return -errno;
+
+	while ((entry = readdir(dir)) != NULL) {
+		if (strncmp(entry->d_name, fwctl_prefix, strlen(fwctl_prefix)) == 0) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!entry || !found) {
+		rc = -ENOENT;
+		goto read_err;
+	}
+
+	sprintf(chardev_path, "/dev/fwctl/%s", entry->d_name);
+
+read_err:
+	closedir(dir);
+	return rc;
+}
+
+static int memdev_add_fwctl(struct cxl_memdev *memdev, const char *cxlmem_base)
+{
+	struct cxl_fwctl *fwctl;
+	char path[CXL_PATH_MAX];
+	struct stat st;
+	int rc;
+
+	rc = get_feature_chardev(cxlmem_base, path);
+	if (rc)
+		return rc;
+
+	if (stat(path, &st) < 0)
+		return -errno;
+
+	fwctl = calloc(1, sizeof(*fwctl));
+	if (!fwctl)
+		return -ENOMEM;
+
+	fwctl->major = major(st.st_rdev);
+	fwctl->minor = minor(st.st_rdev);
+	memdev->fwctl = fwctl;
+
+	return 0;
+}
+
 static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 {
 	const char *devname = devpath_to_devname(cxlmem_base);
@@ -1279,6 +1338,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	memdev->major = major(st.st_rdev);
 	memdev->minor = minor(st.st_rdev);
 
+	/* If this fails, no Features support. */
+	if (memdev_add_fwctl(memdev, cxlmem_base))
+		dbg(ctx, "%s: no Features support.\n", devname);
+
 	sprintf(path, "%s/pmem/size", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		memdev->pmem_size = strtoull(buf, NULL, 0);
@@ -1515,6 +1578,21 @@ CXL_EXPORT int cxl_memdev_get_minor(struct cxl_memdev *memdev)
 	return memdev->minor;
 }
 
+CXL_EXPORT struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev)
+{
+	return memdev->fwctl;
+}
+
+CXL_EXPORT int cxl_fwctl_get_major(struct cxl_fwctl *fwctl)
+{
+	return fwctl->major;
+}
+
+CXL_EXPORT int cxl_fwctl_get_minor(struct cxl_fwctl *fwctl)
+{
+	return fwctl->minor;
+}
+
 CXL_EXPORT unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev)
 {
 	return memdev->pmem_size;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 4c9760f377e6..3ad0cd06e25a 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -291,4 +291,7 @@ global:
 LIBCXL_9 {
 global:
 	cxl_bus_get_by_provider;
+	cxl_memdev_get_fwctl;
+	cxl_fwctl_get_major;
+	cxl_fwctl_get_minor;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910e9335..8bb3308cc036 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -13,6 +13,8 @@
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
 
+#define CXL_PATH_MAX	512
+
 struct cxl_pmem {
 	int id;
 	void *dev_buf;
@@ -34,6 +36,11 @@ enum cxl_fwl_loading {
 	CXL_FWL_LOADING_START,
 };
 
+struct cxl_fwctl {
+	int major;
+	int minor;
+};
+
 struct cxl_endpoint;
 struct cxl_memdev {
 	int id, major, minor;
@@ -56,6 +63,7 @@ struct cxl_memdev {
 	unsigned long long serial;
 	struct cxl_endpoint *endpoint;
 	struct cxl_fw_loader *fwl;
+	struct cxl_fwctl *fwctl;
 };
 
 struct cxl_dport {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 7a32b9b65736..54d97d7bb501 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -59,6 +59,7 @@ static inline enum cxl_fwl_status cxl_fwl_status_from_ident(char *status)
 }
 
 struct cxl_memdev;
+struct cxl_fwctl;
 struct cxl_memdev *cxl_memdev_get_first(struct cxl_ctx *ctx);
 struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
 int cxl_memdev_get_id(struct cxl_memdev *memdev);
@@ -69,6 +70,7 @@ const char *cxl_memdev_get_host(struct cxl_memdev *memdev);
 struct cxl_bus *cxl_memdev_get_bus(struct cxl_memdev *memdev);
 int cxl_memdev_get_major(struct cxl_memdev *memdev);
 int cxl_memdev_get_minor(struct cxl_memdev *memdev);
+struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
@@ -81,6 +83,9 @@ int cxl_memdev_update_fw(struct cxl_memdev *memdev, const char *fw_path);
 int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev);
 int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev, int timeout_ms);
 
+int cxl_fwctl_get_major(struct cxl_fwctl *fwctl);
+int cxl_fwctl_get_minor(struct cxl_fwctl *fwctl);
+
 /* ABI spelling mistakes are forever */
 static inline const char *cxl_memdev_get_firmware_version(
 		struct cxl_memdev *memdev)
-- 
2.49.0


