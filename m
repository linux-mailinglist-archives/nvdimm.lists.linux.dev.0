Return-Path: <nvdimm+bounces-3659-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D9450A94C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 21:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 416DA2E0CE3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 19:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4AA23A9;
	Thu, 21 Apr 2022 19:35:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ADC23A0
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 19:35:25 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id j8so5960502pll.11
        for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 12:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVQ88PczBbGB51gqeQlAd30Ygrp0C37zg3POCPbMg9g=;
        b=uKrGMjq9p+eXG3Nd+kK5bCGIHmimCCqws2Qylgc430pv8VXh+pEHL+ugppqPLg4Tq/
         g/bDXUkCDp14IjgrO/SRkld7zAXjnb5AlamKlYWL1RbQR3VpQmuhSS8SLiyt5PpYwqPk
         CXMJDCd1ZIVEidgboV9ZS68uocN1c39/cN+z5tJtWJUHIgE36pE7O/R6gmUVlAThRWfA
         zOd+UZc5P2XNH5TYUDaL/Mpfi3ElCY825Ks06KzoFwYjNNHU0m93XuYLueAVFUMVtqJT
         QdDhGChlZGkjxTMhPM/FyAvitkrf4bzj6fQ/Kn0qqllOVGSZFUAKa+nFyXaeG8rvBRAx
         hKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVQ88PczBbGB51gqeQlAd30Ygrp0C37zg3POCPbMg9g=;
        b=d+LRGUaWN+zyGBl1wA6o29ydQo7dVPUrnhsaPRljlHIBsEel4Fs0g8QTutAwxmukj+
         7+g6UPvs+6Vvausu1fCH1fDVzg7lQqanaaKGhKeiBQNFZKXA+g8mwNJdhZFFpvNrN4bz
         mzqH9b118wolR1qhN7wwS06mO9V/Grk6vJFC6r/g+2bK5p1O1ysZRTGXe7AFgQO/aMJu
         5R8PdwvRQs+lk2zjAvSDnu9SRdg024rBlGgKFzjeHnjIHB1vTIPbelV1Cs3SqxDM0KGP
         czIdEix/oTeRTfOkSIuZGb/9xQA2Lz5fep7NA8uJlMCqxl7BaS6B0iX1Xsri25gffTbA
         8x8Q==
X-Gm-Message-State: AOAM5324QwqkUVTX7dI9R48YbKynkoGAC+V7l5JXAzcJVAaVVyAvk+dL
	PH21cJ7M5ZTI06hicbDFxz0seGNycDb/pOZrkhH/XQ==
X-Google-Smtp-Source: ABdhPJy25IQaDtq87Y+NzYExt1ge+2jbzd0XOqO1H/kIEJDYM27XWIrrUPts+iDIBNuP1HMq2AVdwDpEL8kvcflefsI=
X-Received: by 2002:a17:90b:1e0e:b0:1d2:8906:cffe with SMTP id
 pg14-20020a17090b1e0e00b001d28906cffemr1291688pjb.220.1650569724646; Thu, 21
 Apr 2022 12:35:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220420020435.90326-1-jane.chu@oracle.com> <20220420020435.90326-5-jane.chu@oracle.com>
In-Reply-To: <20220420020435.90326-5-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Apr 2022 12:35:13 -0700
Message-ID: <CAPcyv4jBUE9BTOrqVsFcBUZxzMx6ygax5FihrrccG2sET56Gjg@mail.gmail.com>
Subject: Re: [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax access mode
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 7:05 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Up till now, dax_direct_access() is used implicitly for normal
> access, but for the purpose of recovery write, dax range with
> poison is requested.  To make the interface clear, introduce
>         enum dax_access_mode {
>                 DAX_ACCESS,
>                 DAX_RECOVERY_WRITE,
>         }
> where DAX_ACCESS is used for normal dax access, and
> DAX_RECOVERY_WRITE is used for dax recovery write.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/dax/super.c             |  5 ++--
>  drivers/md/dm-linear.c          |  5 ++--
>  drivers/md/dm-log-writes.c      |  5 ++--
>  drivers/md/dm-stripe.c          |  5 ++--
>  drivers/md/dm-target.c          |  4 ++-
>  drivers/md/dm-writecache.c      |  7 +++---
>  drivers/md/dm.c                 |  5 ++--
>  drivers/nvdimm/pmem.c           | 44 +++++++++++++++++++++++++--------
>  drivers/nvdimm/pmem.h           |  5 +++-
>  drivers/s390/block/dcssblk.c    |  9 ++++---
>  fs/dax.c                        |  9 ++++---
>  fs/fuse/dax.c                   |  4 +--
>  include/linux/dax.h             |  9 +++++--
>  include/linux/device-mapper.h   |  4 ++-
>  tools/testing/nvdimm/pmem-dax.c |  3 ++-
>  15 files changed, 85 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 0211e6f7b47a..5405eb553430 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -117,6 +117,7 @@ enum dax_device_flags {
>   * @dax_dev: a dax_device instance representing the logical memory range
>   * @pgoff: offset in pages from the start of the device to translate
>   * @nr_pages: number of consecutive pages caller can handle relative to @pfn
> + * @mode: indicator on normal access or recovery write
>   * @kaddr: output parameter that returns a virtual address mapping of pfn
>   * @pfn: output parameter that returns an absolute pfn translation of @pgoff
>   *
> @@ -124,7 +125,7 @@ enum dax_device_flags {
>   * pages accessible at the device relative @pgoff.
>   */
>  long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
> -               void **kaddr, pfn_t *pfn)
> +               enum dax_access_mode mode, void **kaddr, pfn_t *pfn)
>  {
>         long avail;
>
> @@ -138,7 +139,7 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>                 return -EINVAL;
>
>         avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
> -                       kaddr, pfn);
> +                       mode, kaddr, pfn);
>         if (!avail)
>                 return -ERANGE;
>         return min(avail, nr_pages);
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 76b486e4d2be..13e263299c9c 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -172,11 +172,12 @@ static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>  }
>
>  static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
> -               long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)
>  {
>         struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
> +       return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
>  }
>
>  static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> index c9d036d6bb2e..06bdbed65eb1 100644
> --- a/drivers/md/dm-log-writes.c
> +++ b/drivers/md/dm-log-writes.c
> @@ -889,11 +889,12 @@ static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
>  }
>
>  static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
> -                                        long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)
>  {
>         struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
>
> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
> +       return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
>  }
>
>  static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index c81d331d1afe..77d72900e997 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -315,11 +315,12 @@ static struct dax_device *stripe_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>  }
>
>  static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
> -               long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)
>  {
>         struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
>
> -       return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
> +       return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
>  }
>
>  static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 64dd0b34fcf4..8cd5184e62f0 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -10,6 +10,7 @@
>  #include <linux/init.h>
>  #include <linux/kmod.h>
>  #include <linux/bio.h>
> +#include <linux/dax.h>
>
>  #define DM_MSG_PREFIX "target"
>
> @@ -142,7 +143,8 @@ static void io_err_release_clone_rq(struct request *clone,
>  }
>
>  static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
> -               long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)
>  {
>         return -EIO;
>  }
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 5630b470ba42..d74c5a7a0ab4 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -286,7 +286,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>
>         id = dax_read_lock();
>
> -       da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, &wc->memory_map, &pfn);
> +       da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, DAX_ACCESS,
> +                       &wc->memory_map, &pfn);
>         if (da < 0) {
>                 wc->memory_map = NULL;
>                 r = da;
> @@ -308,8 +309,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>                 i = 0;
>                 do {
>                         long daa;
> -                       daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i, p - i,
> -                                               NULL, &pfn);
> +                       daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i,
> +                                       p - i, DAX_ACCESS, NULL, &pfn);
>                         if (daa <= 0) {
>                                 r = daa ? daa : -EINVAL;
>                                 goto err3;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3c5fad7c4ee6..8258676a352f 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1093,7 +1093,8 @@ static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
>  }
>
>  static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> -                                long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)
>  {
>         struct mapped_device *md = dax_get_private(dax_dev);
>         sector_t sector = pgoff * PAGE_SECTORS;
> @@ -1111,7 +1112,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>         if (len < 1)
>                 goto out;
>         nr_pages = min(len, nr_pages);
> -       ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
> +       ret = ti->type->direct_access(ti, pgoff, nr_pages, mode, kaddr, pfn);
>
>   out:
>         dm_put_live_table(md, srcu_idx);
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 4aa17132a557..c77b7cf19639 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -239,24 +239,47 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>
>  /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
>  __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
> -               long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)
>  {
>         resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
> -
> -       if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -                                       PFN_PHYS(nr_pages))))
> -               return -EIO;
> +       sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
> +       unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
> +       struct badblocks *bb = &pmem->bb;
> +       sector_t first_bad;
> +       int num_bad;
>
>         if (kaddr)
>                 *kaddr = pmem->virt_addr + offset;
>         if (pfn)
>                 *pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
>
> +       if (bb->count &&
> +               badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
> +               long actual_nr;
> +
> +               if (mode != DAX_RECOVERY_WRITE)
> +                       return -EIO;
> +
> +               /*
> +                * Set the recovery stride is set to kernel page size because
> +                * the underlying driver and firmware clear poison functions
> +                * don't appear to handle large chunk(such as 2MiB) reliably.
> +                */
> +               actual_nr = PHYS_PFN(
> +                       PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
> +               dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
> +                               sector, nr_pages, first_bad, actual_nr);
> +               if (actual_nr)
> +                       return actual_nr;
> +               return 1;
> +       }
> +

Similar feedback as Christoph, lets keep this patch just to the simple
task of plumbing the @mode argument to dax_direct_access() and save
the logic changes for DAX_RECOVERY_WRITE to a later patch. The idea
being that in general you want to limit the blast radius of
regressions so that it simplifies reverts if necessary. If these logic
changes have a regression then reverting this patch also undoes all
the other innocent boilerplate plumbing.

