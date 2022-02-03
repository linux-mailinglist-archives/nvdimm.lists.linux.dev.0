Return-Path: <nvdimm+bounces-2848-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4073C4A8229
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 11:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 59F801C0D08
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 10:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D952CA1;
	Thu,  3 Feb 2022 10:16:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DE2F26
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 10:16:47 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 2247F210F5;
	Thu,  3 Feb 2022 10:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1643883400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nMtUiTADLXvATyPy55s5v2jIbp3M1SDdfjBzYLxVQaY=;
	b=uy2A4dJPId5ZjWCWAB7xzjfv13TBL3uksbYhtD+kKBZhrAucoFYo7wWTV4GGe0bSvNLiZg
	/TASBHNd2GhHxG8IXnxdCpSOmo6tXKy/zRv5lEnzQFTGOlVqJYjcu5NXWm80JkNcmnW25s
	2wbAYsBhMPGEqliDZhIuMJnb1yi8F+o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1643883400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nMtUiTADLXvATyPy55s5v2jIbp3M1SDdfjBzYLxVQaY=;
	b=vcVcbh2mnYakFOI5KUfh516xdmKnxbolVU4Edct5Wyh+ucnXTTj5p+shSiuZgqtlRy2NAd
	0gSKvXRm2L/1iWDw==
Received: from quack3.suse.cz (unknown [10.100.200.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 7694EA3B88;
	Thu,  3 Feb 2022 10:16:39 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E2601A05B6; Thu,  3 Feb 2022 11:16:38 +0100 (CET)
Date: Thu, 3 Feb 2022 11:16:38 +0100
From: Jan Kara <jack@suse.cz>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, duanxiongchun@bytedance.com
Subject: Re: [PATCH v2 1/6] mm: rmap: fix cache flush on THP pages
Message-ID: <20220203101638.5sibdhu4owokhfex@quack3.lan>
References: <20220202143307.96282-1-songmuchun@bytedance.com>
 <20220202143307.96282-2-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202143307.96282-2-songmuchun@bytedance.com>

On Wed 02-02-22 22:33:02, Muchun Song wrote:
> The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
> However, it does not cover the full pages in a THP except a head page.
> Replace it with flush_cache_range() to fix this issue. At least, no
> problems were found due to this. Maybe because the architectures that
> have virtual indexed caches is less.
> 
> Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/rmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b0fd9dc19eba..0ba12dc9fae3 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -974,7 +974,8 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
>  			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
>  				continue;
>  
> -			flush_cache_page(vma, address, page_to_pfn(page));
> +			flush_cache_range(vma, address,
> +					  address + HPAGE_PMD_SIZE);
>  			entry = pmdp_invalidate(vma, address, pmd);
>  			entry = pmd_wrprotect(entry);
>  			entry = pmd_mkclean(entry);
> -- 
> 2.11.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

