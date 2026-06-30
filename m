Return-Path: <nvdimm+bounces-14677-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FmgGNgubQ2q6dAoAu9opvQ
	(envelope-from <nvdimm+bounces-14677-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 12:31:39 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5966E2E3A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 12:31:39 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcJ0DR8d;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14677-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14677-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3D1D930B756E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 10:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4D13F0A9E;
	Tue, 30 Jun 2026 10:28:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9123F075A
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 10:28:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782815298; cv=none; b=CxzemAur3iZz+LL5SVkuWhx63qkABcDFefPzaNVxDxfUMMXEbuh8H1c7C7VZunUNk1QRlfqS3O7li/7FeKxP5jx9FujbLSHV6Pcvp7MvVBdGk8rKAcsgPIGE1WwSNc88XorT24fETbZMjy2n8yAoPunvgtmtuaoCkTpbr49LgeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782815298; c=relaxed/simple;
	bh=gT2KJYO7rghPiFA5dV0zixKv2phCs86Y6fazb1kQzew=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mrD077vzUGRuVZuQp9ps8BZKUFVVvjVhhpzNfgXQwFReMdMIHVp7BpVrEKU5w9ynDtI7ZGSqLLHT5OQht+fIzncF/Cm+PUR4yfIgt+dJuewjNvUwekwP8VAjZpqiDrZEqEs0xaP+olANlGNUMsE8dY4O/zn0phW5AslS/hXFaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcJ0DR8d; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA31F00A3A;
	Tue, 30 Jun 2026 10:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782815297;
	bh=TDFERgUAfmvkPdxHwm5lSZZd5jCw7kbpMz24hTurTcM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PcJ0DR8dSdcxs7IxOY8grNDrziq3NfdwPFr4rPGf6UjCkRzk2bVFOFaD7pVcutZhE
	 qUUiouDUCBOwn7FAo13h7gJstzTvwm0j4NmtHlOKRBiNkueVOKl1Ra6PDbMT/nT5gv
	 XGF5x4pRGyDMQ+FeQe881SFGUZU156jJnsZKsqWVkvc6VwvuF6EZYHqMeLBxEg79E+
	 gK09oq9UV/X88t/bgCgWXgWsOUVyphE1xJVxlWMv3fFuyIcpXrNcqhVx+eo1JknUsW
	 NazqSLP0rUxqfc3Wy8mL1lN3zA05tWR2lhrfRNxrf1Fh3WARQ48nxIF+cNQOGH92ua
	 9msPKa/XZEf6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/12] nvdimm: virtio_pmem: stop allocating child
 flush bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Chen" <me@linux.beauty>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260630092338.2094628-5-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
 <20260630092338.2094628-5-me@linux.beauty>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 10:28:16 +0000
Message-Id: <20260630102817.24AA31F00A3A@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14677-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:me@linux.beauty,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,smtp.kernel.org:mid,lists.linux.dev:replyto,lists.linux.dev:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4B5966E2E3A

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Block I/O Forward Progress / Deadlock due to missing mempool backi=
ng for flush allocations
--

commit e290d67d3c09c47f258d895e86c79743d39db2c1
Author: Li Chen <me@linux.beauty>

nvdimm: virtio_pmem: stop allocating child flush bio

This commit avoids allocating a child PREFLUSH bio during REQ_FUA
submission by queuing an ordered WQ_MEM_RECLAIM work item. It allows
provider flush callbacks to return NVDIMM_FLUSH_ASYNC after taking
ownership of parent bio completion.

> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 4176046627beb..8e16b7780be1a 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c

[ ... ]

> @@ -107,30 +113,46 @@ static int virtio_pmem_flush(struct nd_region *nd_r=
egion)
>  	return err;
>  };
> =20
> +static void virtio_pmem_flush_work(struct work_struct *work)
> +{
> +	struct virtio_pmem_flush_work *flush;
> +	int err;
> +
> +	flush =3D container_of(work, struct virtio_pmem_flush_work, work);
> +	err =3D virtio_pmem_flush(flush->nd_region);

[ ... ]

>  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  {
> -	/*
> -	 * Create child bio for asynchronous flush and chain with
> -	 * parent bio. Otherwise directly call nd_region flush.
> -	 */
> -	if (bio && bio->bi_iter.bi_sector !=3D -1) {
> -		struct bio *child =3D bio_alloc(bio->bi_bdev, 0,
> -					      REQ_OP_WRITE | REQ_PREFLUSH,
> -					      GFP_ATOMIC);
> +	struct virtio_device *vdev =3D nd_region->provider_data;
> +	struct virtio_pmem *vpmem =3D vdev->priv;
> +	struct virtio_pmem_flush_work *flush;
> +	int err;
> =20
> -		if (!child)
> +	if (bio && bio->bi_iter.bi_sector !=3D -1) {
> +		flush =3D kmalloc_obj(*flush, GFP_NOIO);

[Severity: High]
Can this cause a deadlock during memory reclaim?

Order-0 allocations with GFP_NOIO (which includes __GFP_DIRECT_RECLAIM)
can loop indefinitely in the page allocator's slowpath rather than failing.

Since this lacks mempool backing and is directly in the block I/O
submission path, couldn't the block submission thread block waiting
for memory, deadlocking if memory cannot be freed without this block I/O
completing?

> +		if (!flush)
>  			return -ENOMEM;
> -		bio_clone_blkg_association(child, bio);
> -		child->bi_iter.bi_sector =3D -1;
> -		bio_chain(child, bio);
> -		submit_bio(child);
> -		return 0;
> +
> +		INIT_WORK(&flush->work, virtio_pmem_flush_work);
> +		flush->nd_region =3D nd_region;
> +		flush->bio =3D bio;
> +		queue_work(vpmem->flush_wq, &flush->work);

[Severity: High]
Is it safe to queue work on a WQ_MEM_RECLAIM workqueue when the worker
function performs a non-mempool-backed GFP_NOIO allocation?

If the system is under severe memory pressure, the workqueue falls back
to its rescuer thread to ensure forward progress. The rescuer executes
virtio_pmem_flush_work() -> virtio_pmem_flush(), which allocates memory:

drivers/nvdimm/nd_virtio.c:virtio_pmem_flush() {
    ...
    req_data =3D kmalloc_obj(*req_data, GFP_NOIO);
    ...
}

Since GFP_NOIO includes __GFP_DIRECT_RECLAIM, the rescuer thread could
block indefinitely in direct reclaim trying to allocate req_data. Doesn't
this stall the rescuer thread and prevent pending flush completions from
making forward progress?

> +		return NVDIMM_FLUSH_ASYNC;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630092338.2094=
628-1-me@linux.beauty?part=3D4

