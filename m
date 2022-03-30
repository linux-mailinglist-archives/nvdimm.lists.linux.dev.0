Return-Path: <nvdimm+bounces-3402-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id B762A4EBA62
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Mar 2022 07:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id DF61C3E0E9A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Mar 2022 05:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315F438D;
	Wed, 30 Mar 2022 05:47:43 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C923536E
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 05:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vw5qTSSzO3QHkcPG1YYXvDz/oVNGsao4uDjLH+4hLTk=; b=XREisISkU0hHxrqIkIdvO9MNRn
	FaeQKbgJIZhQqVUcIbuyeDkBl7PulOxYhTzSYTpGSJoOQN1bkwwqmDmsGTwhCDcz0Psz5RzT503pr
	DYGTxCubvd3nz22y3ygeTSl3ly9hSHXqj0pCdDhpNzgO4G8XaIrNJAfnn8saNsauYhZGJSPhzS0sn
	LCmBRG88QiaxhxkzGXzGCGoxPj8M2LlwH9dSY5Mgs60XT93nXWTSGo3B81ENkUkQzXyc1Hpt8oarG
	fsyPU9Pq2qGq9wp2kNCn1+kOrxoatU8oI1XL7v8L2FNKSr48mJZg5apP9Tf8rSlzdLf1JUuwggNxv
	fg++ZXcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZRAz-00EN0z-An; Wed, 30 Mar 2022 05:47:25 +0000
Date: Tue, 29 Mar 2022 22:47:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, duanxiongchun@bytedance.com, smuchun@gmail.com,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: Re: [PATCH v6 3/6] mm: rmap: introduce pfn_mkclean_range() to cleans
 PTEs
Message-ID: <YkPu7XjYzkQLVMw/@infradead.org>
References: <20220329134853.68403-1-songmuchun@bytedance.com>
 <20220329134853.68403-4-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329134853.68403-4-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 29, 2022 at 09:48:50PM +0800, Muchun Song wrote:
> + * * Return the start of user virtual address at the specific offset within

Double "*" here.

Also Shiyang has been wanting a quite similar vma_pgoff_address for use
in dax.c.  Maybe we'll need to look into moving this to linux/mm.h.

>  static inline unsigned long
> -vma_address(struct page *page, struct vm_area_struct *vma)
> +vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
> +		  struct vm_area_struct *vma)
>  {
> -	pgoff_t pgoff;
>  	unsigned long address;
>  
> -	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
> -	pgoff = page_to_pgoff(page);
>  	if (pgoff >= vma->vm_pgoff) {
>  		address = vma->vm_start +
>  			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
>  		/* Check for address beyond vma (or wrapped through 0?) */
>  		if (address < vma->vm_start || address >= vma->vm_end)
>  			address = -EFAULT;
> -	} else if (PageHead(page) &&
> -		   pgoff + compound_nr(page) - 1 >= vma->vm_pgoff) {
> +	} else if (pgoff + nr_pages - 1 >= vma->vm_pgoff) {
>  		/* Test above avoids possibility of wrap to 0 on 32-bit */
>  		address = vma->vm_start;
>  	} else {
> @@ -545,6 +541,18 @@ vma_address(struct page *page, struct vm_area_struct *vma)
>  }
>  
>  /*
> + * Return the start of user virtual address of a page within a vma.
> + * Returns -EFAULT if all of the page is outside the range of vma.
> + * If page is a compound head, the entire compound page is considered.
> + */
> +static inline unsigned long
> +vma_address(struct page *page, struct vm_area_struct *vma)
> +{
> +	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
> +	return vma_pgoff_address(page_to_pgoff(page), compound_nr(page), vma);
> +}
> +
> +/*
>   * Then at what user virtual address will none of the range be found in vma?
>   * Assumes that vma_address() already returned a good starting address.
>   */
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 723682ddb9e8..ad5cf0e45a73 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -929,12 +929,12 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	return pra.referenced;
>  }
>  
> -static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
> -			    unsigned long address, void *arg)
> +static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  {
> -	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
> +	int cleaned = 0;
> +	struct vm_area_struct *vma = pvmw->vma;
>  	struct mmu_notifier_range range;
> -	int *cleaned = arg;
> +	unsigned long address = pvmw->address;
>  
>  	/*
>  	 * We have to assume the worse case ie pmd for invalidation. Note that
> @@ -942,16 +942,16 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>  	 */
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
>  				0, vma, vma->vm_mm, address,
> -				vma_address_end(&pvmw));
> +				vma_address_end(pvmw));
>  	mmu_notifier_invalidate_range_start(&range);
>  
> -	while (page_vma_mapped_walk(&pvmw)) {
> +	while (page_vma_mapped_walk(pvmw)) {
>  		int ret = 0;
>  
> -		address = pvmw.address;
> -		if (pvmw.pte) {
> +		address = pvmw->address;
> +		if (pvmw->pte) {
>  			pte_t entry;
> -			pte_t *pte = pvmw.pte;
> +			pte_t *pte = pvmw->pte;
>  
>  			if (!pte_dirty(*pte) && !pte_write(*pte))
>  				continue;
> @@ -964,7 +964,7 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>  			ret = 1;
>  		} else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -			pmd_t *pmd = pvmw.pmd;
> +			pmd_t *pmd = pvmw->pmd;
>  			pmd_t entry;
>  
>  			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
> @@ -991,11 +991,22 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * See Documentation/vm/mmu_notifier.rst
>  		 */
>  		if (ret)
> -			(*cleaned)++;
> +			cleaned++;
>  	}
>  
>  	mmu_notifier_invalidate_range_end(&range);
>  
> +	return cleaned;
> +}
> +
> +static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
> +			     unsigned long address, void *arg)
> +{
> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
> +	int *cleaned = arg;
> +
> +	*cleaned += page_vma_mkclean_one(&pvmw);
> +
>  	return true;
>  }
>  
> @@ -1033,6 +1044,38 @@ int folio_mkclean(struct folio *folio)
>  EXPORT_SYMBOL_GPL(folio_mkclean);
>  
>  /**
> + * pfn_mkclean_range - Cleans the PTEs (including PMDs) mapped with range of
> + *                     [@pfn, @pfn + @nr_pages) at the specific offset (@pgoff)
> + *                     within the @vma of shared mappings. And since clean PTEs
> + *                     should also be readonly, write protects them too.
> + * @pfn: start pfn.
> + * @nr_pages: number of physically contiguous pages srarting with @pfn.
> + * @pgoff: page offset that the @pfn mapped with.
> + * @vma: vma that @pfn mapped within.
> + *
> + * Returns the number of cleaned PTEs (including PMDs).
> + */
> +int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
> +		      struct vm_area_struct *vma)
> +{
> +	struct page_vma_mapped_walk pvmw = {
> +		.pfn		= pfn,
> +		.nr_pages	= nr_pages,
> +		.pgoff		= pgoff,
> +		.vma		= vma,
> +		.flags		= PVMW_SYNC,
> +	};
> +
> +	if (invalid_mkclean_vma(vma, NULL))
> +		return 0;
> +
> +	pvmw.address = vma_pgoff_address(pgoff, nr_pages, vma);
> +	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
> +
> +	return page_vma_mkclean_one(&pvmw);
> +}
> +
> +/**
>   * page_move_anon_rmap - move a page to our anon_vma
>   * @page:	the page to move to our anon_vma
>   * @vma:	the vma the page belongs to
> -- 
> 2.11.0
> 
---end quoted text---

