Return-Path: <nvdimm+bounces-2414-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E90D48A03D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 10 Jan 2022 20:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7B8891C0939
	for <lists+linux-nvdimm@lfdr.de>; Mon, 10 Jan 2022 19:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765302CA4;
	Mon, 10 Jan 2022 19:35:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B66168
	for <nvdimm@lists.linux.dev>; Mon, 10 Jan 2022 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZFZ4QOFgcoyMCECZ3PkgL8BM+HFxPBx0EV0hU5cheCk=; b=kwTBNQ14Ajm4bb+p+yD8k57QkP
	ag8IoWMx+ZceNrBHQIAX1qjPtJFmAq9bB3a4JnH2JpRIvuJYBtpHdys8Jq/5cenklNvLq/gPB+1Sg
	2qgeP1b1J6H2Tv69ZZ1Dchmb2ZJjZjBKqVxc/SH3eNnBFhJ4iqYqyoAG6HKgY9R7CIH30swf1tj0Z
	Gu8uqqBGWzCL6jiU7/viwFyhvJ/itxVSedkUZDGnUhNOWzn5QaeMXBfrtSKRCMeY14yLf8X1p6aFJ
	T2ZJbBdfedchNNamYhhW0wNJ5GgzCiU5esGaF1uPdBB8x01ZyuwW4BYXYZcWtRvjnGo36PQEJY1Up
	7sxipnQg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n70RN-002fyD-DM; Mon, 10 Jan 2022 19:34:49 +0000
Date: Mon, 10 Jan 2022 19:34:49 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Phyr Starter
Message-ID: <YdyKWeU0HTv8m7wD@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

TLDR: I want to introduce a new data type:

struct phyr {
        phys_addr_t addr;
        size_t len;
};

and use it to replace bio_vec as well as using it to replace the array
of struct pages used by get_user_pages() and friends.

---

There are two distinct problems I want to address: doing I/O to memory
which does not have a struct page and efficiently doing I/O to large
blobs of physically contiguous memory, regardless of whether it has a
struct page.  There are some other improvements which I regard as minor.

There are many types of memory that one might want to do I/O to that do
not have a struct page, some examples:
 - Memory on a graphics card (or other PCI card, but gfx seems to be
   the primary provider of DRAM on the PCI bus today)
 - DAX, or other pmem (there are some fake pages today, but this is
   mostly a workaround for the IO problem today)
 - Guest memory being accessed from the hypervisor (KVM needs to
   create structpages to make this happen.  Xen doesn't ...)
All of these kinds of memories can be addressed by the CPU and so also
by a bus master.  That is, there is a physical address that the CPU
can use which will address this memory, and there is a way to convert
that to a DMA address which can be programmed into another device.
There's no intent here to support memory which can be accessed by a
complex scheme like writing an address to a control register and then
accessing the memory through a FIFO; this is for memory which can be
accessed by DMA and CPU loads and stores.

For get_user_pages() and friends, we currently fill an array of struct
pages, each one representing PAGE_SIZE bytes.  For an application that
is using 1GB hugepages, writing 2^18 entries is a significant overhead.
It also makes drivers hard to write as they have to recoalesce the
struct pages, even though the VM can tell it whether those 2^18 pages
are contiguous.

On the minor side, struct phyr can represent any mappable chunk of memory.
A bio_vec is limited to 2^32 bytes, while on 64-bit machines a phyr
can represent larger than 4GB.  A phyr is the same size as a bio_vec
on 64 bit (16 bytes), and the same size for 32-bit with PAE (12 bytes).
It is smaller for 32-bit machines without PAE (8 bytes instead of 12).

Finally, it may be possible to stop using scatterlist to describe the
input to the DMA-mapping operation.  We may be able to get struct
scatterlist down to just dma_address and dma_length, with chaining
handled through an enclosing struct.

I would like to see phyr replace bio_vec everywhere it's currently used.
I don't have time to do that work now because I'm busy with folios.
If someone else wants to take that on, I shall cheer from the sidelines.
What I do intend to do is:

 - Add an interface to gup.c to pin/unpin N phyrs
 - Add a sg_map_phyrs()
   This will take an array of phyrs and allocate an sg for them
 - Whatever else I need to do to make one RDMA driver happy with
   this scheme

At that point, I intend to stop and let others more familiar with this
area of the kernel continue the conversion of drivers.

P.S. If you've had the Prodigy song running through your head the whole
time you've been reading this email ... I'm sorry / You're welcome.
If people insist, we can rename this to phys_range or something boring,
but I quite like the spelling of phyr with the pronunciation of "fire".

