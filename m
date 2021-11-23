Return-Path: <nvdimm+bounces-2033-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3EF45AFAE
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Nov 2021 00:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 2B7933E101E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 23:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5F22C96;
	Tue, 23 Nov 2021 23:01:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2835629CA
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 23:01:26 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA89560F9F;
	Tue, 23 Nov 2021 23:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1637708484;
	bh=pls+4Tj3c/ICn7BC7DHJJDR6vWjRVS5kwuRh25nYZn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A31w9TfD/GCAkyoiaYjxWJv4kgIOAGlqBICm5gISvgj3+KslhgzzB7I5OwYUHnVzx
	 dyn3LR9gbZ/HrBotRMs7StpVlmchU0eDlpDGaRljnPx+bGNA/0cB5p5JRZb3o2sUBO
	 hF6Qo92PpE8A4hy2yy+H981S+0vY3HJC8kSrpbwHYqsct3hucsEplv50J3rukwffoH
	 O3A+kDqAlaMRFz6/lbIJT0/0+NwD2s/AZk41Jl9mly99UZ4DjCWLKmF52rWb48gQaJ
	 dkdvRvzUFHE+skCxChOUx8qzZKJS5mcUPkYSMjj/92SjB0kosyKkdroePujhUJ3u4c
	 FCbkMajyHEzFQ==
Date: Tue, 23 Nov 2021 15:01:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 23/29] xfs: use IOMAP_DAX to check for DAX mappings
Message-ID: <20211123230124.GR266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
 <20211109083309.584081-24-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083309.584081-24-hch@lst.de>

On Tue, Nov 09, 2021 at 09:33:03AM +0100, Christoph Hellwig wrote:
> Use the explicit DAX flag instead of checking the inode flag in the
> iomap code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Any particular reason to pass this in as a flag vs. querying the inode?

Doesn't really bother me either way, was just curious.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 7 ++++---
>  fs/xfs/xfs_iomap.h | 3 ++-
>  fs/xfs/xfs_pnfs.c  | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 604000b6243ec..8cef3b68cba78 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -188,6 +188,7 @@ xfs_iomap_write_direct(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		offset_fsb,
>  	xfs_fileoff_t		count_fsb,
> +	unsigned int		flags,
>  	struct xfs_bmbt_irec	*imap)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -229,7 +230,7 @@ xfs_iomap_write_direct(
>  	 * the reserve block pool for bmbt block allocation if there is no space
>  	 * left but we need to do unwritten extent conversion.
>  	 */
> -	if (IS_DAX(VFS_I(ip))) {
> +	if (flags & IOMAP_DAX) {
>  		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
>  		if (imap->br_state == XFS_EXT_UNWRITTEN) {
>  			force = true;
> @@ -620,7 +621,7 @@ imap_needs_alloc(
>  	    imap->br_startblock == DELAYSTARTBLOCK)
>  		return true;
>  	/* we convert unwritten extents before copying the data for DAX */
> -	if (IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN)
> +	if ((flags & IOMAP_DAX) && imap->br_state == XFS_EXT_UNWRITTEN)
>  		return true;
>  	return false;
>  }
> @@ -826,7 +827,7 @@ xfs_direct_write_iomap_begin(
>  	xfs_iunlock(ip, lockmode);
>  
>  	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
> -			&imap);
> +			flags, &imap);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index f1a281ab9328c..5648262a71736 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -12,7 +12,8 @@ struct xfs_inode;
>  struct xfs_bmbt_irec;
>  
>  int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
> -		xfs_fileoff_t count_fsb, struct xfs_bmbt_irec *imap);
> +		xfs_fileoff_t count_fsb, unsigned int flags,
> +		struct xfs_bmbt_irec *imap);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
>  xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
>  		xfs_fileoff_t end_fsb);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 5e1d29d8b2e73..e188e1cf97cc5 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -155,7 +155,7 @@ xfs_fs_map_blocks(
>  		xfs_iunlock(ip, lock_flags);
>  
>  		error = xfs_iomap_write_direct(ip, offset_fsb,
> -				end_fsb - offset_fsb, &imap);
> +				end_fsb - offset_fsb, 0, &imap);
>  		if (error)
>  			goto out_unlock;
>  
> -- 
> 2.30.2
> 

