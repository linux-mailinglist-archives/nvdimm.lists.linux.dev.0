Return-Path: <nvdimm+bounces-4751-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 681755BA555
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 05:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FCA3280CEF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 03:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547152100;
	Fri, 16 Sep 2022 03:36:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744720EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299392; x=1694835392;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r/wpsgIfHbDzQJNWJ9HD7Sb+85QkD9aLuJZ8FLqHRVk=;
  b=g53wPSeVkvdSF6Cs1+SbG6Lb3K55J4CV3euWiOe+LGlxvPMHRioSiiXl
   6FDei0xret8EXyc/VCyzgJahC2eCftQsTs911COEQOyZ5PGiq+Eu3/ha3
   FLUS2IwBX52WxKsFLF+dKUgzwL9REOZ5t5zwVmjrpPqekTvE/yRmN1oKT
   yDngm8tKMcJ6cVdlCZdLHUWGKov4N9anQTuE2n+nDhfXBBZh9w3qaSNYs
   7MozGc2cTkMsSa6I/wqEq4LbIWu3NcYN3VWaH/vva74h234EMhLfm9l+P
   e6q/JXaDupx/YhJonFcbQbBsEGdE4RvXvmHbPXm4YASBFZHObKid1GT9J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="360643279"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="360643279"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="679809542"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:31 -0700
Subject: [PATCH v2 14/18] devdax: add PUD support to the DAX mapping
 infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:36:31 -0700
Message-ID: <166329939123.2786261.4488002998591622104.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for using the DAX mapping infrastructure for device-dax,
update the helpers to handle PUD entries.

In practice the code related to @size_downgrade will go unused for PUD
entries since only devdax creates DAX PUD entries and devdax enforces
aligned mappings. The conversion is included for completeness.

The addition of PUD support to dax_insert_pfn_mkwrite() requires a new
stub for vmf_insert_pfn_pud() in the
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=n case.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/mapping.c   |   50 ++++++++++++++++++++++++++++++++++++-----------
 include/linux/dax.h     |   32 ++++++++++++++++++++----------
 include/linux/huge_mm.h |   11 ++++++++--
 3 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index 5d4b9601f183..b5a5196f8831 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -13,6 +13,7 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 #include <linux/pagemap.h>
+#include <linux/huge_mm.h>
 
 #include "dax-private.h"
 
@@ -56,6 +57,8 @@ static bool dax_is_zapped(void *entry)
 
 static unsigned int dax_entry_order(void *entry)
 {
+	if (xa_to_value(entry) & DAX_PUD)
+		return PUD_ORDER;
 	if (xa_to_value(entry) & DAX_PMD)
 		return PMD_ORDER;
 	return 0;
@@ -66,9 +69,14 @@ static unsigned long dax_is_pmd_entry(void *entry)
 	return xa_to_value(entry) & DAX_PMD;
 }
 
+static unsigned long dax_is_pud_entry(void *entry)
+{
+	return xa_to_value(entry) & DAX_PUD;
+}
+
 static bool dax_is_pte_entry(void *entry)
 {
-	return !(xa_to_value(entry) & DAX_PMD);
+	return !(xa_to_value(entry) & (DAX_PMD|DAX_PUD));
 }
 
 static int dax_is_zero_entry(void *entry)
@@ -277,6 +285,8 @@ static unsigned long dax_entry_size(void *entry)
 		return 0;
 	else if (dax_is_pmd_entry(entry))
 		return PMD_SIZE;
+	else if (dax_is_pud_entry(entry))
+		return PUD_SIZE;
 	else
 		return PAGE_SIZE;
 }
@@ -564,11 +574,11 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 			     struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
-	bool pmd_downgrade; /* splitting PMD entry into PTE entries? */
+	bool size_downgrade; /* splitting entry into PTE entries? */
 	void *entry;
 
 retry:
-	pmd_downgrade = false;
+	size_downgrade = false;
 	xas_lock_irq(xas);
 	entry = get_unlocked_entry(xas, order);
 
@@ -581,15 +591,25 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 		}
 
 		if (order == 0) {
-			if (dax_is_pmd_entry(entry) &&
+			if (!dax_is_pte_entry(entry) &&
 			    (dax_is_zero_entry(entry) ||
 			     dax_is_empty_entry(entry))) {
-				pmd_downgrade = true;
+				size_downgrade = true;
 			}
 		}
 	}
 
-	if (pmd_downgrade) {
+	if (size_downgrade) {
+		unsigned long colour, nr;
+
+		if (dax_is_pmd_entry(entry)) {
+			colour = PG_PMD_COLOUR;
+			nr = PG_PMD_NR;
+		} else {
+			colour = PG_PUD_COLOUR;
+			nr = PG_PUD_NR;
+		}
+
 		/*
 		 * Make sure 'entry' remains valid while we drop
 		 * the i_pages lock.
@@ -603,9 +623,8 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 		 */
 		if (dax_is_zero_entry(entry)) {
 			xas_unlock_irq(xas);
-			unmap_mapping_pages(mapping,
-					    xas->xa_index & ~PG_PMD_COLOUR,
-					    PG_PMD_NR, false);
+			unmap_mapping_pages(mapping, xas->xa_index & ~colour,
+					    nr, false);
 			xas_reset(xas);
 			xas_lock_irq(xas);
 		}
@@ -613,7 +632,7 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL); /* undo the PMD join */
 		dax_wake_entry(xas, entry, WAKE_ALL);
-		mapping->nrpages -= PG_PMD_NR;
+		mapping->nrpages -= nr;
 		entry = NULL;
 		xas_set(xas, index);
 	}
@@ -623,7 +642,9 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 	} else {
 		unsigned long flags = DAX_EMPTY;
 
-		if (order > 0)
+		if (order == PUD_SHIFT - PAGE_SHIFT)
+			flags |= DAX_PUD;
+		else if (order == PMD_SHIFT - PAGE_SHIFT)
 			flags |= DAX_PMD;
 		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
 		dax_lock_entry(xas, entry);
@@ -846,7 +867,10 @@ vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
-		if (dax_is_pmd_entry(entry))
+		if (dax_is_pud_entry(entry))
+			unmap_mapping_pages(mapping, index & ~PG_PUD_COLOUR,
+					    PG_PUD_NR, false);
+		else if (dax_is_pmd_entry(entry))
 			unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
 					    PG_PMD_NR, false);
 		else /* pte entry */
@@ -1018,6 +1042,8 @@ vm_fault_t dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn,
 	else if (order == PMD_ORDER)
 		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);
 #endif
+	else if (order == PUD_ORDER)
+		ret = vmf_insert_pfn_pud(vmf, pfn, FAULT_FLAG_WRITE);
 	else
 		ret = VM_FAULT_FALLBACK;
 	dax_unlock_entry(&xas, entry);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index de60a34088bb..3a27fecf072a 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -278,22 +278,25 @@ static inline bool dax_mapping(struct address_space *mapping)
 }
 
 /*
- * DAX pagecache entries use XArray value entries so they can't be mistaken
- * for pages.  We use one bit for locking, one bit for the entry size (PMD)
- * and two more to tell us if the entry is a zero page or an empty entry that
- * is just used for locking.  In total four special bits.
+ * DAX pagecache entries use XArray value entries so they can't be
+ * mistaken for pages.  We use one bit for locking, two bits for the
+ * entry size (PMD, PUD) and two more to tell us if the entry is a zero
+ * page or an empty entry that is just used for locking.  In total 5
+ * special bits which limits the max pfn that can be stored as:
+ * (1UL << 57 - PAGE_SHIFT). 63 - DAX_SHIFT - 1 (for xa_mk_value()).
  *
- * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
- * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
- * block allocation.
+ * If the P{M,U}D bits are not set the entry has size PAGE_SIZE, and if
+ * the ZERO_PAGE and EMPTY bits aren't set the entry is a normal DAX
+ * entry with a filesystem block allocation.
  */
-#define DAX_SHIFT	(5)
+#define DAX_SHIFT	(6)
 #define DAX_MASK	((1UL << DAX_SHIFT) - 1)
 #define DAX_LOCKED	(1UL << 0)
 #define DAX_PMD		(1UL << 1)
-#define DAX_ZERO_PAGE	(1UL << 2)
-#define DAX_EMPTY	(1UL << 3)
-#define DAX_ZAP		(1UL << 4)
+#define DAX_PUD		(1UL << 2)
+#define DAX_ZERO_PAGE	(1UL << 3)
+#define DAX_EMPTY	(1UL << 4)
+#define DAX_ZAP		(1UL << 5)
 
 /*
  * These flags are not conveyed in Xarray value entries, they are just
@@ -316,6 +319,13 @@ int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 /* The order of a PMD entry */
 #define PMD_ORDER (PMD_SHIFT - PAGE_SHIFT)
 
+/* The 'colour' (ie low bits) within a PUD of a page offset.  */
+#define PG_PUD_COLOUR ((PUD_SIZE >> PAGE_SHIFT) - 1)
+#define PG_PUD_NR (PUD_SIZE >> PAGE_SHIFT)
+
+/* The order of a PUD entry */
+#define PUD_ORDER (PUD_SHIFT - PAGE_SHIFT)
+
 static inline unsigned int pe_order(enum page_entry_size pe_size)
 {
 	if (pe_size == PE_SIZE_PTE)
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 768e5261fdae..de73f5a16252 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -18,10 +18,19 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
+vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
+				   pgprot_t pgprot, bool write);
 #else
 static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
 }
+
+static inline vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf,
+						 pfn_t pfn, pgprot_t pgprot,
+						 bool write)
+{
+	return VM_FAULT_SIGBUS;
+}
 #endif
 
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
@@ -58,8 +67,6 @@ static inline vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn,
 {
 	return vmf_insert_pfn_pmd_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
 }
-vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write);
 
 /**
  * vmf_insert_pfn_pud - insert a pud size pfn


