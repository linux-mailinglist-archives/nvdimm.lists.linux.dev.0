Return-Path: <nvdimm+bounces-2374-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD42485C05
	for <lists+linux-nvdimm@lfdr.de>; Thu,  6 Jan 2022 00:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1F69E3E0E4A
	for <lists+linux-nvdimm@lfdr.de>; Wed,  5 Jan 2022 23:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882EE2CA8;
	Wed,  5 Jan 2022 23:01:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1241168
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 23:01:33 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id s15so639824plg.12
        for <nvdimm@lists.linux.dev>; Wed, 05 Jan 2022 15:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lYUQ0jogQjWg2SKVQ30dsRSlcaeazzEtqXlzWbNNuus=;
        b=6/Bg0iJxptBJ5muNxEYKrhAdId1eegrkiDTwzcOkRNG/1pZwpe1Kc0tU6bymS70DU+
         8ESBLtk3380N/aKA8dhXdtVbUKbQsElmA07znjldaLWcH03yYl0NJ+Q3XI9jXdeV+wTA
         qiCK76kfVGn9XvWsW5PPFXZDbq1/msVbB258rBMaV3S/YjxN4yci+XoYeyeBXenxbope
         yR2CxFbsnkQBSpIRlpWUkp2grrtqnY9HE9vcXNYsrBYd/F9pbY0XWdeUm3fL70Gb4cVx
         1lwv7FgulwaSqIh8FBqTbxrhxp9I7C4OUgas3UZmtPvyetq/ZpjcVvDGItfdG8xgBLGW
         CJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lYUQ0jogQjWg2SKVQ30dsRSlcaeazzEtqXlzWbNNuus=;
        b=kOOe5Hd4qf8c21/s/IMNQyO+UYfrmYxaR/pznc7P9hyy62PNE088FO76xWXU1IQlR6
         0eJsrRZPCHDFnlAXcQQv7aY8BB0U01HMi89j7b0uxQOzEsrLxyzxvYX+DTbhu8qMl19r
         0j4ZNhU/xVCr3CSyAqKuF5ZM8nlGKS2KbeAxgwiOD7JHBakmIreH7Cm5mWWTa9mI8T2p
         kBlUKgOZaOoqAciqVtX9LMCnUqAr6CeNoq/+xZTgg2l7WntRwqO0HHSwvt3ofQ/P59o5
         QVPGR/R1xhLCTZpYVc6AAG+rou189TNv8RjTSI+FVFmw/n3KR5u824Pz3kMHHVl2Tdgz
         B4ag==
X-Gm-Message-State: AOAM530sXeWEtgoSSP0ip55NYOxjU0bY6hEBeHKrL/SX+vSOhPZxHa7O
	MgWOL+RMZy5XZDTTWXuBiw224qLxM3jG+27f0JJK1Q==
X-Google-Smtp-Source: ABdhPJzf5eJTSEClLg5zwO6K5qaFfN5H8KDGlVe5p8PWRR8tnpS8qX7iqOl0I8aQyNguu6qYdaAdcFHeQgkO1dL21w0=
X-Received: by 2002:a17:90a:e7cb:: with SMTP id kb11mr6739703pjb.8.1641423693104;
 Wed, 05 Jan 2022 15:01:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-3-ruansy.fnst@fujitsu.com> <20220105181230.GC398655@magnolia>
 <CAPcyv4iTaneUgdBPnqcvLr4Y_nAxQp31ZdUNkSRPsQ=9CpMWHg@mail.gmail.com>
 <20220105185626.GE398655@magnolia> <CAPcyv4h3M9f1-C5e9kHTfPaRYR_zN4gzQWgR+ZyhNmG_SL-u+A@mail.gmail.com>
 <20220105224727.GG398655@magnolia>
In-Reply-To: <20220105224727.GG398655@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jan 2022 15:01:22 -0800
Message-ID: <CAPcyv4iZ88FPeZC1rt_bNdWHDZ5oh7ua31NuET2-oZ1UcMrH2Q@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] dax: Introduce holder for dax_device
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 5, 2022 at 2:47 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Jan 05, 2022 at 11:20:12AM -0800, Dan Williams wrote:
> > On Wed, Jan 5, 2022 at 10:56 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Wed, Jan 05, 2022 at 10:23:08AM -0800, Dan Williams wrote:
> > > > On Wed, Jan 5, 2022 at 10:12 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > >
> > > > > On Sun, Dec 26, 2021 at 10:34:31PM +0800, Shiyang Ruan wrote:
> > > > > > To easily track filesystem from a pmem device, we introduce a holder for
> > > > > > dax_device structure, and also its operation.  This holder is used to
> > > > > > remember who is using this dax_device:
> > > > > >  - When it is the backend of a filesystem, the holder will be the
> > > > > >    instance of this filesystem.
> > > > > >  - When this pmem device is one of the targets in a mapped device, the
> > > > > >    holder will be this mapped device.  In this case, the mapped device
> > > > > >    has its own dax_device and it will follow the first rule.  So that we
> > > > > >    can finally track to the filesystem we needed.
> > > > > >
> > > > > > The holder and holder_ops will be set when filesystem is being mounted,
> > > > > > or an target device is being activated.
> > > > > >
> > > > > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > > > > > ---
> > > > > >  drivers/dax/super.c | 62 +++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  include/linux/dax.h | 29 +++++++++++++++++++++
> > > > > >  2 files changed, 91 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > > > > > index c46f56e33d40..94c51f2ee133 100644
> > > > > > --- a/drivers/dax/super.c
> > > > > > +++ b/drivers/dax/super.c
> > > > > > @@ -20,15 +20,20 @@
> > > > > >   * @inode: core vfs
> > > > > >   * @cdev: optional character interface for "device dax"
> > > > > >   * @private: dax driver private data
> > > > > > + * @holder_data: holder of a dax_device: could be filesystem or mapped device
> > > > > >   * @flags: state and boolean properties
> > > > > > + * @ops: operations for dax_device
> > > > > > + * @holder_ops: operations for the inner holder
> > > > > >   */
> > > > > >  struct dax_device {
> > > > > >       struct inode inode;
> > > > > >       struct cdev cdev;
> > > > > >       void *private;
> > > > > >       struct percpu_rw_semaphore rwsem;
> > > > > > +     void *holder_data;
> > > > > >       unsigned long flags;
> > > > > >       const struct dax_operations *ops;
> > > > > > +     const struct dax_holder_operations *holder_ops;
> > > > > >  };
> > > > > >
> > > > > >  static dev_t dax_devt;
> > > > > > @@ -192,6 +197,29 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(dax_zero_page_range);
> > > > > >
> > > > > > +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
> > > > > > +                           u64 len, int mf_flags)
> > > > > > +{
> > > > > > +     int rc;
> > > > > > +
> > > > > > +     dax_read_lock(dax_dev);
> > > > > > +     if (!dax_alive(dax_dev)) {
> > > > > > +             rc = -ENXIO;
> > > > > > +             goto out;
> > > > > > +     }
> > > > > > +
> > > > > > +     if (!dax_dev->holder_ops) {
> > > > > > +             rc = -EOPNOTSUPP;
> > > > > > +             goto out;
> > > > > > +     }
> > > > > > +
> > > > > > +     rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> > > > > > +out:
> > > > > > +     dax_read_unlock(dax_dev);
> > > > > > +     return rc;
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> > > > > > +
> > > > > >  #ifdef CONFIG_ARCH_HAS_PMEM_API
> > > > > >  void arch_wb_cache_pmem(void *addr, size_t size);
> > > > > >  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> > > > > > @@ -254,6 +282,10 @@ void kill_dax(struct dax_device *dax_dev)
> > > > > >               return;
> > > > > >       dax_write_lock(dax_dev);
> > > > > >       clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
> > > > > > +
> > > > > > +     /* clear holder data */
> > > > > > +     dax_dev->holder_ops = NULL;
> > > > > > +     dax_dev->holder_data = NULL;
> > > > > >       dax_write_unlock(dax_dev);
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(kill_dax);
> > > > > > @@ -401,6 +433,36 @@ void put_dax(struct dax_device *dax_dev)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(put_dax);
> > > > > >
> > > > > > +void dax_register_holder(struct dax_device *dax_dev, void *holder,
> > > > > > +             const struct dax_holder_operations *ops)
> > > > > > +{
> > > > > > +     if (!dax_alive(dax_dev))
> > > > > > +             return;
> > > > > > +
> > > > > > +     dax_dev->holder_data = holder;
> > > > > > +     dax_dev->holder_ops = ops;
> > > > >
> > > > > Shouldn't this return an error code if the dax device is dead or if
> > > > > someone already registered a holder?  I'm pretty sure XFS should not
> > > > > bind to a dax device if someone else already registered for it...
> > > >
> > > > Agree, yes.
> > > >
> > > > >
> > > > > ...unless you want to use a notifier chain for failure events so that
> > > > > there can be multiple consumers of dax failure events?
> > > >
> > > > No, I would hope not. It should be 1:1 holders to dax-devices. Similar
> > > > ownership semantics like bd_prepare_to_claim().
> > >
> > > Does each partition on a pmem device still have its own dax_device?
> >
> > No, it never did...
> >
> > Just as before, each dax-device is still associated with a gendisk /
> > whole-block_device. The recent change is that instead of needing that
> > partition-block_device plumbed to convert a relative block number to
> > its absolute whole-block_device offset the filesystem now handles that
> > at iomap_begin() time. See:
> >
> >                 if (mapping_flags & IOMAP_DAX)
> >                         iomap->addr += target->bt_dax_part_off;
> >
> > ...in xfs_bmbt_to_iomap() (in -next). I.e. bdev_dax_pgoff() is gone
> > with the lead-in reworks.
>
> OH.  Crap, Dan's right:
>
> XFS (pmem0p1): ddev dax = 0xffff88800304ed00 bdev = 0xffff8880480d6180
> XFS (pmem0p2): ddev dax = 0xffff88800304ed00 bdev = 0xffff8880480d4380
>
> Unless you're planning to remove partition support too, this patch needs
> to be reworked so that multiple filesystems in separate partitions can
> each call dax_register_holder to receive memory_failure notifications
> for their partition.

Oh, crap indeed. I think this gets back to the slow tip-toeing away
from dax + partition support. While FSDAX can continue to support
"legacy/experimental" operation on partitions of DAX capable block
devices, I think failure notification + reflink support is where we
draw the line and say "DAX on partitions was a mistake, it's too late
to undo that mistake, but going forward for new FSDAX features it
requires switching from block-device partitions to pmem-namespaces if
you need sub-division support and new DAX features."

> /methinks this sharing is all a little scary...

Yes, I think we should just fail the holder registration and
DAX+reflink unless the FS being mounted on a whole device. I know Ted
and others had reservations about moving filesystems to be mounted on
dax-devices directly, but hopefully the whole-block_device requirement
is a workable middle ground?

