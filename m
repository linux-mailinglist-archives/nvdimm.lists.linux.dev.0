Return-Path: <nvdimm+bounces-14616-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xpIjIoOPP2r9UQkAu9opvQ
	(envelope-from <nvdimm+bounces-14616-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 27 Jun 2026 10:53:23 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B556D180F
	for <lists+linux-nvdimm@lfdr.de>; Sat, 27 Jun 2026 10:53:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=XZBj3KvI;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14616-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14616-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C49A63021B19
	for <lists+linux-nvdimm@lfdr.de>; Sat, 27 Jun 2026 08:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA493769E6;
	Sat, 27 Jun 2026 08:53:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231A12949E0;
	Sat, 27 Jun 2026 08:53:14 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782550397; cv=pass; b=d2Kp3yDgXJJ3NSog4DAIExCg+S0YRk6AVNBPqGrxQQ69iHp0+GahBN0EiKKwYrInyip+ZbujWHt7gs6pJt727FnmNBLuYzuwG2xuDBpTyhNYvSd9bJcVFhDBrmMwDbmZH1XZDdzdxXxdLsc5Y+qWwpa1R52jaFaWzqoIKle8mag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782550397; c=relaxed/simple;
	bh=Rzk5L0awvCvWEAsORzQ9bQ2zCXjrnt8nmPAZ8JNHQu4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=E6041l+5OK6mFyCpV46kOzCOjtFFlzA7FDq8105jAVdIuDVHFDc01eVUoI1zUaD3WSRzXjz1wyUPSLpUpvnmYpS853zZV94H/PDbbBHyOZRbXbspiqHpSEmo3f/jNu3iCGq56V0loV+zu728mDAZF02wAuNtsrQRr/i2jSsT6ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XZBj3KvI; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782550392; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FrklaJkEGMZdRVcDiAEIPgrUcTprK/8kYOEiW6q+SQkLSFExW/AX3ctsszbvkJ/+bqTTEZP9pgV+ZYY1+WPqrPSZp+mxl89X1jUF2/d89YLJpXKCm69uFfTbuslWaGROCUZ6/H06fIWChXgmzTwxfg15jnAzIs7txpTXAkss4YU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782550392; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XRr9atgIwN93/df1+0fKjKE769Lk7ZWwqIUKWgTaXI0=; 
	b=S9U3g6IAkOG2Aebq4/3QTCfu9WvtMJB0QbGEbFZnyrM4NgZPw7G19Su+FtLHavyam7Ci1ttrYZ1DSfy5avgA6YuRA/4dAyxPVDWWbbd5x3+o7HEYsVIw2UADh08nOH8BxGJkv1JBRyP1tcxvBMUTxkT9Hzvg9ZwstfmlgN+xvKI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782550392;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XRr9atgIwN93/df1+0fKjKE769Lk7ZWwqIUKWgTaXI0=;
	b=XZBj3KvIKN7rvDGGIzY+5oB/YwZnfyv4m90tUs5TcyRcCeeLOe/6oUoXURVWwVsM
	qCmgeRzVlinh5siLdJWxKvLYnJhgQJlo36DvGaMiRKNG3JpKRS900gUIcRZeI5CmrJO
	2waS5UEG5WQDuPGit9m/rMlttoiyawcELroNiIeA=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1782550391677430.979504149547; Sat, 27 Jun 2026 01:53:11 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1782550389067617.6778432013716; Sat, 27 Jun 2026 01:53:09 -0700 (PDT)
Date: Sat, 27 Jun 2026 16:53:08 +0800
From: Li Chen <me@linux.beauty>
To: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>,
	"Alison Schofield" <alison.schofield@intel.com>,
	"virtualization" <virtualization@lists.linux.dev>,
	"nvdimm" <nvdimm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19f084860c8.3959ac405441214.5537045160824133666@linux.beauty>
In-Reply-To: <CAM9Jb+hf6KEWRKtWr6PQByRQ869jL6Ws7J_ShFjKY_YicTbS_g@mail.gmail.com>
References: <20260621130246.2973254-1-me@linux.beauty> <20260621130246.2973254-2-me@linux.beauty> <CAM9Jb+hf6KEWRKtWr6PQByRQ869jL6Ws7J_ShFjKY_YicTbS_g@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] nvdimm: preserve flush callback errors
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.15 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linux.beauty,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_FROM(0.00)[bounces-14616-lists,linux-nvdimm=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:pankaj.gupta.linux@gmail.com,m:dan.j.williams@intel.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:alison.schofield@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:pankajguptalinux@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[linux.beauty:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C7B556D180F

Hi Pankaj,

 ---- On Tue, 23 Jun 2026 17:46:20 +0800  Pankaj Gupta <pankaj.gupta.linux@=
gmail.com> wrote ---=20
 > > nvdimm_flush() currently converts any non-zero provider flush error to
 > > -EIO. That loses useful errno values from provider callbacks.
 > >
 > > A local virtio-pmem mkfs sanity test showed the masking clearly:
 > >
 > >   wipefs: /dev/pmem0: cannot flush modified buffers: Input/output erro=
r
 > >   mkfs.ext4: Input/output error while writing out and closing file sys=
tem
 > >   nd_region region0: dbg: nvdimm_flush rc=3D-5
 > >
 > > The virtio-pmem callback can return -ENOMEM when async_pmem_flush() fa=
ils
 > > to allocate a child flush bio, but nvdimm_flush() hides that as -EIO b=
efore
 > > pmem_submit_bio() converts it to a block status.
 > >
 > > Return the provider callback error directly. The generic flush path st=
ill
 > > returns 0, and pmem_submit_bio() already handles errno-to-blk_status
 > > conversion for bio completion.
 > >
 > > Signed-off-by: Li Chen <me@linux.beauty>
 > > ---
 > > v3->v4:
 > > - New patch.
 > >
 > >  drivers/nvdimm/region_devs.c | 6 ++----
 > >  1 file changed, 2 insertions(+), 4 deletions(-)
 > >
 > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs=
.c
 > > index e35c2e18518f0..0cd96503c0596 100644
 > > --- a/drivers/nvdimm/region_devs.c
 > > +++ b/drivers/nvdimm/region_devs.c
 > > @@ -1114,10 +1114,8 @@ int nvdimm_flush(struct nd_region *nd_region, s=
truct bio *bio)
 > >
 > >         if (!nd_region->flush)
 > >                 rc =3D generic_nvdimm_flush(nd_region);
 > > -       else {
 > > -               if (nd_region->flush(nd_region, bio))
 > > -                       rc =3D -EIO;
 > > -       }
 > > +       else
 > > +               rc =3D nd_region->flush(nd_region, bio);
 >=20
 > IIRC this was introduced as a generic populate error type since a
 > failed flush can also propagate host-side errors, which may not be
 > relevant to the guest.
 > That said, we could still consider handling specific cases like
 > -ENOMEM, unless there is a better approach to address this.

Ah, yes, you are absolutely right. I went too far here.

Regards,
Li=E2=80=8B



