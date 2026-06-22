Return-Path: <nvdimm+bounces-14480-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id T+3qFaDwOGpokQcAu9opvQ
	(envelope-from <nvdimm+bounces-14480-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 Jun 2026 10:21:52 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A556ADA4C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 Jun 2026 10:21:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=proton.me header.s=protonmail header.b=b8ZS3oGP;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14480-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14480-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=proton.me;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D8483005649
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 Jun 2026 08:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05AE138F621;
	Mon, 22 Jun 2026 08:14:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD95B39022B
	for <nvdimm@lists.linux.dev>; Mon, 22 Jun 2026 08:14:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782116053; cv=none; b=hCRPKrCpM1mYiBviPy/+iIeFRJx8BaRu3tzmNrkqa2/4KrHz5sbSsT19E8gu/uFcfLA7Lhi2GbDNlSZoMZPxcZ6Q3kxV3p4QvWh6ZLRxuUQlANhPhr7qBLeJOLSu1Mx264R3BiiknVMizAc2TD9V9wnJiZj2K0G/E8QGMIuttQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782116053; c=relaxed/simple;
	bh=OYVQalUnkD3lEzaWVjkXqi8tj1VuU8wwFGJH1p13e0g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKL9wOSHDmA14TgCh9Do6/ohTcCPXtVfB3AZmp5N90IUs223WKu4noJF/9ZGmyT6ADNSutUbIU5fHHX/gRlOmmAYpK3bpvQi8NFnBj82moYMIsAKZjY58V7mb4CqOTMYrzhN2c1TOyU0ioDsKkISASGeivbUN7fq2MioGH5vo8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=b8ZS3oGP; arc=none smtp.client-ip=79.135.106.119
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1782116046; x=1782375246;
	bh=OYVQalUnkD3lEzaWVjkXqi8tj1VuU8wwFGJH1p13e0g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=b8ZS3oGPVFIwzXNsxM6bxi1sA7NxsFIb72UsatETjq9HDi384zGi3Kqy/gqiUG27C
	 TG9yquvhc7ZI5TAh+8FJu2R3U4IpYCHRqCuuCKB0APCiGeD6wY87sI2wRAWBSe1cN0
	 rXvXUSqGZt546AK4hfwygLpeMMObVq/8SVK7zDLfFnpaunFgP2AUfXehPM0dDBRNcJ
	 2hA3d/itp8iK0En1+OppgmJfM6af0Bt/6kckq0OssMmR+7Mpy9rPrxdmg31Fb0AjT8
	 beGj8N2NiZuVMjQb0NbPWW6+4hzdlsJUrzuitxdmc6cIC+uUhFWqdyuqcMiwnpq2T9
	 FzR+2/UlTo0+g==
Date: Mon, 22 Jun 2026 08:14:00 +0000
To: David Laight <david.laight.linux@gmail.com>, Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
Message-ID: <20260622081353.57531-1-hexlabsecurity@proton.me>
In-Reply-To: <20260621112357.56a290bc@pumpkin>
References: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me> <20260621112357.56a290bc@pumpkin>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 8ebe181dc80e8fed1ded21af92df171cf348ee05
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[proton.me,quarantine];
	R_DKIM_ALLOW(-0.20)[proton.me:s=protonmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14480-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:david.laight.linux@gmail.com,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:davidlaightlinux@gmail.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,intel.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[hexlabsecurity@proton.me,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hexlabsecurity@proton.me,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[proton.me:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:from_smtp,proton.me:dkim,proton.me:mid,proton.me:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B5A556ADA4C

On 2026-06-21, David Laight wrote:
> Is this enough and/or a sane way to stop the overflow.

For the overflow, yes. In 64-bit the product no longer wraps, so the bound
rejects exactly the nslot values that don't fit config_size. Minimal change=
,
backports cleanly.

> AFAICT label_size is either 128 or 258.

128 or 256. nd_label_validate() probes label_size[] =3D { 128, 256 } (v1.1 =
/ v1.2)
and sets ndd->nslabel_size from that.

> But I can't see where nsarea.config_size is set.

A u32 filled by nvdimm_init_nsarea() from ND_CMD_GET_CONFIG_SIZE -- reporte=
d by
the dimm provider's ->ndctl (firmware/_DSM on NFIT), not a user ioctl. No s=
anity
cap today.

> The same could be done for nslot - any value above 64k is pretty much
> guaranteed to be garbage

Agreed. The largest legitimate nslot is config_size / label_size: a few hun=
dred
on a real ~128K area, ~1024 at most. The exact bound already ties nslot to
config_size; a ceiling still helps for the gap you point at: config_size is
firmware-reported and uncapped, so a bogus large config_size would otherwis=
e
admit a large nslot and kvzalloc.

I'd keep the (u64) cast as the targeted fix here (Fixes:/stable) and add th=
e
nslot and config_size bounds as a follow-up hardening patch, or fold them i=
nto a
v2 if you'd rather see them together. Either way I'll send it.

Bryam


