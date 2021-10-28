Return-Path: <nvdimm+bounces-1723-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA3E43D8A0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 Oct 2021 03:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 9B3AE3E0F76
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 Oct 2021 01:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A4D2C96;
	Thu, 28 Oct 2021 01:33:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7C2C83
	for <nvdimm@lists.linux.dev>; Thu, 28 Oct 2021 01:33:10 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so6649800pjl.2
        for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 18:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pAiaBNCk1xnEBH3C9EMpKzrgqAPJnlmXDrtIiJ0dt1I=;
        b=pAV9PI3uqSjbwl4ehA+e1fD0AmJsR9RObZKjbvBijn3hthsC3BOWhi8AwEhKayTbAn
         +kULxKOjbDPkdJvduTRaYnTinwRQ3sTGC3RmXxOu+ZBFQAZP2dCfU0u+xx+MyQD5sCXu
         juQ8/OlFDYxVdxNYORCgy1YjcIYTJ/VbxjTb7UxVpCGr1z8kM8Yws8W6G4x0NWwc6hyB
         NrmNiLX5o2T12KN42PUJoRgcExOicwbK7jy2OCO7u+1RAggFonc1ris6SaZqTakBedPe
         +KiIfancYaA+JSRyfWPQcobeLcn00lylDFmKvFb7FlRzM0bgeIYcMRtTDSe9GGiatzrv
         LAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pAiaBNCk1xnEBH3C9EMpKzrgqAPJnlmXDrtIiJ0dt1I=;
        b=SSmpV6NrbXJA0HWDlbDSQqKVhnGeO3UcaY883M3pfpQ7eiqBUGffjLHg8EUKNE6cv1
         d59pflIadjY9Um0h7KMrUUUfzSW8qIBsyGaYykDhfZbdB3oIRyMAl7LIz26p8iuA5GLG
         1CbpXz82kPg+hS8ISJhRw6CDgsAUGPbp7xRE23EWlecrTafCDIvFmHoPtYG+pgpjnrVU
         6yE+0xOqpFEsdqGpzG8jXNgXq3blsAsvFXf0M8WWBXJEbLTleUblW8NGkeWj1FXrZf9U
         g2JR03DmwjWjqxI3DwajhXp67KVkyr5h3LgF4Psq8GoJBBN4yjsOeBG8z+VavvzHpAXl
         4ibA==
X-Gm-Message-State: AOAM531s2vF/791tAXabhauuuy+K9udnwTaq9cF/J20Kr+IHWFGCRUnz
	AzRSEZs5FBMHnu84eTRxTHamPyjA6zwoLd875cMCNA==
X-Google-Smtp-Source: ABdhPJxm6eCpHzum4moJkAnlQxDuj0JlmT3Vix8IBxxMECN3GUzGEt1VHXlaU6FsHMYZFBw/KnWLJLzVXyU36Brr9pk=
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr1221700pjb.93.1635384790364;
 Wed, 27 Oct 2021 18:33:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-9-hch@lst.de>
In-Reply-To: <20211018044054.1779424-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 18:32:58 -0700
Message-ID: <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] dm-linear: add a linear_dax_pgoff helper
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>, device-mapper development <dm-devel@redhat.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-erofs@lists.ozlabs.org, linux-ext4 <linux-ext4@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.

Looks good.

Mike, ack?

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-linear.c | 49 +++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 32fbab11bf90c..bf03f73fd0f36 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -164,63 +164,44 @@ static int linear_iterate_devices(struct dm_target *ti,
>  }
>
>  #if IS_ENABLED(CONFIG_FS_DAX)
> +static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
> +{
> +       struct linear_c *lc = ti->private;
> +       sector_t sector = linear_map_sector(ti, *pgoff << PAGE_SECTORS_SHIFT);
> +
> +       *pgoff = (get_start_sect(lc->dev->bdev) + sector) >> PAGE_SECTORS_SHIFT;
> +       return lc->dev->dax_dev;
> +}
> +
>  static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>                 long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> -       long ret;
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -
> -       dev_sector = linear_map_sector(ti, sector);
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
> -       if (ret)
> -               return ret;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
>         return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>  }
>
>  static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       dev_sector = linear_map_sector(ti, sector);
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       dev_sector = linear_map_sector(ti, sector);
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>                                       size_t nr_pages)
>  {
> -       int ret;
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -
> -       dev_sector = linear_map_sector(ti, sector);
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages << PAGE_SHIFT, &pgoff);
> -       if (ret)
> -               return ret;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
>         return dax_zero_page_range(dax_dev, pgoff, nr_pages);
>  }
>
> --
> 2.30.2
>

