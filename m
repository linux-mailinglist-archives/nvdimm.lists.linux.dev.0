Return-Path: <nvdimm+bounces-3028-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 638674B7A30
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Feb 2022 23:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1F5A31C0A44
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Feb 2022 22:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD7021B66;
	Tue, 15 Feb 2022 22:06:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193531B64
	for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 22:06:35 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id j4so319729plj.8
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 14:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VVrjCQk0e2bEXbKTkyebIDZYiYKF0U8p5xUNgx6nAe0=;
        b=nE35RWa6oDgBalrevFEPRO4+2X1WpWNqXc18NzpTgKw5LYA/qcTsaEbTbUcF5+1vny
         yinI0tL2Ot6PPN326SGxQFjZJw7wM6Ak/gPKz3EexZH9k6ekyuItMdahLbM5M328yY9f
         IB1FQymUIQ5G+Q/15li4O96F2jwU1xjrnmCkkyUVXlCXvgjP8jBgYvFO/miqvK26On6U
         guLecixg3/nlWPYYO9/Fy4Rc2CSSKsXpjLwSBwBiGyY/V86ic7L+kpL/cbjgLb+mrNnU
         Dj4LsAPhCboWHCBb7jVbBlNPYixLLKaDYizQHgOchXufz+VZR2/rExv3NHWvYNjoqIKV
         +DUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VVrjCQk0e2bEXbKTkyebIDZYiYKF0U8p5xUNgx6nAe0=;
        b=QogZ/RKwR1+S+eDclTdZ8dTTgCWsHBi7rVS/tQ86VhVIv2fRp9TNpn3P/3N056sQPP
         t+Mx58cuuWYMUP52Zterhoc69kwBsN+z385K9VBbwDfjDwt3bae0pSG+Z5NHJcvovVr+
         T09mfB7XBcLUQ1Jv/JYhOL/elTXUi2T91L6VXvx3MX+srwfr0v+ZKGcafogBPjMhi0Cv
         KuI0TzIlIoxFodOsYrfGYU50wf+5v7atR/XxMd20S/OmG6WpuZA2aF9jwSwwwdBqZ1V1
         CMd0urCtjWj9z9CWwdciXK+0JRIVWcSumxS8kekg2UuCIm/z7LEZiUu+vSJVTuUI1iLu
         m0fQ==
X-Gm-Message-State: AOAM533/mL9v1SolhHno8nMuRGabY3Zfd6U7x4L1HFjDZqRImgF7deOt
	sW7QwHiJdtoJ+3C3JpMpSbzdh7Wzsh2NzNF4jeTqYeOBfjA=
X-Google-Smtp-Source: ABdhPJwlpdC05oj7M5BjmWhQxUU9avBLaGs7R0OLF51skyfT2cwCjdpjxdAijHrqBSuda/rYLUu8zubxJ+5FrHrRYqg=
X-Received: by 2002:a17:90a:e7cb:: with SMTP id kb11mr1025329pjb.220.1644962794472;
 Tue, 15 Feb 2022 14:06:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YfqBLxjr5zz1TU91@infradead.org> <20220213125832.2722009-1-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220213125832.2722009-1-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 14:06:26 -0800
Message-ID: <CAPcyv4j9VTGxsNv4QFMONTjh_NWPkQ3dkG-uKvTyRp+X0bBvew@mail.gmail.com>
Subject: Re: [PATCH v10.1 1/9] dax: Introduce holder for dax_device
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Feb 13, 2022 at 4:58 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> v10.1 update:
>  - Fix build error reported by kernel test robot
>  - Add return code to dax_register_holder()
>  - Add write lock to prevent concurrent registrations
>  - Rename dax_get_holder() to dax_holder()
>  - Add kernel doc for new added functions
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    instance of this filesystem.
>  - When this pmem device is one of the targets in a mapped device, the
>    holder will be this mapped device.  In this case, the mapped device
>    has its own dax_device and it will follow the first rule.  So that we
>    can finally track to the filesystem we needed.
>
> The holder and holder_ops will be set when filesystem is being mounted,
> or an target device is being activated.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c | 95 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 30 ++++++++++++++
>  2 files changed, 125 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e3029389d809..d7fb4c36bf16 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -21,6 +21,9 @@
>   * @cdev: optional character interface for "device dax"
>   * @private: dax driver private data
>   * @flags: state and boolean properties
> + * @ops: operations for dax_device
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
> + * @holder_ops: operations for the inner holder
>   */
>  struct dax_device {
>         struct inode inode;
> @@ -28,6 +31,9 @@ struct dax_device {
>         void *private;
>         unsigned long flags;
>         const struct dax_operations *ops;
> +       void *holder_data;
> +       struct percpu_rw_semaphore holder_rwsem;

This lock is not necessary, see below...

> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static dev_t dax_devt;
> @@ -193,6 +199,29 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
> +                             u64 len, int mf_flags)
> +{
> +       int rc, id;
> +
> +       id = dax_read_lock();
> +       if (!dax_alive(dax_dev)) {
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       if (!dax_dev->holder_ops) {
> +               rc = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> +out:
> +       dax_read_unlock(id);
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -268,6 +297,13 @@ void kill_dax(struct dax_device *dax_dev)
>
>         clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
>         synchronize_srcu(&dax_srcu);
> +
> +       /* Lock to prevent concurrent registrations. */
> +       percpu_down_write(&dax_dev->holder_rwsem);
> +       /* clear holder data */
> +       dax_dev->holder_ops = NULL;
> +       dax_dev->holder_data = NULL;
> +       percpu_up_write(&dax_dev->holder_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(kill_dax);
>
> @@ -393,6 +429,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>
>         dax_dev->ops = ops;
>         dax_dev->private = private;
> +       percpu_init_rwsem(&dax_dev->holder_rwsem);
>         return dax_dev;
>
>   err_dev:
> @@ -409,6 +446,64 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +/**
> + * dax_holder() - obtain the holder of a dax device
> + * @dax_dev: a dax_device instance
> +
> + * Return: the holder's data which represents the holder if registered,
> + * otherwize NULL.
> + */
> +void *dax_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_alive(dax_dev))
> +               return NULL;
> +
> +       return dax_dev->holder_data;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder);
> +
> +/**
> + * dax_register_holder() - register a holder to a dax device
> + * @dax_dev: a dax_device instance
> + * @holder: a pointer to a holder's data which represents the holder
> + * @ops: operations of this holder
> +
> + * Return: negative errno if an error occurs, otherwise 0.
> + */
> +int dax_register_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_alive(dax_dev))
> +               return -ENXIO;
> +
> +       /* Already registered */
> +       if (dax_holder(dax_dev))
> +               return -EBUSY;

Delete this...

> +
> +       /* Lock to prevent concurrent registrations. */
> +       percpu_down_write(&dax_dev->holder_rwsem);

...and just use cmpxchg:

if (cmpxchg(&dax_dev->holder_data, NULL, holder))
    return -EBUSY;
dax_dev->holder_ops = ops;

...and then on the release side you can require that the caller
specify @holder before clearing to make the unregistration symmetric:

if (cmpxchg(&dax_dev->holder_data, holder, NULL) != holder))
    return -EBUSY;
dax_dev->holder_ops = NULL;


> +       dax_dev->holder_data = holder;
> +       dax_dev->holder_ops = ops;
> +       percpu_up_write(&dax_dev->holder_rwsem);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_register_holder);
> +
> +/**
> + * dax_unregister_holder() - unregister the holder for a dax device
> + * @dax_dev: a dax_device instance
> + */
> +void dax_unregister_holder(struct dax_device *dax_dev)

Per above, require the holder to pass in their holder_data again.

> +{
> +       if (!dax_alive(dax_dev))
> +               return;
> +
> +       dax_dev->holder_data = NULL;
> +       dax_dev->holder_ops = NULL;
> +}
> +EXPORT_SYMBOL_GPL(dax_unregister_holder);
> +
>  /**
>   * inode_dax: convert a public inode into its dax_dev
>   * @inode: An inode with i_cdev pointing to a dax_dev
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 9fc5f99a0ae2..9800d84e5b7d 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -32,8 +32,24 @@ struct dax_operations {
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
>
> +struct dax_holder_operations {
> +       /*
> +        * notify_failure - notify memory failure into inner holder device
> +        * @dax_dev: the dax device which contains the holder
> +        * @offset: offset on this dax device where memory failure occurs
> +        * @len: length of this memory failure event
> +        * @flags: action flags for memory failure handler
> +        */
> +       int (*notify_failure)(struct dax_device *dax_dev, u64 offset,
> +                       u64 len, int mf_flags);
> +};
> +
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
> +int dax_register_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops);
> +void dax_unregister_holder(struct dax_device *dax_dev);
> +void *dax_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
> @@ -53,6 +69,18 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>         return dax_synchronous(dax_dev);
>  }
>  #else
> +static inline int dax_register_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       return 0;
> +}
> +static inline void dax_unregister_holder(struct dax_device *dax_dev)
> +{
> +}
> +static inline void *dax_holder(struct dax_device *dax_dev)
> +{
> +       return NULL;
> +}
>  static inline struct dax_device *alloc_dax(void *private,
>                 const struct dax_operations *ops)
>  {
> @@ -185,6 +213,8 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>                 size_t bytes, struct iov_iter *i);
>  int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>                         size_t nr_pages);
> +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off, u64 len,
> +               int mf_flags);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
>
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> --
> 2.34.1
>
>
>

