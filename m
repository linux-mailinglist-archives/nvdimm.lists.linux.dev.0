Return-Path: <nvdimm+bounces-6519-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A0F77B112
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Aug 2023 08:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C479F280F9D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Aug 2023 06:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8569063B2;
	Mon, 14 Aug 2023 06:06:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78025687
	for <nvdimm@lists.linux.dev>; Mon, 14 Aug 2023 06:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691993173; x=1723529173;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=igwqY+DlLN1XbqdBe2kVLRnBm1tJGTmIQMvEm+2XvxA=;
  b=RNGQ0sitM+oj0a0ZNSahtoOMhnatE0nkGahWMiAr84aODzsULDwxD3MQ
   BoE1EdkSrwsLEW/mfM6+xf7MBaGtTWaZhL/4PsJc874GVQ8DDnbpGoxWY
   FbXK+h/JeST/DOPc/k0M7yGRjG2eFYqj23uSAH0dSqHjFuOzw8psUl/Yp
   7fP4dybVD6jI0UziPqq1RrubiTJ96UV1HqiUWFtVZMPlPAoRFZyR6m2tq
   VhfQh7qzq14NInTf+xVW9TMXjIoJ5l9+ZC0/ddrARrrzQWHZw3SPNvyp/
   qsjTywc6s5ZOBA4d0dJ9uRtVT8WDTXs6lj61jQAzk5v8pA5TBfxr+tfRo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="458333709"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="458333709"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 23:06:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="710214230"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="710214230"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 23:06:09 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
  "david@redhat.com" <david@redhat.com>,  "Jiang, Dave"
 <dave.jiang@intel.com>,  "linux-mm@kvack.org" <linux-mm@kvack.org>,
  "osalvador@suse.de" <osalvador@suse.de>,  "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "Williams, Dan J"
 <dan.j.williams@intel.com>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "Jonathan.Cameron@Huawei.com"
 <Jonathan.Cameron@Huawei.com>,  "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>,  "jmoyer@redhat.com" <jmoyer@redhat.com>,
  "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] mm/memory_hotplug: split memmap_on_memory
 requests across memblocks
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
	<20230720-vv-kmem_memmap-v2-2-88bdaab34993@intel.com>
	<87a5vmadcw.fsf@linux.ibm.com>
	<87351e2e43.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<e3c253709ff5fd6a456d4b28b94b8a8a6b12be44.camel@intel.com>
Date: Mon, 14 Aug 2023 14:04:31 +0800
In-Reply-To: <e3c253709ff5fd6a456d4b28b94b8a8a6b12be44.camel@intel.com>
	(Vishal L. Verma's message of "Wed, 2 Aug 2023 14:02:12 +0800")
Message-ID: <87o7ja9n2o.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Mon, 2023-07-24 at 11:16 +0800, Huang, Ying wrote:
>> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>> >
>> > > @@ -1339,27 +1367,20 @@ int __ref add_memory_resource(int nid,
>> > > struct resource *res, mhp_t mhp_flags)
>> > >         /*
>> > >          * Self hosted memmap array
>> > >          */
>> > > -       if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
>> > > -               if (!mhp_supports_memmap_on_memory(size)) {
>> > > -                       ret = -EINVAL;
>> > > +       if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
>> > > +           mhp_supports_memmap_on_memory(memblock_size)) {
>> > > +               for (cur_start = start; cur_start < start + size;
>> > > +                    cur_start += memblock_size) {
>> > > +                       ret = add_memory_create_devices(nid,
>> > > group, cur_start,
>> > > +                                                       memblock_
>> > > size,
>> > > +                                                       mhp_flags
>> > > );
>> > > +                       if (ret)
>> > > +                               goto error;
>> > > +               }
>> >
>> > We should handle the below error details here.
>> >
>> > 1) If we hit an error after some blocks got added, should we
>> > iterate over rest of the dev_dax->nr_range.
>> > 2) With some blocks added if we return a failure here, we remove
>> > the
>> > resource in dax_kmem. Is that ok?
>> >
>> > IMHO error handling with partial creation of memory blocks in a
>> > resource range should be
>> > documented with this change.
>>
>> Or, should we remove all added memory blocks upon error?
>>
> I didn't address these in v3 - I wasn't sure how we'd proceed here.
> Something obviously went very wrong and I'd imagine it is okay if this
> memory is unusable as a result.
>
> What woyuld removing the blocks we added look like? Just call
> try_remove_memory() from the error path in add_memory_resource()? (for
> a range of [start, cur_start) ?

I guess that we can just keep the original behavior.  Originally, if
something goes wrong, arch_remove_memory() and remove_memory_block() (in
create_memory_block_devices()) will be called for all added memory
range.  So, we should do that too?

--
Best Regards,
Huang, Ying

