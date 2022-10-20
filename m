Return-Path: <nvdimm+bounces-4983-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D67A7606A9C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Oct 2022 23:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00C37280A9C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Oct 2022 21:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CB5610D;
	Thu, 20 Oct 2022 21:56:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADF07B
	for <nvdimm@lists.linux.dev>; Thu, 20 Oct 2022 21:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666303000; x=1697839000;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lOKfI6sTflYeTXUvY61fNwx8fUxj12mbkLEBQEJvOj4=;
  b=koDU+8uesrqXxufRyV9qOIY9IsS9zGko2CE55eOjYAFjGIfRmkWVhweR
   +0Qr+oQ98SvWqtAYcJ1lygOis6kJsWjfYotXUhdQs0OVjgXstVFweszU0
   QrMFiWxhj/O1N7km+vcf+Xyx0iYPGozzHgP2lmrNUEegcqmyHPOJbfRDo
   E2Dwmf+/w1hjc+YQ7BqjPhhC8uniLi9lDNX5BON1waREyC34r/6Awbfwi
   F2vuBFr7emheWLMq81Rtcy3XZ9EEBtvka4jqQJIiXVXl7yKyKynMFCNdL
   jByNhciPUWdxOhBSMkamwvY5EMpStJv+/9jZbJsF1wBtqLT+y3JpQtY8W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="308528549"
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="308528549"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 14:56:40 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="581177758"
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="581177758"
Received: from amwalker-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.42.205])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 14:56:39 -0700
Subject: [PATCH] mm/memremap: Introduce pgmap_request_folio() using pgmap
 offsets
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 John Hubbard <jhubbard@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Christian =?utf-8?b?S8O2bmln?= <christian.koenig@amd.com>, "Pan,
 Xinhui" <Xinhui.Pan@amd.com>, David Airlie <airlied@linux.ie>,
 Daniel Vetter <daniel@ffwll.ch>, Ben Skeggs <bskeggs@redhat.com>,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, nvdimm@lists.linux.dev
Date: Thu, 20 Oct 2022 14:56:39 -0700
Message-ID: <166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

A 'struct dev_pagemap' (pgmap) represents a collection of ZONE_DEVICE
pages. The pgmap is a reference counted object that serves a similar
role as a 'struct request_queue'. Live references are obtained for each
in flight request / page, and once a page's reference count drops to
zero the associated pin of the pgmap is dropped as well. While a page is
idle nothing should be accessing it because that is effectively a
use-after-free situation. Unfortunately, all current ZONE_DEVICE
implementations deploy a layering violation to manage requests to
activate pages owned by a pgmap. Specifically, they take steps like walk
the pfns that were previously assigned at memremap_pages() time and use
pfn_to_page() to recall metadata like page->pgmap, or make use of other
data like page->zone_device_data.

The first step towards correcting that situation is to provide a
API to get access to a pgmap page that does not require the caller to
know the pfn, nor access any fields of an idle page. Ideally this API
would be able to support dynamic page creation instead of the current
status quo of pre-allocating and initializing pages.

On a prompt from Jason, introduce pgmap_request_folio() that operates on
an offset into a pgmap. It replaces the shortlived
pgmap_request_folios() that was continuing the layering violation of
assuming pages are available to be consulted before asking the pgmap to
make them available.

For now this only converts the callers to lookup the pgmap and generate
the pgmap offset, but it does not do the deeper cleanup of teaching
those call sites to generate those arguments without walking the page
metadata. For next steps it appears the DEVICE_PRIVATE implementations
could plumb the pgmap into the necessary callsites and switch to using
gen_pool_alloc() to track which offsets of a pgmap are allocated. For
DAX, dax_direct_access() could switch from returning pfns to returning
the associated @pgmap and @pgmap_offset. Those changes are saved for
follow-on work.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
This builds on the dax reference counting reworks in mm-unstable.

 arch/powerpc/kvm/book3s_hv_uvmem.c       |   11 ++--
 drivers/dax/mapping.c                    |   10 +++
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   14 +++--
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |   13 +++-
 include/linux/memremap.h                 |   35 ++++++++---
 lib/test_hmm.c                           |    9 +++
 mm/memremap.c                            |   92 ++++++++++++------------------
 7 files changed, 106 insertions(+), 78 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 884ec112ad43..2ea59396f608 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -689,12 +689,14 @@ unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
  */
 static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 {
-	struct page *dpage = NULL;
+	struct dev_pagemap *pgmap = &kvmppc_uvmem_pgmap;
 	unsigned long bit, uvmem_pfn;
 	struct kvmppc_uvmem_page_pvt *pvt;
 	unsigned long pfn_last, pfn_first;
+	struct folio *folio;
+	struct page *dpage;
 
-	pfn_first = kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT;
+	pfn_first = pgmap->range.start >> PAGE_SHIFT;
 	pfn_last = pfn_first +
 		   (range_len(&kvmppc_uvmem_pgmap.range) >> PAGE_SHIFT);
 
@@ -716,9 +718,10 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 	pvt->gpa = gpa;
 	pvt->kvm = kvm;
 
-	dpage = pfn_to_page(uvmem_pfn);
+	folio = pgmap_request_folio(pgmap,
+				    pfn_to_pgmap_offset(pgmap, uvmem_pfn), 0);
+	dpage = &folio->page;
 	dpage->zone_device_data = pvt;
-	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
 	lock_page(dpage);
 	return dpage;
 out_clear:
diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index ca06f2515644..b885c75e2dfb 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -376,8 +376,14 @@ static vm_fault_t dax_associate_entry(void *entry,
 		if (flags & DAX_COW) {
 			dax_mapping_set_cow(folio);
 		} else {
+			struct dev_pagemap *pgmap = folio_pgmap(folio);
+			unsigned long pfn = page_to_pfn(&folio->page);
+
 			WARN_ON_ONCE(folio->mapping);
-			if (!pgmap_request_folios(folio_pgmap(folio), folio, 1))
+			if (folio !=
+			    pgmap_request_folio(pgmap,
+						pfn_to_pgmap_offset(pgmap, pfn),
+						folio_order(folio)))
 				return VM_FAULT_SIGBUS;
 			folio->mapping = mapping;
 			folio->index = index + i;
@@ -691,7 +697,7 @@ static struct page *dax_zap_pages(struct xa_state *xas, void *entry)
 
 	dax_for_each_folio(entry, folio, i) {
 		if (zap)
-			pgmap_release_folios(folio, 1);
+			folio_put(folio);
 		if (!ret && !dax_folio_idle(folio))
 			ret = folio_page(folio, 0);
 	}
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 8cf97060122b..1cecee358a9e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -215,15 +215,17 @@ svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr)
 	return (addr + adev->kfd.dev->pgmap.range.start) >> PAGE_SHIFT;
 }
 
-static void
-svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
+static void svm_migrate_get_vram_page(struct dev_pagemap *pgmap,
+				      struct svm_range *prange,
+				      unsigned long pfn)
 {
+	struct folio *folio;
 	struct page *page;
 
-	page = pfn_to_page(pfn);
+	folio = pgmap_request_folio(pgmap, pfn_to_pgmap_offset(pgmap, pfn), 0);
+	page = &folio->page;
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	pgmap_request_folios(page->pgmap, page_folio(page), 1);
 	lock_page(page);
 }
 
@@ -298,6 +300,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
 			 dma_addr_t *scratch)
 {
+	struct kfd_dev *kfddev = adev->kfd.dev;
 	uint64_t npages = migrate->npages;
 	struct device *dev = adev->dev;
 	struct amdgpu_res_cursor cursor;
@@ -327,7 +330,8 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 		if (spage && !is_zone_device_page(spage)) {
 			dst[i] = cursor.start + (j << PAGE_SHIFT);
 			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
-			svm_migrate_get_vram_page(prange, migrate->dst[i]);
+			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
+						  migrate->dst[i]);
 			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 			src[i] = dma_map_page(dev, spage, 0, PAGE_SIZE,
 					      DMA_TO_DEVICE);
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 1482533c7ca0..24208a1d7441 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -307,6 +307,9 @@ static struct page *
 nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
 {
 	struct nouveau_dmem_chunk *chunk;
+	struct dev_pagemap *pgmap;
+	struct folio *folio;
+	unsigned long pfn;
 	struct page *page = NULL;
 	int ret;
 
@@ -316,17 +319,21 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
 		drm->dmem->free_pages = page->zone_device_data;
 		chunk = nouveau_page_to_chunk(page);
 		chunk->callocated++;
+		pfn = page_to_pfn(page);
 		spin_unlock(&drm->dmem->lock);
 	} else {
 		spin_unlock(&drm->dmem->lock);
 		ret = nouveau_dmem_chunk_alloc(drm, &page);
 		if (ret)
 			return NULL;
+		chunk = nouveau_page_to_chunk(page);
+		pfn = page_to_pfn(page);
 	}
 
-	pgmap_request_folios(page->pgmap, page_folio(page), 1);
-	lock_page(page);
-	return page;
+	pgmap = &chunk->pagemap;
+	folio = pgmap_request_folio(pgmap, pfn_to_pgmap_offset(pgmap, pfn), 0);
+	lock_page(&folio->page);
+	return &folio->page;
 }
 
 static void
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index ddb196ae0696..f11f827883bb 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -139,6 +139,28 @@ struct dev_pagemap {
 	};
 };
 
+/*
+ * Do not use this in new code, this is a transitional helper on the
+ * path to convert all ZONE_DEVICE users to operate in terms of pgmap
+ * offsets rather than pfn and pfn_to_page() to put ZONE_DEVICE pages
+ * into use.
+ */
+static inline pgoff_t pfn_to_pgmap_offset(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	u64 phys = PFN_PHYS(pfn), sum = 0;
+	int i;
+
+	for (i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
+
+		if (phys >= range->start && phys <= range->end)
+			return PHYS_PFN(phys - range->start + sum);
+		sum += range_len(range);
+	}
+
+	return -1;
+}
+
 static inline bool pgmap_has_memory_failure(struct dev_pagemap *pgmap)
 {
 	return pgmap->ops && pgmap->ops->memory_failure;
@@ -193,9 +215,8 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 				    struct dev_pagemap *pgmap);
-bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
-			  int nr_folios);
-void pgmap_release_folios(struct folio *folio, int nr_folios);
+struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
+				  pgoff_t pgmap_offset, int order);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
@@ -231,16 +252,12 @@ static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 	return NULL;
 }
 
-static inline bool pgmap_request_folios(struct dev_pagemap *pgmap,
-					struct folio *folio, int nr_folios)
+static inline struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
+						pgoff_t pgmap_offset, int order)
 {
 	return false;
 }
 
-static inline void pgmap_release_folios(struct folio *folio, int nr_folios)
-{
-}
-
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
 {
 	return false;
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index e4f7219ae3bb..1f7e00ae62d5 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -605,8 +605,11 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 
 static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
 {
+	struct dev_pagemap *pgmap;
 	struct page *dpage = NULL;
 	struct page *rpage = NULL;
+	struct folio *folio;
+	unsigned long pfn;
 
 	/*
 	 * For ZONE_DEVICE private type, this is a fake device so we allocate
@@ -632,7 +635,11 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
 			goto error;
 	}
 
-	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
+	/* FIXME: Rework allocator to be pgmap offset based */
+	pgmap = dpage->pgmap;
+	pfn = page_to_pfn(dpage);
+	folio = pgmap_request_folio(pgmap, pfn_to_pgmap_offset(pgmap, pfn), 0);
+	WARN_ON_ONCE(dpage != &folio->page);
 	lock_page(dpage);
 	dpage->zone_device_data = rpage;
 	return dpage;
diff --git a/mm/memremap.c b/mm/memremap.c
index 02b796749b72..09b20a337db9 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -492,76 +492,60 @@ void free_zone_device_page(struct page *page)
 	put_dev_pagemap(page->pgmap);
 }
 
-static __maybe_unused bool folio_span_valid(struct dev_pagemap *pgmap,
-					    struct folio *folio,
-					    int nr_folios)
+static unsigned long pgmap_offset_to_pfn(struct dev_pagemap *pgmap,
+					 pgoff_t pgmap_offset)
 {
-	unsigned long pfn_start, pfn_end;
-
-	pfn_start = page_to_pfn(folio_page(folio, 0));
-	pfn_end = pfn_start + (1 << folio_order(folio)) * nr_folios - 1;
+	u64 sum = 0, offset = PFN_PHYS(pgmap_offset);
+	int i;
 
-	if (pgmap != xa_load(&pgmap_array, pfn_start))
-		return false;
+	for (i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
 
-	if (pfn_end > pfn_start && pgmap != xa_load(&pgmap_array, pfn_end))
-		return false;
+		if (offset >= sum && offset < (sum + range_len(range)))
+			return PHYS_PFN(range->start + offset - sum);
+		sum += range_len(range);
+	}
 
-	return true;
+	return -1;
 }
 
 /**
- * pgmap_request_folios - activate an contiguous span of folios in @pgmap
- * @pgmap: host page map for the folio array
- * @folio: start of the folio list, all subsequent folios have same folio_size()
+ * pgmap_request_folio - activate a folio of a given order in @pgmap
+ * @pgmap: host page map of the folio to activate
+ * @pgmap_offset: page-offset into the pgmap to request
+ * @order: expected folio_order() of the folio
  *
  * Caller is responsible for @pgmap remaining live for the duration of
- * this call. Caller is also responsible for not racing requests for the
- * same folios.
+ * this call. The order (size) of the folios in the pgmap are assumed
+ * stable before this call.
  */
-bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
-			  int nr_folios)
+struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
+				  pgoff_t pgmap_offset, int order)
 {
-	struct folio *iter;
-	int i;
+	unsigned long pfn = pgmap_offset_to_pfn(pgmap, pgmap_offset);
+	struct page *page = pfn_to_page(pfn);
+	struct folio *folio;
+	int v;
 
-	/*
-	 * All of the WARNs below are for catching bugs in future
-	 * development that changes the assumptions of:
-	 * 1/ uniform folios in @pgmap
-	 * 2/ @pgmap death does not race this routine.
-	 */
-	VM_WARN_ON_ONCE(!folio_span_valid(pgmap, folio, nr_folios));
+	if (WARN_ON_ONCE(page->pgmap != pgmap))
+		return NULL;
 
 	if (WARN_ON_ONCE(percpu_ref_is_dying(&pgmap->ref)))
-		return false;
+		return NULL;
 
-	for (iter = folio_next(folio), i = 1; i < nr_folios;
-	     iter = folio_next(folio), i++)
-		if (WARN_ON_ONCE(folio_order(iter) != folio_order(folio)))
-			return false;
+	folio = page_folio(page);
+	if (WARN_ON_ONCE(folio_order(folio) != order))
+		return NULL;
 
-	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(iter), i++) {
-		folio_ref_inc(iter);
-		if (folio_ref_count(iter) == 1)
-			percpu_ref_tryget(&pgmap->ref);
-	}
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(pgmap_request_folios);
+	v = folio_ref_inc_return(folio);
+	if (v > 1)
+		return folio;
 
-/*
- * A symmetric helper to undo the page references acquired by
- * pgmap_request_folios(), but the caller can also just arrange
- * folio_put() on all the folios it acquired previously for the same
- * effect.
- */
-void pgmap_release_folios(struct folio *folio, int nr_folios)
-{
-	struct folio *iter;
-	int i;
+	if (WARN_ON_ONCE(!percpu_ref_tryget(&pgmap->ref))) {
+		folio_put(folio);
+		return NULL;
+	}
 
-	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(folio), i++)
-		folio_put(iter);
+	return folio;
 }
+EXPORT_SYMBOL_GPL(pgmap_request_folio);


