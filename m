Return-Path: <nvdimm+bounces-3789-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B205211B5
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 May 2022 12:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FC1A280A71
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 May 2022 10:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0983223DB;
	Tue, 10 May 2022 10:06:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BDF23C2
	for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 10:06:16 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AI0P84K4R1JlNNlB1ZT4xcQxRtODGchMFZxGqfqr?=
 =?us-ascii?q?LsXjdYENS3mBVzjFNUGuHM6yNN2qnct93a9/l8x5U6JDTy4Q3TAY5pCpnJ55og?=
 =?us-ascii?q?ZCbXIzGdC8cHM8zwvXrFRsht4NHAjX5BJhcokT0+1H9YtANkVEmjfvSHuCkUba?=
 =?us-ascii?q?dUsxMbVQMpBkJ2EsLd9ER0tYAbeiRW2thiPuqyyHtEAbNNw1cbgr435m+RCZH5?=
 =?us-ascii?q?5wejt+3UmsWPpintHeG/5Uc4Ql2yauZdxMUSaEMdgK2qnqq8V23wo/Z109F5tK?=
 =?us-ascii?q?NmbC9fFAIQ6LJIE6FjX8+t6qK20AE/3JtlP1gcqd0hUR/0l1lm/hr1dxLro32R?=
 =?us-ascii?q?wEyIoXCheYcTwJFVSp5OMWq/ZeeeyTm65DIlxaun3zEhq8G4FsNFYER5Od7KW9?=
 =?us-ascii?q?U8vkfMjoMclaIgOfe6La6TOxtj8MjIeHrIYoAt3AmxjbcZd4mSpDrQqPE/9ZU0?=
 =?us-ascii?q?T48wMdUEp72eMsdbStHbRLOeRRDN14bTpUkk4+AinD5NT8et1ORoas+5nP7zQp?=
 =?us-ascii?q?t3byrO93QEvSGR9pSmEmwpW/c+Wn9RBYAO7S3zTuD72Lpg+rnnj3yU4FUE6e3n?=
 =?us-ascii?q?tZsnlGSw2k7DBwNSUD9pfi/l174V99BQ2QS8y0/pO4y81aqQcT2XxyQpnOP+BU?=
 =?us-ascii?q?bXrJ4EeQ85UeGyrf85ByQDWwJCDVGbbQOrsAxQTA1x1mhhM7yCHpjvdW9TXOb6?=
 =?us-ascii?q?6fRoyi+NDYYKUccaiIeCwgI+d/upMc0lB2nZtJiFrOly974Azf9xxiUoyUkwbY?=
 =?us-ascii?q?el8gG0+O851+vqzatoIXZCx47/S3JUW+/qAB0foioY8qv81ezxehBNoGxXFSHv?=
 =?us-ascii?q?WZCn8mY8fBICouC0jGOKNjhtpnBC+2taWWa2AAwWcJ6sWnFxpJqRqgIiBkWGau?=
 =?us-ascii?q?jGp9slefVXXLu?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AAk0ILqEPzin0AFePpLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124124303"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 10 May 2022 18:06:09 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 107D44D16FFC;
	Tue, 10 May 2022 18:06:04 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 10 May 2022 18:06:03 +0800
Received: from [192.168.22.28] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 10 May 2022 18:06:02 +0800
Message-ID: <696970ff-6a35-831a-da82-bba7975628c7@fujitsu.com>
Date: Tue, 10 May 2022 18:06:03 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 06/07] xfs: support CoW in fsdax mode
To: Christoph Hellwig <hch@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>,
	<dan.j.williams@intel.com>, <david@fromorbit.com>, <jane.chu@oracle.com>,
	<rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>, <willy@infradead.org>,
	<naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220508143620.1775214-14-ruansy.fnst@fujitsu.com>
 <Ynn8BnZclNoEuzvv@infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <Ynn8BnZclNoEuzvv@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 107D44D16FFC.A5333
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/5/10 13:45, Christoph Hellwig 写道:
>> +#ifdef CONFIG_FS_DAX
>> +int
>> +xfs_dax_fault(
>> +	struct vm_fault		*vmf,
>> +	enum page_entry_size	pe_size,
>> +	bool			write_fault,
>> +	pfn_t			*pfn)
>> +{
>> +	return dax_iomap_fault(vmf, pe_size, pfn, NULL,
>> +			(write_fault && !vmf->cow_page) ?
>> +				&xfs_dax_write_iomap_ops :
>> +				&xfs_read_iomap_ops);
>> +}
>> +#endif
> 
> Is there any reason this is in xfs_iomap.c and not xfs_file.c?

Yes, It's better to put it in xfs_file.c since it's the only caller.  I 
didn't notice it...


--
Thanks,
Ruan.

> 
> Otherwise the patch looks good:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>



