Return-Path: <nvdimm+bounces-5565-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E075654C9C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Dec 2022 07:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E2AD280A9B
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Dec 2022 06:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A280223D8;
	Fri, 23 Dec 2022 06:53:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FCE23A2
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 06:53:36 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="102069672"
X-IronPort-AV: E=Sophos;i="5.96,267,1665414000"; 
   d="scan'208";a="102069672"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP; 23 Dec 2022 15:52:24 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id B68EF7E116
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:23 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com [10.128.233.114])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id DF04DF66E8
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:17 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3003.s.css.fujitsu.com (Postfix) with ESMTP id 980B4200B2A8;
	Fri, 23 Dec 2022 15:52:17 +0900 (JST)
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
Subject: [PATCH for-next v3 2/7] RDMA/rxe: Always schedule works before accessing user MRs
Date: Fri, 23 Dec 2022 15:51:53 +0900
Message-Id: <53e045f842a5519eb905c447eeff9441de609fdb.1671772917.git.matsuda-daisuke@fujitsu.com>
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

Both responder and completer can sleep to execute page-fault when used
with ODP, and page-fault handler can be invoked when they are going to
access user MRs, so works must be scheduled in such cases.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 20 ++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_recv.c |  4 ++--
 drivers/infiniband/sw/rxe/rxe_resp.c | 15 ++++++++++-----
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 046bbacce37c..421f4ffe51a3 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -124,13 +124,29 @@ void retransmit_timer(struct timer_list *t)
 	}
 }
 
-void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
+void rxe_comp_queue_pkt(struct rxe_pkt_info *pkt, struct sk_buff *skb)
 {
+	struct rxe_qp *qp = pkt->qp;
 	int must_sched;
 
 	skb_queue_tail(&qp->resp_pkts, skb);
 
-	must_sched = skb_queue_len(&qp->resp_pkts) > 1;
+	/* Schedule a work item if processing READ or ATOMIC acks.
+	 * In these cases, completer may sleep to access ODP-enabled MRs.
+	 */
+	switch (pkt->opcode) {
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY:
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST:
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST:
+	case IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE:
+		must_sched = 1;
+		break;
+
+	default:
+		must_sched = skb_queue_len(&qp->resp_pkts) > 1;
+	}
+
 	if (must_sched != 0)
 		rxe_counter_inc(SKB_TO_PKT(skb)->rxe, RXE_CNT_COMPLETER_SCHED);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 948ce4902b10..d567aa65b5e0 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -176,9 +176,9 @@ int rxe_icrc_init(struct rxe_dev *rxe);
 int rxe_icrc_check(struct sk_buff *skb, struct rxe_pkt_info *pkt);
 void rxe_icrc_generate(struct sk_buff *skb, struct rxe_pkt_info *pkt);
 
-void rxe_resp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
+void rxe_resp_queue_pkt(struct rxe_pkt_info *pkt, struct sk_buff *skb);
 
-void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
+void rxe_comp_queue_pkt(struct rxe_pkt_info *pkt, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 434a693cd4a5..01d07572a56f 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -174,9 +174,9 @@ static int hdr_check(struct rxe_pkt_info *pkt)
 static inline void rxe_rcv_pkt(struct rxe_pkt_info *pkt, struct sk_buff *skb)
 {
 	if (pkt->mask & RXE_REQ_MASK)
-		rxe_resp_queue_pkt(pkt->qp, skb);
+		rxe_resp_queue_pkt(pkt, skb);
 	else
-		rxe_comp_queue_pkt(pkt->qp, skb);
+		rxe_comp_queue_pkt(pkt, skb);
 }
 
 static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index d9134a00a529..991550baef8c 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -85,15 +85,20 @@ static char *resp_state_name[] = {
 };
 
 /* rxe_recv calls here to add a request packet to the input queue */
-void rxe_resp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
+void rxe_resp_queue_pkt(struct rxe_pkt_info *pkt, struct sk_buff *skb)
 {
-	int must_sched;
-	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
+	int must_sched = 1;
+	struct rxe_qp *qp = pkt->qp;
 
 	skb_queue_tail(&qp->req_pkts, skb);
 
-	must_sched = (pkt->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST) ||
-			(skb_queue_len(&qp->req_pkts) > 1);
+	/* responder can sleep to access an ODP-enabled MR. Always schedule
+	 * work items for non-zero-byte operations, RDMA READ, and ATOMIC
+	 * operations.
+	 */
+	if ((skb_queue_len(&qp->req_pkts) == 1) && (payload_size(pkt) == 0)
+	    && !(pkt->mask & RXE_READ_OR_ATOMIC_MASK))
+		must_sched = 0;
 
 	if (must_sched)
 		rxe_sched_task(&qp->resp.task);
-- 
2.31.1


