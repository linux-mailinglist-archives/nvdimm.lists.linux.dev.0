Return-Path: <nvdimm+bounces-2518-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id CE9F249516D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 16:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 85CD23E027B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 15:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5C92CA8;
	Thu, 20 Jan 2022 15:27:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9A2C80
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 15:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F58CC340E0;
	Thu, 20 Jan 2022 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1642692459;
	bh=Pw9woOKfBVJV94yKFOUNOSr0Qw3ODqyl0O2HtAePtz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pOKuNzyOrqoltMx1Os0/MBtmr/0Xb8E2I3GsmntkfouHLWh2rc+3eAmcf3brDY4+t
	 Fbmu+22jcLD8zPsoLRItEYBxaFP/LmFrM+ZNY+7Hu6v4pDwNmCdQmOBa84URMALXbP
	 t0P5+cQEQdYOBsE97ZNpat/tAti3jxnQ18Y+zs6Ym7qyCTeHef5hOeQzXZcVJInPwz
	 /GVflmj6mwk/B0emQh9mlNzIvE/iVZ0lh8yVxwGOrRE3cwmSIjCH0KPcw3OPiUydMC
	 Ey4aZayhMg8op0x5rg+6sjZW9YF+bJzBfJCR6vCSv/xPMKQ/4LpvFwVvlVpa42q4+2
	 EQV2Hzq9pBsJA==
Date: Thu, 20 Jan 2022 07:27:36 -0800
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <20220120135602.GA11223@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120135602.GA11223@lst.de>

On Thu, Jan 20, 2022 at 02:56:02PM +0100, Christoph Hellwig wrote:
>  - on the input side to dma mapping the bio_vecs (or phyrs) are chained
>    as bios or whatever the containing structure is.  These already exist
>    and have infrastructure at least in the block layer
>  - on the output side I plan for two options:
> 
> 	1) we have a sane IOMMU and everyting will be coalesced into a
> 	   single dma_range.  This requires setting the block layer
> 	   merge boundary to match the IOMMU page size, but that is
> 	   a very good thing to do anyway.

It doesn't look like IOMMU page sizes are exported, or even necessarily
consistently sized on at least one arch (power).

