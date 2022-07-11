Return-Path: <nvdimm+bounces-4097-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F2B561804
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 12:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 30B442E0A82
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 10:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1100DED4;
	Thu, 30 Jun 2022 10:35:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2A37B;
	Thu, 30 Jun 2022 10:35:54 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYZRq52g8z680Ry;
	Thu, 30 Jun 2022 18:33:27 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 12:35:50 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 11:35:49 +0100
Date: Thu, 30 Jun 2022 11:35:48 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>, "Jason
 Gunthorpe" <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>, "Christoph
 Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 33/46] resource: Introduce alloc_free_mem_region()
Message-ID: <20220630113548.000036e8@Huawei.com>
In-Reply-To: <20220624041950.559155-8-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-8-dan.j.williams@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.200.250]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 21:19:37 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The core of devm_request_free_mem_region() is a helper that searches for
> free space in iomem_resource and performs __request_region_locked() on
> the result of that search. The policy choices of the implementation
> conform to what CONFIG_DEVICE_PRIVATE users want which is memory that is
> immediately marked busy, and a preference to search for the first-fit
> free range in descending order from the top of the physical address
> space.
> 
> CXL has a need for a similar allocator, but with the following tweaks:
> 
> 1/ Search for free space in ascending order
> 
> 2/ Search for free space relative to a given CXL window
> 
> 3/ 'insert' rather than 'request' the new resource given downstream
>    drivers from the CXL Region driver (like the pmem or dax drivers) are
>    responsible for request_mem_region() when they activate the memory
>    range.
> 
> Rework __request_free_mem_region() into get_free_mem_region() which
> takes a set of GFR_* (Get Free Region) flags to control the allocation
> policy (ascending vs descending), and "busy" policy (insert_resource()
> vs request_region()).
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-cxl/20220420143406.GY2120790@nvidia.com/
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

A few things inline,

Thanks,

Jonathan

> ---
>  include/linux/ioport.h |   2 +
>  kernel/resource.c      | 174 ++++++++++++++++++++++++++++++++---------
>  mm/Kconfig             |   5 ++
>  3 files changed, 146 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index ec5f71f7135b..ed03518347aa 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -329,6 +329,8 @@ struct resource *devm_request_free_mem_region(struct device *dev,
>  		struct resource *base, unsigned long size);
>  struct resource *request_free_mem_region(struct resource *base,
>  		unsigned long size, const char *name);
> +struct resource *alloc_free_mem_region(struct resource *base,
> +		unsigned long size, unsigned long align, const char *name);
>  
>  static inline void irqresource_disabled(struct resource *res, u32 irq)
>  {
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 53a534db350e..9fc990274106 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c


> +static bool gfr_continue(struct resource *base, resource_size_t addr,
> +			 resource_size_t size, unsigned long flags)
> +{
> +	if (flags & GFR_DESCENDING)
> +		return addr > size && addr >= base->start;
> +	return addr > addr - size &&

Is this checking for wrap around?  If so maybe a comment to call that out?

> +	       addr <= min_t(resource_size_t, base->end,
> +			     (1ULL << MAX_PHYSMEM_BITS) - 1);
> +}
> +
> +static resource_size_t gfr_next(resource_size_t addr, resource_size_t size,
> +				unsigned long flags)
> +{
> +	if (flags & GFR_DESCENDING)
> +		return addr - size;
> +	return addr + size;
> +}
> +
> +static void remove_free_mem_region(void *_res)
>  {
> -	resource_size_t end, addr;
> +	struct resource *res = _res;
> +
> +	if (res->parent)
> +		remove_resource(res);
> +	free_resource(res);
> +}
> +
> +static struct resource *
> +get_free_mem_region(struct device *dev, struct resource *base,
> +		    resource_size_t size, const unsigned long align,
> +		    const char *name, const unsigned long desc,
> +		    const unsigned long flags)
> +{
> +	resource_size_t addr;
>  	struct resource *res;
>  	struct region_devres *dr = NULL;
>  
> -	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
> -	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
> -	addr = end - size + 1UL;
> +	size = ALIGN(size, align);
>  
>  	res = alloc_resource(GFP_KERNEL);
>  	if (!res)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (dev) {
> +	if (dev && (flags & GFR_REQUEST_REGION)) {
>  		dr = devres_alloc(devm_region_release,
>  				sizeof(struct region_devres), GFP_KERNEL);
>  		if (!dr) {
>  			free_resource(res);
>  			return ERR_PTR(-ENOMEM);
>  		}
> +	} else if (dev) {
> +		if (devm_add_action_or_reset(dev, remove_free_mem_region, res))
> +			return ERR_PTR(-ENOMEM);

slightly nicer to return whatever value you got back from devm_add_action_or_reset()

>  	}
>  
>  	write_lock(&resource_lock);
> -	for (; addr > size && addr >= base->start; addr -= size) {
> -		if (__region_intersects(addr, size, 0, IORES_DESC_NONE) !=
> -				REGION_DISJOINT)
> +	for (addr = gfr_start(base, size, align, flags);
> +	     gfr_continue(base, addr, size, flags);
> +	     addr = gfr_next(addr, size, flags)) {
> +		if (__region_intersects(base, addr, size, 0, IORES_DESC_NONE) !=
> +		    REGION_DISJOINT)
>  			continue;
>  
> -		if (__request_region_locked(res, &iomem_resource, addr, size,
> -						name, 0))
> -			break;
> +		if (flags & GFR_REQUEST_REGION) {
> +			if (__request_region_locked(res, &iomem_resource, addr,
> +						    size, name, 0))
> +				break;
>  
> -		if (dev) {
> -			dr->parent = &iomem_resource;
> -			dr->start = addr;
> -			dr->n = size;
> -			devres_add(dev, dr);
> -		}
> +			if (dev) {
> +				dr->parent = &iomem_resource;
> +				dr->start = addr;
> +				dr->n = size;
> +				devres_add(dev, dr);
> +			}
>  
> -		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
> -		write_unlock(&resource_lock);
> +			res->desc = desc;
> +			write_unlock(&resource_lock);
> +
> +
> +			/*
> +			 * A driver is claiming this region so revoke any
> +			 * mappings.
> +			 */
> +			revoke_iomem(res);
> +		} else {
> +			res->start = addr;
> +			res->end = addr + size - 1;
> +			res->name = name;
> +			res->desc = desc;
> +			res->flags = IORESOURCE_MEM;
> +
> +			/*
> +			 * Only succeed if the resource hosts an exclusive
> +			 * range after the insert
> +			 */
> +			if (__insert_resource(base, res) || res->child)
> +				break;
> +
> +			write_unlock(&resource_lock);
> +		}
>  
> -		/*
> -		 * A driver is claiming this region so revoke any mappings.
> -		 */
> -		revoke_iomem(res);
>  		return res;
>  	}
>  	write_unlock(&resource_lock);
>  
> -	free_resource(res);
> -	if (dr)
> +	if (flags & GFR_REQUEST_REGION) {
> +		free_resource(res);
>  		devres_free(dr);

The original if (dr) was unnecessary as devres_free() checks.

Looking just at this patch it looks like you aren't covering the
corner case of dev == NULL and GFR_REQUEST_REGION.

Perhaps worth a tiny comment in patch description? (doesn't seem worth
pulling this change out as a precursor given it's so small).
Of add the extra if (dr) back in to 'document' that no change...


> +	} else if (dev)
> +		devm_release_action(dev, remove_free_mem_region, res);
>  
>  	return ERR_PTR(-ERANGE);
>  }
> @@ -1854,18 +1928,48 @@ static struct resource *__request_free_mem_region(struct device *dev,
>  struct resource *devm_request_free_mem_region(struct device *dev,
>  		struct resource *base, unsigned long size)
>  {
> -	return __request_free_mem_region(dev, base, size, dev_name(dev));
> +	unsigned long flags = GFR_DESCENDING | GFR_REQUEST_REGION;
> +
> +	return get_free_mem_region(dev, base, size, GFR_DEFAULT_ALIGN,
> +				   dev_name(dev),
> +				   IORES_DESC_DEVICE_PRIVATE_MEMORY, flags);
>  }
>  EXPORT_SYMBOL_GPL(devm_request_free_mem_region);
>  
>  struct resource *request_free_mem_region(struct resource *base,
>  		unsigned long size, const char *name)
>  {
> -	return __request_free_mem_region(NULL, base, size, name);
> +	unsigned long flags = GFR_DESCENDING | GFR_REQUEST_REGION;
> +
> +	return get_free_mem_region(NULL, base, size, GFR_DEFAULT_ALIGN, name,
> +				   IORES_DESC_DEVICE_PRIVATE_MEMORY, flags);
>  }
>  EXPORT_SYMBOL_GPL(request_free_mem_region);
>  
> -#endif /* CONFIG_DEVICE_PRIVATE */
> +/**
> + * alloc_free_mem_region - find a free region relative to @base
> + * @base: resource that will parent the new resource
> + * @size: size in bytes of memory to allocate from @base
> + * @align: alignment requirements for the allocation
> + * @name: resource name
> + *
> + * Buses like CXL, that can dynamically instantiate new memory regions,
> + * need a method to allocate physical address space for those regions.
> + * Allocate and insert a new resource to cover a free, unclaimed by a
> + * descendant of @base, range in the span of @base.
> + */
> +struct resource *alloc_free_mem_region(struct resource *base,
Given the extra align parameter, does it make sense to give this a naming
that highlights that vs the other two interfaces above?

alloc_free_mem_region_aligned()

> +				       unsigned long size, unsigned long align,
> +				       const char *name)
> +{
> +	/* GFR_ASCENDING | GFR_INSERT_RESOURCE */

Given those flags don't exist and some fool like me might grep for them
perhaps better to describe it in text

	/* Default of ascending direction and insert resource */

> +	unsigned long flags = 0;
> +
> +	return get_free_mem_region(NULL, base, size, align, name,
> +				   IORES_DESC_NONE, flags);
> +}
> +EXPORT_SYMBOL_NS_GPL(alloc_free_mem_region, CXL);
> +#endif /* CONFIG_GET_FREE_REGION */
>  
>  static int __init strict_iomem(char *str)
>  {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 169e64192e48..a5b4fee2e3fd 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -994,9 +994,14 @@ config HMM_MIRROR
>  	bool
>  	depends on MMU
>  
> +config GET_FREE_REGION
> +	depends on SPARSEMEM
> +	bool
> +
>  config DEVICE_PRIVATE
>  	bool "Unaddressable device memory (GPU memory, ...)"
>  	depends on ZONE_DEVICE
> +	select GET_FREE_REGION
>  
>  	help
>  	  Allows creation of struct pages to represent unaddressable device


