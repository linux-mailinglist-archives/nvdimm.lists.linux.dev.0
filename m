Return-Path: <nvdimm+bounces-3848-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D23FD5328DD
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 May 2022 13:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02C58280353
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 May 2022 11:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BE880B;
	Tue, 24 May 2022 11:24:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E590B7C
	for <nvdimm@lists.linux.dev>; Tue, 24 May 2022 11:24:10 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OA1hVR015197;
	Tue, 24 May 2022 11:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=kykubJkzX1oGNgeN6ESKMNHxM8yz3Sga91HNs+hXK9A=;
 b=YJM1gGBwg/54LDliHFrem99cSHzyQEBb+FL3BdR4pg/rbcDRdDMWgZaqNVZe+g0pKmmx
 aUB6qzJHSRqHX4eZCuhTSzT/nvYjTK4MoJitkzcyXi+5YyUqtEuQd8WGofJB8driXo9s
 vJ4Oq95zBLyAAJL0u6J/ZsspR8uMnLto23n7p/k+ffZyoZ3a3wlT3taufNAQfJjHNZNo
 ozh0zlmlJYB1sbMhJ3g/gabxfY+qUrQLUQIsp6dcvNbxea8N5acYgnYvr6ZaDGMyUzqb
 NAERqDOpRzDDgB38KwbCxDiwqwjB+GGgcLpJfKNa61GGNcrvOtAEfRarnUlZEcfjJM7n 1w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8w8g1fya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 May 2022 11:24:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OBCD6a027258;
	Tue, 24 May 2022 11:24:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma06ams.nl.ibm.com with ESMTP id 3g6qbjcbnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 May 2022 11:24:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OBNxFs40829284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 May 2022 11:23:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 868EC52052;
	Tue, 24 May 2022 11:23:59 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.16.48])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 2670C5204F;
	Tue, 24 May 2022 11:23:55 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 24 May 2022 16:53:54 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>
Subject: [PATCH] powerpc/papr_scm: don't requests stats with '0' sized stats buffer
Date: Tue, 24 May 2022 16:53:53 +0530
Message-Id: <20220524112353.1718454-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d2l_vtGwXDQrm6Kiv6av3OVqPcbbjDCU
X-Proofpoint-ORIG-GUID: d2l_vtGwXDQrm6Kiv6av3OVqPcbbjDCU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 impostorscore=0
 mlxlogscore=916 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240057

Sachin reported [1] that on a POWER-10 lpar he is seeing a kernel panic being
reported with vPMEM when papr_scm probe is being called. The panic is of the
form below and is observed only with following option disabled(profile) for the
said LPAR 'Enable Performance Information Collection' in the HMC:

 Kernel attempted to write user page (1c) - exploit attempt? (uid: 0)
 BUG: Kernel NULL pointer dereference on write at 0x0000001c
 Faulting instruction address: 0xc008000001b90844
 Oops: Kernel access of bad area, sig: 11 [#1]
<snip>
 NIP [c008000001b90844] drc_pmem_query_stats+0x5c/0x270 [papr_scm]
 LR [c008000001b92794] papr_scm_probe+0x2ac/0x6ec [papr_scm]
 Call Trace:
       0xc00000000941bca0 (unreliable)
       papr_scm_probe+0x2ac/0x6ec [papr_scm]
       platform_probe+0x98/0x150
       really_probe+0xfc/0x510
       __driver_probe_device+0x17c/0x230
<snip>
 ---[ end trace 0000000000000000 ]---
 Kernel panic - not syncing: Fatal exception

On investigation looks like this panic was caused due to a 'stat_buffer' of
size==0 being provided to drc_pmem_query_stats() to fetch all performance
stats-ids of an NVDIMM. However drc_pmem_query_stats() shouldn't have been called
since the vPMEM NVDIMM doesn't support and performance stat-id's. This was caused
due to missing check for 'p->stat_buffer_len' at the beginning of
papr_scm_pmu_check_events() which indicates that the NVDIMM doesn't support
performance-stats.

Fix this by introducing the check for 'p->stat_buffer_len' at the beginning of
papr_scm_pmu_check_events().

[1] https://lore.kernel.org/all/6B3A522A-6A5F-4CC9-B268-0C63AA6E07D3@linux.ibm.com

Fixes: 0e0946e22f3665d2732 ("powerpc/papr_scm: Fix leaking nvdimm_events_map elements")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 181b855b3050..82cae08976bc 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -465,6 +465,9 @@ static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu
 	u32 available_events;
 	int index, rc = 0;
 
+	if (!p->stat_buffer_len)
+		return -ENOENT;
+
 	available_events = (p->stat_buffer_len  - sizeof(struct papr_scm_perf_stats))
 			/ sizeof(struct papr_scm_perf_stat);
 	if (available_events == 0)
-- 
2.35.1


