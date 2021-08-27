Return-Path: <nvdimm+bounces-1041-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4CE3F92D7
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 05:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0A29E3E10E1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 03:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD532FB3;
	Fri, 27 Aug 2021 03:22:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4104C3FC1
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 03:22:31 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AdJlzS6DX1wrl1s/lHemQ55DYdb4zR+YMi2TD?=
 =?us-ascii?q?tnoBLSC9F/b0qynAppomPGDP4gr5NEtApTniAtjkfZq/z+8X3WB5B97LMzUO01?=
 =?us-ascii?q?HYTr2Kg7GD/xTQXwX69sN4kZxrarVCDrTLZmRSvILX5xaZHr8brOW6zA=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,355,1620662400"; 
   d="scan'208";a="113546519"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Aug 2021 11:22:23 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 821B24D0D4BA;
	Fri, 27 Aug 2021 11:22:23 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 11:22:24 +0800
Received: from [192.168.22.65] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 27 Aug 2021 11:22:22 +0800
Subject: Re: [PATCH v7 3/8] fsdax: Replace mmap entry in case of CoW
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs
	<linux-xfs@vger.kernel.org>, david <david@fromorbit.com>, linux-fsdevel
	<linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Ritesh Harjani <riteshh@linux.ibm.com>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-4-ruansy.fnst@fujitsu.com>
 <CAPcyv4iOSxoy-qGfAd3i4uzwfDX0t1xTmyM0pNd+-euVMDUwrQ@mail.gmail.com>
 <20210823125715.GA15536@lst.de>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <d4f07aef-ad9f-7de9-c112-a40e2022b399@fujitsu.com>
Date: Fri, 27 Aug 2021 11:22:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210823125715.GA15536@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-yoursite-MailScanner-ID: 821B24D0D4BA.AF7AB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



On 2021/8/23 20:57, Christoph Hellwig wrote:
> On Thu, Aug 19, 2021 at 03:54:01PM -0700, Dan Williams wrote:
>>
>> static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
>>                                const struct iomap_iter *iter, void
>> *entry, pfn_t pfn,
>>                                unsigned long flags)
>>
>>
>>>   {
>>> +       struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>>>          void *new_entry = dax_make_entry(pfn, flags);
>>> +       bool dirty = insert_flags & DAX_IF_DIRTY;
>>> +       bool cow = insert_flags & DAX_IF_COW;
>>
>> ...and then calculate these flags from the source data. I'm just
>> reacting to "yet more flags".
> 
> Except for the overly long line above that seems like a good idea.
> The iomap_iter didn't exist for most of the time this patch has been
> around.
> 

So should I reuse the iter->flags to pass the insert_flags? (left shift 
it to higher bits)

--
Thanks,
Ruan.



