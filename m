Return-Path: <nvdimm+bounces-8409-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D4C915871
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jun 2024 23:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64A6A1C2244C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jun 2024 21:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A901A08C9;
	Mon, 24 Jun 2024 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FjSiz7Dp"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7C1A00DE
	for <nvdimm@lists.linux.dev>; Mon, 24 Jun 2024 21:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719263210; cv=none; b=Nupt9wxhBNcYcbof4WIFv+Vc8wZc6XAkNgSSMRBEbhlYbkKdVlWH2uwDttt5gZxo7+iTkhWLFWLL3ctX6+G16MI05kzWnPJ4jzWi6fifOsDFOlregG+mQxigWjABs7oKG8uX4ncOMekhAxU3MiCyKGFowq+CqAm1iwJM5rl2ZcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719263210; c=relaxed/simple;
	bh=R/t899kMVsz1GCvL9hdaUVDf3S5y9/adwOitnAB34uo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gec+ZsFxmG6BCb/JifTjRygUJcfFU0f8RP/GEzGyOWLB2NERHH/FBfot8ipGswxardtzj1IpDQOAqiRmygPxVXwjv0fpwkjXBWUJJz0Of8sSs5cAr/Kk4G0zqhk7ksvJqJcR1XEOZa6YK1s1YxyL3MOLNXExRA+HbXpRwzoM4w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FjSiz7Dp; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719263209; x=1750799209;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R/t899kMVsz1GCvL9hdaUVDf3S5y9/adwOitnAB34uo=;
  b=FjSiz7DpJ03NBCYSx6LNyvi2gsX1UAHN6xCVb8dp5gi60xbdrQtBRlDX
   enso0YsvBq/zg+8+coVVzYdmwm9WWOA+2xnawUzUsIoG0nvWwaG9ZJH0P
   EDVuUJFnYR2FDeQXREjgwbzfpkLwuOQRumnMdPyNL+NXJjddcS2UMzZCk
   R2jESowVBScY0qdK5hd5Ur20LLolhIozLRlJHmw8itNwmyLyRvb5Qoyy/
   VY2YktXalo18z7n3bYlojpwG8jzDzgFj+r1n3+HHyCRi6knjsK50ae3a8
   w0xgbItz7CRKwJbJjWX5FFm/M21g3w9UMb+cNx9dGShN3hyntkooO0+mD
   g==;
X-CSE-ConnectionGUID: RFDfT8beRvOCg51muP1eeg==
X-CSE-MsgGUID: OFW9BJGYTxuI54lhXpdSeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="26845247"
X-IronPort-AV: E=Sophos;i="6.08,262,1712646000"; 
   d="scan'208";a="26845247"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 14:06:48 -0700
X-CSE-ConnectionGUID: +yVwtFwWRkmD90DfK1IjsQ==
X-CSE-MsgGUID: H97FnB23SQ2Bn3HUxuhVBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,262,1712646000"; 
   d="scan'208";a="66640108"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.55.37])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 14:06:47 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] cxl/test: add cxl_translate unit test
Date: Mon, 24 Jun 2024 14:06:44 -0700
Message-Id: <20240624210644.495563-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

cxl_translate.sh is added to the CXL unit test suite along with
a C program 'translate' that performs the address translations.

The test program performs the same calculations as the CXL driver
while the script feeds the test program trusted samples.

The trusted samples are either from the CXL Driver Writers
Guide[1] or from another source that has been verified. ie a
spreadsheet reviewed by CXL developers.

[1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

More sample data is wanted. If you have a sample set or would be
willing to review sample sets I generate, please reach out.

The CXL Drivers Writers Guide update that includes the tables used
here is under review and not yet available at the provided link.


 test/cxl-translate.sh | 215 ++++++++++++++++++++++++++++++++++++++++++
 test/meson.build      |   6 ++
 test/translate.c      | 163 ++++++++++++++++++++++++++++++++
 3 files changed, 384 insertions(+)
 create mode 100755 test/cxl-translate.sh
 create mode 100644 test/translate.c

diff --git a/test/cxl-translate.sh b/test/cxl-translate.sh
new file mode 100755
index 000000000000..be6d7f43a136
--- /dev/null
+++ b/test/cxl-translate.sh
@@ -0,0 +1,215 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+set -ex
+trap 'err $LINENO' ERR
+
+rc=1
+
+TEST=$TEST_PATH/translate
+MODULO=0
+XOR=1
+
+# Test against 'Sample Sets' and 'XOR Tables'
+#
+# Sample Set's have a pattern and the expected HPAs have been verified
+# although maybe not published. They verify Modulo and XOR translations.
+#
+# XOR Table's are extracted from the CXL Driver Writers Guide [1].
+# Although the XOR Tables do not include an explicit check of the Modulo
+# translation result, a Modulo calculation is always the first step in
+# any XOR calculation. ie. if Modulo fails so does XOR.
+#
+# [1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html
+
+
+# Sample Sets
+#
+# params_#: dpa, region eiw, region eig, host bridge eiw
+# expect_[modulo|xor]_#: expected hpa for each position in the region
+# 	interleave set for the modulo|xor math.
+#
+# Feeds the parameters with an expected hpa for each position in the
+# region interleave to TEST. The test performs the same calculations
+# as the CXL Driver and returns success if its calculation matches
+# the expected hpa.
+
+# 1+1+1+1
+# 4 way region interleave using 4 host bridges
+declare -A Sample_4R_4H=(
+	["params_0"]="0 2 0 2"
+	["expect_modulo_0"]="0 256 512 768"
+	["expect_xor_0"]="0 256 512 768"
+	["params_1"]="256 2 0 2"
+	["expect_modulo_1"]="1024 1280 1536 1792"
+	["expect_xor_1"]="1024 1280 1536 1792"
+	["params_2"]="2048 2 0 2"
+	["expect_modulo_2"]="8192 8448 8704 8960"
+	["expect_xor_2"]="8192 8448 8704 8960"
+)
+
+# 1+1+1+1+1+1+1+1+1+1+1+1
+# 12 way region interleave using 12 host bridges
+declare -A Sample_12R_12H=(
+	["params_0"]="0 10 0 10"
+	["expect_modulo_0"]="0 256 512 768 1024 1280 1536 1792 2048 2304 2560 2816"
+	["expect_xor_0"]="0 256 512 768 1024 1280 1536 1792 2304 2048 2816 2560"
+	["params_1"]="512 10 0 10"
+	["expect_modulo_1"]="6144 6400 6656 6912 7168 7424 7680 7936 8192 8448 8704 8960"
+	["expect_xor_1"]="6912 6656 6400 6144 7936 7680 7424 7168 8192 8448 8704 8960"
+)
+
+decode_r_eiw()
+{
+	case $1 in
+		0) echo 1 ;;
+		1) echo 2 ;;
+		2) echo 4 ;;
+		3) echo 8 ;;
+		4) echo 16 ;;
+		8) echo 3 ;;
+		9) echo 6 ;;
+		10) echo 12 ;;
+		*) echo "Invalid r_eiw value: $1" ; err "$LINENO" ;;
+	esac
+}
+
+test_sample_set()
+{
+	local -n sample_set=$1
+	local sample_count=$((${#sample_set[@]} / 3))
+
+	for i in $(seq 0 $((sample_count - 1))); do
+		# Split the parameters and expected hpa values
+		IFS=' ' read -r dpa r_eiw r_eig hb_eiw <<< "${sample_set["params_$i"]}"
+		IFS=' ' read -r -a expect_modulo_values <<< "${sample_set["expect_modulo_$i"]}"
+		IFS=' ' read -r -a expect_xor_values <<< "${sample_set["expect_xor_$i"]}"
+
+		ways=$(decode_r_eiw "$r_eiw")
+		for ((pos = 0; pos < ways; pos++)); do
+			expect_hpa_modulo=${expect_modulo_values[$pos]}
+			expect_hpa_xor=${expect_xor_values[$pos]}
+
+			"$TEST" "$dpa" "$pos" "$r_eiw" "$r_eig" "$hb_eiw" $MODULO "$expect_hpa_modulo" || {
+				err "$LINENO"
+			}
+			"$TEST" "$dpa" "$pos" "$r_eiw" "$r_eig" "$hb_eiw" $XOR "$expect_hpa_xor" || {
+				err "$LINENO"
+			}
+		done
+	done
+}
+
+# XOR Tables
+#
+# The tables that follow are the XOR translation examples in the
+# CXL Driver Writers Guide Sections 2.13.24.1 and 25.1
+#
+# Format: "dpa pos r_eiw r_eig h_eiw xor_hpa:
+
+# 1+1+1+1
+# 4 way region interleave using 4 host bridges
+XOR_Table_4R_4H=(
+	"248 0 2 0 2 248"
+	"16 1  2 0 2 272"
+	"16 2  2 0 2 528"
+	"32 3  2 0 2 800"
+	"288 0 2 0 2 1056"
+	"288 1 2 0 2 1312"
+	"288 2 2 0 2 1568"
+	"288 3 2 0 2 1824"
+	"544 1 2 0 2 2080"
+	"544 0 2 0 2 2336"
+	"544 3 2 0 2 2592"
+	"1040 2 2 0 2 4112"
+	"1568 3 2 0 2 6176"
+	"32784 1 2 0 2 131088"
+	"65552 2 2 0 2 262160"
+	"98336 3 2 0 2 393248"
+	"98328 2 2 0 2 393496"
+	"98352 2 2 0 2 393520"
+	"443953523 0 2 0 2 1775813747"
+)
+
+# 2+2+2+2
+# 8 way region interleave using 4 host bridges
+XOR_Table_8R_4H=(
+	"248 0 3 0 2 248"
+	"16  2 3 0 2 528"
+	"16  4 3 0 2 1040"
+	"32  6 3 0 2 1568"
+	"272 2 3 0 2 2832"
+	"528 4 3 0 2 5648"
+	"800 6 3 0 2 7456"
+	"16400 1 3 0 2 131088"
+	"32784 2 3 0 2 262160"
+	"49184 3 3 0 2 393248"
+	"49176 2 3 0 2 393496"
+	"49200 2 3 0 2 393520"
+	"116520373 3 3 0 2 932162229"
+	"244690459 5 3 0 2 1957525275"
+	"292862215 5 3 0 2 2342899463"
+	"30721158  4 3 0 2 245769350"
+	"246386959 4 3 0 2 1971096847"
+	"72701249  5 3 0 2 581610561"
+	"529382429 5 3 0 2 4235060509"
+	"191132300 2 3 0 2 1529057420"
+	"18589081  1 3 0 2 148712089"
+	"344295715 7 3 0 2 2754367011"
+)
+
+# 1+1+1+1+1+1+1+1+1+1+1+1
+# 12 way region interleave using 12 host bridges
+XOR_Table_12R_12H=(
+	"224 0 10 0 10 224"
+	"16  1 10 0 10 272"
+	"16  2 10 0 10 528"
+	"32  3 10 0 10 800"
+	"32  4 10 0 10 1056"
+	"32  5 10 0 10 1312"
+	"32  6 10 0 10 1568"
+	"32  7 10 0 10 1824"
+	"32  9 10 0 10 2080"
+	"32  8 10 0 10 2336"
+	"32 11 10 0 10 2592"
+	"32 10 10 0 10 2848"
+	"288 0 10 0 10 3360"
+	"299017087 7 10 0 10 3588205439"
+	"329210435 0 10 0 10 3950524995"
+	"151050637 11 10 0 10 1812608653"
+	"145169214  2 10 0 10 1742030654"
+	"328998732 10 10 0 10 3947985996"
+	"159252439  3 10 0 10 1911027415"
+	"342098916  5 10 0 10 4105186020"
+	"97970344   8 10 0 10 1175645096"
+	"214995572  8 10 0 10 2579948404"
+	"101289661  7 10 0 10 1215475645"
+	"40424079   7 10 0 10 485088911"
+	"231458716  7 10 0 10 2777503900"
+)
+
+test_xor_table()
+{
+	local -n samples=$1
+
+	for sample in "${samples[@]}"; do
+		IFS=' ' read -r dpa pos r_eiw r_eig hb_eiw xor_hpa <<< "$sample"
+
+		"$TEST" "$dpa" "$pos" "$r_eiw" "$r_eig" "$hb_eiw" $XOR "$xor_hpa" || {
+			err "$LINENO"
+		}
+	done
+}
+
+# Process Samples
+test_sample_set Sample_4R_4H
+test_sample_set Sample_12R_12H
+
+test_xor_table XOR_Table_4R_4H
+test_xor_table XOR_Table_8R_4H
+test_xor_table XOR_Table_12R_12H
+
+echo "All samples processed successfully"
diff --git a/test/meson.build b/test/meson.build
index a965a79fd6cb..f15a97a12b47 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -132,6 +132,10 @@ revoke_devmem = executable('revoke_devmem', testcore + [
 
 mmap = executable('mmap', 'mmap.c',)
 
+translate = executable('translate', 'translate.c',
+  include_directories : root_inc,
+)
+
 create = find_program('create.sh')
 clear = find_program('clear.sh')
 pmem_errors = find_program('pmem-errors.sh')
@@ -160,6 +164,7 @@ cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
+cxl_translate = find_program('cxl-translate.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -192,6 +197,7 @@ tests = [
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
+  [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
diff --git a/test/translate.c b/test/translate.c
new file mode 100644
index 000000000000..e39637d6a8e1
--- /dev/null
+++ b/test/translate.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 Intel Corporation. All rights reserved.
+#include <inttypes.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <ccan/short_types/short_types.h>
+
+/* Mimic kernel macros */
+#define BITS_PER_LONG_LONG 64
+#define GENMASK_ULL(h, l) \
+	(((~(0)) - ((1) << (l)) + 1) & (~(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
+
+#define XOR_MATH 1
+
+static int hweight64(u64 value)
+{
+	int count = 0;
+
+	while (value) {
+		count += value & 1;
+		value >>= 1;
+	}
+	return count;
+}
+
+static u64 __restore_xor_pos(u64 hpa, u64 map)
+{
+	u64 val;
+	int pos;
+
+	if (!map)
+		return hpa;
+
+	/* XOR of all set bits */
+	val = (hweight64(hpa & map)) & 1;
+
+	/* Find the lowest set bit in the map */
+	pos = ffs(map) - 1;
+
+	/* Set bit at hpa[pos] to val */
+	hpa = (hpa & ~(1ULL << pos)) | (val << pos);
+
+	return hpa;
+}
+
+static u64 restore_xor_pos(u64 hpa_offset, u8 eiw)
+{
+	u64 temp_a, temp_b, temp_c;
+
+	switch (eiw) {
+	case 0: /* 1-way */
+	case 8: /* 3-way */
+		return hpa_offset;
+
+	/*
+	 * These map values were selected to match the samples
+	 * in the CXL Drivers Writers Guide for Host Bridge
+	 * Interleaves at HBIG 0: 0x2020900, 0x4041200
+	 *
+	 * TODO Add the xormaps as test parameters.
+	 */
+	case 1: /* 2-way */
+		return __restore_xor_pos(hpa_offset, 0x2020900);
+
+	case 2: /* 4-way */
+		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
+		return __restore_xor_pos(temp_a, 0x4041200);
+
+	case 3: /* 8-way */
+		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
+		temp_b = __restore_xor_pos(temp_a, 0x4041200);
+		return __restore_xor_pos(temp_b, 0x1010400);
+
+	case 4: /* 16-way */
+		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
+		temp_b = __restore_xor_pos(temp_a, 0x4041200);
+		temp_c = __restore_xor_pos(temp_b, 0x1010400);
+		return __restore_xor_pos(temp_c, 0x800);
+
+	case 9: /* 6-way */
+		return __restore_xor_pos(hpa_offset, 0x2020900);
+
+	case 10: /* 12-way */
+		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
+		return __restore_xor_pos(temp_a, 0x4041200);
+
+	default:
+		return ULLONG_MAX;
+	}
+
+	return ULLONG_MAX;
+}
+
+static u64 to_hpa(u64 dpa_offset, int pos, u8 eiw, u16 eig, u8 hb_eiw, u8 math)
+{
+	u64 mask_upper, mask_lower;
+	u64 bits_upper, bits_lower;
+	u64 hpa_offset;
+
+	/*
+	 * Translate DPA->HPA by reversing the HPA->DPA decoder logic
+	 * defined in CXL Spec 3.0 Section 8.2.4.19.13  Implementation
+	 * Note: Device Decode Logic
+	 *
+	 * Insert the 'pos' to construct the HPA.
+	 */
+	mask_upper = GENMASK_ULL(51, eig + 8);
+
+	if (eiw < 8) {
+		hpa_offset = (dpa_offset & mask_upper) << eiw;
+		hpa_offset |= pos << (eig + 8);
+	} else {
+		bits_upper = (dpa_offset & mask_upper) >> (eig + 8);
+		bits_upper = bits_upper * 3;
+		hpa_offset = ((bits_upper << (eiw - 8)) + pos) << (eig + 8);
+	}
+
+	/* Lower bits don't change */
+	mask_lower = (1 << (eig + 8)) - 1;
+	bits_lower = dpa_offset & mask_lower;
+	hpa_offset += bits_lower;
+
+	if (math == XOR_MATH)
+		hpa_offset = restore_xor_pos(hpa_offset, hb_eiw);
+
+	return hpa_offset;
+}
+
+int main(int argc, char *argv[])
+{
+	u8 region_eiw, hostbridge_eiw;
+	u64 dpa, expect_hpa, hpa;
+	u16 region_eig;
+	int math, pos;
+
+	if (argc != 8) {
+		printf("Usage: %s <dpa> <pos> <region_eiw> <region_eig> <host_eiw> <math> <hpa>\n",
+		       argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	dpa = strtoull(argv[1], NULL, 0);
+	pos = atoi(argv[2]);
+	region_eiw = strtoul(argv[3], NULL, 0);
+	region_eig = strtoul(argv[4], NULL, 0);
+	hostbridge_eiw = strtoul(argv[5], NULL, 0);
+	math = atoi(argv[6]);
+	expect_hpa = strtoull(argv[7], NULL, 0);
+
+	hpa = to_hpa(dpa, pos, region_eiw, region_eig, hostbridge_eiw, math);
+
+	if (hpa != expect_hpa) {
+		printf("Fail: expected_hpa %lu translated_hpa:%lu\n",
+		       expect_hpa, hpa);
+		return EXIT_FAILURE;
+	}
+	printf("Pass: expected_hpa %lu translated_hpa:%lu\n", expect_hpa, hpa);
+
+	return 0;
+}

base-commit: 16f45755f991f4fb6d76fec70a42992426c84234
-- 
2.37.3


