Return-Path: <nvdimm+bounces-13917-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WO8kAqeQ4mmX7QAAu9opvQ
	(envelope-from <nvdimm+bounces-13917-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 21:57:27 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF5641E666
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 21:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16E4E3059FC6
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 19:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39DD38F64A;
	Fri, 17 Apr 2026 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eL/ToGA4"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C40734216C
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776455792; cv=none; b=XFedblQobLFdb9cxr+k5piF+X4+5KhVLMUAv5qtdXzb0HQir+z3OjtEilnZTwCe4f7OjcgmxejEWyLopgzyMwlXlrHz68swYDRTuGCKZofSv9bolf0JE4ym+MqTnRcp2T+hnBdEazrhPsjNFI1kQBkjHtSHey54zDA95dHGsB/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776455792; c=relaxed/simple;
	bh=ksuYBGHbHGCoFIpozDY/F5XCFRC+LNWv6xjmNIfUBnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1aWgRrCKD3OMDDrCYBZWy/l6NHDIIUdbNphM49WO/NKb78nhNNeIplAEaA7dL01gD0J8hWKMr/8nX6cJ19pEUrBXlxLNAFy1b1Pt1gJdx0h8MZ4azoVYDRspQ4ZHLeKVbKmkxI05MdS+xCprVmFCZ7yJI/jiAN6ZWr/OrNFsn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eL/ToGA4; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776455790; x=1807991790;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ksuYBGHbHGCoFIpozDY/F5XCFRC+LNWv6xjmNIfUBnM=;
  b=eL/ToGA4Tuxs2skR6m0W83j0JlLSSGAz+e3hIY3KHOuGg9M4Kg6o8E6M
   z+HeOanP0FvqBbuVQxi2Zu9Gq0c8TCneuCSl0pQ2IJQguk0M+pjVz1WLJ
   JxiKvLB/w1RwpHn7pCRlH3Aray695EiFjhlIqk9PsuwFFtE+5lAVTmMg7
   QHJkbLhH1R5Hia5tqUMA5lZlXYUrWOTet2G3QrMnQT6upsqbRt6kUF1a5
   lKHEXYTpj0IWnXltWt2oqArJYCxF/qOhkkP78ZRE9mky4khY68uR8X1DP
   zcxcQ0Ozyd5JNfyuV08qlrxzjZERhEBQxdMEZRzovZqqy49RzOacIlVBW
   w==;
X-CSE-ConnectionGUID: m6ohha7cTpSVkArtm7G08A==
X-CSE-MsgGUID: dLoJ5DsxTf6jzBJIbqR5PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77548545"
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="77548545"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 12:56:29 -0700
X-CSE-ConnectionGUID: mJIVEl5yQ4iMF0UhAE08nw==
X-CSE-MsgGUID: QokvExqaQA280F311kQepw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="224620538"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 12:56:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Subject: [ndctl PATCH v2 1/2] test/common: add helpers for CXL region replay testing
Date: Fri, 17 Apr 2026 12:56:23 -0700
Message-ID: <ccc1955b697f7b74e16924bff1b1e262eb52fba0.1776454849.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13917-lists,linux-nvdimm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[alison.schofield@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7DF5641E666
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add replay_regions() and supporting helpers to the CXL test common
library. The helpers capture the current region configuration, trigger
a region replay by unbinding and rebinding the cxl_acpi driver, and
verify that the regions reconstructed during enumeration match the
original configuration.

Replay is enabled by instructing the cxl_test module to preserve its
decoder registry across the driver unbind/bind cycle. This allows the
decoder programming associated with user-created regions to survive
topology teardown so that the regions are reconstructed during driver
initialization as auto-discovered regions.

Region signatures are derived from region attributes and memdev serial
numbers so that the replayed configuration can be compared independent
of topology enumeration order and device numbering.

These helpers provide a reusable mechanism for CXL tests that need to
exercise region replay behavior. A unit test, cxl-region-replay.sh, is
posted in a follow-on patch and demonstrates the workflow.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Tested-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Link: https://lore.kernel.org/r/8646e0b11697e3adb4fc9a83fa486e68a4b9b5c5.1773466514.git.alison.schofield@intel.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Add comment for replay state comparison (Fabio)
- Rebase onto latest ndctl/pending
- Add Fabio's Tags


 test/common | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/test/common b/test/common
index 2eb11b7396d0..d60d9e046445 100644
--- a/test/common
+++ b/test/common
@@ -168,3 +168,114 @@ check_dmesg()
 
 # CXL COMMON
 CXL_TEST_QOS_CLASS=42
+
+# CXL region replay helpers
+#
+# replay_regions() snapshots the current region configuration, performs
+# a cxl_acpi driver unbind/bind cycle to trigger region replay, and
+# verifies that the regions reconstructed during enumeration match the
+# original configuration.
+#
+# This allows tests to create regions through the user interface and
+# then replay them as auto-discovered regions during driver
+# initialization.
+#
+# See example usage in test/cxl-region-replay.sh.
+
+CXL_EXPECTED_REGION_SIGS=""
+
+cxl_get_memdev_serial()
+{
+	local memdev="$1"
+
+	"$CXL" list -m "$memdev" | jq -r '.[0].serial'
+}
+
+cxl_emit_region_signature()
+{
+	local region="$1"
+	local region_json size type ways gran state
+	local entry pos memdev serial sig
+
+	region_json=$("$CXL" list -R --targets -r "$region")
+	[[ -n "$region_json" && "$region_json" != "[]" ]] || return 1
+
+	size=$(jq -r '.[0].size' <<<"$region_json")
+	type=$(jq -r '.[0].type' <<<"$region_json")
+	ways=$(jq -r '.[0].interleave_ways' <<<"$region_json")
+	gran=$(jq -r '.[0].interleave_granularity' <<<"$region_json")
+	state=$(jq -r '.[0].decode_state' <<<"$region_json")
+
+	sig="size=$size type=$type ways=$ways gran=$gran"
+
+	while IFS= read -r entry; do
+		pos=$(jq -r '.position' <<<"$entry")
+		memdev=$(jq -r '.memdev' <<<"$entry")
+		serial=$(cxl_get_memdev_serial "$memdev") || return 1
+		[[ -n "$serial" && "$serial" != "null" ]] || return 1
+		sig="$sig pos=$pos serial=$serial"
+	done < <(jq -c '.[0].mappings | sort_by(.position)[]' <<<"$region_json")
+
+	echo "$sig state=$state"
+}
+
+cxl_collect_region_signatures()
+{
+	local region
+	local -a regions=()
+
+	mapfile -t regions < <("$CXL" list -Ri | jq -r '.[].region' | sort) || return 1
+
+	for region in "${regions[@]}"; do
+		cxl_emit_region_signature "$region" || return 1
+	done | sort
+}
+
+cxl_capture_expected_region_signatures()
+{
+	CXL_EXPECTED_REGION_SIGS=$(cxl_collect_region_signatures) || return 1
+}
+
+cxl_verify_replayed_regions()
+{
+	local actual_region_sigs
+	local -a expected_lines=()
+	local -a actual_lines=()
+	local i
+	local expected_line actual_line
+	local expected_struct actual_struct
+	local expected_state actual_state
+
+	actual_region_sigs=$(cxl_collect_region_signatures) || return 1
+
+	mapfile -t expected_lines < <(printf '%s\n' "$CXL_EXPECTED_REGION_SIGS" | sed '/^$/d')
+	mapfile -t actual_lines < <(printf '%s\n' "$actual_region_sigs" | sed '/^$/d')
+
+	[ "${#expected_lines[@]}" -eq "${#actual_lines[@]}" ] || return 1
+
+	for ((i = 0; i < ${#expected_lines[@]}; i++)); do
+		expected_line=${expected_lines[i]}
+		actual_line=${actual_lines[i]}
+
+		expected_struct=${expected_line% state=*}
+		expected_state=${expected_line##* state=}
+		actual_struct=${actual_line% state=*}
+		actual_state=${actual_line##* state=}
+
+		# Require exact structural match for the region config.
+		# Only enforce state when the expected state was commit.
+		[ "$expected_struct" = "$actual_struct" ] || return 1
+		[ "$expected_state" != "commit" ] || [ "$actual_state" = "commit" ] || return 1
+	done
+}
+
+replay_regions()
+{
+	echo "replaying existing regions"
+	cxl_capture_expected_region_signatures || return 1
+	echo 1 > /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry
+	echo cxl_acpi.0 > /sys/bus/platform/drivers/cxl_acpi/unbind
+	echo cxl_acpi.0 > /sys/bus/platform/drivers/cxl_acpi/bind
+	echo 0 > /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry
+	cxl_verify_replayed_regions || return 1
+}
-- 
2.37.3


