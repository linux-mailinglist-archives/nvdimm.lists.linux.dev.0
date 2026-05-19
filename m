Return-Path: <nvdimm+bounces-14060-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SO/XLCNLDGrjdQUAu9opvQ
	(envelope-from <nvdimm+bounces-14060-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 13:36:03 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7871757DBD5
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 13:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D0E013012B03
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 11:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF516369D67;
	Tue, 19 May 2026 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlhI6SV1"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB273321D4;
	Tue, 19 May 2026 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779190278; cv=none; b=Z94D5yIaAe6Svm2S2fZQ/Q/FEJDv21eWgVsWqOOoyABNaBx/M5U8Hf/IMwxW04r11Bg3hOB1ZQw26KRpMfMgDY0A0pDr9c6Y//x9VbzwDvmSdh9+rDHX/ZfiYJNlKFjqq6H5aib9yw0m/wpkee9vsQysPUq4gm4H2tDlzJhZrpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779190278; c=relaxed/simple;
	bh=YNM/fqs9TGWH1hPYSOkKh1B0729fn+GJaHi3vqaVG64=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=deqEqGwHeyyhx7v9DNQHcnnnjez12QeiEGXMmtk+0ZBOvAzIPMgtU5kA2Wph1/DpAiCGni8SxEc1puw+JLFP1LOzW7pEXc5312klqFBxi1qw0FSAfeD/Qad9Yhbm6T/N003gTsHdf15VmnxO/nvgeg6S191tqxYcedMo0VsmP1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlhI6SV1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDC3C2BCB3;
	Tue, 19 May 2026 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779190278;
	bh=YNM/fqs9TGWH1hPYSOkKh1B0729fn+GJaHi3vqaVG64=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hlhI6SV1lH+42oYEQLI4i3vUNxcG67ocr6I0zWlpTD3s8NKuGNHKQ4SQJS3+r5XMc
	 MAYwQEFXad0qtY0p3ZDGqq1zh0IWiArsQoIFAwKdp82emo5bCUh7aG0cylflNNRujG
	 2Bu3OLzFQH+n1U14r6btcqaASvvtv5AdojJf3zjCiw4Wq+Gy9ItbZOvvM5KVbfp+bU
	 WiYSIwUyaW/qqfV4XPYc17Bu84Q/JqSsKLHKFmRXZj2dVtqork2YArwvCTVwvnRPwC
	 y7MdXCKJHWWSOVI2VDw56jneVinBj9r9xe1BPoJdaPyjYPZSsQa2AamVnhOwNlWcnx
	 8tr4IJdBx5Ijw==
Date: Tue, 19 May 2026 12:31:12 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
Cc: smita.koralahallichannabasappa@amd.com, alison.schofield@intel.com,
 dan.j.williams@intel.com, icheng@nvidia.com, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, nvdimm@lists.linux.dev, ardb@kernel.org,
 benjamin.cheatham@amd.com, dave.jiang@intel.com,
 jonathan.cameron@huawei.com
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <20260519123112.5b5d34cd@jic23-huawei>
In-Reply-To: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
References: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-14060-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jic23@kernel.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,fujitsu.com:email,intel.com:email]
X-Rspamd-Queue-Id: 7871757DBD5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, 19 May 2026 12:18:32 +0200
Tomasz Wolski <tomasz.wolski@fujitsu.com> wrote:

> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem =E2=80=94 two subsystems (e.g. dax_hmem and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
>=20
> Switch from request_resource() + dev_dbg() to
> request_resource_conflict() + dev_err() so that the conflict is visible
> by default and the colliding resource is identified in the message.
>=20
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-=
mobl4.notmuch/
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
Seems reasonable to me
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/dax/bus.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 68437c05e21d..66413c6c2ba0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -637,7 +637,7 @@ struct dax_region *alloc_dax_region(struct device *pa=
rent, int region_id,
>  		unsigned long flags)
>  {
>  	struct dax_region *dax_region;
> -	int rc;
> +	struct resource *conflict;
> =20
>  	/*
>  	 * The DAX core assumes that it can store its private data in
> @@ -670,10 +670,11 @@ struct dax_region *alloc_dax_region(struct device *=
parent, int region_id,
>  		.flags =3D IORESOURCE_MEM | flags,
>  	};
> =20
> -	rc =3D request_resource(&dax_regions, &dax_region->res);
> -	if (rc) {
> -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> -			&dax_region->res);
> +	conflict =3D request_resource_conflict(&dax_regions, &dax_region->res);
> +	if (conflict) {
> +		dev_err(parent,
> +			"dax_region: can't claim %pR: address conflict with %s %pR\n",
> +			&dax_region->res, conflict->name, conflict);
>  		goto err_res;
>  	}
> =20


