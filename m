Return-Path: <nvdimm+bounces-14915-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id P9F2NS65U2oUeQMAu9opvQ
	(envelope-from <nvdimm+bounces-14915-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:56:30 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7551374546D
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:56:30 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOMK4crQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14915-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14915-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1F03300951C
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 15:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091BE33F5B3;
	Sun, 12 Jul 2026 15:56:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373ACA52;
	Sun, 12 Jul 2026 15:56:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871785; cv=none; b=k+jusBONjX18YV4d0IBeBKZWPcPTsecWE0lYrtBVFUhl6R5JXTBRKz2yiYzUhlBFx0BT7ZJpI4bZNC4DH5fV6Q/Jjick+wTpwCc8GOdewbdLYFaujzxCyhg4YF9eS/zirv56sfIFKA3FY08rxXr5ocupw6l/IjZKOkFyyyrpuEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871785; c=relaxed/simple;
	bh=GarHY/jkqVHjHyEtv3h1RPyr4dnJ/07P8f0OWP7tu1w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L+KPfkYzl97VyE1HJy6i9Q3Omq34yz/9qlbRtBkjnZOs3ltbfIzTGilkQuSk1quF2L91r0VEpM/4fAlqfY3qxBykPS2uq1SITJEMIaTnOKmIhZuPzFTlQeMdldfPEcV8WDf03S2nRrRVl+wpak6EzHL8EpGfsndPaQ7ahe3Qx2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOMK4crQ; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372671F000E9;
	Sun, 12 Jul 2026 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783871784;
	bh=qmhHQTdq+XBtdJ+21wlXh6cwR6EmZGKbMctgfapNuXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EOMK4crQdxXKWBwNCztiMkSrJsqDd54SIDb5mAWmDMnAtfz+kv6kfF8nxxPJJzGhI
	 I2TPJ9sxfdwugPbahxCjOH/bW1oAD6jvEvc088y+TqaQA2cqgkrycp5siT69/Y/fv/
	 2u0GcaJgxlOqSTRp9DzdpNgi/okb1bwS7KR8xY3V0ni1gSFLJCGq99YbNBrPpgfDxy
	 agDwgFlhOvGMmMYorFxaSAx3P98+dz+8VdWuEglDgscPLW6a5Wk0YctMY9a1b0pnl3
	 sHlAb8SYQr5qocx5T8leZmHzdXPR0pvlONVZD5jln/Y2Yfkn3i4KnIuD5aM675BNu3
	 N4K/u23Qe+v4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 07/10] dax/kmem: resolve default online type at probe
 time
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260712154505.3564379-8-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
 <20260712154505.3564379-8-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:56:23 +0000
Message-Id: <20260712155624.372671F000E9@smtp.kernel.org>
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
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14915-lists,linux-nvdimm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gourry.net:email,smtp.kernel.org:mid,lists.linux.dev:from_smtp,lists.linux.dev:replyto,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7551374546D

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Memory leak during device removal if any DAX ranges are too small =
after alignment.
--

--- Patch [7]: [PATCH v7 07/10] dax/kmem: resolve default online type at pr=
obe time ---
commit 4d3b2bc139f20f3d91088883d6dbe39863e79701
Author: Gregory Price <gourry@gourry.net>

dax/kmem: resolve default online type at probe time
   =20
Resolve the default online type in kmem at probe time explicitly
instead of implicitly inheriting the system default by calling
add_memory_driver_managed().

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 592171ec10f49..38ed5c4e9c83d 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c

[ ... ]

While reviewing this, I noticed a potential resource leak in another part of
the file:

> 		rc =3D dax_kmem_range(dev_dax, i, &range);
> 		if (rc)
> 			continue;
>=20
> 		/* range was never added during probe */
> 		if (!data->res[i]) {
> 			success++;
> 			continue;
> 		}

[Severity: High]
This is a pre-existing issue, but does this logic skip the success counter
increment when a memory range is too small?

If dax_kmem_range() returns -ENOSPC during probe for a small range, the
same check here in dev_dax_kmem_remove() will execute continue early.

This bypasses the success++ operation, which means the success counter
will remain strictly less than dev_dax->nr_range.=20

> 	if (success >=3D dev_dax->nr_range) {
> 		memory_group_unregister(data->mgid);
> 		kfree(data->res_name);
> 		kfree(data);
> 		dev_set_drvdata(dev, NULL);
> 		/* ... */
> 		clear_node_memory_type(node, NULL);
> 	}

Could this bypass the cleanup block entirely, permanently leaking the memory
group and driver data structures every time a device with unaligned or small
memory ranges is unbound?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712154505.3564=
379-1-gourry@gourry.net?part=3D7

