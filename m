Return-Path: <nvdimm+bounces-11181-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A07B09560
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jul 2025 22:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92CBE188AAB9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jul 2025 20:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5748D224AEF;
	Thu, 17 Jul 2025 20:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6J6wB7t"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B12248AF
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 20:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752782633; cv=none; b=JSHjgujigxSkserdDpzld3E90ckD5uvJ8OctCultPkVrS9XscUWbcs2O3D48r/vrVWPl/NA7j1tXLNDJtx7tHUdUaScjhQNckXfFZHy/DIsOlADan+47dbCs40UVShYTfj+Gq1BEhneuOAcewg5XKT8hJun2ckrAckS/Lw7x3aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752782633; c=relaxed/simple;
	bh=Q/F1zAOvHokBZlzDec5Cjn3EbeBfpbAqOlMColJ54Aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzKsRaKPNyPB1LkK0F3QibI7VvNGGbgM9ba+e91xuE5g/khwHXx+dwVRsksg52ipMf9QMMxA8EGW/MqJOFuvKPp5gPD/a4GBHE0Tbbwcs3Hu+O92I5V2U2TLThC5jq3cuu/gmxd0L3zrODbPhD+3QOZtiRXdWB6fruYoXlGCXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g6J6wB7t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752782630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ClNVtTZhZp5gAwQFZwS1SAbGnOFesIfcYAsTrAvuVJw=;
	b=g6J6wB7tJUpEDS5+igQjHwbD2g3WVm8I3tKDeP9yweRvHhP5JNqBy3eE7rbLaj6u1cyy/B
	HpG5xmhqgFDwbrABLil8G9hCsGq2BhXgnXbpWECWiEhfiHSECfX34To8YLzzToUNntOkhl
	92Wpzz+Cgup/BwnUf3q8aif/MTmX3Ew=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-zefk5FAjPdKCOje2gSTghw-1; Thu, 17 Jul 2025 16:03:48 -0400
X-MC-Unique: zefk5FAjPdKCOje2gSTghw-1
X-Mimecast-MFC-AGG-ID: zefk5FAjPdKCOje2gSTghw_1752782627
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-456267c79deso4354155e9.1
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 13:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752782627; x=1753387427;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ClNVtTZhZp5gAwQFZwS1SAbGnOFesIfcYAsTrAvuVJw=;
        b=s0Hn62hsoe0kHdx1ta3g8pTdLtKh6unvrCJrP4Ll0ou6Kktj0I6czrrpSn6QzzZTgh
         XbWYdGObcH3ZgzZ09uICBXSI9r22YG4ziv23HmtoTq/Bjd4Js6BmQtxk6+Oo/T2imFFH
         oCj1WwIrv0ZtcTBizx9vrxPkPfO4Q2IyDwp8CCp140xi4HmKLF3am9LMmob2BmWpwqxo
         cyzjhxILU8fsoBckEY5mNW3f210vkVp0+TvQrKJcBSLCSuEE4ReOhXgLZDIq7YWzxKN3
         VPGTIN0Q4hesDdw0+pB/jqWh4NmaALQLlmMEV9ux09h5/opexfGMHnSbXV5jma0qjI9M
         k9qg==
X-Forwarded-Encrypted: i=1; AJvYcCWrplOgeqMbvSGDW4QZxR0IZnF+OEBcQdEdNJy8HVcTKOwBJxhYw9iKnSSQY4KgmDxrFSFYWyI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgRR0PWA1CEFEf4rli5OS52dvFm7WYPu/6xYJARZEdgI2cK8L8
	oYbc8I2+mXSLsnPmbTmj3SqLUvHtCK1Ge2TYkVtWGymOe/wjR3uOPOfvAXCo2mSOub+SUtdO8vi
	rsj8+hygkiAFU4rOe9cb/JRAzaB0jAvXpKQFarYSK/jAuIhOxnum12UnMrA==
X-Gm-Gg: ASbGncu/AUCUAowEqR2mQRfMsukY1zu814Lxuq48bwRNIn0GTApwPK3rM6cqUEe0PJW
	hQAwwjZeE8YbRHvMMDy4pXmix/Xwv/sGGtWCfu1o8N0KZvvKH8ryhbYZWJ9QTZNVkazg2Coft5s
	/ZD4aSWOCoKOoArPCsKSnW/wjTDu46q2mC93vGUy327EYH2zXV3qiVrz/Chux33Bu+vW6Yoz2WR
	BbTL/tEaTf1t5mzmD3aOI0Mwb+pwyaIT8Ar+T5N0IpaG3rnimJEk9QkUgPSSTa8MVwdTztKfdSt
	nkn6F8bmwZZSdHAAr2SDCmUsVaB0dc/KPvfMYhyFxUmXf6+CnkwgkZpVvDCFTqvjhypISS7EQ4L
	GBHVzGGPEB45lh3QOemWf7zgFDsQvCq8gKqErArm46yIja3z3LCRj65bafXoy2HLD
X-Received: by 2002:a05:600c:3481:b0:456:f9f:657 with SMTP id 5b1f17b1804b1-4562e3c503amr79746145e9.27.1752782626942;
        Thu, 17 Jul 2025 13:03:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHITXVfZtwqa7P8f0u6oWcFw1NazxQtB99hClGfTnR+mgLoVDMe7M6pKVDkyJRWFMthviCSvw==
X-Received: by 2002:a05:600c:3481:b0:456:f9f:657 with SMTP id 5b1f17b1804b1-4562e3c503amr79745695e9.27.1752782626423;
        Thu, 17 Jul 2025 13:03:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:2b00:b1a5:704a:6a0c:9ae? (p200300d82f352b00b1a5704a6a0c09ae.dip0.t-ipconnect.de. [2003:d8:2f35:2b00:b1a5:704a:6a0c:9ae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45630ec9129sm49616075e9.29.2025.07.17.13.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 13:03:45 -0700 (PDT)
Message-ID: <b7457b96-2b78-4202-8380-4c7cd70767b9@redhat.com>
Date: Thu, 17 Jul 2025 22:03:44 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] mm/memory: factor out common code from
 vm_normal_page_*()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-8-david@redhat.com>
 <1aef6483-18e6-463b-a197-34dd32dd6fbd@lucifer.local>
 <50190a14-78fb-4a4a-82fa-d7b887aa4754@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <50190a14-78fb-4a4a-82fa-d7b887aa4754@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IfjeZ4bZpTDivGAP9XrrhT8n5BSyRggtjw18TvJr2YM_1752782627
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.07.25 21:55, Lorenzo Stoakes wrote:
> On Thu, Jul 17, 2025 at 08:51:51PM +0100, Lorenzo Stoakes wrote:
>>> @@ -721,37 +772,21 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>   		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
>>>   		return NULL;
>>>   	}
>>> -
>>> -	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>>> -		if (vma->vm_flags & VM_MIXEDMAP) {
>>> -			if (!pfn_valid(pfn))
>>> -				return NULL;
>>> -			goto out;
>>> -		} else {
>>> -			unsigned long off;
>>> -			off = (addr - vma->vm_start) >> PAGE_SHIFT;
>>> -			if (pfn == vma->vm_pgoff + off)
>>> -				return NULL;
>>> -			if (!is_cow_mapping(vma->vm_flags))
>>> -				return NULL;
>>> -		}
>>> -	}
>>> -
>>> -	if (is_huge_zero_pfn(pfn))
>>> -		return NULL;
>>> -	if (unlikely(pfn > highest_memmap_pfn)) {
>>> -		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
>>> -		return NULL;
>>> -	}
>>> -
>>> -	/*
>>> -	 * NOTE! We still have PageReserved() pages in the page tables.
>>> -	 * eg. VDSO mappings can cause them to exist.
>>> -	 */
>>> -out:
>>> -	return pfn_to_page(pfn);
>>> +	return vm_normal_page_pfn(vma, addr, pfn, pmd_val(pmd));
>>
>> Hmm this seems broken, because you're now making these special on arches with
>> pte_special() right? But then you're invoking the not-special function?
>>
>> Also for non-pte_special() arches you're kind of implying they _maybe_ could be
>> special.
> 
> OK sorry the diff caught me out here, you explicitly handle the pmd_special()
> case here, duplicatively (yuck).
> 
> Maybe you fix this up in a later patch :)

I had that, but the conditions depend on the level, meaning: unnecessary 
checks for pte/pmd/pud level.

I had a variant where I would pass "bool special" into 
vm_normal_page_pfn(), but I didn't like it.

To optimize out, I would have to provide a "level" argument, and did not 
convince myself yet that that is a good idea at this point.

-- 
Cheers,

David / dhildenb


