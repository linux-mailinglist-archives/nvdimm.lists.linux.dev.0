Return-Path: <nvdimm+bounces-3469-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F064FAEC2
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 18:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 5F51C3E0FF2
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 16:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17855138C;
	Sun, 10 Apr 2022 16:09:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0201375
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 16:09:36 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AChoaW6AtXsWcNxVW/1biw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fUQex1G8lgzcOzjcdUGiFP/zfYmOke9AnbY++oR8FvJeAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkHhcwmj/3auK79SMkjPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9NljyPhME3xtNWqbS+V?=
 =?us-ascii?q?AUoIrbR3u8aVnG0FgknZ/YapeSXeyPXXcu7iheun2HX6/lnEkA6FYMC/eNwG2t?=
 =?us-ascii?q?P6boTLzVlRhCIh8q3xryhQ+Vhj8hlK9PkVKsTs3cmz3fGDPIiQJnGWI3L48NV2?=
 =?us-ascii?q?HE7gcUmNfrceM0fZhJsYQ7GbhkJPU0YYLo6neG1ljz6dhVbtluepuww+We75Ap?=
 =?us-ascii?q?v3LnoNfLRe8eWXoNRn0CFtiTK8nqRKhERNPSb0ibD/n/Eru3Gmy69U4IPPLqi/?=
 =?us-ascii?q?/VujRuYwWl7IBkXU0ar5PeihkOgVtZ3NUMZ4GwtoLI0+UjtScPyNzW8oXiZrls?=
 =?us-ascii?q?fVsBWHukS9g6A0OzX7hyfC2xCSSROAPQitckrVXk62EShgdzkH3psvaeTRHbb8?=
 =?us-ascii?q?a2bxQ5ekwB9wXQqPHdCFFVapYK45txbs/4Gdf47eIbdszE/MW2YL+i2kRUD?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AlD4Ai680vM+pUCyHVNtuk+A+I+orL9Y04lQ7?=
 =?us-ascii?q?vn2YSXRuE/Bw8Pre5cjztCWE8Ar5N0tQ+uxoVJPufZqYz+8Q3WBzB8bFYOCFgh?=
 =?us-ascii?q?rLEGgK1+KLqFeMdxEWtNQtspuIGJIfNDSfNzZHZL7BkWyF+sgbsaW62ZHtleHD?=
 =?us-ascii?q?1G1sUA0vT6lh6j1yAgGdHlYefng9ObMJUIqb+tFcpyetPVAebsGADHEDWOTZ4/?=
 =?us-ascii?q?LRkpaOW296OzcXrBmJkSiz6KP3VzyR3hIlWTtJxrs4tUjp+jaJnZmejw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123453823"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Apr 2022 00:09:14 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id C00324D17163;
	Mon, 11 Apr 2022 00:09:08 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Mon, 11 Apr 2022 00:09:08 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Mon, 11 Apr 2022 00:09:11 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Mon, 11 Apr 2022 00:09:07 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v12 4/7] fsdax: Introduce dax_lock_mapping_entry()
Date: Mon, 11 Apr 2022 00:09:01 +0800
Message-ID: <20220410160904.3758789-5-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: C00324D17163.AF597
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

The current dax_lock_page() locks dax entry by obtaining mapping and
index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
to lock a specific dax entry corresponding to this file's mapping,index.
And output the page corresponding to the specific dax entry for caller
use.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c            | 63 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h | 15 +++++++++++
 2 files changed, 78 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 1ac12e877f4f..57efd3f73655 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -455,6 +455,69 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
 	dax_unlock_entry(&xas, (void *)cookie);
 }
 
+/*
+ * dax_lock_mapping_entry - Lock the DAX entry corresponding to a mapping
+ * @mapping: the file's mapping whose entry we want to lock
+ * @index: the offset within this file
+ * @page: output the dax page corresponding to this dax entry
+ *
+ * Return: A cookie to pass to dax_unlock_mapping_entry() or 0 if the entry
+ * could not be locked.
+ */
+dax_entry_t dax_lock_mapping_entry(struct address_space *mapping, pgoff_t index,
+		struct page **page)
+{
+	XA_STATE(xas, NULL, 0);
+	void *entry;
+
+	rcu_read_lock();
+	for (;;) {
+		entry = NULL;
+		if (!dax_mapping(mapping))
+			break;
+
+		xas.xa = &mapping->i_pages;
+		xas_lock_irq(&xas);
+		xas_set(&xas, index);
+		entry = xas_load(&xas);
+		if (dax_is_locked(entry)) {
+			rcu_read_unlock();
+			wait_entry_unlocked(&xas, entry);
+			rcu_read_lock();
+			continue;
+		}
+		if (!entry ||
+		    dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+			/*
+			 * Because we are looking for entry from file's mapping
+			 * and index, so the entry may not be inserted for now,
+			 * or even a zero/empty entry.  We don't think this is
+			 * an error case.  So, return a special value and do
+			 * not output @page.
+			 */
+			entry = (void *)~0UL;
+		} else {
+			*page = pfn_to_page(dax_to_pfn(entry));
+			dax_lock_entry(&xas, entry);
+		}
+		xas_unlock_irq(&xas);
+		break;
+	}
+	rcu_read_unlock();
+	return (dax_entry_t)entry;
+}
+
+void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index,
+		dax_entry_t cookie)
+{
+	XA_STATE(xas, &mapping->i_pages, index);
+
+	if (cookie == ~0UL)
+		return;
+
+	dax_unlock_entry(&xas, (void *)cookie);
+}
+
 /*
  * Find page cache entry at given index. If it is a DAX entry, return it
  * with the entry locked. If the page cache doesn't contain an entry at
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9c426a207ba8..c152f315d1c9 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -143,6 +143,10 @@ struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
+dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
+		unsigned long index, struct page **page);
+void dax_unlock_mapping_entry(struct address_space *mapping,
+		unsigned long index, dax_entry_t cookie);
 #else
 static inline struct page *dax_layout_busy_page(struct address_space *mapping)
 {
@@ -170,6 +174,17 @@ static inline dax_entry_t dax_lock_page(struct page *page)
 static inline void dax_unlock_page(struct page *page, dax_entry_t cookie)
 {
 }
+
+static inline dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
+		unsigned long index, struct page **page)
+{
+	return 0;
+}
+
+static inline void dax_unlock_mapping_entry(struct address_space *mapping,
+		unsigned long index, dax_entry_t cookie)
+{
+}
 #endif
 
 int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-- 
2.35.1




