Return-Path: <nvdimm+bounces-1444-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBB941A8C9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 08:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id B0ED61C0A22
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 06:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287013FF5;
	Tue, 28 Sep 2021 06:23:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2841972
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 06:23:26 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AGRWP7azeUug2UwtVswB6t+cnxyrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApDJwhDIBxmBKC2uPbKqKYGPwe492a4qzp00Pu5aBz4A3HQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9krF3oTJ9yEmjPnZHOqkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhhc14zs5c85K2U?=
 =?us-ascii?q?hsBMLDOmfgGTl9TFCQW0ahuoeaaeSnh4JHNp6HBWz62qxl0N2k6NJMZ9s55G2Z?=
 =?us-ascii?q?L8uYSKSxLZReG78qpwba/W8FtgMo5JcXmNY9ZvWtvpRnVBPBgQ9bcQqHO5NZdx?=
 =?us-ascii?q?x8xgNxDGbDVYM9xQTZtcxPGbDVMN00RBZZ4m/2n7lHlciFVs1KVja425XXDig1?=
 =?us-ascii?q?71f7mN9+9UtqUScRQm26cp3na5CL9AxcHJJqTxCTt2nKnhsfLhj+9VI96PKe38?=
 =?us-ascii?q?fpmn0yV7ncOExBQWVbTif24jFOuHtxEJ0EK9y4Gs6c/7gqoQ8P7Uhn+p2SL1jY?=
 =?us-ascii?q?YWtxNA6g55RuLx678/QmUHC4HQyRHZdhgs9U5LRQu11mUj5b5CydHrrKYUzSe+?=
 =?us-ascii?q?62SoDf0PjIaRUccZDUDZRkI5dj95oUyiA/fCNF5H+iojbXI9ZvYq9yRhHFmwex?=
 =?us-ascii?q?N0ohQjOPmlW0rSgmE/vDhJjPZLC2ONo590j5EWQ=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Ab+kR1qMzyEAD/MBcTv2jsMiBIKoaSvp037BL?=
 =?us-ascii?q?7TEUdfUxSKGlfq+V8sjzqiWftN98YhAdcLO7Scy9qBHnhP1ICOAqVN/MYOCMgh?=
 =?us-ascii?q?rLEGgN1+vf6gylMyj/28oY7q14bpV5YeeaMXFKyer8/ym0euxN/OW6?=
X-IronPort-AV: E=Sophos;i="5.85,328,1624291200"; 
   d="scan'208";a="115096956"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Sep 2021 14:23:26 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 75C8B4D0DC7A;
	Tue, 28 Sep 2021 14:23:24 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 28 Sep 2021 14:23:13 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 28 Sep 2021 14:23:12 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <dan.j.williams@intel.com>, <djwong@kernel.org>, <hch@lst.de>,
	<linux-xfs@vger.kernel.org>
CC: <ruansy.fnst@fujitsu.com>, <david@fromorbit.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>, Ritesh Harjani <riteshh@linux.ibm.com>
Subject: [PATCH v10 1/8] fsdax: Output address in dax_iomap_pfn() and rename it
Date: Tue, 28 Sep 2021 14:23:04 +0800
Message-ID: <20210928062311.4012070-2-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com>
References: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 75C8B4D0DC7A.A1011
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
---
 fs/dax.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4e3e5a283a91..8b482a58acae 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1010,8 +1010,8 @@ static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
 
-static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
+		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
@@ -1023,11 +1023,13 @@ static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
 		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   NULL, pfnp);
+				   kaddr, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
 	}
+	if (!pfnp)
+		goto out_check_addr;
 	rc = -EINVAL;
 	if (PFN_PHYS(length) < size)
 		goto out;
@@ -1037,6 +1039,12 @@ static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
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
@@ -1401,7 +1409,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 		return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
 	}
 
-	err = dax_iomap_pfn(&iter->iomap, pos, size, &pfn);
+	err = dax_iomap_direct_access(&iter->iomap, pos, size, NULL, &pfn);
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
-- 
2.33.0




