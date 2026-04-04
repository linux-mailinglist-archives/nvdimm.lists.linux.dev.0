Return-Path: <nvdimm+bounces-13812-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 1OFhO7l80GmQ8AYAu9opvQ
	(envelope-from <nvdimm+bounces-13812-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 04 Apr 2026 04:51:37 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20323399AC8
	for <lists+linux-nvdimm@lfdr.de>; Sat, 04 Apr 2026 04:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C973430247FC
	for <lists+linux-nvdimm@lfdr.de>; Sat,  4 Apr 2026 02:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDBB2E2DD2;
	Sat,  4 Apr 2026 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZqrw+Dp"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5289F2E091E
	for <nvdimm@lists.linux.dev>; Sat,  4 Apr 2026 02:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775271091; cv=none; b=OK9lq4vnu+OurLkGIJiPzV6K3yH0e0pxDIDkHDS06LwzPjwrnQVc7sVVXLBchbwVEon2NksRLRg879WvTjONBvIQLXeL4Yu4CkMfbKYGzlxa+ncD3UXonhA4gjOTggycC4bUqYMP/iQXU7iTbb9zAEOVKlkAAqrYq+md4D0CSiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775271091; c=relaxed/simple;
	bh=hfWQKDjsB7YH2/j6QsckO2nPJ2e2M0lp9aYuaRdAMH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iaODmBzLUhTUb/pd9/vbai/xD+6HCQ/lYEbTj1fEUe065i6OeV7TUmVRoDr2hNiozry9GVyw0DoMCZua+nTsz0F2+IJi/hItHc2Dg54DNFdrL3OKQY6Hx6FnFNuv9tmUbYMp1ZDeeDET523NcOEsgH4tjX4fN1jUS1Um5YVi0ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZqrw+Dp; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775271089; x=1806807089;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hfWQKDjsB7YH2/j6QsckO2nPJ2e2M0lp9aYuaRdAMH4=;
  b=RZqrw+Dpe05EAV2DJQ9nM7AO1taT9gUBKBVHDZYxpC6atl6rJfhdbCyq
   FYJy18EiZl8HOAWzDAOAS2T6PA9SAlkqzzgHU6gGET4wfUkBSKhKrYfQy
   dpiAOeagEe1/+DKz3RwZMZZAiydct/bnwZN1w83CFZ1EITZTusK/ZY0Mk
   WllgkiO5dbfPH57Kf6dqyUcb0UoBJuNj56sbZNUbA2tJW1Ng5fKZ1c2de
   kvK6zYM5qWh4qr+3OnQEPvBbWs5vEd70EF6qSHWGrWHWYlNNfHQW2z4RY
   pzVs/t+3ONoe7bNgEKHtiH06CF2BwEwvfJCC9GOcpMsRhilC+7j5CYkQR
   g==;
X-CSE-ConnectionGUID: O1CprSNSSaiCoRiyjmsv1w==
X-CSE-MsgGUID: wwx24ZwCRj6V8CQJh9kRiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="87399758"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="87399758"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 19:51:28 -0700
X-CSE-ConnectionGUID: kfspY5WrRXiFA1eKa/SsoQ==
X-CSE-MsgGUID: kHJtf6xTSimWT5qe0vGQow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="227329014"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.12])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 19:51:27 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2] test/cxl-dax-hmem.sh: validate dax_hmem vs CXL collisions
Date: Fri,  3 Apr 2026 19:51:21 -0700
Message-ID: <20260404025123.2967169-1-alison.schofield@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13812-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alison.schofield@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,cxl-elc.sh:url,cxl-dax-hmem.sh:url,cxl-translate.sh:url,cxl-destroy-region.sh:url]
X-Rspamd-Queue-Id: 20323399AC8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Dan Williams <dan.j.williams@intel.com>

Use the new "cxl_test.hmem_test" and "cxl_test.fail_autoassemble"
module options to implement a new cxl-dax-hmem.sh test. The test
checks dax_hmem takeover of Soft Reserve ranges that collide with
autoassembled CXL regions. It depends on the cxl_mock_mem driver
to launch multiple async probes before the dax_hmem driver attaches.

[as: do_skip on missing params, explicit param usage, robust unload,
check_dmesg, misc style]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Add delay (cxl-list) between modprobe and dax lookup
  In testing sometimes a daxctl right after modprobe fails to find
  the devices.

 test/cxl-dax-hmem.sh | 68 ++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build     |  2 ++
 2 files changed, 70 insertions(+)
 create mode 100755 test/cxl-dax-hmem.sh

diff --git a/test/cxl-dax-hmem.sh b/test/cxl-dax-hmem.sh
new file mode 100755
index 000000000000..6f4ed5076870
--- /dev/null
+++ b/test/cxl-dax-hmem.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation
+
+. $(dirname $0)/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modinfo cxl_test | grep -q '^parm:.*hmem_test' || \
+	do_skip "cxl_test hmem_test module param not available"
+
+modinfo cxl_test | grep -q '^parm:.*fail_autoassemble' || \
+	do_skip "cxl_test fail_autoassemble module param not available"
+
+rc=1
+
+unload()
+{
+	modprobe -r dax_cxl 2>/dev/null || true
+	modprobe -r dax_hmem 2>/dev/null || true
+	modprobe -r cxl_mock_mem 2>/dev/null || true
+	modprobe -r cxl_test 2>/dev/null || true
+}
+
+find_dax_cxl()
+{
+	$DAXCTL list -R | jq -r \
+		'.[] | select(.path | contains("cxl_acpi.0")) | .path'
+}
+
+find_dax_hmem()
+{
+	$DAXCTL list -R | jq -r \
+		'.[] | select(.path | contains("hmem_platform.1")) | .path'
+}
+
+unload
+
+# Verify CXL autoassembly claims the Soft Reserve range before dax_hmem
+modprobe cxl_mock_mem
+modprobe cxl_test hmem_test=1
+$CXL list
+
+dax=$(find_dax_cxl)
+[[ -z "$dax" ]] && err $LINENO
+dax=$(find_dax_hmem)
+[[ -n "$dax" ]] && err $LINENO
+
+unload
+
+# Verify dax_hmem claims the Soft Reserve range when CXL autoassembly fails
+modprobe cxl_mock_mem
+modprobe cxl_test hmem_test=1 fail_autoassemble=1
+$CXL list
+
+dax=$(find_dax_cxl)
+[[ -n "$dax" ]] && err $LINENO
+dax=$(find_dax_hmem)
+[[ -z "$dax" ]] && err $LINENO
+
+unload
+check_dmesg "$LINENO"
diff --git a/test/meson.build b/test/meson.build
index 593edf552b36..4260a3fa4448 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -169,6 +169,7 @@ cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
+cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -203,6 +204,7 @@ tests = [
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
   [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
+  [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3


