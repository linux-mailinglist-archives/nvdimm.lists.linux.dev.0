Return-Path: <nvdimm+bounces-3584-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F54D506388
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Apr 2022 06:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 203583E0E6A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Apr 2022 04:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505AEEA4;
	Tue, 19 Apr 2022 04:51:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4809DEA1
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 04:51:04 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3Acc1GcqCgTJpJxRVW/1biw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fBgK6hj9xgzFSnGpLWzuDOvmKNDPzKI8lbInl8xlXvJOAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkHhcwmj/3auK79SMkjPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9NljyPhME3xtNWqbS+V?=
 =?us-ascii?q?AUoIrbR3u8aVnG0FgknZ/YYp+aYfCfXXcu7iheun2HX6/lnEkA6FYMC/eNwG2t?=
 =?us-ascii?q?P6boTLzVlRhCIh8q3xryhQ+Vhj8hlK9PkVKsTs3cmz3fGDPIiQJnGWI3L48NV2?=
 =?us-ascii?q?HE7gcUmNfrceM0fZhJsYQ7GbhkJPU0YYLo6neG1ljz6dhVbtluepuww+We75Ap?=
 =?us-ascii?q?v3LnoNfLRe8eWXoNRn0CFtiTK8nqRKhERNPSb0ibD/n/Eru3Gmy69U4IPPLqi/?=
 =?us-ascii?q?/VujRuYwWl7IBkXU0ar5PeihkOgVtZ3NUMZ4GwtoLI0+UjtScPyNzW8oXiZrls?=
 =?us-ascii?q?fVsBWHukS9g6A0OzX7hyfC2xCSSROAPQitckrVXk62EShgdzkH3psvaeTRHbb8?=
 =?us-ascii?q?a2bxQ5ekwB9wXQqPHdCFFVapYK45txbs/4Gdf47eIbdszE/MW2YL+i2kRUD?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AVbE/nK3WYdvTvdjcNkG4jQqjBFYkLtp133Aq?=
 =?us-ascii?q?2lEZdPRUGvb3qynIpoV86faUskdpZJhOo7C90cW7LU80sKQFhLX5Xo3SOzUO2l?=
 =?us-ascii?q?HYT72KhLGKq1aLdhEWtNQtsZuIGJIeNDSfNzdHZL7BkWuF+sgbsaS62ZHtleHD?=
 =?us-ascii?q?1G1sUA0vT6lh6j1yAgGdHlYefng8ObMJUIqb+tFcpyetPVAebsGADHEDWOTZ4/?=
 =?us-ascii?q?LRkpaOW299OzcXrBmJkSiz6KP3VzyR3hIlWTtJxrs4tUjp+jaJnpmejw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123671757"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Apr 2022 12:50:54 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id BCFBD4D1716F;
	Tue, 19 Apr 2022 12:50:49 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 19 Apr 2022 12:50:51 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 19 Apr 2022 12:50:47 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v13 3/7] pagemap,pmem: Introduce ->memory_failure()
Date: Tue, 19 Apr 2022 12:50:41 +0800
Message-ID: <20220419045045.1664996-4-ruansy.fnst@fujitsu.com>
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
X-yoursite-MailScanner-ID: BCFBD4D1716F.A4F31
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

When memory-failure occurs, we call this function which is implemented
by each kind of devices.  For the fsdax case, pmem device driver
implements it.  Pmem device driver will find out the filesystem in which
the corrupted page located in.

With dax_holder notify support, we are able to notify the memory failure
from pmem driver to upper layers.  If there is something not support in
the notify routine, memory_failure will fall back to the generic hanlder.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c    | 17 +++++++++++++++++
 include/linux/memremap.h | 12 ++++++++++++
 mm/memory-failure.c      | 14 ++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 58d95242a836..bd502957cfdf 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -366,6 +366,21 @@ static void pmem_release_disk(void *__pmem)
 	blk_cleanup_disk(pmem->disk);
 }
 
+static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
+		unsigned long pfn, unsigned long nr_pages, int mf_flags)
+{
+	struct pmem_device *pmem =
+			container_of(pgmap, struct pmem_device, pgmap);
+	u64 offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
+	u64 len = nr_pages << PAGE_SHIFT;
+
+	return dax_holder_notify_failure(pmem->dax_dev, offset, len, mf_flags);
+}
+
+static const struct dev_pagemap_ops fsdax_pagemap_ops = {
+	.memory_failure		= pmem_pagemap_memory_failure,
+};
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -427,6 +442,7 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->pfn_flags = PFN_DEV;
 	if (is_nd_pfn(dev)) {
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
+		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pfn_sb = nd_pfn->pfn_sb;
 		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
@@ -440,6 +456,7 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pgmap.range.end = res->end;
 		pmem->pgmap.nr_range = 1;
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
+		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |= PFN_MAP;
 		bb_range = pmem->pgmap.range;
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index ad6062d736cd..bcfb6bf4ce5a 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -79,6 +79,18 @@ struct dev_pagemap_ops {
 	 * the page back to a CPU accessible page.
 	 */
 	vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
+
+	/*
+	 * Handle the memory failure happens on a range of pfns.  Notify the
+	 * processes who are using these pfns, and try to recover the data on
+	 * them if necessary.  The mf_flags is finally passed to the recover
+	 * function through the whole notify routine.
+	 *
+	 * When this is not implemented, or it returns -EOPNOTSUPP, the caller
+	 * will fall back to a common handler called mf_generic_kill_procs().
+	 */
+	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
+			      unsigned long nr_pages, int mf_flags);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7c8c047bfdc8..a40e79e634a4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1741,6 +1741,20 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	if (!pgmap_pfn_valid(pgmap, pfn))
 		goto out;
 
+	/*
+	 * Call driver's implementation to handle the memory failure, otherwise
+	 * fall back to generic handler.
+	 */
+	if (pgmap->ops->memory_failure) {
+		rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
+		/*
+		 * Fall back to generic handler too if operation is not
+		 * supported inside the driver/device/filesystem.
+		 */
+		if (rc != -EOPNOTSUPP)
+			goto out;
+	}
+
 	rc = mf_generic_kill_procs(pfn, flags, pgmap);
 out:
 	/* drop pgmap ref acquired in caller */
-- 
2.35.1




