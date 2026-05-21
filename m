Return-Path: <nvdimm+bounces-14086-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qN6lI96xDmosBQYAu9opvQ
	(envelope-from <nvdimm+bounces-14086-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 May 2026 09:18:54 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D4759FFE9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 May 2026 09:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2C4C73040C59
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 May 2026 07:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625F839A4C5;
	Thu, 21 May 2026 07:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="QDgkMVRC"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5F83955CD
	for <nvdimm@lists.linux.dev>; Thu, 21 May 2026 07:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347905; cv=none; b=JSdMde8VAGBk/QqTOECRPul9oBUmPCCgbrqv0eDh1FGQucUkS6G0qIQIfMF8pmWxYwCnLalSwwDPHjxQVS9zityLxxg0ctoKJHMs+xBCNhjmGeG9GuskZZL1dEpYBqaC1+wwylw0DI+ibTL5HqWzsXmkU3ga4wuExqFI7Yxc/mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347905; c=relaxed/simple;
	bh=U46C/BpM2vEnvjIIsJtWek75An3X80SCFk7DqgK5MC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOrfWUjU26nlVmxM+t4evb2dZhRVQvoafJsTdoHOAIAAbgyDnygEJpfkYdMc7dre98HRuDCIX5q55/GZogvcqFQo6rx2Lt17ZIDq0uCe8PAekCOy19crqnb5lNlTmAAzGOJFoZFYuz9grW9zdqtLghvB4XA5s41hpJHqhRC/MDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=QDgkMVRC; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 99B23D0933;
	Thu, 21 May 2026 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347901;
	bh=H0ERgf6l48k7n+RO+vxMZwZ2/ZJGp5WzvOOMr4YqH/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDgkMVRC6D/FPdZ5WacGD82YKZlOl29ltsen1a2bEaz+6Ll9g1Sos7hVApnDdCCg8
	 SyASYXwzIEunoEHTG+aOlGAEee0EXIDdnPQQM/OejdZ7z5I2e9QmfvI0kyCVyCHeBB
	 l7KLHqPTrAcIosRjOtUm0GtePnWbPgIeAreHbj0g=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 4/4] cleanup: Remove NULL check from unconditional guards
Date: Thu, 21 May 2026 07:18:04 +0000
Message-ID: <b9080cd6d4e9f8e9529a74cf8922f6f54bdd2145.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ilvokhin.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14086-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[d@ilvokhin.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ilvokhin.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 06D4759FFE9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The unconditional guard destructors check whether the lock pointer is
NULL before unlocking. This check is dead code because unconditional
guards guarantee a non-NULL lock pointer at destructor time.

DEFINE_GUARD() runs the lock operation unconditionally in the
constructor. If the pointer were NULL, the lock operation (e.g.
mutex_lock(NULL)) would crash before the constructor returns. The
destructor never runs with a NULL pointer. All DEFINE_GUARD() users
dereference the pointer in their lock. Verified by auditing every
instance found by: git grep -n -A 1 'DEFINE_GUARD('. The only exception
is xe_pm_runtime_release_only, whose constructor is a noop, but it has
no callers.

__DEFINE_UNLOCK_GUARD() has only a few usages outside of
include/linux/cleanup.h: tty_port_tty (NULL-checks in its tty_kref_put()
call), irqdesc_lock (fixed earlier) and two guards in
kernel/sched/sched.h (dereference the pointer unconditionally in their
lock constructors).

DEFINE_LOCK_GUARD_1() sets .lock from its argument and runs the lock
operation in the constructor. Same reasoning applies. All
DEFINE_LOCK_GUARD_1() users dereference the pointer in their lock. Also,
verified by auditing every match of: git grep -n 'DEFINE_LOCK_GUARD_1('.

DEFINE_LOCK_GUARD_0() hardcodes .lock = (void *)1 in the constructor,
so it is never NULL by construction.

Conditional (_try) variants: DEFINE_GUARD_COND() and
DEFINE_LOCK_GUARD_1_COND() use EXTEND_CLASS_COND(), whose wrapper
destructor returns early when the lock was not acquired, before reaching
the base destructor since commit 2deccd5c862a ("cleanup: Optimize
guards"):

    if (_cond) return; class_##_name##_destructor(_T);

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 8f8d588b5595..1f6d1a97617a 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -398,7 +398,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
-	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
 #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
@@ -492,7 +492,7 @@ typedef struct {							\
 static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 	__no_context_analysis						\
 {									\
-	if (_T->lock) { _unlock; }					\
+	_unlock;							\
 }									\
 									\
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
-- 
2.53.0-Meta


