Return-Path: <nvdimm+bounces-14595-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bDNJCq5yPWoR3QgAu9opvQ
	(envelope-from <nvdimm+bounces-14595-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:25:50 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7274D6C82E8
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:25:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CS+5uu+I;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14595-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14595-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5859A303C4D3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB77630F7EB;
	Thu, 25 Jun 2026 18:23:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECA630566D;
	Thu, 25 Jun 2026 18:23:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411819; cv=none; b=Tnkclmsba6KP7p0+gnYWwR0eXJAZOT1qy+UMQWkoXFSPHQPwAX0xPSU6USXpTl5a1KZGuNaVLXNv3jR50YG6wUDUpvJfAHxCfsaahYViexZELhWzoHq4gld+Kf/JEOXu70r8QOi7nE0suJ2hzm3+1fMvKUedJRORwoZvQVxYS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411819; c=relaxed/simple;
	bh=OwKUqxlGbPsWvu9qthqwCqAWAlOWYOUFpMgWUwZAAXI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SvF1sFK9GX5nVNhH6lyI7gQ2iZHRAjO6wsCWvjrq1OH6+NcRgPK+4Q8n53EkeMXGYtenKMI9s2NdIrC2s8RO/MtHg4Bv74vheU483+hSyyFS5rfjZoT4W9gVEBM47egtQo4XUtQNnumspIrLqsxTPXtMjo2ARXH6VlYgMtKugCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CS+5uu+I; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D111F000E9;
	Thu, 25 Jun 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411818;
	bh=xLhZFNhS3+ZXz2n8oW+J5yqGYjG7Lw07ccDp0qGfycA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CS+5uu+IF1BiT8nq903h0nTEZlqpvmHDy20kzC0bvi8Qrd6hJqGv7eWce8SsKPaMK
	 UZlxFl2EAQpDvSrScmfy1fWqbi6mDlcWRYb4XkJJxiDeQE1t/rJSjAJCVAPZDBZnW/
	 InzZX86LxT5AYG87yc6Ag9dCF5BLBqw2nM703fJ8lcSqFb1CiC+hri+G4Ro3BfGKA3
	 JmroLvF5CzArUlEAQERx8FzuiykV1VsJesmmQFhjSG8vxH45PzPxG4u+4xlhs9Xiq1
	 GnUxRYKIv0yp8RKefNNs6jZz96Af37FeRtcwVUKtGS7lzuBd28AAU3qsCKl8CISNh8
	 cotP/fObRsgNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 19/31] cxl/extent: Enforce cross-region tag
 uniqueness
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-20-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-20-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:23:37 +0000
Message-Id: <20260625182337.F1D111F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14595-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,smtp.kernel.org:mid,lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7274D6C82E8

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Use-after-free of `tag_group` in `cxl_realize_group()` when extent=
 addition fails.
- [High] Data race on `group->nr_extents` during concurrent extent device r=
elease leading to UAF/leak.
--

commit 0105c4aa2861118ac775e4aaac54f4e888f84aa2
Author: Anisa Su <anisa.su887@gmail.com>

cxl/extent: Enforce cross-region tag uniqueness

This patch adds a host-wide registry of live tag groups with non-null uuids
to ensure that tag uuids are unique across all regions and memdevs. It
updates alloc_tag_group() to register new tags, free_tag_group() to
unregister them, and validation logic to reject conflicting tags.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index a590a89f35802..36be56ca10974 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c

[ ... ]

>  static void free_tag_group(struct cxl_dc_tag_group *group)
>  {
> +	cxl_tag_unregister(group);
>  	xa_destroy(&group->dc_extents);
>  	/* Drop the pin taken in alloc_tag_group(). */
>  	put_device(&group->cxlr_dax->dev);

[Severity: High]
Can this lead to a use-after-free of the tag_group pointer?

If xa_insert() fails (e.g., due to -ENOMEM) for the first extent in
cxlr_add_extent(), the allocated tag_group is retained in
mds->add_ctx.group but its dc_extents xarray remains empty.

Back in cxl_realize_group(), the loop continues and eventually extracts
this empty tag_group:

cxl_realize_group() {
        ...
        tag_group =3D mds->add_ctx.group;
        ...
        rc =3D online_tag_group(tag_group, !existing);
        ...
        if (existing)
                rc =3D __cxlr_notify_extent(tag_group->cxlr_dax->cxlr, ...
}

If online_tag_group() iterates over the empty xarray, decrements
group->nr_extents to 0, frees the tag_group via free_tag_group(), and
returns 0 (success), won't cxl_realize_group() then proceed to
dereference the freed tag_group pointer when calling
__cxlr_notify_extent() or cxlr_notify_extent()?

[Severity: High]
Can a data race occur on group->nr_extents during concurrent releases?

The group->nr_extents counter is decremented with a non-atomic
group->nr_extents-- in both dc_extent_release() and rm_tag_group().
Because sysfs files like length and offset are world-readable,
unprivileged userspace processes can hold references to multiple extents
within the same tag group.

If these processes close the sysfs files concurrently,
dc_extent_release() executes on multiple CPUs concurrently.

If one CPU reads the counter, and a second CPU reads, decrements, and
frees the tag_group via free_tag_group(), won't the first CPU then
write to the nr_extents field of the freed memory?

>  	kfree(group);
>  }

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D19

