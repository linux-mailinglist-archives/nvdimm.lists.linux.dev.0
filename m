Return-Path: <nvdimm+bounces-14036-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id /yFDANUuC2qZEQUAu9opvQ
	(envelope-from <nvdimm+bounces-14036-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 May 2026 17:23:01 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC3756FD7C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 May 2026 17:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3109303281A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 May 2026 15:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F13378D8A;
	Mon, 18 May 2026 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="PNJ/Xjcr"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39312377EAF
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779117718; cv=none; b=CvLOlTnYGF7kZc5bwv1fOqaJwzYHuAJzDojm55+oPCnMKcIxdNrPVJ+siUhgNbs0nAc9ovHpRY3ps85BUaAc8BTf+P6sfWbsm4kqmIHlBNZHaZ1LCUuxOJ4FueZoMF4cYM88o7ntrshLNG/4A7gNwcZbn3QKPJK9+eZ1/9lNb8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779117718; c=relaxed/simple;
	bh=w+Q7t4o7qDFQ3ne6wKp5B+sEEsLg7p6ytok3TvOGmk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jB3mK8F0VlvQp1Ww7zX1umenEMztQeavDGfSWz4lwMuoNInzg0EDbcYFZjo3siIKAk4y3aknt0lEt0Dy3Nhrt30rCJdxoIaxk63Gg2asW26iW14rnUq+cdgKKezmRdozQaPYWu9Q2Gc5m3So0O9fdilxjFp9hyxiA1svGGLfr3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=PNJ/Xjcr; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D4F1CD073C;
	Mon, 18 May 2026 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779117709;
	bh=1KXWMoC0rvv795nBW4ClZKN1RA1WwowAzTWzTm/OEKQ=;
	h=From:To:Cc:Subject:Date;
	b=PNJ/Xjcrgic4qljVGaQMcy4tCG87uJdTjczeVllLWKBbUnkobpFoc17IHhohtHjau
	 Z6+pT0tcaGtzKfhmEco1wuzxOC6i6WueoKxjtb63cgDWNEt2PPclIKhbjum7RrpVM/
	 kEwIr38QLNw7/n0johyE6q6/tj4YYMHGPgHI4T+A=
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
Subject: [PATCH v3 0/4] cleanup: Remove NULL check from unconditional guards
Date: Mon, 18 May 2026 15:21:26 +0000
Message-ID: <cover.1779116497.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
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
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14036-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[d@ilvokhin.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ilvokhin.com:+];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 3FC3756FD7C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Unconditional guard destructors have dead NULL checks. The lock operation in
the constructor would crash before the destructor ever runs with NULL.

- Patches 1-2 prepare guards that legitimately handle NULL.
- Patch 3 adds __nonnull() to guard constructors for compile-time enforcement.
- Patch 4 removes the dead checks.

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Changes in v3:

- Audited usages of DEFINE_GUARD(), __DEFINE_UNLOCK_GUARD() and
  DEFINE_LOCK_GUARD_1() to make sure NULL check removal will work correctly
  (Peter Zijlstra).
- Moved NULL check into irqdesc_lock unlock expression (Peter Zijlstra).
- Added compiler-enforced nonnull() check for guard constructors.
- Converted nvdimm_bus guard to class.

Changes in v2:

- Expand commit message with detailed reasoning, why the proposed
  change is correct.
- Rebase on top of locking/core.

v2: https://lore.kernel.org/all/20260512071510.92451-1-d@ilvokhin.com/
v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

See also [1] for relevant discussion.

[1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/

Dmitry Ilvokhin (4):
  nvdimm: Convert nvdimm_bus guard to class
  genirq: Move NULL check into irqdesc_lock guard unlock expression
  cleanup: Annotate guard constructors with __nonnull()
  cleanup: Remove NULL check from unconditional guards

 drivers/nvdimm/nd.h                 | 7 +++++--
 include/linux/cleanup.h             | 8 +++++---
 include/linux/compiler_attributes.h | 6 ++++++
 kernel/irq/internals.h              | 2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.53.0-Meta


