Return-Path: <nvdimm+bounces-5932-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 841DA6E5154
	for <lists+linux-nvdimm@lfdr.de>; Mon, 17 Apr 2023 22:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D0681C20926
	for <lists+linux-nvdimm@lfdr.de>; Mon, 17 Apr 2023 19:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7788BF8;
	Mon, 17 Apr 2023 19:59:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294548BEB
	for <nvdimm@lists.linux.dev>; Mon, 17 Apr 2023 19:59:50 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id v9so32292626pjk.0
        for <nvdimm@lists.linux.dev>; Mon, 17 Apr 2023 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1681761589; x=1684353589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=phtw730Z1oAu+dFt847+KyYIBXIePeo4uDtmDchStzE=;
        b=TLAsAz+hMtLXec8QY1C2WsIM8VDQFspPSCbSJMVu2rVYwOiLU0KvEWfDP4CBBRw0gr
         bRNo3KJJUZXtUeIGlqCJV9TzBl7pYcte95+yWVoc6nsxtbJ5WsSUAsm38oyb/FeU8AgF
         GHTYs3NDb0JhHvKai/TwBNa8k6eM1TqUOUif+ey0ZcIVh5FuyHrjG3Ahilh8ydsBvXOd
         76jmncwIUT93XLkUZQiwDBd/srfa6iivy309KkBSxa/5Cu0g077Fa5JEzajp5BBomjSp
         7LCqynGuLGlQydI7UVc9Zz+TwuFTQsxmN7MI5y28/6i1OumMtCeXp8nrtFR+0UlK2HgH
         Rbtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681761589; x=1684353589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phtw730Z1oAu+dFt847+KyYIBXIePeo4uDtmDchStzE=;
        b=N6pBN06N+Jo5tkIU8UHBaKmBhoPFuNXAxNPBB4i9ECCXyWzatY1H88yBR9gmHZN4dl
         W7KdWaQnGuzZnTueVF2gCHXoAlPVX7SlCXqjkCx7aa4lApFdWjXHtNHDKj5jtk96EuRm
         I0D0Sc7bAm1dtW/OAmTniAZNS7QrToB2BALgPOo0hPtegpJJpD8n3w7GiZJ7rnl2aUaS
         khCF+xmVVIBuUqADE25Z7bx9bB+KxXSwiiihphOctMSpX2qjgo08wzMIyygy9rz4sYli
         hf/RAMesglAwKoSj3BWVYEhnX1g2yAjQfO1zTN+sd52mUeileHKTdZUK9H6FFCokW43I
         9Uyw==
X-Gm-Message-State: AAQBX9eeiGmpX5usSVOGroS72ZW87HjcjnpVXlUpj7YS7kY84r9MMM9C
	G/kHKnSaFpwdjxmyMzfRyZO/cw==
X-Google-Smtp-Source: AKy350ZOIVs0PXqCX3v2o9m6GdrpUCcVieJDD3O0SmT6MDiPWIyFGHmWHgQbBGKGTvc5v1eLblXv7w==
X-Received: by 2002:a17:902:ce10:b0:1a6:cb66:681f with SMTP id k16-20020a170902ce1000b001a6cb66681fmr74865plg.46.1681761589427;
        Mon, 17 Apr 2023 12:59:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id q24-20020a170902b11800b0019e8915b1b5sm8037811plr.105.2023.04.17.12.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:59:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1poV0s-00BlVY-9h;
	Mon, 17 Apr 2023 16:59:46 -0300
Date: Mon, 17 Apr 2023 16:59:46 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: linux-mm@kvack.org
Cc: lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev, "T.J. Mercier" <tjmercier@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <ZD2lMvprVxu23BXZ@ziepe.ca>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <CABdmKX3kJZKsOQSi=4+RE8D3AF=-823B9WV11sC4WH67hjzqSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdmKX3kJZKsOQSi=4+RE8D3AF=-823B9WV11sC4WH67hjzqSQ@mail.gmail.com>

On Tue, Feb 28, 2023 at 12:59:41PM -0800, T.J. Mercier wrote:
> On Sat, Jan 21, 2023 at 7:03 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > I would like to have a session at LSF to talk about Matthew's
> > physr discussion starter:
> >
> >  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> >
> > I have become interested in this with some immediacy because of
> > IOMMUFD and this other discussion with Christoph:
> >
> >  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
> >
> > Which results in, more or less, we have no way to do P2P DMA
> > operations without struct page - and from the RDMA side solving this
> > well at the DMA API means advancing at least some part of the physr
> > idea.

[..]

I got fairly far along this and had to put it aside for some other
tasks, but here is what I came up with so far:

https://github.com/jgunthorpe/linux/commits/rlist

      PCI/P2PDMA: Do not store bus_off in the pci_p2pdma_map_state
      PCI/P2PDMA: Split out the information about the providing device from pgmap
      PCI/P2PDMA: Move the DMA API helpers to p2pdma_provider
      lib/rlist: Introduce range list
      lib/rlist: Introduce rlist cpu range iterator
      PCI/P2PDMA: Store the p2pdma_provider structs in an xarray
      lib/rlist: Introduce rlist_dma
      dma: Add DMA direct support for rlist mapping
      dma: Generic rlist dma_map_ops
      dma: Add DMA API support for mapping a rlist_cpu to a rlist_dma
      iommu/dma: Implement native rlist dma_map_ops
      dma: Use generic_dma.*_rlist in simple dma_map_ops implementations
      dma: Use generic_dma.*_rlist when map_sg just does map_page for n=1
      dma: Use generic_dma.*_rlist when iommu_area_alloc() is used
      dma/dummy: Add rlist
      s390/dma: Use generic_dma.*_rlist
      mm/gup: Create a wrapper for pin_user_pages to return a rlist
      dmabuf: WIP DMABUF exports the backing memory through rcpu
      RDMA/mlx5: Use rdma_umem_for_each_dma_block()
      RMDA/mlx: Use rdma_umem_for_each_dma_block() instead of sg_dma_address
      RDMA/mlx5: Use the length of the MR not the umem
      RDMA/umem: Add ib_umem_length() instead of open coding
      RDMA: Add IB DMA API wrappers for rlist
      RDMA: Switch ib_umem to rlist
      cover-letter: RFC Create an alternative to scatterlist in the DMA API

It is huge and scary. It is not quite nice enough to post but should
be an interesting starting point for LSF/MM. At least it broadly shows
all the touching required and why this is such a nasty problem.

The draft cover letter explaining what the series does:

    cover-letter: RFC Create an alternative to scatterlist in the DMA API
    
    This was kicked off by Matthew with his phyr idea from this thread:
    
    https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
    
    Hwoevr, I have become interested in this with some immediacy because of
    IOMMUFD and this other discussion with Christoph:
    
    https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
    
    Which results in, more or less, we have no way to do P2P DMA operations
    without struct page. This becomes complicated when we touch RDMA which
    highly relies on scatterlist for its internal implementations, so being
    unable to use scatterlist to store only dma_addr_t's means RDMA needs a
    complete scatterlist replacement that can.
    
    So - my objective is to enable to DMA API to "DMA map" something that is
    not a scatterlist, may or may not contain struct pages, but can still
    contain P2P DMA physical addresses. With this tool, transform the RDMA
    subystem to use the new DMA API and then go into DMABUF and stop creating
    scatterlists without any CPU pages. From that point we could implement
    DMABUF in VFIO (as above) and use the DMABUF to feed the MMIO pages into
    IOMMUFD to restore the PCI P2P support in VMs withotu creating the
    follow_pte security problem that VFIO has.
    
    After going through the thread again, and making some sketches, I've come
    up with this suggestion as a path forward, explored very roughly in this
    RFC:
    
    1) Create something I've called a 'range list CPU iterator'. This is an
       API that abstractly iterates over CPU physical memory ranges. It
       has useful helpers to iterate over things in 'struct page/folio *',
       physical ranges, copy to/from, and so on
    
       It has the necessary extra bits beyond the physr sketch to support P2P
       in the DMA API based on what was done for the pgmap based stuff. ie we
       need to know the provider of the non-struct page memory to get the
       struct device to compute the p2p distance and compute the pci_offset.
    
       The immediate idea is this is an iterator, not a data structure. So it
       can iterate over different kinds of storage. This frees us from having
       to immediatly consolidate all the different storage schemes in the
       kernel and lets that work happen over time.
    
       I imagine we would want to have this work with struct page * (for GUP)
       and bio_vec (for storage/net) and something else for the "kitchen sink"
       with DMABUF/etc. We may also want to allow it to wrapper scatterlist to
       provide for a more gradual code migration.
    
       Things are organized so sometime in the future this could collapse down
       into something that is not a multi-storage iterator, but perhaps just
       a single storage type that everyone is happy with.
    
       In the mean time we can use the API to progress all the other related
       infrastructure.
    
       Fundamentally this tries to avoid the scatterlist mistake of leaking
       too much of the storage implementation detail to the user.
    
    2) Create a general storage called the "range list". This is intended to
       be a general catch-all like scatterlist is, and it is optimized
       towards page list users, so it is quite good for what RDMA wants.
    
    3) Create a "range list DMA iterator" which is the dma_addr_t version of
       #1. This needs to have all the goodies to break up the ranges into
       things HW would like, such as page lists, or restricted scatter/gather
       records.
    
       I've been able to draft several optimizations in the DMA mapping path
       that should help offset some of the CPU cost of the more abstracted
       iterators:
    
           - DMA direct can directly re-use the CPU list with no iteration or
             memory allocation.
    
           - The IOMMU path can do only one iteration by pre-recording if the
             CPU list was all page aligned when it was created
    
    The following patches go deeper into my thinking, present fairly complete
    drafts of what things could look like, and more broadly explores the whole
    idea.
    
    At the end of the series we have
     - rlist, rlist_cpu, rlist_dma implementations
     - An rlist implementation for every dma_map_ops
     - Good rlist implementations for DMA direct and dma-iommu.c
     - A pin_user_pages() wrapper
     - RDMA umem converted and compiling with some RDMA drivers
     - Compile tested only :)
    
    It is a huge amount of work, I'd like to get a sense of what people think
    before going more deepely into a more final tested implementation. I know
    this is not quite what Matthew and Christoph have talked about.

