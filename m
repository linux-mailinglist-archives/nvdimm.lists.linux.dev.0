Return-Path: <nvdimm+bounces-3030-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF8E4B7A86
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Feb 2022 23:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id B11CC3E0585
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Feb 2022 22:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D8E1847;
	Tue, 15 Feb 2022 22:38:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FA61360
	for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 22:38:18 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id i21so474851pfd.13
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 14:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=83N6jbrz7Nk3njK8ABDKRljMA2AS3yoeVqMaJxkbwE4=;
        b=NZcAstJ9fEDIrozklG+RC9EQnCGd5vnNAmljBzFj7Frwp93akfK3W5JC/0w/lZ18dD
         MYqN+YgMBuM/nKcjfD2aeojlmtsQHT2+Be4zWWUs2s6SZLdqRp6AVGU1oryJJeClc7Kt
         XtHnfx8AOWkte0H2aoUZtq0u17D5yDLE3VhNbvYCHpY7QmFnYpsfRHTkw9EV1u+7l2yC
         JmubuJ1AB28ViO/8hEO0kHPsixIW9HU4iwOXN+/f6B4W4+9OHIHZcRTrv/eeN/Z6zSwS
         WAIwsOTjCBT/cguKvVlDE+i1V2yXum0gE9hA8+qaxza2iGH1wIlB8bXWrlVlVNHdSIRX
         k7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=83N6jbrz7Nk3njK8ABDKRljMA2AS3yoeVqMaJxkbwE4=;
        b=yZ2XEdJL2wIOkoOzLvQHtfYOSNEDzarXIBw8NVtrQKEt3mA1fcGIZQFe2KxxFCZf96
         c5jKi9Z9EtzAqdS2T9DeTdRjDEz23W/KI0PbvZIvN02MTR/uPDhrX4mznbJUo2jozd0I
         MZenoZGHvH6DYBkzWokgS0IcdcbDCSlTvrqITH6WEH38MDb8xHRqmmUZypPpGwCIPmhm
         IvDFcWPforDv2tp5aJN5du5E2Ra2MA82I4Nks3VNNCyKUzZGOxJICkETOWRGpcrExJZh
         aT+FndVJmhfKE1n0mi1rFP/ErswZlcouRu72uEdDXyBmrlkXnNN42ass24FWXFa/zPf1
         CJFg==
X-Gm-Message-State: AOAM530LLD5FAnhWSnCHYL2E8ZmoUZnCYKSZtxR85or5g/3Ya4neTAJK
	fj1lkRouxfR/VUt82y89isMFiVr8XLG0EVHqijkJdw==
X-Google-Smtp-Source: ABdhPJwyiOHriZYIH+JGn4mCV9FeAMpy8ae1cYWDts5xxcI1rDCUtkY8xoI1fwtyNIRCDQmS/O9n6n/LNqhqdjINLRE=
X-Received: by 2002:a05:6a00:8ca:b0:4e0:2ed3:5630 with SMTP id
 s10-20020a056a0008ca00b004e02ed35630mr30392pfu.3.1644964697734; Tue, 15 Feb
 2022 14:38:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-4-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-4-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 14:38:11 -0800
Message-ID: <CAPcyv4i0FSjfd1vYFBj6DMq4dG36JPzvuUFw3yjJweNqsHNNPw@mail.gmail.com>
Subject: Re: [PATCH v10 3/9] pagemap,pmem: Introduce ->memory_failure()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.
>
> With dax_holder notify support, we are able to notify the memory failure
> from pmem driver to upper layers.  If there is something not support in
> the notify routine, memory_failure will fall back to the generic hanlder.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvdimm/pmem.c    | 16 ++++++++++++++++
>  include/linux/memremap.h | 12 ++++++++++++
>  mm/memory-failure.c      | 14 ++++++++++++++
>  3 files changed, 42 insertions(+)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 58d95242a836..0a6e8698d086 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -366,6 +366,20 @@ static void pmem_release_disk(void *__pmem)
>         blk_cleanup_disk(pmem->disk);
>  }
>
> +static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +               unsigned long pfn, u64 len, int mf_flags)
> +{
> +       struct pmem_device *pmem =
> +                       container_of(pgmap, struct pmem_device, pgmap);
> +       u64 offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
> +
> +       return dax_holder_notify_failure(pmem->dax_dev, offset, len, mf_flags);
> +}
> +
> +static const struct dev_pagemap_ops fsdax_pagemap_ops = {
> +       .memory_failure         = pmem_pagemap_memory_failure,
> +};
> +
>  static int pmem_attach_disk(struct device *dev,
>                 struct nd_namespace_common *ndns)
>  {
> @@ -427,6 +441,7 @@ static int pmem_attach_disk(struct device *dev,
>         pmem->pfn_flags = PFN_DEV;
>         if (is_nd_pfn(dev)) {
>                 pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
> +               pmem->pgmap.ops = &fsdax_pagemap_ops;
>                 addr = devm_memremap_pages(dev, &pmem->pgmap);
>                 pfn_sb = nd_pfn->pfn_sb;
>                 pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
> @@ -440,6 +455,7 @@ static int pmem_attach_disk(struct device *dev,
>                 pmem->pgmap.range.end = res->end;
>                 pmem->pgmap.nr_range = 1;
>                 pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
> +               pmem->pgmap.ops = &fsdax_pagemap_ops;
>                 addr = devm_memremap_pages(dev, &pmem->pgmap);
>                 pmem->pfn_flags |= PFN_MAP;
>                 bb_range = pmem->pgmap.range;
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 1fafcc38acba..f739318b496f 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -77,6 +77,18 @@ struct dev_pagemap_ops {
>          * the page back to a CPU accessible page.
>          */
>         vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> +
> +       /*
> +        * Handle the memory failure happens on a range of pfns.  Notify the
> +        * processes who are using these pfns, and try to recover the data on
> +        * them if necessary.  The mf_flags is finally passed to the recover
> +        * function through the whole notify routine.
> +        *
> +        * When this is not implemented, or it returns -EOPNOTSUPP, the caller
> +        * will fall back to a common handler called mf_generic_kill_procs().
> +        */
> +       int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> +                             u64 len, int mf_flags);

I think it is odd to have the start address be in terms of pfns and
the length by in terms of bytes. I would either change @len to
@nr_pages, or change @pfn to @phys and make it a phys_addr_t.

Otherwise you can add,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

