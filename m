Return-Path: <nvdimm+bounces-1545-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F8D42E1CD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Oct 2021 21:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 6FBC61C0F49
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Oct 2021 19:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E6A2C85;
	Thu, 14 Oct 2021 19:01:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894D472
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 19:01:25 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso5486002pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 12:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lxPCfnRN1pVZCKXw+dPxQ+TEoXLlYUHXoOMaDAY9JY=;
        b=znOijpGsqyIV/LrTXkLB2IgQNxqApgMz6qnz4fsbZ391wxVpJFRcuaopZfjROr+pE1
         6qlWaoSS5n4g9vKjm3ZnzUGXP47SF1hqpZX7k3lVBRBZffHAUn8q9KeJZnptR9LU0Nws
         FcIDkwvm3EfoOjxn89JWINzElALz8diSKGPAcoCv02CSzC9PuA93c61qJaEvtqPsIeMW
         1L2kRh4Q1ic+Lx9xkQgW4MP5RXHKFQW+Xh8IEzvokBgR4xee3GGKcf2A+kaxbfyv3vMT
         9JcCRz9bu1k6grqH4IWRQBtuGNNQsNG2wOGFmlch6YbW8A9GgheKvFxlHcNzACdtnAs3
         j4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lxPCfnRN1pVZCKXw+dPxQ+TEoXLlYUHXoOMaDAY9JY=;
        b=U/ygz7Pg+nDiJSMHC98sGj4YR2D//UZB3Wxl4JoWC7Pdud6rQKETbAnWMVFUNDjyYA
         4a88y0tpmIEanaKsHNZO/s21BPN6dA+thyxdDjb1byAGk60kQyh83ImrjHug21tugFQ+
         qF80e4CY+CCoQ4A3Fju7nSqfsRWqEv7rJbQB+ovfWNE/aWbprmTjemQzwb8VTR0Ctioz
         jVMX29IUbIHvldCEjtFp2qSnGYfnqTvl17qeCnTQvL4lTzm9XcliuNzfqkHHQAzyCyXY
         od7CrQtZnBU4OV5ATLqzKEAa+OD89g8xjuHuuR7Moq9GBi73ZbLXOmotXDqsegxbzOfR
         jJSw==
X-Gm-Message-State: AOAM530ZKgp/+EH05MfMOUEVDT8ysggVo19E23up3MxXtsN4+4IHcgGc
	uVmQyXSchpwzUkUgSV7i8n/XqlPZTpjiutk46aY6YA==
X-Google-Smtp-Source: ABdhPJxCgGkWzKHyVqrmEOVmd1w9TLUS+nlQWIxOo1mRfzxINIImPWmsFKQDhXF3LgH7DgfDwo2el8Sf5cWsxs7zCaw=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr6572559plo.4.1634238084797; Thu, 14 Oct
 2021 12:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211014153928.16805-1-alex.sierra@amd.com> <20211014153928.16805-3-alex.sierra@amd.com>
 <20211014170634.GV2744544@nvidia.com> <YWh6PL7nvh4DqXCI@casper.infradead.org>
In-Reply-To: <YWh6PL7nvh4DqXCI@casper.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 12:01:14 -0700
Message-ID: <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alex Sierra <alex.sierra@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, 
	Linux MM <linux-mm@kvack.org>, Ralph Campbell <rcampbell@nvidia.com>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Christoph Hellwig <hch@lst.de>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 14, 2021 at 11:45 AM Matthew Wilcox <willy@infradead.org> wrote:
>
>
> It would probably help if you cc'd Dan on this.

Thanks.

[..]
>
> On Thu, Oct 14, 2021 at 02:06:34PM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 14, 2021 at 10:39:28AM -0500, Alex Sierra wrote:
> > > From: Ralph Campbell <rcampbell@nvidia.com>
> > >
> > > ZONE_DEVICE struct pages have an extra reference count that complicates the
> > > code for put_page() and several places in the kernel that need to check the
> > > reference count to see that a page is not being used (gup, compaction,
> > > migration, etc.). Clean up the code so the reference count doesn't need to
> > > be treated specially for ZONE_DEVICE.
> > >
> > > Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> > > Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > > v2:
> > > AS: merged this patch in linux 5.11 version
> > >
> > > v5:
> > > AS: add condition at try_grab_page to check for the zone device type, while
> > > page ref counter is checked less/equal to zero. In case of device zone, pages
> > > ref counter are initialized to zero.
> > >
> > > v7:
> > > AS: fix condition at try_grab_page added at v5, is invalid. It supposed
> > > to fix xfstests/generic/413 test, however, there's a known issue on
> > > this test where DAX mapped area DIO to non-DAX expect to fail.
> > > https://patchwork.kernel.org/project/fstests/patch/1489463960-3579-1-git-send-email-xzhou@redhat.com
> > > This condition was removed after rebase over patch series
> > > https://lore.kernel.org/r/20210813044133.1536842-4-jhubbard@nvidia.com
> > > ---
> > >  arch/powerpc/kvm/book3s_hv_uvmem.c     |  2 +-
> > >  drivers/gpu/drm/nouveau/nouveau_dmem.c |  2 +-
> > >  fs/dax.c                               |  4 +-
> > >  include/linux/dax.h                    |  2 +-
> > >  include/linux/memremap.h               |  7 +--
> > >  include/linux/mm.h                     | 11 ----
> > >  lib/test_hmm.c                         |  2 +-
> > >  mm/internal.h                          |  8 +++
> > >  mm/memcontrol.c                        |  6 +--
> > >  mm/memremap.c                          | 69 +++++++-------------------
> > >  mm/migrate.c                           |  5 --
> > >  mm/page_alloc.c                        |  3 ++
> > >  mm/swap.c                              | 45 ++---------------
> > >  13 files changed, 46 insertions(+), 120 deletions(-)
> >
> > Has anyone tested this with FSDAX? Does get_user_pages() on fsdax
> > backed memory still work?
> >
> > What refcount value does the struct pages have when they are installed
> > in the PTEs? Remember a 0 refcount will make all the get_user_pages()
> > fail.
> >
> > I'm looking at the call path starting in ext4_punch_hole() and I would
> > expect to see something manipulating the page ref count before
> > the ext4_break_layouts() call path gets to the dax_page_unused() test.
> >
> > All I see is we go into unmap_mapping_pages() - that would normally
> > put back the page references held by PTEs but insert_pfn() has this:
> >
> >       if (pfn_t_devmap(pfn))
> >               entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
> >
> > And:
> >
> > static inline pte_t pte_mkdevmap(pte_t pte)
> > {
> >       return pte_set_flags(pte, _PAGE_SPECIAL|_PAGE_DEVMAP);
> > }
> >
> > Which interacts with vm_normal_page():
> >
> >               if (pte_devmap(pte))
> >                       return NULL;
> >
> > To disable that refcounting?
> >
> > So... I have a feeling this will have PTEs pointing to 0 refcount
> > pages? Unless FSDAX is !pte_devmap which is not the case, right?
> >
> > This seems further confirmed by this comment:
> >
> >       /*
> >        * If we race get_user_pages_fast() here either we'll see the
> >        * elevated page count in the iteration and wait, or
> >        * get_user_pages_fast() will see that the page it took a reference
> >        * against is no longer mapped in the page tables and bail to the
> >        * get_user_pages() slow path.  The slow path is protected by
> >        * pte_lock() and pmd_lock(). New references are not taken without
> >        * holding those locks, and unmap_mapping_pages() will not zero the
> >        * pte or pmd without holding the respective lock, so we are
> >        * guaranteed to either see new references or prevent new
> >        * references from being established.
> >        */
> >
> > Which seems to explain this scheme relies on unmap_mapping_pages() to
> > fence GUP_fast, not on GUP_fast observing 0 refcounts when it should
> > stop.
> >
> > This seems like it would be properly fixed by using normal page
> > refcounting for PTEs - ie stop using special for these pages?
> >
> > Does anyone know why devmap is pte_special anyhow?

It does not need to be special as mentioned here:

https://lore.kernel.org/all/CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com/

The refcount dependencies also go away after this...

https://lore.kernel.org/all/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com/

...but you can see that patches 1 and 2 in that series depend on being
able to guarantee that all mappings are invalidated when the undelying
device that owns the pgmap goes away.

For that to happen there needs to be communication back to the FS for
device-gone / failure events. That work is in progress via this
series:

https://lore.kernel.org/all/20210924130959.2695749-1-ruansy.fnst@fujitsu.com/

So there's a path to unwind this awkwardness, but it needs some
dominoes to fall first as far as I can see. My current focus is
getting Shiyang's series unblocked.

