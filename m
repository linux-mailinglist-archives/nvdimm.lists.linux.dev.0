Return-Path: <nvdimm+bounces-3270-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 614904D3E10
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 01:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 57F171C0B18
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 00:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71E918D;
	Thu, 10 Mar 2022 00:26:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFA57F
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 00:26:44 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so6771925pjb.4
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 16:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQ5sXziCooHIXl/2HjfAKdxZRIJNOqLHKmehhq6dXuA=;
        b=BL8aZPjjssce7mPIFAhJDomv2XOSpSrRSP853T81aBGL+M6NcK9YcFzmJpP0giYrg4
         MKjwmuR5cyz1YvkZRXk1TjltfMkqPdoCr2FXdjzJ7I/cjLvblsrN4WtBAELWtx4yQ69S
         0H3P9B/ef+y6d0YURAFjxdo1eKIeIGrC8PbTJSLpeWlkcadMmtllbmBUYIS1nbna07pD
         ksdaNFUAHuou32qpeI0QL9gBAqUqRT48ElCvgHzHG2Bm33jTGTppZwh2d8hiibAphSHo
         HLoq/xTLmIrNjgJkj+63J5yI+YyAwkUr124mum33cc748kn0/0V9MVi8m0b+hP6yASuA
         xadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQ5sXziCooHIXl/2HjfAKdxZRIJNOqLHKmehhq6dXuA=;
        b=fWqT6Rq+AW+0jlWrTHxvDrhwxoh3txr5ihZb3nNqcMMgbskuAb6W72OUAYMoqlWnCo
         DrxGGhTXLzrWVNJad65leZDZY9uZ51S6qZUAb0eEGKOGELNWcoNDhsdcKX5wUlWYPLnN
         f63px9iiQE3RHjoz/lss/xJkTHtjEyIA5Uy8VCOajBr4q+a1ZUUezbkm9awfydh5Tls5
         Q+9YbI4Haq2XFLPYtUaz/GxumbXiIDD8+FzP6/AOjUsemppwxGGAFQ/hinp+4GJ5Lrxk
         QFllaN34bXoM/n51GtUx8NeoZirTxfwRZbJU1j5z8OmnGlJbxDBjmS1wku1kvQlC2Ser
         05xA==
X-Gm-Message-State: AOAM532BmDWiic0b7Fil2C8IwojYzNAcrR895/mpAvfYpwbxsjWT6Mw4
	8dEBKA4whnmNEq27iMbXJ2l+95iOHxI09kVjzvz/Ug==
X-Google-Smtp-Source: ABdhPJxjIr4DaptrkFT5V+OR8NeLez/jndrqxCyEZZrZiO4/OHN8jNUcL9x0ITJHBLLjCMHbEJHuO58kdXgVLJIv5GA=
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id
 q13-20020a17090a430d00b001bcf3408096mr2138031pjg.93.1646872003959; Wed, 09
 Mar 2022 16:26:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com> <20220302082718.32268-4-songmuchun@bytedance.com>
In-Reply-To: <20220302082718.32268-4-songmuchun@bytedance.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 16:26:33 -0800
Message-ID: <CAPcyv4iv4LXLbmj=O0ugzo7yju1ePbEWWrs5VQ3t3VgAgOLYyw@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
To: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, xiyuyang19@fudan.edu.cn, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	duanxiongchun@bytedance.com, Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 2, 2022 at 12:29 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The page_mkclean_one() is supposed to be used with the pfn that has a
> associated struct page, but not all the pfns (e.g. DAX) have a struct
> page. Introduce a new function pfn_mkclean_range() to cleans the PTEs
> (including PMDs) mapped with range of pfns which has no struct page
> associated with them. This helper will be used by DAX device in the
> next patch to make pfns clean.

This seems unfortunate given the desire to kill off
CONFIG_FS_DAX_LIMITED which is the only way to get DAX without 'struct
page'.

I would special case these helpers behind CONFIG_FS_DAX_LIMITED such
that they can be deleted when that support is finally removed.

>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/rmap.h |  3 +++
>  mm/internal.h        | 26 +++++++++++++--------
>  mm/rmap.c            | 65 +++++++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 74 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index b58ddb8b2220..a6ec0d3e40c1 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -263,6 +263,9 @@ unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
>   */
>  int folio_mkclean(struct folio *);
>
> +int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
> +                     struct vm_area_struct *vma);
> +
>  void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
>
>  /*
> diff --git a/mm/internal.h b/mm/internal.h
> index f45292dc4ef5..ff873944749f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -516,26 +516,22 @@ void mlock_page_drain(int cpu);
>  extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
>
>  /*
> - * At what user virtual address is page expected in vma?
> - * Returns -EFAULT if all of the page is outside the range of vma.
> - * If page is a compound head, the entire compound page is considered.
> + * * Return the start of user virtual address at the specific offset within
> + * a vma.
>   */
>  static inline unsigned long
> -vma_address(struct page *page, struct vm_area_struct *vma)
> +vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
> +                 struct vm_area_struct *vma)
>  {
> -       pgoff_t pgoff;
>         unsigned long address;
>
> -       VM_BUG_ON_PAGE(PageKsm(page), page);    /* KSM page->index unusable */
> -       pgoff = page_to_pgoff(page);
>         if (pgoff >= vma->vm_pgoff) {
>                 address = vma->vm_start +
>                         ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
>                 /* Check for address beyond vma (or wrapped through 0?) */
>                 if (address < vma->vm_start || address >= vma->vm_end)
>                         address = -EFAULT;
> -       } else if (PageHead(page) &&
> -                  pgoff + compound_nr(page) - 1 >= vma->vm_pgoff) {
> +       } else if (pgoff + nr_pages - 1 >= vma->vm_pgoff) {
>                 /* Test above avoids possibility of wrap to 0 on 32-bit */
>                 address = vma->vm_start;
>         } else {
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
> +       VM_BUG_ON_PAGE(PageKsm(page), page);    /* KSM page->index unusable */
> +       return vma_pgoff_address(page_to_pgoff(page), compound_nr(page), vma);
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
>         return pra.referenced;
>  }
>
> -static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
> -                           unsigned long address, void *arg)
> +static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  {
> -       DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
> +       int cleaned = 0;
> +       struct vm_area_struct *vma = pvmw->vma;
>         struct mmu_notifier_range range;
> -       int *cleaned = arg;
> +       unsigned long address = pvmw->address;
>
>         /*
>          * We have to assume the worse case ie pmd for invalidation. Note that
> @@ -942,16 +942,16 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>          */
>         mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
>                                 0, vma, vma->vm_mm, address,
> -                               vma_address_end(&pvmw));
> +                               vma_address_end(pvmw));
>         mmu_notifier_invalidate_range_start(&range);
>
> -       while (page_vma_mapped_walk(&pvmw)) {
> +       while (page_vma_mapped_walk(pvmw)) {
>                 int ret = 0;
>
> -               address = pvmw.address;
> -               if (pvmw.pte) {
> +               address = pvmw->address;
> +               if (pvmw->pte) {
>                         pte_t entry;
> -                       pte_t *pte = pvmw.pte;
> +                       pte_t *pte = pvmw->pte;
>
>                         if (!pte_dirty(*pte) && !pte_write(*pte))
>                                 continue;
> @@ -964,7 +964,7 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>                         ret = 1;
>                 } else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -                       pmd_t *pmd = pvmw.pmd;
> +                       pmd_t *pmd = pvmw->pmd;
>                         pmd_t entry;
>
>                         if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
> @@ -991,11 +991,22 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>                  * See Documentation/vm/mmu_notifier.rst
>                  */
>                 if (ret)
> -                       (*cleaned)++;
> +                       cleaned++;
>         }
>
>         mmu_notifier_invalidate_range_end(&range);
>
> +       return cleaned;
> +}
> +
> +static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
> +                            unsigned long address, void *arg)
> +{
> +       DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
> +       int *cleaned = arg;
> +
> +       *cleaned += page_vma_mkclean_one(&pvmw);
> +
>         return true;
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
> +                     struct vm_area_struct *vma)
> +{
> +       struct page_vma_mapped_walk pvmw = {
> +               .pfn            = pfn,
> +               .nr_pages       = nr_pages,
> +               .pgoff          = pgoff,
> +               .vma            = vma,
> +               .flags          = PVMW_SYNC,
> +       };
> +
> +       if (invalid_mkclean_vma(vma, NULL))
> +               return 0;
> +
> +       pvmw.address = vma_pgoff_address(pgoff, nr_pages, vma);
> +       VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
> +
> +       return page_vma_mkclean_one(&pvmw);
> +}
> +
> +/**
>   * page_move_anon_rmap - move a page to our anon_vma
>   * @page:      the page to move to our anon_vma
>   * @vma:       the vma the page belongs to
> --
> 2.11.0
>

