Return-Path: <nvdimm+bounces-920-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DFA3F3110
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Aug 2021 18:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id A433F3E109F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Aug 2021 16:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF113FC4;
	Fri, 20 Aug 2021 16:06:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D32C3FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 16:06:34 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id y190so9007087pfg.7
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 09:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SE1PBWc7mAk6yXDwwX3HHPm6R0g9oeMCDvjQB1FSRU4=;
        b=qYalQzoW2Ggwdbv3kEUgyzgEYSvY12zzfUROr1+BzqCFxig1iNFSX1WjFq9gGf8qwb
         RLSCrRhomWIzKnh9gEpB6S+i3uPQYcDisaRNTg1c6SZvnnC8rCRCfumKRT6L7fH/1P37
         +zW0nAHwXhnhLpUFFCPDuTHWmlUXf+4CnmFxja9S4eBXm6oRYFHW4+GcrVo4fVlT7yjw
         Y0n63ldEWM68CSxELu9A6tHjrShCuAjb5kkOm7v4dtrVpJ6G1MvoNXZhrHbSNZPol3FU
         2lyLCf9JfLM5anzTGAgvT2ovm2qtdFPG9BrPN8aF3hnxb5CodCg/svyxL8kbWdXo7Okb
         T5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SE1PBWc7mAk6yXDwwX3HHPm6R0g9oeMCDvjQB1FSRU4=;
        b=e0viJytF0T6mSPTT1crLea6N6az1SYLAqNhdgJQy5aHQoI03Qz/CXbCjl9d3umydI+
         A++OjyRBqVfQntUq/RMem9INfPI5yIf0T0sUUsNHy+dY81BGLtXT8+Wcs1N/T5I/HcTW
         LUejnVhALokHJbCmwSHKCi7NgyusJ+nTjRRlz31mBmYTB4ggwjiwaKeK26FQjAUgXSsc
         +Bw8BiG0MLDSF0U3c29T6EjNVN0hZjfijs3crn6HgTwWVkQilXR95DElMVAipEfXZeT/
         QTgOEfZKULlA1AAMI50ZTS23Dt2AbuueDy/Dvu5iMU9+HX2zTP0JErbT2pc+C0IfuSf0
         CXbw==
X-Gm-Message-State: AOAM5332GULUrua8If5IzuthfURaIcLG+SKy+UL3xqtsutkwGIVtfAZQ
	GNg3vihtsDKvwN1AfNpddusc414Y9l3waFucHlEOsg==
X-Google-Smtp-Source: ABdhPJzZwGSABeBQxV85uUQDyE877kBWKar9nuSTal+efpWConcEcwK48D/jgozGf+NtNUk6MXi23elgGDtpJtSZv9s=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
 l6-20020a056a0016c6b029032de1909dd0mr20235683pfc.70.1629475593581; Fri, 20
 Aug 2021 09:06:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 09:06:22 -0700
Message-ID: <CAPcyv4gVpK2US=-FhZYccKN-9sVa9WC4k5TD+WNH0bBkjwhE2w@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 2/9] dax: Introduce holder for dax_device
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    superblock of this filesystem.
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
>  drivers/dax/super.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 17 +++++++++++++++++
>  2 files changed, 63 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 5fa6ae9dbc8b..00c32dfa5665 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -214,6 +214,8 @@ enum dax_device_flags {
>   * @cdev: optional character interface for "device dax"
>   * @host: optional name for lookups where the device path is not available
>   * @private: dax driver private data
> + * @holder_rwsem: prevent unregistration while holder_ops is in progress
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
>   * @flags: state and boolean properties
>   */
>  struct dax_device {
> @@ -222,8 +224,11 @@ struct dax_device {
>         struct cdev cdev;
>         const char *host;
>         void *private;
> +       struct rw_semaphore holder_rwsem;

Given the rarity of notification failures and the infrequency of
registration events I think it would be ok for this to be a global
lock rather than per-device. In fact there is already a global dax
lock, see dax_read_lock(). Let's convert that from srcu to rwsem and
add a dax_write_lock().

> +       void *holder_data;
>         unsigned long flags;
>         const struct dax_operations *ops;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static ssize_t write_cache_show(struct device *dev,
> @@ -373,6 +378,25 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +                             size_t size, void *data)
> +{
> +       int rc;
> +
> +       if (!dax_dev)
> +               return -ENXIO;

There also needs to be a dax_dev->alive check, which is only valid to
be checked under dax_read_lock().

Who would ever pass NULL to this function?

> +
> +       if (!dax_dev->holder_data)
> +               return -EOPNOTSUPP;
> +
> +       down_read(&dax_dev->holder_rwsem);
> +       rc = dax_dev->holder_ops->notify_failure(dax_dev, offset,
> +                                                        size, data);
> +       up_read(&dax_dev->holder_rwsem);



> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -603,6 +627,7 @@ struct dax_device *alloc_dax(void *private, const char *__host,
>         dax_add_host(dax_dev, host);
>         dax_dev->ops = ops;
>         dax_dev->private = private;
> +       init_rwsem(&dax_dev->holder_rwsem);
>         if (flags & DAXDEV_F_SYNC)
>                 set_dax_synchronous(dax_dev);
>
> @@ -624,6 +649,27 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_dev)

Same questions about NULL dax dev and ->alive checking.

> +               return;
> +       down_write(&dax_dev->holder_rwsem);
> +       dax_dev->holder_data = holder;
> +       dax_dev->holder_ops = ops;
> +       up_write(&dax_dev->holder_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(dax_set_holder);
> +
> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_dev)
> +               return NULL;

Where is this API used? This result is not valid unless the caller is
holding the read lock.

> +
> +       return dax_dev->holder_data;
> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);
> +
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @host: alternate name for the device registered by a dax driver
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b52f084aa643..6f4b5c97ceb0 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -38,10 +38,17 @@ struct dax_operations {
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
>
> +struct dax_holder_operations {
> +       int (*notify_failure)(struct dax_device *, loff_t, size_t, void *);
> +};
> +
>  extern struct attribute_group dax_attribute_group;
>
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *dax_get_by_host(const char *host);
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops);
> +void *dax_get_holder(struct dax_device *dax_dev);
>  struct dax_device *alloc_dax(void *private, const char *host,
>                 const struct dax_operations *ops, unsigned long flags);
>  void put_dax(struct dax_device *dax_dev);
> @@ -77,6 +84,14 @@ static inline struct dax_device *dax_get_by_host(const char *host)
>  {
>         return NULL;
>  }
> +static inline void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +}
> +static inline void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       return NULL;
> +}
>  static inline struct dax_device *alloc_dax(void *private, const char *host,
>                 const struct dax_operations *ops, unsigned long flags)
>  {
> @@ -226,6 +241,8 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>                 size_t bytes, struct iov_iter *i);
>  int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>                         size_t nr_pages);
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +               size_t size, void *data);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
>
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> --
> 2.32.0
>
>
>

