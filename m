Return-Path: <nvdimm+bounces-14271-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGWLFYuFHmqhkQkAu9opvQ
	(envelope-from <nvdimm+bounces-14271-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 09:26:03 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 125A7629A82
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 09:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 28A503014ABD
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Jun 2026 07:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512AA369D72;
	Tue,  2 Jun 2026 07:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="12adhDAQ"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE917357D00
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384918; cv=none; b=a8aCIm+XC+MOGzIAQQo8SPpxYV4tqhEumrNZCbfI9Ukl8/xdnV0jJJ4TKrlmQBddF8AxLhvgGMZEggVtdnGWjV9iy69PgeTvZSHkz6WHdJEpmdIZX3GiEdUw4dmRy+0hTtUr3QOK90UCpE3Qi1ta+oGZNSILE0/2cgkNynmAF3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384918; c=relaxed/simple;
	bh=6tHY8J5FZLwsZSvp67K8n1Zpn1BPM8ttSTjEaithh3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaZrbP5eFIvZoN/MN6YmQqTatJp80gmEDHAuxx4DlgdKKnpkKq4Fkq2oUpJt2CiQU0bkyx/E/FB72tDztNd7CAchTaqISiDWy3PMQzSs/zTPX0EhRB4de9TIxVAsQCkBR1cGKsz0tgXOXBZTPTKsNhr1Z8Jjb5S+Os2Da596S7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=12adhDAQ; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 3D789D0F60;
	Tue, 02 Jun 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384410;
	bh=q9nFC7Z6g0jTQPCQtPDnRmGJV7FHjg8u5lzjUyjo/pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12adhDAQBMv06fSZOopwItXmo4Lw/7ockRyACsAaB6poBkYNvma5vTCgI3NHqHYqp
	 w9lZXhbKznr/Jmm93wlarHH2wV6ETfxx4kcHGyPoR9qy70NeKpuYsWdZLgefIB/urd
	 QZnTi9X04U9hZ5ji9cB+bqbylG8MPEQ36EXRI3gA=
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
Subject: [PATCH v5 1/4] nvdimm: Convert nvdimm_bus guard to class
Date: Tue,  2 Jun 2026 07:12:50 +0000
Message-ID: <8c0417904d280896ecf2e9923ffa9f20076f59b8.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14271-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[d@ilvokhin.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ilvokhin.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 125A7629A82
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The nvdimm_bus guard accepts NULL and skips locking when NULL is passed.
Convert from DEFINE_GUARD() to DEFINE_CLASS() + DEFINE_CLASS_IS_GUARD().

This is a preparatory change for making DEFINE_GUARD() constructors
__nonnull_args(). nvdimm_bus legitimately passes NULL, so it must be
adjusted to avoid a compile error.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..18b64559664b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -632,8 +632,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
-DEFINE_GUARD(nvdimm_bus, struct device *,
-	     if (_T) nvdimm_bus_lock(_T), if (_T) nvdimm_bus_unlock(_T));
+DEFINE_CLASS(nvdimm_bus, struct device *,
+	     if (_T) nvdimm_bus_unlock(_T),
+	     ({ if (_T) nvdimm_bus_lock(_T); _T; }),
+	     struct device *_T);
+DEFINE_CLASS_IS_GUARD(nvdimm_bus);
 
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
-- 
2.53.0-Meta


