Return-Path: <nvdimm+bounces-5118-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF9B6256A2
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Nov 2022 10:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB45C280D05
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Nov 2022 09:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B7D2F42;
	Fri, 11 Nov 2022 09:25:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E162C80
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 09:25:12 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="95532463"
X-IronPort-AV: E=Sophos;i="5.96,156,1665414000"; 
   d="scan'208";a="95532463"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP; 11 Nov 2022 18:24:00 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 588A3D3EA3
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 18:23:59 +0900 (JST)
Received: from m3004.s.css.fujitsu.com (m3004.s.css.fujitsu.com [10.128.233.124])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 986949FDD4
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 18:23:58 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3004.s.css.fujitsu.com (Postfix) with ESMTP id 61DD920607A2;
	Fri, 11 Nov 2022 18:23:58 +0900 (JST)
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
Subject: [RFC PATCH v2 5/7] RDMA/rxe: Allow registering MRs for On-Demand Paging
Date: Fri, 11 Nov 2022 18:22:26 +0900
Message-Id: <c5455766a0e0c8708c31b925574dc9fffe6202a7.1668157436.git.matsuda-daisuke@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668157436.git.matsuda-daisuke@fujitsu.com>
References: <cover.1668157436.git.matsuda-daisuke@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00

Allow applications to register an ODP-enabled MR, in which case the flag
IB_ACCESS_ON_DEMAND is passed to rxe_reg_user_mr(). However, there is no
RDMA operation supported right now. They will be enabled later in the
subsequent two patches.

rxe_odp_do_pagefault() is called to initialize an ODP-enabled MR. It syncs
process address space from the CPU page table to the driver page table
(dma_list/pfn_list in umem_odp) when called with RXE_PAGEFAULT_SNAPSHOT
flag. Additionally, It can be used to trigger page fault when pages being
accessed are not present or do not have proper read/write permissions, and
possibly to prefetch pages in the future.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/sw/rxe/rxe.c       |  7 +++
 drivers/infiniband/sw/rxe/rxe_loc.h   |  5 ++
 drivers/infiniband/sw/rxe/rxe_mr.c    |  7 ++-
 drivers/infiniband/sw/rxe/rxe_odp.c   | 81 +++++++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_resp.c  | 25 +++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.c |  8 ++-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  2 +
 7 files changed, 126 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 51daac5c4feb..0719f451253c 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -73,6 +73,13 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 			rxe->ndev->dev_addr);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
+
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		rxe->attr.kernel_cap_flags |= IBK_ON_DEMAND_PAGING;
+
+		/* IB_ODP_SUPPORT_IMPLICIT is not supported right now. */
+		rxe->attr.odp_caps.general_caps |= IB_ODP_SUPPORT;
+	}
 }
 
 /* initialize port attributes */
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 993aa6a8003d..3cf830ee2081 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -64,6 +64,7 @@ int rxe_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 /* rxe_mr.c */
 u8 rxe_get_next_key(u32 last_key);
+void rxe_mr_init(int access, struct rxe_mr *mr);
 void rxe_mr_init_dma(int access, struct rxe_mr *mr);
 int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 		     int access, struct rxe_mr *mr);
@@ -188,4 +189,8 @@ static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
+/* rxe_odp.c */
+int rxe_create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length, u64 iova,
+			   int access_flags, struct rxe_mr *mr);
+
 #endif /* RXE_LOC_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index d4f10c2d1aa7..dd0d68d61bc4 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -48,7 +48,7 @@ int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length)
 				| IB_ACCESS_REMOTE_WRITE	\
 				| IB_ACCESS_REMOTE_ATOMIC)
 
-static void rxe_mr_init(int access, struct rxe_mr *mr)
+void rxe_mr_init(int access, struct rxe_mr *mr)
 {
 	u32 lkey = mr->elem.index << 8 | rxe_get_next_key(-1);
 	u32 rkey = (access & IB_ACCESS_REMOTE) ? lkey : 0;
@@ -433,7 +433,10 @@ int copy_data(
 		if (bytes > 0) {
 			iova = sge->addr + offset;
 
-			err = rxe_mr_copy(mr, iova, addr, bytes, dir);
+			if (mr->odp_enabled)
+				err = -EOPNOTSUPP;
+			else
+				err = rxe_mr_copy(mr, iova, addr, bytes, dir);
 			if (err)
 				goto err2;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 0787a9b19646..50766889f61a 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -5,6 +5,8 @@
 
 #include <rdma/ib_umem_odp.h>
 
+#include "rxe.h"
+
 static bool rxe_ib_invalidate_range(struct mmu_interval_notifier *mni,
 				    const struct mmu_notifier_range *range,
 				    unsigned long cur_seq)
@@ -32,3 +34,82 @@ static bool rxe_ib_invalidate_range(struct mmu_interval_notifier *mni,
 const struct mmu_interval_notifier_ops rxe_mn_ops = {
 	.invalidate = rxe_ib_invalidate_range,
 };
+
+#define RXE_PAGEFAULT_RDONLY BIT(1)
+#define RXE_PAGEFAULT_SNAPSHOT BIT(2)
+static int rxe_odp_do_pagefault(struct rxe_mr *mr, u64 user_va, int bcnt, u32 flags)
+{
+	int np;
+	u64 access_mask;
+	bool fault = !(flags & RXE_PAGEFAULT_SNAPSHOT);
+	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+
+	access_mask = ODP_READ_ALLOWED_BIT;
+	if (umem_odp->umem.writable && !(flags & RXE_PAGEFAULT_RDONLY))
+		access_mask |= ODP_WRITE_ALLOWED_BIT;
+
+	/*
+	 * umem mutex is always locked in ib_umem_odp_map_dma_and_lock().
+	 * Callers must release the lock later to let invalidation handler
+	 * do its work again.
+	 */
+	np = ib_umem_odp_map_dma_and_lock(umem_odp, user_va, bcnt,
+					  access_mask, fault);
+
+	return np;
+}
+
+static int rxe_init_odp_mr(struct rxe_mr *mr)
+{
+	int ret;
+	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+
+	ret = rxe_odp_do_pagefault(mr, mr->umem->address, mr->umem->length,
+				   RXE_PAGEFAULT_SNAPSHOT);
+	mutex_unlock(&umem_odp->umem_mutex);
+
+	return ret >= 0 ? 0 : ret;
+}
+
+int rxe_create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length, u64 iova,
+			   int access_flags, struct rxe_mr *mr)
+{
+	int err;
+	struct ib_umem_odp *umem_odp;
+	struct rxe_dev *dev = container_of(pd->device, struct rxe_dev, ib_dev);
+
+	if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+		return -EOPNOTSUPP;
+
+	rxe_mr_init(access_flags, mr);
+
+	if (!start && length == U64_MAX) {
+		if (iova != 0)
+			return -EINVAL;
+		if (!(dev->attr.odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
+			return -EINVAL;
+
+		/* Never reach here, for implicit ODP is not implemented. */
+	}
+
+	umem_odp = ib_umem_odp_get(pd->device, start, length, access_flags,
+				   &rxe_mn_ops);
+	if (IS_ERR(umem_odp))
+		return PTR_ERR(umem_odp);
+
+	umem_odp->private = mr;
+
+	mr->odp_enabled = true;
+	mr->ibmr.pd = pd;
+	mr->umem = &umem_odp->umem;
+	mr->access = access_flags;
+	mr->ibmr.length = length;
+	mr->ibmr.iova = iova;
+	mr->offset = ib_umem_offset(&umem_odp->umem);
+	mr->state = RXE_MR_STATE_VALID;
+	mr->ibmr.type = IB_MR_TYPE_USER;
+
+	err = rxe_init_odp_mr(mr);
+
+	return err;
+}
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 03e54cb37d44..4beb18f8bea8 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -539,8 +539,16 @@ static enum resp_states write_data_in(struct rxe_qp *qp,
 	int	err;
 	int data_len = payload_size(pkt);
 
-	err = rxe_mr_copy(qp->resp.mr, qp->resp.va + qp->resp.offset,
-			  payload_addr(pkt), data_len, RXE_TO_MR_OBJ);
+	/* resp.mr is not set in check_rkey() for zero byte operations */
+	if (data_len == 0)
+		goto out;
+
+	if (qp->resp.mr->odp_enabled)
+		err = -EOPNOTSUPP;
+	else
+		err = rxe_mr_copy(qp->resp.mr, qp->resp.va + qp->resp.offset,
+				  payload_addr(pkt), data_len, RXE_TO_MR_OBJ);
+
 	if (err) {
 		rc = RESPST_ERR_RKEY_VIOLATION;
 		goto out;
@@ -671,7 +679,10 @@ static enum resp_states rxe_atomic_reply(struct rxe_qp *qp,
 		if (mr->state != RXE_MR_STATE_VALID)
 			return RESPST_ERR_RKEY_VIOLATION;
 
-		ret = rxe_atomic_ops(qp, pkt, mr);
+		if (mr->odp_enabled)
+			ret = RESPST_ERR_UNSUPPORTED_OPCODE;
+		else
+			ret = rxe_atomic_ops(qp, pkt, mr);
 	} else
 		ret = RESPST_ACKNOWLEDGE;
 
@@ -835,8 +846,12 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	if (!skb)
 		return RESPST_ERR_RNR;
 
-	err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
-			  payload, RXE_FROM_MR_OBJ);
+	/* mr is NULL for a zero byte operation. */
+	if ((res->read.resid != 0) && mr->odp_enabled)
+		err = -EOPNOTSUPP;
+	else
+		err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
+				  payload, RXE_FROM_MR_OBJ);
 	rxe_put(mr);
 	if (err) {
 		kfree_skb(skb);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 786a3583ac21..0876b17c83c1 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -926,11 +926,15 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 		goto err2;
 	}
 
-
 	rxe_get(pd);
 	mr->ibmr.pd = ibpd;
 
-	err = rxe_mr_init_user(rxe, start, length, iova, access, mr);
+	if (access & IB_ACCESS_ON_DEMAND)
+		err = rxe_create_user_odp_mr(&pd->ibpd, start, length, iova,
+					     access, mr);
+	else
+		err = rxe_mr_init_user(rxe, start, length, iova, access, mr);
+
 	if (err)
 		goto err3;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 60d0cdb5465a..02d079d9dc54 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -321,6 +321,8 @@ struct rxe_mr {
 	atomic_t		num_mw;
 
 	struct rxe_map		**map;
+
+	bool		        odp_enabled;
 };
 
 enum rxe_mw_state {
-- 
2.31.1


