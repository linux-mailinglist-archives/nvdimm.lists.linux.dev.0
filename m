Return-Path: <nvdimm+bounces-2329-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DED1947F74D
	for <lists+linux-nvdimm@lfdr.de>; Sun, 26 Dec 2021 15:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id E73851C0A79
	for <lists+linux-nvdimm@lfdr.de>; Sun, 26 Dec 2021 14:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0235C2CB8;
	Sun, 26 Dec 2021 14:35:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81A92CAB
	for <nvdimm@lists.linux.dev>; Sun, 26 Dec 2021 14:35:15 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AUYtO7qwSIWk8XQ7+Pux6t+dcxyrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApDhx0WYDmGAXCz3TMq6JamWhKd4kO4+2/U0OupTQzYJkHQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9kfF3oTJ9yEmjPjSHOSkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhhc14zs5c85K2U?=
 =?us-ascii?q?hsBMLDOmfgGTl9TFCQW0ahuoeaWfCbk4ZzLp6HBWz62qxl0N2k6NJMZ9s55G2Z?=
 =?us-ascii?q?L8uYSKSxLZReG78q2y7KTS+9inM0vIcDneoQFtRlIwTjfS/RgXpHHR6TD4MRw3?=
 =?us-ascii?q?TEsi8QIFvHbD+IVayVoahvoYBBVPFoTTpUkk4+Agnj5bi0drVe9prQ+6GuVyxZ?=
 =?us-ascii?q?+uJDrLtbUf9miQcROgl3eomPA4nS/DhwEXPSdwDyItHmsm8fIhyrwXI9UH7q9n?=
 =?us-ascii?q?tZugVuO1ikdExEbS1a/iee2h1T4WN9FLUEQvC00osAa8E2tU8m4XBCipnOAlgA?=
 =?us-ascii?q?TVsAWEOAg7gyJjK3O7G6xAmkCUy4EeNI9nNE5SCZs1VKTmd7tQzt1v9Wopdi1n?=
 =?us-ascii?q?luPhWrqf3FLcilZPmlZJTbpKuLL+Okb5i8jhP45eEJtsuDIJA=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AfC/4kaEH5w68T7A8pLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.88,237,1635177600"; 
   d="scan'208";a="119563880"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Dec 2021 22:35:10 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 7D3A14D146F1;
	Sun, 26 Dec 2021 22:35:06 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 26 Dec 2021 22:35:08 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 26 Dec 2021 22:35:04 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v9 07/10] mm: move pgoff_address() to vma_pgoff_address()
Date: Sun, 26 Dec 2021 22:34:36 +0800
Message-ID: <20211226143439.3985960-8-ruansy.fnst@fujitsu.com>
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
X-yoursite-MailScanner-ID: 7D3A14D146F1.ADC7B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Since it is not a DAX-specific function, move it into mm and rename it
to be a generic helper.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c           | 12 +-----------
 include/linux/mm.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b3c737aff9de..ad8ceea1f54c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -853,16 +853,6 @@ static void *dax_insert_entry(struct xa_state *xas,
 	return entry;
 }
 
-static inline
-unsigned long pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
-{
-	unsigned long address;
-
-	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
-	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
-	return address;
-}
-
 /* Walk all mappings of a given index of a file and writeprotect them */
 static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 		unsigned long pfn)
@@ -882,7 +872,7 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
-		address = pgoff_address(index, vma);
+		address = vma_pgoff_address(vma, index);
 
 		/*
 		 * follow_invalidate_pte() will use the range to call
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a7e4a9e7d807..3f44cd9e296c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2855,6 +2855,19 @@ static inline unsigned long vma_pages(struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+/*
+ * Get user virtual address at the specific offset within a vma.
+ */
+static inline unsigned long vma_pgoff_address(struct vm_area_struct *vma,
+					      pgoff_t pgoff)
+{
+	unsigned long address;
+
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	return address;
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
-- 
2.34.1




