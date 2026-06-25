Return-Path: <nvdimm+bounces-14588-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XJz6DxtwPWqj3AgAu9opvQ
	(envelope-from <nvdimm+bounces-14588-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:14:51 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9686C81FB
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:14:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWs129Bu;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14588-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14588-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 36EB0300B0A3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F6530C169;
	Thu, 25 Jun 2026 18:14:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ADE30BBB9;
	Thu, 25 Jun 2026 18:14:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411283; cv=none; b=utfus7ufatxzoF+wAF9wFCpm+NRSV9Ljp7MR9JI0od+yiag0LxO5y5cyKN1S8EvnxfDMW9aftwMbP5pWOdfpiUEkIfzRL4H1Iqg7fvir8ye1b+rcGYhXY23q85V68Lk6Syu95XIWi6egeCEbRtjQ9YMf4UF98jQs18CwR1B7vLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411283; c=relaxed/simple;
	bh=TgFOmn/S6iGOC3SXnPV3hz4u1hPr+LED4ah7PUQvEw4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=porKB/P+xhlnlUc620f4n3QvkUaNbZxNAD7xVV6P+hCdY/sQtkJOlDduzZTFpyRgAflNY77EYCsvIPHvorwqXRgwz0lAwVH0Y4fcE1ypTchfCpSc7QAskmPa1Qpe7r0AEShoALi1PBO+TlpWrjuawJ2hZYw9Zq1dfX8zOzu4ufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWs129Bu; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E561F000E9;
	Thu, 25 Jun 2026 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411282;
	bh=a+/NT9qQPyAZvJ8WJ03mQ9xhmNr5gFd8IqFW41T8WWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nWs129BubL4C4Z10jBQUX5st0UdJH3MQXL6xhitZDTH89c7X4vvxKAxEEgl/QhlnU
	 PLrfAlNFpczIuxkBpVpDX6LSTMUOe6O7oHJkREEYYNngMVRqkhLCCtnJSt4sGltVds
	 mFGcf+p2divqX5ovMsgqcJQpPQGs/4pI2Ve0RaahvJAVqz6cKFRxId6gWATaQS9Mjd
	 NOPob37CEVcW7qR9nRNDmQKcaASOr6VBd9oKv72NHGz/VHSg7bqZXW3Enr8D2Urk7Y
	 a/76oSCtfCe8VdHVJYR00Yq7l3+0Vt3GWQ/Y5OlB2eID7rj07MGJGYZ9rSVKh8s5qq
	 ceSTesmB4Pqmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 10/31] cxl/mem: Configure dynamic capacity
 interrupts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-11-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-11-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:14:41 +0000
Message-Id: <20260625181442.33E561F000E9@smtp.kernel.org>
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
	TAGGED_FROM(0.00)[bounces-14588-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:linux-cxl@vger.kernel.org,m:nvdimm@lists.linux.dev,m:anisasu887@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[kernel.org:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
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
X-Rspamd-Queue-Id: 2E9686C81FB

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] An unhandled DCD event status bit will cause an infinite loop in t=
he `cxl_event_thread` IRQ handler if DCD processing is disabled dynamically.
- [High] The driver fails to perform an initial drain of the DCD event log =
when the BIOS has control of standard CXL errors (`!native_cxl`), stranding=
 pre-existing events.
--

commit 4e2d7455b6a9875d8ee530fc91ae3a8b65741caa
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Configure dynamic capacity interrupts

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism.  The interrupt mailbox commands were
extended in CXL 3.1 to support these notifications.  Firmware can't
configure DCD events to be FW controlled but can retain control of
memory events.

> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8d12c684d6700..95a4bf7c1e466 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
[ ... ]
> @@ -632,6 +657,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_stat=
e *mds,
>  	return 0;
>  }
> =20
> +static int cxl_irqsetup(struct cxl_memdev_state *mds,
> +			struct cxl_event_interrupt_policy *policy,
> +			bool native_cxl)
> +{
> +	struct cxl_dev_state *cxlds =3D &mds->cxlds;
> +	int rc;
> +
> +	if (native_cxl) {
> +		rc =3D cxl_event_irqsetup(mds, policy);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		rc =3D cxl_event_req_irq(cxlds, policy->dcd_settings);
> +		if (rc) {
> +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
> +			cxl_disable_dcd(mds);

[Severity: High]
If cxl_event_req_irq() fails here, cxl_disable_dcd() is called, but the
device is already programmed to generate DCD interrupts.

When a DCD event interrupt fires, cxl_event_thread() will read the status
and retain the CXLDEV_EVENT_STATUS_DCD bit because the mask includes it.
However, cxl_mem_get_event_records() skips draining the log when
cxl_dcd_supported() is false:

drivers/cxl/core/mbox.c:cxl_mem_get_event_records() {
    ...
    if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
        cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
    ...
}

Will this cause cxl_event_thread() to spin in an infinite loop since the
status bit is never cleared by draining the log?

> +		}
> +	}
> +
> +	return 0;
> +}
[ ... ]
> @@ -687,11 +744,16 @@ static int cxl_event_config(struct pci_host_bridge =
*host_bridge,
>  	if (rc)
>  		return rc;
> =20
> -	rc =3D cxl_event_irqsetup(mds, &policy);
> +	rc =3D cxl_irqsetup(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
> =20
> -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> +	if (native_cxl)
> +		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);

[Severity: High]
If the BIOS has control of standard CXL errors (!native_cxl), does this skip
the initial drain of the DCD event log?

Since the driver owns the DCD log regardless of native_cxl, it appears that
pre-existing DCD events might be left in the log, potentially preventing
subsequent edge-triggered interrupts from firing.

> +
> +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> +		native_cxl ? "OS" : "BIOS",
> +		cxl_dcd_supported(mds) ? "supported" : "not supported");
> =20
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D10

