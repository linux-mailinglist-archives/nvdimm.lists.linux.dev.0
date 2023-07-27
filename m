Return-Path: <nvdimm+bounces-6415-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 742917645EE
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jul 2023 07:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C8BB2820E0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jul 2023 05:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6308484;
	Thu, 27 Jul 2023 05:43:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B963538B
	for <nvdimm@lists.linux.dev>; Thu, 27 Jul 2023 05:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690436585; x=1721972585;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=CZIXORpK/pKO7gqM7gZSvX2ogA1eMyUczHdXGcg8arI=;
  b=FDUa4O9YPyb11eg5HGbbcL/NYX+mqxK0aA+UswTrpHK2uuHgbnFe4rg+
   Euc4MqyuqR+E3QPKj6V/lp3pqQwcP77HfYCachm76LkHZC1k9Of4zVV7i
   YH95QQY9/P0da+JxzDUBcRFxuBXingd8mRdZNDZyRc4QNH9Iwpb+k/I/O
   T4NBhz7oVbWaGm4HLw3KkXgIi+zU8iShJ8q5LABiUMXsluw4rvU6vgefL
   CVWdsbdUvBeOmkC/V14gV/iqVwTCss3yA6Z1s4TFOlZBzIsWgcXax+TIt
   ZIBdO61Han2jpR0AnntRr/Gi/wPbE2wlb7eESHwZ6SQRE41oxWIztjTjF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="371821350"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="371821350"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:43:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="756522804"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="756522804"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:43:00 -0700
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
Date: Thu, 27 Jul 2023 13:41:23 +0800
In-Reply-To: <87y1j2vvqw.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Thu, 27 Jul 2023 14:07:31 +1000")
Message-ID: <87a5vhx664.fsf@yhuang6-desk2.ccr.corp.intel.com>
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
>>>>>> And, I don't think that we are forced to use the general notifier
>>>>>> chain interface in all memory device drivers.  If the memory device
>>>>>> driver has better understanding of the memory device, it can use other
>>>>>> way to determine abstract distance.  For example, a CXL memory device
>>>>>> driver can identify abstract distance by itself.  While other memory
>>>>>> device drivers can use the general notifier chain interface at the
>>>>>> same time.
>>>>>
>>>>> Whilst I think personally I would find that flexibility useful I am
>>>>> concerned it means every driver will just end up divining it's own
>>>>> distance rather than ensuring data in HMAT/CDAT/etc. is correct. That
>>>>> would kind of defeat the purpose of it all then.
>>>>
>>>> But we have no way to enforce that too.
>>>
>>> Enforce that HMAT/CDAT/etc. is correct? Agree we can't enforce it, but
>>> we can influence it. If drivers can easily ignore the notifier chain and
>>> do their own thing that's what will happen.
>>
>> IMHO, both enforce HMAT/CDAT/etc is correct and enforce drivers to use
>> general interface we provided.  Anyway, we should try to make HMAT/CDAT
>> works well, so drivers want to use them :-)
>
> Exactly :-)
>
>>>>>> While other memory device drivers can use the general notifier chain
>>>>>> interface at the same time.
>>>
>>> How would that work in practice though? The abstract distance as far as
>>> I can tell doesn't have any meaning other than establishing preferences
>>> for memory demotion order. Therefore all calculations are relative to
>>> the rest of the calculations on the system. So if a driver does it's own
>>> thing how does it choose a sensible distance? IHMO the value here is in
>>> coordinating all that through a standard interface, whether that is HMAT
>>> or something else.
>>
>> Only if different algorithms follow the same basic principle.  For
>> example, the abstract distance of default DRAM nodes are fixed
>> (MEMTIER_ADISTANCE_DRAM).  The abstract distance of the memory device is
>> in linear direct proportion to the memory latency and inversely
>> proportional to the memory bandwidth.  Use the memory latency and
>> bandwidth of default DRAM nodes as base.
>>
>> HMAT and CDAT report the raw memory latency and bandwidth.  If there are
>> some other methods to report the raw memory latency and bandwidth, we
>> can use them too.
>
> Argh! So we could address my concerns by having drivers feed
> latency/bandwidth numbers into a standard calculation algorithm right?
> Ie. Rather than having drivers calculate abstract distance themselves we
> have the notifier chains return the raw performance data from which the
> abstract distance is derived.

Now, memory device drivers only need a general interface to get the
abstract distance from the NUMA node ID.  In the future, if they need
more interfaces, we can add them.  For example, the interface you
suggested above.

--
Best Regards,
Huang, Ying

