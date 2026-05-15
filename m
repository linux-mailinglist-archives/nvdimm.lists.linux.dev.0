Return-Path: <nvdimm+bounces-14030-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yIytNNpkBmqbjQIAu9opvQ
	(envelope-from <nvdimm+bounces-14030-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 May 2026 02:12:10 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3349D547EB3
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 May 2026 02:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CE8230262FF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 May 2026 00:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63E9149C6F;
	Fri, 15 May 2026 00:12:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6E678F39;
	Fri, 15 May 2026 00:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778803925; cv=none; b=DDVaEdKGESFx1uprV+mMBmRyEWMcXYhp476EXpErGGzCIZbrvk/wiCp4fYV1gkPrF1MRXVCdzaSLBnyiIySiyWblN+Z2wVsTgZsjv6tkjTyTt0bNiaOO9C9Y3N4xJD+QOiQgqHq8vDy10ff7QNYshkwFQa+r4q+G4BZ1a7/+w4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778803925; c=relaxed/simple;
	bh=Ty+ceTxq3ZSm3E1EKFYAdJlnXeiUaGgWBIQM3yrL0O0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qSF84GAsvCCmcw1HLP0lXELOX6NiurNkQ103gKTYmNgEMHrTHB+LA05BLvLcK7GueoNXraxRmUNeaXBdikcTIKsSxjo35LgnDcOWQLWaWlNhSCcXLrgeKKHRBzY/ecA4/WsfjsSCAxxHrO6Q9goWJA3PPCr157rqC9UJUpx+Gjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E424C2BCB3;
	Fri, 15 May 2026 00:12:05 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v2] cxl: Add CXL type2 accelerator unit test
Date: Thu, 14 May 2026 17:12:03 -0700
Message-ID: <20260515001203.2628149-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3349D547EB3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[intel.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14030-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.933];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:mid,cxl-type2.sh:url,cxl-translate.sh:url,cxl-dax-hmem.sh:url,cxl-elc.sh:url]
X-Rspamd-Action: no action

CXL type2 hierachy can be setup via the cxl_test. Add a regression test
unit to CXL CLI to verify the type2 loading/unloading. Test include
removing the root port and bringing it back, unbinding the type2 mock
device driver and bringing it back, and checking to see if a region
can be destroyed and a memdev can be disabled.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Load/unload module once for test. (Alison)
- Add additional tests. (Alison)
---
 test/cxl-type2.sh | 103 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build  |   2 +
 2 files changed, 105 insertions(+)
 create mode 100644 test/cxl-type2.sh

diff --git a/test/cxl-type2.sh b/test/cxl-type2.sh
new file mode 100644
index 000000000000..34e22adcc223
--- /dev/null
+++ b/test/cxl-type2.sh
@@ -0,0 +1,103 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")"/common
+
+rc=77
+set -ex
+trap 'err $LINENO' ERR
+check_prereq "jq"
+
+remove_kmod() {
+	modprobe -r cxl_test
+}
+
+load_kmod() {
+	modprobe cxl_test type2_test=1
+}
+
+init_check() {
+	load_kmod
+	[ -f /sys/module/cxl_test/parameters/type2_test ] || \
+		do_skip "cxl_test type2_test module param not available"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+}
+
+# Test rootport disable/enable case
+cycle_root_port() {
+	echo "Testing root port disable/enable"
+	memdev=$("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[0].memdev')
+	[ -n "$memdev" ] || err "$LINENO"
+	port=$("$CXL" list -b "$CXL_TEST_BUS" -m "$memdev" -P | jq -r '.[0].port')
+	[ -n "$port" ] || err "$LINENO"
+
+	"$CXL" disable-port "$port" -f
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+
+	"$CXL" enable-port "$port"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+}
+
+# Test rebind device driver
+cycle_pdev_driver() {
+	echo "Testing device driver unbind/bind"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/unbind
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+}
+
+# Test memdev removal with CXL CLI
+test_dev_removal() {
+	echo "Testing device removal with CXL CLI"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+	"$CXL" disable-region "$region"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+
+	# type2 region is auto region and cannot be destroyed
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -Ri | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+	"$CXL" destroy-region "$region" || true
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -Ri | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+
+	# Do it directly via sysfs since CXL CLI has checks that will skip sysfs
+	echo "0" | tee /sys/bus/cxl/devices/"$region"/commit || true
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -Ri | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+
+	# Make sure there's no delete_region for a type2 root decoder
+	rd=$("$CXL" list -b "$CXL_TEST_BUS" -r"$region" -D | jq -r '.[0]."root decoders"[0].decoder')
+	[ -n "$rd" ] || err "$LINENO"
+	[ ! -f /sys/bus/cxl/devices/"$rd"/delete_region ] || err "$LINENO"
+
+	memdev=$("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[0].memdev')
+	[ -n "$memdev" ] || err "$LINENO"
+
+	# memdev is not expected to be removed because region can't be destroyed
+	"$CXL" disable-memdev "$memdev" || true
+	memdev=$("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[0].memdev // empty')
+	[ -n "$memdev" ] || err "$LINENO"
+}
+
+remove_kmod
+init_check
+rc=1
+
+cycle_root_port
+cycle_pdev_driver
+test_dev_removal
+
+check_dmesg "$LINENO"
+remove_kmod
diff --git a/test/meson.build b/test/meson.build
index e0e2193bfd51..567347b655d2 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -171,6 +171,7 @@ cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
+cxl_type2 = find_program('cxl-type2.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -207,6 +208,7 @@ tests = [
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
+  [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

base-commit: 81c7cdd6cbcb4f1f77870ff02d8dd86298036f58
-- 
2.54.0


