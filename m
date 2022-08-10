Return-Path: <nvdimm+bounces-4490-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DB158EE91
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Aug 2022 16:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 448FE280A7D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Aug 2022 14:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA262CA9;
	Wed, 10 Aug 2022 14:40:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075722C80
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 14:40:38 +0000 (UTC)
Received: from [192.168.1.218] (cpe-74-75-141-195.maine.res.rr.com [74.75.141.195])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id CA2CD40167F4;
	Wed, 10 Aug 2022 10:31:13 -0400 (EDT)
Reply-To: moss@cs.umass.edu
Subject: Re: [PATCH RFC 10/15] x86: add an arch helper function to invalidate
 all cache for nvdimm
To: Mark Rutland <mark.rutland@arm.com>, Dave Jiang <dave.jiang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Davidlohr Bueso <dave@stgolabs.net>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 a.manzanares@samsung.com, linux-arch@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
 <20220718053039.5whjdcxynukildlo@offworld>
 <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
 <20220803183729.00002183@huawei.com>
 <9f3705e1-de21-0f3c-12af-fd011b6d613d@intel.com>
 <YvO8pP7NUOdH17MM@FVFF77S0Q05N>
From: Eliot Moss <moss@cs.umass.edu>
Message-ID: <cf519783-ec21-b3c9-37db-7504b2279d43@cs.umass.edu>
Date: Wed, 10 Aug 2022 10:31:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YvO8pP7NUOdH17MM@FVFF77S0Q05N>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/10/2022 10:15 AM, Mark Rutland wrote:
> On Tue, Aug 09, 2022 at 02:47:06PM -0700, Dave Jiang wrote:
>>
>> On 8/3/2022 10:37 AM, Jonathan Cameron wrote:
>>> On Tue, 19 Jul 2022 12:07:03 -0700
>>> Dave Jiang <dave.jiang@intel.com> wrote:
>>>
>>>> On 7/17/2022 10:30 PM, Davidlohr Bueso wrote:
>>>>> On Fri, 15 Jul 2022, Dave Jiang wrote:
>>>>>> The original implementation to flush all cache after unlocking the
>>>>>> nvdimm
>>>>>> resides in drivers/acpi/nfit/intel.c. This is a temporary stop gap until
>>>>>> nvdimm with security operations arrives on other archs. With support CXL
>>>>>> pmem supporting security operations, specifically "unlock" dimm, the
>>>>>> need
>>>>>> for an arch supported helper function to invalidate all CPU cache for
>>>>>> nvdimm has arrived. Remove original implementation from acpi/nfit and
>>>>>> add
>>>>>> cross arch support for this operation.
>>>>>>
>>>>>> Add CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE Kconfig and allow x86_64 to
>>>>>> opt in
>>>>>> and provide the support via wbinvd_on_all_cpus() call.
>>>>> So the 8.2.9.5.5 bits will also need wbinvd - and I guess arm64 will need
>>>>> its own semantics (iirc there was a flush all call in the past). Cc'ing
>>>>> Jonathan as well.
>>>>>
>>>>> Anyway, I think this call should not be defined in any place other
>>>>> than core
>>>>> kernel headers, and not in pat/nvdimm. I was trying to make it fit in
>>>>> smp.h,
>>>>> for example, but conviniently we might be able to hijack
>>>>> flush_cache_all()
>>>>> for our purposes as of course neither x86-64 arm64 uses it :)
>>>>>
>>>>> And I see this as safe (wrt not adding a big hammer on unaware
>>>>> drivers) as
>>>>> the 32bit archs that define the call are mostly contained thin their
>>>>> arch/,
>>>>> and the few in drivers/ are still specific to those archs.
>>>>>
>>>>> Maybe something like the below.
>>>> Ok. I'll replace my version with yours.
>>> Careful with flush_cache_all(). The stub version in
>>> include/asm-generic/cacheflush.h has a comment above it that would
>>> need updating at very least (I think).
>>> Note there 'was' a flush_cache_all() for ARM64, but:
>>> https://patchwork.kernel.org/project/linux-arm-kernel/patch/1429521875-16893-1-git-send-email-mark.rutland@arm.com/
>>
>>
>> flush_and_invalidate_cache_all() instead given it calls wbinvd on x86? I
>> think other archs, at least ARM, those are separate instructions aren't
>> they?
> 
> On arm and arm64 there is no way to perform maintenance on *all* caches; it has
> to be done in cacheline increments by address. It's not realistic to do that
> for the entire address space, so we need to know the relevant address ranges
> (as per the commit referenced above).
> 
> So we probably need to think a bit harder about the geenric interface, since
> "all" isn't possible to implement. :/

Can you not do flushing by set and way on each cache,
probably working outwards from L1?

Eliot Moss

