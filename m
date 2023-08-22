Return-Path: <nvdimm+bounces-6546-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B18F278372A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Aug 2023 03:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC2EC1C20A1E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Aug 2023 01:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8803C10EB;
	Tue, 22 Aug 2023 01:00:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3082BEA5
	for <nvdimm@lists.linux.dev>; Tue, 22 Aug 2023 01:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692666043; x=1724202043;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=PpIQtwVVDLgNvYt1ipLFOy1XV/k+n83Ca/rODVEtFaw=;
  b=JUWsQNKWf6AJdzsIvdMQ1EY0fW32TFu7VxCMze1FiLSOV1X/hq0HhJcu
   6bG766P3T9SOfGJkZCV/M/9Ksh7Mbefz73ZXv8VUcfX8tgrhSBpZSRjH6
   Q/Ce3ZldSuvSHNhwZOHILSSYQ8eLWO3jRnqBYHc6JqVWmlriYfSIL7amD
   LixXTCS4T+Vn7YMBhXL1k3GQM6bc+bC2cLWwFdPablQym4RjMuH2YTAOW
   0QJROYpo+i67nEecDJ1gFG9MB2CH05vn05dtRAQhNOpAZ9VHrsLjEojBF
   o5PHOV6YDX08fWLECM4P2lbsQ/I8Izh+uv18E+KMEHylC5dtdx4EM3cEQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="354072397"
X-IronPort-AV: E=Sophos;i="6.01,191,1684825200"; 
   d="scan'208";a="354072397"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 18:00:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="685853988"
X-IronPort-AV: E=Sophos;i="6.01,191,1684825200"; 
   d="scan'208";a="685853988"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 18:00:35 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>,  <linux-cxl@vger.kernel.org>,
  <nvdimm@lists.linux.dev>,  <linux-acpi@vger.kernel.org>,  "Aneesh Kumar K
 . V" <aneesh.kumar@linux.ibm.com>,  Wei Xu <weixugc@google.com>,  Dan
 Williams <dan.j.williams@intel.com>,  Dave Hansen <dave.hansen@intel.com>,
  "Davidlohr Bueso" <dave@stgolabs.net>,  Johannes Weiner
 <hannes@cmpxchg.org>,  "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
  Michal Hocko <mhocko@kernel.org>,  Yang Shi <shy828301@gmail.com>,
  Rafael J Wysocki <rafael.j.wysocki@intel.com>,  Dave Jiang
 <dave.jiang@intel.com>
Subject: Re: [PATCH RESEND 1/4] memory tiering: add abstract distance
 calculation algorithms management
References: <20230721012932.190742-1-ying.huang@intel.com>
	<20230721012932.190742-2-ying.huang@intel.com>
	<87r0owzqdc.fsf@nvdebian.thelocal>
	<87r0owy95t.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87sf9cxupz.fsf@nvdebian.thelocal>
	<878rb3xh2x.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87351axbk6.fsf@nvdebian.thelocal>
	<87edkuvw6m.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87y1j2vvqw.fsf@nvdebian.thelocal>
	<87a5vhx664.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87lef0x23q.fsf@nvdebian.thelocal>
	<87r0oack40.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87cyzgwrys.fsf@nvdebian.thelocal>
	<87il98c8ms.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87edjwlzn7.fsf@nvdebian.thelocal>
Date: Tue, 22 Aug 2023 08:58:20 +0800
In-Reply-To: <87edjwlzn7.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Tue, 22 Aug 2023 09:52:43 +1000")
Message-ID: <875y57dhar.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Alistair Popple <apopple@nvidia.com> writes:

> "Huang, Ying" <ying.huang@intel.com> writes:
>
>> Alistair Popple <apopple@nvidia.com> writes:
>>
>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>
>>>> Hi, Alistair,
>>>>
>>>> Sorry for late response.  Just come back from vacation.
>>>
>>> Ditto for this response :-)
>>>
>>> I see Andrew has taken this into mm-unstable though, so my bad for not
>>> getting around to following all this up sooner.
>>>
>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>
>>>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>>>
>>>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>>>
>>>>>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>>>>>
>>>>>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>>>>>
>>>>>>>>>>>> While other memory device drivers can use the general notifier chain
>>>>>>>>>>>> interface at the same time.
>>>>>>>>>
>>>>>>>>> How would that work in practice though? The abstract distance as far as
>>>>>>>>> I can tell doesn't have any meaning other than establishing preferences
>>>>>>>>> for memory demotion order. Therefore all calculations are relative to
>>>>>>>>> the rest of the calculations on the system. So if a driver does it's own
>>>>>>>>> thing how does it choose a sensible distance? IHMO the value here is in
>>>>>>>>> coordinating all that through a standard interface, whether that is HMAT
>>>>>>>>> or something else.
>>>>>>>>
>>>>>>>> Only if different algorithms follow the same basic principle.  For
>>>>>>>> example, the abstract distance of default DRAM nodes are fixed
>>>>>>>> (MEMTIER_ADISTANCE_DRAM).  The abstract distance of the memory device is
>>>>>>>> in linear direct proportion to the memory latency and inversely
>>>>>>>> proportional to the memory bandwidth.  Use the memory latency and
>>>>>>>> bandwidth of default DRAM nodes as base.
>>>>>>>>
>>>>>>>> HMAT and CDAT report the raw memory latency and bandwidth.  If there are
>>>>>>>> some other methods to report the raw memory latency and bandwidth, we
>>>>>>>> can use them too.
>>>>>>>
>>>>>>> Argh! So we could address my concerns by having drivers feed
>>>>>>> latency/bandwidth numbers into a standard calculation algorithm right?
>>>>>>> Ie. Rather than having drivers calculate abstract distance themselves we
>>>>>>> have the notifier chains return the raw performance data from which the
>>>>>>> abstract distance is derived.
>>>>>>
>>>>>> Now, memory device drivers only need a general interface to get the
>>>>>> abstract distance from the NUMA node ID.  In the future, if they need
>>>>>> more interfaces, we can add them.  For example, the interface you
>>>>>> suggested above.
>>>>>
>>>>> Huh? Memory device drivers (ie. dax/kmem.c) don't care about abstract
>>>>> distance, it's a meaningless number. The only reason they care about it
>>>>> is so they can pass it to alloc_memory_type():
>>>>>
>>>>> struct memory_dev_type *alloc_memory_type(int adistance)
>>>>>
>>>>> Instead alloc_memory_type() should be taking bandwidth/latency numbers
>>>>> and the calculation of abstract distance should be done there. That
>>>>> resovles the issues about how drivers are supposed to devine adistance
>>>>> and also means that when CDAT is added we don't have to duplicate the
>>>>> calculation code.
>>>>
>>>> In the current design, the abstract distance is the key concept of
>>>> memory types and memory tiers.  And it is used as interface to allocate
>>>> memory types.  This provides more flexibility than some other interfaces
>>>> (e.g. read/write bandwidth/latency).  For example, in current
>>>> dax/kmem.c, if HMAT isn't available in the system, the default abstract
>>>> distance: MEMTIER_DEFAULT_DAX_ADISTANCE is used.  This is still useful
>>>> to support some systems now.  On a system without HMAT/CDAT, it's
>>>> possible to calculate abstract distance from ACPI SLIT, although this is
>>>> quite limited.  I'm not sure whether all systems will provide read/write
>>>> bandwith/latency data for all memory devices.
>>>>
>>>> HMAT and CDAT or some other mechanisms may provide the read/write
>>>> bandwidth/latency data to be used to calculate abstract distance.  For
>>>> them, we can provide a shared implementation in mm/memory-tiers.c to map
>>>> from read/write bandwith/latency to the abstract distance.  Can this
>>>> solve your concerns about the consistency among algorithms?  If so, we
>>>> can do that when we add the second algorithm that needs that.
>>>
>>> I guess it would address my concerns if we did that now. I don't see why
>>> we need to wait for a second implementation for that though - the whole
>>> series seems to be built around adding a framework for supporting
>>> multiple algorithms even though only one exists. So I think we should
>>> support that fully, or simplfy the whole thing and just assume the only
>>> thing that exists is HMAT and get rid of the general interface until a
>>> second algorithm comes along.
>>
>> We will need a general interface even for one algorithm implementation.
>> Because it's not good to make a dax subsystem driver (dax/kmem) to
>> depend on a ACPI subsystem driver (acpi/hmat).  We need some general
>> interface at subsystem level (memory tier here) between them.
>
> I don't understand this argument. For a single algorithm it would be
> simpler to just define acpi_hmat_calculate_adistance() and a static
> inline version of it that returns -ENOENT when !CONFIG_ACPI than adding
> a layer of indirection through notifier blocks. That breaks any
> dependency on ACPI and there's plenty of precedent for this approach in
> the kernel already.

ACPI is a subsystem, so it's OK for dax/kmem to depends on CONFIG_ACPI.
But HMAT is a driver of ACPI subsystem (controlled via
CONFIG_ACPI_HMAT).  It's not good for a driver of DAX subsystem
(dax/kmem) to depend on a *driver* of ACPI subsystem.

Yes.  Technically, there's no hard wall to prevent this.  But I think
that a good design should make drivers depends on subsystems or drivers
of the same subsystem, NOT drivers of other subsystems.

--
Best Regards,
Huang, Ying

