Return-Path: <nvdimm+bounces-1321-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3327E40D0DB
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Sep 2021 02:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 15B951C0F5E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Sep 2021 00:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F632FB2;
	Thu, 16 Sep 2021 00:30:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDAE3FC5
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 00:30:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 491556108F;
	Thu, 16 Sep 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1631752209;
	bh=RTxTQggqSxSYdn2y3gMxq6FoxSHAqy63/h21L2l9IRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+iusVMvz3jRSfTsKEk2750zrmp+bxGU83YcFVS3zgJJY5KNuTGrUus6hqAv7NRus
	 xZfemHe3GZfd+wXGEqUFpr93ea9KMDDhMKnxH9pTnv0pFol/ghTqhYfDzKPcFsSf45
	 3IOB1ZGILT3odwkmYwsPu3Krw8H9nLaz7iWSQ/Vw/dgyK260mVocdG1x0f9b+YYbNB
	 k5qPED0BYUc+bh98JIkb9OUgZUpJzqi01zisxEbENjTEaPzz/LrDz0rgteAzBNlVLX
	 HtAAk57VS16JzM2BI/vl7SSWEaaH6y1EPxPP2KqqEzfOif1kxTsbWo2AyHcAPEwR9s
	 otHt644RlBSDQ==
Date: Wed, 15 Sep 2021 17:30:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	rgoldwyn@suse.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH v9 8/8] xfs: Add dax dedupe support
Message-ID: <20210916003008.GE34830@magnolia>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com>
 <20210915104501.4146910-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915104501.4146910-9-ruansy.fnst@fujitsu.com>

On Wed, Sep 15, 2021 at 06:45:01PM +0800, Shiyang Ruan wrote:
> Introduce xfs_mmaplock_two_inodes_and_break_dax_layout() for dax files
> who are going to be deduped.  After that, call compare range function
> only when files are both DAX or not.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c    |  2 +-
>  fs/xfs/xfs_inode.c   | 80 +++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_inode.h   |  1 +
>  fs/xfs/xfs_reflink.c |  4 +--
>  4 files changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 2ef1930374d2..c3061723613c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -846,7 +846,7 @@ xfs_wait_dax_page(
>  	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>  }
>  
> -static int
> +int
>  xfs_break_dax_layouts(
>  	struct inode		*inode,
>  	bool			*retry)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a4f6f034fb81..bdc084cdbf46 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3790,6 +3790,61 @@ xfs_iolock_two_inodes_and_break_layout(
>  	return 0;
>  }
>  
> +static int
> +xfs_mmaplock_two_inodes_and_break_dax_layout(
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*ip2)
> +{
> +	int			error, attempts = 0;
> +	bool			retry;
> +	struct page		*page;
> +	struct xfs_log_item	*lp;
> +
> +	if (ip1->i_ino > ip2->i_ino)
> +		swap(ip1, ip2);
> +
> +again:
> +	retry = false;
> +	/* Lock the first inode */
> +	xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
> +	error = xfs_break_dax_layouts(VFS_I(ip1), &retry);
> +	if (error || retry) {
> +		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
> +		if (error == 0 && retry)
> +			goto again;
> +		return error;
> +	}
> +
> +	if (ip1 == ip2)
> +		return 0;
> +
> +	/* Nested lock the second inode */
> +	lp = &ip1->i_itemp->ili_item;
> +	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
> +		if (!xfs_ilock_nowait(ip2,
> +		    xfs_lock_inumorder(XFS_MMAPLOCK_EXCL, 1))) {
> +			xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
> +			if ((++attempts % 5) == 0)
> +				delay(1); /* Don't just spin the CPU */
> +			goto again;
> +		}

I suspect we don't need this part for grabbing the MMAPLOCK^W pagecache
invalidatelock.  The AIL only grabs the ILOCK, never the IOLOCK or the
MMAPLOCK.

> +	} else
> +		xfs_ilock(ip2, xfs_lock_inumorder(XFS_MMAPLOCK_EXCL, 1));
> +	/*
> +	 * We cannot use xfs_break_dax_layouts() directly here because it may
> +	 * need to unlock & lock the XFS_MMAPLOCK_EXCL which is not suitable
> +	 * for this nested lock case.
> +	 */
> +	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
> +	if (page && page_ref_count(page) != 1) {

Do you think the patch "ext4/xfs: add page refcount helper" would be a
good cleanup to head this series?

https://lore.kernel.org/linux-xfs/20210913161604.31981-1-alex.sierra@amd.com/T/#m59cf7cd5c0d521ad487fa3a15d31c3865db88bdf

The rest of the logic looks ok.

--D

> +		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
> +		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
> +		goto again;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Lock two inodes so that userspace cannot initiate I/O via file syscalls or
>   * mmap activity.
> @@ -3804,8 +3859,19 @@ xfs_ilock2_io_mmap(
>  	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
>  	if (ret)
>  		return ret;
> -	filemap_invalidate_lock_two(VFS_I(ip1)->i_mapping,
> -				    VFS_I(ip2)->i_mapping);
> +
> +	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
> +		ret = xfs_mmaplock_two_inodes_and_break_dax_layout(ip1, ip2);
> +		if (ret) {
> +			inode_unlock(VFS_I(ip2));
> +			if (ip1 != ip2)
> +				inode_unlock(VFS_I(ip1));
> +			return ret;
> +		}
> +	} else
> +		filemap_invalidate_lock_two(VFS_I(ip1)->i_mapping,
> +					    VFS_I(ip2)->i_mapping);
> +
>  	return 0;
>  }
>  
> @@ -3815,8 +3881,14 @@ xfs_iunlock2_io_mmap(
>  	struct xfs_inode	*ip1,
>  	struct xfs_inode	*ip2)
>  {
> -	filemap_invalidate_unlock_two(VFS_I(ip1)->i_mapping,
> -				      VFS_I(ip2)->i_mapping);
> +	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
> +		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
> +		if (ip1 != ip2)
> +			xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
> +	} else
> +		filemap_invalidate_unlock_two(VFS_I(ip1)->i_mapping,
> +					      VFS_I(ip2)->i_mapping);
> +
>  	inode_unlock(VFS_I(ip2));
>  	if (ip1 != ip2)
>  		inode_unlock(VFS_I(ip1));
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index b21b177832d1..f7e26fe31a26 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -472,6 +472,7 @@ enum xfs_prealloc_flags {
>  
>  int	xfs_update_prealloc_flags(struct xfs_inode *ip,
>  				  enum xfs_prealloc_flags flags);
> +int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
>  int	xfs_break_layouts(struct inode *inode, uint *iolock,
>  		enum layout_break_reason reason);
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 9d876e268734..3b99c9dfcf0d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1327,8 +1327,8 @@ xfs_reflink_remap_prep(
>  	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
>  		goto out_unlock;
>  
> -	/* Don't share DAX file data for now. */
> -	if (IS_DAX(inode_in) || IS_DAX(inode_out))
> +	/* Don't share DAX file data with non-DAX file. */
> +	if (IS_DAX(inode_in) != IS_DAX(inode_out))
>  		goto out_unlock;
>  
>  	if (!IS_DAX(inode_in))
> -- 
> 2.33.0
> 
> 
> 

