Return-Path: <nvdimm+bounces-2521-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id E9450495399
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 18:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id CE5231C0964
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 17:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E79F2CAB;
	Thu, 20 Jan 2022 17:54:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC0E173
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 17:54:44 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F09FED1;
	Thu, 20 Jan 2022 09:54:37 -0800 (PST)
Received: from [10.57.68.26] (unknown [10.57.68.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0213C3F774;
	Thu, 20 Jan 2022 09:54:34 -0800 (PST)
Message-ID: <744d247c-bbb5-80aa-f774-c65791cb0766@arm.com>
Date: Thu, 20 Jan 2022 17:54:30 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Phyr Starter
Content-Language: en-GB
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: nvdimm@lists.linux.dev, linux-rdma@vger.kernel.org,
 John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, Jason Gunthorpe <jgg@nvidia.com>,
 netdev@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
 Logan Gunthorpe <logang@deltatee.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com> <20220120135602.GA11223@lst.de>
 <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
From: Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2022-01-20 15:27, Keith Busch wrote:
> On Thu, Jan 20, 2022 at 02:56:02PM +0100, Christoph Hellwig wrote:
>>   - on the input side to dma mapping the bio_vecs (or phyrs) are chained
>>     as bios or whatever the containing structure is.  These already exist
>>     and have infrastructure at least in the block layer
>>   - on the output side I plan for two options:
>>
>> 	1) we have a sane IOMMU and everyting will be coalesced into a
>> 	   single dma_range.  This requires setting the block layer
>> 	   merge boundary to match the IOMMU page size, but that is
>> 	   a very good thing to do anyway.
> 
> It doesn't look like IOMMU page sizes are exported, or even necessarily
> consistently sized on at least one arch (power).

FWIW POWER does its own thing separate from the IOMMU API. For all the 
regular IOMMU API players, page sizes are published in the iommu_domain 
that the common iommu-dma layer operates on. In fact it already uses 
them to pick chunk sizes for composing large buffer allocations.

Robin.

