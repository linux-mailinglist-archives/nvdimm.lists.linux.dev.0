Return-Path: <nvdimm+bounces-9602-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D059F99CB
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Dec 2024 19:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3080616C4D0
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Dec 2024 18:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A009721D009;
	Fri, 20 Dec 2024 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfuTv37H"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C8921C18C
	for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734720774; cv=none; b=o6KN01lQyff2XHXVSqrvwVcDSrVe85TVo32EA8l0GmGx6ewQDWB+cNSu8B8InY+wX6/QZwBeGvcb+NHGqWj5vyb4uwL8DQBQbYdOqTGSW6tgMmDZ+KjY5TH7Ctm9I+nPLHbLcI7pqZrFzt+txbuMMCi+R9z0pUYL9MXd0425HJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734720774; c=relaxed/simple;
	bh=Jrrtf7ynRpuFJhIQSQyE3DoqQyVa/3BweSfVsAsT1z0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m9nY2I8pcMkwHg7F7NQLT7rFVXqqNfT9A1jzWr/wbAKkYzs4qp4MFY67THGAi+kXtV2Eq910MIMoeT0Flh2tf8l6dU3/KM7rmx6kkmeN4y+BxiCnj6h1verTnITRWk4jJhAET7LTevWfY9MtmIxPl4JPHW0yZSZ1D6C1SRxjBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JfuTv37H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734720770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dbnyZoiiDhY37GUrey2T2rbzBAr5nAsVjfs5zL0bbZ8=;
	b=JfuTv37HwZQaoryeeEdOc5f3nwpk2AeN0LtgTeFKgM0chkD2zZaKsZsEfsDY1+ZVGtcTzt
	+l/6v7fi6tFhUOgMI8nTLmsRNw0rxFk6PNjsyAlD6R8BvcveUCPR5pSaoJBYzrOxTI0ap4
	+Oyh8LhfpsF46v/ggwUoz0XS8kFS4fM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-I2_ZxFWXPOiSUSf1NcJj1g-1; Fri, 20 Dec 2024 13:52:49 -0500
X-MC-Unique: I2_ZxFWXPOiSUSf1NcJj1g-1
X-Mimecast-MFC-AGG-ID: I2_ZxFWXPOiSUSf1NcJj1g
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361ac607b6so19008275e9.0
        for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 10:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734720768; x=1735325568;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dbnyZoiiDhY37GUrey2T2rbzBAr5nAsVjfs5zL0bbZ8=;
        b=pfFk/tREGnKcYjK8I3rzctC2C+NGxxhEw7WvYosTHgpnXjSnWvd2JU4cV+PERK7CYd
         Trtpf/2Y9vVZMILm3uzUz27lNMF/N2gE2oEmwVysk1YiGzrdr1oUuKtQtyQ8RpzjqdOB
         cRZmFQtTpCNSUFxDrSYsBPmUEDtwu0X+q/6fmqVerixTb/vQzpifIrUBFkx6wLXd0gkz
         qVBBFV/3/b3YnIks3a3HCJU+8Ywabr7K+48W4hwY/Lgo8zpy77UanmwV0yYx5sjjH5My
         xK/tHquwWNN1rzcoQM5u2N4qQxs+lRjOVZSyCjyxp/kJbynCVgeX6JC0/Q8c/GSlFD3r
         hwZg==
X-Forwarded-Encrypted: i=1; AJvYcCVFDqneq93jcEO3snSu/+X8KcnL91vwSJDy0E46x7zFdsn53Rx5ELuUFOzE7gSGnudSrfFSTaI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhjcdWOSQDHwhT/l2OtM5lTmCWOXnwNw5r9PWIsxXSgmpWJKKw
	QleXfiHbkYVHfIY5nGoknV23qs8H8jpza/RS7j3xfFKXsfkG0JrWi1rFtEMxhitBD5gxaHZCCuW
	NOO4yiI2t+F27XxelaznLSZZE+vzXxq9Hlqlfgz6iHc1Kz2XfHsUe2w==
X-Gm-Gg: ASbGncttjn8+1pW0YWl3qj3X3ClAyRUO3qtx28lpvXI4qRKGoDUMVJB6tGpcXg5Zvko
	VwVJaht4uZnOCXqU0TAnCKas/0kERWaat8QuVCtdTCRUqyKJd4ajUEWBN0fWJq5CxQGVDcDK5tY
	4AXfs5jhkk1/FtjCfO+4a+YWGYVaoOHLniMTkjsTQsvvbMBUC9orJTv7wfKn0MrhbbEbiZ9O0z+
	LQYjGpXeWANx0YC5jtlCUEK8P+gtgU7Sw8yIMScekdpHUgcZwdh7YyuBCaeS/nfyh9orDCcltwt
	CiVYyNRk8NAW9wGsR/FcpqRh5n4Q2kxY8BtxsXtJuEdAx+GSDovwe4Vs2xwQ/Qzm6ho8Dq/z44k
	CoOYtTEUc
X-Received: by 2002:a05:600c:314a:b0:434:a815:2b57 with SMTP id 5b1f17b1804b1-43668b480b9mr32010285e9.20.1734720768201;
        Fri, 20 Dec 2024 10:52:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzGxd/06JI/0DtYjP1I3Wm39fK5VpQfdZeds0gJTv70jrji/ntjg1Ho8vO3whD4eQ7dP1reg==
X-Received: by 2002:a05:600c:314a:b0:434:a815:2b57 with SMTP id 5b1f17b1804b1-43668b480b9mr32009855e9.20.1734720767708;
        Fri, 20 Dec 2024 10:52:47 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:9d00:edd9:835b:4bfb:2ce3? (p200300cbc7089d00edd9835b4bfb2ce3.dip0.t-ipconnect.de. [2003:cb:c708:9d00:edd9:835b:4bfb:2ce3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436611ea3e0sm53634835e9.7.2024.12.20.10.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 10:52:46 -0800 (PST)
Message-ID: <ee19854f-fa1f-4207-9176-3c7b79bccd07@redhat.com>
Date: Fri, 20 Dec 2024 19:52:43 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/25] huge_memory: Add vmf_insert_folio_pud()
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
 <03cb3c24f10818c0780a08509628893ab460e5d1.1734407924.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <03cb3c24f10818c0780a08509628893ab460e5d1.1734407924.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6ScsY4pE_-xjnuycfePm8bKDAspoMDHOzsZj48mymGA_1734720768
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.12.24 06:12, Alistair Popple wrote:
> Currently DAX folio/page reference counts are managed differently to
> normal pages. To allow these to be managed the same as normal pages
> introduce vmf_insert_folio_pud. This will map the entire PUD-sized folio
> and take references as it would for a normally mapped page.
> 
> This is distinct from the current mechanism, vmf_insert_pfn_pud, which
> simply inserts a special devmap PUD entry into the page table without
> holding a reference to the page for the mapping.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   include/linux/huge_mm.h | 11 +++++-
>   mm/huge_memory.c        | 96 ++++++++++++++++++++++++++++++++++++------
>   2 files changed, 95 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 93e509b..012137b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -39,6 +39,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   
>   vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
>   vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
> +vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio, bool write);
>   
>   enum transparent_hugepage_flag {
>   	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
> @@ -458,6 +459,11 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
>   	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
>   }
>   
> +static inline bool is_huge_zero_pud(pud_t pud)
> +{
> +	return false;
> +}
> +
>   struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
>   void mm_put_huge_zero_folio(struct mm_struct *mm);
>   
> @@ -604,6 +610,11 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
>   	return false;
>   }
>   
> +static inline bool is_huge_zero_pud(pud_t pud)
> +{
> +	return false;
> +}
> +

I'm really not a fan of these, because I assume we will never ever 
implement these any time soon. (who will waste 1 GiG or more on faster 
reading of 0s?)


>   static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
>   {
>   	return;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 120cd2c..5081808 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1482,19 +1482,17 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>   	struct mm_struct *mm = vma->vm_mm;
>   	pgprot_t prot = vma->vm_page_prot;
>   	pud_t entry;
> -	spinlock_t *ptl;
>   
> -	ptl = pud_lock(mm, pud);
>   	if (!pud_none(*pud)) {
>   		if (write) {
>   			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
> -				goto out_unlock;
> +				return;
>   			entry = pud_mkyoung(*pud);
>   			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
>   			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
>   				update_mmu_cache_pud(vma, addr, pud);
>   		}
> -		goto out_unlock;
> +		return;
>   	}
>   
>   	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
> @@ -1508,9 +1506,6 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>   	}
>   	set_pud_at(mm, addr, pud, entry);
>   	update_mmu_cache_pud(vma, addr, pud);
> -
> -out_unlock:
> -	spin_unlock(ptl);
>   }
>   
>   /**
> @@ -1528,6 +1523,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>   	unsigned long addr = vmf->address & PUD_MASK;
>   	struct vm_area_struct *vma = vmf->vma;
>   	pgprot_t pgprot = vma->vm_page_prot;
> +	spinlock_t *ptl;
>   
>   	/*
>   	 * If we had pud_special, we could avoid all these restrictions,
> @@ -1545,10 +1541,55 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>   
>   	track_pfn_insert(vma, &pgprot, pfn);
>   
> +	ptl = pud_lock(vma->vm_mm, vmf->pud);
>   	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
> +	spin_unlock(ptl);
> +
>   	return VM_FAULT_NOPAGE;
>   }
>   EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
> +
> +/**
> + * vmf_insert_folio_pud - insert a pud size folio mapped by a pud entry
> + * @vmf: Structure describing the fault
> + * @pfn: pfn of the page to insert
> + * @write: whether it's a write fault
> + *
> + * Return: vm_fault_t value.
> + */
> +vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio, bool write)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	unsigned long addr = vmf->address & PUD_MASK;
> +	pfn_t pfn = pfn_to_pfn_t(folio_pfn(folio));
> +	pud_t *pud = vmf->pud;
> +	pgprot_t prot = vma->vm_page_prot;

See below, pfn, prot and page can likely go.

> +	struct mm_struct *mm = vma->vm_mm;
> +	spinlock_t *ptl;
> +	struct page *page;
> +
> +	if (addr < vma->vm_start || addr >= vma->vm_end)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (WARN_ON_ONCE(folio_order(folio) != PUD_ORDER))
> +		return VM_FAULT_SIGBUS;
> +
> +	track_pfn_insert(vma, &prot, pfn);

Oh, why is that required? We are inserting a folio and start messing 
with VM_PAT on x86 that only applies to VM_PFNMAP mappings? :)

> +
> +	ptl = pud_lock(mm, pud);
> +	if (pud_none(*vmf->pud)) {
> +		page = pfn_t_to_page(pfn);

Why are we suddenly working with that pfn_t whichcraft? :)


> +		folio = page_folio(page);

Ehm, you got the folio ... passed into this function?

Why can't that simply be

folio_get(folio);
folio_add_file_rmap_pud(folio, folio_page(folio, 0), vma);

> +		folio_get(folio);
> +		folio_add_file_rmap_pud(folio, page, vma);
> +		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
> +	}
> +	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
> +	spin_unlock(ptl);
> +
> +	return VM_FAULT_NOPAGE;
> +}
> +EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
>   #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>   
>   void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
> @@ -2146,7 +2187,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   			zap_deposited_table(tlb->mm, pmd);
>   		spin_unlock(ptl);
>   	} else if (is_huge_zero_pmd(orig_pmd)) {
> -		zap_deposited_table(tlb->mm, pmd);
> +		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
> +			zap_deposited_table(tlb->mm, pmd);
>   		spin_unlock(ptl);
>   	} else {
>   		struct folio *folio = NULL;
> @@ -2634,12 +2676,24 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
>   	arch_check_zapped_pud(vma, orig_pud);
>   	tlb_remove_pud_tlb_entry(tlb, pud, addr);
> -	if (vma_is_special_huge(vma)) {
> +	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
>   		spin_unlock(ptl);
>   		/* No zero page support yet */
>   	} else {
> -		/* No support for anonymous PUD pages yet */
> -		BUG();
> +		struct page *page = NULL;
> +		struct folio *folio;
> +
> +		/* No support for anonymous PUD pages or migration yet */
> +		BUG_ON(vma_is_anonymous(vma) || !pud_present(orig_pud));

VM_WARN_ON_ONCE().

> +
> +		page = pud_page(orig_pud);
> +		folio = page_folio(page);
> +		folio_remove_rmap_pud(folio, page, vma);
> +		VM_BUG_ON_PAGE(!PageHead(page), page);

Please drop that or so something like

VM_WARN_ON_ONCE(page != folio_page(folio, 0));

> +		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
> +
> +		spin_unlock(ptl);
> +		tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE);
>   	}
>   	return 1;
>   }
> @@ -2647,6 +2701,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>   		unsigned long haddr)
>   {
> +	pud_t old_pud;
> +
>   	VM_BUG_ON(haddr & ~HPAGE_PUD_MASK);
>   	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
>   	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PUD_SIZE, vma);
> @@ -2654,7 +2710,23 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>   
>   	count_vm_event(THP_SPLIT_PUD);
>   
> -	pudp_huge_clear_flush(vma, haddr, pud);
> +	old_pud = pudp_huge_clear_flush(vma, haddr, pud);
> +	if (is_huge_zero_pud(old_pud))
> +		return;
> +
> +	if (vma_is_dax(vma)) {

Maybe you want

if (!vma_is_dax(vma))
	return;

To then reduce alignment. I suspect all other splitting code (besides 
anon memory) will want to do the same thing here in the future.

-- 
Cheers,

David / dhildenb


