Return-Path: <nvdimm+bounces-3674-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E246750C495
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 01:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CCE8280ABD
	for <lists+linux-nvdimm@lfdr.de>; Fri, 22 Apr 2022 23:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B579A33C9;
	Fri, 22 Apr 2022 23:26:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03523203
	for <nvdimm@lists.linux.dev>; Fri, 22 Apr 2022 23:25:58 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id j6so7015202pfe.13
        for <nvdimm@lists.linux.dev>; Fri, 22 Apr 2022 16:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kg+J0lutmClKCI/mbVYUeiYnCMom4Vl06UJmqL3ZJtk=;
        b=2sK4ko6n7BlY3r3TG8OzRAVyPe1h7zc8rAEdVLjHdq2PKfDVL/FT7Pslh7H83JFdMr
         GuFH8wALKvjAcFX6asFEAZLfn/vTT8SYv72LHIfjr+mNBLu7QongXYEtc9osgfeNORzE
         atQtxcU/uvR/evvZNnsl3Bfk5YIMFJtj0qoI0hBXD7eCJo/+yEOod8AbK19Fjwe53/ev
         WrHwAu83WduuhAHlLFr5lcG6AfYXdDCrN1ayu5hzfVWFafyqTkJhFqJkC7/XRZX5J9Op
         oVFFww3nI/Ud4cKURLuZ2XJm8Qd74eY+OoTb5zD5sfOxZm4F54ba3WbFrlzWKC6eD27i
         rcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kg+J0lutmClKCI/mbVYUeiYnCMom4Vl06UJmqL3ZJtk=;
        b=K9IPGya1w6/Fh7jn21NZ+jOz7lP1K0WyIPR4D3rzADeN1k0hr9GXED/+puePifd/aw
         OIOEIr8ql6yds3CsX5ig+DgYFzHU3RZ/eoElmKNWapt2qKkrkNGS3pHw0giqPmxA9fnx
         gFCL/V+E8hu5r8N/6uvXYR8rab9UQmSdXHH/IH/w6wm/PqZAs9EW7uGJBOnC2MPvoooZ
         kEuDQKBn6vefgDFKWrRgyfRZVdTqDaZZmA9eJ2J/Jt3j0Z8jKKj5hpt1i9+F2Y6XRnhq
         ucW7XT/uz5ucATgphSbL1XtEESkeMq8abzetkyjeIsNSPks0TCJ35K2hl3OG/3QdqzQ1
         jFBQ==
X-Gm-Message-State: AOAM5336TB9IFj9kDA5BsdQGXGdimTOpeyZthZT1awgWFNII1OqyY1LP
	3lpkLjE8O4NbW6uUHrB8I2e1TPALoWA0vyDBCZy7jQ==
X-Google-Smtp-Source: ABdhPJyk+9NByLvMF4dmHW+MT93xxhaesMYL7U/407zUDtQsybQYu4P3kbbZJirb7qj0n9DVt2vmaTTwis8/njJa1Y8=
X-Received: by 2002:a05:6a00:8c5:b0:4fe:134d:30d3 with SMTP id
 s5-20020a056a0008c500b004fe134d30d3mr7387132pfu.3.1650669958018; Fri, 22 Apr
 2022 16:25:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220422224508.440670-1-jane.chu@oracle.com> <20220422224508.440670-4-jane.chu@oracle.com>
In-Reply-To: <20220422224508.440670-4-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2022 16:25:47 -0700
Message-ID: <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] mce: fix set_mce_nospec to always unmap the whole page
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	"Luck, Tony" <tony.luck@intel.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"

[ Add Tony as the originator of the whole_page() logic and Jue who
reported the issue that lead to 17fae1294ad9 x86/{mce,mm}: Unmap the
entire page if the whole page is affected and poisoned ]


On Fri, Apr 22, 2022 at 3:46 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> The set_memory_uc() approach doesn't work well in all cases.
> As Dan pointed out when "The VMM unmapped the bad page from
> guest physical space and passed the machine check to the guest."
> "The guest gets virtual #MC on an access to that page. When
> the guest tries to do set_memory_uc() and instructs cpa_flush()
> to do clean caches that results in taking another fault / exception
> perhaps because the VMM unmapped the page from the guest."
>
> Since the driver has special knowledge to handle NP or UC,
> mark the poisoned page with NP and let driver handle it when
> it comes down to repair.
>
> Please refer to discussions here for more details.
> https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
>
> Now since poisoned page is marked as not-present, in order to
> avoid writing to a not-present page and trigger kernel Oops,
> also fix pmem_do_write().
>
> Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/kernel/cpu/mce/core.c |  6 +++---
>  arch/x86/mm/pat/set_memory.c   | 23 +++++++++++------------
>  drivers/nvdimm/pmem.c          | 30 +++++++-----------------------
>  include/linux/set_memory.h     |  4 ++--
>  4 files changed, 23 insertions(+), 40 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index 981496e6bc0e..fa67bb9d1afe 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -579,7 +579,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
>
>         pfn = mce->addr >> PAGE_SHIFT;
>         if (!memory_failure(pfn, 0)) {
> -               set_mce_nospec(pfn, whole_page(mce));
> +               set_mce_nospec(pfn);
>                 mce->kflags |= MCE_HANDLED_UC;
>         }
>
> @@ -1316,7 +1316,7 @@ static void kill_me_maybe(struct callback_head *cb)
>
>         ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
>         if (!ret) {
> -               set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
> +               set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>                 sync_core();
>                 return;
>         }
> @@ -1342,7 +1342,7 @@ static void kill_me_never(struct callback_head *cb)
>         p->mce_count = 0;
>         pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
>         if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
> -               set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
> +               set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>  }
>
>  static void queue_task_work(struct mce *m, char *msg, void (*func)(struct callback_head *))
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 978cf5bd2ab6..e3a5e55f3e08 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1925,13 +1925,8 @@ int set_memory_wb(unsigned long addr, int numpages)
>  }
>  EXPORT_SYMBOL(set_memory_wb);
>
> -/*
> - * Prevent speculative access to the page by either unmapping
> - * it (if we do not require access to any part of the page) or
> - * marking it uncacheable (if we want to try to retrieve data
> - * from non-poisoned lines in the page).
> - */
> -int set_mce_nospec(unsigned long pfn, bool unmap)
> +/* Prevent speculative access to a page by marking it not-present */
> +int set_mce_nospec(unsigned long pfn)
>  {
>         unsigned long decoy_addr;
>         int rc;
> @@ -1956,19 +1951,23 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
>          */
>         decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>
> -       if (unmap)
> -               rc = set_memory_np(decoy_addr, 1);
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> +       rc = set_memory_np(decoy_addr, 1);
>         if (rc)
>                 pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>         return rc;
>  }
>
> +static int set_memory_present(unsigned long *addr, int numpages)
> +{
> +       return change_page_attr_set(addr, numpages, __pgprot(_PAGE_PRESENT), 0);
> +}
> +
>  /* Restore full speculative operation to the pfn. */
>  int clear_mce_nospec(unsigned long pfn)
>  {
> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +       unsigned long addr = (unsigned long) pfn_to_kaddr(pfn);
> +
> +       return set_memory_present(&addr, 1);
>  }
>  EXPORT_SYMBOL_GPL(clear_mce_nospec);
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 58d95242a836..4aa17132a557 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -158,36 +158,20 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>                         struct page *page, unsigned int page_off,
>                         sector_t sector, unsigned int len)
>  {
> -       blk_status_t rc = BLK_STS_OK;
> -       bool bad_pmem = false;
>         phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
>         void *pmem_addr = pmem->virt_addr + pmem_off;
>
> -       if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> -               bad_pmem = true;
> +       if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
> +               blk_status_t rc = pmem_clear_poison(pmem, pmem_off, len);
> +
> +               if (rc != BLK_STS_OK)
> +                       return rc;
> +       }
>
> -       /*
> -        * Note that we write the data both before and after
> -        * clearing poison.  The write before clear poison
> -        * handles situations where the latest written data is
> -        * preserved and the clear poison operation simply marks
> -        * the address range as valid without changing the data.
> -        * In this case application software can assume that an
> -        * interrupted write will either return the new good
> -        * data or an error.
> -        *
> -        * However, if pmem_clear_poison() leaves the data in an
> -        * indeterminate state we need to perform the write
> -        * after clear poison.
> -        */
>         flush_dcache_page(page);
>         write_pmem(pmem_addr, page, page_off, len);
> -       if (unlikely(bad_pmem)) {
> -               rc = pmem_clear_poison(pmem, pmem_off, len);
> -               write_pmem(pmem_addr, page, page_off, len);
> -       }
>
> -       return rc;
> +       return BLK_STS_OK;
>  }
>
>  static void pmem_submit_bio(struct bio *bio)
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 683a6c3f7179..369769ce7399 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -43,10 +43,10 @@ static inline bool can_set_direct_map(void)
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>
>  #ifdef CONFIG_X86_64
> -int set_mce_nospec(unsigned long pfn, bool unmap);
> +int set_mce_nospec(unsigned long pfn);
>  int clear_mce_nospec(unsigned long pfn);
>  #else
> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
> +static inline int set_mce_nospec(unsigned long pfn)
>  {
>         return 0;
>  }
> --
> 2.18.4
>

