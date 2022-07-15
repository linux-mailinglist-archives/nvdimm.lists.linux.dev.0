Return-Path: <nvdimm+bounces-4282-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC181575859
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Jul 2022 02:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F8E8280D90
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Jul 2022 00:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB9CB7463;
	Fri, 15 Jul 2022 00:03:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB047460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843394; x=1689379394;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UDYAt3M3nQnYVxO8RqGbN31McxI7qhhgMZQ6vq7TSG0=;
  b=bt05UXkhUovA84bPJeD2WYgoyDbrqE481onuNn6yvdZyAnrNrsDJaBAR
   1ai7PqxFkeKAe8CZsR+Tf8BforxgerK140hJrLDWxX6KT2GAsZDuqEJ+X
   zyzBSjMgb7rzUal4seGk4QAlwUt7eeSplVBgR+psouSBjbmHYdXOhJAZ/
   Ief0OTwQq5HUtHkayRIYnzyLVzdUVoy/FTTRSEgPhEtvWQHR3NwT20sIi
   W8HhJ/DRnlnOA2xzAVLtaJZSZ5gAXWVbkSbq6VrPpDqsAzAEsQMslnG+F
   o8JYrRzZjtFQJXGI5urErHs0Y9UUGgtD1pdcnD2Y0rJk1Oyjg0OKi7dft
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="285684017"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="285684017"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="842326104"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:13 -0700
Subject: [PATCH v2 16/28] resource: Introduce alloc_free_mem_region()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev,
 linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:02:13 -0700
Message-ID: <165784333333.1758207.13703329337805274043.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The core of devm_request_free_mem_region() is a helper that searches for
free space in iomem_resource and performs __request_region_locked() on
the result of that search. The policy choices of the implementation
conform to what CONFIG_DEVICE_PRIVATE users want which is memory that is
immediately marked busy, and a preference to search for the first-fit
free range in descending order from the top of the physical address
space.

CXL has a need for a similar allocator, but with the following tweaks:

1/ Search for free space in ascending order

2/ Search for free space relative to a given CXL window

3/ 'insert' rather than 'request' the new resource given downstream
   drivers from the CXL Region driver (like the pmem or dax drivers) are
   responsible for request_mem_region() when they activate the memory
   range.

Rework __request_free_mem_region() into get_free_mem_region() which
takes a set of GFR_* (Get Free Region) flags to control the allocation
policy (ascending vs descending), and "busy" policy (insert_resource()
vs request_region()).

As part of the consolidation of the legacy GFR_REQUEST_REGION case with
the new default of just inserting a new resource into the free space
some minor cleanups like not checking for NULL before calling
devres_free() (which does its own check) is included.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/linux-cxl/20220420143406.GY2120790@nvidia.com/
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/ioport.h |    2 +
 kernel/resource.c      |  178 +++++++++++++++++++++++++++++++++++++++---------
 mm/Kconfig             |    5 +
 3 files changed, 150 insertions(+), 35 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 79d1ad6d6275..616b683563a9 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -330,6 +330,8 @@ struct resource *devm_request_free_mem_region(struct device *dev,
 		struct resource *base, unsigned long size);
 struct resource *request_free_mem_region(struct resource *base,
 		unsigned long size, const char *name);
+struct resource *alloc_free_mem_region(struct resource *base,
+		unsigned long size, unsigned long align, const char *name);
 
 static inline void irqresource_disabled(struct resource *res, u32 irq)
 {
diff --git a/kernel/resource.c b/kernel/resource.c
index 53a534db350e..4c5e80b92f2f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -489,8 +489,9 @@ int __weak page_is_ram(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
-static int __region_intersects(resource_size_t start, size_t size,
-			unsigned long flags, unsigned long desc)
+static int __region_intersects(struct resource *parent, resource_size_t start,
+			       size_t size, unsigned long flags,
+			       unsigned long desc)
 {
 	struct resource res;
 	int type = 0; int other = 0;
@@ -499,7 +500,7 @@ static int __region_intersects(resource_size_t start, size_t size,
 	res.start = start;
 	res.end = start + size - 1;
 
-	for (p = iomem_resource.child; p ; p = p->sibling) {
+	for (p = parent->child; p ; p = p->sibling) {
 		bool is_type = (((p->flags & flags) == flags) &&
 				((desc == IORES_DESC_NONE) ||
 				 (desc == p->desc)));
@@ -543,7 +544,7 @@ int region_intersects(resource_size_t start, size_t size, unsigned long flags,
 	int ret;
 
 	read_lock(&resource_lock);
-	ret = __region_intersects(start, size, flags, desc);
+	ret = __region_intersects(&iomem_resource, start, size, flags, desc);
 	read_unlock(&resource_lock);
 
 	return ret;
@@ -1780,62 +1781,139 @@ void resource_list_free(struct list_head *head)
 }
 EXPORT_SYMBOL(resource_list_free);
 
-#ifdef CONFIG_DEVICE_PRIVATE
-static struct resource *__request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size, const char *name)
+#ifdef CONFIG_GET_FREE_REGION
+#define GFR_DESCENDING		(1UL << 0)
+#define GFR_REQUEST_REGION	(1UL << 1)
+#define GFR_DEFAULT_ALIGN (1UL << PA_SECTION_SHIFT)
+
+static resource_size_t gfr_start(struct resource *base, resource_size_t size,
+				 resource_size_t align, unsigned long flags)
+{
+	if (flags & GFR_DESCENDING) {
+		resource_size_t end;
+
+		end = min_t(resource_size_t, base->end,
+			    (1ULL << MAX_PHYSMEM_BITS) - 1);
+		return end - size + 1;
+	}
+
+	return ALIGN(base->start, align);
+}
+
+static bool gfr_continue(struct resource *base, resource_size_t addr,
+			 resource_size_t size, unsigned long flags)
+{
+	if (flags & GFR_DESCENDING)
+		return addr > size && addr >= base->start;
+	/*
+	 * In the ascend case be careful that the last increment by
+	 * @size did not wrap 0.
+	 */
+	return addr > addr - size &&
+	       addr <= min_t(resource_size_t, base->end,
+			     (1ULL << MAX_PHYSMEM_BITS) - 1);
+}
+
+static resource_size_t gfr_next(resource_size_t addr, resource_size_t size,
+				unsigned long flags)
+{
+	if (flags & GFR_DESCENDING)
+		return addr - size;
+	return addr + size;
+}
+
+static void remove_free_mem_region(void *_res)
+{
+	struct resource *res = _res;
+
+	if (res->parent)
+		remove_resource(res);
+	free_resource(res);
+}
+
+static struct resource *
+get_free_mem_region(struct device *dev, struct resource *base,
+		    resource_size_t size, const unsigned long align,
+		    const char *name, const unsigned long desc,
+		    const unsigned long flags)
 {
-	resource_size_t end, addr;
+	resource_size_t addr;
 	struct resource *res;
 	struct region_devres *dr = NULL;
 
-	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
-	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
-	addr = end - size + 1UL;
+	size = ALIGN(size, align);
 
 	res = alloc_resource(GFP_KERNEL);
 	if (!res)
 		return ERR_PTR(-ENOMEM);
 
-	if (dev) {
+	if (dev && (flags & GFR_REQUEST_REGION)) {
 		dr = devres_alloc(devm_region_release,
 				sizeof(struct region_devres), GFP_KERNEL);
 		if (!dr) {
 			free_resource(res);
 			return ERR_PTR(-ENOMEM);
 		}
+	} else if (dev) {
+		if (devm_add_action_or_reset(dev, remove_free_mem_region, res))
+			return ERR_PTR(-ENOMEM);
 	}
 
 	write_lock(&resource_lock);
-	for (; addr > size && addr >= base->start; addr -= size) {
-		if (__region_intersects(addr, size, 0, IORES_DESC_NONE) !=
-				REGION_DISJOINT)
+	for (addr = gfr_start(base, size, align, flags);
+	     gfr_continue(base, addr, size, flags);
+	     addr = gfr_next(addr, size, flags)) {
+		if (__region_intersects(base, addr, size, 0, IORES_DESC_NONE) !=
+		    REGION_DISJOINT)
 			continue;
 
-		if (__request_region_locked(res, &iomem_resource, addr, size,
-						name, 0))
-			break;
+		if (flags & GFR_REQUEST_REGION) {
+			if (__request_region_locked(res, &iomem_resource, addr,
+						    size, name, 0))
+				break;
 
-		if (dev) {
-			dr->parent = &iomem_resource;
-			dr->start = addr;
-			dr->n = size;
-			devres_add(dev, dr);
-		}
+			if (dev) {
+				dr->parent = &iomem_resource;
+				dr->start = addr;
+				dr->n = size;
+				devres_add(dev, dr);
+			}
 
-		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
-		write_unlock(&resource_lock);
+			res->desc = desc;
+			write_unlock(&resource_lock);
+
+
+			/*
+			 * A driver is claiming this region so revoke any
+			 * mappings.
+			 */
+			revoke_iomem(res);
+		} else {
+			res->start = addr;
+			res->end = addr + size - 1;
+			res->name = name;
+			res->desc = desc;
+			res->flags = IORESOURCE_MEM;
+
+			/*
+			 * Only succeed if the resource hosts an exclusive
+			 * range after the insert
+			 */
+			if (__insert_resource(base, res) || res->child)
+				break;
+
+			write_unlock(&resource_lock);
+		}
 
-		/*
-		 * A driver is claiming this region so revoke any mappings.
-		 */
-		revoke_iomem(res);
 		return res;
 	}
 	write_unlock(&resource_lock);
 
-	free_resource(res);
-	if (dr)
+	if (flags & GFR_REQUEST_REGION) {
+		free_resource(res);
 		devres_free(dr);
+	} else if (dev)
+		devm_release_action(dev, remove_free_mem_region, res);
 
 	return ERR_PTR(-ERANGE);
 }
@@ -1854,18 +1932,48 @@ static struct resource *__request_free_mem_region(struct device *dev,
 struct resource *devm_request_free_mem_region(struct device *dev,
 		struct resource *base, unsigned long size)
 {
-	return __request_free_mem_region(dev, base, size, dev_name(dev));
+	unsigned long flags = GFR_DESCENDING | GFR_REQUEST_REGION;
+
+	return get_free_mem_region(dev, base, size, GFR_DEFAULT_ALIGN,
+				   dev_name(dev),
+				   IORES_DESC_DEVICE_PRIVATE_MEMORY, flags);
 }
 EXPORT_SYMBOL_GPL(devm_request_free_mem_region);
 
 struct resource *request_free_mem_region(struct resource *base,
 		unsigned long size, const char *name)
 {
-	return __request_free_mem_region(NULL, base, size, name);
+	unsigned long flags = GFR_DESCENDING | GFR_REQUEST_REGION;
+
+	return get_free_mem_region(NULL, base, size, GFR_DEFAULT_ALIGN, name,
+				   IORES_DESC_DEVICE_PRIVATE_MEMORY, flags);
 }
 EXPORT_SYMBOL_GPL(request_free_mem_region);
 
-#endif /* CONFIG_DEVICE_PRIVATE */
+/**
+ * alloc_free_mem_region - find a free region relative to @base
+ * @base: resource that will parent the new resource
+ * @size: size in bytes of memory to allocate from @base
+ * @align: alignment requirements for the allocation
+ * @name: resource name
+ *
+ * Buses like CXL, that can dynamically instantiate new memory regions,
+ * need a method to allocate physical address space for those regions.
+ * Allocate and insert a new resource to cover a free, unclaimed by a
+ * descendant of @base, range in the span of @base.
+ */
+struct resource *alloc_free_mem_region(struct resource *base,
+				       unsigned long size, unsigned long align,
+				       const char *name)
+{
+	/* Default of ascending direction and insert resource */
+	unsigned long flags = 0;
+
+	return get_free_mem_region(NULL, base, size, align, name,
+				   IORES_DESC_NONE, flags);
+}
+EXPORT_SYMBOL_NS_GPL(alloc_free_mem_region, CXL);
+#endif /* CONFIG_GET_FREE_REGION */
 
 static int __init strict_iomem(char *str)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 169e64192e48..a5b4fee2e3fd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -994,9 +994,14 @@ config HMM_MIRROR
 	bool
 	depends on MMU
 
+config GET_FREE_REGION
+	depends on SPARSEMEM
+	bool
+
 config DEVICE_PRIVATE
 	bool "Unaddressable device memory (GPU memory, ...)"
 	depends on ZONE_DEVICE
+	select GET_FREE_REGION
 
 	help
 	  Allows creation of struct pages to represent unaddressable device


