Return-Path: <nvdimm+bounces-3873-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFD053C464
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 07:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 092432E09F5
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 05:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E415A55;
	Fri,  3 Jun 2022 05:37:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F51AA4C
	for <nvdimm@lists.linux.dev>; Fri,  3 Jun 2022 05:37:52 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3A/2M4EqNzZGtw3iHvrR0klsFynXyQoLVcMsFnjC/?=
 =?us-ascii?q?WdQjo3Dsr0WYGymIdXjuFOP7bYjb9fNAgOYq28xtV7JOEm99gGjLY11k3ESsS9?=
 =?us-ascii?q?pCt6fd1j6vIF3rLaJWFFSqL1u1GAjX7BJ1yHi+0SiuFaOC79yEmjfjQH9IQNca?=
 =?us-ascii?q?fUsxPbV49IMseoUI78wIJqtYAbemRW2thi/uryyHsEAPNNwpPD44hw/nrRCWDE?=
 =?us-ascii?q?xjFkGhwUlQWPZintbJF/pUfJMp3yaqZdxMUTmTId9NWSdovzJnhlo/Y1xwrTN2?=
 =?us-ascii?q?4kLfnaVBMSbnXVeSMoiMOHfH83V4Z/Wpvuko4HKN0hUN/kSiAmctgjttLroCYR?=
 =?us-ascii?q?xorP7HXhaIWVBww/yRWZPcapu+ZcSDn2SCU5wicG5f2+N1iBV83MaUW4OFyBnt?=
 =?us-ascii?q?E9OBeIzcIBjiHhuSzwbu8SuREhtkqM8TqeogYvxlIzTrZJfcgT4rKT6jD6Zlfx?=
 =?us-ascii?q?jhYrt9PGfLPT8sfZyBmYBnJb1tIIFh/IJ43mqGqwGb+dzlZoVeOjasx/2XXigd?=
 =?us-ascii?q?21dDFPNjKfdqFbcZYhECVoiTB5WuRKhUbMsGPjD+A2nGyj+TM2yThV+o6Hb6g8?=
 =?us-ascii?q?9ZugVuO1ikdDwAQWVKnoP6/zEmkVLp3LVIY+y8rhawz71CwCN38WQCo5nKJoHY?=
 =?us-ascii?q?0W9FQO+kh9EeBx8L85Q+eF2FCTjlbadM7v883bTon3RmCmNaBLT5mtrDTQnKA3?=
 =?us-ascii?q?rCOpDi2NG4eKmpqTTULSg8J/MjliJoulR+JQtsLOKq0iMDlXD/rzz2UoSwWmbo?=
 =?us-ascii?q?el4gI2r+98FSBhCijzrDNTwgo9kDUU3ij4wdReoGofcqr5ELd4PIGK5yWJnGFv?=
 =?us-ascii?q?X4Zi42O4vsmE56AjmqOTf8LEbXv4OyKWBXCgERoN4ss8TWzvXqie51ApjZkKwF?=
 =?us-ascii?q?0Ma45lZXBCKPIkVoJosYNYz3xNukqC79dwv8ClcDIfekJnNiIBjaWXqVMSQ=3D?=
 =?us-ascii?q?=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Ay8JKfK0V4IPPuv1tQ8WQjAqjBI4kLtp133Aq?=
 =?us-ascii?q?2lEZdPU1SL39qynKppkmPHDP5gr5J0tLpTntAsi9qBDnhPtICOsqTNSftWDd0Q?=
 =?us-ascii?q?PGEGgI1/qB/9SPIU3D398Y/aJhXow7M9foEGV95PyQ3CCIV/om3/mLmZrFudvj?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124686800"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Jun 2022 13:37:44 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 60BAF4D1719C;
	Fri,  3 Jun 2022 13:37:44 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 3 Jun 2022 13:37:43 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 3 Jun 2022 13:37:44 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <akpm@linux-foundation.org>, <jane.chu@oracle.com>,
	<rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>, <willy@infradead.org>,
	<naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>, Christoph Hellwig
	<hch@lst.de>
Subject: [PATCH v2 04/14] fsdax: Introduce dax_lock_mapping_entry()
Date: Fri, 3 Jun 2022 13:37:28 +0800
Message-ID: <20220603053738.1218681-5-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
References: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 60BAF4D1719C.A0A77
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
index 4155a6107fa1..65e44d78b3bb 100644
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
index cf85fc36da5f..7116681b48c0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -161,6 +161,10 @@ struct page *dax_layout_busy_page(struct address_space *mapping);
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
@@ -188,6 +192,17 @@ static inline dax_entry_t dax_lock_page(struct page *page)
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
2.36.1




