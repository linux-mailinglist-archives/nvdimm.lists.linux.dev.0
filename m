Return-Path: <nvdimm+bounces-3771-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB24851EE15
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 16:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C6DE280A62
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 14:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E707D1855;
	Sun,  8 May 2022 14:36:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845F1110A
	for <nvdimm@lists.linux.dev>; Sun,  8 May 2022 14:36:39 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AdgDLBagHbyfnfMQ3dbsb8h3gX161jBEKZh0ujC4?=
 =?us-ascii?q?5NGQNrF6WrkVRzGYfDW6FOazeMWD0edkjPou+8U5VsJCEyd5mGgE4q3w8FHgiR?=
 =?us-ascii?q?ejtX4rAdhiqV8+xwmwvdGo+toNGLICowPkcFhcwnT/wdOixxZVA/fvQHOCkUra?=
 =?us-ascii?q?dYnkZqTJME0/NtzoywobVvaY42bBVMyvV0T/Di5W31G2NglaYAUpIg063ky6Di?=
 =?us-ascii?q?dyp0N8uUvPSUtgQ1LPWvyF94JvyvshdJVOgKmVfNrbSq+ouUNiEEm3lExcFUrt?=
 =?us-ascii?q?Jk57wdAsEX7zTIROTzHFRXsBOgDAb/mprjPl9b6FaNC+7iB3Q9zx14M9QvJqrW?=
 =?us-ascii?q?EEnOLbQsOoAURhECDw4NqpDkFPCCSHl7ZTMkhKdIhMAxN0rVinaJ7Yw9u9pAG1?=
 =?us-ascii?q?m++YfLTcXZBGfwemxxdqTTuhqg8UqK8nmFIMCs25tzHfSCvNOaZDIQ43L49FC1?=
 =?us-ascii?q?Ts9j8wIGuzRD+IGaD5rfTzBZRNVM1saAZ54m/2n7lHzejseqhSKpK4z4mHW1yR?=
 =?us-ascii?q?w1qTgNJzefdnibclXgUGeqUrF8n7/DxVcM8aQoRKB83SxlqrKmAv4RosZF/u/7?=
 =?us-ascii?q?PECqFuNym0WDTUSVECnur+9i0ijS5RTJlJ80iolrYA271DtQtSVdxuxp2+N+B4?=
 =?us-ascii?q?bQdtfDuY66SmLx6GS6AGcbkAGRzhMLtcmqecxXzUh0lLPlNTsbRR1v7qRRW2M8?=
 =?us-ascii?q?J+PsCi/fyQYRUcGZCkZXU4L+NXuvow3pgzAQ8wlE6OviNDxXzbqzFiiqCk4mqV?=
 =?us-ascii?q?WjsMR0ai/1U7IjijqpZXTSAMxoALNUQqN6gJ/eZ7gd4KzwUbU4OwGL4uDSFSF+?=
 =?us-ascii?q?n8elKC28uEUCrmfmSqMXqMJHbe097CCKjKanF0HInWL31xB4Fb6JcYJvm44fxw?=
 =?us-ascii?q?vb645lfbSSBe7kWtsCFV7ZhNGtZNKXr8=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A/K8r5ar5PcUalDfTj2WU/e4aV5rPeYIsimQD?=
 =?us-ascii?q?101hICG8cqSj+fxG+85rsyMc6QxhIU3I9urhBEDtex/hHNtOkOws1NSZLW7bUQ?=
 =?us-ascii?q?mTXeJfBOLZqlWKcUDDH6xmpMNdmsNFaeEYY2IUsS+D2njbLz8/+qj7zImYwffZ?=
 =?us-ascii?q?02x2TRxnL4Vp7wJCAA6dFUFsLTM2fqYRJd6N4NZdvTq8dTAyZsS/PHMMWO/OvJ?=
 =?us-ascii?q?nlj5TjCCR2fSIP2U2fiy+y8r7mH1y91hcaaTlGxrAv6izkvmXCl92ej80=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124075739"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 May 2022 22:36:31 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id E5CF24D17197;
	Sun,  8 May 2022 22:36:27 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 8 May 2022 22:36:31 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 8 May 2022 22:36:26 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>, <naoya.horiguchi@nec.com>,
	<linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v14 07/07] fsdax: set a CoW flag when associate reflink mappings
Date: Sun, 8 May 2022 22:36:13 +0800
Message-ID: <20220508143620.1775214-8-ruansy.fnst@fujitsu.com>
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
X-yoursite-MailScanner-ID: E5CF24D17197.AF878
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Introduce a PAGE_MAPPING_DAX_COW flag to support association with CoW file
mappings.  In this case, since the dax-rmap has already took the
responsibility to look up for shared files by given dax page,
the page->mapping is no longer to used for rmap but for marking that
this dax page is shared.  And to make sure disassociation works fine, we
use page->index as refcount, and clear page->mapping to the initial
state when page->index is decreased to 0.

With the help of this new flag, it is able to distinguish normal case
and CoW case, and keep the warning in normal case.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/dax.c                   | 50 +++++++++++++++++++++++++++++++-------
 include/linux/page-flags.h |  6 +++++
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 57efd3f73655..4d3dfc8bee33 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -334,13 +334,35 @@ static unsigned long dax_end_pfn(void *entry)
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
+static inline bool dax_mapping_is_cow(struct address_space *mapping)
+{
+	return (unsigned long)mapping == PAGE_MAPPING_DAX_COW;
+}
+
 /*
- * TODO: for reflink+dax we need a way to associate a single page with
- * multiple address_space instances at different linear_page_index()
- * offsets.
+ * Set the page->mapping with FS_DAX_MAPPING_COW flag, increase the refcount.
+ */
+static inline void dax_mapping_set_cow(struct page *page)
+{
+	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_COW) {
+		/*
+		 * Reset the index if the page was already mapped
+		 * regularly before.
+		 */
+		if (page->mapping)
+			page->index = 1;
+		page->mapping = (void *)PAGE_MAPPING_DAX_COW;
+	}
+	page->index++;
+}
+
+/*
+ * When it is called in dax_insert_entry(), the cow flag will indicate that
+ * whether this entry is shared by multiple files.  If so, set the page->mapping
+ * FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address)
+		struct vm_area_struct *vma, unsigned long address, bool cow)
 {
 	unsigned long size = dax_entry_size(entry), pfn, index;
 	int i = 0;
@@ -352,9 +374,13 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(page->mapping);
-		page->mapping = mapping;
-		page->index = index + i++;
+		if (cow) {
+			dax_mapping_set_cow(page);
+		} else {
+			WARN_ON_ONCE(page->mapping);
+			page->mapping = mapping;
+			page->index = index + i++;
+		}
 	}
 }
 
@@ -370,7 +396,12 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+		if (dax_mapping_is_cow(page->mapping)) {
+			/* keep the CoW flag if this page is still shared */
+			if (page->index-- > 0)
+				continue;
+		} else
+			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
 		page->mapping = NULL;
 		page->index = 0;
 	}
@@ -829,7 +860,8 @@ static void *dax_insert_entry(struct xa_state *xas,
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
+		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
+				false);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index fe47ee8dc258..cad9aeb5e75c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -650,6 +650,12 @@ __PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
 #define PAGE_MAPPING_KSM	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 
+/*
+ * Different with flags above, this flag is used only for fsdax mode.  It
+ * indicates that this page->mapping is now under reflink case.
+ */
+#define PAGE_MAPPING_DAX_COW	0x1
+
 static __always_inline int PageMappingFlags(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
-- 
2.35.1




