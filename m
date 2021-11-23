Return-Path: <nvdimm+bounces-2020-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 377E145AF06
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 23:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 67D813E1023
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 22:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED272C96;
	Tue, 23 Nov 2021 22:25:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6B62C83
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 22:25:57 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63B2260F5B;
	Tue, 23 Nov 2021 22:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1637706356;
	bh=QAV7Co9x+kq7cw9CnYx72vJEWiPcLd0IRsChlJ7iD78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qw8qbxKV0Ln59bnZ2iYvOCv17wc7NmZh2MVxAZoTUcjsGNcBZmG3/y8Q/y5EgIU5z
	 /Ud6BAVnfCGhCYrp8HEHI2+/oPKUxgQfi7IwyDfXcYG8HqhS9fH0BBdDHARe1h/v2R
	 7TUyTl1cxhl1w+Cm157k5ff4tt95TM11J5zZXaFkyV2QIcdSubiuEdFX8woRCQsoJi
	 ye9Pa33GtkO04j+eaol/2zzbKQr0Ulfns+oBJwkqlGf2W9emGi7Irt2r6IIEzkds8z
	 JuJGU8+xc+QmNI7kLV/+mvxjz4Ku5J0WJTELrf3/2LsR9G90q2v/zZ2lDrTO802RUz
	 NlSo0Mf2Bi+iQ==
Date: Tue, 23 Nov 2021 14:25:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/29] dax: move the partition alignment check into
 fs_dax_get_by_bdev
Message-ID: <20211123222555.GE266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
 <20211109083309.584081-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083309.584081-7-hch@lst.de>

On Tue, Nov 09, 2021 at 09:32:46AM +0100, Christoph Hellwig wrote:
> fs_dax_get_by_bdev is the primary interface to find a dax device for a
> block device, so move the partition alignment check there instead of
> wiring it up through ->dax_supported.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 04fc680542e8d..482fe775324a4 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -93,6 +93,12 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  	if (!blk_queue_dax(bdev->bd_disk->queue))
>  		return NULL;
>  
> +	if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
> +	    (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {

Do we have to be careful about 64-bit division here, or do we not
support DAX on 32-bit?

> +		pr_info("%pg: error: unaligned partition for dax\n", bdev);

I also wonder if this should be ratelimited...?

--D

> +		return NULL;
> +	}
> +
>  	id = dax_read_lock();
>  	dax_dev = xa_load(&dax_hosts, (unsigned long)bdev->bd_disk);
>  	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
> @@ -107,10 +113,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>  		struct block_device *bdev, int blocksize, sector_t start,
>  		sector_t sectors)
>  {
> -	pgoff_t pgoff, pgoff_end;
> -	sector_t last_page;
> -	int err;
> -
>  	if (blocksize != PAGE_SIZE) {
>  		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
>  		return false;
> @@ -121,19 +123,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>  		return false;
>  	}
>  
> -	err = bdev_dax_pgoff(bdev, start, PAGE_SIZE, &pgoff);
> -	if (err) {
> -		pr_info("%pg: error: unaligned partition for dax\n", bdev);
> -		return false;
> -	}
> -
> -	last_page = PFN_DOWN((start + sectors - 1) * 512) * PAGE_SIZE / 512;
> -	err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
> -	if (err) {
> -		pr_info("%pg: error: unaligned partition for dax\n", bdev);
> -		return false;
> -	}
> -
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> -- 
> 2.30.2
> 

