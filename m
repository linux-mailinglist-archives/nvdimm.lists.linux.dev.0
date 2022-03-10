Return-Path: <nvdimm+bounces-3295-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC4D4D46A3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 13:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id DF7AB1C0AB4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 12:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCC357CE;
	Thu, 10 Mar 2022 12:17:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AD07A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 12:17:37 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 4A93E21106
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646914656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3hDMUGxVtatlNKnKtnB0OeCC/YkSCibjvhbGGDVrSqw=;
	b=wXRu3M0lYizrrEIHhUfGvd59qm2OncrD1QoXvQKsjrQWEVRcWs97Z8i5aHWRBAstqn6XZr
	DDh1ufCSoyjcZi9AwjTTBdCpOtwAaCZUtFT3vl0g+O7g5OI/PBj8kNWfzym6XaUJUQjNOb
	1xXjiFCR48hwjjGWt/Qz5FUTES9wMKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646914656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3hDMUGxVtatlNKnKtnB0OeCC/YkSCibjvhbGGDVrSqw=;
	b=AkI0Q+a5rQon5mAywDZhjkv9WXhBH/yxI4mVwWfio4cfWa+XRCKLBkxvUfFeZ7pbsBoqME
	HnpzzZz4ZJSWsXBg==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 423A4A3B96
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 12:17:36 +0000 (UTC)
Date: Thu, 10 Mar 2022 13:17:35 +0100
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Subject: Delivery by get send-email to mailing list fails
Message-ID: <20220310121735.GD3113@kunlun.suse.cz>
References: <20220310120531.4942-1-msuchanek@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310120531.4942-1-msuchanek@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hello,

I cannot send mail to the mailing list with get send-email.

The copy sent to me is delivered but the e-mail does not appear in the
mailing list archives.

Is there any way to fix this?

Thanks

Michal

On Thu, Mar 10, 2022 at 01:05:33PM +0100, Michal Suchanek wrote:
> With seed namespaces caught early on with
> commit 9bd2994 ("ndctl/namespace: Skip seed namespaces when processing all namespaces.")
> commit 07011a3 ("ndctl/namespace: Suppress -ENXIO when processing all namespaces.")
> the function-specific checks are no longer needed and can be dropped.
> 
> Reverts commit fb13dfb ("zero_info_block: skip seed devices")
> Reverts commit fe626a8 ("ndctl/namespace: Fix disable-namespace accounting relative to seed devices")
> 
> Fixes: 80e0d88 ("namespace-action: Drop zero namespace checks.")
> Fixes: fb13dfb ("zero_info_block: skip seed devices")
> Fixes: fe626a8 ("ndctl/namespace: Fix disable-namespace accounting relative to seed devices")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  ndctl/lib/libndctl.c |  7 +------
>  ndctl/namespace.c    | 11 ++++-------
>  ndctl/region.c       |  2 +-
>  3 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ccca8b5..110d8a5 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -4593,7 +4593,6 @@ NDCTL_EXPORT int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns)
>  	const char *bdev = NULL;
>  	int fd, active = 0;
>  	char path[50];
> -	unsigned long long size = ndctl_namespace_get_size(ndns);
>  
>  	if (pfn && ndctl_pfn_is_enabled(pfn))
>  		bdev = ndctl_pfn_get_block_device(pfn);
> @@ -4630,11 +4629,7 @@ NDCTL_EXPORT int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns)
>  				devname);
>  		return -EBUSY;
>  	} else {
> -		if (size == 0)
> -			/* No disable necessary due to no capacity allocated */
> -			return 1;
> -		else
> -			ndctl_namespace_disable_invalidate(ndns);
> +		ndctl_namespace_disable_invalidate(ndns);
>  	}
>  
>  	return 0;
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 257b58c..722f13a 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -1054,9 +1054,6 @@ static int zero_info_block(struct ndctl_namespace *ndns)
>  	void *buf = NULL, *read_buf = NULL;
>  	char path[50];
>  
> -	if (ndctl_namespace_get_size(ndns) == 0)
> -		return 1;
> -
>  	ndctl_namespace_set_raw_mode(ndns, 1);
>  	rc = ndctl_namespace_enable(ndns);
>  	if (rc < 0) {
> @@ -1130,7 +1127,7 @@ static int namespace_prep_reconfig(struct ndctl_region *region,
>  	}
>  
>  	rc = ndctl_namespace_disable_safe(ndns);
> -	if (rc < 0)
> +	if (rc)
>  		return rc;
>  
>  	ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_RAW);
> @@ -1426,7 +1423,7 @@ static int dax_clear_badblocks(struct ndctl_dax *dax)
>  		return -ENXIO;
>  
>  	rc = ndctl_namespace_disable_safe(ndns);
> -	if (rc < 0) {
> +	if (rc) {
>  		error("%s: unable to disable namespace: %s\n", devname,
>  			strerror(-rc));
>  		return rc;
> @@ -1450,7 +1447,7 @@ static int pfn_clear_badblocks(struct ndctl_pfn *pfn)
>  		return -ENXIO;
>  
>  	rc = ndctl_namespace_disable_safe(ndns);
> -	if (rc < 0) {
> +	if (rc) {
>  		error("%s: unable to disable namespace: %s\n", devname,
>  			strerror(-rc));
>  		return rc;
> @@ -1473,7 +1470,7 @@ static int raw_clear_badblocks(struct ndctl_namespace *ndns)
>  		return -ENXIO;
>  
>  	rc = ndctl_namespace_disable_safe(ndns);
> -	if (rc < 0) {
> +	if (rc) {
>  		error("%s: unable to disable namespace: %s\n", devname,
>  			strerror(-rc));
>  		return rc;
> diff --git a/ndctl/region.c b/ndctl/region.c
> index e499546..33828b0 100644
> --- a/ndctl/region.c
> +++ b/ndctl/region.c
> @@ -71,7 +71,7 @@ static int region_action(struct ndctl_region *region, enum device_action mode)
>  	case ACTION_DISABLE:
>  		ndctl_namespace_foreach(region, ndns) {
>  			rc = ndctl_namespace_disable_safe(ndns);
> -			if (rc < 0)
> +			if (rc)
>  				return rc;
>  		}
>  		rc = ndctl_region_disable_invalidate(region);
> -- 
> 2.35.1
> 

