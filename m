Return-Path: <nvdimm+bounces-1632-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 31ED54329F9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Oct 2021 01:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2FA951C0F8A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Oct 2021 23:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F83A2C94;
	Mon, 18 Oct 2021 23:06:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D76072
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 23:06:17 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id r17so16725955qtx.10
        for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 16:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t13jy1xQQB0gmrT1NW6zHUJeUfFTnWrh5vLufzqGSOo=;
        b=fs+pNVjSp3t08y/Qek5U1K5zYFVoFGvNZNYlFKrOzb5uFIcN616uN4ceFhbswCQe7X
         GUI/334ZkDOCYAG+JpNB9RdhrVATD0hQUjfxnS5ctmLY2ZenBoqQuwH76SRvkXdP3cM+
         Qj0Fbzxqk/1FraNlERd968zbnq2JTCiCQ5CDO3Q9WlBmC+057YzLvNhj4/rxypVAcP6J
         rQjumGXPcmEExt0Lzf/PYTPfWRlJ1vp+BUyWiM8N59qwmvNjm9ZC55jAARqDBFWT2HWZ
         3jklaTYrhAgcwaVE5TpN3HHyWJ9JCIz/QYjAgjghO3lQCIQG8A268X/1sctoDSt10rLN
         uwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t13jy1xQQB0gmrT1NW6zHUJeUfFTnWrh5vLufzqGSOo=;
        b=Tp5fCULypLl4kqrcQ/+k80JZLd/KVNfxvWDqcDE3a3IUxM57XTDFMh/ktUaRrURyaW
         5ff1SaAqS1ockxP2Oyi8tOlrfnIIC4GzbwsZjBpne9LIm12mFMK/B06cef9Y+i8efOSB
         L+w2ZxtuD/pQtBYVouRa75hz40COVPbY0kaA7hLrJAFJLmAcH11lCxQnTJUlwrI8EcCS
         sO86KHt98QOaDP2f/0OY6M0eCc/dINV3MYe6ous6HGmlvW5+yhBVUGsLf+RoE50xfkaz
         cfnOzKO4tlJNh8aPDEiUbhmjgmP9hd1viROY4YPxhqNagCM8N3fydeKxmoGtpySeLo8x
         tSyg==
X-Gm-Message-State: AOAM5335iB/mmUe70QSEx5u7SsZVZbM8u6NFlP9ERqAkmsYeiLFpYsUg
	QPgscTjJu12cQdj6an+ZfU3iZg==
X-Google-Smtp-Source: ABdhPJwMWFSkjHgN749nnHNdzV4ycZUrAg1Cl3jWHBuFmRmB/uqZm1f8+nVTShmwK2hP+IrC5sCFZQ==
X-Received: by 2002:ac8:5755:: with SMTP id 21mr32075024qtx.353.1634598376340;
        Mon, 18 Oct 2021 16:06:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id e16sm6723324qkl.108.2021.10.18.16.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 16:06:15 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mcbhu-00GP5O-UW; Mon, 18 Oct 2021 20:06:14 -0300
Date: Mon, 18 Oct 2021 20:06:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Alex Sierra <alex.sierra@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kuehling, Felix" <Felix.Kuehling@amd.com>,
	Linux MM <linux-mm@kvack.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
	Christoph Hellwig <hch@lst.de>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
Message-ID: <20211018230614.GF3686969@ziepe.ca>
References: <20211014153928.16805-3-alex.sierra@amd.com>
 <20211014170634.GV2744544@nvidia.com>
 <YWh6PL7nvh4DqXCI@casper.infradead.org>
 <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
 <20211014230606.GZ2744544@nvidia.com>
 <CAPcyv4hC4qxbO46hp=XBpDaVbeh=qdY6TgvacXRprQ55Qwe-Dg@mail.gmail.com>
 <20211016154450.GJ2744544@nvidia.com>
 <CAPcyv4j0kHREAOG6_07E2foz6e4FP8D72mZXH6ivsiUBu_8c6g@mail.gmail.com>
 <20211018182559.GC3686969@ziepe.ca>
 <CAPcyv4jvZjeMcKLVuOEQ_gXRd87i3NUX5D=MmsJ++rWafnK-NQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jvZjeMcKLVuOEQ_gXRd87i3NUX5D=MmsJ++rWafnK-NQ@mail.gmail.com>

On Mon, Oct 18, 2021 at 12:37:30PM -0700, Dan Williams wrote:

> > device-dax uses PUD, along with TTM, they are the only places. I'm not
> > sure TTM is a real place though.
> 
> I was setting device-dax aside because it can use Joao's changes to
> get compound-page support.

Ideally, but that ideas in that patch series have been floating around
for a long time now..
 
> > As I understand things, something like FSDAX post-folio should
> > generate maximal compound pages for extents in the page cache that are
> > physically contiguous.
> >
> > A high order folio can be placed in any lower order in the page
> > tables, so we never have to fracture it, unless the underlying page
> > are moved around - which requires an unmap_mapping_range() cycle..
> 
> That would be useful to disconnect the compound-page size from the
> page-table-entry installed for the page. However, don't we need
> typical compound page fracturing in the near term until folios move
> ahead?

I do not know, just mindful not to get ahead of Matthew
 
> > > There are end users that would notice the PMD regression, and I think
> > > FSDAX PMDs with proper compound page metadata is on the same order of
> > > work as fixing the refcount.
> >
> > Hmm, I don't know.. I sketched out the refcount stuff and the code is
> > OK but ugly and will add a conditional to some THP cases
> 
> That reminds me that there are several places that do:
> 
> pmd_devmap(pmd) || pmd_trans_huge(pmd)

I haven't tried to look at this yet. I did check that the pte_devmap()
flag can be deleted, but this is more tricky.

We have pmd_huge(), pmd_large(), pmd_devmap(), pmd_trans_huge(),
pmd_leaf(), at least

and I couldn't tell you today the subtle differences between all of
these things on every arch :\

AFAIK there should only be three case:
 - pmd points to a pte table
 - pmd is in the special hugetlb format
 - pmd points at something described by struct page(s)

> ...for the common cases where a THP and DEVMAP page are equivalent,
> but there are a few places where those paths are not shared when the
> THP path expects that the page came from the page allocator. So while
> DEVMAP is not needed in GUP after this conversion, there still needs
> to be an audit of when THP needs to be careful of DAX mappings.

Yes, it is a tricky job to do the full work, but I think in the end,
'pmd points at something described by struct page(s)' is enough for
all code to use is_zone_device_page() instead of a PTE bit or VMA flag
to drive its logic.

> > Here I imagine the thing that creates the pgmap would specify the
> > policy it wants. In most cases the policy is tightly coupled to what
> > the free function in the the provided dev_pagemap_ops does..
> 
> The thing that creates the pgmap is the device-driver, and
> device-driver does not implement truncate or reclaim. It's not until
> the FS mounts that the pgmap needs to start enforcing pin lifetime
> guarantees.

I am explaining this wrong, the immediate need is really 'should
foll_longterm fail fast-gup to the slow path' and something like the
nvdimm driver can just set that to 1 and rely on VMA flags to control
what the slow path does - as is today.

It is not as elegant as more flags in the pgmap, but it would get the
job done with minimal fuss.

Might be nice to either rely fully on VMA flags or fully on pgmap
holder flags for FOLL_LONGTERM?

> > Anyhow, I'm wondering on a way forward. There are many balls in the
> > air, all linked:
> >  - Joao's compound page support for device_dax and more
> >  - Alex's DEVICE_COHERENT
> 
> I have not seen these patches.

It is where this series came from. As DEVICE_COHERENT is focused on
changing the migration code and, as I recall, the 1 == free thing
complicated that enough that Christoph requested it be cleaned.

> >  - The refcount normalization
> >  - Removing the pgmap test from GUP
> >  - Removing the need for the PUD/PMD/PTE special bit
> >  - Removing the need for the PUD/PMD/PTE devmap bit
> 
> It's not clear that this anything but pure cleanup once the special
> bit can be used for architectures that don't have devmap. Those same
> archs presumably don't care about the THP collisions with DAX.

I understood there was some community that was interested in DAX on
other arches that don't have the PTE bits to spare, so this would be
of interest to them?

> Completing the DAX reflink work is in my near term goals and that
> includes "shootdown for fsdax and removing the pgmap test from GUP",
> but probably not in the order that "refcount normalization" folks
> would prefer.

Indeed, I don't think that will help many of the stuck items on the
list move ahead.

Jason

