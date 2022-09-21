Return-Path: <nvdimm+bounces-4792-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 818EA5BF282
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 02:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 800841C20934
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 00:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFFDF1399;
	Wed, 21 Sep 2022 00:58:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4541365
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 00:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18D5C433D6;
	Wed, 21 Sep 2022 00:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663721927;
	bh=Tk5BZ3s9YloXqflrMgU4zATgp2PDiyQTeakuZwFxfJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cta/AORVvHnTh04B4P8+nB9nYCUCnOkbBCigdJ92AcISI42UNbPXAKtG7h2zotGbl
	 v+qEtiNDoPyQNfAsPl/psNg2ZTKHSU2AycXrq8UWakpVNfrG9XAy4RmRq65MthNh8c
	 jVi21gUNufeRnUxUuoqv3jwH+t/EiT5DXt/1fRplerCe/bASJMkxJzjjtVE6XmD98z
	 NFH11cV4Poy3ddKcGWTSwFUVI3uAqk/36iS4mopI/+sN+2PzY4k+T23pJ+SLBWXZV2
	 258wU7Zzw9BzSlvBx7XYp7oj02O6xZuBmnWScCxEdHV/uvdxudw6sQX7vtid/396Lw
	 /4P1criyOQoBw==
Date: Tue, 20 Sep 2022 17:58:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH 3/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <Yyphx31m5fO+OZCI@magnolia>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
 <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1662114961-66-4-git-send-email-ruansy.fnst@fujitsu.com>
 <20220920024519.GQ3600936@dread.disaster.area>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920024519.GQ3600936@dread.disaster.area>

On Tue, Sep 20, 2022 at 12:45:19PM +1000, Dave Chinner wrote:
> On Fri, Sep 02, 2022 at 10:36:01AM +0000, Shiyang Ruan wrote:
> > This patch is inspired by Dan's "mm, dax, pmem: Introduce
> > dev_pagemap_failure()"[1].  With the help of dax_holder and
> > ->notify_failure() mechanism, the pmem driver is able to ask filesystem
> > (or mapped device) on it to unmap all files in use and notify processes
> > who are using those files.
> > 
> > Call trace:
> > trigger unbind
> >  -> unbind_store()
> >   -> ... (skip)
> >    -> devres_release_all()   # was pmem driver ->remove() in v1
> >     -> kill_dax()
> >      -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
> >       -> xfs_dax_notify_failure()
> > 
> > Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
> > event.  So do not shutdown filesystem directly if something not
> > supported, or if failure range includes metadata area.  Make sure all
> > files and processes are handled correctly.
> > 
> > [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
> > 
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  drivers/dax/super.c         |  3 ++-
> >  fs/xfs/xfs_notify_failure.c | 23 +++++++++++++++++++++++
> >  include/linux/mm.h          |  1 +
> >  3 files changed, 26 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 9b5e2a5eb0ae..cf9a64563fbe 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -323,7 +323,8 @@ void kill_dax(struct dax_device *dax_dev)
> >  		return;
> >  
> >  	if (dax_dev->holder_data != NULL)
> > -		dax_holder_notify_failure(dax_dev, 0, U64_MAX, 0);
> > +		dax_holder_notify_failure(dax_dev, 0, U64_MAX,
> > +				MF_MEM_PRE_REMOVE);
> >  
> >  	clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
> >  	synchronize_srcu(&dax_srcu);
> > diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> > index 3830f908e215..5e04ba7fa403 100644
> > --- a/fs/xfs/xfs_notify_failure.c
> > +++ b/fs/xfs/xfs_notify_failure.c
> > @@ -22,6 +22,7 @@
> >  
> >  #include <linux/mm.h>
> >  #include <linux/dax.h>
> > +#include <linux/fs.h>
> >  
> >  struct xfs_failure_info {
> >  	xfs_agblock_t		startblock;
> > @@ -77,6 +78,9 @@ xfs_dax_failure_fn(
> >  
> >  	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> >  	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
> > +		/* The device is about to be removed.  Not a really failure. */
> > +		if (notify->mf_flags & MF_MEM_PRE_REMOVE)
> > +			return 0;
> >  		notify->want_shutdown = true;
> >  		return 0;
> >  	}
> > @@ -182,12 +186,23 @@ xfs_dax_notify_failure(
> >  	struct xfs_mount	*mp = dax_holder(dax_dev);
> >  	u64			ddev_start;
> >  	u64			ddev_end;
> > +	int			error;
> >  
> >  	if (!(mp->m_super->s_flags & SB_BORN)) {
> >  		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
> >  		return -EIO;
> >  	}
> >  
> > +	if (mf_flags & MF_MEM_PRE_REMOVE) {
> > +		xfs_info(mp, "device is about to be removed!");
> > +		down_write(&mp->m_super->s_umount);
> > +		error = sync_filesystem(mp->m_super);
> > +		drop_pagecache_sb(mp->m_super, NULL);
> > +		up_write(&mp->m_super->s_umount);
> > +		if (error)
> > +			return error;
> 
> If the device is about to go away unexpectedly, shouldn't this shut
> down the filesystem after syncing it here?  If the filesystem has
> been shut down, then everything will fail before removal finally
> triggers, and the act of unmounting the filesystem post device
> removal will clean up the page cache and all the other caches.

IIRC they want to kill all the processes with MAP_SYNC mappings sooner
than whenever the admin gets around to unmounting the filesystem, which
is why PRE_REMOVE will then go walk the rmapbt to find processes to
shoot down.  I'm not sure, though, if drop_pagecache_sb only touches
DRAM page cache or if it'll shoot down fsdax mappings too?

> IOWs, I don't understand why the page cache is considered special
> here (as opposed to, say, the inode or dentry caches), nor why we
> aren't shutting down the filesystem directly after syncing it to
> disk to ensure that we don't end up with applications losing data as
> a result of racing with the removal....

But yeah, we might as well shut down the fs at the end of PRE_REMOVE
handling, if the rmap walk hasn't already done that.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

