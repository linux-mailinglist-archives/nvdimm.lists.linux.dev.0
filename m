Return-Path: <nvdimm+bounces-4746-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D145BA544
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 05:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C554F1C209B2
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 03:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC88620FF;
	Fri, 16 Sep 2022 03:36:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2AE20EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299363; x=1694835363;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bcuK2KG5EjEAqreYAdzRR3rq0EZdnkZSoL2J30lxqoE=;
  b=lp1U3OCfCV+qGfUV+6dbeB09e/4MKNE7DTbDCDGVQ+qaf4ccCpOsffQZ
   zc/5ljU1+v+D7Yiec5KBa654X3A2uJCN3rd/jjucgzyZ45qLQeuZPI+Jb
   XRb8cK0iOtp1J6Us1FCJ0C88Zi7XfOiLJoqR7CqvFB1SsBdDFXsGQSH/G
   dg69iMQPSH9hF297E4DajzntYAQnnjg+FEUBMzGCctf0st2obkihBUvBT
   bxBxXlXrIgmb0F/kiBZnlkADHGqAOiWGk+oZfI26nlVAxTZcTRnZLnzEs
   qNZ2ZUVkFZmCgEUuiXDqS+3QR2hlEEVnWb8BLXtOAHAmhT08Rz4SHaI4W
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="297625012"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="297625012"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="648099926"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:01 -0700
Subject: [PATCH v2 09/18] fsdax: Rework dax_insert_entry() calling convention
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:36:01 -0700
Message-ID: <166329936170.2786261.6094157723547541341.stgit@dwillia2-xfh.jf.intel.com>
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

Move the determination of @dirty and @cow in dax_insert_entry() to flags
(DAX_DIRTY and DAX_COW) that are passed in. This allows the iomap
related code to remain fs/dax.c in preparation for the Xarray
infrastructure to move to drivers/dax/mapping.c.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index bd5c6b6e371e..5d9f30105db4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -75,12 +75,20 @@ fs_initcall(init_dax_wait_table);
  * block allocation.
  */
 #define DAX_SHIFT	(5)
+#define DAX_MASK	((1UL << DAX_SHIFT) - 1)
 #define DAX_LOCKED	(1UL << 0)
 #define DAX_PMD		(1UL << 1)
 #define DAX_ZERO_PAGE	(1UL << 2)
 #define DAX_EMPTY	(1UL << 3)
 #define DAX_ZAP		(1UL << 4)
 
+/*
+ * These flags are not conveyed in Xarray value entries, they are just
+ * modifiers to dax_insert_entry().
+ */
+#define DAX_DIRTY (1UL << (DAX_SHIFT + 0))
+#define DAX_COW   (1UL << (DAX_SHIFT + 1))
+
 static unsigned long dax_to_pfn(void *entry)
 {
 	return xa_to_value(entry) >> DAX_SHIFT;
@@ -88,7 +96,8 @@ static unsigned long dax_to_pfn(void *entry)
 
 static void *dax_make_entry(pfn_t pfn, unsigned long flags)
 {
-	return xa_mk_value(flags | (pfn_t_to_pfn(pfn) << DAX_SHIFT));
+	return xa_mk_value((flags & DAX_MASK) |
+			   (pfn_t_to_pfn(pfn) << DAX_SHIFT));
 }
 
 static bool dax_is_locked(void *entry)
@@ -880,6 +889,20 @@ static bool dax_fault_is_cow(const struct iomap_iter *iter)
 		(iter->iomap.flags & IOMAP_F_SHARED);
 }
 
+static unsigned long dax_iter_flags(const struct iomap_iter *iter,
+				    struct vm_fault *vmf)
+{
+	unsigned long flags = 0;
+
+	if (!dax_fault_is_synchronous(iter, vmf->vma))
+		flags |= DAX_DIRTY;
+
+	if (dax_fault_is_cow(iter))
+		flags |= DAX_COW;
+
+	return flags;
+}
+
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
  * of the appropriate size so we don't have to worry about downgrading PMDs to
@@ -888,13 +911,13 @@ static bool dax_fault_is_cow(const struct iomap_iter *iter)
  * appropriate.
  */
 static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
-				   const struct iomap_iter *iter, void **pentry,
-				   pfn_t pfn, unsigned long flags)
+				   void **pentry, pfn_t pfn,
+				   unsigned long flags)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	void *new_entry = dax_make_entry(pfn, flags);
-	bool dirty = !dax_fault_is_synchronous(iter, vmf->vma);
-	bool cow = dax_fault_is_cow(iter);
+	bool dirty = flags & DAX_DIRTY;
+	bool cow = flags & DAX_COW;
 	void *entry = *pentry;
 
 	if (dirty)
@@ -1189,7 +1212,8 @@ static vm_fault_t dax_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 	vm_fault_t ret;
 
-	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, entry, pfn,
+			       DAX_ZERO_PAGE | dax_iter_flags(iter, vmf));
 	if (ret)
 		goto out;
 
@@ -1220,8 +1244,9 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		goto fallback;
 
 	pfn = page_to_pfn_t(zero_page);
-	ret = dax_insert_entry(xas, vmf, iter, entry, pfn,
-			       DAX_PMD | DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, entry, pfn,
+			       DAX_PMD | DAX_ZERO_PAGE |
+				       dax_iter_flags(iter, vmf));
 	if (ret)
 		return ret;
 
@@ -1600,7 +1625,8 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
-	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, entry_flags);
+	ret = dax_insert_entry(xas, vmf, entry, pfn,
+			       entry_flags | dax_iter_flags(iter, vmf));
 	if (ret)
 		return ret;
 


