Return-Path: <nvdimm+bounces-4779-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 992C05BDA58
	for <lists+linux-nvdimm@lfdr.de>; Tue, 20 Sep 2022 04:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33876280D23
	for <lists+linux-nvdimm@lfdr.de>; Tue, 20 Sep 2022 02:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD9FEDE;
	Tue, 20 Sep 2022 02:45:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F96ED3
	for <nvdimm@lists.linux.dev>; Tue, 20 Sep 2022 02:45:23 +0000 (UTC)
Received: from dread.disaster.area (pa49-180-183-60.pa.nsw.optusnet.com.au [49.180.183.60])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A23661100975;
	Tue, 20 Sep 2022 12:45:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1oaTGB-009qB6-UQ; Tue, 20 Sep 2022 12:45:19 +1000
Date: Tue, 20 Sep 2022 12:45:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH 3/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <20220920024519.GQ3600936@dread.disaster.area>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
 <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1662114961-66-4-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1662114961-66-4-git-send-email-ruansy.fnst@fujitsu.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=63292942
	a=mj5ET7k2jFntY++HerHxfg==:117 a=mj5ET7k2jFntY++HerHxfg==:17
	a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
	a=omOdbC7AAAAA:8 a=7-415B0cAAAA:8 a=_WoWtd2e78iMft2-j4wA:9
	a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Fri, Sep 02, 2022 at 10:36:01AM +0000, Shiyang Ruan wrote:
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
>      -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
>       -> xfs_dax_notify_failure()
> 
> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
> event.  So do not shutdown filesystem directly if something not
> supported, or if failure range includes metadata area.  Make sure all
> files and processes are handled correctly.
> 
> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c         |  3 ++-
>  fs/xfs/xfs_notify_failure.c | 23 +++++++++++++++++++++++
>  include/linux/mm.h          |  1 +
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 9b5e2a5eb0ae..cf9a64563fbe 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -323,7 +323,8 @@ void kill_dax(struct dax_device *dax_dev)
>  		return;
>  
>  	if (dax_dev->holder_data != NULL)
> -		dax_holder_notify_failure(dax_dev, 0, U64_MAX, 0);
> +		dax_holder_notify_failure(dax_dev, 0, U64_MAX,
> +				MF_MEM_PRE_REMOVE);
>  
>  	clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
>  	synchronize_srcu(&dax_srcu);
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 3830f908e215..5e04ba7fa403 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/mm.h>
>  #include <linux/dax.h>
> +#include <linux/fs.h>
>  
>  struct xfs_failure_info {
>  	xfs_agblock_t		startblock;
> @@ -77,6 +78,9 @@ xfs_dax_failure_fn(
>  
>  	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
>  	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
> +		/* The device is about to be removed.  Not a really failure. */
> +		if (notify->mf_flags & MF_MEM_PRE_REMOVE)
> +			return 0;
>  		notify->want_shutdown = true;
>  		return 0;
>  	}
> @@ -182,12 +186,23 @@ xfs_dax_notify_failure(
>  	struct xfs_mount	*mp = dax_holder(dax_dev);
>  	u64			ddev_start;
>  	u64			ddev_end;
> +	int			error;
>  
>  	if (!(mp->m_super->s_flags & SB_BORN)) {
>  		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
>  		return -EIO;
>  	}
>  
> +	if (mf_flags & MF_MEM_PRE_REMOVE) {
> +		xfs_info(mp, "device is about to be removed!");
> +		down_write(&mp->m_super->s_umount);
> +		error = sync_filesystem(mp->m_super);
> +		drop_pagecache_sb(mp->m_super, NULL);
> +		up_write(&mp->m_super->s_umount);
> +		if (error)
> +			return error;

If the device is about to go away unexpectedly, shouldn't this shut
down the filesystem after syncing it here?  If the filesystem has
been shut down, then everything will fail before removal finally
triggers, and the act of unmounting the filesystem post device
removal will clean up the page cache and all the other caches.

IOWs, I don't understand why the page cache is considered special
here (as opposed to, say, the inode or dentry caches), nor why we
aren't shutting down the filesystem directly after syncing it to
disk to ensure that we don't end up with applications losing data as
a result of racing with the removal....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

