Return-Path: <nvdimm+bounces-3839-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A4D528F78
	for <lists+linux-nvdimm@lfdr.de>; Mon, 16 May 2022 22:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30A39280A8B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 16 May 2022 20:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162681390;
	Mon, 16 May 2022 20:30:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27179A35
	for <nvdimm@lists.linux.dev>; Mon, 16 May 2022 20:30:43 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id h186so12490993pgc.3
        for <nvdimm@lists.linux.dev>; Mon, 16 May 2022 13:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ACVB3Y0E0YBB7tPTLWC9kOdJEJz9VBk49uvnZGm168=;
        b=qGydRqSWRmHEQXYWmP7xMI27DcIFY/huv3iAZeyWMrXsevjA/vluKjedm9wtt9X32P
         iUvChArCrzR4ORotZg6i6NqXMMeXQ5c0xG80tUiASZRn6cwEMkpCy+spDWjB/0AmYeSe
         9y33tA/Zw1YcrbeOz3ij6n39xxkrUCu7fQYZvNDNJ/+7QTq/o47w94oCDPsvP/jLiIWq
         3GgfFkC9tcKnoewv3pgIJX1LVvsI/MOFs1pIJziXrfIqYY38MkQGstWWozTQtPWcJbea
         TpOIcniKYiC3q8XlKKDX/TlRQRn6fsBB/qWp+q79LMsO+hn9bBhXZPy994JoFyC2Vfll
         gXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ACVB3Y0E0YBB7tPTLWC9kOdJEJz9VBk49uvnZGm168=;
        b=a/AK58LItdDVlcgauAE0qGpyfskzyVmM1qaaRktxGmmXdeI02YTvjaJHGbelH05Fsu
         lgJMS0SFZrYzKIk9V+snEDbQoPDibiSiIMQcrQEtn8xTu4A5RrTQLreTjprQ/WxErM4p
         KSn8aF7zKSKWg3Z1FBHEtCNmkxzkZcekJJe9GK9klzvr2FijKoqlmVfegogkE1P9Bryz
         jM5Y+TTXw/N3sn+d7NMK8nyuwB0L/cA6vgiBA1V8LhvHcMArYiiQWKwheNzVYAYwCbOQ
         1lvSfITyYy1V+JeOtq2lmvvt7wQ2fXhkC79VZhOMNNJOHJCHhuQtWzIXNkhkV1oZiyVw
         ZY3g==
X-Gm-Message-State: AOAM533gPirMLXTIRyu2KMRlzhkt/ZIkoqkLYE4DAA6XQXsgth/SwI7k
	AmD59zj4MrkvPc/mmqVgqf8bxp86OhCvt48owOWBZg==
X-Google-Smtp-Source: ABdhPJxNfgFTQfSkBwC0NJUOFm4ZykQQ/RD3rs42AoQjvgd05emu3aDGtrxluv0uzUNgQwYGRoYx/NUiZsqjsEDg+7c=
X-Received: by 2002:a62:a105:0:b0:50d:c97b:3084 with SMTP id
 b5-20020a62a105000000b0050dc97b3084mr18768863pff.61.1652733042575; Mon, 16
 May 2022 13:30:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220422224508.440670-1-jane.chu@oracle.com> <20220422224508.440670-3-jane.chu@oracle.com>
In-Reply-To: <20220422224508.440670-3-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 May 2022 13:30:31 -0700
Message-ID: <CAPcyv4g02C5LnDxqDG0_U51+v05fQa966LnrvvdadN2Eqf7eKA@mail.gmail.com>
Subject: Re: [PATCH v9 2/7] x86/mce: relocate set{clear}_mce_nospec() functions
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 22, 2022 at 3:46 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
> file where they belong.
>
> While at it, fixup a function name in a comment.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/include/asm/set_memory.h | 52 -------------------------------
>  arch/x86/mm/pat/set_memory.c      | 49 ++++++++++++++++++++++++++++-
>  include/linux/set_memory.h        |  8 ++---
>  3 files changed, 52 insertions(+), 57 deletions(-)
>
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 78ca53512486..b45c4d27fd46 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -86,56 +86,4 @@ bool kernel_page_present(struct page *page);
>
>  extern int kernel_set_to_readonly;
>
> -#ifdef CONFIG_X86_64
> -/*
> - * Prevent speculative access to the page by either unmapping
> - * it (if we do not require access to any part of the page) or
> - * marking it uncacheable (if we want to try to retrieve data
> - * from non-poisoned lines in the page).
> - */
> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
> -{
> -       unsigned long decoy_addr;
> -       int rc;
> -
> -       /* SGX pages are not in the 1:1 map */
> -       if (arch_is_platform_page(pfn << PAGE_SHIFT))
> -               return 0;
> -       /*
> -        * We would like to just call:
> -        *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
> -        * but doing that would radically increase the odds of a
> -        * speculative access to the poison page because we'd have
> -        * the virtual address of the kernel 1:1 mapping sitting
> -        * around in registers.
> -        * Instead we get tricky.  We create a non-canonical address
> -        * that looks just like the one we want, but has bit 63 flipped.
> -        * This relies on set_memory_XX() properly sanitizing any __pa()
> -        * results with __PHYSICAL_MASK or PTE_PFN_MASK.
> -        */
> -       decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
> -
> -       if (unmap)
> -               rc = set_memory_np(decoy_addr, 1);
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> -       if (rc)
> -               pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
> -       return rc;
> -}
> -#define set_mce_nospec set_mce_nospec
> -
> -/* Restore full speculative operation to the pfn. */
> -static inline int clear_mce_nospec(unsigned long pfn)
> -{
> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> -}
> -#define clear_mce_nospec clear_mce_nospec
> -#else
> -/*
> - * Few people would run a 32-bit kernel on a machine that supports
> - * recoverable errors because they have too much memory to boot 32-bit.
> - */
> -#endif
> -
>  #endif /* _ASM_X86_SET_MEMORY_H */
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index abf5ed76e4b7..978cf5bd2ab6 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>  }
>
>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed
>   * a pgprot_t value from upper layers and a reservation has already been taken.
>   * If you want to set the pgprot to a specific page protocol, use the
>   * set_memory_xx() functions.
> @@ -1925,6 +1925,53 @@ int set_memory_wb(unsigned long addr, int numpages)
>  }
>  EXPORT_SYMBOL(set_memory_wb);
>
> +/*
> + * Prevent speculative access to the page by either unmapping
> + * it (if we do not require access to any part of the page) or
> + * marking it uncacheable (if we want to try to retrieve data
> + * from non-poisoned lines in the page).
> + */
> +int set_mce_nospec(unsigned long pfn, bool unmap)
> +{
> +       unsigned long decoy_addr;
> +       int rc;
> +
> +       if (!IS_ENABLED(CONFIG_64BIT))
> +               return 0;
> +
> +       /* SGX pages are not in the 1:1 map */
> +       if (arch_is_platform_page(pfn << PAGE_SHIFT))
> +               return 0;
> +       /*
> +        * We would like to just call:
> +        *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
> +        * but doing that would radically increase the odds of a
> +        * speculative access to the poison page because we'd have
> +        * the virtual address of the kernel 1:1 mapping sitting
> +        * around in registers.
> +        * Instead we get tricky.  We create a non-canonical address
> +        * that looks just like the one we want, but has bit 63 flipped.
> +        * This relies on set_memory_XX() properly sanitizing any __pa()
> +        * results with __PHYSICAL_MASK or PTE_PFN_MASK.
> +        */
> +       decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
> +
> +       if (unmap)
> +               rc = set_memory_np(decoy_addr, 1);
> +       else
> +               rc = set_memory_uc(decoy_addr, 1);
> +       if (rc)
> +               pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
> +       return rc;
> +}
> +
> +/* Restore full speculative operation to the pfn. */
> +int clear_mce_nospec(unsigned long pfn)
> +{
> +       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +}
> +EXPORT_SYMBOL_GPL(clear_mce_nospec);
> +
>  int set_memory_x(unsigned long addr, int numpages)
>  {
>         if (!(__supported_pte_mask & _PAGE_NX))
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index f36be5166c19..683a6c3f7179 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -42,14 +42,14 @@ static inline bool can_set_direct_map(void)
>  #endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>
> -#ifndef set_mce_nospec
> +#ifdef CONFIG_X86_64

Jane,

I just noticed that this makes set_mce_nospec() and clear_mce_nospec()
x86_64-only. If / when more architectures add support for these
helpers they will need to go back to the "#ifndef $symbol" scheme to
allow asm/set_memory.h to indicate the availability of the arch-local
helper.

