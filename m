Return-Path: <nvdimm+bounces-14381-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9sdWLiT/KWppgwMAu9opvQ
	(envelope-from <nvdimm+bounces-14381-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 02:19:48 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CD266D7E3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 02:19:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=VFniniox;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14381-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14381-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3F523082585
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 00:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67ECA17A2E8;
	Thu, 11 Jun 2026 00:19:33 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6045135A53
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 00:19:31 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781137173; cv=none; b=C+lvX/XuL24FIFAOOk40z22utHkmC34Rt7pky3aHk6zqqeHhIET023cQ9Pl5DAzZ78/xCUy+g3Z4LOICOqxm2TY+SymMhVNFaY1PoalPmIdHVAGULiQAeA31OhRQSxmuDvpZ4mCppRthbyI9tIHsYSNEXdjkkgzHL6KeURwno0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781137173; c=relaxed/simple;
	bh=5NfHHB1XexcAuvs06yfjoDisyrtOqg5KcGCXrerRxYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM0LdrW5jfxx6eOSabHN7y0R9ltLgutiD0OZUKImoFDEdR43h/s7i9hocWaeyc8X+aZMLs86EN6pNvF5q9cX9wyF9DzFZPlndHXJakcRBbyTeRlruZHObravSUZiHLs2eLC4VIpdkiYdR70L/qTGXt0NGp3tPwUVKsj/Y5t0IXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFniniox; arc=none smtp.client-ip=192.198.163.15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781137171; x=1812673171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5NfHHB1XexcAuvs06yfjoDisyrtOqg5KcGCXrerRxYQ=;
  b=VFninioxnhktREByrEF89JaTFYKP110eEw2UJs4DzXIYkLViF7f34HBU
   AgqcTYc+dAgdRokCEa2eztC2OoYDA+OV+iZ3ZGtfXYJejfy/huJKUwaYd
   SYErfXUXtbhdkHyz8qXTAEKHINXsGcUFVSwEl6H0PE58AbjL65qKrYgCV
   4KaiJg9Nf6JRFJWqNJt85Dsvs4e5NSsGMVfgn5mfuybTlO7NN1DV3AeLE
   LvdSlT9gtyDAQo54+jVOt4VA1DjFTXEPgdxE60Ro98ScaK4GktPdzALLL
   tyFxAGtETLaQYiednaFs4hOayUDo8NxLLfULYCE9v8nnwhH7i0jKkbrtc
   Q==;
X-CSE-ConnectionGUID: XGh3fTy+T7mzPBhPYFW4kQ==
X-CSE-MsgGUID: Zs0TpRMFTWG/DaIc9gwPTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82054170"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="82054170"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 17:19:29 -0700
X-CSE-ConnectionGUID: fGIvWrbrRX6+7KvRVHi7OA==
X-CSE-MsgGUID: u6jQSadmQjWWMNYPINxjMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="242181822"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.46])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 17:19:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 2/3] test/cxl-create-region.sh: deduplicate decoder and memdev lookups
Date: Wed, 10 Jun 2026 17:19:20 -0700
Message-ID: <89bdbb621375f9dffb648b455d3d872ea7fc8f98.1781136221.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1781136221.git.alison.schofield@intel.com>
References: <cover.1781136221.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14381-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:alison.schofield@intel.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[alison.schofield@intel.com,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alison.schofield@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 52CD266D7E3

Several region setup helpers open-code the same decoder and memdev
lookups.

Factor the common queries into shared helpers. This reduces duplicate
logic and simplifies adding new region configuration tests.

No functional change.

Assisted-by: Claude:Opus-4-8
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-create-region.sh | 73 ++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 40 deletions(-)

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index d7a6840fed1a..5941e18f338d 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -25,17 +25,21 @@ destroy_regions()
 	fi
 }
 
+# Find the pmem capable single-target root decoder for a memdev
+find_x1_decoder()
+{
+	$CXL list -b cxl_test -D -d root -m "$1" |
+		  jq -r ".[] |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) |
+		  .decoder"
+}
+
 create_x1_region()
 {
 	mem="$1"
 
-	# find a pmem capable root decoder for this mem
-	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
-		  jq -r ".[] |
-		  select(.pmem_capable == true) |
-		  select(.nr_targets == 1) |
-		  .decoder")
-
+	decoder=$(find_x1_decoder "$mem")
 	if [[ ! $decoder ]]; then
 		echo "no suitable decoder found for $mem, skipping"
 		return
@@ -69,13 +73,7 @@ create_subregions()
 	slice=$((256 << 20))
 	mem="$1"
 
-	# find a pmem capable root decoder for this mem
-	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
-		  jq -r ".[] |
-		  select(.pmem_capable == true) |
-		  select(.nr_targets == 1) |
-		  .decoder")
-
+	decoder=$(find_x1_decoder "$mem")
 	if [[ ! $decoder ]]; then
 		echo "no suitable decoder found for $mem, skipping"
 		return
@@ -133,6 +131,17 @@ create_single()
 	destroy_regions "$region"
 }
 
+# Find the index'th memdev behind the decoder's target at position
+find_memdev()
+{
+	local decoder="$1" position="$2" index="$3"
+	local port_dev
+
+	port_dev=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == $position) | .target")
+	$CXL list -M -p "$port_dev" | jq -r ".[$index].memdev"
+}
+
 create_and_destroy_region()
 {
 	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
@@ -155,9 +164,7 @@ setup_x1()
 		.decoder")
 
 	# Find a memdev for this host-bridge
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
 	memdevs="$mem0"
 }
 
@@ -170,12 +177,8 @@ setup_x2()
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
 	memdevs="$mem0 $mem1"
 }
 
@@ -188,14 +191,10 @@ setup_x4()
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
-	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
+	mem2=$(find_memdev "$decoder" 0 1)
+	mem3=$(find_memdev "$decoder" 1 1)
 	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
@@ -213,15 +212,9 @@ setup_x3()
 	fi
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 2) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
+	mem2=$(find_memdev "$decoder" 2 0)
 	memdevs="$mem0 $mem1 $mem2"
 }
 
-- 
2.37.3


