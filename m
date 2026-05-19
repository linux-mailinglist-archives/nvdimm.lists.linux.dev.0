Return-Path: <nvdimm+bounces-14064-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0A8zGrRXDGodfwUAu9opvQ
	(envelope-from <nvdimm+bounces-14064-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 14:29:40 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 766BD57EB0A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 14:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2271930358E1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 12:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C814DA541;
	Tue, 19 May 2026 12:17:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA3A48C8BC
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 12:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193070; cv=none; b=l7jW3EmFBHh6fK1Xef+di2yBtJWQHUEn1bCjk0fWKwxmWeGjwnLpIMc06Dt9nojaLoA3tZB4tsiI0fg+CATHsVoP13249RAyX0U5A3yIfUyQaYnaBmbMpzDyF0JyTatJppzmZcPENep64QSfNbSC1/nGo3QW4MAQV53u2deYGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193070; c=relaxed/simple;
	bh=upXnea/syoigr+IoslHgr69Ts5eXS5P26WmSRRcg5io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9H4gbCPMTe/vsR4f5vqLHYDaMF29KG82eQ4l2sNvXTHRJkZZeAYFxDR1NUTEqIU9G+iEFpnnaULkfYJYnI71kl8NzSxIkKBcYwRarkS+AHwY/8pGbiyuGY7oKMgvTDMpuHZQRvN10IHfuNwr+GQDd/YdrZfSJpbELDB3vTu4ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F959402F1;
	Tue, 19 May 2026 12:17:41 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf18.hostedemail.com (Postfix) with ESMTPA id 6BF002F;
	Tue, 19 May 2026 12:17:37 +0000 (UTC)
Date: Tue, 19 May 2026 07:17:35 -0500
From: John Groves <John@groves.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/6] dax: fix misleading comment about share/index union
 in dax_folio_reset_order()
Message-ID: <agxU0XFIqRBc3xF1@groves.net>
References: <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
 <20260518213549.31246-1-john@jagalactic.com>
 <0100019e3d045be0-088bc509-0545-4e5a-b532-507045af78d0-000000@email.amazonses.com>
 <20260519123436.04aa1891@jic23-huawei>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519123436.04aa1891@jic23-huawei>
X-Stat-Signature: fwpwxiir9eti5i4k67qxoz3f3mibyrs4
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+Bj53NNfsYNYN4y3Hu23Z5pdDQWApk3TU=
X-HE-Tag: 1779193057-913965
X-HE-Meta: U2FsdGVkX1/anuJAk60Qwgc4AL5N9BtnfKb0pG3dFESwJLuzWFfGy6qyXSJQJF7bhQZg17nRGDKLJciEsdq9mU8u9zgvI8obye7qLbU33TMfasHRvOijLoxdXaal+joY7jRoL30vuOLbkEqZlM4xWdn/ukp+kmhG1haLf7CtV97C1QwfBosmuSwe69fzZMhWV3ithS2b/Ap7aneIqwLVKar/OpMMXmZFqYwbbOEF0LAqQHh6Y2DZGYbktgJ1jSmW7WvGV8GK0qBnHMLDM8ASBWwQa5LbCm60ifcKvFquzOZZ1/FrwBHsSqg4QPWu/RdgmNUs2O9s1DrpengQ9R03t0sco5/DQmN8huS0dqbA/wcnIQ2Wsb3IUtgGkHwJw/SGHt1Kq7SWzFl54dkXOmugQRh4Pa8hKZzR6++PEoHOPJVp9EfVr/XXRw6hJ7cr3KebO9JasHZL92oAM03+CCvQrg==
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14064-lists,linux-nvdimm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DMARC_NA(0.00)[groves.net];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,groves.net:mid,groves.net:email,jagalactic.com:email]
X-Rspamd-Queue-Id: 766BD57EB0A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 26/05/19 12:34PM, Jonathan Cameron wrote:
> On Mon, 18 May 2026 21:35:56 +0000
> John Groves <john@jagalactic.com> wrote:
> 
> > From: John Groves <John@Groves.net>
> > 
> > The comment in dax_folio_reset_order() claims that DAX maintains an
> > invariant where folio->share != 0 only when folio->mapping == NULL,
> > implying folio->share is zero whenever mapping is non-NULL. This is
> > misleading because folio->share and folio->index are a union -- for
> > non-shared folios with mapping != NULL, reading folio->share returns
> 
> Maybe for consistency refer to that as folio->mapping != NULL

Will do, thanks

> 
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
> > Signed-off-by: John Groves <john@groves.net>
> Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> 
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
> >  	 */
> >  	folio->mapping = NULL;
> >  	folio->share = 0;
> 

