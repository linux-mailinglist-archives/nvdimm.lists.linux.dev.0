Return-Path: <nvdimm+bounces-6851-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7A47DB221
	for <lists+linux-nvdimm@lfdr.de>; Mon, 30 Oct 2023 03:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3CFD2813D6
	for <lists+linux-nvdimm@lfdr.de>; Mon, 30 Oct 2023 02:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34D4EBD;
	Mon, 30 Oct 2023 02:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHPvBEOc"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E052D364
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 02:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698634095; x=1730170095;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=NcH0XnP6VoshU9abBq6Ta+z+6AM7rwOc9BoEsxOjEI8=;
  b=aHPvBEOcF8UNnYyVrNSDnTk34xvwbG1P7Ds5/6DwXehvM2MNWvlsYHNj
   r9A0vN9ypdQ0/1mPjm5QRrvySWzXEprPcAoAsv47IciVucku/1oCpatiB
   5hgnlDo9qpBaUZQfHb93//W9vbk5dB/vsylVgguShRJUNvH93bgLcjOFy
   ahvWa1DmiMR5aHqJhsool5qYm9f65nUev8eNgnCo1bnsjie9gTUq6r8br
   Iv2hmiRFxBa/2CU2c0+FGOSpGIVSpMs1hN3/xYKQvQclvEqDwLSKV1cOF
   +MD/1iGVZdiJHxg0cyWByG1/U+hh3JuO4sqcEJIbdipg6SM8DExsmsIuq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="367347171"
X-IronPort-AV: E=Sophos;i="6.03,262,1694761200"; 
   d="scan'208";a="367347171"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 19:48:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="760135503"
X-IronPort-AV: E=Sophos;i="6.03,262,1694761200"; 
   d="scan'208";a="760135503"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 19:48:10 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  Oscar Salvador <osalvador@suse.de>,  Dan Williams
 <dan.j.williams@intel.com>,  Dave Jiang <dave.jiang@intel.com>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <nvdimm@lists.linux.dev>,  <linux-cxl@vger.kernel.org>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  "Aneesh Kumar K.V"
 <aneesh.kumar@linux.ibm.com>,  Michal Hocko <mhocko@suse.com>,  Jonathan
 Cameron <Jonathan.Cameron@Huawei.com>,  Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v7 2/3] mm/memory_hotplug: split memmap_on_memory
 requests across memblocks
In-Reply-To: <20231025-vv-kmem_memmap-v7-2-4a76d7652df5@intel.com> (Vishal
	Verma's message of "Wed, 25 Oct 2023 16:44:34 -0600")
References: <20231025-vv-kmem_memmap-v7-0-4a76d7652df5@intel.com>
	<20231025-vv-kmem_memmap-v7-2-4a76d7652df5@intel.com>
Date: Mon, 30 Oct 2023 10:46:08 +0800
Message-ID: <875y2oddzj.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Vishal Verma <vishal.l.verma@intel.com> writes:

> The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is restricted to
> 'memblock_size' chunks of memory being added. Adding a larger span of
> memory precludes memmap_on_memory semantics.
>
> For users of hotplug such as kmem, large amounts of memory might get
> added from the CXL subsystem. In some cases, this amount may exceed the
> available 'main memory' to store the memmap for the memory being added.
> In this case, it is useful to have a way to place the memmap on the
> memory being added, even if it means splitting the addition into
> memblock-sized chunks.
>
> Change add_memory_resource() to loop over memblock-sized chunks of
> memory if caller requested memmap_on_memory, and if other conditions for
> it are met. Teach try_remove_memory() to also expect that a memory
> range being removed might have been split up into memblock sized chunks,
> and to loop through those as needed.
>
> This does preclude being able to use PUD mappings in the direct map; a
> proposal to how this could be optimized in the future is laid out
> here[1].
>
> [1]: https://lore.kernel.org/linux-mm/b6753402-2de9-25b2-36e9-eacd49752b19@redhat.com/
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  mm/memory_hotplug.c | 209 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 144 insertions(+), 65 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6be7de9efa55..b97035193090 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1380,6 +1380,48 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>  	return arch_supports_memmap_on_memory(vmemmap_size);
>  }
>  
> +static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
> +					    u64 start, u64 size)
> +{
> +	unsigned long memblock_size = memory_block_size_bytes();
> +	u64 cur_start;
> +	int ret;
> +
> +	for (cur_start = start; cur_start < start + size;
> +	     cur_start += memblock_size) {
> +		struct mhp_params params = { .pgprot =
> +						     pgprot_mhp(PAGE_KERNEL) };
> +		struct vmem_altmap mhp_altmap = {
> +			.base_pfn = PHYS_PFN(cur_start),
> +			.end_pfn = PHYS_PFN(cur_start + memblock_size - 1),
> +		};
> +
> +		mhp_altmap.free = memory_block_memmap_on_memory_pages();
> +		params.altmap = kmemdup(&mhp_altmap, sizeof(struct vmem_altmap),
> +					GFP_KERNEL);
> +		if (!params.altmap)
> +			return -ENOMEM;
> +
> +		/* call arch's memory hotadd */
> +		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
> +		if (ret < 0) {
> +			kfree(params.altmap);

Should we call

        remove_memory_blocks_and_altmaps(start, cur_start - start);

here to clean up resources?

--
Best Regards,
Huang, Ying

> +			return ret;
> +		}
> +
> +		/* create memory block devices after memory was added */
> +		ret = create_memory_block_devices(cur_start, memblock_size,
> +						  params.altmap, group);
> +		if (ret) {
> +			arch_remove_memory(cur_start, memblock_size, NULL);
> +			kfree(params.altmap);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
>   * and online/offline operations (triggered e.g. by sysfs).
> @@ -1390,10 +1432,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  {
>  	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
> -	struct vmem_altmap mhp_altmap = {
> -		.base_pfn =  PHYS_PFN(res->start),
> -		.end_pfn  =  PHYS_PFN(res->end),
> -	};
>  	struct memory_group *group = NULL;
>  	u64 start, size;
>  	bool new_node = false;
> @@ -1436,28 +1474,22 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	/*
>  	 * Self hosted memmap array
>  	 */
> -	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
> -		if (mhp_supports_memmap_on_memory(size)) {
> -			mhp_altmap.free = memory_block_memmap_on_memory_pages();
> -			params.altmap = kmemdup(&mhp_altmap,
> -						sizeof(struct vmem_altmap),
> -						GFP_KERNEL);
> -			if (!params.altmap)
> -				goto error;
> +	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
> +	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
> +		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
> +		if (ret)
> +			goto error;
> +	} else {
> +		ret = arch_add_memory(nid, start, size, &params);
> +		if (ret < 0)
> +			goto error;
> +
> +		/* create memory block devices after memory was added */
> +		ret = create_memory_block_devices(start, size, NULL, group);
> +		if (ret) {
> +			arch_remove_memory(start, size, NULL);
> +			goto error;
>  		}
> -		/* fallback to not using altmap  */
> -	}
> -
> -	/* call arch's memory hotadd */
> -	ret = arch_add_memory(nid, start, size, &params);
> -	if (ret < 0)
> -		goto error_free;
> -
> -	/* create memory block devices after memory was added */
> -	ret = create_memory_block_devices(start, size, params.altmap, group);
> -	if (ret) {
> -		arch_remove_memory(start, size, NULL);
> -		goto error_free;
>  	}
>  
>  	if (new_node) {
> @@ -1494,8 +1526,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  		walk_memory_blocks(start, size, NULL, online_memory_block);
>  
>  	return ret;
> -error_free:
> -	kfree(params.altmap);
>  error:
>  	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
>  		memblock_remove(start, size);
> @@ -2076,6 +2106,16 @@ static int test_has_altmap_cb(struct memory_block *mem, void *arg)
>  	return 0;
>  }
>  
> +static int count_memory_range_altmaps_cb(struct memory_block *mem, void *arg)
> +{
> +	u64 *num_altmaps = (u64 *)arg;
> +
> +	if (mem->altmap)
> +		*num_altmaps += 1;
> +
> +	return 0;
> +}
> +
>  static int check_cpu_on_node(int nid)
>  {
>  	int cpu;
> @@ -2146,11 +2186,69 @@ void try_offline_node(int nid)
>  }
>  EXPORT_SYMBOL(try_offline_node);
>  
> -static int __ref try_remove_memory(u64 start, u64 size)
> +static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
>  {
> -	struct memory_block *mem;
> -	int rc = 0, nid = NUMA_NO_NODE;
> +	unsigned long memblock_size = memory_block_size_bytes();
>  	struct vmem_altmap *altmap = NULL;
> +	struct memory_block *mem;
> +	u64 cur_start;
> +	int rc;
> +
> +	/*
> +	 * For memmap_on_memory, the altmaps could have been added on
> +	 * a per-memblock basis. Loop through the entire range if so,
> +	 * and remove each memblock and its altmap.
> +	 */
> +	for (cur_start = start; cur_start < start + size;
> +	     cur_start += memblock_size) {
> +		rc = walk_memory_blocks(cur_start, memblock_size, &mem,
> +					test_has_altmap_cb);
> +		if (rc) {
> +			altmap = mem->altmap;
> +			/*
> +			 * Mark altmap NULL so that we can add a debug
> +			 * check on memblock free.
> +			 */
> +			mem->altmap = NULL;
> +		}
> +
> +		remove_memory_block_devices(cur_start, memblock_size);
> +
> +		arch_remove_memory(cur_start, memblock_size, altmap);
> +
> +		/* Verify that all vmemmap pages have actually been freed. */
> +		if (altmap) {
> +			WARN(altmap->alloc, "Altmap not fully unmapped");
> +			kfree(altmap);
> +		}
> +	}
> +}
> +
> +static int memory_blocks_have_altmaps(u64 start, u64 size)
> +{
> +	u64 num_memblocks = size / memory_block_size_bytes();
> +	u64 num_altmaps = 0;
> +
> +	if (!mhp_memmap_on_memory())
> +		return 0;
> +
> +	walk_memory_blocks(start, size, &num_altmaps,
> +			   count_memory_range_altmaps_cb);
> +
> +	if (num_altmaps == 0)
> +		return 0;
> +
> +	if (num_memblocks != num_altmaps) {
> +		WARN_ONCE(1, "Not all memblocks in range have altmaps");
> +		return -EINVAL;
> +	}
> +
> +	return 1;
> +}
> +
> +static int __ref try_remove_memory(u64 start, u64 size)
> +{
> +	int rc, nid = NUMA_NO_NODE;
>  
>  	BUG_ON(check_hotplug_memory_range(start, size));
>  
> @@ -2167,45 +2265,25 @@ static int __ref try_remove_memory(u64 start, u64 size)
>  	if (rc)
>  		return rc;
>  
> -	/*
> -	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
> -	 * the same granularity it was added - a single memory block.
> -	 */
> -	if (mhp_memmap_on_memory()) {
> -		rc = walk_memory_blocks(start, size, &mem, test_has_altmap_cb);
> -		if (rc) {
> -			if (size != memory_block_size_bytes()) {
> -				pr_warn("Refuse to remove %#llx - %#llx,"
> -					"wrong granularity\n",
> -					start, start + size);
> -				return -EINVAL;
> -			}
> -			altmap = mem->altmap;
> -			/*
> -			 * Mark altmap NULL so that we can add a debug
> -			 * check on memblock free.
> -			 */
> -			mem->altmap = NULL;
> -		}
> -	}
> -
>  	/* remove memmap entry */
>  	firmware_map_remove(start, start + size, "System RAM");
>  
> -	/*
> -	 * Memory block device removal under the device_hotplug_lock is
> -	 * a barrier against racing online attempts.
> -	 */
> -	remove_memory_block_devices(start, size);
> -
>  	mem_hotplug_begin();
>  
> -	arch_remove_memory(start, size, altmap);
> -
> -	/* Verify that all vmemmap pages have actually been freed. */
> -	if (altmap) {
> -		WARN(altmap->alloc, "Altmap not fully unmapped");
> -		kfree(altmap);
> +	rc = memory_blocks_have_altmaps(start, size);
> +	if (rc < 0) {
> +		goto err;
> +	} else if (rc == 0) {
> +		/*
> +		 * Memory block device removal under the device_hotplug_lock is
> +		 * a barrier against racing online attempts.
> +		 * No altmaps present, do the removal directly
> +		 */
> +		remove_memory_block_devices(start, size);
> +		arch_remove_memory(start, size, NULL);
> +	} else {
> +		/* all memblocks in the range have altmaps */
> +		remove_memory_blocks_and_altmaps(start, size);
>  	}
>  
>  	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
> @@ -2218,8 +2296,9 @@ static int __ref try_remove_memory(u64 start, u64 size)
>  	if (nid != NUMA_NO_NODE)
>  		try_offline_node(nid);
>  
> +err:
>  	mem_hotplug_done();
> -	return 0;
> +	return (rc < 0 ? rc : 0);
>  }
>  
>  /**

