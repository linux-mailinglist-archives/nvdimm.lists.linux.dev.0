Return-Path: <nvdimm+bounces-826-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4FFC3E8703
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 02:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E46623E147D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 00:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4C92FB9;
	Wed, 11 Aug 2021 00:08:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A2C177
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 00:07:59 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3F9D600CD;
	Wed, 11 Aug 2021 00:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628640478;
	bh=fbMv564d/h7xq+40JXS/+17OpmGr84wJa0rzOUfg/Bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U3yIRj8YznQ1y/FyYLGexH6gy6OVI3HrDl4Ua2tjhfi/dfvGh+MjNICJaBb7QEzHX
	 CBDQD9GHoDOOTzdfCXFyAjfFh/JRKDPyQ5Zi0BMufHS76eYPjASPdTw3AW5NLaCsw/
	 0hcNVG8A8rfjyQilBZCxsFOLpXhFuF/7JXmA7OhwExMxB1pdZnEjIVktXuWw7EJz5Y
	 YpP297ASOHUSvjVHaE1KxOisElNjtQW0+KQoDk/1Gb9RDWEIieoOrKAmWnFP7dO5HB
	 duH6VvbFQLqTpB0xCHiLp5VnWLCtIUYVTNjsOf9ZywFqGTcXDXHf7YrdBUuIKZgvI9
	 +sAtLdSSXL8rw==
Date: Tue, 10 Aug 2021 17:07:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 23/30] fsdax: switch dax_iomap_rw to use iomap_iter
Message-ID: <20210811000758.GQ3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-24-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-24-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:37AM +0200, Christoph Hellwig wrote:
> Switch the dax_iomap_rw implementation to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me gets excited about this file getting cleaned up
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 49 ++++++++++++++++++++++++-------------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4d63040fd71f56..51da45301350a6 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1103,20 +1103,21 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  	return size;
>  }
>  
> -static loff_t
> -dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> -		struct iomap *iomap, struct iomap *srcmap)
> +static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
> +		struct iov_iter *iter)
>  {
> +	const struct iomap *iomap = &iomi->iomap;
> +	loff_t length = iomap_length(iomi);
> +	loff_t pos = iomi->pos;
>  	struct block_device *bdev = iomap->bdev;
>  	struct dax_device *dax_dev = iomap->dax_dev;
> -	struct iov_iter *iter = data;
>  	loff_t end = pos + length, done = 0;
>  	ssize_t ret = 0;
>  	size_t xfer;
>  	int id;
>  
>  	if (iov_iter_rw(iter) == READ) {
> -		end = min(end, i_size_read(inode));
> +		end = min(end, i_size_read(iomi->inode));
>  		if (pos >= end)
>  			return 0;
>  
> @@ -1133,7 +1134,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	 * written by write(2) is visible in mmap.
>  	 */
>  	if (iomap->flags & IOMAP_F_NEW) {
> -		invalidate_inode_pages2_range(inode->i_mapping,
> +		invalidate_inode_pages2_range(iomi->inode->i_mapping,
>  					      pos >> PAGE_SHIFT,
>  					      (end - 1) >> PAGE_SHIFT);
>  	}
> @@ -1209,31 +1210,29 @@ ssize_t
>  dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops)
>  {
> -	struct address_space *mapping = iocb->ki_filp->f_mapping;
> -	struct inode *inode = mapping->host;
> -	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
> -	unsigned flags = 0;
> +	struct iomap_iter iomi = {
> +		.inode		= iocb->ki_filp->f_mapping->host,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(iter),
> +	};
> +	loff_t done = 0;
> +	int ret;
>  
>  	if (iov_iter_rw(iter) == WRITE) {
> -		lockdep_assert_held_write(&inode->i_rwsem);
> -		flags |= IOMAP_WRITE;
> +		lockdep_assert_held_write(&iomi.inode->i_rwsem);
> +		iomi.flags |= IOMAP_WRITE;
>  	} else {
> -		lockdep_assert_held(&inode->i_rwsem);
> +		lockdep_assert_held(&iomi.inode->i_rwsem);
>  	}
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
> -		flags |= IOMAP_NOWAIT;
> +		iomi.flags |= IOMAP_NOWAIT;
>  
> -	while (iov_iter_count(iter)) {
> -		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
> -				iter, dax_iomap_actor);
> -		if (ret <= 0)
> -			break;
> -		pos += ret;
> -		done += ret;
> -	}
> +	while ((ret = iomap_iter(&iomi, ops)) > 0)
> +		iomi.processed = dax_iomap_iter(&iomi, iter);
>  
> -	iocb->ki_pos += done;
> +	done = iomi.pos - iocb->ki_pos;
> +	iocb->ki_pos = iomi.pos;
>  	return done ? done : ret;
>  }
>  EXPORT_SYMBOL_GPL(dax_iomap_rw);
> @@ -1307,7 +1306,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	}
>  
>  	/*
> -	 * Note that we don't bother to use iomap_apply here: DAX required
> +	 * Note that we don't bother to use iomap_iter here: DAX required
>  	 * the file system block size to be equal the page size, which means
>  	 * that we never have to deal with more than a single extent here.
>  	 */
> @@ -1561,7 +1560,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	}
>  
>  	/*
> -	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
> +	 * Note that we don't use iomap_iter here.  We aren't doing I/O, only
>  	 * setting up a mapping, so really we're using iomap_begin() as a way
>  	 * to look up our filesystem block.
>  	 */
> -- 
> 2.30.2
> 

