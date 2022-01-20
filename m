Return-Path: <nvdimm+bounces-2513-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A4C494FA4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 14:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 274671C09A9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 13:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2A82CAB;
	Thu, 20 Jan 2022 13:56:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAAE2C82
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 13:56:06 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8957B68BEB; Thu, 20 Jan 2022 14:56:02 +0100 (CET)
Date: Thu, 20 Jan 2022 14:56:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120135602.GA11223@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111004126.GJ2328285@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 10, 2022 at 08:41:26PM -0400, Jason Gunthorpe wrote:
> > Finally, it may be possible to stop using scatterlist to describe the
> > input to the DMA-mapping operation.  We may be able to get struct
> > scatterlist down to just dma_address and dma_length, with chaining
> > handled through an enclosing struct.
> 
> Can you talk about this some more? IMHO one of the key properties of
> the scatterlist is that it can hold huge amounts of pages without
> having to do any kind of special allocation due to the chaining.
> 
> The same will be true of the phyr idea right?

No special allocations as in no vmalloc?  The chaining still has to
allocate memory using a mempool.

Anyway, to explain my idea which is very similar but not identical to
the one willy has:

 - on the input side to dma mapping the bio_vecs (or phyrs) are chained
   as bios or whatever the containing structure is.  These already exist
   and have infrastructure at least in the block layer
 - on the output side I plan for two options:

	1) we have a sane IOMMU and everyting will be coalesced into a
	   single dma_range.  This requires setting the block layer
	   merge boundary to match the IOMMU page size, but that is
	   a very good thing to do anyway.
	2) we have no IOMMU (or a weird one) and get one output dma_range
	   per input bio_vec.  We'd eithe have to support chaining or use
	   vmalloc or huge numbers of entries.

> If you limit to that scenario then we can be more optimal because
> things like byte granular offsets and size in the interior pages don't
> need to exist. Every interior chunk is always aligned to its order and
> we only need to record the order.

The block layer does not small offsets.  Direct I/O can often be
512 byte aligned, and some other passthrough commands can have even
smaller alignment, although I don't think we ever go below 4-byte
alignment anywhere in the block layer.

> IMHO storage density here is quite important, we end up having to keep
> this stuff around for a long time.

If we play these tricks it won't be general purpose enough to get rid
of the existing scatterlist usage.

