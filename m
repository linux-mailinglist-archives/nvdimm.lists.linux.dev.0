Return-Path: <nvdimm+bounces-3842-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB0E52E448
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 May 2022 07:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 73DEC2E09E9
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 May 2022 05:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A09D15CC;
	Fri, 20 May 2022 05:20:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB7F15A9
	for <nvdimm@lists.linux.dev>; Fri, 20 May 2022 05:20:05 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3A5VLVKa+4syirCH9xfjiSDrUD63+TJUtcMsCJ2f8?=
 =?us-ascii?q?bfWQNrUomhGYHzmcfCDjTOa6IZzCmf9F/btm0pB8A75GEmoNrGldlrnsFo1Bi8?=
 =?us-ascii?q?5ScXYvDRqvT04J+FuWaFQQ/qZx2huDodKjYdVeB4Ef9WlTdhSMkj/vQHOKlULe?=
 =?us-ascii?q?s1h1ZHmeIdg9w0HqPpMZp2uaEsfDha++8kYuaT//3YTdJ6BYoWo4g0J9vnTs01?=
 =?us-ascii?q?BjEVJz0iXRlDRxDlAe2e3D4l/vzL4npR5fzatE88uJX24/+IL+FEmPxp3/BC/u?=
 =?us-ascii?q?ulPD1b08LXqXPewOJjxK6WYD72l4b+HN0if19aZLwam8O49mNt8pswdNWpNq+T?=
 =?us-ascii?q?xw1FqPRmuUBSAQeGCZ7VUFD0OadfSPh4JbCnyUqdFOpmZ2CFnoeMYQG++pfD3t?=
 =?us-ascii?q?J8PsCIjERKBuEgoqewLm7YuhqiN4qIMTiMMUYoH4I5T3QC7AkB4/CR6HL7NpD9?=
 =?us-ascii?q?DY2ms1KW/3ZYqIxZThwaxLPSx5CIFEaDNQ5hujArn3+dSBI7VeQjakp6mPQigt?=
 =?us-ascii?q?r39DFNsTZe9mPbcFUhVqD4GbH+XnpRB0XKrS3yzOD/zSnhvLnmjnyU4YfUra/8?=
 =?us-ascii?q?5ZChFyV23xWBgYaWEW2pdGnhUOkHdFSMUoZ/mwpt6da3EiqSMTtGh61uniJujY?=
 =?us-ascii?q?CVNdKVe438geAzuzT+QnxLmwFSCNRLcwor+coSjEwkFyEhdXkAXpoqrL9dJ433?=
 =?us-ascii?q?t94thvrYW5MczBEPnRCEGM4DxDYiNlbpnryohxLScZZVuHIJAw=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AW6c12a/LRHvcOJF+kT9uk+DVI+orL9Y04lQ7?=
 =?us-ascii?q?vn2ZKCYlFfBw8vrFoB11726WtN98YhEdcLO7WZVoI0msl6KdiLN5VdyftWLdyQ?=
 =?us-ascii?q?6Vxe9ZnO/fKv7bdxEWNNQx6U6tScdD4RTLY2RHsQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124369298"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 20 May 2022 13:18:54 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 3873B4D16FFC;
	Fri, 20 May 2022 13:18:53 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 20 May 2022 13:18:53 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 20 May 2022 13:18:53 +0800
Received: from [192.168.22.28] (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 20 May 2022 13:18:52 +0800
Message-ID: <bc0f3750-e339-d736-62ee-ef447790e7b1@fujitsu.com>
Date: Fri, 20 May 2022 13:18:52 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
To: Christoph Hellwig <hch@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>,
	<dan.j.williams@intel.com>, <david@fromorbit.com>, <jane.chu@oracle.com>
References: <20220410171623.3788004-1-ruansy.fnst@fujitsu.com>
 <YlPTaexutZrus1kQ@infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <YlPTaexutZrus1kQ@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 3873B4D16FFC.A0799
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/4/11 15:06, Christoph Hellwig 写道:
> On Mon, Apr 11, 2022 at 01:16:23AM +0800, Shiyang Ruan wrote:
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index bd502957cfdf..72d9e69aea98 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -359,7 +359,6 @@ static void pmem_release_disk(void *__pmem)
>>   	struct pmem_device *pmem = __pmem;
>>   
>>   	dax_remove_host(pmem->disk);
>> -	kill_dax(pmem->dax_dev);
>>   	put_dax(pmem->dax_dev);
>>   	del_gendisk(pmem->disk);
>>   
>> @@ -597,6 +596,8 @@ static void nd_pmem_remove(struct device *dev)
>>   		pmem->bb_state = NULL;
>>   	}
>>   	nvdimm_flush(to_nd_region(dev->parent), NULL);
>> +
>> +	kill_dax(pmem->dax_dev);
> 
> I think the put_dax will have to move as well.

After reading the implementation of 'devm_add_action_or_reset()', I 
think there is no need to move kill_dax() and put_dax() into ->remove().

In unbind, it will call both drv->remove() and devres_release_all(). 
The action, pmem_release_disk(), added in devm_add_action_or_reset() 
will be execute in devres_release_all().  So, during the unbind process, 
{kill,put}_dax() will finally be called to notify the REMOVE signal.

In addition, if devm_add_action_or_reset() fails in pmem_attach_disk(), 
pmem_release_disk() will be called to cleanup the pmem->dax_dev.


--
Thanks,
Ruan.

> 
> This part should probably also be a separate, well-documented
> cleanup patch.



