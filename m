Return-Path: <nvdimm+bounces-208-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0353A931D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Jun 2021 08:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id CA4883E1045
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Jun 2021 06:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E80A2FB2;
	Wed, 16 Jun 2021 06:50:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39FF70
	for <nvdimm@lists.linux.dev>; Wed, 16 Jun 2021 06:50:09 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id 11so608544plk.12
        for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 23:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Kn3PBZvfdrm3M++IQCcW4SjJvH/DG1JZP1myaOpJRg=;
        b=EOUg1SGoT/6uPzoDXTs7vcmZcQci9D4manCusk+A1HK/afG4VmUTZJ89jjcHHhF+15
         uDqVUdG5Jdourr03Cxc0YGw7sbmPEt9Pr3EGYAPrRyqSEEBLdhkj+MTnwPyydv0GBvoM
         dfqP3Y4INs8cQT5ly23nRsxM3joBbpiFsfbw40tuTTT4WoV1SqU9dQ4Ajfz3c6Ty/0q8
         1cZOMl+cehTCGKZQ7JY74pJGDp2MPTk0DAJ7yBKQdp6tvwCQExYpIOb+7tmP7sZ/9HqU
         rqItzUaIRiLJ5q0EBSfITxk49RBh4zDf49bvuF7oxdH6oq0gdzedyMoEZVeEQCFEmpXu
         6UCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Kn3PBZvfdrm3M++IQCcW4SjJvH/DG1JZP1myaOpJRg=;
        b=qdvn4gJv2RHIsab0i7o5VUZK9c7gc+YCwF0tzZKYJzD73yfSKnF15UTKOZre7YT7AS
         U5t9hwENC2eXN5gaFG4G78Mw0e2BMLp401wxOe5sng0koY9dKqpPd6k1KlYLSH2iMy9R
         doCzLLeW6/2h/UvWpwUreJrwrv2w8LSn08cu5PknTGSTxN0CrX5juI21Y4EtLIu7R/N2
         3kHbS3GlddBs7EG8AxNZQTRtFXjEYtYI5Vtb5R3MKLBDYb7ISycpLXU5TKYwwRsAaW2h
         kEutJDbum6g78Nlq6X+jTH2G9+MJypJxI3fj1RemXMFHwxAUFYJkfFXzkX5ylXYJ8MCs
         qxGg==
X-Gm-Message-State: AOAM533MPe0tWHMIjVID+97w/DCBAY57pQ1ZwMxOZ2x61L5GF1kILH4I
	VJYL19xcqrfmc8mBfgknld4nM68aI2Pl29zhXOSt/w==
X-Google-Smtp-Source: ABdhPJyQRs1D11qRe1LliJmjI3lSiLNlJfJSax7U3r7FSVTrVSQxBNBqbhHBO+w23FsmYdODe6G8Ue0jGeGbsigANto=
X-Received: by 2002:a17:902:b497:b029:115:e287:7b55 with SMTP id
 y23-20020a170902b497b0290115e2877b55mr7677048plr.79.1623826208688; Tue, 15
 Jun 2021 23:50:08 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com> <20210604011844.1756145-6-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-6-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jun 2021 23:49:57 -0700
Message-ID: <CAPcyv4heVL+9T3R8dTRw7yaFsL65MXN2qbuqFnO4G2fHMFgYiA@mail.gmail.com>
Subject: Re: [PATCH v4 05/10] mm, pmem: Implement ->memory_failure() in pmem driver
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Call the ->memory_failure() which is implemented by pmem driver, in
> order to finally notify filesystem to handle the corrupted data.  The
> handler which collects and kills processes are moved into
> mf_dax_kill_procs(), which will be called by filesystem.
>
> Keep the old handler in order to roll back if driver or filesystem
> does not support ->memory_failure()/->corrupted_range().
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  block/genhd.c         | 30 ++++++++++++++++++
>  drivers/nvdimm/pmem.c | 14 +++++++++
>  include/linux/genhd.h |  1 +
>  mm/memory-failure.c   | 71 +++++++++++++++++++++++++++----------------

I would not expect a patch that converts the pmem driver to touch
mm/memory-failure.c. mf_generic_kill_procs() has nothing to do with
the pmem driver.

>  4 files changed, 90 insertions(+), 26 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 9f8cb7beaad1..75834bd057df 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -718,6 +718,36 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
>         return bdev;
>  }
>
> +/**
> + * bdget_disk_sector - get block device by given sector number
> + * @disk: gendisk of interest
> + * @sector: sector number
> + *
> + * RETURNS: the found block device where sector locates in
> + */
> +struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector)
> +{
> +       struct block_device *part = NULL, *p;
> +       unsigned long idx;
> +
> +       rcu_read_lock();
> +       xa_for_each(&disk->part_tbl, idx, p) {
> +               if (p->bd_partno == 0)
> +                       continue;
> +               if (p->bd_start_sect <= sector &&
> +                       sector < p->bd_start_sect + bdev_nr_sectors(p)) {
> +                       part = p;
> +                       break;
> +               }
> +       }
> +       rcu_read_unlock();
> +       if (!part)
> +               part = disk->part0;
> +
> +       return bdget_disk(disk, part->bd_partno);
> +}
> +EXPORT_SYMBOL(bdget_disk_sector);

I can't see any justification for this function. The pmem driver does
not need it and the upper layer holders should have their own
mechanism to go from dax_dev offset to bdev if they need to, but
hopefully they don't. A dax_device failure should be independent of a
block_device failure.

> +
>  /*
>   * print a full list of all partitions - intended for places where the root
>   * filesystem can't be mounted and thus to give the victim some idea of what
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index ed10a8b66068..98349e7d0a28 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -364,9 +364,23 @@ static void pmem_release_disk(void *__pmem)
>         put_disk(pmem->disk);
>  }
>
> +static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +               unsigned long pfn, int flags)
> +{
> +       struct pmem_device *pdev =
> +                       container_of(pgmap, struct pmem_device, pgmap);

This local variable is called @pmem not @pdev in other parts of the driver.

> +       loff_t offset = PFN_PHYS(pfn) - pdev->phys_addr - pdev->data_offset;
> +       struct block_device *bdev =
> +                       bdget_disk_sector(pdev->disk, offset >> SECTOR_SHIFT);
> +
> +       return dax_corrupted_range(pdev->dax_dev, bdev, offset,
> +                                  page_size(pfn_to_page(pfn)), &flags);

Per previous comments this interface should be range based. Why is the
last argument &flags? That was passed in by value so any changes to it
will not be reflected back to memory_failure()?

> +}
> +
>  static const struct dev_pagemap_ops fsdax_pagemap_ops = {
>         .kill                   = pmem_pagemap_kill,
>         .cleanup                = pmem_pagemap_cleanup,
> +       .memory_failure         = pmem_pagemap_memory_failure,
>  };
>
>  static int pmem_attach_disk(struct device *dev,
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 6fc26f7bdf71..2ad70c02c343 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -219,6 +219,7 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
>
>  extern void del_gendisk(struct gendisk *gp);
>  extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
> +extern struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector);
>
>  void set_disk_ro(struct gendisk *disk, bool read_only);
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 4377e727d478..43017d7f3918 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1247,6 +1247,36 @@ static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>         kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
>  }
>
> +static int mf_generic_kill_procs(unsigned long long pfn, int flags)
> +{
> +       struct page *page = pfn_to_page(pfn);
> +       LIST_HEAD(to_kill);
> +       dax_entry_t cookie;
> +
> +       /*
> +        * Prevent the inode from being freed while we are interrogating
> +        * the address_space, typically this would be handled by
> +        * lock_page(), but dax pages do not use the page lock. This
> +        * also prevents changes to the mapping of this pfn until
> +        * poison signaling is complete.
> +        */
> +       cookie = dax_lock_page(page);
> +       if (!cookie)
> +               return -EBUSY;
> +       /*
> +        * Unlike System-RAM there is no possibility to swap in a
> +        * different physical page at a given virtual address, so all
> +        * userspace consumption of ZONE_DEVICE memory necessitates
> +        * SIGBUS (i.e. MF_MUST_KILL)
> +        */
> +       flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +       collect_procs(page, &to_kill, flags & MF_ACTION_REQUIRED);
> +
> +       unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
> +       dax_unlock_page(page, cookie);
> +       return 0;
> +}
> +

Per above, I am surprised to find this in this patch, it belong in its
own patch if at all.

>  int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index, int flags)
>  {
>         LIST_HEAD(to_kill);
> @@ -1348,9 +1378,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>                 struct dev_pagemap *pgmap)
>  {
>         struct page *page = pfn_to_page(pfn);
> -       LIST_HEAD(to_kill);
>         int rc = -EBUSY;
> -       dax_entry_t cookie;
>
>         if (flags & MF_COUNT_INCREASED)
>                 /*
> @@ -1364,20 +1392,9 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>                 goto out;
>         }
>
> -       /*
> -        * Prevent the inode from being freed while we are interrogating
> -        * the address_space, typically this would be handled by
> -        * lock_page(), but dax pages do not use the page lock. This
> -        * also prevents changes to the mapping of this pfn until
> -        * poison signaling is complete.
> -        */
> -       cookie = dax_lock_page(page);
> -       if (!cookie)
> -               goto out;
> -
>         if (hwpoison_filter(page)) {
>                 rc = 0;
> -               goto unlock;
> +               goto out;
>         }
>
>         if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
> @@ -1385,7 +1402,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>                  * TODO: Handle HMM pages which may need coordination
>                  * with device-side memory.
>                  */
> -               goto unlock;
> +               goto out;
>         }
>
>         /*
> @@ -1395,19 +1412,21 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>         SetPageHWPoison(page);
>
>         /*
> -        * Unlike System-RAM there is no possibility to swap in a
> -        * different physical page at a given virtual address, so all
> -        * userspace consumption of ZONE_DEVICE memory necessitates
> -        * SIGBUS (i.e. MF_MUST_KILL)
> +        * Call driver's implementation to handle the memory failure,
> +        * otherwise roll back to generic handler.
>          */
> -       flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> -       collect_procs_file(page, page->mapping, page->index, &to_kill,
> -                          flags & MF_ACTION_REQUIRED);
> +       if (pgmap->ops->memory_failure) {
> +               rc = pgmap->ops->memory_failure(pgmap, pfn, flags);
> +               /*
> +                * Roll back to generic handler too if operation is not
> +                * supported inside the driver/device/filesystem.
> +                */
> +               if (rc != EOPNOTSUPP)
> +                       goto out;
> +       }
> +
> +       rc = mf_generic_kill_procs(pfn, flags);
>
> -       unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
> -       rc = 0;
> -unlock:
> -       dax_unlock_page(page, cookie);
>  out:
>         /* drop pgmap ref acquired in caller */
>         put_dev_pagemap(pgmap);
> --
> 2.31.1
>
>
>

