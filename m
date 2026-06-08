Return-Path: <nvdimm+bounces-14341-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id AbM9BH40J2ostQIAu9opvQ
	(envelope-from <nvdimm+bounces-14341-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 08 Jun 2026 23:30:38 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DF165AACF
	for <lists+linux-nvdimm@lfdr.de>; Mon, 08 Jun 2026 23:30:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b="Gz4/iYc7";
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14341-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14341-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B18913021EA0
	for <lists+linux-nvdimm@lfdr.de>; Mon,  8 Jun 2026 21:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8E83A5435;
	Mon,  8 Jun 2026 21:30:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999603ACEFE
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 21:30:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954218; cv=none; b=UaPwTucnSOIMxrY9/yAMtlnIZbwqauoOJkhEx5VOpjQImCFm7ShjkTfww/+3xrvAw/mPKZJyeGz5DvP3lsLwnPtdOJiqk5uHWbhNOU8RAsiQhBGMJEK5TJasSTGTid9ioHl9lOz2i9CMD6/yqlqDRnfkUlQQ0AMhSy+jjBmUwkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954218; c=relaxed/simple;
	bh=4qsxO9BikZyc6jOlZZ25PVxJzq1Gm3DpN6Oq2wyMrPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L8cP1m1y0ldTn2wBSrPztsirOWjY2jmBxpL9hUvVX0IStBqL0uuWADmePrFU/5DuV6Wwn/smsaT6A2H8LhpRFPM3cxWNPTSbGWWQiXMr+EXqx1akBy+CEArRh5IjZdiHtBWDwKEk+6zBnrBSeICwz8q2Ir1tm0Y8JhphGxDpudo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gz4/iYc7; arc=none smtp.client-ip=192.198.163.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780954217; x=1812490217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4qsxO9BikZyc6jOlZZ25PVxJzq1Gm3DpN6Oq2wyMrPI=;
  b=Gz4/iYc7yJdnJyo0x+XNv83CJTTWc014CvQ5hxi2Ykp77BtUF3iyRbPd
   x+Uw49QZcpp1+oqChE81f1N3k53EhRtURvsWeXLWhM0tPQ6FLB9UtvW9W
   4HzpToSSSr63G9tYsAl+rELSkHccjYh0VZ0in3wISHqstVwSXO5jWDeYJ
   voGKNz2vqctZIZbJxwYiZwhkGU7aEwR3oM0EtG+XGN7YS6OJYDosVBney
   Ofqvf3i56+RGcOd06zl/BOR7bxeaDmVSXajzXeNq7n/cioZgD/aYTyvN8
   fYrgRxrMkN9UwY229NEKhH/l4gBsPfjAXXWN3gBi7hT7Qmmw5bVysaEAP
   A==;
X-CSE-ConnectionGUID: 74AlFcOBSbG+JFkNmdZFag==
X-CSE-MsgGUID: och6nkMBRHappVmxJeFPHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="107142298"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="107142298"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:30:16 -0700
X-CSE-ConnectionGUID: uBx1zjrJQmCzXetftIkzJA==
X-CSE-MsgGUID: e4N8m7Z5Tg6YB1WFtKmqVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="242719981"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:30:14 -0700
Message-ID: <a248d046-6542-46f0-9167-96e3bdbedb7c@intel.com>
Date: Mon, 8 Jun 2026 14:30:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 4/9] dax/fsdev: don't leave a dangling dev_dax->pgmap
 on probe failure
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193333.94326-1-john@jagalactic.com>
 <0100019ea3939aab-4a2fe020-b29c-4648-ad01-08b091ef9627-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019ea3939aab-4a2fe020-b29c-4648-ad01-08b091ef9627-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14341-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:john@jagalactic.com,m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 60DF165AACF



On 6/7/26 12:33 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> After the dynamic path set dev_dax->pgmap, any later probe failure left
> dev_dax->pgmap dangling: devres frees the devm_kzalloc'd pgmap on probe
> failure, and subsequent probe attempts would hit the "dynamic-dax with
> pre-populated page map" check and fail permanently.
> 
> Factor pgmap acquisition out into fsdev_acquire_pgmap(), and defer the
> dev_dax->pgmap assignment until probe can no longer fail. A failed probe
> now never publishes the pointer at all, so there is nothing to unwind.
> This also matches kill_dev_dax(), which already clears the dynamic pgmap
> pointer on unbind: dev_dax->pgmap is now non-NULL only while the pgmap
> is actually valid.
> 
> Refactor suggested by Dave Jiang.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/fsdev.c | 77 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 49 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index dbd722ed7ab05..0fd5e1293d725 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -219,47 +219,62 @@ static const struct file_operations fsdev_fops = {
>  	.release = fsdev_release,
>  };
>  
> -static int fsdev_dax_probe(struct dev_dax *dev_dax)
> +/*
> + * Acquire the dev_pagemap for probe: the static (pre-populated) one if
> + * present, or a devm-allocated one for the dynamic case. Note that
> + * dev_dax->pgmap is not set here; fsdev_dax_probe() sets it only once
> + * probe succeeds, so a failed probe never leaves a dangling pointer
> + * to a devres-freed pgmap.
> + */
> +static struct dev_pagemap *fsdev_acquire_pgmap(struct dev_dax *dev_dax)
>  {
> -	struct dax_device *dax_dev = dev_dax->dax_dev;
>  	struct device *dev = &dev_dax->dev;
>  	struct dev_pagemap *pgmap;
> -	struct inode *inode;
> -	u64 data_offset = 0;
> -	struct cdev *cdev;
> -	void *addr;
> -	int rc, i;
> +	size_t pgmap_size;
>  
>  	if (static_dev_dax(dev_dax)) {
>  		if (dev_dax->nr_range > 1) {
> -			dev_warn(dev, "static pgmap / multi-range device conflict\n");
> -			return -EINVAL;
> +			dev_warn(dev,
> +				 "static pgmap / multi-range device conflict\n");
> +			return ERR_PTR(-EINVAL);
>  		}
>  
>  		pgmap = dev_dax->pgmap;
>  		pgmap->vmemmap_shift = 0;
> -	} else {
> -		size_t pgmap_size;
> +		return pgmap;
> +	}
>  
> -		if (dev_dax->pgmap) {
> -			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
> -			return -EINVAL;
> -		}
> +	if (dev_dax->pgmap) {
> +		dev_warn(dev, "dynamic-dax with pre-populated page map\n");
> +		return ERR_PTR(-EINVAL);
> +	}
>  
> -		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
> -		pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
> -		if (!pgmap)
> -			return -ENOMEM;
> +	pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
> +	pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
> +	if (!pgmap)
> +		return ERR_PTR(-ENOMEM);
>  
> -		pgmap->nr_range = dev_dax->nr_range;
> -		dev_dax->pgmap = pgmap;
> +	pgmap->nr_range = dev_dax->nr_range;
> +	for (int i = 0; i < dev_dax->nr_range; i++)
> +		pgmap->ranges[i] = dev_dax->ranges[i].range;
>  
> -		for (i = 0; i < dev_dax->nr_range; i++) {
> -			struct range *range = &dev_dax->ranges[i].range;
> +	return pgmap;
> +}
>  
> -			pgmap->ranges[i] = *range;
> -		}
> -	}
> +static int fsdev_dax_probe(struct dev_dax *dev_dax)
> +{
> +	struct dax_device *dax_dev = dev_dax->dax_dev;
> +	struct device *dev = &dev_dax->dev;
> +	struct dev_pagemap *pgmap;
> +	struct inode *inode;
> +	u64 data_offset = 0;
> +	struct cdev *cdev;
> +	void *addr;
> +	int rc, i;
> +
> +	pgmap = fsdev_acquire_pgmap(dev_dax);
> +	if (IS_ERR(pgmap))
> +		return PTR_ERR(pgmap);
>  
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct range *range = &dev_dax->ranges[i].range;
> @@ -306,7 +321,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	/* Detect whether the data is at a non-zero offset into the memory */
>  	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
>  		u64 phys = dev_dax->ranges[0].range.start;
> -		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
> +		u64 pgmap_phys = pgmap[0].range.start;
>  
>  		if (!WARN_ON(pgmap_phys > phys))
>  			data_offset = phys - pgmap_phys;
> @@ -339,7 +354,13 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		return rc;
>  
>  	run_dax(dax_dev);
> -	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +	if (rc)
> +		return rc;
> +
> +	/* Probe can no longer fail; expose the pgmap via dev_dax */
> +	dev_dax->pgmap = pgmap;
> +	return 0;
>  }
>  
>  static struct dax_device_driver fsdev_dax_driver = {


