Return-Path: <nvdimm+bounces-9587-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D559F596C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Dec 2024 23:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5FB27A30DB
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Dec 2024 22:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216421EE02E;
	Tue, 17 Dec 2024 22:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcLI10rf"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93731D9A48
	for <nvdimm@lists.linux.dev>; Tue, 17 Dec 2024 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734473690; cv=none; b=NlMM6C8LjH+plFPhsk/YHkHpb44NHvA0j2kzu3tjJ1qIJ9OQM8b3fnxTmNdBCAOeWcflncJJhsYDBQw2dtSU4kH38Acjnut9q1zOV4rvvpdrC4fmiTSRPoz1Q7ZBVv6Fd1HXE7/VVjcEvazXJY6w7WOGeUmCaE4X0GyCObHu7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734473690; c=relaxed/simple;
	bh=C7WNlVEmJjhlFNyxh743Po7U6Z0u5qHtj09VBt/yqeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YXh8DduwMCWKPmuyhw4lNE+0ZiIr+Op+EJ0V0nPt532V7qEf6y4I5UPDlPf5IjBTp/+v/YJZFsiGZQpt5K5WxPG33lPOsfPBWAYkZSxJLCrQ4lFxdI7q7oBsQP5ack6VSbzpSAlPsqaMIUcLTgd+BND+8AyXpKTZgVIxVtplQi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HcLI10rf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734473688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4W/q1KrGX8XGQ17XCg/MjjkKWOXUGMRUZUVOWrHU3No=;
	b=HcLI10rfdBbKQqidwhGKJZGVTB84ODZAh1gjceM76ogb6VTWjdkZwSLF92rLW3iIvbzeOT
	HNA3Bq+s6mOCs/vmKcSgJ0ZaXH8SAXfh3zaQn2qt95Y3nIZYMrn4Q58tvKgme5QhqUuRc6
	vQeRmbN6wPAJG1hErbhB6v70f8EXL24=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-nLKJ57StMOSaypn_1Gg2FA-1; Tue, 17 Dec 2024 17:14:46 -0500
X-MC-Unique: nLKJ57StMOSaypn_1Gg2FA-1
X-Mimecast-MFC-AGG-ID: nLKJ57StMOSaypn_1Gg2FA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4362b9c1641so24956515e9.3
        for <nvdimm@lists.linux.dev>; Tue, 17 Dec 2024 14:14:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734473686; x=1735078486;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4W/q1KrGX8XGQ17XCg/MjjkKWOXUGMRUZUVOWrHU3No=;
        b=BYnMwaDtnwOC9MSK0byPEwtlJmViqzfKxNv11arRNtge87mVhj1NWeHN5srflLU/y1
         qydJYBPjmC9hzH8BZ/2W41CvGVHit0IfNaaq+5ED503wnyzSZSOdt+lf7xc3vbIJWC45
         L/8wlw94IOM7VP37OloloiHSz6/vGMVgNabEMOJMvYtoTHsiPSOl83lut46t3AkzDEn0
         33bRicu7Jh9FcbXq9szSdJqCq7oYSW3Crsf5HtRIYLpuLni9amkbrZ6XUlNiyPCLI1mS
         jiscgKeIO1Mly27tbaP2QEuhJl3OqZkDWuEHgShuNh2JnV0ysMwcSU+A9fvShyneXYkO
         qliA==
X-Forwarded-Encrypted: i=1; AJvYcCWm9h2NhHEqVDwUChXe+ZqZkOqC/6jGlwE9VfJeR4t0x6EPppWY0WzViqe3kT50JNsN/einpYY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyann4PbcTXPwrmBaMy0w1AUaRJ0yB2LF/YewRfeAITucO8laQW
	pwjnfoQubleq+DN8/U6HeFdv4t8b4Pc4kVVxFINkGAaTvAbDgViswlvTxlVP+U9dRK3zAzr8+dB
	gCY0JZJ+9+ofwoUPH0t4NYxG1/kUcvGh5FOqJnm4SL519ZuldPCYghw==
X-Gm-Gg: ASbGncscBMleCva7gJcPmMGCma+Cz5xMd3+LwpFKax5zGhJnQDbMQ7ejvHHdmCHfIoA
	6TuUlKiKSYTDSRzbQ+i03BKCZXLdwII9N3G63bEcOGj++J9AfR6qeFNPrXtU3251Knhs3wn9NIo
	B3/TZcwPr2ixh2xrafoT9yz6m4anUDThOmvK7T9bjSLxzRg2JMxK0PfLPjqjEQUDi5SFiTpcTSG
	XSdksFfThjnwAvvyrSp5FWw3E/X0d828NW8GkGw8IqsDhX54cWFogjbamffTlVevmn+aP+l5ASJ
	tl8uB8oQbtfIgiWQevLg8lkKnNPbgrtXrQFwA2wp20mLR66/LQCaNpvjZzjDD9imCmQs0QYom9P
	cye3wwEKq
X-Received: by 2002:a05:600c:3c9f:b0:434:f5c0:32b1 with SMTP id 5b1f17b1804b1-4365537150fmr3537935e9.15.1734473685485;
        Tue, 17 Dec 2024 14:14:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTA6KpAji94rWVq0XTa+DJffBW/rQwG7DLaTq8FXlBm90uKsIvAH/DN3eMrFmLxXFdurudeQ==
X-Received: by 2002:a05:600c:3c9f:b0:434:f5c0:32b1 with SMTP id 5b1f17b1804b1-4365537150fmr3537595e9.15.1734473685027;
        Tue, 17 Dec 2024 14:14:45 -0800 (PST)
Received: from ?IPV6:2003:cb:c73b:5600:c716:d8e0:609d:ae92? (p200300cbc73b5600c716d8e0609dae92.dip0.t-ipconnect.de. [2003:cb:c73b:5600:c716:d8e0:609d:ae92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8046da0sm12634055f8f.74.2024.12.17.14.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 14:14:44 -0800 (PST)
Message-ID: <359a1cf2-c5b0-4682-ba3c-980d77c4cfdb@redhat.com>
Date: Tue, 17 Dec 2024 23:14:42 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/25] mm/mm_init: Move p2pdma page refcount
 initialisation to p2pdma
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: lina@asahilina.net, zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
 will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
 dave.hansen@linux.intel.com, ira.weiny@intel.com, willy@infradead.org,
 djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, peterx@redhat.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 david@fromorbit.com
References: <cover.18cbcff3638c6aacc051c44533ebc6c002bf2bd9.1734407924.git-series.apopple@nvidia.com>
 <aaa23e6f315a2d9b30a422c3769100cdfa42e85a.1734407924.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aaa23e6f315a2d9b30a422c3769100cdfa42e85a.1734407924.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gZz0PvqsBAEEYIEczb4YMm6-th_J2VKqPQBhP5uG96k_1734473686
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.12.24 06:12, Alistair Popple wrote:
> Currently ZONE_DEVICE page reference counts are initialised by core
> memory management code in __init_zone_device_page() as part of the
> memremap() call which driver modules make to obtain ZONE_DEVICE
> pages. This initialises page refcounts to 1 before returning them to
> the driver.
> 
> This was presumably done because it drivers had a reference of sorts
> on the page. It also ensured the page could always be mapped with
> vm_insert_page() for example and would never get freed (ie. have a
> zero refcount), freeing drivers of manipulating page reference counts.

It probably dates back to copying that code from other zone-init code 
where we
(a) Treat all available-at-boot memory as allocated before we release it 
to the buddy
(b) Treat all hotplugged memory as allocated until we release it to the 
buddy

As a side note, I'm working on converting (b) -- PageOffline pages -- to 
have a refcount of 0 ("frozen").

> 
> However it complicates figuring out whether or not a page is free from
> the mm perspective because it is no longer possible to just look at
> the refcount. Instead the page type must be known and if GUP is used a
> secondary pgmap reference is also sometimes needed.
> 
> To simplify this it is desirable to remove the page reference count
> for the driver, so core mm can just use the refcount without having to
> account for page type or do other types of tracking. This is possible
> because drivers can always assume the page is valid as core kernel
> will never offline or remove the struct page.
> 
> This means it is now up to drivers to initialise the page refcount as
> required. P2PDMA uses vm_insert_page() to map the page, and that
> requires a non-zero reference count when initialising the page so set
> that when the page is first mapped.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ---
> 
> Changes since v2:
> 
>   - Initialise the page refcount for all pages covered by the kaddr
> ---
>   drivers/pci/p2pdma.c | 13 +++++++++++--
>   mm/memremap.c        | 17 +++++++++++++----
>   mm/mm_init.c         | 22 ++++++++++++++++++----
>   3 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 0cb7e0a..04773a8 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -140,13 +140,22 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>   	rcu_read_unlock();
>   
>   	for (vaddr = vma->vm_start; vaddr < vma->vm_end; vaddr += PAGE_SIZE) {
> -		ret = vm_insert_page(vma, vaddr, virt_to_page(kaddr));
> +		struct page *page = virt_to_page(kaddr);
> +
> +		/*
> +		 * Initialise the refcount for the freshly allocated page. As
> +		 * we have just allocated the page no one else should be
> +		 * using it.
> +		 */
> +		VM_WARN_ON_ONCE_PAGE(!page_ref_count(page), page);
> +		set_page_count(page, 1);
> +		ret = vm_insert_page(vma, vaddr, page);
>   		if (ret) {
>   			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
>   			return ret;
>   		}
>   		percpu_ref_get(ref);
> -		put_page(virt_to_page(kaddr));
> +		put_page(page);
>   		kaddr += PAGE_SIZE;
>   		len -= PAGE_SIZE;
>   	}
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 40d4547..07bbe0e 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -488,15 +488,24 @@ void free_zone_device_folio(struct folio *folio)
>   	folio->mapping = NULL;
>   	folio->page.pgmap->ops->page_free(folio_page(folio, 0));
>   
> -	if (folio->page.pgmap->type != MEMORY_DEVICE_PRIVATE &&
> -	    folio->page.pgmap->type != MEMORY_DEVICE_COHERENT)
> +	switch (folio->page.pgmap->type) {
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_COHERENT:
> +		put_dev_pagemap(folio->page.pgmap);
> +		break;
> +
> +	case MEMORY_DEVICE_FS_DAX:
> +	case MEMORY_DEVICE_GENERIC:
>   		/*
>   		 * Reset the refcount to 1 to prepare for handing out the page
>   		 * again.
>   		 */
>   		folio_set_count(folio, 1);
> -	else
> -		put_dev_pagemap(folio->page.pgmap);
> +		break;
> +
> +	case MEMORY_DEVICE_PCI_P2PDMA:
> +		break;
> +	}
>   }
>   
>   void zone_device_page_init(struct page *page)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 24b68b4..f021e63 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1017,12 +1017,26 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>   	}
>   
>   	/*
> -	 * ZONE_DEVICE pages are released directly to the driver page allocator
> -	 * which will set the page count to 1 when allocating the page.
> +	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC and
> +	 * MEMORY_TYPE_FS_DAX pages are released directly to the driver page
> +	 * allocator which will set the page count to 1 when allocating the
> +	 * page.
> +	 *
> +	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
> +	 * their refcount reset to one whenever they are freed (ie. after
> +	 * their refcount drops to 0).
>   	 */
> -	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
> -	    pgmap->type == MEMORY_DEVICE_COHERENT)
> +	switch (pgmap->type) {
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_COHERENT:
> +	case MEMORY_DEVICE_PCI_P2PDMA:
>   		set_page_count(page, 0);
> +		break;
> +
> +	case MEMORY_DEVICE_FS_DAX:
> +	case MEMORY_DEVICE_GENERIC:
> +		break;
> +	}
>   }
>   
>   /*


But that's a bit weird: we call __init_single_page()->init_page_count() 
to initialize it to 1, to then set it back to 0.


Maybe we can just pass to __init_single_page() the refcount we want to 
have directly? Can be a patch on top of course.

Apart from that

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


