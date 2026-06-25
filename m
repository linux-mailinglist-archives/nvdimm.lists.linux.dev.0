Return-Path: <nvdimm+bounces-14598-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6TX9F11yPWr83AgAu9opvQ
	(envelope-from <nvdimm+bounces-14598-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:24:29 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CBE96C82D3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:24:28 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDQstgTN;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14598-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14598-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 70EF5300E14E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAA53148C2;
	Thu, 25 Jun 2026 18:24:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6189230F7EB;
	Thu, 25 Jun 2026 18:24:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411860; cv=none; b=XI3tr3Gt3ycLkT+NzCaadc85ExiYjUYtomfTj4f+28/UDoa+is5oGxb3CLH8NRKqctZoUorhXbnfanX6Id6i6eaTCfim4JsCkFOyBM/KWeXsCfpoZYitq401h/h/j8ub0cHfouFGR9LhkYGl1f/mySij3S2lT7LFkyUJkdalMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411860; c=relaxed/simple;
	bh=ry0sNvlVsC3aiFlZl10rkcmgEzrQiZ/FRb2tWDUolHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=djjjr7v61VL4Bpr1jDCoeLn+a2dxFOz3DheWDz5Y20JYVluFWOunNqoWsebwDRVDGZ80ihx5tcx4ov6UhfstbEnwP+MAPlWXemKz0X8sR4RSKmnzQ98K2OQDApP+7145GalEsxGOzDPAauUPPUJ8zaCLi/iFsMIiay7/+imiEYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDQstgTN; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F8E1F00A3A;
	Thu, 25 Jun 2026 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411859;
	bh=pTf2C5d2lFSXSvvib88PwjpdSQHTolWrGh+Vs7bY8GE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UDQstgTNQDItb1vIOCuIRtBywbNK4XMtnEdXxD3Z6K80785Xf+3P/Cwql0xtJQXdO
	 fcLaOgt/mUVoJrqsK1ChCxwi2oBiIEgdTkdPDRoVml1p3WM7PvhkS8nIOtcRR99p7k
	 47dCcMw6kvBcnHWNKJbP8dtr26FvQL0xcjxn7t0KHQnZlQ+lDEHMFxg2D3AANdrSUo
	 8VCIQq4EhA0ijtn97/Qju1A91MRxZGHO8EDTL6kip6jtDPCBIMCvsooKlFO41tHAQT
	 /pqEIPv52ArTV1E6JxUnhxPg+2k0XbrAnhGinO3MZsY1jF/4g7O81Qr1MdLbnOG8Tu
	 47Z6vsrEibNyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 17/31] cxl/mem: Enforce tag-group semantics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-18-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-18-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:24:18 +0000
Message-Id: <20260625182418.E9F8E1F00A3A@smtp.kernel.org>
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
	TAGGED_FROM(0.00)[bounces-14598-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url,smtp.kernel.org:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5CBE96C82D3

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Untagged extents spanning different DC partitions and DAX regions =
are incorrectly coalesced and assigned to the same region.
- [High] Fully duplicate extent groups are incorrectly rejected and omitted=
 from the device response.
--

commit c2cf18ae81b1c32953f39b06aeaa9e153f4ac609
Author: Anisa Su <anisa.su887@gmail.com>

cxl/mem: Enforce tag-group semantics

This commit completes tag-group validation. It adds sequence integrity
checks to verify that sharable partitions have dense shared_extn_seq
values, and verifies that tagged allocations do not span DC partitions.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 14ba263044f08..7967b0db2c512 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +static int cxl_check_group_partition(struct cxl_memdev_state *mds,
> +				     const uuid_t *tag,
> +				     const struct list_head *group)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	const struct cxl_dpa_partition *first_part =3D NULL;
> +	u64 first_dpa =3D 0;
> +	struct cxl_extent_list_node *pos;
> +
> +	if (uuid_is_null(tag) || list_empty(group))
> +		return 0;

[Severity: High]
This is a pre-existing issue, but does this explicit bypass for untagged
extents allow them to span different DC partitions?

If a device sends multiple untagged DC add capacity events spanning
different partitions, cxl_add_pending() appears to extract them all into a
single group.

Since this check returns 0 for null UUIDs, cxl_realize_group() processes th=
em
together. Would cxlr_add_extent() then register them all under the DAX regi=
on
of the first extent, effectively merging extents from different partitions =
into
the same region's resource tree?

[ ... ]

>  static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t =
*tag,
> -			     struct list_head *group, bool existing)
> +			     struct list_head *group, bool shareable,
> +			     bool existing)
>  {
>  	struct device *dev =3D mds->cxlds.dev;
>  	struct cxl_extent_list_node *pos, *tmp;
>  	struct cxl_dc_tag_group *tag_group;
>  	int group_cnt =3D 0;
> +	u16 seq_num;
>  	int rc;
> =20
> +	seq_num =3D -1;
>  	list_for_each_entry_safe(pos, tmp, group, list) {
> -		/*
> -		 * Pass the device-stamped 0-based shared_extn_seq through
> -		 * unchanged as the dax-side @seq_num (0..n-1).
> -		 */
> -		u16 seq =3D le16_to_cpu(pos->extent->shared_extn_seq);
> +		if (shareable)
> +			seq_num =3D le16_to_cpu(pos->extent->shared_extn_seq);
> +		else
> +			seq_num++;
> =20
> -		if (cxl_add_extent(mds, pos->extent, seq) < 0) {
> +		if (cxl_add_extent(mds, pos->extent, seq_num) < 0) {

[Severity: High]
This is a pre-existing issue, but what happens if a device resends a tag gr=
oup
where all extents have already been accepted?

If cxl_add_extent() detects a duplicate, it returns 0 without calling
cxlr_add_extent(). If this happens for every extent in the group,
mds->add_ctx.group is never allocated and remains NULL.

Does this cause the subsequent if (!tag_group) check in this function to dr=
op
the group and return -ENXIO instead of returning group_cnt to acknowledge
the extents back to the device?

>  			dev_dbg(dev,
>  				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
>  				tag,
> @@ -1412,15 +1532,22 @@ static int cxl_realize_group(struct cxl_memdev_st=
ate *mds, const uuid_t *tag,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D17

