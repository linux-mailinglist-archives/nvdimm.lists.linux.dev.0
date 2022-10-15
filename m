Return-Path: <nvdimm+bounces-4938-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E135FF73F
	for <lists+linux-nvdimm@lfdr.de>; Sat, 15 Oct 2022 01:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5A2F280BE7
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Oct 2022 23:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08A0469E;
	Fri, 14 Oct 2022 23:57:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FFE4697
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791840; x=1697327840;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=00TuoeEs7LX9ow5sfsY7OGmlVaqdx+lllPmKBKn3E9Y=;
  b=ExZUGEhhZP/if7gQ2P9yIw5Kg30wPRAsgcyDdzj7vS6POLwcgu4QHtS3
   tUi4fkB+E9i4MHuEoKpqmQTTkQQiChQVeGvrqxmUld+U3UKYPU/nmnvqT
   rBf/X8U9pcFv2TZZGE7GQOJUmAObI7TgkrYIBQ1A6IcysERv4ti8tTP6j
   4Jx1VqUtD6bTPeOA+yl2dkwqakTsRHAcu+RuNm7WIwse28lRcUFCt+/K3
   hxcWsnxRxzcW1n0scmOmidJUHx7N1KYqt23TyPXA82qUr9bvRZ3wkwsV6
   906qG0NxZq/aXwrrDPDFz468LVsfpE++snPVRBY2glwiEbbB0h3lmHgMG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="369693676"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="369693676"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:20 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="658759562"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="658759562"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:20 -0700
Subject: [PATCH v3 04/25] fsdax: Introduce dax_zap_mappings()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:19 -0700
Message-ID: <166579183976.2236710.17370760087488536715.stgit@dwillia2-xfh.jf.intel.com>
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

Typical pages take a reference at pte insertion and drop it at
zap_pte_range() time. That reference management is missing for DAX
leading to a situation where DAX pages are mapped in user page tables,
but are not referenced.

Once fsdax decides it wants to unmap the page it can drop its reference,
but unlike typical pages it needs to maintain the association of the
page to the inode that arbitrated the access in the first instance. It
maintains that association until explicit truncate(), or the implicit
truncate() that occurs at inode death, truncate_inode_pages_final().

The zapped state tracks whether the fsdax has dropped its interest in a
page, but still allows the associated i_pages entry to live until
truncate. This facilitates inode lookup while awaiting any page pin
users to drop their pins. For example, if memory_failure() is triggered
on the page after it has been unmapped, but before it has been truncated
from the inode, memory_failure() can still associate the event with the
inode.

Once truncate begins fsdax unmaps the page to prevent any new references
from being taken without calling back into fsdax core to reestablish
the mapping.

This approach relies on all paths that call truncate_inode_pages() to
first call dax_zap_mappings(). For that another bandaid is needed to add
this 'zap' step to the truncate_inode_pages_final() path, but that is
saved for a follow-on patch.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |   72 +++++++++++++++++++++++++++++++++++----------------
 fs/ext4/inode.c     |    2 +
 fs/fuse/dax.c       |    4 +--
 fs/xfs/xfs_file.c   |    2 +
 fs/xfs/xfs_inode.c  |    4 +--
 include/linux/dax.h |   11 +++++---
 6 files changed, 63 insertions(+), 32 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 76bad1c095c0..a75d4bf541b4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -74,11 +74,12 @@ fs_initcall(init_dax_wait_table);
  * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
  * block allocation.
  */
-#define DAX_SHIFT	(4)
+#define DAX_SHIFT	(5)
 #define DAX_LOCKED	(1UL << 0)
 #define DAX_PMD		(1UL << 1)
 #define DAX_ZERO_PAGE	(1UL << 2)
 #define DAX_EMPTY	(1UL << 3)
+#define DAX_ZAP		(1UL << 4)
 
 static unsigned long dax_to_pfn(void *entry)
 {
@@ -95,6 +96,11 @@ static bool dax_is_locked(void *entry)
 	return xa_to_value(entry) & DAX_LOCKED;
 }
 
+static bool dax_is_zapped(void *entry)
+{
+	return xa_to_value(entry) & DAX_ZAP;
+}
+
 static unsigned int dax_entry_order(void *entry)
 {
 	if (xa_to_value(entry) & DAX_PMD)
@@ -407,19 +413,6 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 	}
 }
 
-static struct page *dax_busy_page(void *entry)
-{
-	unsigned long pfn;
-
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		if (!dax_page_idle(page))
-			return page;
-	}
-	return NULL;
-}
-
 /*
  * dax_lock_page - Lock the DAX entry corresponding to a page
  * @page: The page whose entry we want to lock
@@ -664,8 +657,43 @@ static void *grab_mapping_entry(struct xa_state *xas,
 	return xa_mk_internal(VM_FAULT_FALLBACK);
 }
 
+static void *dax_zap_entry(struct xa_state *xas, void *entry)
+{
+	unsigned long v = xa_to_value(entry);
+
+	return xas_store(xas, xa_mk_value(v | DAX_ZAP));
+}
+
+/**
+ * Return NULL if the entry is zapped and all pages in the entry are
+ * idle, otherwise return the non-idle page in the entry
+ */
+static struct page *dax_zap_pages(struct xa_state *xas, void *entry)
+{
+	struct page *ret = NULL;
+	unsigned long pfn;
+	bool zap;
+
+	if (!dax_entry_size(entry))
+		return NULL;
+
+	zap = !dax_is_zapped(entry);
+
+	for_each_mapped_pfn(entry, pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (!ret && !dax_page_idle(page))
+			ret = page;
+	}
+
+	if (zap)
+		dax_zap_entry(xas, entry);
+
+	return ret;
+}
+
 /**
- * dax_layout_busy_page_range - find first pinned page in @mapping
+ * dax_zap_mappings_range - find first pinned page in @mapping
  * @mapping: address space to scan for a page with ref count > 1
  * @start: Starting offset. Page containing 'start' is included.
  * @end: End offset. Page containing 'end' is included. If 'end' is LLONG_MAX,
@@ -682,8 +710,8 @@ static void *grab_mapping_entry(struct xa_state *xas,
  * to be able to run unmap_mapping_range() and subsequently not race
  * mapping_mapped() becoming true.
  */
-struct page *dax_layout_busy_page_range(struct address_space *mapping,
-					loff_t start, loff_t end)
+struct page *dax_zap_mappings_range(struct address_space *mapping, loff_t start,
+				    loff_t end)
 {
 	void *entry;
 	unsigned int scanned = 0;
@@ -727,7 +755,7 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
 		if (unlikely(dax_is_locked(entry)))
 			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
-			page = dax_busy_page(entry);
+			page = dax_zap_pages(&xas, entry);
 		put_unlocked_entry(&xas, entry, WAKE_NEXT);
 		if (page)
 			break;
@@ -742,13 +770,13 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
 	xas_unlock_irq(&xas);
 	return page;
 }
-EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
+EXPORT_SYMBOL_GPL(dax_zap_mappings_range);
 
-struct page *dax_layout_busy_page(struct address_space *mapping)
+struct page *dax_zap_mappings(struct address_space *mapping)
 {
-	return dax_layout_busy_page_range(mapping, 0, LLONG_MAX);
+	return dax_zap_mappings_range(mapping, 0, LLONG_MAX);
 }
-EXPORT_SYMBOL_GPL(dax_layout_busy_page);
+EXPORT_SYMBOL_GPL(dax_zap_mappings);
 
 static int __dax_invalidate_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 478ec6bc0935..3935af49df8b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3957,7 +3957,7 @@ int ext4_break_layouts(struct inode *inode)
 		return -EINVAL;
 
 	do {
-		page = dax_layout_busy_page(inode->i_mapping);
+		page = dax_zap_mappings(inode->i_mapping);
 		if (!page)
 			return 0;
 
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index ae52ef7dbabe..8cdc9402e8f7 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -443,7 +443,7 @@ static int fuse_setup_new_dax_mapping(struct inode *inode, loff_t pos,
 
 	/*
 	 * Can't do inline reclaim in fault path. We call
-	 * dax_layout_busy_page() before we free a range. And
+	 * dax_zap_mappings() before we free a range. And
 	 * fuse_wait_dax_page() drops mapping->invalidate_lock and requires it.
 	 * In fault path we enter with mapping->invalidate_lock held and can't
 	 * drop it. Also in fault path we hold mapping->invalidate_lock shared
@@ -671,7 +671,7 @@ static int __fuse_dax_break_layouts(struct inode *inode, bool *retry,
 {
 	struct page *page;
 
-	page = dax_layout_busy_page_range(inode->i_mapping, start, end);
+	page = dax_zap_mappings_range(inode->i_mapping, start, end);
 	if (!page)
 		return 0;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 556e28d06788..ca0afcdd98c0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -822,7 +822,7 @@ xfs_break_dax_layouts(
 
 	ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
 
-	page = dax_layout_busy_page(inode->i_mapping);
+	page = dax_zap_mappings(inode->i_mapping);
 	if (!page)
 		return 0;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 28493c8e9bb2..d48dfee01008 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3481,8 +3481,8 @@ xfs_mmaplock_two_inodes_and_break_dax_layout(
 	 * need to unlock & lock the XFS_MMAPLOCK_EXCL which is not suitable
 	 * for this nested lock case.
 	 */
-	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
-	if (page && page_ref_count(page) != 1) {
+	page = dax_zap_mappings(VFS_I(ip2)->i_mapping);
+	if (page) {
 		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
 		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
 		goto again;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 04987d14d7e0..f6acb4ed73cb 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -157,8 +157,9 @@ static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
 
-struct page *dax_layout_busy_page(struct address_space *mapping);
-struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
+struct page *dax_zap_mappings(struct address_space *mapping);
+struct page *dax_zap_mappings_range(struct address_space *mapping, loff_t start,
+				    loff_t end);
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
 dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
@@ -166,12 +167,14 @@ dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
 void dax_unlock_mapping_entry(struct address_space *mapping,
 		unsigned long index, dax_entry_t cookie);
 #else
-static inline struct page *dax_layout_busy_page(struct address_space *mapping)
+static inline struct page *dax_zap_mappings(struct address_space *mapping)
 {
 	return NULL;
 }
 
-static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
+static inline struct page *dax_zap_mappings_range(struct address_space *mapping,
+						  pgoff_t start,
+						  pgoff_t nr_pages)
 {
 	return NULL;
 }


