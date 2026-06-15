Return-Path: <nvdimm+bounces-14420-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0J7eKWD8L2ogLQUAu9opvQ
	(envelope-from <nvdimm+bounces-14420-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 15:21:36 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06229686B12
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 15:21:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14420-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14420-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7153E305BB76
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 13:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6683F44F5;
	Mon, 15 Jun 2026 13:16:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274735C183
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 13:16:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529411; cv=none; b=mH4ofOg5P8dgTFTyWF1+r/R34wBTfsdez8eIn3zc2lHeHHGATvD+ZqxAmR7obhZNngHqYqqfCn9uvzGcKCUMqbhLN5TY1AjirJjpFeRW4Oz2y17JMviwwuLEc0o6hnZfulSiSOkeHQbTpI7im4UlXJve6PZwRh/OwZoncQ7I0ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529411; c=relaxed/simple;
	bh=pMREYlYHGc5Tkh4427Y9bIHLMo21yJ3BiQqtR+Ik0DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cd4olszkz3CMGqSoPTkhd30prCji2WgkiUDu3uMYSZ5PGl2sjF+yOTgGsebOwTTEpLRKqXG2tmC7V8RkAMtAJGwpGU9uQT0sOdYVmU2JVfr+VtqCREYfhlI/r80VhMPQuAlOlf7hlFGOjzxPDJzuhzXdMbSY/GzXtaNLkDUeEfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B6301A0A43;
	Mon, 15 Jun 2026 13:16:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf20.hostedemail.com (Postfix) with ESMTPA id 4B67020025;
	Mon, 15 Jun 2026 13:16:35 +0000 (UTC)
Date: Mon, 15 Jun 2026 08:16:34 -0500
From: John Groves <John@groves.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V5 3/9] dax/fsdev: clear vmemmap_shift when binding
 static pgmap
Message-ID: <ai_63hJ1pVP15nbc@groves.net>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173202.65935-1-john@jagalactic.com>
 <0100019eb7bdc5a7-f15b011c-0aee-411f-8d7c-2996345048e4-000000@email.amazonses.com>
 <ait0jiPmYrpwdEBW@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ait0jiPmYrpwdEBW@MWDK4CY14F>
X-Stat-Signature: bceddahxhdzmsy1ywk9uaa1bs1jhxk8y
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX180S01DUCi5FDR/O4kT1psh/9MvNKg99Gw=
X-HE-Tag: 1781529395-294135
X-HE-Meta: U2FsdGVkX1/yRQ3MVlQ8eTLP5Ts9BmNqPWWY2fNZ+FUtpXs1kVZ6A6CfA1mpsWl53a4KdsjiWoICOlSM6DVZ3IlMvcf5mhBIHVZykPnx/IjqIkM1QLn+iPXwX3NWjU/fmUl7n77sqW23ZS7ig/h+hKcM4uJo9vU1SpmVAhFcNTFch+2MnkwfzhypiMrPcnNAAw/najyhBXV6B6AwwnPSAKLfnqME/E+Y632/KTC9BOVGjH/8IEtXOu2a2IOJWYsaDlTWzMd2c8Q9ba/Q7qI+OVTTpYnhSsNLiw1++6+zFS2XpoGdTBDNZWzXtGNag2gxz5+JLzEGSBuLBPBAcx6przZ4NZIL/bhtIRuvVTivSFHn+zJxr6JNmpuYfj6jpFlP4bxk/2Wbr9zBuMS4X04Onw==
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14420-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[groves.net];
	FORGED_RECIPIENTS(0.00)[m:icheng@nvidia.com,m:john@jagalactic.com,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,s:lists@lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,groves.net:email,groves.net:mid,groves.net:from_mime,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 06229686B12

On 26/06/12 10:56AM, Richard Cheng wrote:
> On Thu, Jun 11, 2026 at 05:32:07PM +0800, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
> > device from device_dax (which may set vmemmap_shift based on alignment) to
> > fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
> > zero it before devm_memremap_pages() so the vmemmap is built for order-0
> > folios as fsdev requires.
> > 
> > Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> > 
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/fsdev.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> > index 2c5de3d80a618..52f46b3e245ea 100644
> > --- a/drivers/dax/fsdev.c
> > +++ b/drivers/dax/fsdev.c
> > @@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
> >  		}
> >  
> >  		pgmap = dev_dax->pgmap;
> > +		pgmap->vmemmap_shift = 0;
> 
> 
> Hello John,
> 
> I would suggest also clearing pgmap->ops and pgmap->owner on teardown.
> fsdev also writes them but never clears them. memuunmap_pages() leaves the
> descriptor intact and kill_dev_dax() only NULLs dev_dax->pgmap for !static case.
> After fsdev unbind the stale ops survive.
> If we do rmmod later a HW failure dispatch pgmap->ops->memory_failure.
> 
> --Richard

Good catch, thanks.

Adding a patch for V6 ("dax/fsdev: clear pgmap ops and owner on unbind")
-- a devm action that NULLs both on unbind, symmetric with setting them
at probe. It matters for the static case where the pgmap is shared and
long-lived; otherwise a later rebind or rmmod could dispatch
memory_failure through the stale handler.

John


