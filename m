Return-Path: <nvdimm+bounces-233-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBE93AB9F0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jun 2021 18:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 9008D3E10EE
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jun 2021 16:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8956D1A;
	Thu, 17 Jun 2021 16:51:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDDC6D15
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 16:51:29 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HGZ8cH111415;
	Thu, 17 Jun 2021 12:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lw8KDET9356JySrstryGIngD5kuCZmK5bMgNuqxfapY=;
 b=bacoI9+qjqul2LxLGHBc6VKECu5+abcjH+Xu3PIgI3Oky99bymm6CHHel5SWZF8sbwIt
 ixUbry/mM4M4tzIExkPUtOD8smh7+S2+q3Yp6MkMpbH3983K2cOG5Rlv7t2nmJXUEqvA
 vN4m4+yL5oYiuD3hK41qndke8TeW52btk3uXibHNsPS9WuAXUHAcAGo70SjmHEJTISbO
 0FVq0RM4sd60z8baQpjoxx7tHmgzo8hGyXq+oCwkh/IJ7IiTFS/zRDQmQs7/zZXujs3R
 kbFTV6TYovueAiWrQlDOYHTLrE1B1TkPNYhliaERMrITXmVFvpgfec/Iq+lzi3oFNpdM eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3989j49beb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 12:51:24 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HGZLA6112229;
	Thu, 17 Jun 2021 12:51:23 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3989j49be2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 12:51:23 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
	by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HGlXMm028376;
	Thu, 17 Jun 2021 16:51:23 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by ppma01wdc.us.ibm.com with ESMTP id 394mj9tkux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 16:51:23 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HGpMu636176224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 16:51:23 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4585B2066;
	Thu, 17 Jun 2021 16:51:22 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2429FB2065;
	Thu, 17 Jun 2021 16:51:20 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.39.101])
	by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
	Thu, 17 Jun 2021 16:51:19 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc: Nathan Lynch <nathanl@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v4 3/7] powerpc/pseries: Rename TYPE1_AFFINITY to FORM1_AFFINITY
Date: Thu, 17 Jun 2021 22:21:01 +0530
Message-Id: <20210617165105.574178-4-aneesh.kumar@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: CJijxWkEJ-ZbTN_GOc81kNVijgAc2P1z
X-Proofpoint-GUID: xVyLwROzdyitx0wc0eEFBqlqXcUENpy3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_15:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170104

Also make related code cleanup that will allow adding FORM2_AFFINITY in
later patches. No functional change in this patch.

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/include/asm/firmware.h       |  4 +--
 arch/powerpc/include/asm/prom.h           |  2 +-
 arch/powerpc/kernel/prom_init.c           |  2 +-
 arch/powerpc/mm/numa.c                    | 35 ++++++++++++++---------
 arch/powerpc/platforms/pseries/firmware.c |  2 +-
 5 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index 7604673787d6..60b631161360 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -44,7 +44,7 @@
 #define FW_FEATURE_OPAL		ASM_CONST(0x0000000010000000)
 #define FW_FEATURE_SET_MODE	ASM_CONST(0x0000000040000000)
 #define FW_FEATURE_BEST_ENERGY	ASM_CONST(0x0000000080000000)
-#define FW_FEATURE_TYPE1_AFFINITY ASM_CONST(0x0000000100000000)
+#define FW_FEATURE_FORM1_AFFINITY ASM_CONST(0x0000000100000000)
 #define FW_FEATURE_PRRN		ASM_CONST(0x0000000200000000)
 #define FW_FEATURE_DRMEM_V2	ASM_CONST(0x0000000400000000)
 #define FW_FEATURE_DRC_INFO	ASM_CONST(0x0000000800000000)
@@ -69,7 +69,7 @@ enum {
 		FW_FEATURE_SPLPAR | FW_FEATURE_LPAR |
 		FW_FEATURE_CMO | FW_FEATURE_VPHN | FW_FEATURE_XCMO |
 		FW_FEATURE_SET_MODE | FW_FEATURE_BEST_ENERGY |
-		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
+		FW_FEATURE_FORM1_AFFINITY | FW_FEATURE_PRRN |
 		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
 		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
 		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR |
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 324a13351749..df9fec9d232c 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -147,7 +147,7 @@ extern int of_read_drc_info_cell(struct property **prop,
 #define OV5_MSI			0x0201	/* PCIe/MSI support */
 #define OV5_CMO			0x0480	/* Cooperative Memory Overcommitment */
 #define OV5_XCMO		0x0440	/* Page Coalescing */
-#define OV5_TYPE1_AFFINITY	0x0580	/* Type 1 NUMA affinity */
+#define OV5_FORM1_AFFINITY	0x0580	/* FORM1 NUMA affinity */
 #define OV5_PRRN		0x0540	/* Platform Resource Reassignment */
 #define OV5_HP_EVT		0x0604	/* Hot Plug Event support */
 #define OV5_RESIZE_HPT		0x0601	/* Hash Page Table resizing */
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 41ed7e33d897..64b9593038a7 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1070,7 +1070,7 @@ static const struct ibm_arch_vec ibm_architecture_vec_template __initconst = {
 #else
 		0,
 #endif
-		.associativity = OV5_FEAT(OV5_TYPE1_AFFINITY) | OV5_FEAT(OV5_PRRN),
+		.associativity = OV5_FEAT(OV5_FORM1_AFFINITY) | OV5_FEAT(OV5_PRRN),
 		.bin_opts = OV5_FEAT(OV5_RESIZE_HPT) | OV5_FEAT(OV5_HP_EVT),
 		.micro_checkpoint = 0,
 		.reserved0 = 0,
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 132813dd1a6c..0ec16999beef 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -53,7 +53,10 @@ EXPORT_SYMBOL(node_data);
 
 static int primary_domain_index;
 static int n_mem_addr_cells, n_mem_size_cells;
-static int form1_affinity;
+
+#define FORM0_AFFINITY 0
+#define FORM1_AFFINITY 1
+static int affinity_form;
 
 #define MAX_DISTANCE_REF_POINTS 4
 static int max_associativity_domain_index;
@@ -190,7 +193,7 @@ int __node_distance(int a, int b)
 	int i;
 	int distance = LOCAL_DISTANCE;
 
-	if (!form1_affinity)
+	if (affinity_form == FORM0_AFFINITY)
 		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < max_associativity_domain_index; i++) {
@@ -210,7 +213,7 @@ static void initialize_distance_lookup_table(int nid,
 {
 	int i;
 
-	if (!form1_affinity)
+	if (affinity_form != FORM1_AFFINITY)
 		return;
 
 	for (i = 0; i < max_associativity_domain_index; i++) {
@@ -289,6 +292,17 @@ static int __init find_primary_domain_index(void)
 	int index;
 	struct device_node *root;
 
+	/*
+	 * Check for which form of affinity.
+	 */
+	if (firmware_has_feature(FW_FEATURE_OPAL)) {
+		affinity_form = FORM1_AFFINITY;
+	} else if (firmware_has_feature(FW_FEATURE_FORM1_AFFINITY)) {
+		dbg("Using form 1 affinity\n");
+		affinity_form = FORM1_AFFINITY;
+	} else
+		affinity_form = FORM0_AFFINITY;
+
 	if (firmware_has_feature(FW_FEATURE_OPAL))
 		root = of_find_node_by_path("/ibm,opal");
 	else
@@ -318,23 +332,16 @@ static int __init find_primary_domain_index(void)
 	}
 
 	max_associativity_domain_index /= sizeof(int);
-
-	if (firmware_has_feature(FW_FEATURE_OPAL) ||
-	    firmware_has_feature(FW_FEATURE_TYPE1_AFFINITY)) {
-		dbg("Using form 1 affinity\n");
-		form1_affinity = 1;
-	}
-
-	if (form1_affinity) {
-		index = of_read_number(distance_ref_points, 1);
-	} else {
+	if (affinity_form == FORM0_AFFINITY) {
 		if (max_associativity_domain_index < 2) {
 			printk(KERN_WARNING "NUMA: "
-				"short ibm,associativity-reference-points\n");
+			       "short ibm,associativity-reference-points\n");
 			goto err;
 		}
 
 		index = of_read_number(&distance_ref_points[1], 1);
+	} else {
+		index = of_read_number(distance_ref_points, 1);
 	}
 
 	/*
diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index 4c7b7f5a2ebc..5d4c2bc20bba 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -119,7 +119,7 @@ struct vec5_fw_feature {
 
 static __initdata struct vec5_fw_feature
 vec5_fw_features_table[] = {
-	{FW_FEATURE_TYPE1_AFFINITY,	OV5_TYPE1_AFFINITY},
+	{FW_FEATURE_FORM1_AFFINITY,	OV5_FORM1_AFFINITY},
 	{FW_FEATURE_PRRN,		OV5_PRRN},
 	{FW_FEATURE_DRMEM_V2,		OV5_DRMEM_V2},
 	{FW_FEATURE_DRC_INFO,		OV5_DRC_INFO},
-- 
2.31.1


