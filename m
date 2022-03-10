Return-Path: <nvdimm+bounces-3298-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A6C4D480C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 14:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 956701C0EF5
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 13:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32F257DD;
	Thu, 10 Mar 2022 13:29:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3577A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:29:38 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7A6511F381
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646918976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiAsEvCPcvJBF5iVULktYrnYMAclaObP1uWa7nXHr7U=;
	b=C46YD1kqWJxb73utdkrRE009s/42LCdS2ukg1uKVEQkNQDxlY3MMsn95EiVuTAGZiLyQcK
	7x16zWdkohfe6QZ9OlEUtNsd4n3u5B7e8XFEkjI2SEmwH6HZE607qHtr25Kk5wr6i964Ld
	GjXj7J/LQgHSQcl5MstJ5U7pt+XMIDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646918976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiAsEvCPcvJBF5iVULktYrnYMAclaObP1uWa7nXHr7U=;
	b=ltC2w/F5z/7CX2hZghpsX+QEmj5utZxOMtdp30bN6YGjYJvyn1Kx46aEVZ24aKvAKLDk0c
	PYVFi3hBJLCraJAQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 6EF17A3B8A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:29:36 +0000 (UTC)
Date: Thu, 10 Mar 2022 14:29:35 +0100
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Subject: Re: Delivery by git send-email to mailing list fails
Message-ID: <20220310132935.GF3113@kunlun.suse.cz>
References: <20220310120531.4942-1-msuchanek@suse.de>
 <20220310121735.GD3113@kunlun.suse.cz>
 <20220310125436.GE3113@kunlun.suse.cz>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220310125436.GE3113@kunlun.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 10, 2022 at 01:54:36PM +0100, Michal Such�nek wrote:
> On Thu, Mar 10, 2022 at 01:17:35PM +0100, Michal Such�nek wrote:
> > Hello,
> > 
> > I cannot send mail to the mailing list with get send-email.
> > 
> > The copy sent to me is delivered but the e-mail does not appear in the
> > mailing list archives.
> > 
> > Is there any way to fix this?
> 
> Apparently the list is subscriber-only. This is unusual for mailing
> lists related to kernel development, and is not documented.

Actually, this has nothing to do with subscription. So in the end I have
no idea why e-mail sent by git send-email is not delivered to the list
while e-mail authored in a MUA works fine.

> 
> Please update the documentation or the mailing list settings.
> 
> > 
> > Thanks
> > 
> > Michal
> > 
> > On Thu, Mar 10, 2022 at 01:05:33PM +0100, Michal Suchanek wrote:
> > > With seed namespaces caught early on with
> > > commit 9bd2994 ("ndctl/namespace: Skip seed namespaces when processing all namespaces.")
> > > commit 07011a3 ("ndctl/namespace: Suppress -ENXIO when processing all namespaces.")
> > > the function-specific checks are no longer needed and can be dropped.
> > > 
> > > Reverts commit fb13dfb ("zero_info_block: skip seed devices")
> > > Reverts commit fe626a8 ("ndctl/namespace: Fix disable-namespace accounting relative to seed devices")
> > > 
> > > Fixes: 80e0d88 ("namespace-action: Drop zero namespace checks.")
> > > Fixes: fb13dfb ("zero_info_block: skip seed devices")
> > > Fixes: fe626a8 ("ndctl/namespace: Fix disable-namespace accounting relative to seed devices")
> > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > > ---
> > >  ndctl/lib/libndctl.c |  7 +------
> > >  ndctl/namespace.c    | 11 ++++-------
> > >  ndctl/region.c       |  2 +-
> > >  3 files changed, 6 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > > index ccca8b5..110d8a5 100644
> > > --- a/ndctl/lib/libndctl.c
> > > +++ b/ndctl/lib/libndctl.c
> > > @@ -4593,7 +4593,6 @@ NDCTL_EXPORT int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns)
> > >  	const char *bdev = NULL;
> > >  	int fd, active = 0;
> > >  	char path[50];
> > > -	unsigned long long size = ndctl_namespace_get_size(ndns);
> > >  
> > >  	if (pfn && ndctl_pfn_is_enabled(pfn))
> > >  		bdev = ndctl_pfn_get_block_device(pfn);
> > > @@ -4630,11 +4629,7 @@ NDCTL_EXPORT int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns)
> > >  				devname);
> > >  		return -EBUSY;
> > >  	} else {
> > > -		if (size == 0)
> > > -			/* No disable necessary due to no capacity allocated */
> > > -			return 1;
> > > -		else
> > > -			ndctl_namespace_disable_invalidate(ndns);
> > > +		ndctl_namespace_disable_invalidate(ndns);
> > >  	}
> > >  
> > >  	return 0;
> > > diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> > > index 257b58c..722f13a 100644
> > > --- a/ndctl/namespace.c
> > > +++ b/ndctl/namespace.c
> > > @@ -1054,9 +1054,6 @@ static int zero_info_block(struct ndctl_namespace *ndns)
> > >  	void *buf = NULL, *read_buf = NULL;
> > >  	char path[50];
> > >  
> > > -	if (ndctl_namespace_get_size(ndns) == 0)
> > > -		return 1;
> > > -
> > >  	ndctl_namespace_set_raw_mode(ndns, 1);
> > >  	rc = ndctl_namespace_enable(ndns);
> > >  	if (rc < 0) {
> > > @@ -1130,7 +1127,7 @@ static int namespace_prep_reconfig(struct ndctl_region *region,
> > >  	}
> > >  
> > >  	rc = ndctl_namespace_disable_safe(ndns);
> > > -	if (rc < 0)
> > > +	if (rc)
> > >  		return rc;
> > >  
> > >  	ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_RAW);
> > > @@ -1426,7 +1423,7 @@ static int dax_clear_badblocks(struct ndctl_dax *dax)
> > >  		return -ENXIO;
> > >  
> > >  	rc = ndctl_namespace_disable_safe(ndns);
> > > -	if (rc < 0) {
> > > +	if (rc) {
> > >  		error("%s: unable to disable namespace: %s\n", devname,
> > >  			strerror(-rc));
> > >  		return rc;
> > > @@ -1450,7 +1447,7 @@ static int pfn_clear_badblocks(struct ndctl_pfn *pfn)
> > >  		return -ENXIO;
> > >  
> > >  	rc = ndctl_namespace_disable_safe(ndns);
> > > -	if (rc < 0) {
> > > +	if (rc) {
> > >  		error("%s: unable to disable namespace: %s\n", devname,
> > >  			strerror(-rc));
> > >  		return rc;
> > > @@ -1473,7 +1470,7 @@ static int raw_clear_badblocks(struct ndctl_namespace *ndns)
> > >  		return -ENXIO;
> > >  
> > >  	rc = ndctl_namespace_disable_safe(ndns);
> > > -	if (rc < 0) {
> > > +	if (rc) {
> > >  		error("%s: unable to disable namespace: %s\n", devname,
> > >  			strerror(-rc));
> > >  		return rc;
> > > diff --git a/ndctl/region.c b/ndctl/region.c
> > > index e499546..33828b0 100644
> > > --- a/ndctl/region.c
> > > +++ b/ndctl/region.c
> > > @@ -71,7 +71,7 @@ static int region_action(struct ndctl_region *region, enum device_action mode)
> > >  	case ACTION_DISABLE:
> > >  		ndctl_namespace_foreach(region, ndns) {
> > >  			rc = ndctl_namespace_disable_safe(ndns);
> > > -			if (rc < 0)
> > > +			if (rc)
> > >  				return rc;
> > >  		}
> > >  		rc = ndctl_region_disable_invalidate(region);
> > > -- 
> > > 2.35.1
> > > 
> > 
> 

