Return-Path: <nvdimm+bounces-3037-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5BA44B7D09
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Feb 2022 03:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id B9AC71C0A79
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Feb 2022 02:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879971F22;
	Wed, 16 Feb 2022 02:09:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7CD1844
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 02:09:53 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id om7so1131203pjb.5
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 18:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+Ju8G+K3yl0rXewZnv2N1IC9X1msq/8ymspEttmFB0=;
        b=g0pX+9paDLIsFTJvf2Iwxzc5R+2Rg/M68J6vnIomnLZCJeTgykYN4I9DF6JoQ/58EO
         ewBbo66r7K5E9FQVu8/isDoqbnf054RXWsWWuL1Jrm/fckkK3fQ2euKN7xMyWXRR/y89
         1vp+hdgXJvlZLsQ159STnVV/30QoM8mBNMZWL8PsuXrmif2YeiPdoF2nqr12WWN/6D0T
         ZAN8Cy7+m55QT6oqbw7RZXcXjb/34BhJ00YPvdKeXsSkJ3yh95N1Oiz8LdcD7g6gGtUw
         uSBzOBGFL+ngPatwlg3p7PuELehciDFJqC12bD0Dym4214TAZAxI7z8RBhTFsuVU/0Ur
         riOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+Ju8G+K3yl0rXewZnv2N1IC9X1msq/8ymspEttmFB0=;
        b=5nPyzssVcu94xKwA8sIZIPaQP8VBm681D0KJGSkPgfY/awCiUiwznwNLPInywAFL2G
         U8WnGZ3QbKTeTZzNDdkOPcGqB/IgusCS5fVqR+QIA0uBESnsT2hvOR8Mpk16ceylBhVg
         OukhcsXs1DDX9yW6KtSDiCL7w9gyRL5AjATvZd1rIyo8KWS7jUaqYQMwMn1w2KPWqncm
         JNuTmOEIGwetqOxFymlEtxpVZsR+XiYAgfEfRmLXAx9ueyje54rVkXnwhFq6J39hjPew
         n1K2PbmjwITmWXkmrADWSfA7ZEWnSDqq2gD8fXuf/K5mrbnotRjEwNCZSW6DEsr0gZ8C
         BZhA==
X-Gm-Message-State: AOAM530lV/51oCcRrWMqUJLDu0NEClxZo93vKCualjUxhGWHTKxCOCcM
	hc6ycnVl2Sh6Zefh0d09l0S+JhKesjYsk0/BC+UJLA==
X-Google-Smtp-Source: ABdhPJzwdMTmGWhsFANakVNZUZj8nYKdCXXxIPTTkPPPKXTQeyH+SCUT7kQ22lBy9f4SZLC2Pj2zCo5Yn5N8CSG4WY0=
X-Received: by 2002:a17:90b:1a92:b0:1b9:8094:446b with SMTP id
 ng18-20020a17090b1a9200b001b98094446bmr357580pjb.93.1644977392787; Tue, 15
 Feb 2022 18:09:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-10-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-10-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 18:09:46 -0800
Message-ID: <CAPcyv4iTO55BX+_v2yHRBjSppPgT23JsHg-Oagb6RwHMj-W+Ug@mail.gmail.com>
Subject: Re: [PATCH v10 9/9] fsdax: set a CoW flag when associate reflink mappings
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Introduce a PAGE_MAPPING_DAX_COW flag to support association with CoW file
> mappings.  In this case, the dax-RMAP already takes the responsibility
> to look up for shared files by given dax page.  The page->mapping is no
> longer to used for rmap but for marking that this dax page is shared.
> And to make sure disassociation works fine, we use page->index as
> refcount, and clear page->mapping to the initial state when page->index
> is decreased to 0.
>
> With the help of this new flag, it is able to distinguish normal case
> and CoW case, and keep the warning in normal case.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c                   | 65 ++++++++++++++++++++++++++++++++------
>  include/linux/page-flags.h |  6 ++++
>  2 files changed, 62 insertions(+), 9 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 250794a5b789..88879c579c1f 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -334,13 +334,46 @@ static unsigned long dax_end_pfn(void *entry)
>         for (pfn = dax_to_pfn(entry); \
>                         pfn < dax_end_pfn(entry); pfn++)
>
> +static inline void dax_mapping_set_cow_flag(struct address_space *mapping)
> +{
> +       mapping = (struct address_space *)PAGE_MAPPING_DAX_COW;
> +}
> +
> +static inline bool dax_mapping_is_cow(struct address_space *mapping)
> +{
> +       return (unsigned long)mapping == PAGE_MAPPING_DAX_COW;
> +}
> +
>  /*
> - * TODO: for reflink+dax we need a way to associate a single page with
> - * multiple address_space instances at different linear_page_index()
> - * offsets.
> + * Set or Update the page->mapping with FS_DAX_MAPPING_COW flag.
> + * Return true if it is an Update.
> + */
> +static inline bool dax_mapping_set_cow(struct page *page)
> +{
> +       if (page->mapping) {
> +               /* flag already set */
> +               if (dax_mapping_is_cow(page->mapping))
> +                       return false;
> +
> +               /*
> +                * This page has been mapped even before it is shared, just
> +                * need to set this FS_DAX_MAPPING_COW flag.
> +                */
> +               dax_mapping_set_cow_flag(page->mapping);
> +               return true;
> +       }
> +       /* Newly associate CoW mapping */
> +       dax_mapping_set_cow_flag(page->mapping);
> +       return false;
> +}
> +
> +/*
> + * When it is called in dax_insert_entry(), the cow flag will indicate that
> + * whether this entry is shared by multiple files.  If so, set the page->mapping
> + * to be FS_DAX_MAPPING_COW, and use page->index as refcount.
>   */
>  static void dax_associate_entry(void *entry, struct address_space *mapping,
> -               struct vm_area_struct *vma, unsigned long address)
> +               struct vm_area_struct *vma, unsigned long address, bool cow)
>  {
>         unsigned long size = dax_entry_size(entry), pfn, index;
>         int i = 0;
> @@ -352,9 +385,17 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>         for_each_mapped_pfn(entry, pfn) {
>                 struct page *page = pfn_to_page(pfn);
>
> -               WARN_ON_ONCE(page->mapping);
> -               page->mapping = mapping;
> -               page->index = index + i++;
> +               if (cow) {
> +                       if (dax_mapping_set_cow(page)) {
> +                               /* Was normal, now updated to CoW */
> +                               page->index = 2;
> +                       } else
> +                               page->index++;
> +               } else {
> +                       WARN_ON_ONCE(page->mapping);
> +                       page->mapping = mapping;
> +                       page->index = index + i++;
> +               }
>         }
>  }
>
> @@ -370,7 +411,12 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>                 struct page *page = pfn_to_page(pfn);
>
>                 WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> -               WARN_ON_ONCE(page->mapping && page->mapping != mapping);
> +               if (!dax_mapping_is_cow(page->mapping)) {
> +                       /* keep the CoW flag if this page is still shared */
> +                       if (page->index-- > 0)
> +                               continue;
> +               } else
> +                       WARN_ON_ONCE(page->mapping && page->mapping != mapping);
>                 page->mapping = NULL;
>                 page->index = 0;
>         }
> @@ -810,7 +856,8 @@ static void *dax_insert_entry(struct xa_state *xas,
>                 void *old;
>
>                 dax_disassociate_entry(entry, mapping, false);
> -               dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
> +               dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
> +                               false);

Where is the caller that passes 'true'? Also when that caller arrives
introduce a separate dax_associate_cow_entry() as that's easier to
read than dax_associate_entry(..., true) in case someone does not
remember what that boolean flag means.

However, it's not clear to me that this approach is a good idea given
that the filesystem is the source of truth for how many address_spaces
this page mapping might be duplicated. What about a iomap_page_ops for
fsdax to ask the filesystem when it is ok to clear the mapping
association for a page?

>                 /*
>                  * Only swap our new entry into the page cache if the current
>                  * entry is a zero page or an empty entry.  If a normal PTE or
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 1c3b6e5c8bfd..6370d279795a 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -572,6 +572,12 @@ __PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
>  #define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
>  #define PAGE_MAPPING_FLAGS     (PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
>
> +/*
> + * Different with flags above, this flag is used only for fsdax mode.  It
> + * indicates that this page->mapping is now under reflink case.
> + */
> +#define PAGE_MAPPING_DAX_COW   0x1
> +
>  static __always_inline int PageMappingFlags(struct page *page)
>  {
>         return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
> --
> 2.34.1
>
>
>

