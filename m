Return-Path: <nvdimm+bounces-2844-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D594A8034
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 09:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 03CD01C0D50
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 08:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB32E2CA1;
	Thu,  3 Feb 2022 08:19:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347842F21
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 08:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643876352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ga3a+cNqPUZbMV6ngpquicZKi+kYXvf5VDW1pb/74NM=;
	b=QlgVGD9calJB0klqNM2gDF2Cq7loULw5rV6MfnXJ/ozdobpwHjhjNIOrHn0hh7qy3Q4cmO
	65Fsoxx1w5fdLolbsqZ18PIjl04yQ/GdbZ/PMoyeVm8GsvVdUqmq9bzZssIeK+lVHmzUWH
	KOF27Pe0lRmZO9OeUd5ek6Ujdqh6SUk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-M-2snSpKMkayMfImHRjfpQ-1; Thu, 03 Feb 2022 03:19:11 -0500
X-MC-Unique: M-2snSpKMkayMfImHRjfpQ-1
Received: by mail-wm1-f71.google.com with SMTP id m18-20020a7bca52000000b003552c4e2550so864324wml.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Feb 2022 00:19:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Ga3a+cNqPUZbMV6ngpquicZKi+kYXvf5VDW1pb/74NM=;
        b=kOrApu9xmJ5gIfMp01iD6R3GEv65kmRZp3aYZiFEpSQQYw9RSIDFjXRUTSPzlX7WK4
         rFcv4LFsQOb0RHeLSnXRxJjPrQHtIFvATxfJTpiyPvPqcpWnxJL/lwVG5XgwEa11z7vt
         7p8IZjLOnlEq1FM2ZIX/heAhPCrWdo4YTWJEsRpT791R1+Oljh/r10dmK4KfLmy+BjWR
         rYnHCHn+TsAulSh/GCDPujVD+GRTVAKXGndWiLoSfySoD1nkasotgDA1CACf+CJboySd
         7edLL+QEljNJD+1cI+2zd5G9XAXgfqbg78NGfw4EcTaeYP8BK6qaNJfpuNQTI0LTvYMx
         tO3g==
X-Gm-Message-State: AOAM532clI5gcvffOAkpBoQFe2MpM0rRc5S/yRWgw/E+pj70SamPds8m
	5b9xjgQJNa73eLm49UI+1+E61U4JSK2QTwGOaH5ZnDEWG5Tt22CaR1olEWiTqsqWHQwmUkN0m6z
	sRGhhU6gxBgEIG+Ix
X-Received: by 2002:adf:f8c6:: with SMTP id f6mr28298302wrq.290.1643876349729;
        Thu, 03 Feb 2022 00:19:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwd+aMUkquNhN3Wzj/b5dtgge/VtJYB/HzKVRpX+1yo3QIeT8CNocEG2VPINgEJ78SzLBILFg==
X-Received: by 2002:adf:f8c6:: with SMTP id f6mr28298281wrq.290.1643876349377;
        Thu, 03 Feb 2022 00:19:09 -0800 (PST)
Received: from ?IPV6:2003:d8:2f11:9700:838c:3860:6500:5284? (p200300d82f119700838c386065005284.dip0.t-ipconnect.de. [2003:d8:2f11:9700:838c:3860:6500:5284])
        by smtp.gmail.com with ESMTPSA id n5sm7530303wmq.43.2022.02.03.00.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 00:19:08 -0800 (PST)
Message-ID: <50158895-0bde-7c13-097e-f8c2f9bdfe10@redhat.com>
Date: Thu, 3 Feb 2022 09:19:08 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] mm/memory_hotplug: Export shrink span functions for
 zone and node
To: Jonghyeon Kim <tome01@ajou.ac.kr>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20220126170002.19754-1-tome01@ajou.ac.kr>
 <5d02ea0e-aca6-a64b-23de-bc9307572d17@redhat.com>
 <20220127094142.GA31409@swarm08>
 <696b782f-0b50-9861-a34d-cf750d4244bd@redhat.com>
 <20220128041959.GA20345@swarm08>
 <df613a5e-bf32-a03e-e06f-5dcb3444c3d4@redhat.com>
 <20220203022241.GA27120@swarm08>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220203022241.GA27120@swarm08>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03.02.22 03:22, Jonghyeon Kim wrote:
> On Fri, Jan 28, 2022 at 09:10:21AM +0100, David Hildenbrand wrote:
>> On 28.01.22 05:19, Jonghyeon Kim wrote:
>>> On Thu, Jan 27, 2022 at 10:54:23AM +0100, David Hildenbrand wrote:
>>>> On 27.01.22 10:41, Jonghyeon Kim wrote:
>>>>> On Wed, Jan 26, 2022 at 06:04:50PM +0100, David Hildenbrand wrote:
>>>>>> On 26.01.22 18:00, Jonghyeon Kim wrote:
>>>>>>> Export shrink_zone_span() and update_pgdat_span() functions to head
>>>>>>> file. We need to update real number of spanned pages for NUMA nodes and
>>>>>>> zones when we add memory device node such as device dax memory.
>>>>>>>
>>>>>>
>>>>>> Can you elaborate a bit more what you intend to fix?
>>>>>>
>>>>>> Memory onlining/offlining is reponsible for updating the node/zone span,
>>>>>> and that's triggered when the dax/kmem mamory gets onlined/offlined.
>>>>>>
>>>>> Sure, sorry for the lack of explanation of the intended fix.
>>>>>
>>>>> Before onlining nvdimm memory using dax(devdax or fsdax), these memory belong to
>>>>> cpu NUMA nodes, which extends span pages of node/zone as a ZONE_DEVICE. So there
>>>>> is no problem because node/zone contain these additional non-visible memory
>>>>> devices to the system.
>>>>> But, if we online dax-memory, zone[ZONE_DEVICE] of CPU NUMA node is hot-plugged
>>>>> to new NUMA node(but CPU-less). I think there is no need to hold
>>>>> zone[ZONE_DEVICE] pages on the original node.
>>>>>
>>>>> Additionally, spanned pages are also used to calculate the end pfn of a node.
>>>>> Thus, it is needed to maintain accurate page stats for node/zone.
>>>>>
>>>>> My machine contains two CPU-socket consisting of DRAM and Intel DCPMM
>>>>> (DC persistent memory modules) with App-Direct mode.
>>>>>
>>>>> Below are my test results.
>>>>>
>>>>> Before memory onlining:
>>>>>
>>>>> 	# ndctl create-namespace --mode=devdax
>>>>> 	# ndctl create-namespace --mode=devdax
>>>>> 	# cat /proc/zoneinfo | grep -E "Node|spanned" | paste - -
>>>>> 	Node 0, zone      DMA	        spanned  4095
>>>>> 	Node 0, zone    DMA32	        spanned  1044480
>>>>> 	Node 0, zone   Normal	        spanned  7864320
>>>>> 	Node 0, zone  Movable	        spanned  0
>>>>> 	Node 0, zone   Device	        spanned  66060288
>>>>> 	Node 1, zone      DMA	        spanned  0
>>>>> 	Node 1, zone    DMA32	        spanned  0
>>>>> 	Node 1, zone   Normal	        spanned  8388608
>>>>> 	Node 1, zone  Movable	        spanned  0
>>>>> 	Node 1, zone   Device	        spanned  66060288
>>>>>
>>>>> After memory onlining:
>>>>>
>>>>> 	# daxctl reconfigure-device --mode=system-ram --no-online dax0.0
>>>>> 	# daxctl reconfigure-device --mode=system-ram --no-online dax1.0
>>>>>
>>>>> 	# cat /proc/zoneinfo | grep -E "Node|spanned" | paste - -
>>>>> 	Node 0, zone      DMA	        spanned  4095
>>>>> 	Node 0, zone    DMA32	        spanned  1044480
>>>>> 	Node 0, zone   Normal	        spanned  7864320
>>>>> 	Node 0, zone  Movable	        spanned  0
>>>>> 	Node 0, zone   Device	        spanned  66060288
>>>>> 	Node 1, zone      DMA	        spanned  0
>>>>> 	Node 1, zone    DMA32	        spanned  0
>>>>> 	Node 1, zone   Normal	        spanned  8388608
>>>>> 	Node 1, zone  Movable	        spanned  0
>>>>> 	Node 1, zone   Device	        spanned  66060288
>>>>> 	Node 2, zone      DMA	        spanned  0
>>>>> 	Node 2, zone    DMA32	        spanned  0
>>>>> 	Node 2, zone   Normal	        spanned  65011712
>>>>> 	Node 2, zone  Movable	        spanned  0
>>>>> 	Node 2, zone   Device	        spanned  0
>>>>> 	Node 3, zone      DMA	        spanned  0
>>>>> 	Node 3, zone    DMA32	        spanned  0
>>>>> 	Node 3, zone   Normal	        spanned  65011712
>>>>> 	Node 3, zone  Movable	        spanned  0
>>>>> 	Node 3, zone   Device	        spanned  0
>>>>>
>>>>> As we can see, Node 0 and 1 still have zone_device pages after memory onlining.
>>>>> This causes problem that Node 0 and Node 2 have same end of pfn values, also 
>>>>> Node 1 and Node 3 have same problem.
>>>>
>>>> Thanks for the information, that makes it clearer.
>>>>
>>>> While this unfortunate, the node/zone span is something fairly
>>>> unreliable/unusable for user space. Nodes and zones can overlap just easily.
>>>>
>>>> What counts are present/managed pages in the node/zone.
>>>>
>>>> So at least I don't count this as something that "needs fixing",
>>>> it's more something that's nice to handle better if easily possible.
>>>>
>>>> See below.
>>>>
>>>>>
>>>>>>> Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
>>>>>>> ---
>>>>>>>  include/linux/memory_hotplug.h | 3 +++
>>>>>>>  mm/memory_hotplug.c            | 6 ++++--
>>>>>>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
>>>>>>> index be48e003a518..25c7f60c317e 100644
>>>>>>> --- a/include/linux/memory_hotplug.h
>>>>>>> +++ b/include/linux/memory_hotplug.h
>>>>>>> @@ -337,6 +337,9 @@ extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>>>>>>  extern void remove_pfn_range_from_zone(struct zone *zone,
>>>>>>>  				       unsigned long start_pfn,
>>>>>>>  				       unsigned long nr_pages);
>>>>>>> +extern void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>>>>>> +			     unsigned long end_pfn);
>>>>>>> +extern void update_pgdat_span(struct pglist_data *pgdat);
>>>>>>>  extern bool is_memblock_offlined(struct memory_block *mem);
>>>>>>>  extern int sparse_add_section(int nid, unsigned long pfn,
>>>>>>>  		unsigned long nr_pages, struct vmem_altmap *altmap);
>>>>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>>>>> index 2a9627dc784c..38f46a9ef853 100644
>>>>>>> --- a/mm/memory_hotplug.c
>>>>>>> +++ b/mm/memory_hotplug.c
>>>>>>> @@ -389,7 +389,7 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
>>>>>>>  	return 0;
>>>>>>>  }
>>>>>>>  
>>>>>>> -static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>>>>>> +void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>>>>>>  			     unsigned long end_pfn)
>>>>>>>  {
>>>>>>>  	unsigned long pfn;
>>>>>>> @@ -428,8 +428,9 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>>>>>>  		}
>>>>>>>  	}
>>>>>>>  }
>>>>>>> +EXPORT_SYMBOL_GPL(shrink_zone_span);
>>>>>>
>>>>>> Exporting both as symbols feels very wrong. This is memory
>>>>>> onlining/offlining internal stuff.
>>>>>
>>>>> I agree with you that your comment. I will find another approach to avoid
>>>>> directly using onlining/offlining internal stuff while updating node/zone span.
>>>>
>>>> IIRC, to handle what you intend to handle properly want to look into teaching
>>>> remove_pfn_range_from_zone() to handle zone_is_zone_device().
>>>>
>>>> There is a big fat comment:
>>>>
>>>> 	/*
>>>> 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>>>> 	 * we will not try to shrink the zones - which is okay as
>>>> 	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>>>> 	 */
>>>> 	if (zone_is_zone_device(zone))
>>>> 		return;
>>>>
>>>>
>>>> Similarly, try_offline_node() spells this out:
>>>>
>>>> 	/*
>>>> 	 * If the node still spans pages (especially ZONE_DEVICE), don't
>>>> 	 * offline it. A node spans memory after move_pfn_range_to_zone(),
>>>> 	 * e.g., after the memory block was onlined.
>>>> 	 */
>>>> 	if (pgdat->node_spanned_pages)
>>>> 		return;
>>>>
>>>>
>>>> So once you handle remove_pfn_range_from_zone() cleanly, you'll cleanly handle
>>>> try_offline_node() implicitly.
>>>>
>>>> Trying to update the node span manually without teaching node/zone shrinking code how to
>>>> handle ZONE_DEVICE properly is just a hack that will only sometimes work. Especially, it
>>>> won't work if the range of interest is still surrounded by other ranges.
>>>>
>>>
>>> Thanks for your pointing out, I missed those comments.
>>> I will keep trying to handle node/zone span updating process.
>>
>> The only safe thing right now for on ZONE_DEVICE in
>> remove_pfn_range_from_zone() would be removing the given range from the
>> start/end of the zone range, but we must not scan using the existing
>> functions.
>>
>> As soon as we start actual *scanning* via find_smallest...
>> find_biggest... in shrink_zone_span() we would mistakenly skip other
>> ZONE_DEVICE ranges and mess up.
>>
>> Assume you would have a ZONE_DEVICE layout like
>>
>> [  DEV 0 | Hole | DEV 1 | Hole | DEV 2 ]
>>
> 
> IIUC, you assumed situation that multiple ZONE_DEVICE in single node, and there
> are holes among them, right?

Exactly. But the holes are just an example to show what we'd have to do
when holes are around. Having multiple devices is the important part.


-- 
Thanks,

David / dhildenb


