Return-Path: <nvdimm+bounces-3410-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 575284EBF5C
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Mar 2022 12:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1C11B3E0F38
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Mar 2022 10:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F7B632;
	Wed, 30 Mar 2022 10:58:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366F27C
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 10:58:29 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AgNM4v69uJjWCds008lY+DrUD63+TJUtcMsCJ2f8?=
 =?us-ascii?q?bfWQNrUog1TAPymEXX2+EOv6PYjP9KNokaYqy8UwPvZHdzYIwTVdlrnsFo1Bi8?=
 =?us-ascii?q?5ScXYvDRqvT04J+FuWaFQQ/qZx2huDodKjYdVeB4Ef9WlTdhSMkj/vQHOKlULe?=
 =?us-ascii?q?s1h1ZHmeIdg9w0HqPpMZp2uaEsfDha++8kYuaT//3YTdJ6BYoWo4g0J9vnTs01?=
 =?us-ascii?q?BjEVJz0iXRlDRxDlAe2e3D4l/vzL4npR5fzatE88uJX24/+IL+FEmPxp3/BC/u?=
 =?us-ascii?q?ulPD1b08LXqXPewOJjxK6WYD72l4b+HN0if19aZLwam8O49mNt8pswdNWpNq+T?=
 =?us-ascii?q?xw1FqPRmuUBSAQeGCZ7VUFD0OadeiDu6JzNnyUqdFOpmZ2CFnoeMYQG++pfD3t?=
 =?us-ascii?q?J8PsCIjERKBuEgoqewLm7YuhqiN4qIMTiMMUYoH4I5T3QC7AkB4/CR6HL7NpD9?=
 =?us-ascii?q?DY2ms1KW/3ZYqIxZThwaxLPSx5CIFEaDNQ5hujArn3+dSBI7VeQjakp6mPQigt?=
 =?us-ascii?q?r39DFNsTZe9mPbcFUhVqD4GbH+XnpRB0XKrS3yzOD/zSnhvLnmjnyU4YfUra/8?=
 =?us-ascii?q?5ZChFyV23xWBgYaWEW2pdGnhUOkHdFSMUoZ/mwpt6da3EiqSMTtGh61uniJujY?=
 =?us-ascii?q?CVNdKVe438geAzuzT+QnxLmwFSCNRLcwor+coSjEwkFyEhdXkAXpoqrL9dJ433?=
 =?us-ascii?q?t94thvrYW5MczBEPnRCEGM4DxDYiNlbpnryohxLScZZVuHIJAw=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A7pXWoarUc0yRRXUzYrKOZWAaV5oUeYIsimQD?=
 =?us-ascii?q?101hICG9vPbo7vxG/c5rrSMc7Qx6ZJhOo6HkBEDtewK/yXcx2/hzAV7AZmjbUQ?=
 =?us-ascii?q?mTXeVfBOLZqlWKJ8S9zI5gPMxbAs9D4bPLfD5HZAXBjDVQ0exM/DBKys+VbC7l?=
 =?us-ascii?q?oUtQcQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123091868"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Mar 2022 18:58:28 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id E2D7E4D17160;
	Wed, 30 Mar 2022 18:58:22 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 30 Mar 2022 18:58:22 +0800
Received: from [10.167.201.8] (10.167.201.8) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 30 Mar 2022 18:58:22 +0800
Message-ID: <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com>
Date: Wed, 30 Mar 2022 18:58:21 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
To: Christoph Hellwig <hch@infradead.org>
CC: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux
 NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, linux-fsdevel
	<linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, david
	<david@fromorbit.com>, Jane Chu <jane.chu@oracle.com>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
 <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
 <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com>
 <YkQtOO/Z3SZ2Pksg@infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <YkQtOO/Z3SZ2Pksg@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: E2D7E4D17160.A1BE2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/3/30 18:13, Christoph Hellwig 写道:
> On Wed, Mar 30, 2022 at 06:03:01PM +0800, Shiyang Ruan wrote:
>>
>> Because I am not sure if the offset between each layer is page aligned.  For
>> example, when pmem dirver handles ->memory_failure(), it should subtract its
>> ->data_offset when it calls dax_holder_notify_failure().
> 
> If they aren't, none of the DAX machinery would work.

OK. Got it.

So, use page-based function signature for ->memory_failure():

int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
		      unsigned long nr_pfns, int flags);


As the code I pasted before, pmem driver will subtract its 
->data_offset, which is byte-based. And the filesystem who implements 
->notify_failure() will calculate the offset in unit of byte again.

So, leave its function signature byte-based, to avoid repeated conversions.

int (*notify_failure)(struct dax_device *dax_dev, u64 offset,
		      u64 len, int mf_flags);

What do you think?


--
Thanks,
Ruan.



