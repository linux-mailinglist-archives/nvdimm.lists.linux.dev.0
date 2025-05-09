Return-Path: <nvdimm+bounces-10352-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 356E1AB1AB6
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 May 2025 18:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04290188916E
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 May 2025 16:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C508236A6D;
	Fri,  9 May 2025 16:40:16 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C8421ABDB;
	Fri,  9 May 2025 16:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746808815; cv=none; b=O4H1f7oMcu1e3vJnIF9fy17vGsfTWBsETXY8NSydlCUts1YYjYYQZ4JoYb7tQV9qqTj//tLKPuYqvt/NPUQkCC9Dd/TEhBtSwl+KNfon6U8FQNMpHzavJnnNtTbd/GAC4ItmtKUk0Xn6aZjNzRz8i44Z1CiT0k1Lfk9bqx5OVg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746808815; c=relaxed/simple;
	bh=TPAdEo7/Dy06XWFbcjP6mddmndOYStgVjgz/BuyijHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JV8zfHEJZftiQ7ZxPuDCFJQ40eGwCNi7vCRDc811DV9+oibdfIge28+5W5VxsTSRTkXLnsYlC3qNvjo8e9sBCKpPq3KmhglgiOudFlAAf3t7CVU9hpiMuwkNUuiQciJ9QiFmDHRYJKcmxhruheiIa77y3t2bp8FmJXLt9U5GRu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A324C4CEE4;
	Fri,  9 May 2025 16:40:15 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: [NDCTL PATCH v6 4/4] cxl/test: Add test for cxl features device
Date: Fri,  9 May 2025 09:39:15 -0700
Message-ID: <20250509164006.687873-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250509164006.687873-1-dave.jiang@intel.com>
References: <20250509164006.687873-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a unit test to verify the features ioctl commands. Test support added
for locating a features device, retrieve and verify the supported features
commands, retrieve specific feature command data, retrieve test feature
data, and write and verify test feature data.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v6:
- Provide a fwctl option and move everything behind it. (Dan)
- Rename test app back to fwctl.c. (Dan)
- Fix spelling error. (Dan)
- Expand scope of fwctl device in documentation. (Dan)
---
 cxl/fwctl/cxl.h      |   2 +-
 meson_options.txt    |   2 +
 test/cxl-features.sh |  31 +++
 test/fwctl.c         | 439 +++++++++++++++++++++++++++++++++++++++++++
 test/meson.build     |  19 ++
 5 files changed, 492 insertions(+), 1 deletion(-)
 create mode 100755 test/cxl-features.sh
 create mode 100644 test/fwctl.c

diff --git a/cxl/fwctl/cxl.h b/cxl/fwctl/cxl.h
index 43f522f0cdcd..c560b2a1181d 100644
--- a/cxl/fwctl/cxl.h
+++ b/cxl/fwctl/cxl.h
@@ -9,7 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
-#include <cxl/features.h>
+#include "features.h"
 
 /**
  * struct fwctl_rpc_cxl - ioctl(FWCTL_RPC) input for CXL
diff --git a/meson_options.txt b/meson_options.txt
index 5c41b1abe1f1..acc19be4ff0a 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -28,3 +28,5 @@ option('iniparserdir', type : 'string',
        description : 'Path containing the iniparser header files')
 option('modprobedatadir', type : 'string',
        description : '''${sysconfdir}/modprobe.d/''')
+option('fwctl', type : 'feature', value : 'enabled',
+  description : 'enable firmware control')
diff --git a/test/cxl-features.sh b/test/cxl-features.sh
new file mode 100755
index 000000000000..3498fa08be53
--- /dev/null
+++ b/test/cxl-features.sh
@@ -0,0 +1,31 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Intel Corporation. All rights reserved.
+
+rc=77
+# 237 is -ENODEV
+ERR_NODEV=237
+
+. $(dirname $0)/common
+FEATURES="$TEST_PATH"/fwctl
+
+trap 'err $LINENO' ERR
+
+modprobe cxl_test
+
+test -x "$FEATURES" || do_skip "no CXL Features Contrl"
+# disable trap
+trap - $(compgen -A signal)
+"$FEATURES"
+rc=$?
+
+echo "error: $rc"
+if [ "$rc" -eq "$ERR_NODEV" ]; then
+	do_skip "no CXL FWCTL char dev"
+elif [ "$rc" -ne 0 ]; then
+	echo "fail: $LINENO" && exit 1
+fi
+
+trap 'err $LINENO' ERR
+
+_cxl_cleanup
diff --git a/test/fwctl.c b/test/fwctl.c
new file mode 100644
index 000000000000..7a780e718872
--- /dev/null
+++ b/test/fwctl.c
@@ -0,0 +1,439 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024-2025 Intel Corporation. All rights reserved.
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <endian.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <cxl/libcxl.h>
+#include <linux/uuid.h>
+#include <uuid/uuid.h>
+#include <util/bitmap.h>
+#include <cxl/fwctl/features.h>
+#include <cxl/fwctl/fwctl.h>
+#include <cxl/fwctl/cxl.h>
+
+static const char provider[] = "cxl_test";
+
+UUID_DEFINE(test_uuid,
+	    0xff, 0xff, 0xff, 0xff,
+	    0xff, 0xff,
+	    0xff, 0xff,
+	    0xff, 0xff,
+	    0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+);
+
+#define CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES	0x0500
+#define CXL_MBOX_OPCODE_GET_FEATURE		0x0501
+#define CXL_MBOX_OPCODE_SET_FEATURE		0x0502
+
+#define GET_FEAT_SIZE	4
+#define SET_FEAT_SIZE	4
+#define EFFECTS_MASK	(BIT(0) | BIT(9))
+
+#define MAX_TEST_FEATURES	1
+#define DEFAULT_TEST_DATA	0xdeadbeef
+#define DEFAULT_TEST_DATA2	0xabcdabcd
+
+struct test_feature {
+	uuid_t uuid;
+	size_t get_size;
+	size_t set_size;
+};
+
+static int send_command(int fd, struct fwctl_rpc *rpc, struct fwctl_rpc_cxl_out *out)
+{
+	if (ioctl(fd, FWCTL_RPC, rpc) == -1) {
+		fprintf(stderr, "RPC ioctl error: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	if (out->retval) {
+		fprintf(stderr, "operation returned failure: %d\n", out->retval);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int get_scope(u16 opcode)
+{
+	switch (opcode) {
+	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
+	case CXL_MBOX_OPCODE_GET_FEATURE:
+		return FWCTL_RPC_CONFIGURATION;
+	case CXL_MBOX_OPCODE_SET_FEATURE:
+		return FWCTL_RPC_DEBUG_WRITE_FULL;
+	default:
+		return -EINVAL;
+	}
+}
+
+static size_t hw_op_size(u16 opcode)
+{
+	switch (opcode) {
+	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
+		return sizeof(struct cxl_mbox_get_sup_feats_in);
+	case CXL_MBOX_OPCODE_GET_FEATURE:
+		return sizeof(struct cxl_mbox_get_feat_in);
+	case CXL_MBOX_OPCODE_SET_FEATURE:
+		return sizeof(struct cxl_mbox_set_feat_in) + sizeof(u32);
+	default:
+		return SIZE_MAX;
+	}
+}
+
+static void free_rpc(struct fwctl_rpc *rpc)
+{
+	void *in, *out;
+
+	in = (void *)rpc->in;
+	out = (void *)rpc->out;
+	free(in);
+	free(out);
+	free(rpc);
+}
+
+static void *zmalloc_aligned(size_t align, size_t size)
+{
+	void *ptr;
+	int rc;
+
+	rc = posix_memalign((void **)&ptr, align, size);
+	if (rc)
+		return NULL;
+	memset(ptr, 0, size);
+
+	return ptr;
+}
+
+static struct fwctl_rpc *get_prepped_command(size_t in_size, size_t out_size,
+					     u16 opcode)
+{
+	struct fwctl_rpc_cxl_out *out;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	size_t op_size;
+	int scope;
+
+	rpc = zmalloc_aligned(16, sizeof(*rpc));
+	if (!rpc)
+		return NULL;
+
+	in = zmalloc_aligned(16, in_size);
+	if (!in)
+		goto free_rpc;
+
+	out = zmalloc_aligned(16, out_size);
+	if (!out)
+		goto free_in;
+
+	in->opcode = opcode;
+
+	op_size = hw_op_size(opcode);
+	if (op_size == SIZE_MAX)
+		goto free_in;
+
+	in->op_size = op_size;
+
+	rpc->size = sizeof(*rpc);
+	scope = get_scope(opcode);
+	if (scope < 0)
+		goto free_all;
+
+	rpc->scope = scope;
+
+	rpc->in_len = in_size;
+	rpc->out_len = out_size;
+	rpc->in = (uint64_t)(uint64_t *)in;
+	rpc->out = (uint64_t)(uint64_t *)out;
+
+	return rpc;
+
+free_all:
+	free(out);
+free_in:
+	free(in);
+free_rpc:
+	free(rpc);
+	return NULL;
+}
+
+static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
+					  const uint32_t expected_data)
+{
+	struct cxl_mbox_get_feat_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	size_t out_size, in_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	uint32_t val;
+	void *data;
+	int rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	out_size = sizeof(*out) + feat_ctx->get_size;
+
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_FEATURE);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+
+	feat_in = &in->get_feat_in;
+	uuid_copy(feat_in->uuid, feat_ctx->uuid);
+	feat_in->count = feat_ctx->get_size;
+
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	data = out->payload;
+	val = le32toh(*(__le32 *)data);
+	if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+out:
+	free_rpc(rpc);
+	return rc;
+}
+
+static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
+{
+	struct cxl_mbox_set_feat_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	size_t in_size, out_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	uint32_t val;
+	void *data;
+	int rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in) + sizeof(val);
+	out_size = sizeof(*out) + sizeof(val);
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_SET_FEATURE);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	feat_in = &in->set_feat_in;
+	uuid_copy(feat_in->uuid, feat_ctx->uuid);
+	data = feat_in->feat_data;
+	val = DEFAULT_TEST_DATA2;
+	*(uint32_t *)data = htole32(val);
+	feat_in->flags = CXL_SET_FEAT_FLAG_FULL_DATA_TRANSFER;
+
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	rc = cxl_fwctl_rpc_get_test_feature(fd, feat_ctx, DEFAULT_TEST_DATA2);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to get feature verify: %d\n", rc);
+		goto out;
+	}
+
+out:
+	free_rpc(rpc);
+	return rc;
+}
+
+static int cxl_fwctl_rpc_get_supported_features(int fd, struct test_feature *feat_ctx)
+{
+	struct cxl_mbox_get_sup_feats_out *feat_out;
+	struct cxl_mbox_get_sup_feats_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	struct cxl_feat_entry *entry;
+	size_t out_size, in_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	int feats, rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	out_size = sizeof(*out) + sizeof(*feat_out);
+	/* First query, to get number of features w/o per feature data */
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
+	if (!rpc)
+		return -ENXIO;
+
+	/* No need to fill in feat_in first go as we are passing in all 0's */
+
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	feat_out = &out->get_sup_feats_out;
+	feats = le16toh(feat_out->supported_feats);
+	if (feats != MAX_TEST_FEATURES) {
+		fprintf(stderr, "Test device has greater than %d test features.\n",
+			MAX_TEST_FEATURES);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	free_rpc(rpc);
+
+	/* Going second round to retrieve each feature details */
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	out_size = sizeof(*out) + sizeof(*feat_out);
+	out_size += feats * sizeof(*entry);
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	feat_in = &in->get_sup_feats_in;
+	feat_in->count = htole32(feats * sizeof(*entry));
+
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	feat_out = &out->get_sup_feats_out;
+	feats = le16toh(feat_out->supported_feats);
+	if (feats != MAX_TEST_FEATURES) {
+		fprintf(stderr, "Test device has greater than %u test features.\n",
+			MAX_TEST_FEATURES);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (le16toh(feat_out->num_entries) != MAX_TEST_FEATURES) {
+		fprintf(stderr, "Test device did not return expected entries. %u\n",
+			le16toh(feat_out->num_entries));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	entry = &feat_out->ents[0];
+	if (uuid_compare(test_uuid, entry->uuid) != 0) {
+		fprintf(stderr, "Test device did not export expected test feature.\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (le16toh(entry->get_feat_size) != GET_FEAT_SIZE ||
+	    le16toh(entry->set_feat_size) != SET_FEAT_SIZE) {
+		fprintf(stderr, "Test device feature in/out size incorrect.\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (le16toh(entry->effects) != EFFECTS_MASK) {
+		fprintf(stderr, "Test device set effects incorrect\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	uuid_copy(feat_ctx->uuid, entry->uuid);
+	feat_ctx->get_size = le16toh(entry->get_feat_size);
+	feat_ctx->set_size = le16toh(entry->set_feat_size);
+
+out:
+	free_rpc(rpc);
+	return rc;
+}
+
+static int test_fwctl_features(struct cxl_memdev *memdev)
+{
+	struct test_feature feat_ctx;
+	unsigned int major, minor;
+	struct cxl_fwctl *fwctl;
+	int fd, rc;
+	char path[256];
+
+	fwctl = cxl_memdev_get_fwctl(memdev);
+	if (!fwctl)
+		return -ENODEV;
+
+	major = cxl_fwctl_get_major(fwctl);
+	minor = cxl_fwctl_get_minor(fwctl);
+
+	if (!major && !minor)
+		return -ENODEV;
+
+	sprintf(path, "/dev/char/%d:%d", major, minor);
+
+	fd = open(path, O_RDONLY, 0644);
+	if (fd < 0) {
+		fprintf(stderr, "Failed to open: %d\n", -errno);
+		return -errno;
+	}
+
+	rc = cxl_fwctl_rpc_get_supported_features(fd, &feat_ctx);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to get supported features: %d\n", rc);
+		goto out;
+	}
+
+	rc = cxl_fwctl_rpc_get_test_feature(fd, &feat_ctx, DEFAULT_TEST_DATA);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to get feature: %d\n", rc);
+		goto out;
+	}
+
+	rc = cxl_fwctl_rpc_set_test_feature(fd, &feat_ctx);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to set feature: %d\n", rc);
+		goto out;
+	}
+
+out:
+	close(fd);
+	return rc;
+}
+
+static int test_fwctl(struct cxl_ctx *ctx, struct cxl_bus *bus)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		if (cxl_memdev_get_bus(memdev) != bus)
+			continue;
+		return test_fwctl_features(memdev);
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct cxl_ctx *ctx;
+	struct cxl_bus *bus;
+	int rc;
+
+	rc = cxl_new(&ctx);
+	if (rc < 0)
+		return rc;
+
+	cxl_set_log_priority(ctx, LOG_DEBUG);
+
+	bus = cxl_bus_get_by_provider(ctx, provider);
+	if (!bus) {
+		fprintf(stderr, "%s: unable to find bus (%s)\n",
+			argv[0], provider);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = test_fwctl(ctx, bus);
+
+out:
+	cxl_unref(ctx);
+	return rc;
+}
diff --git a/test/meson.build b/test/meson.build
index d871e28e17ce..918db7e6049b 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -17,6 +17,13 @@ ndctl_deps = libndctl_deps + [
   versiondep,
 ]
 
+libcxl_deps = [
+  cxl_dep,
+  ndctl_dep,
+  uuid,
+  kmod,
+]
+
 libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
   dependencies : libndctl_deps,
   include_directories : root_inc,
@@ -235,6 +242,18 @@ if get_option('keyutils').enabled()
   ]
 endif
 
+uuid_dep = dependency('uuid', required: false)
+if get_option('fwctl').enabled() and uuid_dep.found()
+  fwctl = executable('fwctl', 'fwctl.c',
+    dependencies : libcxl_deps,
+    include_directories : root_inc,
+  )
+  cxl_features = find_program('cxl-features.sh')
+  tests += [
+    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
+  ]
+endif
+
 foreach t : tests
   test(t[0], t[1],
     is_parallel : false,
-- 
2.49.0


