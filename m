Return-Path: <nvdimm+bounces-3034-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 52DAF4B7C98
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Feb 2022 02:47:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id B4CBC3E0E79
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Feb 2022 01:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26583187F;
	Wed, 16 Feb 2022 01:47:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1321844
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 01:47:26 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id 10so838254plj.1
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 17:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nlq8z2arOhNkxaYYwLaD3RpZ3GoR+UWwTLLnfnZTXnY=;
        b=DMFJ896b0Vz97kUGCM8E2K0r8djjVIJRIYsuIAYOAkaBkfNx2QQREloFJCf8CCj90h
         nKbD8u01PBQSSUY4vqTZ47YDWw/7PCDnAZR43J2UUhOWiepjRATef/AE87HO4hR7J2nz
         GU11Ftko5mrJ93140D/KkqH3K/LZp7UXoU/O7KYuYnti1rfi+dGGasqbL8Ese5rf7bo9
         0zlx0b2y45jW/cov0X+AFCz60VpwmqGu+eu6OeJ6DLRZRoZejU+362F7o9KjYYX+BWaK
         Z6uEVIvEuOOUm7Sj5OgLhqGQtk5FGMlS5mNoa//ff5PaLIM4owD5EtniIIHFb0scDZ9e
         EWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nlq8z2arOhNkxaYYwLaD3RpZ3GoR+UWwTLLnfnZTXnY=;
        b=IrEpdtQdrRvU6JyG09AC0YhwyaY5MIWMW1D9+JkRGUIDyo1iFSj6mNip/P6ujEK0b3
         1w9AfVQCyPQaQMa8G5Sta23sAvs6+9iROWFBNYjqY5ApXfPC2gC16sGEe2CiyunxAs8+
         JmNCP+U6JbiLus3E0Ggm419AWoTn7ETa77+iG08a77o2N2sFzq01O7YS59tIh4LtOvjX
         zqsBhC8aZWYwuYdPSI1xSdwXc2WcqsP5ss02FQnhqL+j5QNTzHNvxL3ssLKfFXEErRmF
         iA5J4r0foS3l4oMnVUX7tHIYCoWK/tXk9OsFzPVsLxuQIdUjj7a8n4VbxoMis/6Vw0oC
         6Urg==
X-Gm-Message-State: AOAM531lan0rSV5WCgZowP7F+BMmThQG0NTbAEMFQicXAriIUK7En7TC
	5dm7gL+axOAoYE3t/fRjrPGe1243qSiTFECM04g0xA==
X-Google-Smtp-Source: ABdhPJwT3hvSagc3TEPzllcZbvtit0z9Qok37GmkfTUSfHMWGioDKT1cQ4/685zOQu/6xCOe6mcuODN03F7rGWAFZWg=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr636363pll.132.1644976045685; Tue, 15
 Feb 2022 17:47:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-8-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 17:47:19 -0800
Message-ID: <CAPcyv4i_mGFO4z3sVYShhhvBO_WASee-EfZK0U+qWw5usDWzxQ@mail.gmail.com>
Subject: Re: [PATCH v10 7/9] mm: Introduce mf_dax_kill_procs() for fsdax case
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> This function is called at the end of RMAP routine, i.e. filesystem
> recovery function, to collect and kill processes using a shared page of
> DAX file.  The difference with mf_generic_kill_procs() is, it accepts
> file's (mapping,offset) instead of struct page because different files'
> mappings and offsets may share the same page in fsdax mode.
> It will be called when filesystem's RMAP results are found.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/mm.h  |  4 ++
>  mm/memory-failure.c | 91 +++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 84 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9b1d56c5c224..0420189e4788 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3195,6 +3195,10 @@ enum mf_flags {
>         MF_SOFT_OFFLINE = 1 << 3,
>         MF_UNPOISON = 1 << 4,
>  };
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> +                     unsigned long count, int mf_flags);
> +#endif /* CONFIG_FS_DAX */
>  extern int memory_failure(unsigned long pfn, int flags);
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  extern void memory_failure_queue_kick(int cpu);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b2d13eba1071..8d123cc4102e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -304,10 +304,9 @@ void shake_page(struct page *p)
>  }
>  EXPORT_SYMBOL_GPL(shake_page);
>
> -static unsigned long dev_pagemap_mapping_shift(struct page *page,
> -               struct vm_area_struct *vma)
> +static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
> +               unsigned long address)
>  {
> -       unsigned long address = vma_address(page, vma);
>         unsigned long ret = 0;
>         pgd_t *pgd;
>         p4d_t *p4d;
> @@ -347,9 +346,8 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
>   * Schedule a process for later kill.
>   * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
>   */
> -static void add_to_kill(struct task_struct *tsk, struct page *p,
> -                      struct vm_area_struct *vma,
> -                      struct list_head *to_kill)
> +static void add_to_kill(struct task_struct *tsk, struct page *p, pgoff_t pgoff,
> +                       struct vm_area_struct *vma, struct list_head *to_kill)
>  {
>         struct to_kill *tk;
>
> @@ -360,9 +358,15 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
>         }
>
>         tk->addr = page_address_in_vma(p, vma);
> -       if (is_zone_device_page(p))
> -               tk->size_shift = dev_pagemap_mapping_shift(p, vma);
> -       else
> +       if (is_zone_device_page(p)) {
> +               /*
> +                * Since page->mapping is not used for fsdax, we need
> +                * calculate the address based on the vma.
> +                */
> +               if (p->pgmap->type == MEMORY_DEVICE_FS_DAX)
> +                       tk->addr = vma_pgoff_address(vma, pgoff);
> +               tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
> +       } else
>                 tk->size_shift = page_shift(compound_head(p));
>
>         /*
> @@ -510,7 +514,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
>                         if (!page_mapped_in_vma(page, vma))
>                                 continue;
>                         if (vma->vm_mm == t->mm)
> -                               add_to_kill(t, page, vma, to_kill);
> +                               add_to_kill(t, page, 0, vma, to_kill);

Why is the @pgoff argument 0? @pgoff is available. Not that I expect
dax pages will ever be anonymous, might as well not leave that land
mine for future refactoring.

Other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

