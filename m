Return-Path: <nvdimm+bounces-13024-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 3Dr3BWzkg2mFvQMAu9opvQ
	(envelope-from <nvdimm+bounces-13024-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 05 Feb 2026 01:29:32 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 661A2ED6EF
	for <lists+linux-nvdimm@lfdr.de>; Thu, 05 Feb 2026 01:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC2143010B87
	for <lists+linux-nvdimm@lfdr.de>; Thu,  5 Feb 2026 00:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B341D5CFB;
	Thu,  5 Feb 2026 00:29:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B47315B971;
	Thu,  5 Feb 2026 00:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770251366; cv=none; b=Of0YhAR9qw9Pmacz1oK48tL53ORFsLuhByGd7x5mPk2u48K4IIsaYGHbKXZAPKGyO3SatWCeWLsN2lqZtpAanUDZHGJ5lCms/w9O+BmXH1/bgu2DtnRoi9rY8JBROoY3Pc8Zl5AFzjrXkCMrGqHyRuCs7uGW55ewKUQxPiQLB+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770251366; c=relaxed/simple;
	bh=UDX6EEi/qrHbX7RN/OrmQnxI0r4DgGOvtltmqIAvk7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1B54GkvKU+0oRM0lCNTfciNVuo2ti5QYvvyDNmsmqUCSJ7yX+1lKGzD0QI9v949ynu3P/4D56OQ7uRehJlFRNRJJv7yr2SFMpXo+O7+Ch4Y9DnNNiwcwvisJOt7ClKCS3iReGS9eIwnbhbgmoNkONTZuctqiAYXyXNF3p8p+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3C7C4CEF7;
	Thu,  5 Feb 2026 00:29:25 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH] cxl: Add support for updated CXL provider name
Date: Wed,  4 Feb 2026 17:29:24 -0700
Message-ID: <20260205002924.1831038-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[intel.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13024-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:email]
X-Rspamd-Queue-Id: 661A2ED6EF
X-Rspamd-Action: no action

With a 7.1 kernel, the CXL provider name is changed due to removal of the
nvdimm_bus_register() wrapper function in cxl_test. This impacts the
security unit tests. Update to address the change.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/common       | 6 ++++++
 test/cxl-security | 6 +++---
 test/security.sh  | 2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/test/common b/test/common
index 2d076402ef7c..f9d180ac5bd3 100644
--- a/test/common
+++ b/test/common
@@ -156,3 +156,9 @@ check_dmesg()
 
 # CXL COMMON
 CXL_TEST_QOS_CLASS=42
+
+if check_min_kver "7.1"; then
+	CXL_TEST_PROVIDER="cxl_acpi.0"
+else
+	CXL_TEST_PROVIDER="cxl_test"
+fi
diff --git a/test/cxl-security b/test/cxl-security
index 9a28ffd82b0b..11301fbc5f1b 100644
--- a/test/cxl-security
+++ b/test/cxl-security
@@ -3,9 +3,9 @@
 
 detect()
 {
-	dev="$($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r 'sort_by(.id) | .[0].dev')"
+	dev="$($NDCTL list -b "$CXL_TEST_PROVIDER" -D | jq -r 'sort_by(.id) | .[0].dev')"
 	[ -n "$dev" ] || err "$LINENO"
-	id="$($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r 'sort_by(.id) | .[0].id')"
+	id="$($NDCTL list -b "$CXL_TEST_PROVIDER" -D | jq -r 'sort_by(.id) | .[0].id')"
 	[ -n "$id" ] || err "$LINENO"
 }
 
@@ -20,7 +20,7 @@ lock_dimm()
 	test -e "$bus_provider_path" || err "$LINENO"
 	bus_provider=$(cat ${bus_provider_path})
 
-	[[ "$bus_provider" == "$CXL_TEST_BUS" ]] || err "$LINENO"
+	[[ "$bus_provider" == "$CXL_TEST_PROVIDER" ]] || err "$LINENO"
 	bus="cxl"
 	nmem_provider_path="/sys/bus/nd/devices/${dev}/${bus}/provider"
 	nmem_provider=$(cat ${nmem_provider_path})
diff --git a/test/security.sh b/test/security.sh
index d3a840c23276..ee27df215edd 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -212,7 +212,7 @@ if [ "$1" = "nfit" ]; then
 	KMOD_TEST="nfit_test"
 elif [ "$1" = "cxl" ]; then
 	. $(dirname $0)/cxl-security
-	TEST_BUS="$CXL_TEST_BUS"
+	TEST_BUS="$CXL_TEST_PROVIDER"
 	check_min_kver "6.2" || do_skip "may lack security handling"
 	KMOD_TEST="cxl_test"
 else

base-commit: 39085f76b6a9d3ac349c3c5dab1cb820c86a293d
-- 
2.52.0


