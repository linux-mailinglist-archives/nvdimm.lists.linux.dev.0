Return-Path: <nvdimm+bounces-1115-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB9E3FEA22
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Sep 2021 09:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E8CA63E0F28
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Sep 2021 07:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1F42FB2;
	Thu,  2 Sep 2021 07:43:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859093FC1
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 07:43:11 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 51A986736F; Thu,  2 Sep 2021 09:43:08 +0200 (CEST)
Date: Thu, 2 Sep 2021 09:43:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v8 6/7] xfs: support CoW in fsdax mode
Message-ID: <20210902074308.GE13867@lst.de>
References: <20210829122517.1648171-1-ruansy.fnst@fujitsu.com> <20210829122517.1648171-7-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829122517.1648171-7-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Aug 29, 2021 at 08:25:16PM +0800, Shiyang Ruan wrote:
> In fsdax mode, WRITE and ZERO on a shared extent need CoW performed.
> After that, new allocated extents needs to be remapped to the file.  Add
> an implementation of ->iomap_end() for dax write ops to do the remapping
> work.

Please split the new dax infrastructure from the XFS changes.

>  static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
> -			       int *iomap_errp, const struct iomap_ops *ops)
> +		int *iomap_errp, const struct iomap_ops *ops)
>  {
>  	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>  	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
> @@ -1631,7 +1664,7 @@ static bool dax_fault_check_fallback(struct vm_fault *vmf, struct xa_state *xas,
>  }
>  
>  static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
> -			       const struct iomap_ops *ops)
> +		const struct iomap_ops *ops)

These looks like unrelated whitespace changes.

> -static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> +loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
>  {
>  	const struct iomap *iomap = &iter->iomap;
>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> @@ -918,6 +918,7 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
>  
>  	return written;
>  }
> +EXPORT_SYMBOL_GPL(iomap_zero_iter);

I don't see why this would have to be exported.

> +	unsigned 		flags,
> +	struct iomap 		*iomap)
> +{
> +	int			error = 0;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	bool			cow = xfs_is_cow_inode(ip);

The cow variable is only used once, so I think we can drop it.

> +	const struct iomap_iter *iter =
> +				container_of(iomap, typeof(*iter), iomap);

Please comment this as it is a little unusual.

> +
> +	if (cow) {
> +		if (iter->processed <= 0)
> +			xfs_reflink_cancel_cow_range(ip, pos, length, true);
> +		else
> +			error = xfs_reflink_end_cow(ip, pos, iter->processed);
> +	}
> +	return error ?: iter->processed;

The ->iomap_end convention is to return 0 or a negative error code.
Also i'd much prefer to just spell this out in a normal sequential way:

	if (!xfs_is_cow_inode(ip))
		return 0;

	if (iter->processed <= 0) {
		xfs_reflink_cancel_cow_range(ip, pos, length, true);
		return 0;
	}

	return xfs_reflink_end_cow(ip, pos, iter->processed);

> +static inline int
> +xfs_iomap_zero_range(
> +	struct xfs_inode	*ip,
> +	loff_t			pos,
> +	loff_t			len,
> +	bool			*did_zero)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	return IS_DAX(inode)
> +			? dax_iomap_zero_range(inode, pos, len, did_zero,
> +					       &xfs_dax_write_iomap_ops)
> +			: iomap_zero_range(inode, pos, len, did_zero,
> +					       &xfs_buffered_write_iomap_ops);
> +}

	if (IS_DAX(inode))
		return dax_iomap_zero_range(inode, pos, len, did_zero,
					    &xfs_dax_write_iomap_ops);
	return iomap_zero_range(inode, pos, len, did_zero,
				&xfs_buffered_write_iomap_ops);

> +static inline int
> +xfs_iomap_truncate_page(
> +	struct xfs_inode	*ip,
> +	loff_t			pos,
> +	bool			*did_zero)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	return IS_DAX(inode)
> +			? dax_iomap_truncate_page(inode, pos, did_zero,
> +					       &xfs_dax_write_iomap_ops)
> +			: iomap_truncate_page(inode, pos, did_zero,
> +					       &xfs_buffered_write_iomap_ops);
> +}

Same here.

