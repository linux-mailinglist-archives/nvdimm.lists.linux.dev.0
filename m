Return-Path: <nvdimm+bounces-14765-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HxZYJF/CR2pmewAAu9opvQ
	(envelope-from <nvdimm+bounces-14765-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 03 Jul 2026 16:08:31 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27AFC703411
	for <lists+linux-nvdimm@lfdr.de>; Fri, 03 Jul 2026 16:08:31 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhNX0kyC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14765-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14765-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 57F16301C430
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jul 2026 14:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F763D9556;
	Fri,  3 Jul 2026 14:06:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1ED3D25C2
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 14:06:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783087579; cv=none; b=t3fHznhREZCxdrrV7N3Vt27mQb1Mne7fnhTjCBRwudalQIGqVxjOUhbm03PAwxEdTrWwUKqmUYpv0caCRi2jJS3vU0WKMPRf5ynV9xW7y93n85N5BfJRUuehhNGrGa14dqAr7ucmpMXXtQ7Z17YniB54oCp1HOvW9mYgu/noLhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783087579; c=relaxed/simple;
	bh=wyqNjMaqnyGnSB8z7l+zYYA5NUJWruTBqnor+x4r1qU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FT+FvT8rq1WFMRTKjzTxb/OAwWg3TWZ0bipYnAm/2rMPoVjRAAfRuWSzFTx51vmeThsuvuQPKqj3q2TT1Lnz/ppMe2Z17x2G+19NTSmAwehx+5ghbdafkM79/hU0nfm8DU8uXWFNYT3oo/rmyUmDbf6M5WxtScMz8EhICJqy/iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhNX0kyC; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103981F000E9;
	Fri,  3 Jul 2026 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783087578;
	bh=ArvNEBWKJ0Cgy1PDOVudURuagJpnqBDRwV4a5iaMye0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JhNX0kyClSo4+we2qEc7Cch6tSogGxKnV6sBBf39W4ybG5ngysLPmzd6rN2Tt5Rph
	 IVxT6SJGpeJTW5ETYj+MAPapknqXFjZW3fYGwWwEu2XhmeTT+XcZ9SJ6uW8gt8/78Q
	 1fsa4Kc/eYhoVMsCqQNqnC1T3wzL37RfLXrOXk6PPKlyP1x4ydYqIxssVLyYyj8EnG
	 O/rM26nqz/RH5W7L76pa/hItnkDm0Qs1G8/mdFgKMYOAO0F9kVGm3FAGuk2nswrFlE
	 Oh4EtI8h/WvSbJ60A5SlRU+Tvxt/EoUnU0ZTfWy4UfZOHvNsvF0WwFlcm6XF2+8uD0
	 NA9Ovs1JgfEFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] nvdimm: ndtest: remove redundant NULL check before
 vfree()
Reply-To: sashiko-reviews@lists.linux.dev
To: mdshahid03@gmail.com
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260703135513.75840-1-mdshahid03@gmail.com>
References: <20260703135513.75840-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 14:06:17 +0000
Message-Id: <20260703140618.103981F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14765-lists,linux-nvdimm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:mdshahid03@gmail.com,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smtp.kernel.org:mid,lists.linux.dev:from_smtp,lists.linux.dev:replyto,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 27AFC703411

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free / list corruption in ndtest_alloc_resource() error =
path.
- [High] Missing error check in ndtest_nvdimm_init() leads to NULL pointer =
dereference.
--

commit 96f1b7f6e50c7c8c92043b84b02d39517266ebe3
Author: Mohammad Shahid <mdshahid03@gmail.com>

nvdimm: ndtest: remove redundant NULL check before vfree()

vfree() safely handles NULL pointers, so the explicit NULL check
before calling vfree() is unnecessary. This was reported by
ifnullfree.cocci.

> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/te=
st/ndtest.c
> index 8e3b6be53839b..2051ad5d4882d 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -376,8 +376,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv=
 *p, size_t size,
>  buf_err:
>  	if (__dma && size >=3D DIMM_SIZE)
>  		gen_pool_free(ndtest_pool, __dma, size);
> -	if (buf)
> -		vfree(buf);
> +	vfree(buf);
>  	kfree(res);

[Severity: High]
This isn't a bug introduced by this patch, but could this error path cause
list corruption or a use-after-free?

Earlier in ndtest_alloc_resource(), res is added to the p->resources list:

	spin_lock(&ndtest_lock);
	list_add(&res->list, &p->resources);
	spin_unlock(&ndtest_lock);

If devm_add_action() fails, execution falls through to buf_err, where
kfree(res) is called. However, res is not removed from the p->resources
list before being freed.

When the driver core subsequently invokes devres_release_all() on failure,
the cleanup function ndtest_release_resource() for any previously
successful allocations will traverse and modify this corrupted list,
resulting in a use-after-free.

Would it make sense to call list_del() before freeing res here?


[Severity: High]
This is a pre-existing issue, but while looking at this file, I noticed a
potential NULL pointer dereference in ndtest_nvdimm_init():

tools/testing/nvdimm/test/ndtest.c:ndtest_nvdimm_init() {
    ...
    ndtest_dimm_register(p, d, id);
    ...
}

If ndtest_dimm_register() fails, such as due to an allocation failure for
the dimm device, it returns an error but leaves d->nvdimm as NULL. Because
ndtest_nvdimm_init() ignores this error, it successfully returns.

Later, ndtest_create_region() passes the NULL nvdimm pointer to
nvdimm_pmem_region_create(), which dereferences it inside
nd_region_create(), causing a crash.

Should the return value of ndtest_dimm_register() be checked to prevent
this?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703135513.7584=
0-1-mdshahid03@gmail.com?part=3D1

