Return-Path: <nvdimm+bounces-2449-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CE448BB2F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jan 2022 00:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 722963E0FA2
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jan 2022 23:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8512CAB;
	Tue, 11 Jan 2022 23:02:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52102C9D
	for <nvdimm@lists.linux.dev>; Tue, 11 Jan 2022 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
	Message-ID:From:References:Cc:To:content-disposition;
	bh=JGlaIoL3JiUKm69gr69makSNy4JbMH4jchaLUqVIQxs=; b=NM2fx5bsTE7zC6hwXw0Pgx4Buo
	YnfVscCdiluO/KndLwpHCA5V85udbr7MzWgEb1jg38WkJSJ8fL3OyoqyyqL4jqzpO8Pla/mmcgX9W
	VJ7W4VkXNJiQARYHA3wa32V1flSLWj92lPbrgdvrnpN3B7d/ng3u6q7Izch764pw8iqYH7LVLwavR
	9DYYHGpHiwJy0jdCORXgA+Mo7xeugu7AqTrSBASKABIReHfGXjUj6rWyn+3zZe7NXnGeToD2PVPbh
	9LKn87e0XzYUAwW/Ryxeab2v22Vg57Ssl+z8R3d88jdSx39zEXB+uAT7iAZZTtXcR3vfLHVYnyNhp
	88IglYGA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <logang@deltatee.com>)
	id 1n7QA9-009o9j-CV; Tue, 11 Jan 2022 16:02:46 -0700
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Joao Martins <joao.m.martins@oracle.com>,
 John Hubbard <jhubbard@nvidia.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
 nvdimm@lists.linux.dev
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com> <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com> <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com> <Yd311C45gpQ3LqaW@casper.infradead.org>
 <ef01ce7d-f1d3-0bbb-38ba-2de4d3f7e31a@deltatee.com>
 <20220111225713.GS2328285@nvidia.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ee523bd5-2818-269b-8b94-89106ad41767@deltatee.com>
Date: Tue, 11 Jan 2022 16:02:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220111225713.GS2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: nvdimm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-block@vger.kernel.org, ming.lei@redhat.com, jhubbard@nvidia.com, joao.m.martins@oracle.com, hch@lst.de, linux-kernel@vger.kernel.org, willy@infradead.org, jgg@nvidia.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: Phyr Starter
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2022-01-11 3:57 p.m., Jason Gunthorpe wrote:
> On Tue, Jan 11, 2022 at 03:09:13PM -0700, Logan Gunthorpe wrote:
> 
>> Either that, or we need a wrapper that allocates an appropriately
>> sized SGL to pass to any dma_map implementation that doesn't support
>> the new structures.
> 
> This is what I think we should do. If we start with RDMA then we can
> motivate the 4 main server IOMMU drivers to get updated ASAP, then it
> can acceptably start to spread to other users.

I suspect the preferred path forward is for the IOMMU drivers that don't
use dma-iommu should be converted to use it. Then anything we do to
dma-iommu will be applicable to the IOMMU drivers. Better than expecting
them to implement a bunch of new functionality themselves.

Logan

