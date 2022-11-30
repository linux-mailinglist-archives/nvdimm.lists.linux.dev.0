Return-Path: <nvdimm+bounces-5293-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A4063CDCB
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Nov 2022 04:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1808B280C19
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Nov 2022 03:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95427FC;
	Wed, 30 Nov 2022 03:28:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453437C
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 03:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BBFC433C1;
	Wed, 30 Nov 2022 03:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669778925;
	bh=pd1oR2EJlnnq8COYozIsiG3lk5t8ltaeT/tSLA1dWsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XzBrmobqhSoN37uonzAHO6DCbFjNYn7l5Yk4IWfrPbdDRoPUCFFyZReRoj7wxYmp2
	 89ckmgTmDUU0haAQDqe0Go7u+WH6uCklvZ3KPSKhdk7s21Dp8v+7hmbKgdiHA7w/dh
	 lbCyjTsZBhtD64OyoTeXX0ah2+XuD17FlOUQzczLoDDyqypF7R10VBjMKa+H4zxwAn
	 2CDJiWQpMOa5jJ7DCWzLmTyO6urxS46sWxoG2+gB5RLnPMHMyR79y0e1j6ihmxq72b
	 jLPCwy/fiEM4F68sGenvJ9VALdRUGX9fyptubNJh9Tn1xQe7YJ6uk2P9PB2ZsgRJ4Y
	 ZHCi5OPSfpCng==
Date: Tue, 29 Nov 2022 19:28:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com
Subject: Re: [PATCH 2/2] fsdax,xfs: port unshare to fsdax
Message-ID: <Y4bN7f8XXviJ6zRz@magnolia>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1669301694-16-3-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669301694-16-3-git-send-email-ruansy.fnst@fujitsu.com>

On Thu, Nov 24, 2022 at 02:54:54PM +0000, Shiyang Ruan wrote:
> Implement unshare in fsdax mode: copy data from srcmap to iomap.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Heh, I had a version nearly like this in my tree.  Makes reviewing
easier:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c             | 52 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_reflink.c |  8 +++++--
>  include/linux/dax.h  |  2 ++
>  3 files changed, 60 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5ea7c0926b7f..3d0bf68ab6b0 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1235,6 +1235,58 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  }
>  #endif /* CONFIG_FS_DAX_PMD */
>  
> +static s64 dax_unshare_iter(struct iomap_iter *iter)
> +{
> +	struct iomap *iomap = &iter->iomap;
> +	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> +	loff_t pos = iter->pos;
> +	loff_t length = iomap_length(iter);
> +	int id = 0;
> +	s64 ret = 0;
> +	void *daddr = NULL, *saddr = NULL;
> +
> +	/* don't bother with blocks that are not shared to start with */
> +	if (!(iomap->flags & IOMAP_F_SHARED))
> +		return length;
> +	/* don't bother with holes or unwritten extents */
> +	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> +		return length;
> +
> +	id = dax_read_lock();
> +	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	ret = copy_mc_to_kernel(daddr, saddr, length);
> +	if (ret)
> +		ret = -EIO;
> +
> +out_unlock:
> +	dax_read_unlock(id);
> +	return ret;
> +}
> +
> +int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
> +		const struct iomap_ops *ops)
> +{
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= pos,
> +		.len		= len,
> +		.flags		= IOMAP_WRITE | IOMAP_UNSHARE | IOMAP_DAX,
> +	};
> +	int ret;
> +
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = dax_unshare_iter(&iter);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dax_file_unshare);
> +
>  static int dax_memzero(struct iomap_iter *iter, loff_t pos, size_t size)
>  {
>  	const struct iomap *iomap = &iter->iomap;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 93bdd25680bc..fe46bce8cae6 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1693,8 +1693,12 @@ xfs_reflink_unshare(
>  
>  	inode_dio_wait(inode);
>  
> -	error = iomap_file_unshare(inode, offset, len,
> -			&xfs_buffered_write_iomap_ops);
> +	if (IS_DAX(inode))
> +		error = dax_file_unshare(inode, offset, len,
> +				&xfs_dax_write_iomap_ops);
> +	else
> +		error = iomap_file_unshare(inode, offset, len,
> +				&xfs_buffered_write_iomap_ops);
>  	if (error)
>  		goto out;
>  
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index ba985333e26b..2b5ecb591059 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -205,6 +205,8 @@ static inline void dax_unlock_mapping_entry(struct address_space *mapping,
>  }
>  #endif
>  
> +int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
> +		const struct iomap_ops *ops);
>  int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
>  		const struct iomap_ops *ops);
>  int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> -- 
> 2.38.1
> 

