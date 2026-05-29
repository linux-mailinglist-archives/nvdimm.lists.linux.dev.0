Return-Path: <nvdimm+bounces-14226-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKTVDTgkGmow1wgAu9opvQ
	(envelope-from <nvdimm+bounces-14226-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 01:41:44 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C73609EA8
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 01:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 713573029720
	for <lists+linux-nvdimm@lfdr.de>; Fri, 29 May 2026 23:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C27381AE2;
	Fri, 29 May 2026 23:41:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40BE3403E4
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780098099; cv=none; b=etC2NexSDXeU7Co+Z1v7OuPsZWgRf3ytfMbh3LJnyt/CeF/WmfoFUI1XV1GBTP4UTAYfr3Kad10vA4pzDGLWnxiO8YEN07HqfgcaRgkxfBoEHrUp3OyBLCZaNeDsAsGcaWXZkvAhpB8Fr1uhEgV73elWPuyzsDrhhGHlnll4tA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780098099; c=relaxed/simple;
	bh=7Hq7Hr1vDE2ELNQTsfUEsIRDYrxMrM3MvbDsUQivLEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DS6tE4HFCbeCrGR13mMu/EQPXE2zhU54LXJHFVMMbcS/4eNd1+WA54s5OcprsHPwpepc2dEUnSRroZDcZwy9iMbm4Pyct226Rfr5GrNSRyz+AueAfupwkcpvqIwN3UewDLeTLRvBFk0OmGniuw1iIAnyE+NtK8fbt1I4flIvu2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8F4EA0248;
	Fri, 29 May 2026 23:41:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf02.hostedemail.com (Postfix) with ESMTPA id D8CDA8000E;
	Fri, 29 May 2026 23:41:31 +0000 (UTC)
Date: Fri, 29 May 2026 18:41:30 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 1/7] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
Message-ID: <ahojLGXcL4VC7DJF@groves.net>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191843.79132-1-john@jagalactic.com>
 <0100019e512043a6-62e6e881-6d31-48e2-86f0-bb2c32248f0a-000000@email.amazonses.com>
 <53fe6abc-00c4-449f-ab94-2632b2aa2928@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53fe6abc-00c4-449f-ab94-2632b2aa2928@intel.com>
X-Stat-Signature: h8jr471wng9sh57xhw8fm7uai4f99dgd
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18TlGrGY33hhVJG23QMIYSbX1V8ucJYbEM=
X-HE-Tag: 1780098091-496962
X-HE-Meta: U2FsdGVkX1+UlghcZMpeqnsuMAUxZPQMJH+x1HBYhB56rN3sQhehgLlM4J59JvNQOKFYfLseFGutk6+4FamT9JA+rJ7vuehPf0+wXnMAqtvSmqvsDXdGZhOzu4E5VPE1VSRQ4kL05JpajebBmRMWke4eBjuwqNYgINCJUjQupMM4CkDBliFiB+po0vCdHV+dsZRjYsy35656ewa/a4ktCCHUhIMytmPT1bAfzDuMqGSSNGBtBvayMDESLLAb/q3eDOaAOYAhemAkKs8Cp18ElBD9gsIzDkEYG7R5U0TV6SzJqJKrjVotyW+dZJnNZKrEdBhYWkHK3cYfnXEAissWz/aDtccCTB9Rv+f3gERSBCwaQTXSXvN0QBWfaIq6CBTfcYfYdLvRXf7gCj+jypxTTA==
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[groves.net];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_FROM(0.00)[bounces-14226-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A3C73609EA8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 26/05/26 04:07PM, Dave Jiang wrote:
> 
> 
> On 5/22/26 12:18 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > The comment in dax_folio_reset_order() claims that DAX maintains an
> > invariant where folio->share != 0 only when folio->mapping == NULL,
> > implying folio->share is zero whenever mapping is non-NULL. This is
> > misleading because folio->share and folio->index are a union -- for
> > non-shared folios with mapping != NULL, reading folio->share returns
> > the file page offset (folio->index), which is typically non-zero.
> > 
> > Reword the comment to accurately describe the union aliasing: the
> > assignment clears whichever interpretation of the union word is active
> > (index for non-shared folios, share for shared folios), which is correct
> > because the folio is being released in either case.
> > 
> > No functional change -- the code was already correct, only the
> > justification was wrong.
> > 
> > Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")
> > 
> > Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/dax.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 6d175cd47a99b..df19c9317d10e 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -392,12 +392,12 @@ int dax_folio_reset_order(struct folio *folio)
> >  	int order = folio_order(folio);
> >  
> >  	/*
> > -	 * DAX maintains the invariant that folio->share != 0 only when
> > -	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
> > -	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
> > -	 * Callers ensure share has been decremented to zero before
> > -	 * calling here, so unconditionally clearing both fields is
> > -	 * correct.
> > +	 * Clear the mapping and the index/share union word. folio->share
> > +	 * and folio->index occupy the same union in struct folio. For
> > +	 * non-shared folios (mapping != NULL), the union holds folio->index
> > +	 * (file page offset); for shared folios (mapping == NULL), it holds
> > +	 * folio->share (reference count). Either way, we are releasing the
> > +	 * folio and both fields should be zeroed.
> 
> In the old comments, there is the pre-condition that "callers ensure share has been decremented to zero before calling here." Is this precondition remain true? Maybe should leave that comment in if that is the case?

That precondition is no longer universally true. 

fsdev_clear_folio_state() calls this at probe time on folios that may be in 
arbitrary state. The new wording justifies the zeroing correctly for all 
callers: we are releasing the folio so both the mapping and the union word 
(whether it holds an index or a share count) must be cleared.

So I think this is right...

Thanks for the review Dave!
John

<snip>


