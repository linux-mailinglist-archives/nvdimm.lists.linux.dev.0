Return-Path: <nvdimm+bounces-6875-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E34E37DEE6C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Nov 2023 09:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A52D1281A0D
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Nov 2023 08:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8B979C7;
	Thu,  2 Nov 2023 08:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpKcaCHR"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224BB79C2
	for <nvdimm@lists.linux.dev>; Thu,  2 Nov 2023 08:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698915256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hhuacmLeEt55NlKgJNjvhJFIwCxPsLqMGQxNmIQI81g=;
	b=fpKcaCHRS23x9k968/hdwc/t+Mu4BjtaUaR7PCHtUxiHVrdaGXNK0PS5q6ntCbkT1mOKM2
	Btr0yfLXC1IDHHvhBcroyLfgqSLGoTmDWKbBeVtzlyW3mW3b8Wc4a88u8hU41ou6jZx0Ku
	D4HL3iAviM2wrqLlzANgkqg32DzBDfM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-md6qOM_6PpyG-knBMWLIwQ-1; Thu, 02 Nov 2023 04:54:15 -0400
X-MC-Unique: md6qOM_6PpyG-knBMWLIwQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4091c9bdb8eso10597795e9.1
        for <nvdimm@lists.linux.dev>; Thu, 02 Nov 2023 01:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698915254; x=1699520054;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhuacmLeEt55NlKgJNjvhJFIwCxPsLqMGQxNmIQI81g=;
        b=dGVo8Dcfwdkb9A95ld+5QcLwwsZfZHHh7Ku04l95/Dp3W1hY6/ves9qkHtH8Ut6Ry9
         EptqKVXoFVFKuh2V561zHdyhzIZZEsOe6j4MHFHeNGD4cPVt4VIXUiUhOs7xQ/cZIETY
         GgKDSg5AOcOPBr1ACj6+nptuEsZHrBnOXjL0HEh4Z72nD+fZeaOuYYGLqldasbFcwg0C
         3tmLqVfxV+Xj3E8nIeglJnX1Vu+3klh1AS+p6MGBngYESaGIeVICoqAH760unYMtoroD
         trtEe80CVlnW4HNZh2/Sfe1ymgALTu3hqBrP2kdgXqRTgO9scgMkhuoQm4WyRG94PFc2
         cB9g==
X-Gm-Message-State: AOJu0YyRwmsht77GYtkHnb/I9svGxuQzBAPBRTIWhqkeRP5LRrrmBGY8
	6xESXFeEiD6uxs+8FXDOVQDoidm3A2g54pjcQNfCHMc8ljwD0c6XKzcTYvxTnVFKxAoVHf/Ft9g
	wy1YOxQ59BI8l507R
X-Received: by 2002:a05:600c:4f49:b0:405:3924:3cad with SMTP id m9-20020a05600c4f4900b0040539243cadmr9416391wmq.15.1698915254053;
        Thu, 02 Nov 2023 01:54:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCmPB7wk4WYX3beE3RQwL26kpX7tKnW0S1AoiLWUYjQvzaem2LWlpr04EvBL0VKBRb3Dyxog==
X-Received: by 2002:a05:600c:4f49:b0:405:3924:3cad with SMTP id m9-20020a05600c4f4900b0040539243cadmr9416375wmq.15.1698915253591;
        Thu, 02 Nov 2023 01:54:13 -0700 (PDT)
Received: from ?IPV6:2003:cb:c716:3000:f155:cef2:ff4d:c7? (p200300cbc7163000f155cef2ff4d00c7.dip0.t-ipconnect.de. [2003:cb:c716:3000:f155:cef2:ff4d:c7])
        by smtp.gmail.com with ESMTPSA id l26-20020a05600c1d1a00b003fef5e76f2csm4257226wms.0.2023.11.02.01.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 01:54:13 -0700 (PDT)
Message-ID: <f71e7e27-83ef-476b-baa6-bb82ea73db10@redhat.com>
Date: Thu, 2 Nov 2023 09:54:11 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/3] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
To: Vishal Verma <vishal.l.verma@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Michal Hocko <mhocko@suse.com>,
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Jeff Moyer <jmoyer@redhat.com>
References: <20231101-vv-kmem_memmap-v8-0-5e4a83331388@intel.com>
 <20231101-vv-kmem_memmap-v8-2-5e4a83331388@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231101-vv-kmem_memmap-v8-2-5e4a83331388@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.11.23 23:51, Vishal Verma wrote:
> The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is restricted to
> 'memblock_size' chunks of memory being added. Adding a larger span of
> memory precludes memmap_on_memory semantics.
> 
> For users of hotplug such as kmem, large amounts of memory might get
> added from the CXL subsystem. In some cases, this amount may exceed the
> available 'main memory' to store the memmap for the memory being added.
> In this case, it is useful to have a way to place the memmap on the
> memory being added, even if it means splitting the addition into
> memblock-sized chunks.
> 
> Change add_memory_resource() to loop over memblock-sized chunks of
> memory if caller requested memmap_on_memory, and if other conditions for
> it are met. Teach try_remove_memory() to also expect that a memory
> range being removed might have been split up into memblock sized chunks,
> and to loop through those as needed.
> 
> This does preclude being able to use PUD mappings in the direct map; a
> proposal to how this could be optimized in the future is laid out
> here[1].
> 
> [1]: https://lore.kernel.org/linux-mm/b6753402-2de9-25b2-36e9-eacd49752b19@redhat.com/
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   mm/memory_hotplug.c | 213 ++++++++++++++++++++++++++++++++++------------------
>   1 file changed, 138 insertions(+), 75 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6be7de9efa55..d242e49d7f7b 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1380,6 +1380,84 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>   	return arch_supports_memmap_on_memory(vmemmap_size);
>   }
>   
> +static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
> +{
> +	unsigned long memblock_size = memory_block_size_bytes();
> +	u64 cur_start;
> +
> +	/*
> +	 * For memmap_on_memory, the altmaps were added on a per-memblock
> +	 * basis; we have to process each individual memory block.
> +	 */
> +	for (cur_start = start; cur_start < start + size;
> +	     cur_start += memblock_size) {
> +		struct vmem_altmap *altmap = NULL;
> +		struct memory_block *mem;
> +
> +		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start)));
> +		WARN_ON_ONCE(!mem);
> +		if (!mem)
> +			continue;

Nit:

if (WARN_ON_ONCE(!mem))
	continue;

> +	for (cur_start = start; cur_start < start + size;
> +	     cur_start += memblock_size) {
> +		struct mhp_params params = { .pgprot =
> +						     pgprot_mhp(PAGE_KERNEL) };
> +		struct vmem_altmap mhp_altmap = {
> +			.base_pfn = PHYS_PFN(cur_start),
> +			.end_pfn = PHYS_PFN(cur_start + memblock_size - 1),
> +		};
> +
> +		mhp_altmap.free = memory_block_memmap_on_memory_pages();
> +		params.altmap = kmemdup(&mhp_altmap, sizeof(struct vmem_altmap),
> +					GFP_KERNEL);
> +		if (!params.altmap)
> +			return -ENOMEM;

As already spotted, we have to cleanup.

> +
> +		/* call arch's memory hotadd */
> +		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
> +		if (ret < 0) {
> +			kfree(params.altmap);
> +			goto out;
> +		}
> +
> +		/* create memory block devices after memory was added */
> +		ret = create_memory_block_devices(cur_start, memblock_size,
> +						  params.altmap, group);
> +		if (ret) {
> +			arch_remove_memory(cur_start, memblock_size, NULL);
> +			kfree(params.altmap);
> +			goto out;
> +		}
> +	}
> +
> +	return 0;
> +out:
> +	if (ret && (cur_start != start))

Nit: I think you can drop the inner parentheses.

> @@ -2146,11 +2208,31 @@ void try_offline_node(int nid)
>   }
>   EXPORT_SYMBOL(try_offline_node);
>   
> +static int memory_blocks_have_altmaps(u64 start, u64 size)
> +{
> +	u64 num_memblocks = size / memory_block_size_bytes();
> +	u64 num_altmaps = 0;
> +
> +	if (!mhp_memmap_on_memory())
> +		return 0;
> +
> +	walk_memory_blocks(start, size, &num_altmaps,
> +			   count_memory_range_altmaps_cb);
> +
> +	if (num_altmaps == 0)
> +		return 0;
> +
> +	if (num_memblocks != num_altmaps) {
> +		WARN_ONCE(1, "Not all memblocks in range have altmaps");

Nit:

if (WARN_ON_ONCE(num_memblocks != num_altmaps))
	return -EINVAL;

Should be sufficient.

[...]

>   	/* remove memmap entry */
>   	firmware_map_remove(start, start + size, "System RAM");
>   
> -	/*
> -	 * Memory block device removal under the device_hotplug_lock is
> -	 * a barrier against racing online attempts.
> -	 */
> -	remove_memory_block_devices(start, size);
> -
>   	mem_hotplug_begin();
>   
> -	arch_remove_memory(start, size, altmap);
> -
> -	/* Verify that all vmemmap pages have actually been freed. */
> -	if (altmap) {
> -		WARN(altmap->alloc, "Altmap not fully unmapped");
> -		kfree(altmap);
> +	rc = memory_blocks_have_altmaps(start, size);
> +	if (rc < 0) {
> +		goto err;

Nit: Maybe better to just

if (rc < 0) {
	mem_hotplug_done();
	return rc
} else ...

And avoid the error label below. Makes the code easier to read.

> +	} else if (rc == 0) {

Nit: else if (!rc)



With the cleanup fixed,

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


