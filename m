Return-Path: <nvdimm+bounces-3770-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F19151EE14
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 16:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id DAE1E2E09C3
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 14:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B900184D;
	Sun,  8 May 2022 14:36:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826EA10ED
	for <nvdimm@lists.linux.dev>; Sun,  8 May 2022 14:36:39 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3ABH7Aja0A+gWrByATGPbD5T9wkn2cJEfYwER7XOP?=
 =?us-ascii?q?LsXnJgD9z3jYAzDQcDWGOO6qNZTGhfdBwOoqy/U4GvsDRzNY2QQE+nZ1PZygU8?=
 =?us-ascii?q?JKaX7x1DatR0xu6d5SFFAQ+hyknQoGowPscEzmM9n9BDpC79SMmjfvQH+KlYAL?=
 =?us-ascii?q?5EnsZqTFMGX5JZS1Ly7ZRbr5A2bBVMivV0T/Ai5S31GyNh1aYBlkpB5er83uDi?=
 =?us-ascii?q?hhdVAQw5TTSbdgT1LPXeuJ84Jg3fcldJFOgKmVY83LTegrN8F251juxExYFAdX?=
 =?us-ascii?q?jnKv5c1ERX/jZOg3mZnh+AvDk20Yd4HdplPtT2Pk0MC+7jx2Tgtl308QLu5qrV?=
 =?us-ascii?q?S8nI6/NhP8AFRJfFkmSOIUfouOffiXg7ZX7I0ruNiGEL+9VJE0/I4wU0uhtBmR?=
 =?us-ascii?q?J7/YZNHYGaRXrr+a3xre6Q+5si+wjMcD0MYJZsXZlpRnZBvYOQJbNWazG6NZUm?=
 =?us-ascii?q?jAqiahmAvfaY9sxaDxhdh3MbhRDfFANB/oWkO6uwHu5bDxcrFOcoLEf4m7PwQg?=
 =?us-ascii?q?327/oWPLZeMONQ8p9nUuCoG/CuWPjDXkyMN2Z1CrA93eEhfHGliC9X5gdfJW+6?=
 =?us-ascii?q?PJrhVi7wm0IFAZQUVq9vOn/hkOgM/pfIEw8/jEy66Q/nGStR97sVlu4p2SFsQM?=
 =?us-ascii?q?XW9t4FeAxrgqKz8L84Q+fCy4PTiNpb8Yvv8s7Azct0zehhdzuATBwobu9Um+G+?=
 =?us-ascii?q?/GYoFuaPSkTMH9HazQIQBUI5/H9r4wpyBHCVNBuFOiylNKdMTXxxS2a6SsznbM?=
 =?us-ascii?q?eieYV2Kihu1PKmTShot7OVAFdzgHWWH+1qxN3f6a7aIGyr1vW9/BNKMCeVFbpl?=
 =?us-ascii?q?GYFgc+2/u0IDI/LkC2LXfVLG6umoeuGWAAwK3YH84IJrmzroiD8O9sLpmwWGau?=
 =?us-ascii?q?gCe5cEReBXaMZkVk5CEdvAUaX?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AvXo0qa23PhXR77qd1J97oAqjBFQkLtp133Aq?=
 =?us-ascii?q?2lEZdPRUGvb4qynIpoVj6faUskdoZJhOo6HiBEDtexzhHNtOkO0s1NSZLW/bUQ?=
 =?us-ascii?q?mTXeNfBOLZqlWKcUCTygce79YGT0EUMr3N5DZB4/oSmDPIdurI3uP3jJyAtKPP?=
 =?us-ascii?q?yWt3VwF2Z+VF5wd9MAySFUp7X2B9dOAEPavZ9sxavCChZHhSSsy6A0MOV+/Fq8?=
 =?us-ascii?q?aOu4nhZXc9dmMawTjLnTW186T7DhTd+h8fVglEybAk/XOAsyGR3NTZj82G?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124075741"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 May 2022 22:36:31 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id A46A34D16FDF;
	Sun,  8 May 2022 22:36:25 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 8 May 2022 22:36:28 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 8 May 2022 22:36:28 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 8 May 2022 22:36:23 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>, <naoya.horiguchi@nec.com>,
	<linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v14 04/07] fsdax: Introduce dax_lock_mapping_entry()
Date: Sun, 8 May 2022 22:36:10 +0800
Message-ID: <20220508143620.1775214-5-ruansy.fnst@fujitsu.com>
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
X-yoursite-MailScanner-ID: A46A34D16FDF.A26AD
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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




