Return-Path: <nvdimm+bounces-3625-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 2015C508EF3
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Apr 2022 19:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 5D9812E0CD8
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Apr 2022 17:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015D01874;
	Wed, 20 Apr 2022 17:58:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF51867
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 17:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BF2C385A0;
	Wed, 20 Apr 2022 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1650477485;
	bh=HjqNizz2UkQgCdLOC/F3s0q1QlXx1JsTyvOA/jgUXyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YlB03/js/4fzWqeo1WlTqDwGajsOcrbi219jHadJoI410A2TWR5KYbzmWkjj4FJTY
	 McQ/4WftYtN8zwEfhuKO/jH668k4OMSQqSyAxVyNC+PBNR9RO2K6n4+0qT7oeArkA2
	 dMtdNRL1SF4NOuUMpNuEAytkwh8o/l5/rUjmM7M40cHicBLnCzJz7cuse2cVUaHoQB
	 leiLBMZRfOYzv/N41lQ//R5wo9TPQfqwAK1FQ8jThkYv4I8plGVqwJmR7ynVFyVgy7
	 s6gQa6W3Y+VJb8xCGHCMKI8YDNtewZtUemj9SepwCeDbPkXEgam7v6o+Uydsmhh6rs
	 GoZI8BwVbjoaA==
Date: Wed, 20 Apr 2022 10:58:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v13 5/7] mm: Introduce mf_dax_kill_procs() for fsdax case
Message-ID: <20220420175804.GY17025@magnolia>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220419045045.1664996-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419045045.1664996-6-ruansy.fnst@fujitsu.com>

On Tue, Apr 19, 2022 at 12:50:43PM +0800, Shiyang Ruan wrote:
> This new function is a variant of mf_generic_kill_procs that accepts a
> file, offset pair instead of a struct to support multiple files sharing
> a DAX mapping.  It is intended to be called by the file systems as part
> of the memory_failure handler after the file system performed a reverse
> mapping from the storage address to the file and file offset.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  include/linux/mm.h  |  2 +
>  mm/memory-failure.c | 96 ++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 88 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ad4b6c15c814..52208d743546 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3233,6 +3233,8 @@ enum mf_flags {
>  	MF_SOFT_OFFLINE = 1 << 3,
>  	MF_UNPOISON = 1 << 4,
>  };
> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> +		      unsigned long count, int mf_flags);
>  extern int memory_failure(unsigned long pfn, int flags);
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  extern void memory_failure_queue_kick(int cpu);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a40e79e634a4..dc47c5f83d85 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -295,10 +295,9 @@ void shake_page(struct page *p)
>  }
>  EXPORT_SYMBOL_GPL(shake_page);
>  
> -static unsigned long dev_pagemap_mapping_shift(struct page *page,
> -		struct vm_area_struct *vma)
> +static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
> +		unsigned long address)
>  {
> -	unsigned long address = vma_address(page, vma);
>  	unsigned long ret = 0;
>  	pgd_t *pgd;
>  	p4d_t *p4d;
> @@ -338,10 +337,14 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
>  /*
>   * Schedule a process for later kill.
>   * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
> + *
> + * Notice: @fsdax_pgoff is used only when @p is a fsdax page.
> + *   In other cases, such as anonymous and file-backend page, the address to be
> + *   killed can be caculated by @p itself.
>   */
>  static void add_to_kill(struct task_struct *tsk, struct page *p,
> -		       struct vm_area_struct *vma,
> -		       struct list_head *to_kill)
> +			pgoff_t fsdax_pgoff, struct vm_area_struct *vma,
> +			struct list_head *to_kill)
>  {
>  	struct to_kill *tk;
>  
> @@ -352,9 +355,15 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
>  	}
>  
>  	tk->addr = page_address_in_vma(p, vma);
> -	if (is_zone_device_page(p))
> -		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
> -	else
> +	if (is_zone_device_page(p)) {
> +		/*
> +		 * Since page->mapping is not used for fsdax, we need
> +		 * calculate the address based on the vma.
> +		 */
> +		if (p->pgmap->type == MEMORY_DEVICE_FS_DAX)
> +			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
> +		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
> +	} else
>  		tk->size_shift = page_shift(compound_head(p));
>  
>  	/*
> @@ -503,7 +512,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
>  			if (!page_mapped_in_vma(page, vma))
>  				continue;
>  			if (vma->vm_mm == t->mm)
> -				add_to_kill(t, page, vma, to_kill);
> +				add_to_kill(t, page, 0, vma, to_kill);
>  		}
>  	}
>  	read_unlock(&tasklist_lock);
> @@ -539,13 +548,41 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
>  			 * to be informed of all such data corruptions.
>  			 */
>  			if (vma->vm_mm == t->mm)
> -				add_to_kill(t, page, vma, to_kill);
> +				add_to_kill(t, page, 0, vma, to_kill);
>  		}
>  	}
>  	read_unlock(&tasklist_lock);
>  	i_mmap_unlock_read(mapping);
>  }
>  
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +/*
> + * Collect processes when the error hit a fsdax page.
> + */
> +static void collect_procs_fsdax(struct page *page,
> +		struct address_space *mapping, pgoff_t pgoff,
> +		struct list_head *to_kill)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +
> +	i_mmap_lock_read(mapping);
> +	read_lock(&tasklist_lock);
> +	for_each_process(tsk) {
> +		struct task_struct *t = task_early_kill(tsk, true);
> +
> +		if (!t)
> +			continue;
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
> +			if (vma->vm_mm == t->mm)
> +				add_to_kill(t, page, pgoff, vma, to_kill);
> +		}
> +	}
> +	read_unlock(&tasklist_lock);
> +	i_mmap_unlock_read(mapping);
> +}
> +#endif /* CONFIG_FS_DAX */
> +
>  /*
>   * Collect the processes who have the corrupted page mapped to kill.
>   */
> @@ -1582,6 +1619,45 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>  	return rc;
>  }
>  
> +#ifdef CONFIG_FS_DAX
> +/**
> + * mf_dax_kill_procs - Collect and kill processes who are using this file range
> + * @mapping:	the file in use
> + * @index:	start pgoff of the range within the file
> + * @count:	length of the range, in unit of PAGE_SIZE
> + * @mf_flags:	memory failure flags
> + */
> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> +		unsigned long count, int mf_flags)
> +{
> +	LIST_HEAD(to_kill);
> +	dax_entry_t cookie;
> +	struct page *page;
> +	size_t end = index + count;
> +
> +	mf_flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +	for (; index < end; index++) {
> +		page = NULL;
> +		cookie = dax_lock_mapping_entry(mapping, index, &page);
> +		if (!cookie)
> +			return -EBUSY;
> +		if (!page)
> +			goto unlock;
> +
> +		SetPageHWPoison(page);
> +
> +		collect_procs_fsdax(page, mapping, index, &to_kill);
> +		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
> +				index, mf_flags);
> +unlock:
> +		dax_unlock_mapping_entry(mapping, index, cookie);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
> +#endif /* CONFIG_FS_DAX */
> +
>  /*
>   * Called from hugetlb code with hugetlb_lock held.
>   *
> -- 
> 2.35.1
> 
> 
> 

