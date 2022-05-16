Return-Path: <nvdimm+bounces-3837-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 395E4528CCA
	for <lists+linux-nvdimm@lfdr.de>; Mon, 16 May 2022 20:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 775702809A5
	for <lists+linux-nvdimm@lfdr.de>; Mon, 16 May 2022 18:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F871377;
	Mon, 16 May 2022 18:21:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178AC136B
	for <nvdimm@lists.linux.dev>; Mon, 16 May 2022 18:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652725315; x=1684261315;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oLHQEvkPPnYrdI/9V6HkCwio6IKvCNslsChgOGiucHs=;
  b=mBGrku4FZVJ9l1G+pBYAllEH+vHZFppaVmihhCWOASnXHF2gbkV7SZYY
   wznLa6VU+r+wiHzc/ElgzqgiLcaoXrE+exXvtwze7JredJcChAsKZUZzG
   Fx2NChL7k25W1/AB70mKkV+EsJ7gLKblqEk7SNXuUYwz6FsJHjurAxjg0
   omZO0KNRCyHVfbGSVC5v1aUSSIowB7b0+cSrgINIkhvXAJnnBdlxQkPbV
   gHOGYXt3dLHnIZtSui3KBkWfoRBJHm8z/7mFn+pnkIpWc5Ps6TvkouG3c
   JBEWuvOj9myv48MbIfkP9wZa6Ti/8ZJX9EYkDAmbPJpNq6OyuupmBcsEq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="258486537"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="258486537"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 11:21:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="816519835"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 11:21:46 -0700
Subject: [PATCH v11 2/7] x86/mce: relocate set{clear}_mce_nospec() functions
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jane Chu <jane.chu@oracle.com>,
 Borislav Petkov <bp@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
 x86@kernel.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Mon, 16 May 2022 11:21:46 -0700
Message-ID: <165272527328.90175.8336008202048685278.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165247798860.4117683.4554602198740624216.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165247798860.4117683.4554602198740624216.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jane Chu <jane.chu@oracle.com>

Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
file where they belong.

While at it, fixup a function name in a comment.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
[sfr: gate {set,clear}_mce_nospec() by CONFIG_X86_64]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v10:
- Fix a compile error with 32-bit builds (Stephen)

 arch/x86/include/asm/set_memory.h |   52 -------------------------------------
 arch/x86/mm/pat/set_memory.c      |   50 ++++++++++++++++++++++++++++++++++--
 include/linux/set_memory.h        |    8 +++---
 3 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 78ca53512486..b45c4d27fd46 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -86,56 +86,4 @@ bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
 
-#ifdef CONFIG_X86_64
-/*
- * Prevent speculative access to the page by either unmapping
- * it (if we do not require access to any part of the page) or
- * marking it uncacheable (if we want to try to retrieve data
- * from non-poisoned lines in the page).
- */
-static inline int set_mce_nospec(unsigned long pfn, bool unmap)
-{
-	unsigned long decoy_addr;
-	int rc;
-
-	/* SGX pages are not in the 1:1 map */
-	if (arch_is_platform_page(pfn << PAGE_SHIFT))
-		return 0;
-	/*
-	 * We would like to just call:
-	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
-	 * but doing that would radically increase the odds of a
-	 * speculative access to the poison page because we'd have
-	 * the virtual address of the kernel 1:1 mapping sitting
-	 * around in registers.
-	 * Instead we get tricky.  We create a non-canonical address
-	 * that looks just like the one we want, but has bit 63 flipped.
-	 * This relies on set_memory_XX() properly sanitizing any __pa()
-	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
-	 */
-	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
-
-	if (unmap)
-		rc = set_memory_np(decoy_addr, 1);
-	else
-		rc = set_memory_uc(decoy_addr, 1);
-	if (rc)
-		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
-	return rc;
-}
-#define set_mce_nospec set_mce_nospec
-
-/* Restore full speculative operation to the pfn. */
-static inline int clear_mce_nospec(unsigned long pfn)
-{
-	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
-}
-#define clear_mce_nospec clear_mce_nospec
-#else
-/*
- * Few people would run a 32-bit kernel on a machine that supports
- * recoverable errors because they have too much memory to boot 32-bit.
- */
-#endif
-
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index abf5ed76e4b7..0caf4b0edcbc 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -19,6 +19,7 @@
 #include <linux/vmstat.h>
 #include <linux/kernel.h>
 #include <linux/cc_platform.h>
+#include <linux/set_memory.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -29,7 +30,6 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/memtype.h>
-#include <asm/set_memory.h>
 #include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
 
@@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
 }
 
 /*
- * _set_memory_prot is an internal helper for callers that have been passed
+ * __set_memory_prot is an internal helper for callers that have been passed
  * a pgprot_t value from upper layers and a reservation has already been taken.
  * If you want to set the pgprot to a specific page protocol, use the
  * set_memory_xx() functions.
@@ -1925,6 +1925,52 @@ int set_memory_wb(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+/*
+ * Prevent speculative access to the page by either unmapping
+ * it (if we do not require access to any part of the page) or
+ * marking it uncacheable (if we want to try to retrieve data
+ * from non-poisoned lines in the page).
+ */
+#ifdef CONFIG_X86_64
+int set_mce_nospec(unsigned long pfn, bool unmap)
+{
+	unsigned long decoy_addr;
+	int rc;
+
+	/* SGX pages are not in the 1:1 map */
+	if (arch_is_platform_page(pfn << PAGE_SHIFT))
+		return 0;
+	/*
+	 * We would like to just call:
+	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
+	 * but doing that would radically increase the odds of a
+	 * speculative access to the poison page because we'd have
+	 * the virtual address of the kernel 1:1 mapping sitting
+	 * around in registers.
+	 * Instead we get tricky.  We create a non-canonical address
+	 * that looks just like the one we want, but has bit 63 flipped.
+	 * This relies on set_memory_XX() properly sanitizing any __pa()
+	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
+	 */
+	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
+
+	if (unmap)
+		rc = set_memory_np(decoy_addr, 1);
+	else
+		rc = set_memory_uc(decoy_addr, 1);
+	if (rc)
+		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
+	return rc;
+}
+
+/* Restore full speculative operation to the pfn. */
+int clear_mce_nospec(unsigned long pfn)
+{
+	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
+}
+EXPORT_SYMBOL_GPL(clear_mce_nospec);
+#endif /* CONFIG_X86_64 */
+
 int set_memory_x(unsigned long addr, int numpages)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index f36be5166c19..683a6c3f7179 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -42,14 +42,14 @@ static inline bool can_set_direct_map(void)
 #endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
-#ifndef set_mce_nospec
+#ifdef CONFIG_X86_64
+int set_mce_nospec(unsigned long pfn, bool unmap);
+int clear_mce_nospec(unsigned long pfn);
+#else
 static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }
-#endif
-
-#ifndef clear_mce_nospec
 static inline int clear_mce_nospec(unsigned long pfn)
 {
 	return 0;


