Return-Path: <nvdimm+bounces-744-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA1B3E2228
	for <lists+linux-nvdimm@lfdr.de>; Fri,  6 Aug 2021 05:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 648533E115F
	for <lists+linux-nvdimm@lfdr.de>; Fri,  6 Aug 2021 03:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6777F2FAE;
	Fri,  6 Aug 2021 03:21:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F46470
	for <nvdimm@lists.linux.dev>; Fri,  6 Aug 2021 03:21:01 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AYYFE2KH4/Yw8RE4tpLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.84,299,1620662400"; 
   d="scan'208";a="112483857"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Aug 2021 11:20:52 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 6ED5B4D0D4A5;
	Fri,  6 Aug 2021 11:20:47 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 6 Aug 2021 11:20:47 +0800
Received: from [192.168.122.212] (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 6 Aug 2021 11:20:47 +0800
Subject: Re: RDMA/rpma + fsdax(ext4) was broken since 36f30e486d
To: Jason Gunthorpe <jgg@ziepe.ca>, <nvdimm@lists.linux.dev>
CC: Yishai Hadas <yishaih@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?=
	<yangx.jy@fujitsu.com>
References: <8b2514bb-1d4b-48bb-a666-85e6804fbac0@cn.fujitsu.com>
 <68169bc5-075f-8260-eedc-80fdf4b0accd@cn.fujitsu.com>
 <20210806014559.GM543798@ziepe.ca>
From: =?UTF-8?B?TGksIFpoaWppYW4v5p2OIOaZuuWdmg==?= <lizhijian@cn.fujitsu.com>
Message-ID: <b5e6c4cd-8842-59ef-c089-2802057f3202@cn.fujitsu.com>
Date: Fri, 6 Aug 2021 11:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210806014559.GM543798@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 6ED5B4D0D4A5.AD4A0
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No

Hi Jason

thank you for your advice.

CCing nvdimm

both ext4 and xfs are impacted.

Thanks


at 2021/8/6 9:45, Jason Gunthorpe wrote:
> On Wed, Aug 04, 2021 at 04:06:53PM +0800, Li, Zhijian/李 智坚 wrote:
>> convert to text and send again
>>
>> 2021/8/4 15:55, Li, Zhijian wrote:
>>> Hey all:
>>>
>>> Recently, i reported a issue to rpmahttps://github.com/pmem/rpma/issues/1142
>>> where we found that the native rpma + fsdax example failed in recent kernel.
>>>
>>> Below is the bisect log
>>>
>>> [lizhijian@yl linux]$ git bisect log
>>> git bisect start
>>> # good: [bbf5c979011a099af5dc76498918ed7df445635b] Linux 5.9
>>> git bisect good bbf5c979011a099af5dc76498918ed7df445635b
>>> # bad: [2c85ebc57b3e1817b6ce1a6b703928e113a90442] Linux 5.10
>>> git bisect bad 2c85ebc57b3e1817b6ce1a6b703928e113a90442
>>> # good: [4d0e9df5e43dba52d38b251e3b909df8fa1110be] lib, uaccess: add failure injection to usercopy functions
>>> git bisect good 4d0e9df5e43dba52d38b251e3b909df8fa1110be
>>> # bad: [6694875ef8045cdb1e6712ee9b68fe08763507d8] ext4: indicate that fast_commit is available via /sys/fs/ext4/feature/...
>>> git bisect bad 6694875ef8045cdb1e6712ee9b68fe08763507d8
>>> # good: [14c914fcb515c424177bb6848cc2858ebfe717a8] Merge tag 'wireless-drivers-next-2020-10-02' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
>>> git bisect good 14c914fcb515c424177bb6848cc2858ebfe717a8
>>> # good: [6f78b9acf04fbf9ede7f4265e7282f9fb39d2c8c] Merge tag 'mtd/for-5.10' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux
>>> git bisect good 6f78b9acf04fbf9ede7f4265e7282f9fb39d2c8c
>>> # bad: [bbe85027ce8019c73ab99ad1c2603e2dcd1afa49] Merge tag 'xfs-5.10-merge-5' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
>>> git bisect bad bbe85027ce8019c73ab99ad1c2603e2dcd1afa49
>>> # bad: [9d9af1007bc08971953ae915d88dc9bb21344b53] Merge tag 'perf-tools-for-v5.10-2020-10-15' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
>>> git bisect bad 9d9af1007bc08971953ae915d88dc9bb21344b53
>>> # good: [21c2fe94abb2abe894e6aabe6b4e84a255c8d339] RDMA/mthca: Combine special QP struct with mthca QP
>>> git bisect good 21c2fe94abb2abe894e6aabe6b4e84a255c8d339
>>> # good: [dbaa1b3d9afba3c050d365245a36616ae3f425a7] Merge branch 'perf/urgent' into perf/core
>>> git bisect good dbaa1b3d9afba3c050d365245a36616ae3f425a7
>>> # bad: [c7a198c700763ac89abbb166378f546aeb9afb33] RDMA/ucma: Fix use after free in destroy id flow
>>> git bisect bad c7a198c700763ac89abbb166378f546aeb9afb33
>>> # bad: [5ce2dced8e95e76ff7439863a118a053a7fc6f91] RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces
>>> git bisect bad 5ce2dced8e95e76ff7439863a118a053a7fc6f91
>>> # bad: [a03bfc37d59de316436c46f5691c5a972ed57c82] RDMA/mlx5: Sync device with CPU pages upon ODP MR registration
>>> git bisect bad a03bfc37d59de316436c46f5691c5a972ed57c82
>>> # good: [a6f0b08dbaf289c3c57284e16ac8043140f2139b] RDMA/core: Remove ucontext->closing
>>> git bisect good a6f0b08dbaf289c3c57284e16ac8043140f2139b
>>> # bad: [36f30e486dce22345c2dd3a3ba439c12cd67f6ba] IB/core: Improve ODP to use hmm_range_fault()
>>> git bisect bad 36f30e486dce22345c2dd3a3ba439c12cd67f6ba
>>> # good: [2ee9bf346fbfd1dad0933b9eb3a4c2c0979b633e] RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()
>>> git bisect good 2ee9bf346fbfd1dad0933b9eb3a4c2c0979b633e
>>> # first bad commit: [36f30e486dce22345c2dd3a3ba439c12cd67f6ba] IB/core: Improve ODP to use hmm_range_fault()
> This is perhaps not so surprising, but I think you should report it to
> the dax people that hmm_range_fault and dax don't work together..
>
> Though I think it is supposed to, and I'm surprised it doesn't.
>
> Jason
>
>



