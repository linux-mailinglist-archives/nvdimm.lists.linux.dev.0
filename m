Return-Path: <nvdimm+bounces-6315-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E5C749DAC
	for <lists+linux-nvdimm@lfdr.de>; Thu,  6 Jul 2023 15:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FA921C20D74
	for <lists+linux-nvdimm@lfdr.de>; Thu,  6 Jul 2023 13:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4C99440;
	Thu,  6 Jul 2023 13:30:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395538F6A
	for <nvdimm@lists.linux.dev>; Thu,  6 Jul 2023 13:30:15 +0000 (UTC)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QxcJh5BrJzMqHn;
	Thu,  6 Jul 2023 21:07:48 +0800 (CST)
Received: from [10.174.151.185] (10.174.151.185) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 6 Jul 2023 21:11:02 +0800
Subject: Re: [PATCH] memory tier: rename destroy_memory_type() to
 put_memory_type()
To: Xiao Yang <yangx.jy@fujitsu.com>
CC: <ying.huang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>
References: <20230706063905.543800-1-linmiaohe@huawei.com>
 <7956e695-3eac-25ef-4412-3a0ff33e3574@fujitsu.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <428b3127-6b48-c19f-ae87-a1975b162e5c@huawei.com>
Date: Thu, 6 Jul 2023 21:11:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7956e695-3eac-25ef-4412-3a0ff33e3574@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.151.185]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected

On 2023/7/6 19:58, Xiao Yang wrote:
> On 2023/7/6 14:39, Miaohe Lin wrote:
>> It appears that destroy_memory_type() isn't a very good name because
>> we usually will not free the memory_type here. So rename it to a more
>> appropriate name i.e. put_memory_type().
>>
>> Suggested-by: Huang, Ying <ying.huang@intel.com>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>   drivers/dax/kmem.c           | 4 ++--
>>   include/linux/memory-tiers.h | 4 ++--
>>   mm/memory-tiers.c            | 6 +++---
>>   3 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
>> index 898ca9505754..c57acb73e3db 100644
>> --- a/drivers/dax/kmem.c
>> +++ b/drivers/dax/kmem.c
>> @@ -264,7 +264,7 @@ static int __init dax_kmem_init(void)
>>       return rc;
>>     error_dax_driver:
>> -    destroy_memory_type(dax_slowmem_type);
>> +    put_memory_type(dax_slowmem_type);
>>   err_dax_slowmem_type:
>>       kfree_const(kmem_name);
>>       return rc;
>> @@ -275,7 +275,7 @@ static void __exit dax_kmem_exit(void)
>>       dax_driver_unregister(&device_dax_kmem_driver);
>>       if (!any_hotremove_failed)
>>           kfree_const(kmem_name);
>> -    destroy_memory_type(dax_slowmem_type);
>> +    put_memory_type(dax_slowmem_type);
>>   }
>>     MODULE_AUTHOR("Intel Corporation");
>> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
>> index fc9647b1b4f9..437441cdf78f 100644
>> --- a/include/linux/memory-tiers.h
>> +++ b/include/linux/memory-tiers.h
>> @@ -33,7 +33,7 @@ struct memory_dev_type {
>>   #ifdef CONFIG_NUMA
>>   extern bool numa_demotion_enabled;
>>   struct memory_dev_type *alloc_memory_type(int adistance);
>> -void destroy_memory_type(struct memory_dev_type *memtype);
>> +void put_memory_type(struct memory_dev_type *memtype);
>>   void init_node_memory_type(int node, struct memory_dev_type *default_type);
>>   void clear_node_memory_type(int node, struct memory_dev_type *memtype);
>>   #ifdef CONFIG_MIGRATION
>> @@ -68,7 +68,7 @@ static inline struct memory_dev_type *alloc_memory_type(int adistance)
>>       return NULL;
>>   }
>>   -static inline void destroy_memory_type(struct memory_dev_type *memtype)
>> +static inline void put_memory_type(struct memory_dev_type *memtype)
>>   {
>>     }
>> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
>> index 1719fa3bcf02..c49ab03f49b1 100644
>> --- a/mm/memory-tiers.c
>> +++ b/mm/memory-tiers.c
>> @@ -560,11 +560,11 @@ struct memory_dev_type *alloc_memory_type(int adistance)
>>   }
>>   EXPORT_SYMBOL_GPL(alloc_memory_type);
>>   -void destroy_memory_type(struct memory_dev_type *memtype)
>> +void put_memory_type(struct memory_dev_type *memtype)
>>   {
>>       kref_put(&memtype->kref, release_memtype);
>>   }
>> -EXPORT_SYMBOL_GPL(destroy_memory_type);
>> +EXPORT_SYMBOL_GPL(put_memory_type);
>>     void init_node_memory_type(int node, struct memory_dev_type *memtype)
>>   {
>> @@ -586,7 +586,7 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
>>        */
>>       if (!node_memory_types[node].map_count) {
>>           node_memory_types[node].memtype = NULL;
>> -        destroy_memory_type(memtype);
>> +        put_memory_type(memtype);
> Hi Maohe,
> 
> I didn't find that destroy_memory_type(memtype) is called here on mainline kernel. Did I miss something?

It's on linux-next tree:
 https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=e5bf0402b80d80b66e9765b2c160b5199a5c7d3b

> 
> Other than that, it looks good to me.
> Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

Thanks for your review and comment.


