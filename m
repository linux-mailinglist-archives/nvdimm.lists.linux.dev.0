Return-Path: <nvdimm+bounces-13575-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMNRKAiFr2lvaAIAu9opvQ
	(envelope-from <nvdimm+bounces-13575-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Mar 2026 03:42:16 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BBF22444A8
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Mar 2026 03:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85C66304EF74
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Mar 2026 02:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8CA3A9629;
	Tue, 10 Mar 2026 02:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DLJeqp5v"
X-Original-To: nvdimm@lists.linux.dev
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A763A785F
	for <nvdimm@lists.linux.dev>; Tue, 10 Mar 2026 02:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773110497; cv=none; b=CF3uHAsBT/R7xNcIHrdJ6S1WURmgRmVeXMOYc33pmTknLbMQUA9CY6q6f91qKhO3JOyi3ZrwffdxTjLIh0HRGbnmqTvvOGGQ1RZYbDPZtG4A975DASxIjvErurMXaIVZtfRtp7Jk/lNYZbJ9mor/NMcixKbQkmVaJG75eAeI8bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773110497; c=relaxed/simple;
	bh=UDCqHsO0bvzEg/LOF8GOb2oCSs2kkC8LVW9VWP5NtVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjZe4FHXO0wJvQzkaH0NjMvmKKqoeXh8JegpY7SP3GQVAHWCBnaeyrMXLUOtJDcy29yuVL/NjjzbOtQoTD0MQIl3+AI284cee70fPLuqdiSnx5zZmneKyfQ+k1XwRF72cJ9ol8EHLK/EE5yGtZPwZGWb7kfw4l+5caetx+qB8No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DLJeqp5v; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773110493; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=h7qbBvFJ3FiiQqx/jHT7Plqms1SRMB6Kj1f8rjsskFI=;
	b=DLJeqp5vWU6vfd+N/9PWlZGiCKkPb7l9su4icn9mePFBPClzOCyKH21vBrxlfn0KAgtnJ2wO4UOwYvm+5BvpVUVSPCk62J5JiNcTLrkaMObO64XdGqYsvwSmGPsrCQd10I2uV3LICYGUq7vyY/WOpcxFGb3uIcZ+GyxZ6FWzotY=
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X-eASE7_1773110492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Mar 2026 10:41:33 +0800
From: cp0613@linux.alibaba.com
To: ishal.l.verma@intel.com,
	alison.schofield@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH 2/2] ndctl/test: Fix meson configuration error when fwctl is disabled
Date: Tue, 10 Mar 2026 10:41:02 +0800
Message-ID: <20260310024102.25682-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310024102.25682-1-cp0613@linux.alibaba.com>
References: <20260310024102.25682-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BBF22444A8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13575-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[cp0613@linux.alibaba.com,nvdimm@lists.linux.dev]
X-Rspamd-Action: no action

From: Chen Pei <cp0613@linux.alibaba.com>

The meson.build script unconditionally references the fwctl
executable in the depends list of test definitions. However,
fwctl is only defined when the fwctl build option is enabled.
This causes a meson configuration error:

  test/meson.build:283:6: ERROR: Unknown variable "fwctl".

when building with -Dfwctl=disabled.

This patch fixes the issue by moving the test dependencies
into a conditional list (tests_deps) that includes fwctl only
when the option is enabled, ensuring all referenced variables
are properly defined during meson configuration.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 test/meson.build | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/test/meson.build b/test/meson.build
index 615376e..a4e3805 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -267,22 +267,27 @@ test_env = [
     'DATA_PATH=@0@'.format(meson.current_source_dir()),
 ]
 
+tests_deps = [
+  ndctl_tool,
+  daxctl_tool,
+  cxl_tool,
+  smart_notify,
+  list_smart_dimm,
+  dax_pmd,
+  dax_errors,
+  daxdev_errors,
+  dax_dev,
+  mmap,
+]
+
+if get_option('fwctl').enabled()
+  tests_deps += [fwctl]
+endif
+
 foreach t : tests
   test(t[0], t[1],
     is_parallel : false,
-    depends : [
-      ndctl_tool,
-      daxctl_tool,
-      cxl_tool,
-      smart_notify,
-      list_smart_dimm,
-      dax_pmd,
-      dax_errors,
-      daxdev_errors,
-      dax_dev,
-      fwctl,
-      mmap,
-    ],
+    depends : tests_deps,
     suite: t[2],
     timeout : 600,
     env : test_env,
-- 
2.43.0


