Return-Path: <nvdimm+bounces-2259-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 856FD4722D1
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Dec 2021 09:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 85BB41C0C4E
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Dec 2021 08:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AC22CA5;
	Mon, 13 Dec 2021 08:40:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE7E68
	for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 08:40:49 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id m9so17711821iop.0
        for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 00:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0PVpqCwIIzT5LiWPmRy0UQXlV25IiTTKjnxtrdOpjdg=;
        b=XslP0/DrKKm00eqAXxJkpa4OppReO8DFePpl0NrqsH0kahG09P03XactTTb9JZ6bfd
         o26yPflHoIB512Q+3UUif1ujL9UH/ThpeJpJ/nOs9pDD1eHl2kFhDy3E3N1iO5JlcV7S
         lye6elPj+N4ilDU47TA2qJZffja29H3PVBxBXgESQdL/2cxf8OCFteq0hi2N0ZYejTGT
         MYcAPYkKdVhVqNUhc4NWD+lE0OQCsGg6r3nUgnNlYJ0K9rNxJK7BhYkbppS3z2OkgTyI
         Q6oe0nHj6CkrFXd/jphO4s3Sl50jffMBpHRtWxWfWUpaMish6CYOGo0is7JSYM2z1Qvs
         Q/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0PVpqCwIIzT5LiWPmRy0UQXlV25IiTTKjnxtrdOpjdg=;
        b=IED3kUkjWSRjpMAKo8F3zFfdf2BrXjsuTnl59613Dg/zYIhwPNl36XSiCrKHz/Lg7h
         tGzguqX2ksNun9giyATiZSpdQguRkwQgmUAyaLvyqcRZPNcnOCJidvqspCPYGgDtdb3D
         cIsnJQH5pUKkzMgBvMe9X0bfpnUnIRaRRZ43n0B6XtQSBcd/Y7lM/iI5sHQSwfx1UHpA
         6amv+5yiWhYrPpsextb+BaxxQGhyguJbhix0wGUINLnrJcftoXATrBkBFmELxtIzo6Ug
         5RfV6c2bF7UUwIgn+3sL5KAIh0cOexJxovMa/s5dbxEpCpvBy+XbgRQRI3UCPu+5v0Lt
         5KQQ==
X-Gm-Message-State: AOAM533oUOD/KGnpw+HpTI4mgOLzEcqUhOg+iOoeDvl9GVyBF1kh553H
	AMxVhdKuZ6MkiMnLLZhZtf0dS1lZy2JMMxXdc60=
X-Google-Smtp-Source: ABdhPJwxmNvCoakg1QaCbmWr8rWWu/4Lgvkfd58YwUsQ9hg8VdK9DfCOvLxOD3zbQQIhWbew1Ez4p6CvOYdkco5t1Hs=
X-Received: by 2002:a6b:7711:: with SMTP id n17mr31597632iom.21.1639384849051;
 Mon, 13 Dec 2021 00:40:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-4-hch@lst.de>
In-Reply-To: <20211209063828.18944-4-hch@lst.de>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 13 Dec 2021 09:40:38 +0100
Message-ID: <CAM9Jb+gVh09scB7BVRHaZ9n+XdF8QyKwVSSg5eAno6WkDAwQTw@mail.gmail.com>
Subject: Re: [PATCH 3/5] dax: remove the DAXDEV_F_SYNC flag
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Matthew Wilcox <willy@infradead.org>, dm-devel@redhat.com, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

> Remove the DAXDEV_F_SYNC flag and thus the flags argument to alloc_dax and
> just let the drivers call set_dax_synchronous directly.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/bus.c            | 3 ++-
>  drivers/dax/super.c          | 6 +-----
>  drivers/md/dm.c              | 2 +-
>  drivers/nvdimm/pmem.c        | 7 +++----
>  drivers/s390/block/dcssblk.c | 4 ++--
>  fs/fuse/virtio_fs.c          | 2 +-
>  include/linux/dax.h          | 8 ++------
>  7 files changed, 12 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 6683d42c32c56..da2a14d096d29 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1324,11 +1324,12 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>          * No dax_operations since there is no access to this device outside of
>          * mmap of the resulting character device.
>          */
> -       dax_dev = alloc_dax(dev_dax, NULL, DAXDEV_F_SYNC);
> +       dax_dev = alloc_dax(dev_dax, NULL);
>         if (IS_ERR(dax_dev)) {
>                 rc = PTR_ERR(dax_dev);
>                 goto err_alloc_dax;
>         }
> +       set_dax_synchronous(dax_dev);
>
>         /* a device_dax instance is dead while the driver is not attached */
>         kill_dax(dax_dev);
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e18155f43a635..e81d5ee57390f 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -345,8 +345,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
>         return dax_dev;
>  }
>
> -struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
> -               unsigned long flags)
> +struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>  {
>         struct dax_device *dax_dev;
>         dev_t devt;
> @@ -366,9 +365,6 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
>
>         dax_dev->ops = ops;
>         dax_dev->private = private;
> -       if (flags & DAXDEV_F_SYNC)
> -               set_dax_synchronous(dax_dev);
> -
>         return dax_dev;
>
>   err_dev:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4e997c02bb0a0..f4b972af10928 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1765,7 +1765,7 @@ static struct mapped_device *alloc_dev(int minor)
>         sprintf(md->disk->disk_name, "dm-%d", minor);
>
>         if (IS_ENABLED(CONFIG_FS_DAX)) {
> -               md->dax_dev = alloc_dax(md, &dm_dax_ops, 0);
> +               md->dax_dev = alloc_dax(md, &dm_dax_ops);
>                 if (IS_ERR(md->dax_dev)) {
>                         md->dax_dev = NULL;
>                         goto bad;
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 8294f1c701baa..85b3339286bd8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -402,7 +402,6 @@ static int pmem_attach_disk(struct device *dev,
>         struct gendisk *disk;
>         void *addr;
>         int rc;
> -       unsigned long flags = 0UL;
>
>         pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
>         if (!pmem)
> @@ -495,13 +494,13 @@ static int pmem_attach_disk(struct device *dev,
>         nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
>         disk->bb = &pmem->bb;
>
> -       if (is_nvdimm_sync(nd_region))
> -               flags = DAXDEV_F_SYNC;
> -       dax_dev = alloc_dax(pmem, &pmem_dax_ops, flags);
> +       dax_dev = alloc_dax(pmem, &pmem_dax_ops);
>         if (IS_ERR(dax_dev)) {
>                 rc = PTR_ERR(dax_dev);
>                 goto out;
>         }
> +       if (is_nvdimm_sync(nd_region))
> +               set_dax_synchronous(dax_dev);
>         rc = dax_add_host(dax_dev, disk);
>         if (rc)
>                 goto out_cleanup_dax;
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index e65e83764d1ce..10823debc09bd 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -686,13 +686,13 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
>         if (rc)
>                 goto put_dev;
>
> -       dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops,
> -                       DAXDEV_F_SYNC);
> +       dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
>         if (IS_ERR(dev_info->dax_dev)) {
>                 rc = PTR_ERR(dev_info->dax_dev);
>                 dev_info->dax_dev = NULL;
>                 goto put_dev;
>         }
> +       set_dax_synchronous(dev_info->dax_dev);
>         rc = dax_add_host(dev_info->dax_dev, dev_info->gd);
>         if (rc)
>                 goto out_dax;
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 242cc1c0d7ed7..5c03a0364a9bb 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -850,7 +850,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
>         dev_dbg(&vdev->dev, "%s: window kaddr 0x%px phys_addr 0x%llx len 0x%llx\n",
>                 __func__, fs->window_kaddr, cache_reg.addr, cache_reg.len);
>
> -       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops, 0);
> +       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
>         if (IS_ERR(fs->dax_dev))
>                 return PTR_ERR(fs->dax_dev);
>
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 3bd1fdb5d5f4b..c04f46478e3b5 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -6,9 +6,6 @@
>  #include <linux/mm.h>
>  #include <linux/radix-tree.h>
>
> -/* Flag for synchronous flush */
> -#define DAXDEV_F_SYNC (1UL << 0)
> -
>  typedef unsigned long dax_entry_t;
>
>  struct dax_device;
> @@ -42,8 +39,7 @@ struct dax_operations {
>  };
>
>  #if IS_ENABLED(CONFIG_DAX)
> -struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
> -               unsigned long flags);
> +struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
> @@ -64,7 +60,7 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>  }
>  #else
>  static inline struct dax_device *alloc_dax(void *private,
> -               const struct dax_operations *ops, unsigned long flags)
> +               const struct dax_operations *ops)
>  {
>         /*
>          * Callers should check IS_ENABLED(CONFIG_DAX) to know if this

Looks good.
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>

