Return-Path: <nvdimm+bounces-6520-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D85C77B1D1
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Aug 2023 08:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67D511C209BA
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Aug 2023 06:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C04063B2;
	Mon, 14 Aug 2023 06:46:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B030A3236
	for <nvdimm@lists.linux.dev>; Mon, 14 Aug 2023 06:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691995613; x=1723531613;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=C0TDfkgSSHw3hPvjktNVzuGscNvAIMHKbLVHz69LTMQ=;
  b=EFK7z9KGXjYZj1FAhX5dLdRTLl4goO568XKd+J/NTSAqWWRrFcsxwpax
   uPSsMwswhwouHmplWXDCX5A20RVnCYeA+HxZpAb8RKR3KY4esX5kHt9UF
   CCj53r0eW+kVzlWkw8WEZi+gDx1nRxRGSCYEHT8SgYpfg5e0P7StmUUKl
   ipa8ZzvbaSLLYozo3Mlfr+v7EdnARRp47/XIyG9gMmdTDGLTNZOzwvAKj
   Bu6IhR+/Uh/jwrt8EhcPUComA0xufer+vandQf10tRWE8GOj/C1OF5n/t
   S2TOZI0Mg7hLU2qc4yGwbBzZQyNR5OqX6ta+WgLZ0mAT6iPuuxrGmFZMH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="356939099"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="356939099"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 23:46:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="847527023"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="847527023"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 23:46:48 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "david@redhat.com" <david@redhat.com>,  "Jiang, Dave"
 <dave.jiang@intel.com>,  "linux-mm@kvack.org" <linux-mm@kvack.org>,
  "osalvador@suse.de" <osalvador@suse.de>,  "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "Williams, Dan J"
 <dan.j.williams@intel.com>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "Jonathan.Cameron@Huawei.com"
 <Jonathan.Cameron@Huawei.com>,  "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>,  "aneesh.kumar@linux.ibm.com"
 <aneesh.kumar@linux.ibm.com>,  "jmoyer@redhat.com" <jmoyer@redhat.com>,
  "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Rapoport
 <rppt@kernel.org>, Bernhard Walle <bernhard.walle@gmx.de>
Subject: Re: [PATCH v2 2/3] mm/memory_hotplug: split memmap_on_memory
 requests across memblocks
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
	<20230720-vv-kmem_memmap-v2-2-88bdaab34993@intel.com>
	<87wmyp26sw.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<abe41c22f72ad600541c6f2b199180b1cbcbb780.camel@intel.com>
Date: Mon, 14 Aug 2023 14:45:11 +0800
In-Reply-To: <abe41c22f72ad600541c6f2b199180b1cbcbb780.camel@intel.com>
	(Vishal L. Verma's message of "Wed, 2 Aug 2023 14:08:20 +0800")
Message-ID: <87jzty9l6w.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Mon, 2023-07-24 at 13:54 +0800, Huang, Ying wrote:
>> Vishal Verma <vishal.l.verma@intel.com> writes:
>>
>> >
>> > @@ -2035,12 +2056,38 @@ void try_offline_node(int nid)
>> >  }
>> >  EXPORT_SYMBOL(try_offline_node);
>> >
>> > -static int __ref try_remove_memory(u64 start, u64 size)
>> > +static void __ref __try_remove_memory(int nid, u64 start, u64 size,
>> > +                                    struct vmem_altmap *altmap)
>> >  {
>> > -       struct vmem_altmap mhp_altmap = {};
>> > -       struct vmem_altmap *altmap = NULL;
>> > -       unsigned long nr_vmemmap_pages;
>> > -       int rc = 0, nid = NUMA_NO_NODE;
>> > +       /* remove memmap entry */
>> > +       firmware_map_remove(start, start + size, "System RAM");
>>
>> If mhp_supports_memmap_on_memory(), we will call
>> firmware_map_add_hotplug() for whole range.  But here we may call
>> firmware_map_remove() for part of range.  Is it OK?
>>
>
> Good point, this is a discrepancy in the add vs remove path. Can the
> firmware memmap entries be moved up a bit in the add path, and is it
> okay to create these for each memblock? Or should these be for the
> whole range? I'm not familiar with the implications. (I've left it as
> is for v3 for now, but depending on the direction I can update in a
> future rev).

Cced more firmware map developers and maintainers.

Per my understanding, we should create one firmware memmap entry for
each memblock.

--
Best Regards,
Huang, Ying

