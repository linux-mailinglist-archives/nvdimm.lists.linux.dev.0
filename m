Return-Path: <nvdimm+bounces-3891-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859EA540197
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Jun 2022 16:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id C82BF2E0A18
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Jun 2022 14:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E7B28FF;
	Tue,  7 Jun 2022 14:38:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827D417C6
	for <nvdimm@lists.linux.dev>; Tue,  7 Jun 2022 14:38:49 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AEtuDyqqieERBcSCcMmlSjOXrUbJeBmKGZBIvgKr?=
 =?us-ascii?q?LsJaIsI5as4F+vjAZXWyEaffYazf0L98gboWy9U4E75PQnIVmS1A4/CAxQiMRo?=
 =?us-ascii?q?6IpJ/zDcB6oYHn6wu4v7a5fx5xHLIGGdajYd1eEzvuWGuWn/SkUOZ2gHOKmUra?=
 =?us-ascii?q?eYnkpHGeIdQ964f5ds79g6mJXqYjha++9kYuaT/z3YDdJ6RYtWo4nw/7rRCdUg?=
 =?us-ascii?q?RjHkGhwUmrSyhx8lAS2e3E9VPrzLEwqRpfyatE88uWSH44vwFwll1418SvBCvv?=
 =?us-ascii?q?9+lr6WkYMBLDPPwmSkWcQUK+n6vRAjnVqlP9la7xHMgEK49mKt4kZJNFlr4G5T?=
 =?us-ascii?q?xw4eKPKg/g1XQRaEj1lIOtN/7qvzX2X6JbPkBOfIyG0qxlpJARsVWECwc57CH9?=
 =?us-ascii?q?P+dQWMjcIaQqJhv7wy7W+IsFoh8ImLcDsPI43umxp0jzYS/0hRPjrQ67Kzd5e0?=
 =?us-ascii?q?i05is1HEbDZfcVxQSVuaBDRSxxJNE0eBJ83kKGvnHaXWzFRrhSX47U252zSxQl?=
 =?us-ascii?q?q+LnrLNfRPNeNQK19kkSHoWTJ12f0GBcXMJqY0zXt2natgPLf2Cb+cIEMHba7s?=
 =?us-ascii?q?PlwjzW7z28LDTUSVF2msby3jVO4V9tDKksSvC00osAa7k23Q8L9XzW8oXiZrlg?=
 =?us-ascii?q?dUd8WGOo/gCmL1KbV5gOxAmkfUiUHbN0gqd9wSTE0vneJlNPBASdz9rGYIVqb/?=
 =?us-ascii?q?7CFpHWyPjIUInIJZS4sSwYOpdLkpekbjBvJQ5BoELOdicf8EjX9hTuNqUAWnbo?=
 =?us-ascii?q?UicIUxqOT5k3cjnSgq/DhSg8z+xWSUHmp4x10YKa7aIGyr1vW9/BNKMCeVFbpl?=
 =?us-ascii?q?HwFndWOqeMDF5eAkASTT+gXWrKk/fCINHvbm1EHN50g8Sm9vm6tZqhO7zxkYkR?=
 =?us-ascii?q?kKMAJfXnuekC7kR1Q/ph7LnasbLExZ4O3FtRsyrLvU8nmPs04xPImjoNZLVfBp?=
 =?us-ascii?q?X8xIxXLmT2FraTlqolnUb/zTCpmJS9y5Xxb8QeL?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AsmxAfq3JLcwF/YSkKxBzBgqjBI4kLtp133Aq?=
 =?us-ascii?q?2lEZdPU1SL39qynKppkmPHDP5gr5J0tLpTntAsi9qBDnhPtICOsqTNSftWDd0Q?=
 =?us-ascii?q?PGEGgI1/qB/9SPIU3D398Y/aJhXow7M9foEGV95PyQ3CCIV/om3/mLmZrFudvj?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124761820"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 07 Jun 2022 22:38:40 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 98CEE4D17196;
	Tue,  7 Jun 2022 22:38:39 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 7 Jun 2022 22:38:39 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 7 Jun 2022 22:38:38 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>, <naoya.horiguchi@nec.com>,
	<linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>, Ritesh Harjani
	<riteshh@linux.ibm.com>
Subject: [PATCH v2.1 08/14] fsdax: Output address in dax_iomap_pfn() and rename it
Date: Tue, 7 Jun 2022 22:38:37 +0800
Message-ID: <20220607143837.161174-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603053738.1218681-9-ruansy.fnst@fujitsu.com>
References: <20220603053738.1218681-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 98CEE4D17196.A17C2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Add address output in dax_iomap_pfn() in order to perform a memcpy() in
CoW case.  Since this function both output address and pfn, rename it to
dax_iomap_direct_access().

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

==
Hi Andrew,

As Dan mentioned[1], the rc should be initialized.  I fixed it and resend this patch.

[1] https://lore.kernel.org/linux-fsdevel/Yp8FUZnO64Qvyx5G@kili/

---
 fs/dax.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b59b864017ad..7a8eb1e30a1b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1026,20 +1026,22 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
+		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	int id, rc;
+	int id, rc = 0;
 	long length;
 
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   DAX_ACCESS, NULL, pfnp);
+				   DAX_ACCESS, kaddr, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
 	}
+	if (!pfnp)
+		goto out_check_addr;
 	rc = -EINVAL;
 	if (PFN_PHYS(length) < size)
 		goto out;
@@ -1049,6 +1051,12 @@ static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
 	if (length > 1 && !pfn_t_devmap(*pfnp))
 		goto out;
 	rc = 0;
+
+out_check_addr:
+	if (!kaddr)
+		goto out;
+	if (!*kaddr)
+		rc = -EFAULT;
 out:
 	dax_read_unlock(id);
 	return rc;
@@ -1456,7 +1464,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 		return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
 	}
 
-	err = dax_iomap_pfn(&iter->iomap, pos, size, &pfn);
+	err = dax_iomap_direct_access(&iter->iomap, pos, size, NULL, &pfn);
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
-- 
2.36.1




