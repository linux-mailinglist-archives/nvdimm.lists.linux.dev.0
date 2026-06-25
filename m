Return-Path: <nvdimm+bounces-14586-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ms8hHMRvPWqC3AgAu9opvQ
	(envelope-from <nvdimm+bounces-14586-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:13:24 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 893DA6C81CF
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 20:13:23 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFlUhI+i;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14586-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14586-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 055333098A44
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 18:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAE330D413;
	Thu, 25 Jun 2026 18:12:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D430FC26;
	Thu, 25 Jun 2026 18:12:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411141; cv=none; b=LFLuZY8PV0TJHLQHyB+x9zC5HbgIcW7llU4TsBO/84uGqbgVN7MZonLdF+snQu3dakac79aaxO+E4fTmXiKhADLaTibHhKkpJEj3aiMgu64WCdGKOld1FeOXaLcmY+W4e87eh+fY0CMVPSIf4fCCFg3uLOobJMc/4TvBx3AivU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411141; c=relaxed/simple;
	bh=vx1ac3c/GnlZUy9y/e+huMiL3iz/T0lADzE6Ij7fR6U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DMSZUZ6BM5CAQ95UEzmXRZGQTQBkeEH3K+DDbttV9B4GBJGUKvQ1Wg51qeg5fOL8Bm75nI73SXgYc/5tDUTv6CfNBjSrvIYVDLfMgy9MjKg1RIzn8OHp9e/NkMg89zxOGTSAra+5uc2/ICge4VHErtySMvOI6Isqj4b8vhMRHXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFlUhI+i; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8B51F000E9;
	Thu, 25 Jun 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411139;
	bh=61aa1MbJBQ8vPMA1+8V3QhkuAJ6Gke/Ge/GCc0NcJks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QFlUhI+iMBmi2YzIP04Gheirm+bQhuIXAXHHYeGV/e13ocDytfDeMmoo9Hq2z7Wwv
	 Utv77lhC42pGkgFXyvdKsoBJMAqo5+zdOx2PVv+rRnU3MVx9NfgYavAB1ByVu3hO15
	 Vcot7rKotKuFnY92Pw/+VhozabfWo0yxXYqL7VsVJ3wXdOvVnxlei720yfA9L2wii/
	 SwUIERJpm4BngPtjiaedL29ecCUx7Gk8ohkCmG3Vi7peJoDKJRAnnxEbo4vJIprQhB
	 FcYNUE12lG+j6wbgBYQKP32jmRFcqrMfES5YE4TW02oyh3cpeUSdfR5mgCQ7es+qqp
	 IiWC6zwYjViaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 12/31] cxl/mem: Set up framework for handling DC
 Events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-13-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-13-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:12:18 +0000
Message-Id: <20260625181219.4E8B51F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14586-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,lists.linux.dev:replyto,lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,smtp.kernel.org:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 893DA6C81CF

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing DCD response on memory allocation failure leaves the devic=
e state machine permanently blocked while unconditionally clearing the even=
t log.
- [Medium] Stack-allocation optimization in `memdev_release_extent()` is de=
feated by an internal dynamic allocation in `cxl_send_dc_response()`.
- [Medium] Invalid `__counted_by` attribute on a little-endian struct membe=
r breaks bounds checking on big-endian architectures.
--

commit f5333550094fcaacb4e98dbf0c270b32ec17b506
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Set up framework for handling DC Events
   =20
Adds the support for receiving DC event records but defers
the real add/release logic to subsequent commits. Simply refuse all
extents for DC_ADD and ack all DC_RELEASE events for now. Forced
release is currently unsupported.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +static void memdev_release_extent(struct cxl_memdev_state *mds, struct r=
ange *range)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	struct cxl_extent extent =3D {
> +		.start_dpa =3D cpu_to_le64(range->start),
> +		.length =3D cpu_to_le64(range_len(range)),
> +	};
> +	struct cxl_extent_list_node node =3D { .extent =3D &extent };
> +	LIST_HEAD(extent_list);
> +
> +	dev_dbg(dev, "Release response dpa %pra\n", range);
> +
> +	/*
> +	 * Stack-allocated instead of kzalloc'ed to avoid potential -ENOMEM,
> +	 * which would prevent sending the release DC rsp.
> +	 */
> +	list_add_tail(&node.list, &extent_list);
> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))

[Severity: Medium]
The comment mentions stack-allocating to avoid -ENOMEM so we can ensure the
release DC response is sent.

However, cxl_send_dc_response() uses kzalloc() to allocate the
cxl_mbox_dc_response message:

    struct cxl_mbox_dc_response *response __free(kfree) =3D
                        kzalloc(pl_size, GFP_KERNEL);

Doesn't this dynamic allocation defeat the optimization, since memory
pressure could still cause kzalloc() to fail, preventing the release
response from being sent?

> +		dev_dbg(dev, "Failed to release %pra\n", range);
> +}

[ ... ]

> +static int handle_add_event(struct cxl_memdev_state *mds,
> +			    struct cxl_event_dcd *event)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	int rc;
> +
> +	rc =3D add_to_pending_list(&mds->add_ctx.pending_extents, &event->exten=
t);
> +	if (rc) {
> +		clear_pending_extents(mds);
> +		return rc;
> +	}

[Severity: High]
If add_to_pending_list() fails and returns -ENOMEM, we return early without
sending the required CXL_MBOX_OP_ADD_DC_RESPONSE command.

Since cxl_handle_dcd_event_records() drops the error and the event is clear=
ed
from the device log, will this leave the device state machine permanently
blocked waiting for a response that never arrives?

> +
> +	if (event->flags & CXL_DCD_EVENT_MORE) {

[ ... ]

> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h

[ ... ]

> +/*
> + * Add Dynamic Capacity Response
> + * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
> + */
> +struct cxl_mbox_dc_response {
> +	__le32 extent_list_size;
> +	u8 flags;
> +	u8 reserved[3];
> +	struct updated_extent_list {
> +		__le64 dpa_start;
> +		__le64 length;
> +		u8 reserved[8];
> +	} __packed extent_list[] __counted_by(extent_list_size);

[Severity: Medium]
Should this use __counted_by_le() instead of __counted_by()?

Since extent_list_size is explicitly little-endian (__le32), using
__counted_by() on big-endian architectures will result in the bounds checki=
ng
instrumentation reading an inflated integer value, leading to out-of-bounds
errors or kernel panics.

> +} __packed;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D12

