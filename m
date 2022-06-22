Return-Path: <nvdimm+bounces-3947-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAABF55519F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 22 Jun 2022 18:49:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36212280AB4
	for <lists+linux-nvdimm@lfdr.de>; Wed, 22 Jun 2022 16:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85ECD1869;
	Wed, 22 Jun 2022 16:49:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647FF1860
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 16:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0240EC34114;
	Wed, 22 Jun 2022 16:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655916569;
	bh=mI4MDyHEMxaSG34Hj/fZrqohmQwQNM49s78s/LON24U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M3J1USxUtGI/7fujk6bsFc6vvzcgJ4Z9zigigTXeZZnMKi4mFcVXFlczuWFcF88M0
	 O2ypyx3yfoPAPxXHFvJg+LXU9muZXYtkkCwfmNhvpvEmaRW2WbdYlUjhVRj9IPSNqu
	 iBnNRmI7IHcWWR5L3kYzyJ8sQ2efKPTVIX8uN8aBIoOhuBZJnao0kMZ52Gx5FeEfkQ
	 0QXmkk0vdQ7Yms9QT22CFikwHd6AYYdwfMqrcWqiBEGeMwkOz8mKTfZoVbxOG8vMNA
	 T5cgKGab/XisfZBcfQKT9tGlZ3LrspUMcDUZfGnI/X4UcTSPl1IeAeGKX4DTPBLf3e
	 cyRwFss2D8ecQ==
Date: Wed, 22 Jun 2022 09:49:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [RFC PATCH v3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <YrNIGGBK7/cztV8c@magnolia>
References: <20220410171623.3788004-1-ruansy.fnst@fujitsu.com>
 <20220615125400.880067-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615125400.880067-1-ruansy.fnst@fujitsu.com>

On Wed, Jun 15, 2022 at 08:54:00PM +0800, Shiyang Ruan wrote:
> This patch is inspired by Dan's "mm, dax, pmem: Introduce
> dev_pagemap_failure()"[1].  With the help of dax_holder and
> ->notify_failure() mechanism, the pmem driver is able to ask filesystem
> (or mapped device) on it to unmap all files in use and notify processes
> who are using those files.
> 
> Call trace:
> trigger unbind
>  -> unbind_store()
>   -> ... (skip)
>    -> devres_release_all()   # was pmem driver ->remove() in v1
>     -> kill_dax()
>      -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_REMOVE)
>       -> xfs_dax_notify_failure()
> 
> Introduce MF_MEM_REMOVE to let filesystem know this is a remove event.
> So do not shutdown filesystem directly if something not supported, or if
> failure range includes metadata area.  Make sure all files and processes
> are handled correctly.
> 
> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> 
> ==
> Changes since v2:
>   1. Rebased on next-20220615
> 
> Changes since v1:
>   1. Drop the needless change of moving {kill,put}_dax()
>   2. Rebased on '[PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink'[2]
> 
> ---
>  drivers/dax/super.c         | 2 +-
>  fs/xfs/xfs_notify_failure.c | 6 +++++-
>  include/linux/mm.h          | 1 +
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 9b5e2a5eb0ae..d4bc83159d46 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -323,7 +323,7 @@ void kill_dax(struct dax_device *dax_dev)
>  		return;
>  
>  	if (dax_dev->holder_data != NULL)
> -		dax_holder_notify_failure(dax_dev, 0, U64_MAX, 0);
> +		dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_REMOVE);

At the point we're initiating a MEM_REMOVE call, is the pmem already
gone, or is it about to be gone?

>  
>  	clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
>  	synchronize_srcu(&dax_srcu);
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index aa8dc27c599c..91d3f05d4241 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -73,7 +73,9 @@ xfs_dax_failure_fn(
>  	struct failure_info		*notify = data;
>  	int				error = 0;
>  
> -	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> +	/* Do not shutdown so early when device is to be removed */
> +	if (!(notify->mf_flags & MF_MEM_REMOVE) ||
> +	    XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
>  	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
>  		return -EFSCORRUPTED;
> @@ -182,6 +184,8 @@ xfs_dax_notify_failure(
>  
>  	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
>  	    mp->m_logdev_targp != mp->m_ddev_targp) {
> +		if (mf_flags & MF_MEM_REMOVE)
> +			return -EOPNOTSUPP;

The reason I ask is that if the pmem is *about to be* but not yet
removed from the system, shouldn't we at least try to flush all dirty
files and the log to reduce data loss and minimize recovery time?

If it's already gone, then you might as well shut down immediately,
unless there's a chance the pmem will come back(?)

--D

>  		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
>  		return -EFSCORRUPTED;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 623c2ee8330a..bbeb31883362 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3249,6 +3249,7 @@ enum mf_flags {
>  	MF_SOFT_OFFLINE = 1 << 3,
>  	MF_UNPOISON = 1 << 4,
>  	MF_NO_RETRY = 1 << 5,
> +	MF_MEM_REMOVE = 1 << 6,
>  };
>  int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
>  		      unsigned long count, int mf_flags);
> -- 
> 2.36.1
> 
> 
> 

