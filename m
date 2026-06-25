Return-Path: <nvdimm+bounces-14592-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id gWXiM5hwPWqv3AgAu9opvQ
	(envelope-from <nvdimm+bounces-14592-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:16:56 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDAD6C822A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:16:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4t9dUgq;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14592-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14592-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1A295300A5BB
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A092D8773;
	Thu, 25 Jun 2026 18:16:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC751305693;
	Thu, 25 Jun 2026 18:16:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411411; cv=none; b=XVrccPQUHqE1c+LBw2dQJh2fG/+c7kXOCtYF3ZrEXMxlbS9TLS/8QOsl/lIKhcqDWa+aV73WeXLaeIniey1yFeTc4brnOmsod0CsXuSFaeB1U86mP3TfKMbhu4OlTnr3NUbh2ShrZfWa8XbXe8YkVazCkBQ7F9YH30wvtH/r3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411411; c=relaxed/simple;
	bh=bnzrYwl6CFGhy4Y3yBROQXeWnZunzeexVYvZfayIOJA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MYp6uxdb1HQ2u6caylCw3l9p6u14ncDrOcsFXlP2bNMONtwT4kzmaUNjwSBuksAbxHzEpf4bWXeUVMpTnP0SCxlQO93c+l5eI2Nsr4O6gNVS8OyrQtlfSSrcubap6IjS7af+opXpgxe9+DwzoAFOBNXz5Pw5a7v4ZuMHm9/P6XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4t9dUgq; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E881F000E9;
	Thu, 25 Jun 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411410;
	bh=hRL15YfI289gQ89N3mCSMIGUGTYlftYyPanImOGo7JU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j4t9dUgqTiw08ws5kV1MODmLGu5tU53zSXeSbCwuV5nPZaQZglXxXnrKJIRQlIuAo
	 D30TpEgX0kFw0SbJ7tlu1/dbrToTlblkqZR+BvjFW32LUlPZs7cFzknts97+xinXG3
	 b9IQvzqhw96mDF2JEMxuFkkVs8+mQ8KIZVBR5jOu4aQBmv+4BTWlxaAZREHQxGXQzz
	 8ZPizSdV+sHvHYzn0V1f4DgZ7gg12UAXuLgZfJk6+TA4pzoX8C+Z8hO7lLQC6PDVWL
	 ljQF9MyX1c/GsLs1Ln5xqI5C63jz9IEnY75toODLv3YK+hm99MxwWSMNhovs4WGAsM
	 SC4tNu8Zx3drQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 07/31] cxl/region: Add DC DAX region support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-8-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-8-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:16:49 +0000
Message-Id: <20260625181650.52E881F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14592-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,smtp.kernel.org:mid,sashiko.dev:url,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CFDAD6C822A

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Lockless access to `cxlmd->cxlds` via the newly introduced `cxled_=
to_mds()` helper in `store_targetN()` leads to a NULL pointer dereference d=
uring concurrent device teardown.
--

commit 0243c2c435424873e37aafdcb17aee31b0ea07a1
Author: Ira Weiny <iweiny@kernel.org>

cxl/region: Add DC DAX region support

This commit introduces dynamic DAX regions to support CXL DC capabilities.
It adds a new sysfs attribute for creating dynamic RAM regions and updates
target attachment logic to handle DCD support.

> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 82ca3a4767080..9ed141fa13341 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
[ ... ]
> @@ -18,6 +19,13 @@ enum cxl_detach_mode {
>  	DETACH_INVALIDATE,
>  };
> =20
> +static inline struct cxl_memdev_state *
> +cxled_to_mds(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev *cxlmd =3D cxled_to_memdev(cxled);
> +	return to_cxl_memdev_state(cxlmd->cxlds);
> +}

[Severity: High]
Can this result in a NULL pointer dereference during concurrent device
teardown?

If a user writes to a CXL region's targetX sysfs file, store_targetN()
calls cxled_to_mds() without holding locks that synchronize with device
teardown.

Concurrently, if the CXL device is hot-removed or the driver is unbound,
cxl_memdev_shutdown() nullifies cxlmd->cxlds under cxl_memdev_rwsem.

This would cause cxled_to_mds() to pass a NULL pointer to
to_cxl_memdev_state(), which unconditionally dereferences it:

drivers/cxl/cxlmem.h:to_cxl_memdev_state() {
    if (cxlds->type !=3D CXL_DEVTYPE_CLASSMEM)
        return NULL;
    ...
}

Does this path need to hold cxl_memdev_rwsem or otherwise verify
cxlmd->cxlds is not NULL before using it?

> +
>  #ifdef CONFIG_CXL_REGION
> =20
>  struct cxl_region_context {
[ ... ]
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index e50dc716d4e82..ba03ec5e27c32 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
[ ... ]
> @@ -2389,6 +2396,8 @@ static size_t store_targetN(struct cxl_region *cxlr=
, const char *buf, int pos,
>  	if (sysfs_streq(buf, "\n"))
>  		rc =3D detach_target(cxlr, pos);
>  	else {
> +		struct cxl_endpoint_decoder *cxled;
> +		struct cxl_memdev_state *mds;
>  		struct device *dev;
> =20
>  		dev =3D bus_find_device_by_name(&cxl_bus_type, NULL, buf);
> @@ -2400,8 +2409,21 @@ static size_t store_targetN(struct cxl_region *cxl=
r, const char *buf, int pos,
>  			goto out;
>  		}
> =20
> -		rc =3D attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
> -				   TASK_INTERRUPTIBLE);
> +		cxled =3D to_cxl_endpoint_decoder(dev);
> +		if (cxlr->mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM_1) {
> +			mds =3D cxled_to_mds(cxled);
> +			if (!mds) {
> +				dev_dbg(dev, "No memdev state\n");
> +				rc =3D -ENODEV;
> +				goto out;
> +			}
> +			if (!cxl_dcd_supported(mds)) {
> +				dev_dbg(dev, "DCD unsupported\n");
> +				rc =3D -EINVAL;
> +				goto out;
> +			}
> +		}
> +		rc =3D attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
>  out:
>  		put_device(dev);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D7

