Return-Path: <nvdimm+bounces-2248-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 027A2471ABC
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Dec 2021 15:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 16F1A1C08E9
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Dec 2021 14:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACA42CB3;
	Sun, 12 Dec 2021 14:24:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208BF68
	for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 14:24:55 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so10982176pjj.0
        for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 06:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gx1tZXjb8AeAhB7OBAq5KXQcuI8KW2+S0VORLm1oQmE=;
        b=Trf/HIOkN+GeGmgox59HxlD8ZOMlFR20ZB+InMjn8/xjd5AQWEht+f7dJJDPJyQt12
         Hs5YF40306Zm+ygK1CkaaBfKeTFcnCVxPeAsPHYpd0YiawMuZdnSo4bkhdvsePlhOd2j
         gAp/LiKLwAFP7q12nb6Z4T6lCVmaI7p1OY+Ynjav6wTP+dzQth2d6BE8dz6PBdnsOt60
         +JosCj5v1C6S5Kf0NUnRqyPbjtiwVa7ZbqayH9ApCY0Ua0U9zyIlGp4volZ/PsUKs7r+
         gRLq3OocwTID+gPajAtFPOiHoNB+XHUI8k84Lejv8hBlIeIcUuZXXTB2apRUF/GggIWe
         Gd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gx1tZXjb8AeAhB7OBAq5KXQcuI8KW2+S0VORLm1oQmE=;
        b=XbLw5WBP7+efOeIZgI2mvAh8wYc3QqhfAJHmZI5LHbGxHOJNUk+rBgVgtDCVGttpj0
         tuqj309+VoMpO2NYhlqmY017IsWkDeB9KDBIk/qMn/Y+JltpkVQ/2+dcU8ZazbaVkFrq
         Ar3wSRA+XVn1j7NshJm8qcpxvmy8j72GR1+yM3VwClUhrixZfN8vH1PFf9mh/hpXoIT1
         7AfgbDoxi+L9lkcVDrOBEV6VywkMvRiY0s+8cK3IjZRp56wyFEW2nuO8xriZIya6wSih
         qHT+L7WQw14j949kLGPDuJRsuZ/Y5J1QGXbnv1ATzGPklpreSkfZFMTzOJhNVO7SKng3
         erSQ==
X-Gm-Message-State: AOAM531upkH8Mt0ShqLKuQm2VdPDyKilpEPaMEBw18fNpi6LmOVFbP+v
	GLT1GQuLpjOIX8lqE8km28V8I5XmvJy37Xfln9YUyA==
X-Google-Smtp-Source: ABdhPJwFoKtHTY/7DpYcVbpBLICwvWE+oSlxmI8ktfa2e/eDZD8ZbEJ6Ezent6W05XQ0XSGm2bJaI9jJ1yqTHEuhU84=
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr37601802pjb.8.1639319094550;
 Sun, 12 Dec 2021 06:24:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-4-hch@lst.de>
In-Reply-To: <20211209063828.18944-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:24:44 -0800
Message-ID: <CAPcyv4i2=n2q_xZ=uaYu71cVE8RH6R85meofm12xg-89OcDdyQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] dax: remove the DAXDEV_F_SYNC flag
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove the DAXDEV_F_SYNC flag and thus the flags argument to alloc_dax and
> just let the drivers call set_dax_synchronous directly.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sure, looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

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
> --
> 2.30.2
>

