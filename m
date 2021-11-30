Return-Path: <nvdimm+bounces-2124-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id D3CBA463E07
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Nov 2021 19:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4025E3E0E55
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Nov 2021 18:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181672CA3;
	Tue, 30 Nov 2021 18:50:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52E429CA
	for <nvdimm@lists.linux.dev>; Tue, 30 Nov 2021 18:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703C5C53FCC;
	Tue, 30 Nov 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1638298203;
	bh=fSfAUACtDSPKtDfu0Vjh52gezwGfBExaZVOYDfbrxws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kQUj0wFtmovwkcDFlqMPtxbImm0+xbpm750Q567/DBdDwBwbcg0A8XmWgO11Lz6kJ
	 W0W0uYJ1fwXOqMHrfguHzPR0i83LIzCE2ZlqVePcWDr4gOoqkWEITKAjKiTsCP2rhH
	 94zAsQk5YlvickuOkZcaDNGmjg5/LaCmn99PBX0nzwJLj10SX964qBQJKbcI8T6puf
	 dyhgEVXi8N1NRHv3+JYF9JdqYVAYNf190W3XMCfqBH0hmIppFR/FEIEO0bp/ufDdzL
	 ymm2hP/ijDWAUWt05ykWrY/+CxGwslisXunUdiQC95Tnw/XxMyYOCJeKWKAdJ3zOc4
	 8BU1N+LyqByJw==
Date: Tue, 30 Nov 2021 10:50:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/29] dax: remove the pgmap sanity checks in
 generic_fsdax_supported
Message-ID: <20211130185002.GD8467@magnolia>
References: <20211129102203.2243509-1-hch@lst.de>
 <20211129102203.2243509-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129102203.2243509-6-hch@lst.de>

On Mon, Nov 29, 2021 at 11:21:39AM +0100, Christoph Hellwig wrote:
> Drivers that register a dax_dev should make sure it works, no need
> to double check from the file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  drivers/dax/super.c | 49 +--------------------------------------------
>  1 file changed, 1 insertion(+), 48 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index bf77c3da5d56d..c8500b7e2d8a2 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -106,13 +106,9 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>  		struct block_device *bdev, int blocksize, sector_t start,
>  		sector_t sectors)
>  {
> -	bool dax_enabled = false;
>  	pgoff_t pgoff, pgoff_end;
> -	void *kaddr, *end_kaddr;
> -	pfn_t pfn, end_pfn;
>  	sector_t last_page;
> -	long len, len2;
> -	int err, id;
> +	int err;
>  
>  	if (blocksize != PAGE_SIZE) {
>  		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
> @@ -137,49 +133,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>  		return false;
>  	}
>  
> -	id = dax_read_lock();
> -	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
> -	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
> -
> -	if (len < 1 || len2 < 1) {
> -		pr_info("%pg: error: dax access failed (%ld)\n",
> -				bdev, len < 1 ? len : len2);
> -		dax_read_unlock(id);
> -		return false;
> -	}
> -
> -	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
> -		/*
> -		 * An arch that has enabled the pmem api should also
> -		 * have its drivers support pfn_t_devmap()
> -		 *
> -		 * This is a developer warning and should not trigger in
> -		 * production. dax_flush() will crash since it depends
> -		 * on being able to do (page_address(pfn_to_page())).
> -		 */
> -		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
> -		dax_enabled = true;
> -	} else if (pfn_t_devmap(pfn) && pfn_t_devmap(end_pfn)) {
> -		struct dev_pagemap *pgmap, *end_pgmap;
> -
> -		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
> -		end_pgmap = get_dev_pagemap(pfn_t_to_pfn(end_pfn), NULL);
> -		if (pgmap && pgmap == end_pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX
> -				&& pfn_t_to_page(pfn)->pgmap == pgmap
> -				&& pfn_t_to_page(end_pfn)->pgmap == pgmap
> -				&& pfn_t_to_pfn(pfn) == PHYS_PFN(__pa(kaddr))
> -				&& pfn_t_to_pfn(end_pfn) == PHYS_PFN(__pa(end_kaddr)))
> -			dax_enabled = true;
> -		put_dev_pagemap(pgmap);
> -		put_dev_pagemap(end_pgmap);
> -
> -	}
> -	dax_read_unlock(id);
> -
> -	if (!dax_enabled) {
> -		pr_info("%pg: error: dax support not enabled\n", bdev);
> -		return false;
> -	}
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> -- 
> 2.30.2
> 

