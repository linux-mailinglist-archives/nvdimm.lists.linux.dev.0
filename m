Return-Path: <nvdimm+bounces-5566-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF210654CA2
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Dec 2022 07:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24C4D280C04
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Dec 2022 06:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8ED23AA;
	Fri, 23 Dec 2022 06:55:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD1F23A0
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 06:55:39 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="101163241"
X-IronPort-AV: E=Sophos;i="5.96,267,1665414000"; 
   d="scan'208";a="101163241"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP; 23 Dec 2022 15:52:27 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 032E3D6476
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:25 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com [10.128.233.114])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 4150DD8C86
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:24 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3003.s.css.fujitsu.com (Postfix) with ESMTP id EDD2C200B2A8;
	Fri, 23 Dec 2022 15:52:23 +0900 (JST)
From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
To: linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	jgg@nvidia.com,
	zyjzyj2000@gmail.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	rpearsonhpe@gmail.com,
	yangx.jy@fujitsu.com,
	lizhijian@fujitsu.com,
	y-goto@fujitsu.com,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Subject: [PATCH for-next v3 4/7] RDMA/rxe: Add page invalidation support
Date: Fri, 23 Dec 2022 15:51:55 +0900
Message-Id: <97b0362e256dd3eb022d81c30941edd8fb0caba9.1671772917.git.matsuda-daisuke@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1671772917.git.matsuda-daisuke@fujitsu.com>
References: <cover.1671772917.git.matsuda-daisuke@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00

On page invalidation, an MMU notifier callback is invoked to unmap DMA
addresses and update the driver page table(umem_odp->dma_list). The
callback is registered when an ODP-enabled MR is created.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/sw/rxe/Makefile  |  2 ++
 drivers/infiniband/sw/rxe/rxe_odp.c | 34 +++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_odp.c

diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
index 5395a581f4bb..93134f1d1d0c 100644
--- a/drivers/infiniband/sw/rxe/Makefile
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -23,3 +23,5 @@ rdma_rxe-y := \
 	rxe_task.o \
 	rxe_net.o \
 	rxe_hw_counters.o
+
+rdma_rxe-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += rxe_odp.o
diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
new file mode 100644
index 000000000000..0787a9b19646
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2022 Fujitsu Ltd. All rights reserved.
+ */
+
+#include <rdma/ib_umem_odp.h>
+
+static bool rxe_ib_invalidate_range(struct mmu_interval_notifier *mni,
+				    const struct mmu_notifier_range *range,
+				    unsigned long cur_seq)
+{
+	struct ib_umem_odp *umem_odp =
+		container_of(mni, struct ib_umem_odp, notifier);
+	unsigned long start;
+	unsigned long end;
+
+	if (!mmu_notifier_range_blockable(range))
+		return false;
+
+	mutex_lock(&umem_odp->umem_mutex);
+	mmu_interval_set_seq(mni, cur_seq);
+
+	start = max_t(u64, ib_umem_start(umem_odp), range->start);
+	end = min_t(u64, ib_umem_end(umem_odp), range->end);
+
+	ib_umem_odp_unmap_dma_pages(umem_odp, start, end);
+
+	mutex_unlock(&umem_odp->umem_mutex);
+	return true;
+}
+
+const struct mmu_interval_notifier_ops rxe_mn_ops = {
+	.invalidate = rxe_ib_invalidate_range,
+};
-- 
2.31.1


