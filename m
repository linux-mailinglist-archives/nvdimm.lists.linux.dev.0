Return-Path: <nvdimm+bounces-6175-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD27732953
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Jun 2023 09:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 160EE2816A9
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Jun 2023 07:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422809446;
	Fri, 16 Jun 2023 07:54:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EC279F7
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 07:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686902068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LCwXsPaPd7Dj5AMUAfbDa6LnAHzyeLCA6sw8/b3X0Ho=;
	b=h8FWd4ZWoLbKP3a0FFusPZdqiw1rPe46zHP7CFBmwPKefJPR9/ilnBvzQLiwFwMn2GRjT0
	vqvIwSjHBuB4KP8bnlIFtTtJaG7ZhfzJqXTfnROj3Mdzt/CH1VF4lgnFEH3wkBTxYOhSif
	KdLSpdOwsypn1rIsydeHSGHoE2f4oXQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-zH6WAGKGMwCYHca-Ajx4YQ-1; Fri, 16 Jun 2023 03:54:25 -0400
X-MC-Unique: zH6WAGKGMwCYHca-Ajx4YQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f7e8c24a92so1327035e9.0
        for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 00:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686902064; x=1689494064;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCwXsPaPd7Dj5AMUAfbDa6LnAHzyeLCA6sw8/b3X0Ho=;
        b=fFW5OF38OOtXIhMQaslHL7M+SBFmuoz3cqBlxgqKXR50QgBozsm3R4Te77Yy8WQChI
         85pLCc82IFmWzQqyqwu12pfEMfa8Y5qjkaltFPEwqX0ao3l7cp1vHqEUH5MvaAaGkEct
         crX+2Zjgu2ws/hJ0oXRfmsENmgDcxiwoSUJ+w30Mi5GWjq+bCR+vtkYWxAQUBwlyvlsA
         odWiQaWGgevoXpVwH7EAF0VPvn5SoJAcA/30PJoMqZay0TBSUOOdieMTsASELImzREJC
         7B7gyHJG99l3aqxKCvndODZhp2KuvEOMJG5wnS8U7qNp0wLvKrzgtR0ITNC3XZ9V58a8
         fzdg==
X-Gm-Message-State: AC+VfDyvMwhYFyN7OrYRy7rSTrsjnqbrrDdfdsKLSjo0GXdDNWkYKSZU
	hGcgkaJlAvGBx2xfQMPnZCRcqSOBI+FJFtqdj7rJbWBkl1XMjpEWfyq6VtNfMMw1OPnzlqLafuB
	8EtJGajWTyVEwUDZP
X-Received: by 2002:a7b:ce85:0:b0:3f8:c5a6:7a8d with SMTP id q5-20020a7bce85000000b003f8c5a67a8dmr1006469wmj.12.1686902064528;
        Fri, 16 Jun 2023 00:54:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ57hUFJkB9ARA1uPg7u8sBxFriDIGC6XvjqrvDb1WUHap8aii1g0Wt8HyS0VoMZ5iYl6OcUQw==
X-Received: by 2002:a7b:ce85:0:b0:3f8:c5a6:7a8d with SMTP id q5-20020a7bce85000000b003f8c5a67a8dmr1006449wmj.12.1686902064164;
        Fri, 16 Jun 2023 00:54:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:9800:59ba:1006:9052:fb40? (p200300cbc707980059ba10069052fb40.dip0.t-ipconnect.de. [2003:cb:c707:9800:59ba:1006:9052:fb40])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c378800b003f195d540d9sm1431039wmr.14.2023.06.16.00.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 00:54:23 -0700 (PDT)
Message-ID: <aadbedeb-424d-a146-392d-d56680263691@redhat.com>
Date: Fri, 16 Jun 2023 09:54:22 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Vishal Verma <vishal.l.verma@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Huang Ying <ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
 <20230613-vv-kmem_memmap-v1-3-f6de9c6af2c6@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 3/3] dax/kmem: Always enroll hotplugged memory for
 memmap_on_memory
In-Reply-To: <20230613-vv-kmem_memmap-v1-3-f6de9c6af2c6@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.23 00:00, Vishal Verma wrote:
> With DAX memory regions originating from CXL memory expanders or
> NVDIMMs, the kmem driver may be hot-adding huge amounts of system memory
> on a system without enough 'regular' main memory to support the memmap
> for it. To avoid this, ensure that all kmem managed hotplugged memory is
> added with the MHP_MEMMAP_ON_MEMORY flag to place the memmap on the
> new memory region being hot added.
> 
> To do this, call add_memory() in chunks of memory_block_size_bytes() as
> that is a requirement for memmap_on_memory. Additionally, Use the
> mhp_flag to force the memmap_on_memory checks regardless of the
> respective module parameter setting.
> 
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   drivers/dax/kmem.c | 49 ++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 7b36db6f1cbd..0751346193ef 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -12,6 +12,7 @@
>   #include <linux/mm.h>
>   #include <linux/mman.h>
>   #include <linux/memory-tiers.h>
> +#include <linux/memory_hotplug.h>
>   #include "dax-private.h"
>   #include "bus.h"
>   
> @@ -105,6 +106,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   	data->mgid = rc;
>   
>   	for (i = 0; i < dev_dax->nr_range; i++) {
> +		u64 cur_start, cur_len, remaining;
>   		struct resource *res;
>   		struct range range;
>   
> @@ -137,21 +139,42 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   		res->flags = IORESOURCE_SYSTEM_RAM;
>   
>   		/*
> -		 * Ensure that future kexec'd kernels will not treat
> -		 * this as RAM automatically.
> +		 * Add memory in chunks of memory_block_size_bytes() so that
> +		 * it is considered for MHP_MEMMAP_ON_MEMORY
> +		 * @range has already been aligned to memory_block_size_bytes(),
> +		 * so the following loop will always break it down cleanly.
>   		 */
> -		rc = add_memory_driver_managed(data->mgid, range.start,
> -				range_len(&range), kmem_name, MHP_NID_IS_MGID);
> +		cur_start = range.start;
> +		cur_len = memory_block_size_bytes();
> +		remaining = range_len(&range);
> +		while (remaining) {
> +			mhp_t mhp_flags = MHP_NID_IS_MGID;
>   
> -		if (rc) {
> -			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> -					i, range.start, range.end);
> -			remove_resource(res);
> -			kfree(res);
> -			data->res[i] = NULL;
> -			if (mapped)
> -				continue;
> -			goto err_request_mem;
> +			if (mhp_supports_memmap_on_memory(cur_len,
> +							  MHP_MEMMAP_ON_MEMORY))
> +				mhp_flags |= MHP_MEMMAP_ON_MEMORY;
> +			/*
> +			 * Ensure that future kexec'd kernels will not treat
> +			 * this as RAM automatically.
> +			 */
> +			rc = add_memory_driver_managed(data->mgid, cur_start,
> +						       cur_len, kmem_name,
> +						       mhp_flags);
> +
> +			if (rc) {
> +				dev_warn(dev,
> +					 "mapping%d: %#llx-%#llx memory add failed\n",
> +					 i, cur_start, cur_start + cur_len - 1);
> +				remove_resource(res);
> +				kfree(res);
> +				data->res[i] = NULL;
> +				if (mapped)
> +					continue;
> +				goto err_request_mem;
> +			}
> +
> +			cur_start += cur_len;
> +			remaining -= cur_len;
>   		}
>   		mapped++;
>   	}
> 

Maybe the better alternative is teach 
add_memory_resource()/try_remove_memory() to do that internally.

In the add_memory_resource() case, it might be a loop around that 
memmap_on_memory + arch_add_memory code path (well, and the error path 
also needs adjustment):

	/*
	 * Self hosted memmap array
	 */
	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
		if (!mhp_supports_memmap_on_memory(size)) {
			ret = -EINVAL;
			goto error;
		}
		mhp_altmap.free = PHYS_PFN(size);
		mhp_altmap.base_pfn = PHYS_PFN(start);
		params.altmap = &mhp_altmap;
	}

	/* call arch's memory hotadd */
	ret = arch_add_memory(nid, start, size, &params);
	if (ret < 0)
		goto error;


Note that we want to handle that on a per memory-block basis, because we 
don't want the vmemmap of memory block #2 to end up on memory block #1. 
It all gets messy with memory onlining/offlining etc otherwise ...

-- 
Cheers,

David / dhildenb


