Return-Path: <nvdimm+bounces-4485-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF66B58E211
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Aug 2022 23:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CD76280A64
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Aug 2022 21:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8822D4A01;
	Tue,  9 Aug 2022 21:47:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDD46AF
	for <nvdimm@lists.linux.dev>; Tue,  9 Aug 2022 21:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660081629; x=1691617629;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0toa8DE8ntR29xYpn/56lJ1FmZA5onr2+vCZmvVjDKw=;
  b=Kx36GxNGN+J3/Bzkz6omKwI0EphJ/fL4XSjYIv+N+kQtLebRzg1Y+gut
   oL2UVFss0FF9gEwFJPAyGkUsDtBihtFYkXAvf2Lf/q6ohpvu6ZiJjdwJv
   4WAiEWpb+whBbYTU1W/wLzThWBis9xDSt+l8fs7hUSD6Tkf8EwBseDpc1
   GuOY+g1zLZ4ITAr97zXx+ktl4GoW9fKNm3HG9St6CI3SbNMHlRjGNKLVd
   sWHRi/NX/xmSEedyahynA51o6gyIAQUa8Yathg7xZXP4CUe7jkvp+eDSj
   OvExv5KBO0jb/p5I0YlMbzhxvBY5vglp3hU9vOhoWL/pfpQNOTO1vMhRp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="354942127"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="354942127"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 14:47:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="664608134"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.24.249]) ([10.212.24.249])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 14:47:06 -0700
Message-ID: <9f3705e1-de21-0f3c-12af-fd011b6d613d@intel.com>
Date: Tue, 9 Aug 2022 14:47:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH RFC 10/15] x86: add an arch helper function to invalidate
 all cache for nvdimm
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 a.manzanares@samsung.com, linux-arch@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
 <20220718053039.5whjdcxynukildlo@offworld>
 <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
 <20220803183729.00002183@huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220803183729.00002183@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/3/2022 10:37 AM, Jonathan Cameron wrote:
> On Tue, 19 Jul 2022 12:07:03 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
>
>> On 7/17/2022 10:30 PM, Davidlohr Bueso wrote:
>>> On Fri, 15 Jul 2022, Dave Jiang wrote:
>>>   
>>>> The original implementation to flush all cache after unlocking the
>>>> nvdimm
>>>> resides in drivers/acpi/nfit/intel.c. This is a temporary stop gap until
>>>> nvdimm with security operations arrives on other archs. With support CXL
>>>> pmem supporting security operations, specifically "unlock" dimm, the
>>>> need
>>>> for an arch supported helper function to invalidate all CPU cache for
>>>> nvdimm has arrived. Remove original implementation from acpi/nfit and
>>>> add
>>>> cross arch support for this operation.
>>>>
>>>> Add CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE Kconfig and allow x86_64 to
>>>> opt in
>>>> and provide the support via wbinvd_on_all_cpus() call.
>>> So the 8.2.9.5.5 bits will also need wbinvd - and I guess arm64 will need
>>> its own semantics (iirc there was a flush all call in the past). Cc'ing
>>> Jonathan as well.
>>>
>>> Anyway, I think this call should not be defined in any place other
>>> than core
>>> kernel headers, and not in pat/nvdimm. I was trying to make it fit in
>>> smp.h,
>>> for example, but conviniently we might be able to hijack
>>> flush_cache_all()
>>> for our purposes as of course neither x86-64 arm64 uses it :)
>>>
>>> And I see this as safe (wrt not adding a big hammer on unaware
>>> drivers) as
>>> the 32bit archs that define the call are mostly contained thin their
>>> arch/,
>>> and the few in drivers/ are still specific to those archs.
>>>
>>> Maybe something like the below.
>> Ok. I'll replace my version with yours.
> Careful with flush_cache_all(). The stub version in
> include/asm-generic/cacheflush.h has a comment above it that would
> need updating at very least (I think).
> Note there 'was' a flush_cache_all() for ARM64, but:
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/1429521875-16893-1-git-send-email-mark.rutland@arm.com/


flush_and_invalidate_cache_all() instead given it calls wbinvd on x86? I 
think other archs, at least ARM, those are separate instructions aren't 
they?

>
> Also, I'm far from sure it will be the right choice on all CXL supporting
> architectures.
> +CC linux-arch, linux-arm and Arnd.
>
>>
>>> Thanks,
>>> Davidlohr
>>>
>>> ------8<----------------------------------------
>>> Subject: [PATCH] arch/x86: define flush_cache_all as global wbinvd
>>>
>>> With CXL security features, global CPU cache flushing nvdimm
>>> requirements are no longer specific to that subsystem, even
>>> beyond the scope of security_ops. CXL will need such semantics
>>> for features not necessarily limited to persistent memory.
>>>
>>> So use the flush_cache_all() for the wbinvd across all
>>> CPUs on x86. arm64, which is another platform to have CXL
>>> support can also define its own semantics here.
>>>
>>> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
>>> ---
>>>   arch/x86/Kconfig                  |  1 -
>>>   arch/x86/include/asm/cacheflush.h |  5 +++++
>>>   arch/x86/mm/pat/set_memory.c      |  8 --------
>>>   drivers/acpi/nfit/intel.c         | 11 ++++++-----
>>>   drivers/cxl/security.c            |  5 +++--
>>>   include/linux/libnvdimm.h         |  9 ---------
>>>   6 files changed, 14 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index 8dbe89eba639..be0b95e51df6 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -83,7 +83,6 @@ config X86
>>>      select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>>      select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>>>      select ARCH_HAS_PMEM_API        if X86_64
>>> -    select ARCH_HAS_NVDIMM_INVAL_CACHE    if X86_64
>>>      select ARCH_HAS_PTE_DEVMAP        if X86_64
>>>      select ARCH_HAS_PTE_SPECIAL
>>>      select ARCH_HAS_UACCESS_FLUSHCACHE    if X86_64
>>> diff --git a/arch/x86/include/asm/cacheflush.h
>>> b/arch/x86/include/asm/cacheflush.h
>>> index b192d917a6d0..05c79021665d 100644
>>> --- a/arch/x86/include/asm/cacheflush.h
>>> +++ b/arch/x86/include/asm/cacheflush.h
>>> @@ -10,4 +10,9 @@
>>>
>>>   void clflush_cache_range(void *addr, unsigned int size);
>>>
>>> +#define flush_cache_all()        \
>>> +do {                    \
>>> +    wbinvd_on_all_cpus();        \
>>> +} while (0)
>>> +
>>>   #endif /* _ASM_X86_CACHEFLUSH_H */
>>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>>> index e4cd1286deef..1abd5438f126 100644
>>> --- a/arch/x86/mm/pat/set_memory.c
>>> +++ b/arch/x86/mm/pat/set_memory.c
>>> @@ -330,14 +330,6 @@ void arch_invalidate_pmem(void *addr, size_t size)
>>>   EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
>>>   #endif
>>>
>>> -#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
>>> -void arch_invalidate_nvdimm_cache(void)
>>> -{
>>> -    wbinvd_on_all_cpus();
>>> -}
>>> -EXPORT_SYMBOL_GPL(arch_invalidate_nvdimm_cache);
>>> -#endif
>>> -
>>>   static void __cpa_flush_all(void *arg)
>>>   {
>>>      unsigned long cache = (unsigned long)arg;
>>> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
>>> index 242d2e9203e9..1b0ecb4d67e6 100644
>>> --- a/drivers/acpi/nfit/intel.c
>>> +++ b/drivers/acpi/nfit/intel.c
>>> @@ -1,6 +1,7 @@
>>>   // SPDX-License-Identifier: GPL-2.0
>>>   /* Copyright(c) 2018 Intel Corporation. All rights reserved. */
>>>   #include <linux/libnvdimm.h>
>>> +#include <linux/cacheflush.h>
>>>   #include <linux/ndctl.h>
>>>   #include <linux/acpi.h>
>>>   #include <asm/smp.h>
>>> @@ -226,7 +227,7 @@ static int __maybe_unused
>>> intel_security_unlock(struct nvdimm *nvdimm,
>>>      }
>>>
>>>      /* DIMM unlocked, invalidate all CPU caches before we read it */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>
>>>      return 0;
>>>   }
>>> @@ -296,7 +297,7 @@ static int __maybe_unused
>>> intel_security_erase(struct nvdimm *nvdimm,
>>>          return -ENOTTY;
>>>
>>>      /* flush all cache before we erase DIMM */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>      memcpy(nd_cmd.cmd.passphrase, key->data,
>>>              sizeof(nd_cmd.cmd.passphrase));
>>>      rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
>>> @@ -316,7 +317,7 @@ static int __maybe_unused
>>> intel_security_erase(struct nvdimm *nvdimm,
>>>      }
>>>
>>>      /* DIMM erased, invalidate all CPU caches before we read it */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>      return 0;
>>>   }
>>>
>>> @@ -353,7 +354,7 @@ static int __maybe_unused
>>> intel_security_query_overwrite(struct nvdimm *nvdimm)
>>>      }
>>>
>>>      /* flush all cache before we make the nvdimms available */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>      return 0;
>>>   }
>>>
>>> @@ -379,7 +380,7 @@ static int __maybe_unused
>>> intel_security_overwrite(struct nvdimm *nvdimm,
>>>          return -ENOTTY;
>>>
>>>      /* flush all cache before we erase DIMM */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>      memcpy(nd_cmd.cmd.passphrase, nkey->data,
>>>              sizeof(nd_cmd.cmd.passphrase));
>>>      rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
>>> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
>>> index 3dc04b50afaf..e2977872bf2f 100644
>>> --- a/drivers/cxl/security.c
>>> +++ b/drivers/cxl/security.c
>>> @@ -6,6 +6,7 @@
>>>   #include <linux/ndctl.h>
>>>   #include <linux/async.h>
>>>   #include <linux/slab.h>
>>> +#include <linux/cacheflush.h>
>>>   #include "cxlmem.h"
>>>   #include "cxl.h"
>>>
>>> @@ -137,7 +138,7 @@ static int cxl_pmem_security_unlock(struct nvdimm
>>> *nvdimm,
>>>          return rc;
>>>
>>>      /* DIMM unlocked, invalidate all CPU caches before we read it */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>      return 0;
>>>   }
>>>
>>> @@ -165,7 +166,7 @@ static int
>>> cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
>>>          return rc;
>>>
>>>      /* DIMM erased, invalidate all CPU caches before we read it */
>>> -    arch_invalidate_nvdimm_cache();
>>> +    flush_cache_all();
>>>      return 0;
>>>   }
>>>
>>> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
>>> index 07e4e7572089..0769afb73380 100644
>>> --- a/include/linux/libnvdimm.h
>>> +++ b/include/linux/libnvdimm.h
>>> @@ -309,13 +309,4 @@ static inline void arch_invalidate_pmem(void
>>> *addr, size_t size)
>>>   {
>>>   }
>>>   #endif
>>> -
>>> -#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
>>> -void arch_invalidate_nvdimm_cache(void);
>>> -#else
>>> -static inline void arch_invalidate_nvdimm_cache(void)
>>> -{
>>> -}
>>> -#endif
>>> -
>>>   #endif /* __LIBNVDIMM_H__ */
>>> -- 
>>> 2.36.1
>>>   

