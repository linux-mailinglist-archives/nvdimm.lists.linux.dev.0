Return-Path: <nvdimm+bounces-2322-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF3F47F73A
	for <lists+linux-nvdimm@lfdr.de>; Sun, 26 Dec 2021 15:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 130C61C0939
	for <lists+linux-nvdimm@lfdr.de>; Sun, 26 Dec 2021 14:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7582CA7;
	Sun, 26 Dec 2021 14:35:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F3A2C9C
	for <nvdimm@lists.linux.dev>; Sun, 26 Dec 2021 14:35:10 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AwMMfG6/yLDvGDhV1Qul4DrUD63+TJUtcMsCJ2f8?=
 =?us-ascii?q?bfWQNrUp002APyzcdCG6HOvuDMGLyf412YI62oElVu5LSzINmG1dlrnsFo1Bi8?=
 =?us-ascii?q?5ScXYvDRqvT04J+FuWaFQQ/qZx2huDodKjYdVeB4Ef9WlTdhSMkj/jRHOCiULe?=
 =?us-ascii?q?s1h1ZHmeIdg9w0HqPpMZp2uaEsfDha++8kYuaT//3YTdJ6BYoWo4g0J9vnTs01?=
 =?us-ascii?q?BjEVJz0iXRlDRxDlAe2e3D4l/vzL4npR5fzatE88uJX24/+IL+FEmPxp3/BC/u?=
 =?us-ascii?q?ulPD1b08LXqXPewOJjxK6WYD72l4b+HN0if19aZLwam8O49mNt8pswdNWpNq+T?=
 =?us-ascii?q?xw1FqPRmuUBSAQeGCZ7VUFD0OaecCXh6pzMlCUqdFOpmZ2CFnoeMYQG++pfD3t?=
 =?us-ascii?q?J8PsCIjERKBuEgoqewLm7YuhqiN4qIMTiMMUYoH4I5T3QC7AkB4/CR6HL7NpD9?=
 =?us-ascii?q?DY2ms1KW/3ZYqIxZThwaxLPSx5CIFEaDNQ5hujArn3+dSBI7VeQjakp6mPQigt?=
 =?us-ascii?q?r39DFNsTZe9mPbcFUhVqD4GbH+XnpRB0XKrS3yzOD/zSnhvLnmjnyU4YfUra/8?=
 =?us-ascii?q?5ZChFyV23xWBgYaWEW2pdGnhUOkHdFSMUoZ/mwpt6da3EiqSMTtGh61uniJujY?=
 =?us-ascii?q?CVNdKVe438geAzuzT+QnxLmwFSCNRLcwor+coSjEwkFyEhdXkAXpoqrL9dJ433?=
 =?us-ascii?q?t94thvrYW5MczBEPnRCEGM4DxDYiNlbpnryohxLScZZVuHIJAw=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ANvZ2kKCVKg/7mnblHemQ55DYdb4zR+YMi2TD?=
 =?us-ascii?q?tnoBLSC9F/b0qynAppomPGDP4gr5NEtApTniAtjkfZq/z+8X3WB5B97LMzUO01?=
 =?us-ascii?q?HYTr2Kg7GD/xTQXwX69sN4kZxrarVCDrTLZmRSvILX5xaZHr8brOW6zA=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,237,1635177600"; 
   d="scan'208";a="119563873"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Dec 2021 22:35:10 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 5C3FA4D146F4;
	Sun, 26 Dec 2021 22:35:08 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 26 Dec 2021 22:35:06 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 26 Dec 2021 22:35:06 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v9 10/10] fsdax: set a CoW flag when associate reflink mappings
Date: Sun, 26 Dec 2021 22:34:39 +0800
Message-ID: <20211226143439.3985960-11-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 5C3FA4D146F4.A169C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Introduce a FS_DAX_MAPPING_COW flag to support association with CoW file
mappings.  In this case, the dax-RMAP already takes the responsibility
to look up for shared files by given dax page.  The page->mapping is no
longer to used for rmap but for marking that this dax page is shared.
And to make sure disassociation works fine, we use page->index as
refcount, and clear page->mapping to the initial state when page->index
is decreased to 0.

With the help of this new flag, it is able to distinguish normal case
and CoW case, and keep the warning in normal case.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ad8ceea1f54c..e72ec712c002 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -335,12 +335,46 @@ static unsigned long dax_end_pfn(void *entry)
 			pfn < dax_end_pfn(entry); pfn++)
 
 /*
- * TODO: for reflink+dax we need a way to associate a single page with
- * multiple address_space instances at different linear_page_index()
- * offsets.
+ * Set FS_DAX_MAPPING_COW flag on the last bit of page->mapping to indicate that
+ * this is a reflink case.  In this case, we associate this page->mapping with
+ * file mapping at the first time and only once.
+ */
+#define FS_DAX_MAPPING_COW	1UL
+
+#define MAPPING_SET_COW(m)	(m = (struct address_space *)FS_DAX_MAPPING_COW)
+#define MAPPING_TEST_COW(m)	(((unsigned long)m & FS_DAX_MAPPING_COW) == \
+					FS_DAX_MAPPING_COW)
+
+/*
+ * Set or Update the page->mapping with FS_DAX_MAPPING_COW flag.
+ * Return true if it is an Update.
+ */
+static inline bool dax_mapping_set_cow(struct page *page)
+{
+	if (page->mapping) {
+		/* flag already set  */
+		if (MAPPING_TEST_COW(page->mapping))
+			return false;
+
+		/*
+		 * This page has been mapped even before it is shared, just
+		 * need to set this FS_DAX_MAPPING_COW flag.
+		 */
+		MAPPING_SET_COW(page->mapping);
+		return true;
+	}
+	/* Newly associate CoW mapping */
+	MAPPING_SET_COW(page->mapping);
+	return false;
+}
+
+/*
+ * When it is called in dax_insert_entry(), the cow flag will indicate that
+ * whether this entry is shared by multiple files.  If so, set the page->mapping
+ * to be FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address)
+		struct vm_area_struct *vma, unsigned long address, bool cow)
 {
 	unsigned long size = dax_entry_size(entry), pfn, index;
 	int i = 0;
@@ -352,9 +386,17 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(page->mapping);
-		page->mapping = mapping;
-		page->index = index + i++;
+		if (cow) {
+			if (dax_mapping_set_cow(page)) {
+				/* Was normal, now updated to CoW */
+				page->index = 2;
+			} else
+				page->index++;
+		} else {
+			WARN_ON_ONCE(page->mapping);
+			page->mapping = mapping;
+			page->index = index + i++;
+		}
 	}
 }
 
@@ -370,7 +412,12 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+		if (!MAPPING_TEST_COW(page->mapping)) {
+			/* keep the CoW flag if this page is still shared */
+			if (page->index-- > 0)
+				continue;
+		} else
+			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
 		page->mapping = NULL;
 		page->index = 0;
 	}
@@ -829,7 +876,8 @@ static void *dax_insert_entry(struct xa_state *xas,
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
+		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
+				false);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
-- 
2.34.1




