Return-Path: <nvdimm+bounces-6552-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E48785046
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Aug 2023 07:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 997232812F5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Aug 2023 05:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D55C1FDD;
	Wed, 23 Aug 2023 05:58:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116D21FA5
	for <nvdimm@lists.linux.dev>; Wed, 23 Aug 2023 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692770314; x=1724306314;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=LW+RWmleuQGwpDrnLOlCnwX6p1Gg6/2pGZbejbm+ZBY=;
  b=LtM/EYDpgaCYMgrDCQnWcDUxvENeKMHqX7pb3BsO2J7ACB+XQFpU757V
   Q8qwwdZNXnoc4Unf3G6Z5sQVvEwdgorUraGr6iyVYsgPiCZg6Wk5lSoLs
   YlEcr+SDyJS0t3bQFZbsRju2IbnWoE9bCzzHCnOG1UcGJMCMa+uoK/ucl
   DODXOCNIv6Xh4Q8QWMp3GyngVxJvcvYKYJau4I5xFcGbgL6oKz0BcKN4Z
   1dqkng0ey2CIwkXRHxz4NlZXk3ZzBPrALR3x5WpFfugiSZyuao0kRQ/td
   E/Ht36GOF/sDzy25bmXmAH3rcFHnNn1VowS0G6Mr0TiV6xnhwIQUJwjzS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="372964708"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="372964708"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 22:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="713437752"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="713437752"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 22:58:28 -0700
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
	<875y57dhar.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<87wmxnlfer.fsf@nvdebian.thelocal>
Date: Wed, 23 Aug 2023 13:56:03 +0800
In-Reply-To: <87wmxnlfer.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Tue, 22 Aug 2023 17:11:34 +1000")
Message-ID: <878ra2b8uk.fsf@yhuang6-desk2.ccr.corp.intel.com>
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
>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>
>>>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>>>
>>>>>> Hi, Alistair,
>>>>>>
>>>>>> Sorry for late response.  Just come back from vacation.
>>>>>
>>>>> Ditto for this response :-)
>>>>>
>>>>> I see Andrew has taken this into mm-unstable though, so my bad for not
>>>>> getting around to following all this up sooner.
>>>>>
>>>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>>>
>>>>>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>>>>>
>>>>>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>>>>>
>>>>>>>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>>>>>>>
>>>>>>>>>> Alistair Popple <apopple@nvidia.com> writes:
>>>>>>>>>>
>>>>>>>>>>>>>> While other memory device drivers can use the general notifier chain
>>>>>>>>>>>>>> interface at the same time.
>>>>>>>>>>>
>>>>>>>>>>> How would that work in practice though? The abstract distance as far as
>>>>>>>>>>> I can tell doesn't have any meaning other than establishing preferences
>>>>>>>>>>> for memory demotion order. Therefore all calculations are relative to
>>>>>>>>>>> the rest of the calculations on the system. So if a driver does it's own
>>>>>>>>>>> thing how does it choose a sensible distance? IHMO the value here is in
>>>>>>>>>>> coordinating all that through a standard interface, whether that is HMAT
>>>>>>>>>>> or something else.
>>>>>>>>>>
>>>>>>>>>> Only if different algorithms follow the same basic principle.  For
>>>>>>>>>> example, the abstract distance of default DRAM nodes are fixed
>>>>>>>>>> (MEMTIER_ADISTANCE_DRAM).  The abstract distance of the memory device is
>>>>>>>>>> in linear direct proportion to the memory latency and inversely
>>>>>>>>>> proportional to the memory bandwidth.  Use the memory latency and
>>>>>>>>>> bandwidth of default DRAM nodes as base.
>>>>>>>>>>
>>>>>>>>>> HMAT and CDAT report the raw memory latency and bandwidth.  If there are
>>>>>>>>>> some other methods to report the raw memory latency and bandwidth, we
>>>>>>>>>> can use them too.
>>>>>>>>>
>>>>>>>>> Argh! So we could address my concerns by having drivers feed
>>>>>>>>> latency/bandwidth numbers into a standard calculation algorithm right?
>>>>>>>>> Ie. Rather than having drivers calculate abstract distance themselves we
>>>>>>>>> have the notifier chains return the raw performance data from which the
>>>>>>>>> abstract distance is derived.
>>>>>>>>
>>>>>>>> Now, memory device drivers only need a general interface to get the
>>>>>>>> abstract distance from the NUMA node ID.  In the future, if they need
>>>>>>>> more interfaces, we can add them.  For example, the interface you
>>>>>>>> suggested above.
>>>>>>>
>>>>>>> Huh? Memory device drivers (ie. dax/kmem.c) don't care about abstract
>>>>>>> distance, it's a meaningless number. The only reason they care about it
>>>>>>> is so they can pass it to alloc_memory_type():
>>>>>>>
>>>>>>> struct memory_dev_type *alloc_memory_type(int adistance)
>>>>>>>
>>>>>>> Instead alloc_memory_type() should be taking bandwidth/latency numbers
>>>>>>> and the calculation of abstract distance should be done there. That
>>>>>>> resovles the issues about how drivers are supposed to devine adistance
>>>>>>> and also means that when CDAT is added we don't have to duplicate the
>>>>>>> calculation code.
>>>>>>
>>>>>> In the current design, the abstract distance is the key concept of
>>>>>> memory types and memory tiers.  And it is used as interface to allocate
>>>>>> memory types.  This provides more flexibility than some other interfaces
>>>>>> (e.g. read/write bandwidth/latency).  For example, in current
>>>>>> dax/kmem.c, if HMAT isn't available in the system, the default abstract
>>>>>> distance: MEMTIER_DEFAULT_DAX_ADISTANCE is used.  This is still useful
>>>>>> to support some systems now.  On a system without HMAT/CDAT, it's
>>>>>> possible to calculate abstract distance from ACPI SLIT, although this is
>>>>>> quite limited.  I'm not sure whether all systems will provide read/write
>>>>>> bandwith/latency data for all memory devices.
>>>>>>
>>>>>> HMAT and CDAT or some other mechanisms may provide the read/write
>>>>>> bandwidth/latency data to be used to calculate abstract distance.  For
>>>>>> them, we can provide a shared implementation in mm/memory-tiers.c to map
>>>>>> from read/write bandwith/latency to the abstract distance.  Can this
>>>>>> solve your concerns about the consistency among algorithms?  If so, we
>>>>>> can do that when we add the second algorithm that needs that.
>>>>>
>>>>> I guess it would address my concerns if we did that now. I don't see why
>>>>> we need to wait for a second implementation for that though - the whole
>>>>> series seems to be built around adding a framework for supporting
>>>>> multiple algorithms even though only one exists. So I think we should
>>>>> support that fully, or simplfy the whole thing and just assume the only
>>>>> thing that exists is HMAT and get rid of the general interface until a
>>>>> second algorithm comes along.
>>>>
>>>> We will need a general interface even for one algorithm implementation.
>>>> Because it's not good to make a dax subsystem driver (dax/kmem) to
>>>> depend on a ACPI subsystem driver (acpi/hmat).  We need some general
>>>> interface at subsystem level (memory tier here) between them.
>>>
>>> I don't understand this argument. For a single algorithm it would be
>>> simpler to just define acpi_hmat_calculate_adistance() and a static
>>> inline version of it that returns -ENOENT when !CONFIG_ACPI than adding
>>> a layer of indirection through notifier blocks. That breaks any
>>> dependency on ACPI and there's plenty of precedent for this approach in
>>> the kernel already.
>>
>> ACPI is a subsystem, so it's OK for dax/kmem to depends on CONFIG_ACPI.
>> But HMAT is a driver of ACPI subsystem (controlled via
>> CONFIG_ACPI_HMAT).  It's not good for a driver of DAX subsystem
>> (dax/kmem) to depend on a *driver* of ACPI subsystem.
>>
>> Yes.  Technically, there's no hard wall to prevent this.  But I think
>> that a good design should make drivers depends on subsystems or drivers
>> of the same subsystem, NOT drivers of other subsystems.
>
> Thanks, I wasn't really thinking of HMAT as an ACPI driver. I understand
> where you're coming from but I really don't see the problem with using a
> static inline. It doesn't create dependencies (you could still use
> dax/kmem without ACPI) and results in smaller and easier to follow code.
>
> IMHO it's far more obvious that a call to acpi_hmat_calcaulte_adist()
> returns either a default if ACPI HMAT isn't configured or a calculated
> value than it is to figure out what notifiers may or may not be
> registered at runtime and what priority they may be called in from
> mt_calc_adistance().
>
> It appears you think that is a bad design, but I don't understand
> why. What does this approach give us that a simpler approach wouldn't?

Think about all these again.  Finally I admit you are right.  The
general interface is better mainly if there are multiple implementations
of the interface.

In this series, we provide just one implementation: HMAT.  And, the
second one: CDAT will be implemented soon.  And, CDAT will use the same
method to translate from read/write bandwidth/latency to adistance.  So,
I suggest to:

- Keep the general interface (and notifier chain), for HMAT and soon
  available CDAT

- Move the code to translate from read/write bandwidth/latency to
  adistance to memory-tiers.c.  Which is used by HMAT now and will be
  used by CDAT soon.  And it can be used by other drivers.

What do you think about that?

--
Best Regards,
Huang, Ying

