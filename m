Return-Path: <nvdimm+bounces-2032-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E4B45AFA3
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Nov 2021 00:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id B55901C0A97
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 23:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809302C96;
	Tue, 23 Nov 2021 23:00:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8B2C81
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 23:00:24 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5E660FBF;
	Tue, 23 Nov 2021 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1637708424;
	bh=sKHHXnnbT3vnShXHfDI+XrnWEu6cyJlqv49857pCV5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SNfotjJ8X++j3i9C0PzbRugHo7+tyQ3T4m1T2Z0oDe2BL+CvmLKMHbJ9Aof3VKeNY
	 sDwLljj8mRvyOvc3cyUTZKzacZFGEg4uSutp+x+tnV8kkKHJifjLRY9EmRsdBMiUqe
	 GxVn3bDkDVq06L3e6PgT9bShcPjCNafhZ8ZNi7Z1YJ5EtI6C7aXLzg2e0EWUycTBUP
	 DPwpUyMgB1OAcoCUFI/b0zq3XhAyO+uD+jcL/j4IJjCewi4CbvT963KCjlHIf4yWwc
	 jGAJ7NKjJpMVS8SUmH8wZarK5OakxSU7WDkhY0Kuv/p08iQVwJqBPPCGcgLRCX5dpb
	 goCWZSExVEQpw==
Date: Tue, 23 Nov 2021 15:00:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 22/29] iomap: add a IOMAP_DAX flag
Message-ID: <20211123230023.GQ266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
 <20211109083309.584081-23-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083309.584081-23-hch@lst.de>

On Tue, Nov 09, 2021 at 09:33:02AM +0100, Christoph Hellwig wrote:
> Add a flag so that the file system can easily detect DAX operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c              | 7 ++++---
>  include/linux/iomap.h | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5b52b878124ac..0bd6cdcbacfc4 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1180,7 +1180,7 @@ int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
>  		.inode		= inode,
>  		.pos		= pos,
>  		.len		= len,
> -		.flags		= IOMAP_ZERO,
> +		.flags		= IOMAP_DAX | IOMAP_ZERO,
>  	};
>  	int ret;
>  
> @@ -1308,6 +1308,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		.inode		= iocb->ki_filp->f_mapping->host,
>  		.pos		= iocb->ki_pos,
>  		.len		= iov_iter_count(iter),
> +		.flags		= IOMAP_DAX,
>  	};
>  	loff_t done = 0;
>  	int ret;
> @@ -1461,7 +1462,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		.inode		= mapping->host,
>  		.pos		= (loff_t)vmf->pgoff << PAGE_SHIFT,
>  		.len		= PAGE_SIZE,
> -		.flags		= IOMAP_FAULT,
> +		.flags		= IOMAP_DAX | IOMAP_FAULT,
>  	};
>  	vm_fault_t ret = 0;
>  	void *entry;
> @@ -1570,7 +1571,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	struct iomap_iter iter = {
>  		.inode		= mapping->host,
>  		.len		= PMD_SIZE,
> -		.flags		= IOMAP_FAULT,
> +		.flags		= IOMAP_DAX | IOMAP_FAULT,
>  	};
>  	vm_fault_t ret = VM_FAULT_FALLBACK;
>  	pgoff_t max_pgoff;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 6d1b08d0ae930..146a7e3e3ea11 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -141,6 +141,7 @@ struct iomap_page_ops {
>  #define IOMAP_NOWAIT		(1 << 5) /* do not block */
>  #define IOMAP_OVERWRITE_ONLY	(1 << 6) /* only pure overwrites allowed */
>  #define IOMAP_UNSHARE		(1 << 7) /* unshare_file_range */
> +#define IOMAP_DAX		(1 << 8) /* DAX mapping */

Should this be #define'd to 0 ifndef CONFIG_FS_DAX so that the compiler
will optimize out all the IOMAP_DAX bits if dax isn't enabled in
Kconfig?  Kind of like what we do for S_DAX?

--D

>  
>  struct iomap_ops {
>  	/*
> -- 
> 2.30.2
> 

