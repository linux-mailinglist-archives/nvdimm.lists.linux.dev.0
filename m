Return-Path: <nvdimm+bounces-1042-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95053F92DF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 05:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 60B441C0FDF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 03:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB052FB6;
	Fri, 27 Aug 2021 03:23:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECD22FAE
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 03:23:56 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AXPiOwq8oukES4tm1kO1uk+DkI+orL9Y04lQ7?=
 =?us-ascii?q?vn2ZKCYlFvBw8vrCoB1173HJYUkqMk3I9ergBEDiewK4yXcW2/hzAV7KZmCP11?=
 =?us-ascii?q?dAR7sSj7cKrQeBJwTOssZZ1YpFN5N1EcDMCzFB5vrS0U2VFMkBzbC8nJyVuQ?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,355,1620662400"; 
   d="scan'208";a="113546575"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Aug 2021 11:23:55 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 0A9C04D0D9CD;
	Fri, 27 Aug 2021 11:23:54 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 11:23:50 +0800
Received: from [192.168.22.65] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 27 Aug 2021 11:23:47 +0800
Subject: Re: [PATCH v7 4/8] fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
To: Dan Williams <dan.j.williams@intel.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>, Ritesh Harjani <riteshh@linux.ibm.com>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-5-ruansy.fnst@fujitsu.com>
 <CAPcyv4gFDyXqu5NyrWQ9Y_JqjLmCb8pWQgPZVBYE=dOir2KdzA@mail.gmail.com>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <6ac5dda5-9681-6b6f-7a84-55215578f0c3@fujitsu.com>
Date: Fri, 27 Aug 2021 11:23:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gFDyXqu5NyrWQ9Y_JqjLmCb8pWQgPZVBYE=dOir2KdzA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-yoursite-MailScanner-ID: 0A9C04D0D9CD.A4211
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



On 2021/8/20 10:39, Dan Williams wrote:
> On Sun, Aug 15, 2021 at 11:04 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>> Punch hole on a reflinked file needs dax_iomap_cow_copy() too.
>> Otherwise, data in not aligned area will be not correct.  So, add the
>> srcmap to dax_iomap_zero() and replace memset() as dax_iomap_cow_copy().
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/dax.c               | 25 +++++++++++++++----------
>>   fs/iomap/buffered-io.c |  4 ++--
>>   include/linux/dax.h    |  3 ++-
>>   3 files changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index e49ba68cc7e4..91ceb518f66a 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -1198,7 +1198,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>>   }
>>   #endif /* CONFIG_FS_DAX_PMD */
>>
>> -s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>> +s64 dax_iomap_zero(loff_t pos, u64 length, const struct iomap *iomap,
>> +               const struct iomap *srcmap)
>>   {
>>          sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
>>          pgoff_t pgoff;
>> @@ -1220,19 +1221,23 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>>
>>          if (page_aligned)
>>                  rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
>> -       else
>> +       else {
>>                  rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
>> -       if (rc < 0) {
>> -               dax_read_unlock(id);
>> -               return rc;
>> -       }
>> -
>> -       if (!page_aligned) {
>> -               memset(kaddr + offset, 0, size);
>> +               if (rc < 0)
>> +                       goto out;
>> +               if (iomap->addr != srcmap->addr) {
>> +                       rc = dax_iomap_cow_copy(pos, size, PAGE_SIZE, srcmap,
>> +                                               kaddr);
> 
> Apologies, I'm confused, why is it ok to skip zeroing here?
> 

That was a mistake.  Will be fixed in next version.


--
Thanks,
Ruan.



