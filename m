Return-Path: <nvdimm+bounces-217-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF9D3AADB8
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jun 2021 09:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id AA3AE1C0E0C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Jun 2021 07:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B85E6D2C;
	Thu, 17 Jun 2021 07:35:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6480C6D10
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 07:35:31 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15H7Z7Ok176436;
	Thu, 17 Jun 2021 03:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vI8PkbPBlpoEc86rYAy6KObZxMHJtikJOjNrt1GAsfs=;
 b=Doh6WdT8TTbDu/BJ+bPblIOFzm1s9DTDgRIFyck2D73/m35GrHggk7rWoVwY4Du81Crh
 kg+Eef12O9i1yQKY1o/6oc3u2X7Q30+dS0UAOLRVP1aG/QbkK0tXJiItSaYfGQOa9GBZ
 zgBQoQjAmu0gIMeSjsJWPXI7VgaYGcWNpnz+KLbHujR9Vb6gwnciWZ7zMvKSrQ6Dmzys
 OqAf4vpZV+aXAI2heEd8p7sNcj47FiUGfBwzy2Ggn/WWAe/KLrBrfpZDT9ITbfb16gfw
 ipQnlPybw7fnLGQdK6GmMsZGqo/n4E9yITuMMy4Qevb6m5FkqOdtI1RfB4aMCZ6Yd8vN qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3980jfav1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 03:35:26 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15H7ZB40176717;
	Thu, 17 Jun 2021 03:35:26 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3980jfav0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 03:35:26 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
	by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15H7WDRV023228;
	Thu, 17 Jun 2021 07:35:25 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by ppma02wdc.us.ibm.com with ESMTP id 394mja6tcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 07:35:25 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15H7ZPkM6750482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 07:35:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 025D3112070;
	Thu, 17 Jun 2021 07:35:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F75411206D;
	Thu, 17 Jun 2021 07:35:22 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.102.31.110])
	by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
	Thu, 17 Jun 2021 07:35:22 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc: Nathan Lynch <nathanl@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 4/8] powerpc/pseries: Consolidate DLPAR NUMA distance update
Date: Thu, 17 Jun 2021 13:04:54 +0530
Message-Id: <20210617073458.510545-5-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617073458.510545-1-aneesh.kumar@linux.ibm.com>
References: <20210617073458.510545-1-aneesh.kumar@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qe70m7RVK5SNtbUHXcIS-nus62h-64yt
X-Proofpoint-GUID: yygfRvxHnmmq1xpalp2lecpaF1JgFuxg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_02:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170052

The associativity details of the newly added resourced are collected from
the hypervisor via "ibm,configure-connector" rtas call. Update the numa
distance details of the newly added numa node after the above call. In
later patch we will remove updating NUMA distance when we are looking
for node id from associativity array.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/mm/numa.c                        | 41 +++++++++++++++++++
 arch/powerpc/platforms/pseries/hotplug-cpu.c  |  2 +
 .../platforms/pseries/hotplug-memory.c        |  2 +
 arch/powerpc/platforms/pseries/pseries.h      |  1 +
 4 files changed, 46 insertions(+)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 0ec16999beef..645a95e3a7ea 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -287,6 +287,47 @@ int of_node_to_nid(struct device_node *device)
 }
 EXPORT_SYMBOL(of_node_to_nid);
 
+static void __initialize_form1_numa_distance(const __be32 *associativity)
+{
+	int i, nid;
+
+	if (of_read_number(associativity, 1) >= primary_domain_index) {
+		nid = of_read_number(&associativity[primary_domain_index], 1);
+
+		for (i = 0; i < max_domain_index; i++) {
+			const __be32 *entry;
+
+			entry = &associativity[be32_to_cpu(distance_ref_points[i])];
+			distance_lookup_table[nid][i] = of_read_number(entry, 1);
+		}
+	}
+}
+
+static void initialize_form1_numa_distance(struct device_node *node)
+{
+	const __be32 *associativity;
+
+	associativity = of_get_associativity(node);
+	if (!associativity)
+		return;
+
+	__initialize_form1_numa_distance(associativity);
+	return;
+}
+
+/*
+ * Used to update distance information w.r.t newly added node.
+ */
+void update_numa_distance(struct device_node *node)
+{
+	if (affinity_form == FORM0_AFFINITY)
+		return;
+	else if (affinity_form == FORM1_AFFINITY) {
+		initialize_form1_numa_distance(node);
+		return;
+	}
+}
+
 static int __init find_primary_domain_index(void)
 {
 	int index;
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 7e970f81d8ff..778b6ab35f0d 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -498,6 +498,8 @@ static ssize_t dlpar_cpu_add(u32 drc_index)
 		return saved_rc;
 	}
 
+	update_numa_distance(dn);
+
 	rc = dlpar_online_cpu(dn);
 	if (rc) {
 		saved_rc = rc;
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 8377f1f7c78e..0e602c3b01ea 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -180,6 +180,8 @@ static int update_lmb_associativity_index(struct drmem_lmb *lmb)
 		return -ENODEV;
 	}
 
+	update_numa_distance(lmb_node);
+
 	dr_node = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
 	if (!dr_node) {
 		dlpar_free_cc_nodes(lmb_node);
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 1f051a786fb3..663a0859cf13 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -113,4 +113,5 @@ extern u32 pseries_security_flavor;
 void pseries_setup_security_mitigations(void);
 void pseries_lpar_read_hblkrm_characteristics(void);
 
+void update_numa_distance(struct device_node *node);
 #endif /* _PSERIES_PSERIES_H */
-- 
2.31.1


