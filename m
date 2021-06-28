Return-Path: <nvdimm+bounces-305-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 768593B562E
	for <lists+linux-nvdimm@lfdr.de>; Mon, 28 Jun 2021 02:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 8A8661C0E6C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 28 Jun 2021 00:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756886D14;
	Mon, 28 Jun 2021 00:03:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CA06D3F
	for <nvdimm@lists.linux.dev>; Mon, 28 Jun 2021 00:03:32 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A9Se1iaFrOT7Xo9FfpLqEDseALOsnbusQ8zAX?=
 =?us-ascii?q?P0AYc31om6uj5rmTdZUgpGfJYVkqKRIdcLy7V5VoBEmskaKdgrNhW4tKPjOW2l?=
 =?us-ascii?q?dARbsKheCJrlHd8m/Fh4lgPMxbE5SWZuefMbEDt7ee3OCnKadd/PC3tLCvmfzF?=
 =?us-ascii?q?z2pgCSVja6Rb5Q9/DQqBe3cGPjVuNN4oEoaG/Mpbq36FcXQTVM6yAX4IRKztvN?=
 =?us-ascii?q?vO/aiWHCIuNlo27hWUlzO05PrfGxic5B0XVDRC2vMD3AH+4nfE2pk=3D?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; 
   d="scan'208";a="110256401"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:03:28 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 11E524D0BA6A;
	Mon, 28 Jun 2021 08:03:24 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:25 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:03:24 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
CC: <darrick.wong@oracle.com>, <dan.j.williams@intel.com>,
	<david@fromorbit.com>, <hch@lst.de>, <agk@redhat.com>, <snitzer@redhat.com>,
	<rgoldwyn@suse.de>
Subject: [PATCH v5 9/9] fs/dax: Remove useless functions
Date: Mon, 28 Jun 2021 08:02:18 +0800
Message-ID: <20210628000218.387833-10-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 11E524D0BA6A.A3DAF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Since owner tracking is triggerred by pmem device, these functions are
useless.  So remove them.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7c5d8acd6bc5..cee8e61d1025 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -334,48 +334,6 @@ static unsigned long dax_end_pfn(void *entry)
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)

-/*
- * TODO: for reflink+dax we need a way to associate a single page with
- * multiple address_space instances at different linear_page_index()
- * offsets.
- */
-static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address)
-{
-	unsigned long size = dax_entry_size(entry), pfn, index;
-	int i = 0;
-
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
-
-	index = linear_page_index(vma, address & ~(size - 1));
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		WARN_ON_ONCE(page->mapping);
-		page->mapping = mapping;
-		page->index = index + i++;
-	}
-}
-
-static void dax_disassociate_entry(void *entry, struct address_space *mapping,
-		bool trunc)
-{
-	unsigned long pfn;
-
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
-
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
-		page->mapping = NULL;
-		page->index = 0;
-	}
-}
-
 static struct page *dax_busy_page(void *entry)
 {
 	unsigned long pfn;
@@ -554,7 +512,6 @@ static void *grab_mapping_entry(struct xa_state *xas,
 			xas_lock_irq(xas);
 		}

-		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL);	/* undo the PMD join */
 		dax_wake_entry(xas, entry, WAKE_ALL);
 		mapping->nrpages -= PG_PMD_NR;
@@ -691,7 +648,6 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
 	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
 		goto out;
-	dax_disassociate_entry(entry, mapping, trunc);
 	xas_store(&xas, NULL);
 	mapping->nrpages -= 1UL << dax_entry_order(entry);
 	ret = 1;
@@ -785,8 +741,6 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;

-		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
--
2.32.0




