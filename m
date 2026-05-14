Return-Path: <nvdimm+bounces-14018-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AWLF55sBWo+WwIAu9opvQ
	(envelope-from <nvdimm+bounces-14018-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 May 2026 08:33:02 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDE753E5B3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 May 2026 08:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 64891303F718
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 May 2026 06:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85A13C5DCD;
	Thu, 14 May 2026 06:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HwYPgNC9"
X-Original-To: nvdimm@lists.linux.dev
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED03AF657
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 06:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778740374; cv=none; b=qkHqLQ1P1AZMFJzPzg8WD8qy/oKPu/7XBEOWgWbF29cttM4B/jtAiFJcN9hyn0jqUn13MndHEZmK2zgzdmT6iTuEqdGmT+1P8RQmpRUSA8fSZqiYV0L86WDNegvIY4kobsjlW0ljXP+Q6EuLrzKxESnCtgvWmvODx2PQ0QUYbYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778740374; c=relaxed/simple;
	bh=oI5IO/JuIxpfhFofjSyTFYBneEIInV4rnJHaccXPSIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJIfcVv85lMGLIa/Nc/L/YXrZrysw82DhM6XLK9PUIn1KR0lugl5FTHdI5GrX1r0jGUQCJR8ibganjNyZ0AScpSriadL6PJvKbBlKURBm/zhdmOyp8fNjzWszrGzx6/t4D5Knb+Gz5vMx8bDI3oMigZU1Gye1h16zhBDs3BsVVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HwYPgNC9; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778740364; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=lMFH9YyVY9ENe/P49TfIR1IEA6wDe12nL5kppRzigNI=;
	b=HwYPgNC9cvM/Lo/QkMExTYk/lUqqk7Ub0Jyd0BXMVvoaN1TPdIq3IwA15oGJE9DHNk9eEXZwoz2/tMnFRzCvwi3xaTyzFWkps/fX16XdMRrLLFdDFh+h1P7GPKU1g5TO7yzWg6v4lRGtFMIjQH5fRbijDKFqHwfc6a/JaS56S+I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X2vwT8Y_1778740362;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X2vwT8Y_1778740362 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 14:32:43 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	guoren@kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert when driver is builtin or live
Date: Thu, 14 May 2026 14:32:34 +0800
Message-ID: <20260514063234.86439-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514063234.86439-1-cp0613@linux.alibaba.com>
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCDE753E5B3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14018-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cp0613@linux.alibaba.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,alibaba.com:email]
X-Rspamd-Action: no action

kmod_module_probe_insert_module() is supposed to return 0 for builtin
modules, but only when libkmod can locate the modules.builtin index. If
the index is missing or out of sync, libkmod falls through to the real
init_module() syscall and returns an error such as -ENOENT, producing a
spurious "insert failure" even though the driver is already part of the
running kernel.

Pre-check kmod_module_get_initstate() and short-circuit when the module
is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE, matching the pattern used by
ndctl's own test/core.c.

For builtin modules the local kmod reference is dropped because builtin
drivers cannot be unloaded; for live modules the reference is retained
in dev->module, matching the post-probe-success behavior.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 daxctl/lib/libdaxctl.c | 18 ++++++++++++++++--
 util/sysfs.c           | 17 +++++++++++------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index ffc81eb..42bfc39 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -910,7 +910,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
 	struct kmod_module *kmod;
-	int rc;
+	int state, rc;
 
 	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
 	if (rc < 0) {
@@ -919,7 +919,21 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 		return rc;
 	}
 
-	/* if the driver is builtin, this Just Works */
+	/* If the driver is builtin or already live, skip probe-insert. */
+	state = kmod_module_get_initstate(kmod);
+	if (state == KMOD_MODULE_BUILTIN) {
+		dbg(ctx, "%s: module %s is builtin\n", devname,
+			kmod_module_get_name(kmod));
+		kmod_module_unref(kmod);
+		return 0;
+	}
+	if (state == KMOD_MODULE_LIVE) {
+		dbg(ctx, "%s: module %s already loaded\n", devname,
+			kmod_module_get_name(kmod));
+		dev->module = kmod;
+		return 0;
+	}
+
 	dbg(ctx, "%s inserting module: %s\n", devname,
 		kmod_module_get_name(kmod));
 	rc = kmod_module_probe_insert_module(kmod,
diff --git a/util/sysfs.c b/util/sysfs.c
index e027e38..641b86d 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -183,12 +183,17 @@ int __util_bind(const char *devname, struct kmod_module *module,
 	}
 
 	if (module) {
-		rc = kmod_module_probe_insert_module(module,
-						     KMOD_PROBE_APPLY_BLACKLIST,
-						     NULL, NULL, NULL, NULL);
-		if (rc < 0) {
-			log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
-			return rc;
+		/* Skip probe-insert when the module is already builtin or live. */
+		int state = kmod_module_get_initstate(module);
+
+		if (state != KMOD_MODULE_BUILTIN && state != KMOD_MODULE_LIVE) {
+			rc = kmod_module_probe_insert_module(module,
+							     KMOD_PROBE_APPLY_BLACKLIST,
+							     NULL, NULL, NULL, NULL);
+			if (rc < 0) {
+				log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
+				return rc;
+			}
 		}
 	}
 
-- 
2.43.0


