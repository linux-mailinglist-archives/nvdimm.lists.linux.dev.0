Return-Path: <nvdimm+bounces-3152-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C6884C5AFB
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 13:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 3670A1C0D66
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 12:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455A848C5;
	Sun, 27 Feb 2022 12:09:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC99248B3
	for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 12:09:07 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3A3rwCZKnGrMC6ssI3R9fZqmPo5gz+J0RdPkR7XQ2?=
 =?us-ascii?q?eYbTBsI5bp2QHyWNKXT3XOq7ZZmanLt4lPt7ip09U75SHnYJlG1Ft+CA2RRqmi?=
 =?us-ascii?q?+KfW43BcR2Y0wB+jyH7ZBs+qZ1YM7EsFehsJpPnjkrrYuiJQUVUj/nSHOKmULe?=
 =?us-ascii?q?cY0ideCc/IMsfoUM68wIGqt4w6TSJK1vlVeLa+6UzCnf8s9JHGj58B5a4lf9al?=
 =?us-ascii?q?K+aVAX0EbAJTasjUFf2zxH5BX+ETE27ByOQroJ8RoZWSwtfpYxV8F81/z91Yj+?=
 =?us-ascii?q?kur39NEMXQL/OJhXIgX1TM0SgqkEa4HVsjeBgb7xBAatUo2zhc9RZ0shEs4ehD?=
 =?us-ascii?q?wkvJbHklvkfUgVDDmd1OqguFLrveCLl6ZfMkR2XG5fr67A0ZK0sBqUU8/h2DUl?=
 =?us-ascii?q?A7/sdLyoHbwzFjOWzqJq7QelEh8ItNsDnMYoT/HZ6wlnxAf8gB5KFXKTO4d5R2?=
 =?us-ascii?q?SwYh8ZSEPKYbM0cARJjbgvHZRJnOVoNDp862uCyiRHXdzxetULQoK8f4Hbaxw8?=
 =?us-ascii?q?316LiWPLTZNCLQMB9mkeDunmA+2X/HwFcONGBoRKF+XKEgvTT2y/2MKoQHbu1s?=
 =?us-ascii?q?PVqnXWU3GUYDBBQXly+ydG9i0ijS5dRMEAZ5CcqhbY9+VbtTdTnWRC85nmesXY?=
 =?us-ascii?q?0X9tWDv1/6wyXzKfQyxiWC3JCTTNbbtEi8sgsSlQC0l6PgsOsFTJ0mKOaRGjb9?=
 =?us-ascii?q?bqOqz62fy8PIgc/iYUsJecey4C75tht0VSUFZA+eJNZR+bdQVnYqw1mZgBj71n?=
 =?us-ascii?q?LsfM26g=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AQxBs+qhdVXmfoyR2Te+9JfvDoHBQX/d13DAb?=
 =?us-ascii?q?v31ZSRFFG/FwyPrCoB1L73XJYWgqM03I+eruBEDgewK5yXcR2+Us1NiZLWzbUQ?=
 =?us-ascii?q?eTXeNfBOjZskXd8k/Fh5dgPM5bGsARaeEYZWIK6/oSizPZLz9P+qjlzEj+7t2u?=
 =?us-ascii?q?qEuFADsaG51I3kNcMEK2A0d2TA5JCd4QE4ed3NNOo36FdW4MZsq2K3EZV6ybzu?=
 =?us-ascii?q?e75q7OUFojPVoK+QOOhTSn5PrTFAWZ5A4XV3dqza05+WbIvgTl7uGIsu29yDXb?=
 =?us-ascii?q?y2jPhq4m6+fJ+59mPoihm8IVIjLjhkKDf4J6QYCPuzgzvaWG9EsquMOkmWZXA+?=
 =?us-ascii?q?1Dr1fqOk2lqxrk3AftlBw07WX59FOeiXz/5eTkWTMBDdZbj44xSGqv16MZhqA1?=
 =?us-ascii?q?7Et35RPTi3IOZimw1hgVpuK4Iy2Cr3DE6EbLyoUo/jFiuYh3Us4vkWVQxjIYLH?=
 =?us-ascii?q?46JlOB1GkWKpgUMCji3ocqTbq7VQGmgoA9+q3cYpwMdi32PnTq/PblpgRroA?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="122037689"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Feb 2022 20:07:58 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 137084D15A5F;
	Sun, 27 Feb 2022 20:07:52 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 27 Feb 2022 20:07:51 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 27 Feb 2022 20:07:51 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v11 5/8] mm: move pgoff_address() to vma_pgoff_address()
Date: Sun, 27 Feb 2022 20:07:44 +0800
Message-ID: <20220227120747.711169-6-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 137084D15A5F.A523F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Since it is not a DAX-specific function, move it into mm and rename it
to be a generic helper.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c           | 12 +-----------
 include/linux/mm.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 653a2f390b72..f164cf64c611 100644
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
index e1a84b1e6787..9b1d56c5c224 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2816,6 +2816,19 @@ static inline unsigned long vma_pages(struct vm_area_struct *vma)
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
2.35.1




