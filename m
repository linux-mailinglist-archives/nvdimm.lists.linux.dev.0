Return-Path: <nvdimm+bounces-231-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F063AB9EC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jun 2021 18:51:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 6615E3E104A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jun 2021 16:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADC46D0F;
	Thu, 17 Jun 2021 16:51:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF4172
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 16:51:25 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HGZGAS166284;
	Thu, 17 Jun 2021 12:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=01/uUUbXSudJzlRpKVgbXNW3ySvB0UacosEODucT4AM=;
 b=sLKJzjmk5HmCpPRQiw9EJEwxHbZ/UgP31DYX1MEIQcigHaVqnfsu1g+FCuMiTx3t2ZRt
 aYr/Z7F7vrBLrdTku75tPb6XESgnG11huBykjY4NXAhxSh8rEsRjxBpq4T1X4F/22+NK
 dQtmffnPQ5KdAe8mHh4VyP81uYcD1dpFcJvNTHKvFwppuEIi+A6/SmSls5CtHJALF7fW
 qIPPdgJVS8P4lMmdQnz93Qb1yHgwnqfxgWceKrYhYqyOT+6hLQRQN26/cKVzt9995kfN
 hxsmbUsrCHkk4DN37DtL0E+ZcqDQvdMa9xWP8cVOUl089k6XuR7kiLeRGrqcf8c/SDbn 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3984w2vct7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 12:51:21 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HGZKAb166777;
	Thu, 17 Jun 2021 12:51:21 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3984w2vcsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 12:51:21 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
	by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HGm6ZC019799;
	Thu, 17 Jun 2021 16:51:20 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by ppma03wdc.us.ibm.com with ESMTP id 394mja2j4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 16:51:20 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HGpJ6031195614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 16:51:19 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F037B2066;
	Thu, 17 Jun 2021 16:51:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6AB8B206B;
	Thu, 17 Jun 2021 16:51:16 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.39.101])
	by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
	Thu, 17 Jun 2021 16:51:16 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc: Nathan Lynch <nathanl@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v4 2/7] powerpc/pseries: rename distance_ref_points_depth to max_associativity_domain_index
Date: Thu, 17 Jun 2021 22:21:00 +0530
Message-Id: <20210617165105.574178-3-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617165105.574178-1-aneesh.kumar@linux.ibm.com>
References: <20210617165105.574178-1-aneesh.kumar@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QNLZwN0xyZ_dqwDuZdCOTX7Y6IbwUuAf
X-Proofpoint-GUID: xJlFBndiXPMQz8IPMvm4kO4w7w55EFOc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_15:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106170104

No functional change in this patch

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/mm/numa.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 8365b298ec48..132813dd1a6c 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -56,7 +56,7 @@ static int n_mem_addr_cells, n_mem_size_cells;
 static int form1_affinity;
 
 #define MAX_DISTANCE_REF_POINTS 4
-static int distance_ref_points_depth;
+static int max_associativity_domain_index;
 static const __be32 *distance_ref_points;
 static int distance_lookup_table[MAX_NUMNODES][MAX_DISTANCE_REF_POINTS];
 
@@ -169,7 +169,7 @@ int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 
 	int i, index;
 
-	for (i = 0; i < distance_ref_points_depth; i++) {
+	for (i = 0; i < max_associativity_domain_index; i++) {
 		index = be32_to_cpu(distance_ref_points[i]);
 		if (cpu1_assoc[index] == cpu2_assoc[index])
 			break;
@@ -193,7 +193,7 @@ int __node_distance(int a, int b)
 	if (!form1_affinity)
 		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
-	for (i = 0; i < distance_ref_points_depth; i++) {
+	for (i = 0; i < max_associativity_domain_index; i++) {
 		if (distance_lookup_table[a][i] == distance_lookup_table[b][i])
 			break;
 
@@ -213,7 +213,7 @@ static void initialize_distance_lookup_table(int nid,
 	if (!form1_affinity)
 		return;
 
-	for (i = 0; i < distance_ref_points_depth; i++) {
+	for (i = 0; i < max_associativity_domain_index; i++) {
 		const __be32 *entry;
 
 		entry = &associativity[be32_to_cpu(distance_ref_points[i]) - 1];
@@ -240,7 +240,7 @@ static int associativity_to_nid(const __be32 *associativity)
 		nid = NUMA_NO_NODE;
 
 	if (nid > 0 &&
-		of_read_number(associativity, 1) >= distance_ref_points_depth) {
+		of_read_number(associativity, 1) >= max_associativity_domain_index) {
 		/*
 		 * Skip the length field and send start of associativity array
 		 */
@@ -310,14 +310,14 @@ static int __init find_primary_domain_index(void)
 	 */
 	distance_ref_points = of_get_property(root,
 					"ibm,associativity-reference-points",
-					&distance_ref_points_depth);
+					&max_associativity_domain_index);
 
 	if (!distance_ref_points) {
 		dbg("NUMA: ibm,associativity-reference-points not found.\n");
 		goto err;
 	}
 
-	distance_ref_points_depth /= sizeof(int);
+	max_associativity_domain_index /= sizeof(int);
 
 	if (firmware_has_feature(FW_FEATURE_OPAL) ||
 	    firmware_has_feature(FW_FEATURE_TYPE1_AFFINITY)) {
@@ -328,7 +328,7 @@ static int __init find_primary_domain_index(void)
 	if (form1_affinity) {
 		index = of_read_number(distance_ref_points, 1);
 	} else {
-		if (distance_ref_points_depth < 2) {
+		if (max_associativity_domain_index < 2) {
 			printk(KERN_WARNING "NUMA: "
 				"short ibm,associativity-reference-points\n");
 			goto err;
@@ -341,10 +341,10 @@ static int __init find_primary_domain_index(void)
 	 * Warn and cap if the hardware supports more than
 	 * MAX_DISTANCE_REF_POINTS domains.
 	 */
-	if (distance_ref_points_depth > MAX_DISTANCE_REF_POINTS) {
+	if (max_associativity_domain_index > MAX_DISTANCE_REF_POINTS) {
 		printk(KERN_WARNING "NUMA: distance array capped at "
 			"%d entries\n", MAX_DISTANCE_REF_POINTS);
-		distance_ref_points_depth = MAX_DISTANCE_REF_POINTS;
+		max_associativity_domain_index = MAX_DISTANCE_REF_POINTS;
 	}
 
 	of_node_put(root);
-- 
2.31.1


