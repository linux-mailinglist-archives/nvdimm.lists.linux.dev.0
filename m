Return-Path: <nvdimm+bounces-7083-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A3F812B21
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Dec 2023 10:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52DF91F21898
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Dec 2023 09:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44AA128695;
	Thu, 14 Dec 2023 09:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wx186yH9"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97382557D
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 09:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702545049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VKHE7jI2ItzkPojzmqif9xZF1gx8hMjEdVxpLC4Oaqc=;
	b=Wx186yH9Qn9J/C9AisHgUaDnxolJDhSdoDLfyeviktb3O/9cOqr6T4tNg1hKYHqubrgWrb
	O2BoZTsHkDGfKW3oSQjdYZ/Yg0qgEzyo82kfpYF31CbK1yJHE7Ote/l4ofSvx6VCNRIO1v
	cufgkm3Mgrt/A56WQtbi4PYxywdHH7g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-NxEJ-IxqNNWGZQP9JUWaUg-1; Thu, 14 Dec 2023 04:10:46 -0500
X-MC-Unique: NxEJ-IxqNNWGZQP9JUWaUg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40c2dd83bc4so48974405e9.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 01:10:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702545045; x=1703149845;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKHE7jI2ItzkPojzmqif9xZF1gx8hMjEdVxpLC4Oaqc=;
        b=UEy1ZVpnz/Oa+WS/9PFD2+alMlmHHuFyrb+b4KZ593wpf2lhbpnUSonP3vwHHGJyp8
         BI2k1swz5fc1cGZ2jGQAmL8cspi+895Hmtf4ST8oYbBx4mgvqCRl5oLSjHWRirLQC2dj
         /8FU8LTsnHFk8NrG6V6zbCxVd0h6mtJCfjBXlfbli9JFuc7zKlhuUNd37s6pc+2gJUfX
         r8tREr4eNCXh/1eH7bK5M0yGELb+5clNl9i5raBakFtlc6bjMEoK1qKWka3UTY56mJmO
         oRy9HJ4BrAULSfIXzzqfgpfTu2qC1XrDPKjSIxTOaty4yZzYjlh9vSQUUFboHUPcZB56
         xTTg==
X-Gm-Message-State: AOJu0Yx8AZRglzqzutf5kKQ9OWJeqZ9eEyx52BdBTYeD6P+UyNUqICGQ
	gibpTWrn99RJQEFvafTdFmhuZn6WwklkHAo+d233YdyVrhbt20TAUPAKWEirezHpLQUtSh/prP2
	jRTL8Ujc93FXV2jzO
X-Received: by 2002:a05:600c:6907:b0:40b:5e21:cc27 with SMTP id fo7-20020a05600c690700b0040b5e21cc27mr4290521wmb.82.1702545045150;
        Thu, 14 Dec 2023 01:10:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXtrTxN0R3ALFd0Y/pmj1KQrvofL8bjmFU2ElpFqvbnNliEFvfIgDr+BYqcGGeCRlZWf8O4Q==
X-Received: by 2002:a05:600c:6907:b0:40b:5e21:cc27 with SMTP id fo7-20020a05600c690700b0040b5e21cc27mr4290513wmb.82.1702545044656;
        Thu, 14 Dec 2023 01:10:44 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b004076f522058sm26234485wms.0.2023.12.14.01.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 01:10:44 -0800 (PST)
Message-ID: <cd7c5f6b-d668-4fab-8e7e-4f41018067c5@redhat.com>
Date: Thu, 14 Dec 2023 10:10:43 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] mm/memory_hotplug: export
 mhp_supports_memmap_on_memory()
To: Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
 Huang Ying <ying.huang@intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 Michal Hocko <mhocko@suse.com>
References: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
 <20231214-vv-dax_abi-v5-3-3f7b006960b4@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231214-vv-dax_abi-v5-3-3f7b006960b4@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.12.23 08:37, Vishal Verma wrote:
> In preparation for adding sysfs ABI to toggle memmap_on_memory semantics
> for drivers adding memory, export the mhp_supports_memmap_on_memory()
> helper. This allows drivers to check if memmap_on_memory support is
> available before trying to request it, and display an appropriate
> message if it isn't available. As part of this, remove the size argument
> to this - with recent updates to allow memmap_on_memory for larger
> ranges, and the internal splitting of altmaps into respective memory
> blocks, the size argument is meaningless.
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
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   include/linux/memory_hotplug.h |  6 ++++++
>   mm/memory_hotplug.c            | 17 ++++++-----------
>   2 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7d2076583494..ebc9d528f00c 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -121,6 +121,7 @@ struct mhp_params {
>   
>   bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
>   struct range mhp_get_pluggable_range(bool need_mapping);
> +bool mhp_supports_memmap_on_memory(void);
>   
>   /*
>    * Zone resizing functions
> @@ -262,6 +263,11 @@ static inline bool movable_node_is_enabled(void)
>   	return false;
>   }
>   
> +static bool mhp_supports_memmap_on_memory(void)
> +{
> +	return false;
> +}
> +
>   static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
>   static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
>   static inline void pgdat_kswapd_lock_init(pg_data_t *pgdat) {}
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 926e1cfb10e9..751664c519f7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1325,7 +1325,7 @@ static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
>   }
>   #endif
>   
> -static bool mhp_supports_memmap_on_memory(unsigned long size)
> +bool mhp_supports_memmap_on_memory(void)
>   {
>   	unsigned long vmemmap_size = memory_block_memmap_size();
>   	unsigned long memmap_pages = memory_block_memmap_on_memory_pages();
> @@ -1334,17 +1334,11 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>   	 * Besides having arch support and the feature enabled at runtime, we
>   	 * need a few more assumptions to hold true:
>   	 *
> -	 * a) We span a single memory block: memory onlining/offlinin;g happens
> -	 *    in memory block granularity. We don't want the vmemmap of online
> -	 *    memory blocks to reside on offline memory blocks. In the future,
> -	 *    we might want to support variable-sized memory blocks to make the
> -	 *    feature more versatile.
> -	 *
> -	 * b) The vmemmap pages span complete PMDs: We don't want vmemmap code
> +	 * a) The vmemmap pages span complete PMDs: We don't want vmemmap code
>   	 *    to populate memory from the altmap for unrelated parts (i.e.,
>   	 *    other memory blocks)
>   	 *
> -	 * c) The vmemmap pages (and thereby the pages that will be exposed to
> +	 * b) The vmemmap pages (and thereby the pages that will be exposed to
>   	 *    the buddy) have to cover full pageblocks: memory onlining/offlining
>   	 *    code requires applicable ranges to be page-aligned, for example, to
>   	 *    set the migratetypes properly.
> @@ -1356,7 +1350,7 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>   	 *       altmap as an alternative source of memory, and we do not exactly
>   	 *       populate a single PMD.
>   	 */
> -	if (!mhp_memmap_on_memory() || size != memory_block_size_bytes())
> +	if (!mhp_memmap_on_memory())
>   		return false;
>   
>   	/*
> @@ -1379,6 +1373,7 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>   
>   	return arch_supports_memmap_on_memory(vmemmap_size);
>   }
> +EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>   
>   static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
>   {
> @@ -1512,7 +1507,7 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   	 * Self hosted memmap array
>   	 */
>   	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
> -	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
> +	    mhp_supports_memmap_on_memory()) {
>   		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
>   		if (ret)
>   			goto error;
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


