Return-Path: <nvdimm+bounces-14805-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bVCUJzjhT2qopgIAu9opvQ
	(envelope-from <nvdimm+bounces-14805-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 19:58:16 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC2B734123
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 19:58:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=PVsTXJsh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14805-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14805-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 176803018EBF
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 17:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DAF4DB549;
	Thu,  9 Jul 2026 17:58:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB444DA53C;
	Thu,  9 Jul 2026 17:58:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783619885; cv=none; b=HokdmHxoXksxEHW+he9eqMlJ3ru+YUHDkWdnvSCmAR4jGdYJFXtyD5kxFZkO65H3vSQgEuAYjZ+v0xZo6fbike6mKeLeEjb5W8ofPb4JZxzDPfqWsK9/U6PdxRUH4Vtrz+nEv+fN989yoB5TqQcczXvzDv1kJWVmPOterb/hHJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783619885; c=relaxed/simple;
	bh=ueCfC8mj9W6I1SlYqEpl674vMNV2wFKokvVZLAzEXzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zr/BJlkbfc31imioGeBGIU4shkOYceQysX/Vv51Ck3OoCxanRTkNf7FqbjBcsqc/GQCnonJFvw0as4s4Ji0q4NbFb1zmSx617DN0WsqovxeUs9aIP7MWHZ0pHz0oxNUaWFtnqvyTYVSJ7d1XgKzi0NuU06UMKxHhZKiMgiyPvKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PVsTXJsh; arc=none smtp.client-ip=192.198.163.12
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783619884; x=1815155884;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ueCfC8mj9W6I1SlYqEpl674vMNV2wFKokvVZLAzEXzA=;
  b=PVsTXJsh6fU42lLh4QQE6DPqX9gOHnbjh4C7ahgq9rPY/1DldGvzAtOu
   ip7hCLXdkE2dWWXbKZUh9TAT9OnyHMkIH3sy2HoDIMptgbqjb3pBjQ3vV
   Z7FnbWmmbTl814a7FzD797g6m730A1aJ+bmHBw4clc/AsmE+x6eQDCvo7
   j68HMLPGHghnuIXst+8a+k4wku2WjnplEhhQQDu0l+f0iMCv7fBl0ihZm
   knag5MlROIsR0quqNSpCYbSczzWv7b3cvw27CPg8Up+5vlLulO0jK0FV6
   GQzQnGFG9FUF2HB1d7B3b85u+u4KwlFqi1OZeAAgUqyy3MWLm3RsPYmeE
   w==;
X-CSE-ConnectionGUID: INIwS+g3TB+vWv9CYLm+gQ==
X-CSE-MsgGUID: LVtG1VufTHybv/1l6OShEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88139590"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88139590"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:58:04 -0700
X-CSE-ConnectionGUID: hf/hEBL1SMaZOpk5XqzpzA==
X-CSE-MsgGUID: mMZej/BNT82mbag9beBfMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252920685"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:58:02 -0700
Message-ID: <c4e18591-137f-4827-b635-a8662a44fe9d@intel.com>
Date: Thu, 9 Jul 2026 10:58:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/10] mm/memory: add memory_block_aligned_range()
 helper
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-2-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14805-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:email,intel.com:from_mime,intel.com:email,intel.com:mid,intel.com:dkim,lists.linux.dev:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7AC2B734123



On 6/30/26 2:18 PM, Gregory Price wrote:
> Memory hotplug operations require ranges aligned to memory block
> boundaries.  This is a generic operation for hotplug.
> 
> Add memory_block_aligned_range() as a common helper in <linux/memory.h>
> that aligns the start address up and end address down to memory block
> boundaries.  Guard against end underflow when the range falls below the
> first memory block boundary, returning an empty range instead.
> 
> Update dax/kmem to use this helper.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/kmem.c     |  4 +---
>  include/linux/memory.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index a18e2b968e4d..592171ec10f4 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
>  	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
>  	struct range *range = &dax_range->range;
>  
> -	/* memory-block align the hotplug range */
> -	r->start = ALIGN(range->start, memory_block_size_bytes());
> -	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
> +	*r = memory_block_aligned_range(range);
>  	if (r->start >= r->end) {
>  		r->start = range->start;
>  		r->end = range->end;
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 463dc02f6cff..1783299073e4 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -20,6 +20,7 @@
>  #include <linux/compiler.h>
>  #include <linux/mutex.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/range.h>
>  
>  #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
>  
> @@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>  unsigned long memory_block_size_bytes(void);
>  int set_memory_block_size_order(unsigned int order);
>  
> +/**
> + * memory_block_aligned_range - align a physical address range to memory blocks
> + * @range: the input range to align
> + *
> + * Aligns the start address up and the end address down to memory block
> + * boundaries. This is required for memory hotplug operations which must
> + * operate on memory-block aligned ranges.
> + *
> + * Returns the aligned range. Callers should check that the returned
> + * range is valid (aligned.start < aligned.end) before using it.
> + */
> +static inline struct range memory_block_aligned_range(const struct range *range)
> +{
> +	struct range aligned;
> +
> +	aligned.start = ALIGN(range->start, memory_block_size_bytes());
> +	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
> +	/* No whole block fits (e.g. range below the first boundary): empty. */
> +	if (aligned.end <= aligned.start)
> +		aligned.start = aligned.end;
> +	else
> +		aligned.end -= 1;
> +
> +	return aligned;
> +}
> +
>  struct memory_notify {
>  	unsigned long start_pfn;
>  	unsigned long nr_pages;


