Return-Path: <nvdimm+bounces-14283-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jZ8aC1ZAH2qwjAAAu9opvQ
	(envelope-from <nvdimm+bounces-14283-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 22:43:02 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 176F3631D5F
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 22:43:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvEOYDcA;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14283-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14283-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 94C843050884
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Jun 2026 20:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53EB2382286;
	Tue,  2 Jun 2026 20:37:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FC237EFE2;
	Tue,  2 Jun 2026 20:37:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432650; cv=none; b=VKdO9U+MtChbUmpEmXTUEDJQxbvpRm07uR0W3/SItE2uVeQamPL68Gpm739gZIreA/7bPeIxg1canQ8SQskfRnX91ztDwU19Mi1+r6IaPzHHQ/cPPbyDNvolJyv8fStSdwniQfUH9tFilebyIy2w2kjgZVQYtZw2CwAgXsbb21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432650; c=relaxed/simple;
	bh=pHwD0ZV1CEAMNsXx/yt+effMomSWCNvi3CFB34MYIdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rJZrYnzf1T0aTyXxywo5Mh+ft1vefIEmzpeHiZRolzBxb2LHZ5tsKj9+9XPW6GlHLjgYgMNkDuXphrVseU29F8tbphC5YgaL08pcQe0jtGWFx5eOCf0anZcDnIG75VVmINHpFUJ1pFR/OGYtWrNGFPbD7WruLAAABf9y08hexcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvEOYDcA; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0651F00898;
	Tue,  2 Jun 2026 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780432648;
	bh=pHwD0ZV1CEAMNsXx/yt+effMomSWCNvi3CFB34MYIdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jvEOYDcADvlGRRYIOLhBJ9fraq492rgPCR9NNwxrkm1WgOgwIS9DZZE6WO+OKQWOj
	 HgTONB8mKBSHVkLVQw9p4dZD1YvkZyfE4eP2vGawFp8cTMKgGZnaXrbPNHA7iXpvKO
	 tIi0EWxzVT/Joq8wQYV4JvHjV3SLdlVQJhH2cg6Pi/IJrwINyUyE4GZYgUjSmhYP0l
	 IqkPj0r/ajPzK1dweOETJ2+uo+G6GSjS6FTxMiUlcm7WRQHMJqmdlQw5PJIvezNu/A
	 QwEf1e/4pe17gdpl6AWUHoPAG2/FRk2AinFLrWnZEIWagdNAm/mc2rWPWAo2ls/ig3
	 dsJmE1RNbNm6Q==
From: Thomas Gleixner <tglx@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>, Peter Zijlstra <peterz@infradead.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Miguel
 Ojeda <ojeda@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco
 Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, Dmitry Ilvokhin <d@ilvokhin.com>
Subject: Re: [PATCH v5 2/4] genirq: Move NULL check into irqdesc_lock guard
 unlock expression
In-Reply-To: <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
Date: Tue, 02 Jun 2026 22:37:26 +0200
Message-ID: <87se747k6x.ffs@fw13>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:d@ilvokhin.com,m:peterz@infradead.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:ojeda@kernel.org,m:brauner@kernel.org,m:elver@google.com,m:hpa@zytor.com,m:akpm@linux-foundation.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-mm@kvack.org,m:kernel-team@meta.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[tglx@kernel.org,nvdimm@lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-14283-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fw13:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lists.linux.dev:from_smtp,ilvokhin.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 176F3631D5F

On Tue, Jun 02 2026 at 07:12, Dmitry Ilvokhin wrote:

> irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
> constructor that can set .lock to NULL.
>
> In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
> move the NULL check into the irqdesc_lock unlock expression, making the
> NULL handling explicit at the call site.
>
> No functional change.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Thomas Gleixner <tglx@kernel.org>

