Return-Path: <nvdimm+bounces-4954-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD76B5FF75F
	for <lists+linux-nvdimm@lfdr.de>; Sat, 15 Oct 2022 01:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB4D81C20996
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Oct 2022 23:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFE5469F;
	Fri, 14 Oct 2022 23:58:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787074694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791936; x=1697327936;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ruMjl+0UocVm9fTpEQwbq3un5MC8KrI+3NHaQIaXRt0=;
  b=I668CiEOqjumguA2wt1/cuXx82yc6X4I9M29W3jmjq0ssrkJMJee/EAL
   U1jMg/UrvM9gJDSKltSnTceJKdDGZt+gfP0382jRWIz2gXXrTzqh5dRj5
   j4zywgAwpgHEXS0YsgIzFZlG06bkKYeGtYOaag/Wp5Oo7fsmX1KAbLra6
   d7xzl4SC2TehWN7yEcruvK26ZzFLUtP5x4N27+EDE8S1fTMHh59inQuCW
   AZphKW/vfTRz8y2EBw6tW76oULlK9MdRNoymiNrqQsCADqz/e34Nl/4Y+
   sot91rBQ6eixwVvoCvgOMn+U5i1VwuldSmiGCPw2BL+Vs1qGpOMWWBEnd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="332018720"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="332018720"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="802798964"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="802798964"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:55 -0700
Subject: [PATCH v3 20/25] devdax: add PUD support to the DAX mapping
 infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:54 -0700
Message-ID: <166579193481.2236710.2902634991178133192.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
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

The addition of PUD support to the common dax_insert_pfn_mkwrite()
requires a new stub for vmf_insert_pfn_pud() in the case where huge page
support and/or PUD support is not available.

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
 include/linux/huge_mm.h |   14 ++++++++++---
 3 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index b452bfa98f5e..ba01c1cf4b51 100644
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
@@ -561,11 +571,11 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
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
 
@@ -578,15 +588,25 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
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
@@ -600,9 +620,8 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
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
@@ -610,7 +629,7 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL); /* undo the PMD join */
 		dax_wake_entry(xas, entry, WAKE_ALL);
-		mapping->nrpages -= PG_PMD_NR;
+		mapping->nrpages -= nr;
 		entry = NULL;
 		xas_set(xas, index);
 	}
@@ -620,7 +639,9 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 	} else {
 		unsigned long flags = DAX_EMPTY;
 
-		if (order > 0)
+		if (order == PUD_SHIFT - PAGE_SHIFT)
+			flags |= DAX_PUD;
+		else if (order == PMD_SHIFT - PAGE_SHIFT)
 			flags |= DAX_PMD;
 		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
 		dax_lock_entry(xas, entry);
@@ -864,7 +885,10 @@ vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
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
@@ -1040,6 +1064,8 @@ vm_fault_t dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn,
 	else if (order == PMD_ORDER)
 		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);
 #endif
+	else if (order == PUD_ORDER)
+		ret = vmf_insert_pfn_pud(vmf, pfn, FAULT_FLAG_WRITE);
 	else
 		ret = VM_FAULT_FALLBACK;
 	dax_unlock_entry(&xas, entry);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 553bc819a6a4..a61df43921a3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -300,22 +300,25 @@ static inline bool dax_mapping(struct address_space *mapping)
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
@@ -339,6 +342,13 @@ int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
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
index a1341fdcf666..aab708996fb0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -16,12 +16,22 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
 		  struct vm_area_struct *vma);
 
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
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
@@ -58,8 +68,6 @@ static inline vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn,
 {
 	return vmf_insert_pfn_pmd_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
 }
-vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write);
 
 /**
  * vmf_insert_pfn_pud - insert a pud size pfn


