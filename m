Return-Path: <nvdimm+bounces-6413-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DF37644C3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jul 2023 06:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 736FD282066
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jul 2023 04:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4088A1C27;
	Thu, 27 Jul 2023 04:04:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F3E185C
	for <nvdimm@lists.linux.dev>; Thu, 27 Jul 2023 04:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690430647; x=1721966647;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=1XoGj8bNfPfHorVioZIXPSWtmymYw6ZsZ+nFjl0sK1I=;
  b=GlYvQfLTvIMrcKVcbf/C4OhzxsCVy6IQdxJmLYZ5UCCHaTYMQFaoH4qe
   Cl0LQpfHHtqYoFfSDCky3gcAzSQhDBb+lyRsDVKXttWeEVoxazI04W01p
   1l8ZCsyyjeIG1gybx5AmsbRpAffYdYgZwEhK/UNM9xdWxK59S8e/y/4p/
   WYk1MTby6znbO4JFJ08YBmJy0Iz2wgRadAiADpFguYRAs4tNRa02C8GGd
   A5tYznZXahnLZr4nbcbhwJVNbqRECPCWdfg4Dz1Tycjp7UR9tsE3RriyY
   BTAvjMkGWvCEe7SN2XqLrrEXGVxihmhmNyMibMqNsMxNL/L/FhT0hGgaF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="431996249"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="431996249"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 21:04:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="900707817"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="900707817"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 21:04:02 -0700
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
Date: Thu, 27 Jul 2023 12:02:25 +0800
In-Reply-To: <87351axbk6.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Thu, 27 Jul 2023 13:42:15 +1000")
Message-ID: <87edkuvw6m.fsf@yhuang6-desk2.ccr.corp.intel.com>
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
>>>> The other way (suggested by this series) is to make dax/kmem call a
>>>> notifier chain, then CXL CDAT or ACPI HMAT can identify the type of
>>>> device and calculate the distance if the type is correct for them.  I
>>>> don't think that it's good to make dax/kem to know every possible
>>>> types of memory devices.
>>>
>>> Do we expect there to be lots of different types of memory devices
>>> sharing a common dax/kmem driver though? Must admit I'm coming from a
>>> GPU background where we'd expect each type of device to have it's own
>>> driver anyway so wasn't expecting different types of memory devices to
>>> be handled by the same driver.
>>
>> Now, dax/kmem.c is used for
>>
>> - PMEM (Optane DCPMM, or AEP)
>> - CXL.mem
>> - HBM (attached to CPU)
>
> Thanks a lot for the background! I will admit to having a faily narrow
> focus here.
>
>>>> And, I don't think that we are forced to use the general notifier
>>>> chain interface in all memory device drivers.  If the memory device
>>>> driver has better understanding of the memory device, it can use other
>>>> way to determine abstract distance.  For example, a CXL memory device
>>>> driver can identify abstract distance by itself.  While other memory
>>>> device drivers can use the general notifier chain interface at the
>>>> same time.
>>>
>>> Whilst I think personally I would find that flexibility useful I am
>>> concerned it means every driver will just end up divining it's own
>>> distance rather than ensuring data in HMAT/CDAT/etc. is correct. That
>>> would kind of defeat the purpose of it all then.
>>
>> But we have no way to enforce that too.
>
> Enforce that HMAT/CDAT/etc. is correct? Agree we can't enforce it, but
> we can influence it. If drivers can easily ignore the notifier chain and
> do their own thing that's what will happen.

IMHO, both enforce HMAT/CDAT/etc is correct and enforce drivers to use
general interface we provided.  Anyway, we should try to make HMAT/CDAT
works well, so drivers want to use them :-)

>>>> While other memory device drivers can use the general notifier chain
>>>> interface at the same time.
>
> How would that work in practice though? The abstract distance as far as
> I can tell doesn't have any meaning other than establishing preferences
> for memory demotion order. Therefore all calculations are relative to
> the rest of the calculations on the system. So if a driver does it's own
> thing how does it choose a sensible distance? IHMO the value here is in
> coordinating all that through a standard interface, whether that is HMAT
> or something else.

Only if different algorithms follow the same basic principle.  For
example, the abstract distance of default DRAM nodes are fixed
(MEMTIER_ADISTANCE_DRAM).  The abstract distance of the memory device is
in linear direct proportion to the memory latency and inversely
proportional to the memory bandwidth.  Use the memory latency and
bandwidth of default DRAM nodes as base.

HMAT and CDAT report the raw memory latency and bandwidth.  If there are
some other methods to report the raw memory latency and bandwidth, we
can use them too.

--
Best Regards,
Huang, Ying

