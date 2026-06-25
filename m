Return-Path: <nvdimm+bounces-14602-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NmQ/HKVzPWo03QgAu9opvQ
	(envelope-from <nvdimm+bounces-14602-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:29:57 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0756C8338
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:29:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1E88vlP;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14602-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14602-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 41694302CA85
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1A1325706;
	Thu, 25 Jun 2026 18:29:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0795B316192;
	Thu, 25 Jun 2026 18:29:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412192; cv=none; b=CON2J8jkswG6T6oJ6EyNr1r4BiYNC6I1mUXEnrdkZzVEIt+vcJ9yYIKBx4/7mEkKLDJujlk6uQIVBdm836hiLflPfGtY67YLjrAySkCRslJinNI49KmXe6yZzET1uz+nIYJ0M/B8ajZZU+3DYXRA78QUCRP5/p2SbqWxVFZAqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412192; c=relaxed/simple;
	bh=dl0D8O3yGITA8x0kSPOkvNjybm75n3Hvqj7jkMoRiic=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fFUFWEDDvq081p8pQr+6qMK4gLNY5zxbyL31wcGeqw/wW23p+i/85jWP1HxglvjAq4Ddy/sy9AIkjPzyk0ZExq2+kPwkSd3J+lqRI/G1dv9rilJbgV549fTHBUXCoDO/zjxbQzPRmWly6tSZsamxyqoZWSiCuGgA1STJgYLs6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1E88vlP; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E951F000E9;
	Thu, 25 Jun 2026 18:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412190;
	bh=yByhOJg/mpsD/Vm6bO5YP+MDCBqOuqHnyjvs7t7avtY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A1E88vlP1XKMdrKCKIpVRmvLs4ImLnErO3gocf9fWxX8xkmHzE92EftwL5tAs40a9
	 XoQjLo8ZBsL3yWnDDcNFrRah8/lFZiiw5byinnJQj27So/E5GmRQNQFDWS3LBUIMMU
	 S5lbBwGxYI+jhJrJelG/urgwD7iJzcemYw++ZdhTYeVvN5/gg8Fs+sVx1ZjTW+aMBb
	 zbXpUXQ/BaK1WbNlQklPn0bAKjT9JUq7fNoobtgIfG38EJXCs6ddM1BFixzXRLtncL
	 qfYOv71DVGaX9vxMY2eNzmbOwWolMhDUwAZcw60bLu1s58mDzw2E2kZR5ncF36e4YZ
	 EUcHvl8LW3zOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 21/31] cxl + dax: Surface dax_resources on DCD Add
 Capacity events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-22-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-22-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:29:49 +0000
Message-Id: <20260625182950.55E951F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14602-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url,smtp.kernel.org:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0D0756C8338

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The dax_resource devm cleanup action is tied to the dc_extent devi=
ce instead of the DAX region, leading to a Use-After-Free of the DAX region=
 if the DAX driver unbinds.
--

commit 20b0e06e09f045b8ed2d61cce6004f2c3647ec5a
Author: Ira Weiny <iweiny@kernel.org>

cxl + dax: Surface dax_resources on DCD Add Capacity events

This commit defines the DAX region .notify callback and registers a
dax_resource for each extent when the CXL side onlines a tag group during
a DC Add event.

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 7356aaaffe577..9b5c03616b83d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
[ ... ]
> @@ -182,6 +182,138 @@ static bool is_dynamic(struct dax_region *dax_regio=
n)
>  	return (dax_region->res.flags & IORESOURCE_DAX_DCD) !=3D 0;
>  }
> =20
> +static void __dax_release_resource(struct dax_resource *dax_resource)
> +{
> +	struct dax_region *dax_region =3D dax_resource->region;
> +
> +	lockdep_assert_held_write(&dax_region_rwsem);
> +	dev_dbg(dax_region->dev, "Extent release resource %pr\n",
> +		dax_resource->res);
[ ... ]
> +static int __dax_region_add_resource(struct dax_region *dax_region,
> +				     struct device *device,
> +				     resource_size_t start, resource_size_t length,
> +				     const uuid_t *tag, u16 seq_num)
> +{
> +	struct dax_resource *dax_resource __free(kfree) =3D
> +				kzalloc(sizeof(*dax_resource), GFP_KERNEL);
[ ... ]
> +	/*
> +	 * open code devm_add_action_or_reset() to avoid recursive write lock
> +	 * of dax_region_rwsem in the error case.
> +	 */
> +	rc =3D devm_add_action(device, dax_release_resource, dax_resource);

[Severity: High]
Does this tie the cleanup action to the wrong device lifetime?

In __dax_region_add_resource(), the devm_add_action() registers
dax_release_resource() to the passed-in device, which is the dc_extent
device managed by the CXL core.

However, the dax_region is tied to the DAX driver's lifecycle. If a user
unbinds the DAX driver, the dax_region is freed. Because the dc_extent
device is managed externally, it outlives the DAX driver unbind.

Later, when the CXL region is destroyed and the dc_extent is released,
dax_release_resource() will run and call __dax_release_resource(), which
dereferences the freed dax_region:

__dax_release_resource()
    struct dax_region *dax_region =3D dax_resource->region;
    dev_dbg(dax_region->dev, ...);

Can this lead to a use-after-free on the dax_region?

> +	if (rc) {
> +		__dax_release_resource(dax_resource);
> +		return rc;
> +	}
> +
> +	dev_set_drvdata(device, no_free_ptr(dax_resource));
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D21

