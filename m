Return-Path: <nvdimm+bounces-6852-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F447DB22C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 30 Oct 2023 03:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFB24B20CCC
	for <lists+linux-nvdimm@lfdr.de>; Mon, 30 Oct 2023 02:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A21EC2;
	Mon, 30 Oct 2023 02:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UXxupA7o"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F17364
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 02:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698634789; x=1730170789;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=C2HcoC4EHeUL7hfMNJTjDHQJVbGTY6+k0Z4WjLTThtw=;
  b=UXxupA7o3Aw38EeL+5HO3RdPGdpLID1r7U7jeGTCT7LXyj4rOkWX13mn
   fUeNtD4ATZ7X/huk3/YMB1VkWSOtpJMgzXAruOh1w6BlV0UwN1b9YgQ6x
   DeN2QBYqSG4Ooxq938c3pRQDPY2LDM0PqD3pQUHeU2is52cTfHF6SQdVu
   YA7dJDn2MK0FRT4ARpbXs56Y9tUoHlOXfzqzmOuWV9jxN57TT33R3IFfb
   wv+1hE2sDLfkZDJolS/RPyKKbBQ74RNSwvdCZP/KEgzeDDD88WFz5bLKL
   XDZUPDnM2JVVxS6Iur005zeFM52QtfbkgbEbqwKNf79gIDYT/suo80LUX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="387817401"
X-IronPort-AV: E=Sophos;i="6.03,262,1694761200"; 
   d="scan'208";a="387817401"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 19:59:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,262,1694761200"; 
   d="scan'208";a="1386390"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 19:59:31 -0700
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
Subject: Re: [PATCH v7 3/3] dax/kmem: allow kmem to add memory with
 memmap_on_memory
In-Reply-To: <20231025-vv-kmem_memmap-v7-3-4a76d7652df5@intel.com> (Vishal
	Verma's message of "Wed, 25 Oct 2023 16:44:35 -0600")
References: <20231025-vv-kmem_memmap-v7-0-4a76d7652df5@intel.com>
	<20231025-vv-kmem_memmap-v7-3-4a76d7652df5@intel.com>
Date: Mon, 30 Oct 2023 10:57:42 +0800
Message-ID: <871qdcddg9.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Vishal Verma <vishal.l.verma@intel.com> writes:

> Large amounts of memory managed by the kmem driver may come in via CXL,
> and it is often desirable to have the memmap for this memory on the new
> memory itself.
>
> Enroll kmem-managed memory for memmap_on_memory semantics if the dax
> region originates via CXL. For non-CXL dax regions, retain the existing
> default behavior of hot adding without memmap_on_memory semantics.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM, Thanks!

Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

> ---
>  drivers/dax/bus.h         | 1 +
>  drivers/dax/dax-private.h | 1 +
>  drivers/dax/bus.c         | 3 +++
>  drivers/dax/cxl.c         | 1 +
>  drivers/dax/hmem/hmem.c   | 1 +
>  drivers/dax/kmem.c        | 8 +++++++-
>  drivers/dax/pmem.c        | 1 +
>  7 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 1ccd23360124..cbbf64443098 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -23,6 +23,7 @@ struct dev_dax_data {
>  	struct dev_pagemap *pgmap;
>  	resource_size_t size;
>  	int id;
> +	bool memmap_on_memory;
>  };
>  
>  struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 27cf2daaaa79..446617b73aea 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -70,6 +70,7 @@ struct dev_dax {
>  	struct ida ida;
>  	struct device dev;
>  	struct dev_pagemap *pgmap;
> +	bool memmap_on_memory;
>  	int nr_range;
>  	struct dev_dax_range {
>  		unsigned long pgoff;
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 0ee96e6fc426..ad9f821b8c78 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -367,6 +367,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
>  			.dax_region = dax_region,
>  			.size = 0,
>  			.id = -1,
> +			.memmap_on_memory = false,
>  		};
>  		struct dev_dax *dev_dax = devm_create_dev_dax(&data);
>  
> @@ -1400,6 +1401,8 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	dev_dax->align = dax_region->align;
>  	ida_init(&dev_dax->ida);
>  
> +	dev_dax->memmap_on_memory = data->memmap_on_memory;
> +
>  	inode = dax_inode(dax_dev);
>  	dev->devt = inode->i_rdev;
>  	dev->bus = &dax_bus_type;
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 8bc9d04034d6..c696837ab23c 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -26,6 +26,7 @@ static int cxl_dax_region_probe(struct device *dev)
>  		.dax_region = dax_region,
>  		.id = -1,
>  		.size = range_len(&cxlr_dax->hpa_range),
> +		.memmap_on_memory = true,
>  	};
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 5d2ddef0f8f5..b9da69f92697 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -36,6 +36,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
>  		.dax_region = dax_region,
>  		.id = -1,
>  		.size = region_idle ? 0 : range_len(&mri->range),
> +		.memmap_on_memory = false,
>  	};
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index c57acb73e3db..0aa6c45a4e5a 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -12,6 +12,7 @@
>  #include <linux/mm.h>
>  #include <linux/mman.h>
>  #include <linux/memory-tiers.h>
> +#include <linux/memory_hotplug.h>
>  #include "dax-private.h"
>  #include "bus.h"
>  
> @@ -56,6 +57,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	unsigned long total_len = 0;
>  	struct dax_kmem_data *data;
>  	int i, rc, mapped = 0;
> +	mhp_t mhp_flags;
>  	int numa_node;
>  
>  	/*
> @@ -136,12 +138,16 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		 */
>  		res->flags = IORESOURCE_SYSTEM_RAM;
>  
> +		mhp_flags = MHP_NID_IS_MGID;
> +		if (dev_dax->memmap_on_memory)
> +			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
> +
>  		/*
>  		 * Ensure that future kexec'd kernels will not treat
>  		 * this as RAM automatically.
>  		 */
>  		rc = add_memory_driver_managed(data->mgid, range.start,
> -				range_len(&range), kmem_name, MHP_NID_IS_MGID);
> +				range_len(&range), kmem_name, mhp_flags);
>  
>  		if (rc) {
>  			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index ae0cb113a5d3..f3c6c67b8412 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  		.id = id,
>  		.pgmap = &pgmap,
>  		.size = range_len(&range),
> +		.memmap_on_memory = false,
>  	};
>  
>  	return devm_create_dev_dax(&data);

