Return-Path: <nvdimm+bounces-14605-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qqZlHIV0PWpl3QgAu9opvQ
	(envelope-from <nvdimm+bounces-14605-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:33:41 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2DD6C839F
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:33:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/s87PFH";
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14605-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14605-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 767273014567
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC413081BE;
	Thu, 25 Jun 2026 18:33:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339419D8A8;
	Thu, 25 Jun 2026 18:33:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412386; cv=none; b=oFZsn/wyRrdGi8Bop8kjCVwuTpHB+5hVcuITaQ3mouyEifU/n+v6VRHC0Au3ZI5ObL6Xpx3sHKhxjMkLDpdzfZa/28eeNudZSDaA1Fw+iRZWIlpMrMdTUPpzojxhbm0UjmPCnQi8y6SqcEydq/PjTJhWRNzXwMle0WAsHcnydFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412386; c=relaxed/simple;
	bh=yJhlXxy8fDWUN0v4APy/5DNNsBOpfI0BkFw2nP4bjOQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NVyQdRY/bAAcMFyMR2fF1g468R0SsnoefOlydOZTv6zVcBN5kavR/cBRfPPuoFe41LZE5O/gzIFKnJ7vMbMU/r9lv/Z1B0ooulFvYzpuVUiLqP+wO5vrDhW/PRehkoWRzoCRXrcAMV0WrffFuE5KGk+15uTuK67x90eiN1WbeZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/s87PFH; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF161F00A3F;
	Thu, 25 Jun 2026 18:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412385;
	bh=WmAbXu8MwNWAuD21/E7bHVR+VD1YPx9TBY/hbqJ91j8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a/s87PFHDyiBE75zcYmMagMtUyBB96/vbAMr4QTgZgMf6EiZzsjkOIpWLoicgxwEt
	 +Weq5vCiZZNW0hI6t8DRx2edjgbKiJnAVHW3E4Xd91W8Te0/3J+K3ueipRdJm80JmD
	 kj9XzsSM5XYC8lckS4BP0Ql9ht8seeW68LsXxR71QDH61KNhNe64y7HwUEzjMyWVvB
	 tcxekrtVJJ5WXU6ONtCjSgEOFNptg751cIRGxFNOCcta40AjdUXnfQxvLmXLrAwIsf
	 y0KqzP2+2wvLzdHl4PZKFd2YWRY225hobOiJEuix0N7R/r5Rgn26HHXa4J6VBJNk+M
	 5kUJzB152oVYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 20/31] cxl/region/extent: Expose dc_extent
 information in sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-21-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-21-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:33:04 +0000
Message-Id: <20260625183305.1AF161F00A3F@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14605-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:anisasu887@gmail.com,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url,smtp.kernel.org:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BD2DD6C839F

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double `xa_erase` race condition in `online_tag_group` error path =
can silently delete concurrently allocated extents.
- [High] Partial group accepted in `cxl_realize_group` on `cxl_add_extent` =
failure, violating More-chain atomicity.
--

commit 802d981e0cb1d1c5a24f7358b9d9626230786651
Author: Ira Weiny <iweiny@kernel.org>

cxl/region/extent: Expose dc_extent information in sysfs

Extent information can be helpful to the user to coordinate memory usage
with the external orchestrator and FM. Expose the details of each
dc_extent by creating sysfs entries.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 36be56ca10974..69c993cdd558b 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c

[ ... ]

> @@ -99,6 +154,7 @@ static void dc_extent_release(struct device *dev)
>  static const struct device_type dc_extent_type =3D {
>  	.name =3D "extent",
>  	.release =3D dc_extent_release,
> +	.groups =3D dc_extent_attribute_groups,
>  };

[Severity: High]
This is a pre-existing issue, but does the error path in online_tag_group()
have a race condition that could silently delete concurrently allocated
extents?

If dev_set_name() or device_add() fails in online_tag_group(), the error pa=
th
calls xa_erase() followed by put_device():

drivers/cxl/core/extent.c:online_tag_group() {
    ...
		rc =3D dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id,
				  dev->id);
		if (rc) {
			xa_erase(&cxlr_dax->dc_extents, dev->id);
			put_device(dev);
			break;
		}

		rc =3D device_add(dev);
		if (rc) {
			xa_erase(&cxlr_dax->dc_extents, dev->id);
			put_device(dev);
			break;
		}
    ...
}

However, put_device() synchronously invokes dc_extent_release(), which
unconditionally executes a second xa_erase() for the same id:

drivers/cxl/core/extent.c:dc_extent_release() {
    ...
	group =3D dc_extent->group;
	cxled_release_extent(dc_extent->cxled, dc_extent);
	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
    ...
}

Since the xarray is configured with XA_FLAGS_ALLOC1, a concurrent thread
processing another DCD event could allocate this id via xa_alloc() immediat=
ely
after the first xa_erase().

Could the second xa_erase() in the release function erroneously delete the
concurrent thread's newly allocated extent, breaking region capacity
accounting?


[Severity: High]
This is a pre-existing issue, but does the error handling in
cxl_realize_group() allow partial tag groups to be onlined?

If cxl_add_extent() fails for any extent in a More-chain group (e.g., due t=
o an
overlap or memory allocation failure), the loop calls delete_extent_node() =
and
executes continue:

drivers/cxl/core/mbox.c:cxl_realize_group() {
    ...
		if (cxl_add_extent(mds, pos->extent, seq_num, existing) < 0) {
			dev_dbg(dev,
				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
				tag,
				le64_to_cpu(pos->extent->start_dpa),
				le64_to_cpu(pos->extent->length));
			delete_extent_node(pos);
			continue;
		}
		group_cnt++;
    ...
}

By using continue, it bypasses the failure and leaves the remaining valid
extents in the group, resulting in a partial tag group being successfully
onlined.

Could this cause the host to surface a broken or incomplete DAX resource,
violating the architectural intent to either accept or reject tagged
allocations atomically?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D20

