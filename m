Return-Path: <nvdimm+bounces-4752-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D46175BA55A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 05:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C054280D1C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 03:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE5520FD;
	Fri, 16 Sep 2022 03:36:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C220EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299398; x=1694835398;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H9Kht40qne3iP+SMB12jPN9XbzdsW4QgUBLEqx1cMBY=;
  b=VjD8WkkSidUmRlASQ1V2J6OEqXyDt3YK+dzr/Sf1pLMvYT2N/3x+uuKI
   jxOFVEvqMHvfp88Bt1MA7UlzSIWuMo7okE5GTeNx4Sp+T4Pa/4+TdX0iI
   BTt4zRrOsUcK7hW4OCB2ZmsO2VtfxpmM+inoRkkFoFZ7ZvaDIbhYia4BR
   dH5x+HoXG2J5x5DDOWQktObGLWTyiP9U8cykGk+QjBHZYoOAbW7Y83fej
   3GST3t2tg8SSPfac+PVHmTWLoe020T3MX48x5TNOyI8RPBqar6N1L6tYG
   /UbN2b1F3rcz3GifY9lpsu44/1PU+6xeX1LChrQuaWXyYbl7MsXf/oiLF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="285943321"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="285943321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="679809564"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:37 -0700
Subject: [PATCH v2 15/18] devdax: Use dax_insert_entry() +
 dax_delete_mapping_entry()
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:36:37 -0700
Message-ID: <166329939733.2786261.13946962468817639563.stgit@dwillia2-xfh.jf.intel.com>
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

Track entries and take pgmap references at mapping insertion time.
Revoke mappings (dax_zap_mappings()) and drop the associated pgmap
references at device destruction or inode eviction time. With this in
place, and the fsdax equivalent already in place, the gup code no longer
needs to consider PTE_DEVMAP as an indicator to get a pgmap reference
before taking a page reference.

In other words, GUP takes additional references on mapped pages. Until
now, DAX in all its forms was failing to take references at mapping
time. With that fixed there is no longer a requirement for gup to manage
@pgmap references. However, that cleanup is saved for a follow-on patch.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c     |   15 +++++++++-
 drivers/dax/device.c  |   73 +++++++++++++++++++++++++++++--------------------
 drivers/dax/mapping.c |    3 ++
 3 files changed, 60 insertions(+), 31 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..35a319a76c82 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -382,9 +382,22 @@ void kill_dev_dax(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct inode *inode = dax_inode(dax_dev);
+	struct page *page;
 
 	kill_dax(dax_dev);
-	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+	/*
+	 * New mappings are blocked. Wait for all GUP users to release
+	 * their pins.
+	 */
+	do {
+		page = dax_zap_mappings(inode->i_mapping);
+		if (!page)
+			break;
+		__wait_var_event(page, dax_page_idle(page));
+	} while (true);
+
+	truncate_inode_pages(inode->i_mapping, 0);
 
 	/*
 	 * Dynamic dax region have the pgmap allocated via dev_kzalloc()
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 5494d745ced5..7f306939807e 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -73,38 +73,15 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 	return -1;
 }
 
-static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
-			      unsigned long fault_size)
-{
-	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
-	struct file *filp = vmf->vma->vm_file;
-	struct dev_dax *dev_dax = filp->private_data;
-	pgoff_t pgoff;
-
-	/* mapping is only set on the head */
-	if (dev_dax->pgmap->vmemmap_shift)
-		nr_pages = 1;
-
-	pgoff = linear_page_index(vmf->vma,
-			ALIGN(vmf->address, fault_size));
-
-	for (i = 0; i < nr_pages; i++) {
-		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-
-		page = compound_head(page);
-		if (page->mapping)
-			continue;
-
-		page->mapping = filp->f_mapping;
-		page->index = pgoff + i;
-	}
-}
-
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
@@ -128,7 +105,16 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, 0);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, 0);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
 }
@@ -136,10 +122,14 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
 	pgoff_t pgoff;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
@@ -171,7 +161,16 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, PMD_ORDER);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, DAX_PMD);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -180,10 +179,14 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pud_addr = vmf->address & PUD_MASK;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
 	pgoff_t pgoff;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PUD_SIZE;
 
@@ -216,7 +219,16 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, PUD_ORDER);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, DAX_PUD);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -494,3 +506,4 @@ MODULE_LICENSE("GPL v2");
 module_init(dax_init);
 module_exit(dax_exit);
 MODULE_ALIAS_DAX_DEVICE(0);
+MODULE_IMPORT_NS(DAX);
diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index b5a5196f8831..9981eebb2dc5 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -266,6 +266,7 @@ void dax_unlock_entry(struct xa_state *xas, void *entry)
 	WARN_ON(!dax_is_locked(old));
 	dax_wake_entry(xas, entry, WAKE_NEXT);
 }
+EXPORT_SYMBOL_NS_GPL(dax_unlock_entry, DAX);
 
 /*
  * Return: The entry stored at this location before it was locked.
@@ -666,6 +667,7 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 	xas_unlock_irq(xas);
 	return xa_mk_internal(VM_FAULT_FALLBACK);
 }
+EXPORT_SYMBOL_NS_GPL(dax_grab_mapping_entry, DAX);
 
 static void *dax_zap_entry(struct xa_state *xas, void *entry)
 {
@@ -910,6 +912,7 @@ vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 	*pentry = entry;
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(dax_insert_entry, DAX);
 
 int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		      struct address_space *mapping, void *entry)


