Return-Path: <nvdimm+bounces-2430-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBA048B586
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jan 2022 19:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 345E41C0AD9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jan 2022 18:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A6B2CA5;
	Tue, 11 Jan 2022 18:16:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2402CA1
	for <nvdimm@lists.linux.dev>; Tue, 11 Jan 2022 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
	Message-ID:From:References:Cc:To:content-disposition;
	bh=oBrXEHfI6xABrUDZXcl3Ilv2Mnj53ZcLvhEcAszQLhw=; b=YeL6mnl38ypaS0PyULw3luqlUK
	XeOI6Vhp947TOTlkyofoaX8wJ8Yg8h3TI1VDxJKcJ9GY5xcvig0mIQbG1QAzJj7OFJGoGht0Yb0/K
	tCS0dg0IMDzl/EH2fKYSqUf/gOewi+o5KmBNzaa7MfqcqWht6q8GI3xD9GYemVOCBS6mmJTuSF8wp
	PWzBOz3P0o1s2U3pEYwYMqlbrob3xzb0MD0zndcqZ4+3aWrBorD50RGouaf0fv20oDTgMxWvUpoMU
	2sXHLWkZGVSk79v0DlRL8om4AbtqKRlS5Om4EuhSURfLs+YKil2RSAe8S2cXFLA5uF5y1ZXO38jnC
	TupA0NOA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <logang@deltatee.com>)
	id 1n7Kzp-009ip7-HL; Tue, 11 Jan 2022 10:31:46 -0700
To: John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Joao Martins <joao.m.martins@oracle.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
 nvdimm@lists.linux.dev
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <305b0b3b-e5d1-3dc2-a4a3-01c05dda6748@deltatee.com>
Date: Tue, 11 Jan 2022 10:31:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: nvdimm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-block@vger.kernel.org, ming.lei@redhat.com, joao.m.martins@oracle.com, jgg@nvidia.com, hch@lst.de, linux-kernel@vger.kernel.org, willy@infradead.org, jhubbard@nvidia.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: Phyr Starter
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2022-01-11 1:17 a.m., John Hubbard wrote:
> On 1/10/22 11:34, Matthew Wilcox wrote:
>> TLDR: I want to introduce a new data type:
>>
>> struct phyr {
>>          phys_addr_t addr;
>>          size_t len;
>> };
>>
>> and use it to replace bio_vec as well as using it to replace the array
>> of struct pages used by get_user_pages() and friends.
>>
>> ---
> 
> This would certainly solve quite a few problems at once. Very compelling.

I agree.

> Zooming in on the pinning aspect for a moment: last time I attempted to
> convert O_DIRECT callers from gup to pup, I recall wanting very much to
> record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
> or some non-FOLL_PIN method. Because at the end of the IO, it is not
> easy to disentangle which pages require put_page() and which require
> unpin_user_page*().
> 
> And changing the bio_vec for *that* purpose was not really acceptable.
> 
> But now that you're looking to change it in a big way (and with some
> spare bits avaiable...oohh!), maybe I can go that direction after all.
> 
> Or, are you looking at a design in which any phyr is implicitly FOLL_PIN'd
> if it exists at all?

I'd also second being able to store a handful of flags in each phyr. My
userspace P2PDMA patchset needs to add a flag to each sgl to indicate
whether it was mapped as a bus address or not (which would be necessary
for the DMA mapped side dma_map_phyr).

Though, it's not immediately obvious where to put the flags without
increasing the size of the structure :(

Logan

