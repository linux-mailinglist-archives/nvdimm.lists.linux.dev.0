Return-Path: <nvdimm+bounces-14600-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id e7o5IitzPWoq3QgAu9opvQ
	(envelope-from <nvdimm+bounces-14600-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:27:55 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5936C8329
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:27:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBuQM0mL;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14600-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.232.135.74 as permitted sender) smtp.mailfrom="nvdimm+bounces-14600-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 989E9302A4F8
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512CD3148C2;
	Thu, 25 Jun 2026 18:27:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0663A1A9F87;
	Thu, 25 Jun 2026 18:27:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412073; cv=none; b=G68LA2ZRyNeDiZocObsAgAsx8HM+2rVO9nmijFpCPSx/nEiQUIj20+8VHyxJPLMHx49gVnO/Jmag3DeyMklZ0kPT6K9s3i5SHeACapRDUL5XqNbX8HcDN69fDydDh+ehSmzy4SS09x7Gh797Uxz5Dewbu1LFiU6NYePwWdphnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412073; c=relaxed/simple;
	bh=uOdPRX3oza1b6QrDye/QNTSahAe9gj67JkrvckiJFUw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NaYH+hDjW+seU1W10PVPWC1yoXt2xdddY6PRgGqVp+USVYUsFw0TtETpYObnH0+OJcBl2WVbBmhuLaMZqZicrUWVXn2GVcfFBawOSbsB2xgfG+2zdq5bKTKvUiBx6g9NeslCAG7mEx/lN02ZLx+MqrDp9SKAwUEq7geEwYfl5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBuQM0mL; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B721F000E9;
	Thu, 25 Jun 2026 18:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412071;
	bh=TcAGM1tSTqXo/WYqugfLXETNXMMn++oUzvlC0NlO8ZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EBuQM0mLJEqgemZeSa4PMnXw/N5jZPsYHB/q7ZWV8erVDDDPly8lwA7jxMpaMYaVW
	 PhAzgYmPKUmrPZZBuAe9x/ieGhXtPT00gcD5WXsUGgkT2H87WJmhjUxMPHXpGjRfJO
	 mI5Y/Io22rxj3O47g0TL1rQvUh2np4IzXUktij/V2I6WxDw3gf0KbjEquYkv6OaUZ+
	 BtAVtCDqBrzD/AO0s69NFW7/njXxv6WuVup3tb8QZHvcAaQVI1PbE21Gq24/Iv0U+7
	 mpybB+WCqA9qrWNKFf/wYQ1yLzOkkSTBOmE0+ub8pDZYszoo+FwNtybJ8SxXq39tlb
	 CrcXDAIDPrmMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 23/31] dax/bus: Factor out dev dax resize logic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-24-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-24-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:27:50 +0000
Message-Id: <20260625182751.64B721F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14600-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:anisasu887@gmail.com,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url,smtp.kernel.org:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2A5936C8329

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Integer overflow in __dev_dax_resize causes >2GB allocations to be=
 treated as errors, leaking DAX resources on 32-bit systems.
--

commit abac505d7b066ca0edac0e8d7df59c037cc29e89
Author: Ira Weiny <iweiny@kernel.org>

dax/bus: Factor out dev dax resize logic

This commit factors out the device dax resize logic to prepare for dynamic
capacity regions. It introduces a helper function that allocates ranges
using a specified parent resource, returning the successfully allocated siz=
e.

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 95683dc8fcd0c..ffa6b303fc9bd 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
[ ... ]
> +static ssize_t dev_dax_resize_static(struct resource *parent,
> +				     struct dev_dax *dev_dax,
> +				     resource_size_t to_alloc)
>  {
>  	struct resource *res, *first;
>  	int rc;
> =20
> +	first =3D parent->child;
> +	if (!first) {
> +		rc =3D alloc_dev_dax_range(parent, dev_dax,
> +					   parent->start, to_alloc, NULL);
> +		if (rc)
> +			return rc;
> +		return to_alloc;
> +	}
> =20
>  	for (res =3D first; res; res =3D res->sibling) {
>  		struct resource *next =3D res->sibling;
> +		resource_size_t alloc;
> =20
>  		/* space at the beginning of the region */
> +		if (res =3D=3D first && res->start > parent->start) {
> +			alloc =3D min(res->start - parent->start, to_alloc);
> +			rc =3D alloc_dev_dax_range(parent, dev_dax,
> +						 parent->start, alloc, NULL);
> +			if (rc)
> +				return rc;
> +			return alloc;

[Severity: High]
On 32-bit systems where ssize_t is a 32-bit signed integer and
resource_size_t can be an unsigned 64-bit value, does returning a 2GB or
larger alloc size cause an integer overflow?

If alloc is >=3D 2GB, returning it as ssize_t could wrap to a negative numb=
er
or zero if truncated from a larger type.

[ ... ]
> +static ssize_t dev_dax_resize(struct dax_region *dax_region,
> +		struct dev_dax *dev_dax, resource_size_t size)
> +{
[ ... ]
> +retry:
> +	alloc =3D dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
> +	if (alloc < 0)
> +		return alloc;

[Severity: High]
If a large allocation overflows into a negative ssize_t, wouldn't this call=
er
evaluate alloc < 0 as true and mistakenly treat the successful allocation as
an error?

Because the successfully mapped chunk was already added to dev_dax->ranges =
in
dev_dax_resize_static(), aborting the resize here without unwinding the new=
ly
allocated range seems like it would permanently leak the DAX space and leave
the region in an inconsistent state.

> +	if (alloc =3D=3D 0)
> +		return -ENOSPC;
>  	to_alloc -=3D alloc;
>  	if (to_alloc)
>  		goto retry;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D23

