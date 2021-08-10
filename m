Return-Path: <nvdimm+bounces-775-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 723A13E4039
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 650521C0F2C
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262D56D00;
	Mon,  9 Aug 2021 06:38:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791B42FB8
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Mri/mZGJNVqNUZOZpDacK9KS7AXJtfgkxhLzH1GJHvs=; b=m3gGhxVwcrqeVqJPEnj+TQ+8Jb
	UYtvAlIR0GXbiv23hf3f7/oUV2DYojqz7830F1MLvghIQ3tdt5TUJjATtrwy0OOzpKkOE1ua7/M7Y
	36yrg9o5cfK9LT6Bqy4AAoNBemEvN4UIwJXEAVhcQWwo3xRACj41jivp0ctboNhX4t5dh52+cPlwJ
	1RLgtZeLRoj3uwxytDaPcF3d9BL/7pYhVy9ouAGRTDxWbiHlLx7SIOb+2CW/HS5XCKCoSph37QRrv
	5+qbKxshkirnSaS39el0dW1laFbEMRurvYTi3eY7d7Yhg5kjP0F+UurVluC3yMWHWa6KzOYRl/GFo
	molmGFXw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCysS-00Ai33-Vs; Mon, 09 Aug 2021 06:35:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	cluster-devel@redhat.com,
	Ritesh Harjani <riteshh@linux.ibm.com>
Subject: [PATCH 27/30] fsdax: factor out helpers to simplify the dax fault code
Date: Mon,  9 Aug 2021 08:12:41 +0200
Message-Id: <20210809061244.1196573-28-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809061244.1196573-1-hch@lst.de>
References: <20210809061244.1196573-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

The dax page fault code is too long and a bit difficult to read. And it
is hard to understand when we trying to add new features. Some of the
PTE/PMD codes have similar logic. So, factor out helper functions to
simplify the code.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[hch: minor cleanups]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 153 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 84 insertions(+), 69 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 51da45301350a6..c09d721629d167 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1255,6 +1255,53 @@ static bool dax_fault_is_synchronous(unsigned long flags,
 		&& (iomap->flags & IOMAP_F_DIRTY);
 }
 
+/*
+ * When handling a synchronous page fault and the inode need a fsync, we can
+ * insert the PTE/PMD into page tables only after that fsync happened. Skip
+ * insertion for now and return the pfn so that caller can insert it after the
+ * fsync is done.
+ */
+static vm_fault_t dax_fault_synchronous_pfnp(pfn_t *pfnp, pfn_t pfn)
+{
+	if (WARN_ON_ONCE(!pfnp))
+		return VM_FAULT_SIGBUS;
+	*pfnp = pfn;
+	return VM_FAULT_NEEDDSYNC;
+}
+
+static vm_fault_t dax_fault_cow_page(struct vm_fault *vmf, struct iomap *iomap,
+		loff_t pos)
+{
+	sector_t sector = dax_iomap_sector(iomap, pos);
+	unsigned long vaddr = vmf->address;
+	vm_fault_t ret;
+	int error = 0;
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+	case IOMAP_UNWRITTEN:
+		clear_user_highpage(vmf->cow_page, vaddr);
+		break;
+	case IOMAP_MAPPED:
+		error = copy_cow_page_dax(iomap->bdev, iomap->dax_dev, sector,
+					  vmf->cow_page, vaddr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		error = -EIO;
+		break;
+	}
+
+	if (error)
+		return dax_fault_return(error);
+
+	__SetPageUptodate(vmf->cow_page);
+	ret = finish_fault(vmf);
+	if (!ret)
+		return VM_FAULT_DONE_COW;
+	return ret;
+}
+
 static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			       int *iomap_errp, const struct iomap_ops *ops)
 {
@@ -1323,30 +1370,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	}
 
 	if (vmf->cow_page) {
-		sector_t sector = dax_iomap_sector(&iomap, pos);
-
-		switch (iomap.type) {
-		case IOMAP_HOLE:
-		case IOMAP_UNWRITTEN:
-			clear_user_highpage(vmf->cow_page, vaddr);
-			break;
-		case IOMAP_MAPPED:
-			error = copy_cow_page_dax(iomap.bdev, iomap.dax_dev,
-						  sector, vmf->cow_page, vaddr);
-			break;
-		default:
-			WARN_ON_ONCE(1);
-			error = -EIO;
-			break;
-		}
-
-		if (error)
-			goto error_finish_iomap;
-
-		__SetPageUptodate(vmf->cow_page);
-		ret = finish_fault(vmf);
-		if (!ret)
-			ret = VM_FAULT_DONE_COW;
+		ret = dax_fault_cow_page(vmf, &iomap, pos);
 		goto finish_iomap;
 	}
 
@@ -1366,19 +1390,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						 0, write && !sync);
 
-		/*
-		 * If we are doing synchronous page fault and inode needs fsync,
-		 * we can insert PTE into page tables only after that happens.
-		 * Skip insertion for now and return the pfn so that caller can
-		 * insert it after fsync is done.
-		 */
 		if (sync) {
-			if (WARN_ON_ONCE(!pfnp)) {
-				error = -EIO;
-				goto error_finish_iomap;
-			}
-			*pfnp = pfn;
-			ret = VM_FAULT_NEEDDSYNC | major;
+			ret = dax_fault_synchronous_pfnp(pfnp, pfn);
 			goto finish_iomap;
 		}
 		trace_dax_insert_mapping(inode, vmf, entry);
@@ -1477,13 +1490,45 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	return VM_FAULT_FALLBACK;
 }
 
+static bool dax_fault_check_fallback(struct vm_fault *vmf, struct xa_state *xas,
+		pgoff_t max_pgoff)
+{
+	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	/*
+	 * Make sure that the faulting address's PMD offset (color) matches
+	 * the PMD offset from the start of the file.  This is necessary so
+	 * that a PMD range in the page table overlaps exactly with a PMD
+	 * range in the page cache.
+	 */
+	if ((vmf->pgoff & PG_PMD_COLOUR) !=
+	    ((vmf->address >> PAGE_SHIFT) & PG_PMD_COLOUR))
+		return true;
+
+	/* Fall back to PTEs if we're going to COW */
+	if (write && !(vmf->vma->vm_flags & VM_SHARED))
+		return true;
+
+	/* If the PMD would extend outside the VMA */
+	if (pmd_addr < vmf->vma->vm_start)
+		return true;
+	if ((pmd_addr + PMD_SIZE) > vmf->vma->vm_end)
+		return true;
+
+	/* If the PMD would extend beyond the file size */
+	if ((xas->xa_index | PG_PMD_COLOUR) >= max_pgoff)
+		return true;
+
+	return false;
+}
+
 static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			       const struct iomap_ops *ops)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, PMD_ORDER);
-	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	bool sync;
 	unsigned int iomap_flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
@@ -1506,33 +1551,12 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
 
-	/*
-	 * Make sure that the faulting address's PMD offset (color) matches
-	 * the PMD offset from the start of the file.  This is necessary so
-	 * that a PMD range in the page table overlaps exactly with a PMD
-	 * range in the page cache.
-	 */
-	if ((vmf->pgoff & PG_PMD_COLOUR) !=
-	    ((vmf->address >> PAGE_SHIFT) & PG_PMD_COLOUR))
-		goto fallback;
-
-	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED))
-		goto fallback;
-
-	/* If the PMD would extend outside the VMA */
-	if (pmd_addr < vma->vm_start)
-		goto fallback;
-	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
-		goto fallback;
-
 	if (xas.xa_index >= max_pgoff) {
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
-	/* If the PMD would extend beyond the file size */
-	if ((xas.xa_index | PG_PMD_COLOUR) >= max_pgoff)
+	if (dax_fault_check_fallback(vmf, &xas, max_pgoff))
 		goto fallback;
 
 	/*
@@ -1584,17 +1608,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						DAX_PMD, write && !sync);
 
-		/*
-		 * If we are doing synchronous page fault and inode needs fsync,
-		 * we can insert PMD into page tables only after that happens.
-		 * Skip insertion for now and return the pfn so that caller can
-		 * insert it after fsync is done.
-		 */
 		if (sync) {
-			if (WARN_ON_ONCE(!pfnp))
-				goto finish_iomap;
-			*pfnp = pfn;
-			result = VM_FAULT_NEEDDSYNC;
+			result = dax_fault_synchronous_pfnp(pfnp, pfn);
 			goto finish_iomap;
 		}
 
-- 
2.30.2


