Return-Path: <nvdimm+bounces-1599-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB87430B89
	for <lists+linux-nvdimm@lfdr.de>; Sun, 17 Oct 2021 20:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 3D8661C0F95
	for <lists+linux-nvdimm@lfdr.de>; Sun, 17 Oct 2021 18:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C882C83;
	Sun, 17 Oct 2021 18:35:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E092C85
	for <nvdimm@lists.linux.dev>; Sun, 17 Oct 2021 18:35:43 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id r2so13711165pgl.10
        for <nvdimm@lists.linux.dev>; Sun, 17 Oct 2021 11:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTrtVmXKl1vzKe1HSo0iCrTyx41Q80sb+HkeZuxUbms=;
        b=1gLtUPZrIll93Lk0DRWWAADIP7tBPsv0/oiYOGA0bFsBuRjeHRumkgSna9zJTneZUF
         3DSw4C1pqxk86MXEubQFxK6sLuu2ip8/omjM4E72LaAQywpQ7y9Cz8sENXd9n7mW3t3z
         6rTdt7sLIak5AkFlx8olY6NWV6x8777Ldqv2eWTYpIft3lHQk6jniiTBjQ+0xKlzpL17
         mDTOwU3RxVXgVCh5zCg5nl77kpch4MUQRq+0cYICimQUnu2bb/zJyJR1KDC6Uo7JFEYO
         cIzKBanykJKjnf+YWHWeKml1+/7Ato6hjP4gcjM3D7zw6NzCVAvX7HCQ75G/nsnxhP7p
         mmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTrtVmXKl1vzKe1HSo0iCrTyx41Q80sb+HkeZuxUbms=;
        b=g7IBK8yQJ5hX2jik75sb3TMLFYHzTGAnz2PWxBrrCf4Tb/pZZINExcY1VRV4j2bIYX
         m6vx1MJ8g2IcFyXRiuw1E3MMaI7Rn/ab5QteZNA/6BluUD4tnHUvb+TJevawfP+ln4Uk
         GXSGpmzRYDhIDWVCx8h8A+Q+Z+SlOn5Iw1IqjjUC3Jg4ImPIlNKtlCmzwvsMDXWttN2w
         SAQ2c7ED0qn0sVOQlyzI9OESTs4JbIYQeuZ9xKvH5WV5GdwctzRtuOjuz6CoWsizqYsE
         4ouYmIYeYzOd1rRvIfbA+eYEE24O9jjRQqovSSa4HNSPRw26yNXwIIsbqqrozOZQq3PF
         JN0Q==
X-Gm-Message-State: AOAM532EIC6Uk2quA7ZQVTrRgaNfUP/ZXFlYPQb/10GJrsfbn17+Dczh
	SW2tr4iAi5ognGiCB0cpqVOxH7r9XJudjhPhh4fflu7TuzA=
X-Google-Smtp-Source: ABdhPJwJM7+IqZd5nnQXXYL4Qb9udjK5XcqDYKSTkol29IdGjGnxP1SxcddyehIQsKSeVah5exCVcaqjhhHWy7v1hMQ=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr19210587pge.5.1634495743329;
 Sun, 17 Oct 2021 11:35:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211014153928.16805-1-alex.sierra@amd.com> <20211014153928.16805-3-alex.sierra@amd.com>
 <20211014170634.GV2744544@nvidia.com> <YWh6PL7nvh4DqXCI@casper.infradead.org>
 <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
 <20211014230606.GZ2744544@nvidia.com> <CAPcyv4hC4qxbO46hp=XBpDaVbeh=qdY6TgvacXRprQ55Qwe-Dg@mail.gmail.com>
 <20211016154450.GJ2744544@nvidia.com>
In-Reply-To: <20211016154450.GJ2744544@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Oct 2021 11:35:35 -0700
Message-ID: <CAPcyv4j0kHREAOG6_07E2foz6e4FP8D72mZXH6ivsiUBu_8c6g@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Alex Sierra <alex.sierra@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, 
	Linux MM <linux-mm@kvack.org>, Ralph Campbell <rcampbell@nvidia.com>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Christoph Hellwig <hch@lst.de>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 16, 2021 at 8:45 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Oct 14, 2021 at 06:37:35PM -0700, Dan Williams wrote:
> > On Thu, Oct 14, 2021 at 4:06 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Oct 14, 2021 at 12:01:14PM -0700, Dan Williams wrote:
> > > > > > Does anyone know why devmap is pte_special anyhow?
> > > >
> > > > It does not need to be special as mentioned here:
> > > >
> > > > https://lore.kernel.org/all/CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com/
> > >
> > > I added a remark there
> > >
> > > Not special means more to me, it means devmap should do the refcounts
> > > properly like normal memory pages.
> > >
> > > It means vm_normal_page should return !NULL and it means insert_page,
> > > not insert_pfn should be used to install them in the PTE. VMAs should
> > > not be MIXED MAP, but normal struct page maps.
> > >
> > > I think this change alone would fix all the refcount problems
> > > everwhere in DAX and devmap.
> > >
> > > > The refcount dependencies also go away after this...
> > > >
> > > > https://lore.kernel.org/all/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com/
> > > >
> > > > ...but you can see that patches 1 and 2 in that series depend on being
> > > > able to guarantee that all mappings are invalidated when the undelying
> > > > device that owns the pgmap goes away.
> > >
> > > If I have put everything together right this is because of what I
> > > pointed to here. FS-DAX is installing 0 refcount pages into PTEs and
> > > expecting that to work sanely.
> > >
> > > This means the page map cannot be removed until all the PTEs are fully
> > > flushed, which buggily doesn't happen because of the missing unplug.
> > >
> > > However, this is all because nobody incrd a refcount to represent the
> > > reference in the PTE and since this ment that 0 refcount pages were
> > > wrongly stuffed into PTEs then devmap used the refcount == 1 hack to
> > > unbreak GUP?
> > >
> > > So.. Is there some reason why devmap pages are trying so hard to avoid
> > > sane refcounting???
> >
> > I wouldn't put it that way. It's more that the original sin of
> > ZONE_DEVICE that sought to reuse the lru field space, by never having
> > a zero recount, then got layered upon and calcified in malignant ways.
> > In the meantime surrounding infrastructure got decrustified. Work like
> > the 'struct page' cleanup among other things, made it clearer and
> > clearer over time that the original design choice needed to be fixed.
>
> So, there used to be some reason, but with the current code
> arrangement it is not the case? This is why it looks so strange when
> reading it..
>
> AFIACT we are good on the LRU stuff now? Eg release_pages() does not
> use page->lru for is_zone_device_page()?

Yes, the lru collision was fixed by the 'struct page' cleanup.

>
> > The MIXED_MAP and insert_pfn were a holdover from page-less DAX, but
> > now that we have page-available DAX, yes, we can skip the FS
> > notification and just rely on typical refcounting and hanging until
> > the FS has a chance to uninstall the PTEs. You're right, the FS
> > notification is an improvement to the conversion, not a requirement.
>
> It all sounds so simple. I looked at this for a good long time and the
> first major roadblock is huge pages.
>
> The mm side is designed around THP which puts a single high order page
> into the PUD/PMD such that the mm only has to juggle one page. This a
> very sane and reasonable thing to do.
>
> DAX is stuffing arrays of 4k pages into the PUD/PMDs. Aligning with
> THP would make using normal refconting much simpler. I looked at
> teaching the mm core to deal with page arrays - it is certainly
> doable, but it is quite inefficient and ugly mm code.

THP does not support PUD, and neither does FSDAX, so it's only PMDs we
need to worry about.

>
> So, can we fix DAX and TTM - the only uses of PUD/PMDs I could find?
>
> Joao has a series that does this to device-dax:
>
> https://lore.kernel.org/all/20210827145819.16471-1-joao.m.martins@oracle.com/

That assumes there's never any need to fracture a huge page which
FSDAX could not support unless the filesystem was built with 2MB block
size.

> TTM is kind of broken already but does have a struct page, and it is
> probably already a high order one. Maybe it is OK? I will ask Thomas
>
> That leaves FSDAX. Can this be fixed? I know nothing of filesystems or
> fsdax to guess. Sounds like folios to me ..

My thought here is to assemble a compound page on the fly when
establishing the FSDAX PMD mapping.

> Assuming changing FSDAX is hard.. How would DAX people feel about just
> deleting the PUD/PMD support until it can be done with compound pages?

There are end users that would notice the PMD regression, and I think
FSDAX PMDs with proper compound page metadata is on the same order of
work as fixing the refcount.

> Doing so would allow fixing the lifecycle, cleaning up gup and
> basically delete a huge wack of slow DAX and devmap specific code from
> the mm. It also opens the door to removing the PTE flag and thus
> allowing DAX on more architectures.
>
> > However, there still needs to be something in the gup-fast path to
> > indicate that GUP_LONGTERM is not possible because the PTE
> > represents
>
> It looks easy now:
>
> 1) We know the pfn has a struct page * because it isn't pfn special
>
> 2) We can get a valid ref on the struct page *:
>
>       head = try_grab_compound_head(page, 1, flags);
>
>    Holding a ref ensures that head->pgmap is valid.
>
> 3) Then check the page type directly:
>
>      if ((flags & FOLL_LONGTERM) && is_zone_device_page(head))
>
>    This tells us we can access the ZONE_DEVICE struct in the union
>
> 4) Ask what the pgmap owner wants to do:
>
>     if (head->pgmap->deny_foll_longterm)
>           return FAIL

The pgmap itself does not know, but the "holder" could specify this
policy. Which is in line with the 'dax_holder_ops' concept being
introduced for reverse mapping support. I.e. when the FS claims the
dax-device it can specify at that point that it wants to forbid
longterm.

> Cost is only paied if FOLL_LONGTERM is given

Yeah, that does naturally fall out from no longer needing to take an
explicit dev_pagemap reference and assuming a page is always there.

