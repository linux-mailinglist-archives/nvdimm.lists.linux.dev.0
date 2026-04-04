Return-Path: <nvdimm+bounces-13811-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YM1yFLxq0Gnf7QYAu9opvQ
	(envelope-from <nvdimm+bounces-13811-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 04 Apr 2026 03:34:52 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AAE13997B1
	for <lists+linux-nvdimm@lfdr.de>; Sat, 04 Apr 2026 03:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A00BA300AC9F
	for <lists+linux-nvdimm@lfdr.de>; Sat,  4 Apr 2026 01:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E3D2571DD;
	Sat,  4 Apr 2026 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pz/Op23U"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E15A27E056
	for <nvdimm@lists.linux.dev>; Sat,  4 Apr 2026 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775266490; cv=none; b=eswou8Hy94QXwdkOjD8WU2wVw50S823OfI3JDpso4014lBeeDaG52KwaKAE/HIiOjFFJNXIxJwC0axzeWhqLrz5Fie02E7eMAvIMoJJFgqgoRPOR3Jd2STm54+uL1k/PruI1YPk09KZ800RRz0RVJLtcMxCIio82l9ZvdtRVPlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775266490; c=relaxed/simple;
	bh=AV1+oxpmkinSQydB2GIrzZVXZNne72Z+pOQxnEkD5zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1RC271NqoqMyfEGFw2MznOsU/ZtIxeATtmJMrhbgObtXEVtt1zIoDoCVd/IOsf/znZuNMsPeagknMp/gS31hedjnjYxlpltRaT6ZfaFhEF+a6MgXOAcRsop8Z46YNaQlyZ8oYCMlk/Eoq+Ep1gu+AhO1dHfqypEF17o7iyc7qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pz/Op23U; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775266489; x=1806802489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AV1+oxpmkinSQydB2GIrzZVXZNne72Z+pOQxnEkD5zc=;
  b=Pz/Op23UKSZXSH7gdrvpvx+EgZf/0SFJaPlbWNDwIKxzXGwedwZQJqCh
   JtjsLtQEpOzEXChsxW3IVdWXKHqcKxAGSo97EwM6cWjZOYYeydWDrHIJL
   4lz0xSFGwhCoR9kNzZmFk/m9OuJQeRZlKh3MrZNxuxhcyaX6cQaxhqDaT
   LeFk/Tf/3wp0I8a4GNH7XTjpanuRVdRNqKd+JAJKhwGzraXKzlu4oYEkX
   6AmJzUY1SLT7b5O/mcsNcehDlMcy7RK2WJUeVZs3+a8ChwYyhos7uleQV
   4Jy1gKOFkFbwteXzggL2LaflzA/0vSqBKWuZZIdWRa+OoWK7YJz6wOxMp
   Q==;
X-CSE-ConnectionGUID: npiI9/5IRkSodoraE/Udlw==
X-CSE-MsgGUID: feinavszR7CbjlVX8DL5wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76218260"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76218260"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:34:48 -0700
X-CSE-ConnectionGUID: Nqcirm13T3+FpHCBJ4hZCQ==
X-CSE-MsgGUID: mozuRCC/Tv22r6/2IX4QIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="257856891"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.12])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:34:49 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 3/3] test/cxl-destroy-region.sh: test out-of-order destroy-region handling
Date: Fri,  3 Apr 2026 18:34:41 -0700
Message-ID: <5d924ca777e265a2faaf21d67a1649c3c0d44277.1775265383.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <c2eccb9b0e596820940bfc7ec839ff807f3ac613.1775265383.git.alison.schofield@intel.com>
References: <c2eccb9b0e596820940bfc7ec839ff807f3ac613.1775265383.git.alison.schofield@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13811-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alison.schofield@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Queue-Id: 3AAE13997B1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

A recent change to 'cxl destroy-region' implementation ensures that
an out of order destroy failure leaves the region intact.

Test an out-of-order destroy attempt followed by in-order destroy
success.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-destroy-region.sh | 79 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
index f03aa67e8b0d..5c3395e530b0 100644
--- a/test/cxl-destroy-region.sh
+++ b/test/cxl-destroy-region.sh
@@ -32,6 +32,29 @@ destroy_regions()
 	fi
 }
 
+create_region()
+{
+	local decoder="$1"
+	local memdev="$2"
+	local size="$3"
+	local region
+
+	if [[ -n "$size" ]]; then
+		region=$("$CXL" create-region -d "$decoder" -m "$memdev" -s "$size" |
+			 jq -r ".region")
+	else
+		region=$("$CXL" create-region -d "$decoder" -m "$memdev" |
+			 jq -r ".region")
+	fi
+
+	if [[ -z "$region" || "$region" == "null" ]]; then
+		echo "create-region failed for decoder=$decoder memdev=$memdev"
+		err "$LINENO"
+	fi
+
+	echo "$region"
+}
+
 check_destroy_ram()
 {
 	mem=$1
@@ -67,6 +90,51 @@ check_destroy_devdax()
 	"$CXL" destroy-region "$region"
 }
 
+find_pmem_decoder()
+{
+	local mem="$1"
+	local slice="$2"
+	local decoder
+
+	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
+		jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 1) |
+		select(.max_available_extent >= $(( slice * 2 ))) |
+		.decoder" | head -n1)
+
+	[[ -z $decoder || $decoder == "null" ]] && return 1
+	echo "$decoder"
+}
+
+check_destroy_subregion_order()
+{
+	local mem="$1"
+	local slice=$((256 << 20))
+	local decoder
+	local region0=""
+	local region1=""
+
+	decoder=$(find_pmem_decoder "$mem" "$slice") || return 1
+
+	region0=$(create_region "$decoder" "$mem" "$slice")
+	region1=$(create_region "$decoder" "$mem" "$slice")
+
+	# wrong destroy order should fail
+	destroy_regions "$region0" && err "$LINENO"
+
+	# region0 should still be enabled
+	"$CXL" list -r "$region0" | jq -e 'length > 0' > /dev/null || err "$LINENO"
+
+	# regions should tear down cleanly in correct order
+	destroy_regions "$region1" || err "$LINENO"
+	"$CXL" list -r "$region1" | jq -e 'length == 0' > /dev/null || err "$LINENO"
+	destroy_regions "$region0" || err "$LINENO"
+	"$CXL" list -r "$region0" | jq -e 'length == 0' > /dev/null || err "$LINENO"
+
+	return 0
+}
+
 # Get clean slate, including auto region resources
 destroy_regions
 assert_no_regions
@@ -96,6 +164,17 @@ for mem in "${mems[@]}"; do
 done
 [[ $found -eq 1 ]] || err "$LINENO"
 
+# test wrong-order destroy on back-to-back pmem regions
+destroy_regions
+found=0
+for mem in "${mems[@]}"; do
+	if check_destroy_subregion_order "$mem"; then
+		found=1
+		break
+	fi
+done
+[[ $found -eq 1 ]] || err "$LINENO"
+
 check_dmesg "$LINENO"
 
 modprobe -r cxl_test
-- 
2.37.3


