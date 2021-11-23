Return-Path: <nvdimm+bounces-2023-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 6386C45AF30
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 23:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 31E183E1020
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 22:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F092C98;
	Tue, 23 Nov 2021 22:33:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B912C81
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 22:33:52 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932C6604AC;
	Tue, 23 Nov 2021 22:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1637706832;
	bh=O27B8IODO4TbobTNVueNMnjyQmJqtFG1kQRovO4dwYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TKlKn3/vXY08+xN4qGiTEQKIBxiE8lVy5SPIYoBb1MUu8xNwKKeia6kyn4vjOSUJ3
	 AWIRnUUB4gW/uFJ7XnrO4aOxzloqhYaigdoxz+MYpx/AD13mMXbOmZq15T5nn1ftDo
	 EAKXQa/YPzAbT9WMt2oNleuktGgLYrZ5yZG94B+lPZvZSeCDHCDO0/Iwo5H3Rsjbvs
	 ZoIaXzelIDd+T3iPTp6aqRKhtMayaJQ2WoYZyNOrgSLrtenYb9ExuvtXjZ/YAEsB2/
	 0S52lNkLxZIWcdE5Z9f5Z4bLtmGUgZPbg/94nQKCrkxmxY5mPuflMzOXga7IkpT083
	 QfhmwkNuxkJ8g==
Date: Tue, 23 Nov 2021 14:33:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 13/29] fsdax: use a saner calling convention for
 copy_cow_page_dax
Message-ID: <20211123223352.GH266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
 <20211109083309.584081-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083309.584081-14-hch@lst.de>

On Tue, Nov 09, 2021 at 09:32:53AM +0100, Christoph Hellwig wrote:
> Just pass the vm_fault and iomap_iter structures, and figure out the rest
> locally.  Note that this requires moving dax_iomap_sector up in the file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes, nice cleanup!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 73bd1439d8089..e51b4129d1b65 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -709,26 +709,31 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  	return __dax_invalidate_entry(mapping, index, false);
>  }
>  
> -static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_dev,
> -			     sector_t sector, struct page *to, unsigned long vaddr)
> +static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
>  {
> +	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> +}
> +
> +static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> +{
> +	sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
>  	void *vto, *kaddr;
>  	pgoff_t pgoff;
>  	long rc;
>  	int id;
>  
> -	rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
> +	rc = bdev_dax_pgoff(iter->iomap.bdev, sector, PAGE_SIZE, &pgoff);
>  	if (rc)
>  		return rc;
>  
>  	id = dax_read_lock();
> -	rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
> +	rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>  	if (rc < 0) {
>  		dax_read_unlock(id);
>  		return rc;
>  	}
> -	vto = kmap_atomic(to);
> -	copy_user_page(vto, kaddr, vaddr, to);
> +	vto = kmap_atomic(vmf->cow_page);
> +	copy_user_page(vto, kaddr, vmf->address, vmf->cow_page);
>  	kunmap_atomic(vto);
>  	dax_read_unlock(id);
>  	return 0;
> @@ -1005,11 +1010,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>  
> -static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
> -{
> -	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> -}
> -
>  static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
>  			 pfn_t *pfnp)
>  {
> @@ -1332,19 +1332,16 @@ static vm_fault_t dax_fault_synchronous_pfnp(pfn_t *pfnp, pfn_t pfn)
>  static vm_fault_t dax_fault_cow_page(struct vm_fault *vmf,
>  		const struct iomap_iter *iter)
>  {
> -	sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
> -	unsigned long vaddr = vmf->address;
>  	vm_fault_t ret;
>  	int error = 0;
>  
>  	switch (iter->iomap.type) {
>  	case IOMAP_HOLE:
>  	case IOMAP_UNWRITTEN:
> -		clear_user_highpage(vmf->cow_page, vaddr);
> +		clear_user_highpage(vmf->cow_page, vmf->address);
>  		break;
>  	case IOMAP_MAPPED:
> -		error = copy_cow_page_dax(iter->iomap.bdev, iter->iomap.dax_dev,
> -					  sector, vmf->cow_page, vaddr);
> +		error = copy_cow_page_dax(vmf, iter);
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);
> -- 
> 2.30.2
> 

