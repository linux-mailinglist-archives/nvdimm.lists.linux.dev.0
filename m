Return-Path: <nvdimm+bounces-2849-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7794A822C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 11:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1D1863E103B
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 10:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73042C80;
	Thu,  3 Feb 2022 10:17:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30E2CA1
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 10:17:05 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 2DA36210F5;
	Thu,  3 Feb 2022 10:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1643883424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuei1RsrZ1XayODHiwABNR6bsWtBgImk04EOWC1VWlw=;
	b=cn0dkVNM6a8g6Q5J0snibEzl61eXoeHCLqGgnEDSLadhko8wMC5ZdfG9sqC5Qx59j09VjU
	vzmmLMmpf1iH834oQmWBLtJiO13ekk281MzWcZcWLrgNGWIJ6F24AQwbdC3bC0o2v3ZpIe
	KNKr4s2a3KK+AGsxswUdZzLFa17FqyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1643883424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuei1RsrZ1XayODHiwABNR6bsWtBgImk04EOWC1VWlw=;
	b=ZMfqE1Cx+GaUDCKmrFbxZ4gEbxAzrQ4RwUrkbNizGFVSQBh0KEBOj6liQLr5mwDS0cloIY
	FzOCiBf/grZyuEAA==
Received: from quack3.suse.cz (unknown [10.100.200.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 1B315A3B8F;
	Thu,  3 Feb 2022 10:17:04 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D489AA05B6; Thu,  3 Feb 2022 11:17:03 +0100 (CET)
Date: Thu, 3 Feb 2022 11:17:03 +0100
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
Subject: Re: [PATCH v2 2/6] dax: fix cache flush on PMD-mapped pages
Message-ID: <20220203101703.a7ixac6h7kit4wng@quack3.lan>
References: <20220202143307.96282-1-songmuchun@bytedance.com>
 <20220202143307.96282-3-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202143307.96282-3-songmuchun@bytedance.com>

On Wed 02-02-22 22:33:03, Muchun Song wrote:
> The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
> However, it does not cover the full pages in a THP except a head page.
> Replace it with flush_cache_range() to fix this issue.
> 
> Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 88be1c02a151..e031e4b6c13c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -857,7 +857,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
>  			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
>  				goto unlock_pmd;
>  
> -			flush_cache_page(vma, address, pfn);
> +			flush_cache_range(vma, address,
> +					  address + HPAGE_PMD_SIZE);
>  			pmd = pmdp_invalidate(vma, address, pmdp);
>  			pmd = pmd_wrprotect(pmd);
>  			pmd = pmd_mkclean(pmd);
> -- 
> 2.11.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

