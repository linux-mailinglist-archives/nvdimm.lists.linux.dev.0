Return-Path: <nvdimm+bounces-3784-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1EB51EE4C
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 16:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id DA1C52E0A16
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 14:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260F31863;
	Sun,  8 May 2022 14:37:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B101854
	for <nvdimm@lists.linux.dev>; Sun,  8 May 2022 14:37:41 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AmllfP6B+qzYrwRVW/8Xiw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fAAm+hT9whmAPzmJKX22BP6zba2PxfIxyb9jj/UoAu5KAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkHhcwmj/3auK79SMkjPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9NljyPhME3xtNWqbS+V?=
 =?us-ascii?q?AUoIrbR3u8aVnG0FgknZ/Eep+KYeijXXcu7iheun2HX6/lnEkA6FYMC/eNwG2t?=
 =?us-ascii?q?P6boTLzVlRhSCgee3ybW7R8Fsm808IcitN4Qa0llgxjHxDPAoW5nPTqzGo9hC0?=
 =?us-ascii?q?18YmcFKGef2ZswXczNjYR3MJRpVNT8/BJs42uXumXj7dzxRrUm9pKwr7myVxwt?=
 =?us-ascii?q?0uJDhMsXSfNOiRshPmEuc4GXc8AzRBhAcKczazD+t8WyljeyJmjn0MKoUCrG58?=
 =?us-ascii?q?/tChFyI2ndVDBwQSEv9rfSn4ma+UNJ3L1cIvCYjxYA0/Uu6R5/9WAe5r2OPvh8?=
 =?us-ascii?q?0XddbVeY97WmlyKPS7kCSBnUsSSRIY9gr8sQxQFQCzFCOm9/2FDpHq6CORDSR+?=
 =?us-ascii?q?9+8qTK0JDhQI3QOaDEJSSMb7NT55oI+lBTCSpBkCqHdptn0HyzghjOHti4zg50?=
 =?us-ascii?q?NgsMRkaa251bKh3SrvJehZgo04BjHG3Kr9Stna4O/IY+l817W6bBHNonxZkeAp?=
 =?us-ascii?q?n8sicWY7f5ICZCLiTzLR/8CWqyqj8tpmhW0bUVHRsFnrmryvSX4O9043d23H28?=
 =?us-ascii?q?xWu5sRNMjSBS7Vdtt2aJu?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AkPYybaoAs8YH77NhmKfgtb8aV5rPeYIsimQD?=
 =?us-ascii?q?101hICG8cqSj+fxG+85rsyMc6QxhIU3I9urhBEDtex/hHNtOkOws1NSZLW7bUQ?=
 =?us-ascii?q?mTXeJfBOLZqlWKcUDDH6xmpMNdmsNFaeEYY2IUsS+D2njbLz8/+qj7zImYwffZ?=
 =?us-ascii?q?02x2TRxnL4Vp7wJCAA6dFUFsLTM2fqYRJd6N4NZdvTq8dTAyZsS/PHMMWO/OvJ?=
 =?us-ascii?q?nlj5TjCCR2fSIP2U2fiy+y8r7mH1y91hcaaTlGxrAv6izkvmXCl92ej80=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124075738"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 May 2022 22:36:31 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 4423C4D1718C;
	Sun,  8 May 2022 22:36:26 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 8 May 2022 22:36:28 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 8 May 2022 22:36:24 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>, <naoya.horiguchi@nec.com>,
	<linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v14 05/07] mm: Introduce mf_dax_kill_procs() for fsdax case
Date: Sun, 8 May 2022 22:36:11 +0800
Message-ID: <20220508143620.1775214-6-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 4423C4D1718C.AEF7C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This new function is a variant of mf_generic_kill_procs that accepts a
file, offset pair instead of a struct to support multiple files sharing
a DAX mapping.  It is intended to be called by the file systems as part
of the memory_failure handler after the file system performed a reverse
mapping from the storage address to the file and file offset.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/mm.h  |  2 +
 mm/memory-failure.c | 96 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index de32c0383387..e2c0f69f0660 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3227,6 +3227,8 @@ enum mf_flags {
 	MF_SOFT_OFFLINE = 1 << 3,
 	MF_UNPOISON = 1 << 4,
 };
+int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
+		      unsigned long count, int mf_flags);
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aeb19593af9c..aedfc5097420 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -295,10 +295,9 @@ void shake_page(struct page *p)
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
-static unsigned long dev_pagemap_mapping_shift(struct page *page,
-		struct vm_area_struct *vma)
+static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
+		unsigned long address)
 {
-	unsigned long address = vma_address(page, vma);
 	unsigned long ret = 0;
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -338,10 +337,14 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
 /*
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
+ *
+ * Notice: @fsdax_pgoff is used only when @p is a fsdax page.
+ *   In other cases, such as anonymous and file-backend page, the address to be
+ *   killed can be caculated by @p itself.
  */
 static void add_to_kill(struct task_struct *tsk, struct page *p,
-		       struct vm_area_struct *vma,
-		       struct list_head *to_kill)
+			pgoff_t fsdax_pgoff, struct vm_area_struct *vma,
+			struct list_head *to_kill)
 {
 	struct to_kill *tk;
 
@@ -352,9 +355,15 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 	}
 
 	tk->addr = page_address_in_vma(p, vma);
-	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
-	else
+	if (is_zone_device_page(p)) {
+		/*
+		 * Since page->mapping is not used for fsdax, we need
+		 * calculate the address based on the vma.
+		 */
+		if (p->pgmap->type == MEMORY_DEVICE_FS_DAX)
+			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
+		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
+	} else
 		tk->size_shift = page_shift(compound_head(p));
 
 	/*
@@ -503,7 +512,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 			if (!page_mapped_in_vma(page, vma))
 				continue;
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, 0, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -539,13 +548,41 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 			 * to be informed of all such data corruptions.
 			 */
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, 0, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
 	i_mmap_unlock_read(mapping);
 }
 
+#ifdef CONFIG_FS_DAX
+/*
+ * Collect processes when the error hit a fsdax page.
+ */
+static void collect_procs_fsdax(struct page *page,
+		struct address_space *mapping, pgoff_t pgoff,
+		struct list_head *to_kill)
+{
+	struct vm_area_struct *vma;
+	struct task_struct *tsk;
+
+	i_mmap_lock_read(mapping);
+	read_lock(&tasklist_lock);
+	for_each_process(tsk) {
+		struct task_struct *t = task_early_kill(tsk, true);
+
+		if (!t)
+			continue;
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+			if (vma->vm_mm == t->mm)
+				add_to_kill(t, page, pgoff, vma, to_kill);
+		}
+	}
+	read_unlock(&tasklist_lock);
+	i_mmap_unlock_read(mapping);
+}
+#endif /* CONFIG_FS_DAX */
+
 /*
  * Collect the processes who have the corrupted page mapped to kill.
  */
@@ -1580,6 +1617,45 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	return rc;
 }
 
+#ifdef CONFIG_FS_DAX
+/**
+ * mf_dax_kill_procs - Collect and kill processes who are using this file range
+ * @mapping:	address_space of the file in use
+ * @index:	start pgoff of the range within the file
+ * @count:	length of the range, in unit of PAGE_SIZE
+ * @mf_flags:	memory failure flags
+ */
+int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
+		unsigned long count, int mf_flags)
+{
+	LIST_HEAD(to_kill);
+	dax_entry_t cookie;
+	struct page *page;
+	size_t end = index + count;
+
+	mf_flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+
+	for (; index < end; index++) {
+		page = NULL;
+		cookie = dax_lock_mapping_entry(mapping, index, &page);
+		if (!cookie)
+			return -EBUSY;
+		if (!page)
+			goto unlock;
+
+		SetPageHWPoison(page);
+
+		collect_procs_fsdax(page, mapping, index, &to_kill);
+		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
+				index, mf_flags);
+unlock:
+		dax_unlock_mapping_entry(mapping, index, cookie);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
+#endif /* CONFIG_FS_DAX */
+
 /*
  * Called from hugetlb code with hugetlb_lock held.
  *
-- 
2.35.1




