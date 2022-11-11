Return-Path: <nvdimm+bounces-5119-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 737946256A3
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Nov 2022 10:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DF8E280D05
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Nov 2022 09:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30B82F55;
	Fri, 11 Nov 2022 09:25:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A07E2F50
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 09:25:15 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="83748143"
X-IronPort-AV: E=Sophos;i="5.96,156,1665414000"; 
   d="scan'208";a="83748143"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP; 11 Nov 2022 18:24:03 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id A9FDADE50E
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 18:24:02 +0900 (JST)
Received: from m3004.s.css.fujitsu.com (m3004.s.css.fujitsu.com [10.128.233.124])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id E9F5FF0FD9
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 18:24:01 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3004.s.css.fujitsu.com (Postfix) with ESMTP id B3F0A20607A2;
	Fri, 11 Nov 2022 18:24:01 +0900 (JST)
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
Subject: [RFC PATCH v2 7/7] RDMA/rxe: Add support for the traditional Atomic operations with ODP
Date: Fri, 11 Nov 2022 18:22:28 +0900
Message-Id: <07a8870f4c7aea3aa876727f8264ec4fb33ed774.1668157436.git.matsuda-daisuke@fujitsu.com>
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

Enable 'fetch and add' and 'compare and swap' operations to manipulate
data in an ODP-enabled MR. This is comprised of the following steps:
 1. Check the driver page table(umem_odp->dma_list) to see if the target
    page is both readable and writable.
 2. If not, then trigger page fault to map the page.
 3. Convert its user space address to a kernel logical address using PFNs
    in the driver page table(umem_odp->pfn_list).
 4. Execute the operation.

umem_mutex is used to ensure that dma_list (an array of addresses of an MR)
is not changed while it is checked and that the target page is not
invalidated before data access completes.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/sw/rxe/rxe.c      |  1 +
 drivers/infiniband/sw/rxe/rxe_loc.h  |  2 ++
 drivers/infiniband/sw/rxe/rxe_odp.c  | 45 ++++++++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_resp.c |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.h |  3 ++
 5 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index dd287fc60e9d..8190af3e9afe 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -88,6 +88,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_RECV;
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_WRITE;
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_READ;
+		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
 	}
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 8b19b6fdc497..6370dc31c83a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -194,5 +194,7 @@ int rxe_create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length, u64 iova,
 			   int access_flags, struct rxe_mr *mr);
 int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
 		    enum rxe_mr_copy_dir dir);
+enum resp_states rxe_odp_atomic_ops(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
+				    struct rxe_mr *mr);
 
 #endif /* RXE_LOC_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index ba4723818ee7..00aab9071737 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -289,3 +289,48 @@ int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
 
 	return err;
 }
+
+static inline void *rxe_odp_get_virt_atomic(struct rxe_qp *qp, struct rxe_mr *mr)
+{
+	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	u64 iova = qp->resp.va + qp->resp.offset;
+	int idx;
+	size_t offset;
+
+	if (rxe_odp_map_range(mr, iova, sizeof(char), 0))
+		return NULL;
+
+	idx = (iova - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
+	offset = iova & (BIT(umem_odp->page_shift) - 1);
+
+	return rxe_odp_get_virt(umem_odp, idx, offset);
+}
+
+enum resp_states rxe_odp_atomic_ops(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
+				    struct rxe_mr *mr)
+{
+	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	u64 *vaddr;
+	int ret;
+
+	if (unlikely(!mr->odp_enabled))
+		return RESPST_ERR_RKEY_VIOLATION;
+
+	/* If pagefault is not required, umem mutex will be held until an
+	 * atomic operation completes. Otherwise, it is released and locked
+	 * again in rxe_odp_map_range() to let invalidation handler do its
+	 * work meanwhile.
+	 */
+	mutex_lock(&umem_odp->umem_mutex);
+
+	vaddr = (u64 *)rxe_odp_get_virt_atomic(qp, mr);
+
+	if (pkt->mask & RXE_ATOMIC_MASK)
+		ret = rxe_process_atomic(qp, pkt, vaddr);
+	else
+		/* ATOMIC WRITE operation will come here. */
+		ret = RESPST_ERR_RKEY_VIOLATION;
+
+	mutex_unlock(&umem_odp->umem_mutex);
+	return ret;
+}
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 296b9ccee330..8e6a32c6c9e7 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -647,7 +647,7 @@ static enum resp_states rxe_atomic_reply(struct rxe_qp *qp,
 			return RESPST_ERR_RKEY_VIOLATION;
 
 		if (mr->odp_enabled)
-			ret = RESPST_ERR_UNSUPPORTED_OPCODE;
+			ret = rxe_odp_atomic_ops(qp, pkt, mr);
 		else
 			ret = rxe_atomic_ops(qp, pkt, mr);
 	} else
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.h b/drivers/infiniband/sw/rxe/rxe_resp.h
index 121f0b998196..cb907b49175f 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.h
+++ b/drivers/infiniband/sw/rxe/rxe_resp.h
@@ -38,4 +38,7 @@ enum resp_states {
 	RESPST_EXIT,
 };
 
+enum resp_states rxe_process_atomic(struct rxe_qp *qp,
+				    struct rxe_pkt_info *pkt, u64 *vaddr);
+
 #endif /* RXE_RESP_H */
-- 
2.31.1


