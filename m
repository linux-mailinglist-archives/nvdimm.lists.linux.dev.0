Return-Path: <nvdimm+bounces-14457-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fGbbKoe1M2pVFQYAu9opvQ
	(envelope-from <nvdimm+bounces-14457-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Jun 2026 11:08:23 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A40269EBA9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Jun 2026 11:08:23 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TatVPEO9;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14457-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14457-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 389E530BEA82
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Jun 2026 09:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FA03B38AA;
	Thu, 18 Jun 2026 09:07:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B83A9D9A
	for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 09:07:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773629; cv=none; b=eyycsJD0QlCrM5NvTZJ5YTUMv6gCjdkhkF6E7BU2qGU6z+yGXu+kqjy8c60WivIM7waqrm9Olw6fueQF4iu/gkDkLVs0AN1SnS8bERbajyt0a4fzzULkNaKVpxNVmugPwHCNF8uIcNiFJWh1UoMrCuWrwoOQ8NMCJowaxkqww+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773629; c=relaxed/simple;
	bh=Xjlc1/XXG5N8sxnddDWptOciIioBBQME9BzZFlDz194=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxQKD6VHa480D9/iUAjAlL6Fbuo96Mh+nkHkgRUMT8i2r25/eZv8kw+IND63yepfhfaEfdSdeuPo1CROySd0zeKOeBtaJcLZKLYOvzd6+RL64mPLi6Mb6fjLb1qYNoTgXD8rpixEU5Cnp2sEvRHc6PUrld8YH9W+RVUuLvSEme8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TatVPEO9; arc=none smtp.client-ip=115.124.30.113
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781773623; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1PNSDl2IB0evv9eWpEea2oOgEMZ7BrwScg55wOaDnuI=;
	b=TatVPEO9aCDYaCYYQsYlOmYLjp4FbmD+uyvqOVffDSKch9e5Bj+gZDiGhj3vQ/ynLoqRrqhkAEcEAq49fej3yjLPIZZsktbRtTt1KRessgZxgjxtNJzOobGSOyTvbROX9/SWEyCNFWMo1nBawkvBEFgYGbbpYMf+RIiGVtAGSfg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X56RkmC_1781773622;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X56RkmC_1781773622 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:07:02 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	dave.jiang@intel.com,
	jic23@kernel.org,
	nvdimm@lists.linux.dev
Cc: guoren@kernel.org,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 2/2] daxctl, util/sysfs: skip module probe-insert when driver is builtin or live
Date: Thu, 18 Jun 2026 17:06:53 +0800
Message-ID: <20260618090653.8983-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260618090653.8983-1-cp0613@linux.alibaba.com>
References: <20260618090653.8983-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
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
	TAGGED_FROM(0.00)[bounces-14457-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[cp0613@linux.alibaba.com,nvdimm@lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:alison.schofield@intel.com,m:dave.jiang@intel.com,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:guoren@kernel.org,m:linux-cxl@vger.kernel.org,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cp0613@linux.alibaba.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,intel.com:email,linux.alibaba.com:dkim,linux.alibaba.com:mid,linux.alibaba.com:from_mime,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2A40269EBA9

kmod_module_probe_insert_module() is supposed to return 0 for builtin
modules, but only when libkmod can locate the modules.builtin index. If
the index is missing (e.g. a kernel built with the driver as builtin
but installed without running modules_install), libkmod falls through
to the real init_module() syscall and returns an error such as -ENOENT,
producing a spurious "insert failure" even though the driver is already
part of the running kernel.

Add a helper util_kmod_skip_probe_insert() that returns true when the
module state is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE. As an
additional heuristic, treat KMOD_MODULE_COMING as builtin when
/sys/module/<name>/ exists but the initstate file does not - this is
the exact pattern libkmod's sysfs fallback emits for builtin drivers
when the modules.builtin index is unavailable. The pattern mirrors the
KMOD_MODULE_LIVE / KMOD_MODULE_BUILTIN check already used by ndctl's
own test/core.c (see test/core.c:218-236).

The helper also returns the observed libkmod state via an out parameter
so daxctl_insert_kmod_for_mode() can distinguish LIVE (retain the kmod
reference in dev->module) from BUILTIN (drop it, since builtin drivers
cannot be unloaded) without re-reading /sys/module/<name>/initstate.
__util_bind() passes NULL since it does not need the state.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Suggested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 daxctl/lib/libdaxctl.c | 22 +++++++++++++++++++--
 util/sysfs.c           | 44 +++++++++++++++++++++++++++++++++++++++++-
 util/sysfs.h           | 16 +++++++++++++++
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 8c3ac47..5b47c77 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -958,7 +958,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
 	struct kmod_module *kmod;
-	int rc;
+	int state, rc;
 
 	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
 	if (rc < 0) {
@@ -967,7 +967,25 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 		return rc;
 	}
 
-	/* if the driver is builtin, this Just Works */
+	/*
+	 * If the driver is builtin or already live, skip probe-insert.
+	 * For live modules retain the local reference in dev->module so
+	 * the module can be unreffed alongside the device; for builtin
+	 * drivers drop it because builtin modules cannot be unloaded.
+	 */
+	if (util_kmod_skip_probe_insert(kmod, ctx, &state)) {
+		if (state == KMOD_MODULE_LIVE) {
+			dbg(ctx, "%s: module %s already loaded\n", devname,
+				kmod_module_get_name(kmod));
+			dev->module = kmod;
+		} else {
+			dbg(ctx, "%s: module %s is builtin\n", devname,
+				kmod_module_get_name(kmod));
+			kmod_module_unref(kmod);
+		}
+		return 0;
+	}
+
 	dbg(ctx, "%s inserting module: %s\n", devname,
 		kmod_module_get_name(kmod));
 	rc = kmod_module_probe_insert_module(kmod,
diff --git a/util/sysfs.c b/util/sysfs.c
index e027e38..eaf4b60 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -6,6 +6,7 @@
 #include <stdarg.h>
 #include <unistd.h>
 #include <errno.h>
+#include <limits.h>
 #include <string.h>
 #include <ctype.h>
 #include <fcntl.h>
@@ -168,6 +169,47 @@ struct kmod_module *__util_modalias_to_module(struct kmod_ctx *kmod_ctx,
 	return mod;
 }
 
+bool __util_kmod_skip_probe_insert(struct kmod_module *module,
+				   struct log_ctx *ctx, int *state_out)
+{
+	const char *name = kmod_module_get_name(module);
+	int state = kmod_module_get_initstate(module);
+	char path[PATH_MAX];
+	struct stat st;
+
+	if (state_out)
+		*state_out = state;
+
+	if (state == KMOD_MODULE_BUILTIN || state == KMOD_MODULE_LIVE)
+		return true;
+
+	/*
+	 * When modules.builtin is missing (e.g. a kernel installed
+	 * without modules_install), libkmod's sysfs fallback returns
+	 * KMOD_MODULE_COMING for builtin drivers because /sys/module/<name>/
+	 * exists but the initstate file does not. Treat that pattern as
+	 * builtin to avoid a spurious "insert failure" message.
+	 */
+	if (state != KMOD_MODULE_COMING)
+		return false;
+
+	if (snprintf(path, sizeof(path), "/sys/module/%s/initstate", name)
+			>= (int)sizeof(path))
+		return false;
+	if (stat(path, &st) == 0 || errno != ENOENT)
+		return false;
+
+	if (snprintf(path, sizeof(path), "/sys/module/%s", name)
+			>= (int)sizeof(path))
+		return false;
+	if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode))
+		return false;
+
+	log_dbg(ctx, "module %s appears builtin (no modules.builtin index)\n",
+			name);
+	return true;
+}
+
 int __util_bind(const char *devname, struct kmod_module *module,
 		const char *bus, struct log_ctx *ctx)
 {
@@ -182,7 +224,7 @@ int __util_bind(const char *devname, struct kmod_module *module,
 		return -EINVAL;
 	}
 
-	if (module) {
+	if (module && !__util_kmod_skip_probe_insert(module, ctx, NULL)) {
 		rc = kmod_module_probe_insert_module(module,
 						     KMOD_PROBE_APPLY_BLACKLIST,
 						     NULL, NULL, NULL, NULL);
diff --git a/util/sysfs.h b/util/sysfs.h
index 4c95c70..e4f6115 100644
--- a/util/sysfs.h
+++ b/util/sysfs.h
@@ -3,6 +3,7 @@
 #ifndef __UTIL_SYSFS_H__
 #define __UTIL_SYSFS_H__
 
+#include <stdbool.h>
 #include <string.h>
 
 typedef void *(*add_dev_fn)(void *parent, int id, const char *dev_path);
@@ -36,6 +37,21 @@ struct kmod_module *__util_modalias_to_module(struct kmod_ctx *kmod_ctx,
 #define util_modalias_to_module(ctx, buf)                                      \
 	__util_modalias_to_module((ctx)->kmod_ctx, buf, &(ctx)->ctx)
 
+/*
+ * __util_kmod_skip_probe_insert - true when kmod_module_probe_insert_module()
+ * should be skipped because @module is already part of the running kernel:
+ * KMOD_MODULE_BUILTIN, KMOD_MODULE_LIVE, or KMOD_MODULE_COMING with
+ * /sys/module/<name>/ existing but no initstate file (the fingerprint
+ * libkmod's sysfs fallback emits for builtin drivers when the
+ * modules.builtin index is missing). If @state_out is non-NULL, the
+ * libkmod state actually observed is stored there so callers can avoid
+ * an extra kmod_module_get_initstate() call.
+ */
+bool __util_kmod_skip_probe_insert(struct kmod_module *module,
+				   struct log_ctx *ctx, int *state_out);
+#define util_kmod_skip_probe_insert(m, c, s)                                   \
+	__util_kmod_skip_probe_insert((m), &(c)->ctx, (s))
+
 int __util_bind(const char *devname, struct kmod_module *module, const char *bus,
 	      struct log_ctx *ctx);
 #define util_bind(n, m, b, c) __util_bind(n, m, b, &(c)->ctx)
-- 
2.43.0


