Return-Path: <nvdimm+bounces-12744-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFDvGSCPcWkLJAAAu9opvQ
	(envelope-from <nvdimm+bounces-12744-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jan 2026 03:44:48 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3FA610BA
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jan 2026 03:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CC2E84827D7
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jan 2026 02:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA14138F93D;
	Thu, 22 Jan 2026 02:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsWhMlgU"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4D25A33F
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 02:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769049871; cv=pass; b=OP/1XwCP2e/niNXL6PbkD3Y0bqFx1Bm08yLbCCiu57UCM9q1iCfb87lMhP4XTRc7wnBBm54c8qhy9dHuIxx8UAdd2ZxbzPGkJ/OBLzBrRd4h8AKlIpQTNEFQueDnf6rZgHOnGPMJLPsI5myXdNAz5+6ROoWwFABZAXahjwjuUgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769049871; c=relaxed/simple;
	bh=UR97j5oS5KW66h4wusIQPc7uR0tPcNE6widZpyUVWkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jm3zGfgp40UBPuYu3iHLiWD2SQjUVkyuAzBdF8paCiYm1UmVrgXjWvF0U+lIn9k5NlcT+5p+ebylaCD8KueREdFj2eZMoXxX7JM6LcJb+C+MY1DBczE0XLUznS5C2pYLOc0t//NxWkZgOd2+h+6AbT/w3gTbLpwqeqkzLua6xRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GsWhMlgU; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5029aa94f28so4282911cf.1
        for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 18:44:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769049863; cv=none;
        d=google.com; s=arc-20240605;
        b=WmGYZzGLDp/xTOPjJWjX11ND3LehRpxAIm6VvlZxONH1PYZV1S8+PRIvkF51f9qip4
         vpphuaU+uu2oGTAls+dU4vVvKl8JhnBvTJj8dnWpKklX527W1NjEFvFKk7TAFu4ghme7
         Rjp5yFzHayfTnJONIUFEHKJ8o6s7aEB8z59CkY2+ATfWuXhhYjZMlVqlZK6DWE/r9wP2
         7wiV+MQTfMJMpC8z5iGwAyK71w47GPFyr7c/G0uXscMwg1Nx/NxF+zb2OeKard6XVpeZ
         lL8MgrTFVD6z6/lT3ePvH8Ii1yJOzLfx1jgkQrrjncaO1SuO/ktJYJE20fsmXmAepLgF
         LZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eAtbLcPlbXwcqSlVRBCKJrrca7k4pIWb0vsbKliyQro=;
        fh=xDr3La4n4DBMu1zMxqMP+nbV9gKEgUkHYJ2ZAPVvqkk=;
        b=AsN5BeAgLpp0Gy44d8n88vzEpZSavfK3qzCVErO/oF/AGjfbr9soi0pQ5czKE85k9W
         T2GTeXZIrr0GHEiWV4wFFOf5jIfn/wYk3UseDj67+XaMb94iDaE9myHSLmNaw+GRhBSF
         Ygc+VRS4emm9uDN+3kw+Rew+/7BxK/YbV/RSxesEVqYTnaB/p0hUqzRM90yD0KKo0o20
         +S/QetUODiVeC8J890kJABHQIJnjSePzrCF2Zb0lgsh5lbwODwkN/P2CSzRQUPEUVgkO
         6ImyjnzNBAPkUyVjsAhrziukS9hOsQs0MbJFQClBNfUDXlO/nGq1oUdSh1zS5r+vwlvd
         U1Ug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769049863; x=1769654663; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAtbLcPlbXwcqSlVRBCKJrrca7k4pIWb0vsbKliyQro=;
        b=GsWhMlgUGil4jl2kRa0NSmsRMfi0dDoAj/Bir3gxFuSFH2C592hQ+xZXmZDMLk0CjK
         jJt4DrStxQE8LrnZCr/d8l4QErKaU0LXPBqDtHEhCc0iuoGNzGXH/CLWUvN9TZkSAlBl
         j0l01yqWP57sKINvMd8NBmnGYV3nXUzr+cYjmONoLh0YnSsnHM4kaXrIAkO1lOb+pDeU
         M2AyT+itOVVCi5BCUsrbkWvDGrCWuggRZWBlFQhQMvHgbSpPRqqGLEhXmwme7W5fS7IG
         8CJItrEak1WVFlOLB/fJCMjuHfxBPvsuGLbnbNkO5F6SeuDXEXE5JUHR7ZPgJ70Bm+6r
         CwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769049863; x=1769654663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eAtbLcPlbXwcqSlVRBCKJrrca7k4pIWb0vsbKliyQro=;
        b=opKVIx4eUpw85WMBA1vQuxxfc2dELrU3bT2c2Qz5ks+y8QDOQqfgfxdvhr6sPcOqA8
         7rQCG4vc+G81RXqNj1YREJraxz2PFwWIsQt+q6+WEOSkvasHj44xBB3/K0yGW057ADpg
         eGPgrOKC0ngFDNkFPfxcAfrsi7EwQ3K5RMMdexrxcsBDWeJcBpKovSihMgIe0tOXspzH
         kmyhUSGV68AaXN3R52k3HndCqIds2yd22xa/+8AeB8xs8qYfT72qfEyX8vy6xlVzAfnk
         NCIPNBxMWbP5/cd5WDRM7n0ZqrO4mT+Y4+bFb+A6afpeU06Kdw0E0TaLCw71LTMTI9ss
         4v9g==
X-Forwarded-Encrypted: i=1; AJvYcCUl+mtJY601Z+HoI5BUMKFmSwI9Smn6QiNACVrc/kkazqq8DEHTIp6BWhZA09c9glzebIMzDZc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNdyIJ7Nx56opgw8VPlc91OcHO59lrmvbUoQ8LyK+G+ptf+QaP
	PG4+c43YZ0Wq35Qmz1UQJ+Mae56JQufevcRy6sayPoo2RdFNcXcJBxKAzaCIY3FS1/tHgrglAaD
	WA0BQUgKvkdv8jO82mi1UN2O1x+M7vvo=
X-Gm-Gg: AZuq6aK91MVwjW3FHUFVbZh+LdE69XRutVGRf1tKr5Bway5f814I9kQ/ew91XVP7Pbx
	GHv5dMndxTL47d+E0nOCsaSKcy6vgO/CaoD8Q7LwFnOEQNk53yTkJM6nb4VreCF2sau/PiHWv5B
	exrYRqhwSkQc0M6J9sqjKqyO13oDXUKiwBMfzTkRrbweIw9rnA4BBJR2U0X/jFwilJmieWzX6Uc
	4Exp4dnFxwYqmLXBgwPPj9xr9ZjXOAs9xR2ay04lef0u1lW1fUUGtMT0iR3cneb6LwL6Q==
X-Received: by 2002:ac8:7c43:0:b0:4ed:bc0a:88c3 with SMTP id
 d75a77b69052e-502eb5b14b5mr24575241cf.33.1769049863440; Wed, 21 Jan 2026
 18:44:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-11-hch@lst.de>
 <20260122004451.GN5945@frogsfrogsfrogs>
In-Reply-To: <20260122004451.GN5945@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 21 Jan 2026 18:44:12 -0800
X-Gm-Features: AZwV_Qg4LxBvht9EBcr0hoT1-gc5FWfx00BC6aQnC2V2vC-gMfVpk6AU_v2RXiM
Message-ID: <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there is a read_ctx
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12744-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[gmail.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,lst.de:email]
X-Rspamd-Queue-Id: 1A3FA610BA
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 4:44=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Jan 21, 2026 at 07:43:18AM +0100, Christoph Hellwig wrote:
> > Move the NULL check into the callers to simplify the callees.  Not sure
> > how fuse worked before, given that it was missing the NULL check.

In fuse, ctx->read_ctx is always valid. It gets initialized to point
to a local struct before it calls into
iomap_read_folio()/iomap_readahead()

>
> Let's cc Joanne to find out then...? [done]
>
> --D
>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap/bio.c         | 5 +----
> >  fs/iomap/buffered-io.c | 4 ++--
> >  2 files changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> > index cb60d1facb5a..80bbd328bd3c 100644
> > --- a/fs/iomap/bio.c
> > +++ b/fs/iomap/bio.c
> > @@ -21,10 +21,7 @@ static void iomap_read_end_io(struct bio *bio)
> >  static void iomap_bio_submit_read(const struct iomap_iter *iter,
> >               struct iomap_read_folio_ctx *ctx)
> >  {
> > -     struct bio *bio =3D ctx->read_ctx;
> > -
> > -     if (bio)
> > -             submit_bio(bio);
> > +     submit_bio(ctx->read_ctx);
> >  }
> >
> >  static void iomap_read_alloc_bio(const struct iomap_iter *iter,
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 4a15c6c153c4..6367f7f38f0c 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -572,7 +572,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
> >               iter.status =3D iomap_read_folio_iter(&iter, ctx,
> >                               &bytes_submitted);
> >
> > -     if (ctx->ops->submit_read)
> > +     if (ctx->read_ctx && ctx->ops->submit_read)
> >               ctx->ops->submit_read(&iter, ctx);
> >
> >       iomap_read_end(folio, bytes_submitted);
> > @@ -636,7 +636,7 @@ void iomap_readahead(const struct iomap_ops *ops,
> >               iter.status =3D iomap_readahead_iter(&iter, ctx,
> >                                       &cur_bytes_submitted);
> >
> > -     if (ctx->ops->submit_read)
> > +     if (ctx->read_ctx && ctx->ops->submit_read)
> >               ctx->ops->submit_read(&iter, ctx);

I wonder if it makes sense to just have submit_read() take in the void
*read_ctx directly instead of it taking in the entire struct
iomap_read_folio_ctx. afaict, the other fields aren't used/necessary.

This patch as-is makes sense to me though.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

> >
> >       if (ctx->cur_folio)
> > --
> > 2.47.3
> >
> >

