Return-Path: <nvdimm+bounces-3589-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFAF50638E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Apr 2022 06:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 189A93E0FFD
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Apr 2022 04:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA40EC2;
	Tue, 19 Apr 2022 04:52:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95FDEA2
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 04:52:05 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3A5z6cUqzunj2H0ctsOpB6t+dIxyrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApDNwhjdWzGVOXmiEOvveNGbyedxyOdyx9UoB75eEyNRnHQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9kfF3oTJ9yEmj/nSHuOkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhhc14zs5c85K2U?=
 =?us-ascii?q?hsBMLDOmfgGTl9TFCQW0ahuoeWcfyfm7pHPp6HBWz62qxl0N2k6NJMZ9s55G2Z?=
 =?us-ascii?q?L8uYSKSxLZReG78q2y7KTS+9inM0vIcDneoQFtRlIwTjfS/RgXpHHR6TD4MRw3?=
 =?us-ascii?q?TEsi8QIFvHbD+IVayVoahvoYBBVPFoTTpUkk4+Agnj5bi0drVe9prQ+6GuVyxZ?=
 =?us-ascii?q?+uJDrLtbUf9miQcROgl3eomPA4nS/DhwEXPSfwjqt9mmwwOPC9Qv5UYQfUra46?=
 =?us-ascii?q?9ZtmlSYwmFVAxoTPXO/oP+kmguwQN5SNUEQ0jQhoLJ090GxSNT5GRqirxasuh8?=
 =?us-ascii?q?aRsoVEOAg7gyJ4rTb7hzfBWUeSDNFLts8u6ceQT0sy0/Mj93yLSJgvafTSn+H8?=
 =?us-ascii?q?LqQ6zSoNkAowcUqDcMfZVJdpYC9/8do1VSSJuuP2ZWd1rXdcQwcCRjWxMTmu4g?=
 =?us-ascii?q?usA=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AC2Iz5KkhL7hgpqneNOUWESz0vxPpDfLK3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fxl6iV/cjzsiWE8Qr5OUtQ4exoV5PwIk80maQb3WBVB8bHYOCEgh?=
 =?us-ascii?q?rPEGgB1/qB/9SIIUSXnYQxuZuIMZIOb+EYZmIbsS+V2meF+q4bsby6Gb6T9Jvj?=
 =?us-ascii?q?5kYoXQd3cLth8gs8Lg6aF3d9TA5ACYFRLuvn2uN34yqnZW8Mbtm2Ql0MX+34rd?=
 =?us-ascii?q?XNk578JTEcARpP0njysRqYrK79DwOD3goTFxdGwbIZ+2DDlADjooWP2svLsSPh?=
 =?us-ascii?q?6w=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123671754"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Apr 2022 12:50:54 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 97B7E4D17170;
	Tue, 19 Apr 2022 12:50:50 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 19 Apr 2022 12:50:52 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 19 Apr 2022 12:50:51 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 19 Apr 2022 12:50:48 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v13 4/7] fsdax: Introduce dax_lock_mapping_entry()
Date: Tue, 19 Apr 2022 12:50:42 +0800
Message-ID: <20220419045045.1664996-5-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 97B7E4D17170.AEC08
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




