Return-Path: <nvdimm+bounces-14597-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id IaaVFstyPWoa3QgAu9opvQ
	(envelope-from <nvdimm+bounces-14597-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:26:19 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D8E6C830A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:26:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDxlbRh8;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14597-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14597-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 391C330785D4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E29D3264CC;
	Thu, 25 Jun 2026 18:24:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9D30569F;
	Thu, 25 Jun 2026 18:24:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411849; cv=none; b=bjnyChHFxdGi0vWTx8yCAIrXckQE0KhJgCTEKfqdKWtxm6qPCLh+HAsiiF1Dv0341NwnAsdMzuYT17Ee7la/XHi/ZiMFkohNfl0Ml80J/bsBfV/QhQ6Cp2gsZjYONzjcP5oyNjzTbjeNrlNSozRH/HvHuHpFoW8h+yG4mijM0t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411849; c=relaxed/simple;
	bh=vWphCE8TVmWGV/5YXCXDkOifnwrx5dtWVTSwySYfkDI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RzQJCQUfdQwM+rgeNhQvSQmmTp1/NBZv548dZxpGJDN9UwA2EiLdV53WuS9bULRYKfmeb3WbQuTNnO/+/eV7HngLfpVxFmh/PHwhjUE/+DlDlNGruS4/WIECObJzEiVjC9Cm1VI8YrzBCLHSM4F7FL1Ns0TkPN7WKDTp8UVTg5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDxlbRh8; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE71F000E9;
	Thu, 25 Jun 2026 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411847;
	bh=vWphCE8TVmWGV/5YXCXDkOifnwrx5dtWVTSwySYfkDI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oDxlbRh88UASv4VP5TnQi39Xh3M0jLm7hsxXM/BEMMmLpmPniFXbjAow7+ilmYZnu
	 HOZhycJsDgUoY3ChBXQ6JnpJ5EyIXDGXQw1SJffTXIzFCAUK2ByghPSjiNfwPij1n2
	 6d5Ws/mwMaiLZ2Wj9gg98RoEotlRp1uMBqL7EBYMziXRTV7oBYJXSpOLH9qQ9UfXY/
	 4HfqJS7z1G34qZKWa1hDK6YvNaoAq1LwXCPzRu0BTxXc5QW3qyUdZKwig6yWaV+jzF
	 4vI/Ir1edGVNX+5Ipir/nZtbXzJJXXMSnACOBboIYnAy3NmcfiOg/zwh+3Htt6/IpL
	 mqzjIQH84NAXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 31/31] Documentation/cxl: Document DCD extent
 handling and DC-backed DAX regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-32-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-32-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:24:06 +0000
Message-Id: <20260625182407.A8BE71F000E9@smtp.kernel.org>
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
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14597-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:linux-cxl@vger.kernel.org,m:nvdimm@lists.linux.dev,m:anisasu887@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,smtp.kernel.org:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A9D8E6C830A

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Typo in documentation: 'can by chained' should be 'can be chained'.
--

commit 06abcda7f883fa6e5d50becfc5150a117123a7a6
Author: Anisa Su <anisa.su887@gmail.com>

Documentation/cxl: Document DCD extent handling and DC-backed DAX regions

This commit extends the CXL and DAX driver-api documentation to cover
Dynamic Capacity Devices. It details the conditions for accepting or
releasing extents, and explains the mapping between accepted extents and
DAX devices.

> diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Document=
ation/driver-api/cxl/linux/cxl-driver.rst
> --- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
> +++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst

[ ... ]

> +Accepting Extents
> +-----------------
> +Extents are made available to the host from the device through DC ADD ev=
ents.
> +Event records contain extents, which may be tagged or untagged, shared or
> +not shared. Multiple event records can by chained together by the `More`=
 flag.

[Severity: Low]
This isn't a bug, but there is a typo here: "can by chained" should be
"can be chained".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D31

