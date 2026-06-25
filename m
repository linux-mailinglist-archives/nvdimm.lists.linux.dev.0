Return-Path: <nvdimm+bounces-14589-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id O1j1JVVwPWqn3AgAu9opvQ
	(envelope-from <nvdimm+bounces-14589-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:15:49 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F0A6C820E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:15:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln3g1MRE;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14589-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14589-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02B27302883B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6967E23ED60;
	Thu, 25 Jun 2026 18:15:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F9E555;
	Thu, 25 Jun 2026 18:15:44 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411346; cv=none; b=L9qVtddSMYJVn6qEMzMLRxlyDA4nSQf6YzyTKZf2meNNovWyuIQYbd1DZkONH0r454rYh/trPMc4zbx2ISP7RP6W+3OXilxFh9ZeRP0daVm5NlSCzMCPgtPBqiEafrJzV+GIYbGKrKEGrJpxAV+8pj4nkuMUZ/tU1SNkZAuzGq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411346; c=relaxed/simple;
	bh=Vy0mz5S0xGeZhiPhMD75YSiZqn1KDDwMRCwt3twshMg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XPQSvRKl4z9loAQLQlSJaa9fkLJu+lBh+4dmNpaS2aENczJkNFFZTfIC8eeivC5ADkbqQV/6d8J4Z7tyd5dB6gFNoT1eQNLnNpujhGP0vhLtzf7u37spCt2hk2FgsQrlezJZMinz5aQIOc6TonfOMjspzoS5daEORlJJ7lf97A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ln3g1MRE; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B691F000E9;
	Thu, 25 Jun 2026 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411344;
	bh=ZxoYy/8q8oKT4Ormr6MYWOzEDEp1/6aaNQIxhYA4rfo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ln3g1MREeTrCFZWXcg6aaGUWNsI9hmJGLcvC8X65CJbD+YDOpaBm6vvjjJdokS1Rt
	 bHSfEvYpHHiX00HoE0JtLyrpkkkjD0cDgJcGdbOT5DPPR3NDoNcH5aD/Em7GBhuyAL
	 t6nyES8OnRkZ4xhcNxNpOk6FNJJvJnZRkIfJP/zm2uiqAocTr2aDPteL821V20ktTN
	 QDtqT56Ob4LX1OdKtHERLHKawTdT3VM5IHMlNjrLfwl0dHpjxR5m7/SrKQIaN3zhbt
	 gSNj0wRel5SJ6Fm7ilTUSVPBcpAxa2eCucsj6xjs8t9DZ9iuW+bVZhh07MhigyImqL
	 iwzJmxWPgl2jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 13/31] cxl/mem: Add 20 second timeout for stalled
 DC_ADD_CAPACITY chains
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-14-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-14-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:15:43 +0000
Message-Id: <20260625181544.67B691F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14589-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,smtp.kernel.org:mid,lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E6F0A6C820E

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Error paths in handle_add_event fail to abort the DCD event chain =
properly, leading to a stalled device, leaked watchdog timers, and partial =
chain acceptance.
- [High] Watchdog timeout clears the pending list without transitioning to =
a discard state, leading to a double-response protocol violation if the cha=
in completes.
--

commit f4b4a95fd0c56d91f06baa4811e9a05ea46012ee
Author: Anisa Su <anisa.su887@gmail.com>

cxl/mem: Add 20 second timeout for stalled DC_ADD_CAPACITY chains

A DC_ADD_CAPACITY event can span multiple event records. This patch adds a
delayed-work watchdog to prevent indefinitely stalled chains and enforces a
maximum limit on the number of pending extents.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 7dd40fb8d613c..4e887b5cdc3ed 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> @@ -1208,15 +1208,78 @@ static void clear_pending_extents(void *_mds)
> =20
>  	list_for_each_entry_safe(pos, tmp, &mds->add_ctx.pending_extents, list)
>  		delete_extent_node(pos);
> +	mds->add_ctx.nr_pending =3D 0;
>  	mds->add_ctx.group =3D NULL;
>  }

[ ... ]

> +static void cxl_dc_add_timeout(struct work_struct *work)
> +{
> +	struct pending_add_ctx *ctx =3D container_of(to_delayed_work(work),
> +						   struct pending_add_ctx,
> +						   timeout_work);

[ ... ]

> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				 &ctx->pending_extents, 0))
> +		dev_dbg(dev, "Failed to send empty ADD_DC_RESPONSE on timeout\n");
> +
> +	clear_pending_extents(mds);
> +	ctx->armed =3D false;
> +}

[Severity: High]
If the device is just slow and later sends the remainder of the chain
(including the closing More=3D0 event), will the driver treat the delayed
events as a fresh chain?

Because cxl_dc_add_timeout() resets ctx->armed =3D false and nr_pending =3D=
 0
without marking the chain as discarded, it appears handle_add_event() would
process a delayed tail of the chain as a new chain.

When the More=3D0 event is processed, wouldn't the driver issue a second
ADD_DC_RESPONSE for this single event chain, violating the CXL protocol?

[ ... ]

> @@ -1239,10 +1303,20 @@ static int add_to_pending_list(struct list_head *=
pending_list,
>  static int handle_add_event(struct cxl_memdev_state *mds,
>  			    struct cxl_event_dcd *event)
>  {
> +	struct pending_add_ctx *ctx =3D &mds->add_ctx;
>  	struct device *dev =3D mds->cxlds.dev;
>  	int rc;
> =20
> -	rc =3D add_to_pending_list(&mds->add_ctx.pending_extents, &event->exten=
t);
> +	guard(mutex)(&ctx->lock);
> +
> +	if (ctx->nr_pending >=3D CXL_DC_MAX_PENDING_EXTENTS) {
> +		dev_warn(dev, "DC add chain exceeds %u extents; dropping (firmware bug=
)\n",
> +			 CXL_DC_MAX_PENDING_EXTENTS);
> +		clear_pending_extents(mds);
> +		return -ENOSPC;
> +	}
> +
> +	rc =3D add_to_pending_list(&ctx->pending_extents, &event->extent);
>  	if (rc) {
>  		clear_pending_extents(mds);
>  		return rc;

[Severity: High]
Do these early error returns fail to abort the event chain properly?

If the limit is exceeded or memory allocation fails, the code calls
clear_pending_extents() and returns an error without sending an
ADD_DC_RESPONSE.

If this happens on the first extent, wouldn't the device never receive a
response and stall indefinitely?

If it occurs on a subsequent extent, does this leave the watchdog timer
armed to fire spuriously later?

Additionally, because clear_pending_extents() resets nr_pending to 0, if
the device continues sending More=3D1 events for the same chain, would the
driver incorrectly process them as a new chain and potentially accept the
tail of a chain after dropping the head?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D13

