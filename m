Return-Path: <nvdimm+bounces-14297-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id e8QWDwZ0H2pqmAAAu9opvQ
	(envelope-from <nvdimm+bounces-14297-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 03 Jun 2026 02:23:34 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9979E6332FC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 03 Jun 2026 02:23:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=OdFVx25b;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14297-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14297-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A61F307BA34
	for <lists+linux-nvdimm@lfdr.de>; Wed,  3 Jun 2026 00:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1190920B80B;
	Wed,  3 Jun 2026 00:18:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F2D2253FC
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:18:02 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445883; cv=none; b=JsAjf/NywuBVqfAFZZd7TOPdvY2QhMclp7l6vhIXWHp9Zh9sV4n0XL1+iCMgDDwkJjGwR7ZL6sKiajF+1ikq2IBlM1ql8ISLfslWHTJulvZWTCqznRnM1Jg7YCtZhVFTGPMqHwK3qEaaTb7+oFMPvalT6IrJ9xL6iGkBwgWbCcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445883; c=relaxed/simple;
	bh=j5a4EnHiKf7RaWJzPddfZ7I45WAetzuNsDXT5s0Zq/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NzvoLRmvwnaY/c8meQ6R7p2290aU28RoJQ3q9X09/MqM/LOnDZCa28rPUB9YJNTDrerBMGxJU1tnKdh5m3JnE1DK2thsnI/eLV00DuybwfKPKtoxIISVD3QyOhg1L0SbJVTdc6QvKbob6e5mijDxM2XjTJXaoELxJdjduUh48yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OdFVx25b; arc=none smtp.client-ip=192.198.163.14
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445882; x=1811981882;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j5a4EnHiKf7RaWJzPddfZ7I45WAetzuNsDXT5s0Zq/w=;
  b=OdFVx25b0T/A6UbjwQ6CAfl1OYxGKurhTvdFDZZeKb8U4MkriV/6zb0k
   rhoiOk1EIj0T8w8aYvYWSB9riQwpB/j7huSxBCrCd/6WqPl9+uEcbJA07
   NZAbfBHH+/tAj/auEn3dvI26gP/qOX0eP0ZDnSusKNW4pb8BdHeGWDI6Z
   9uhB8eRRNLQB02ybydFTYwuqwHc2KEPeBQlh7JMOrT03gJAjlqRNcLQZ6
   cxoCGQiuws0prNbcSmy7nVwXPNwxbK5vwQtGbPwYkaEjEq+gtq5mhH3OG
   9Hh5TABClcOhV4zS3KbYC7uhXrgS388pOerij6slJGplDN/hUeKAFJcZw
   A==;
X-CSE-ConnectionGUID: rspwaf1RT5uN/le51FsHpQ==
X-CSE-MsgGUID: Ep5/Ic5xT+GgBMqArGQzQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81274796"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="81274796"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:18:02 -0700
X-CSE-ConnectionGUID: QqOEc7o8QeibjRKTdoq74w==
X-CSE-MsgGUID: zSlGOjfITn6UgTOfJDjhYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="244144753"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.108.56]) ([10.125.108.56])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:18:00 -0700
Message-ID: <0079f36f-0605-4ab4-97c6-5223340a2ebd@intel.com>
Date: Tue, 2 Jun 2026 17:17:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
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
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165037.6619-1-john@jagalactic.com>
 <0100019e79cb8953-e505a8dc-63a4-4bc3-a9bd-3b86ec081838-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cb8953-e505a8dc-63a4-4bc3-a9bd-3b86ec081838-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14297-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:john@jagalactic.com,m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,s:lists@lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,intel.com:mid,intel.com:dkim,intel.com:from_mime,intel.com:email,groves.net:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9979E6332FC



On 5/30/26 9:50 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Fix memory_failure offset calculation for multi-range devices. The old code
> subtracted ranges[0].range.start from the faulting PFN's physical address,
> which produces an incorrect (inflated) logical offset when the PFN falls in
> ranges[1] or beyond due to physical gaps between ranges. Add
> fsdev_pfn_to_offset() to walk the range list and compute the correct
> device-linear byte offset.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/fsdev.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee45..f315533b299e9 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
>   * The core mm code in free_zone_device_folio() handles the wake_up_var()
>   * directly for this memory type.
>   */
> +static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
> +{
> +	phys_addr_t phys = PFN_PHYS(pfn);
> +	u64 offset = 0;
> +
> +	for (int i = 0; i < dev_dax->nr_range; i++) {
> +		struct range *range = &dev_dax->ranges[i].range;
> +
> +		if (phys >= range->start && phys <= range->end)
> +			return offset + (phys - range->start);
> +		offset += range_len(range);
> +	}
> +	return -1ULL;
> +}
> +
>  static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
>  		unsigned long pfn, unsigned long nr_pages, int mf_flags)
>  {
>  	struct dev_dax *dev_dax = pgmap->owner;
> -	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
> +	u64 offset = fsdev_pfn_to_offset(dev_dax, pfn);
>  	u64 len = nr_pages << PAGE_SHIFT;
>  
>  	return dax_holder_notify_failure(dev_dax->dax_dev, offset,


