Return-Path: <nvdimm+bounces-14284-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Lez0FsdDH2p2jQAAu9opvQ
	(envelope-from <nvdimm+bounces-14284-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 22:57:43 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F1244631F14
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 22:57:42 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiWZZ4rs;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14284-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.232.135.74 as permitted sender) smtp.mailfrom="nvdimm+bounces-14284-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 90396302DC44
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Jun 2026 20:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AE5397352;
	Tue,  2 Jun 2026 20:57:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA2E2E173D
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 20:57:37 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780433858; cv=none; b=kY2GHdwzXpqQhx+RWqRkPxUTlz/xSXew/bSdObulwqmjxkjWElGiHkOaBascSqDm6ZpmUBZycVJki1cn80yB89Rfv1gCS54EZrH4Wm3gOCRMVlDr5dBvQePcnxXjCZ67+YOn2Sy/NEUEsXlQWY1VGfclktI4kLjTqZbsev7KJmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780433858; c=relaxed/simple;
	bh=+1aWWw/VOUkqUbYCvDexioiv825eBfUthhxhUbeH0Gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqdJKjysWaTj5+S0RRbQQJTD27WALyqZMnjrBhhaY2D1w00yCCBZzS+ooU7CdGj5jSCPkqsGa9JULRV+oTlSq83qTFsynRPZpK+GwrH0QXgt1YaHzKUJzYxmH2LAY9wYxser+QRP8SU3XebVWIEYFrGtAoBJ1G4/7yrjI8n055g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiWZZ4rs; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0161F0089E
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 20:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780433857;
	bh=9UxALlZp/awNelHKd+NuGpitMwLkRFkpst+BtBihDis=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XiWZZ4rs/2nqPYIObqYnIq5AzztDyRWTcgfkC4OazOBrD0sT6tzZvL3gDTJzFnTh2
	 uuawj+ykPMEegjPDbVziym3rlgqt8G2J+fFGPfsOIyo9Ht04jqXub014kCxJPeGLEM
	 YH4R8wMGMcHxUuLxIlq3+TRjYDHWGstorXJm8aRaU8+InxbbiCfoOb1NhD3zmMJf01
	 u2Whvh59/Egl64a2753XUtsfsdSTzco4G0Pt06RR/K979vXQkKpZabxAyeVNCN8qG6
	 c25E50yXSL9dH5ZQQXpbIwVBg/21fDqnDPjpYMgY7FhuhEFunEH7Q6uV3SVMlLJkus
	 6bl2kaiqQ6P9A==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa619653e4so3478912e87.1
        for <nvdimm@lists.linux.dev>; Tue, 02 Jun 2026 13:57:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+y1wAfmBN3CT4cIQvZ3juz00kYdJl5YUjSM697rEvaFnHF5ICe8IbgCNkHxK9ptaZyUBfn9Ek=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw471nFMJOta9BYlsTfRt9eMCxusSfSd8UH7OXvmQcLT1ULaOtV
	UnTFDw81nHCEO1IlF1Yzi+mUNAZwxPNccTx6xfqdKNIGBE/kcwSK1leQZSnJRQRYUjMyoDhLnTt
	33fVGrMCeyNkTdyrHfMfXUu6/x1Z6hH4=
X-Received: by 2002:a05:6512:b1f:b0:5a7:4912:1a50 with SMTP id
 2adb3069b0e04-5aa7c7ba65bmr95622e87.20.1780433855543; Tue, 02 Jun 2026
 13:57:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4739447.LvFx2qVVIh@rafael.j.wysocki> <2268031.irdbgypaU6@rafael.j.wysocki>
 <ah8l-p0Ih9tzu0G1@ashevche-desk.local>
In-Reply-To: <ah8l-p0Ih9tzu0G1@ashevche-desk.local>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 2 Jun 2026 22:57:23 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0i0bKHa28xoVRiy_7i_PgjqYD_TA0yRoofmjH1oHGQuQA@mail.gmail.com>
X-Gm-Features: AVHnY4LjTtFPU-7gUiC9pe6qbcAK2aht3aLMvvWCkRbTo51arqrwkDeFdk4pDcA
Message-ID: <CAJZ5v0i0bKHa28xoVRiy_7i_PgjqYD_TA0yRoofmjH1oHGQuQA@mail.gmail.com>
Subject: Re: [PATCH v1 01/17] ACPI: bus: Introduce devm_acpi_install_notify_handler()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Hans de Goede <hansg@kernel.org>, 
	Armin Wolf <w_armin@gmx.de>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,gmx.de,intel.com,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-14284-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:andriy.shevchenko@linux.intel.com,m:rafael@kernel.org,m:linux-acpi@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:hansg@kernel.org,m:w_armin@gmx.de,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[rafael@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rafael@kernel.org,nvdimm@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,lists.linux.dev:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F1244631F14

On Tue, Jun 2, 2026 at 8:50=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, May 21, 2026 at 03:59:50PM +0200, Rafael J. Wysocki wrote:
>
> > Introduce devm_acpi_install_notify_handler() for installing an ACPI
> > notify handler managed by devres that will be removed automatically on
> > driver detach.
> >
> > It installs the notify handler on the device object in the ACPI
> > namespace that corresponds to the owner device's ACPI companion, if
> > present (an error is returned if the owner device doesn't have an ACPI
> > companion).
> >
> > Currently, there is no way to manually remove the notify handler
> > installed by it because none of its users brought on subsequently
> > will need to do that.
>
> ...
>
> > +static void devm_acpi_notify_handler_release(struct device *dev, void =
*res)
> > +{
> > +     struct acpi_notify_handler_devres *dr =3D res;
>
> 'dr' is usually associated with internal devres structures and might be
> misleading in here, I would rename to something like handler_devres.

Well, whatever.

> > +     acpi_dev_remove_notify_handler(ACPI_COMPANION(dev), dr->handler_t=
ype,
>
> acpi_dev might be also part of the same data structure, so you won't need=
 to
> take dev again and derive adev from it.

I'm not sure what you mean.

Put acpi_dev into struct acpi_notify_handler_devres?  That can be done
in a follow-up patch.

> > +                                    dr->handler);
> > +}
>
> ...
>
> > +/**
> > + * devm_acpi_install_notify_handler - Install an ACPI notify handler f=
or a
> > + *                                 managed device
>
> There is a stray space just after asterisk.

Which asterisk?

> > + * @dev: Device to install a notify handler for
> > + * @handler_type: Type of the notify handler
> > + * @handler: Handler function to install
> > + * @context: Data passed back to the handler function
> > + *
> > + * This function performs the same function as acpi_dev_install_notify=
_handler()
> > + * called for the ACPI companion of @dev with the same @handler_type, =
@handler,
> > + * and @context arguments, but the ACPI notify handler installed by it=
 will be
> > + * automatically removed on driver detach.
> > + *
> > + * Callers should ensure that all resources used by @handler have been=
 allocated
> > + * prior to invoking this function, in which case those resources shou=
ld be
> > + * devres-managed so that they won't be released before the notify han=
dler
> > + * removal.  Otherwise, special synchronization between @handler and t=
he
> > + * management of those resources is required.
> > + *
> > + * When the request fails, an error message is printed with contextual
> > + * information (device name, handler function and error code).  Don't =
add extra
>
> This "handler function" points to __func__? If so, it seems misleading.

Yes, this sentence should just be "When the request fails, an error
message is printed" without the "contextual information" part.

> > + * error messages at the call sites.
> > + *
> > + * Return: 0 on success or a negative error number.
> > + */
> > +int devm_acpi_install_notify_handler(struct device *dev, u32 handler_t=
ype,
> > +                                  acpi_notify_handler handler, void *c=
ontext)
> > +{
> > +     struct acpi_notify_handler_devres *dr;
> > +     struct acpi_device *adev;
> > +     int ret;
> > +
> > +     adev =3D ACPI_COMPANION(dev);
> > +     if (!adev)
> > +             return dev_err_probe(dev, -ENODEV, "No ACPI companion in =
%s()\n", __func__);
>
> Not sure how __func__ may help here. We will have a device instance to be
> printed. It's obvious then how to find the culprit call.

But it doesn't hurt either, does it?

> > +     dr =3D devres_alloc(devm_acpi_notify_handler_release, sizeof(*dr)=
, GFP_KERNEL);
> > +     if (!dr)
> > +             return -ENOMEM;
> > +
> > +     ret =3D acpi_dev_install_notify_handler(adev, handler_type, handl=
er, context);
> > +     if (ret) {
> > +             devres_free(dr);
> > +             return dev_err_probe(dev, ret, "Failed to install an ACPI=
 notify handler\n");
> > +     }
> > +
> > +     dr->handler =3D handler;
> > +     dr->handler_type =3D handler_type;
> > +     devres_add(dev, dr);
>
> > +     return 0;
> > +}
>
> --

So thanks for the review, but I don't think I want to send a v2 at this poi=
nt.

I'd rather send a follow-up patch to clean up these things.

