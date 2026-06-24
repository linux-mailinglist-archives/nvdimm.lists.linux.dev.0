Return-Path: <nvdimm+bounces-14493-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id WjTVEF5dO2oQWwgAu9opvQ
	(envelope-from <nvdimm+bounces-14493-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 06:30:22 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 384076BB408
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 06:30:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4v04cQu;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14493-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14493-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 49F3030095D3
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 04:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBBE30DECE;
	Wed, 24 Jun 2026 04:30:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B742BD587
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 04:30:13 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275415; cv=none; b=qpjIkR/OMfJklUuxuhH+MIlibvO//YE3sn11W9ZCuQJg/90IHiXrO2e/JatQ5FxUEKLO8T0fcAvReV7FFzWmqfkxlnpn66G/Ok5JYpdmrsnrQ1mVrg0Xgxxse03PmMSAfJYMeAXcLCVFw5AZYu7GhcouYWUd3k7fU8JtDr4SAoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275415; c=relaxed/simple;
	bh=te02MGvWggn5yLlbLVy3r4gr8+VpGgdhMMg3uj/MBdY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OnVlWGgMvRckBlfcnX92m/wUBhnYu5uFGNNQdB9U1UB+oMcYIZrjTPo9KXyL1MA8Elh3MhDYbHSWxK3PSOj9UEg97MczrFy2RGWNYboMwQhX+cL5LsiswIPxymSyhSTwecIYGm/wHCP73dAYMpNKwp1oFz5ML6CGw9Hp+rvZdSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4v04cQu; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD331F000E9;
	Wed, 24 Jun 2026 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782275413;
	bh=DWQ+WQn/rwl+aGo9qtqh88aLfYDbf1G1AIth4FiOSyg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h4v04cQuO9sm6Or2BexlEuVOGfLmfsuQuDg1+QKSsoYdO0PSyQI4hd0iXMy8UrlZP
	 bhxYgBggUH98XXO9QNFKdlT38j48jOiB8PwdbCEhdMlEAwsROhSQlZ078bKzSA3bl2
	 VOP8hOKuPmU9bI2WTe0M8lLLuoOT72sKWioBcddhJMPQUtD2W1bh/etjTDtE+5u/Q/
	 NOS2KJNLRZz2q1R3qGzTZk9TrANlqBFlZeiq5qikMYmIz2Heg9rREvx7GDwXfOHlNe
	 EZTw8t58TNm542nYaeYiR1WI+jsS+I5iPMKA52wYWOW5nH6E4OrGdIr9VOnKdH8tEO
	 wsG13X3X9/HSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] libnvdimm/labels: reject an implausibly large
 on-media slot count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas via B4 Relay" <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260623-b4-disp-1f2c537a-v2-2-59af73f1f090@proton.me>
References: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
 <20260623-b4-disp-1f2c537a-v2-2-59af73f1f090@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 04:30:13 +0000
Message-Id: <20260624043013.9AD331F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14493-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:devnull+hexlabsecurity.proton.me@kernel.org,m:nvdimm@lists.linux.dev,m:devnull@kernel.org,s:lists@lfdr.de];
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
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm,hexlabsecurity.proton.me];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,proton.me:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 384076BB408

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The hardcoded cap of 64K for `nslot` breaks legitimate devices wit=
h large label storage areas and introduces a self-bricking behavior by reje=
cting natively generated label formats.
--

commit e9419d2283340d1b7069d74b83a7188e43fd5de9
Author: Bryam Vargas <hexlabsecurity@proton.me>

libnvdimm/labels: reject an implausibly large on-media slot count

This commit adds a 64K upper bound check on the nslot value read from the
media to prevent large allocations. It validates the nslot field in
__nd_label_validate() against the newly introduced NSINDEX_NSLOT_MAX.

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index ec12ce72cfe2c..ce1e43d67babe 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -202,6 +202,10 @@ static int __nd_label_validate(struct nvdimm_drvdata *=
ndd)
 		}
=20
 		nslot =3D __le32_to_cpu(nsindex[i]->nslot);
+		if (nslot > NSINDEX_NSLOT_MAX) {
+			dev_dbg(dev, "nsindex%d nslot: %u implausibly large\n", i, nslot);
+			continue;
+		}
[Severity: High]
Could this cause a regression by breaking legitimate devices with large
label areas?

If a device has a config_size larger than ~8.4MB, nvdimm_num_label_slots()
will naturally generate an nslot value greater than 64K.

When the kernel formats such a device in nd_label_write_index(), it writes
this unbounded nslot to the media:

drivers/nvdimm/label.c:nd_label_write_index() {
    ...
    if (flags & ND_NSINDEX_INIT)
        nslot =3D nvdimm_num_label_slots(ndd);
    ...
}

Will __nd_label_validate() then reject these newly initialized labels on the
next probe, making the namespaces inaccessible?

Also, does this check prevent the large allocation mentioned in the commit
message? Looking at nd_label_data_init(), the allocation appears to use
config_size directly before nslot is even read or validated.

 		if ((u64)nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->nsarea.config_size) {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623-b4-disp-1f=
2c537a-v2-0-59af73f1f090@proton.me?part=3D2

