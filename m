Return-Path: <nvdimm+bounces-14911-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id uOdFEpO4U2rteAMAu9opvQ
	(envelope-from <nvdimm+bounces-14911-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:53:55 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9238D745457
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:53:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7D+mCBM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14911-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14911-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 389AC3007CB4
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 15:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDB83264E4;
	Sun, 12 Jul 2026 15:53:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086F5CA52;
	Sun, 12 Jul 2026 15:53:49 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871631; cv=none; b=FLVaftAgYgwY6+D28woMzJw7cOL6jgi5yKa6ouzPTJVlWc3NL8PNJW52WGFm2H1bgM2WNrEGTAn7XWN7TVfqR3a/6r/tzIYPjvLOns9pFt5Pc9XfO3ExG96sRSXr2vE2k4OxSOD/d1Lv7UTIkUP6R6g3lELKONvOwb8Efq7w+kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871631; c=relaxed/simple;
	bh=3YKlkSqtPR60HZ1ETI8Z2FeZxdkBl55sDIpz+KD73Io=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tjjvtvDJrFmt8vVNkNLp83Z5X/7zxJL067DCMUUW2Qb7rwkRm25i4R0Zlpodyf4ub1I7MTLNwEm7K/JCQWjjc84zSFfQs0Rnm5ibjIL7Bvqu+Vl4clcnoApnqvmBWT0E15UIb5HGa9cVTDlDf7hsVAr8PW+es6mqT1/QPs7gZQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7D+mCBM; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7294D1F000E9;
	Sun, 12 Jul 2026 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783871629;
	bh=MM/tUPGZRj8cN6Q77HvuZ7j8DNJZh5gga6PTltZsMAs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M7D+mCBM+QMONsIJ+7m8caOij9polLlIdMU8WIawtecBQ4AaZyi/BXmq+XjXjXMby
	 SNh+qXn/nfqHw9akFF4nlGvoJ9n+LOByfpswca+AhDxHYutSfI3pCAeL59HTTDd5LP
	 hWm1DS6Dxl5K2Hhw+yG+Y+3Ynuv247/m43otExP2Uu1DEr0vdygAMpfzWaWqnQkiOO
	 pbun0vcFoyKoUx/nWK6BLlSzy7UCWX4TjxqoY+7VJJuz/oYWzwfUjoXC5067RqJ14i
	 beoRyvuR4Azwzof+Pg6aPrU96VlyCj7g27ceWVFEawk8tAYl2o3djyyUOBMNZDs0wf
	 6FBnTjP4xAoaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 03/10] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260712154505.3564379-4-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
 <20260712154505.3564379-4-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:53:49 +0000
Message-Id: <20260712155349.7294D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14911-lists,linux-nvdimm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:linux-cxl@vger.kernel.org,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:email,sashiko.dev:url,smtp.kernel.org:mid,lists.linux.dev:from_smtp,lists.linux.dev:replyto,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9238D745457

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incomplete refactoring introduces a TOCTOU race condition where `a=
dd_memory_resource` uses a stale snapshot of `online_type` but evaluates th=
e condition using the live `mhp_get_default_online_type()`.
--

--- Patch [3]: [PATCH v7 03/10] mm/memory_hotplug: pass online_type to onli=
ne_memory_block() via arg ---
commit 72fc58e4b65f508d5057e9fe2ec0ff1c08b34e61
Author: Gregory Price <gourry@gourry.net>

mm/memory_hotplug: pass online_type to online_memory_block() via arg

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab22632..6833208cc17cb 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid=
, struct memory_group *group,
>  int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  {
>  	struct mhp_params params =3D { .pgprot =3D pgprot_mhp(PAGE_KERNEL) };
> +	enum mmop online_type =3D mhp_get_default_online_type();
>  	enum memblock_flags memblock_flags =3D MEMBLOCK_NONE;
>  	struct memory_group *group =3D NULL;
>  	u64 start, size;

[ ... ]

> @@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *r=
es, mhp_t mhp_flags)
> =20
>  	/* online pages if requested */
>  	if (mhp_get_default_online_type() !=3D MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);

[Severity: High]
Does checking the live state here instead of the cached online_type introdu=
ce
a race condition?

If a concurrent write to the lockless sysfs attribute
/sys/devices/system/memory/auto_online_blocks changes the global policy
from MMOP_OFFLINE to MMOP_ONLINE_MOVABLE while add_memory_resource() is
executing, this condition could evaluate to true while walk_memory_blocks()
uses the cached MMOP_OFFLINE value.

Because the condition uses the live value, but walk_memory_blocks() uses the
cached online_type, could memory_subsys_online() treat MMOP_OFFLINE as an
unconfigured request and forcefully overwrite it to MMOP_ONLINE?

This would result in memory being onlined into the un-removable ZONE_NORMAL
kernel zone instead of being left offline or onlined into ZONE_MOVABLE. This
pins the memory permanently and prevents memory hot-unplug, leading to
resource stranding in virtualized environments.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712154505.3564=
379-1-gourry@gourry.net?part=3D3

