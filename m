Return-Path: <nvdimm+bounces-4195-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27180571EFA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Jul 2022 17:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D30E2280AB6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Jul 2022 15:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333F64429;
	Tue, 12 Jul 2022 15:23:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E384414
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 15:23:55 +0000 (UTC)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CF2nb6007050;
	Tue, 12 Jul 2022 15:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=5ECn/sObgC3lCbv+/XzZgYJYx1I49uysR8R2kS1gM34=;
 b=nyzEbBg3+mS9WzNAGU/lSjK47wlBJyyGx8wce3bi03LzIyjeeb5PRJw0hHYJ/yxMaBpA
 o4rdftOf2DFZXfhTnCOv/t+53NRL/en/H9ttL7SpbVcyjKAU8ec/tV0GALGmXmbHeig/
 VW8Mk7b5itGOSdSLl2rmxWERV0y+WnBwAruQHb36Q52n85duxsrpg01KkoWHg2Jdhp6z
 i+3MooN+2RZkyW0vP5RorG2jx8kz1h7Jk4toQKXgs7+MbWFp2hXC6D8mp4dnjxa5WgC3
 8emuhmVI1f/SUliw3KjaJpt1R4W6TdMLzdU3gf7f7CwfgcjSfNycT2DbQYw9QNhEbOdq bg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h99r03r0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Jul 2022 15:23:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CFM0TJ012056;
	Tue, 12 Jul 2022 15:23:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma04ams.nl.ibm.com with ESMTP id 3h8rrn19vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Jul 2022 15:23:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CFNjsD16449988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Jul 2022 15:23:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5C594203F;
	Tue, 12 Jul 2022 15:23:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C86FE42041;
	Tue, 12 Jul 2022 15:23:44 +0000 (GMT)
Received: from ltc-boston123.aus.stglabs.ibm.com (unknown [9.40.193.212])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 12 Jul 2022 15:23:44 +0000 (GMT)
Subject: [REPOST PATCH] ndtest: Cleanup all of blk namespace specific code
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: linuxppc-dev@lists.ozlabs.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, dan.j.williams@intel.com, ira.weiny@intel.com,
        mpe@ellerman.id.au
Date: Tue, 12 Jul 2022 10:23:44 -0500
Message-ID: 
 <165763940218.3501174.7103619358744815702.stgit@ltc-boston123.aus.stglabs.ibm.com>
User-Agent: StGit/0.19
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nA906ZoSj8WM3tlF64CqdcA_NTmcsMm2
X-Proofpoint-ORIG-GUID: nA906ZoSj8WM3tlF64CqdcA_NTmcsMm2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_08,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1011 spamscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207120059

With the nd_namespace_blk and nd_blk_region infrastructures being removed,
the ndtest still has some references to the old code. So the
compilation fails as below,

../tools/testing/nvdimm/test/ndtest.c:204:25: error: ‘ND_DEVICE_NAMESPACE_BLK’ undeclared here (not in a function); did you mean ‘ND_DEVICE_NAMESPACE_IO’?
  204 |                 .type = ND_DEVICE_NAMESPACE_BLK,
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         ND_DEVICE_NAMESPACE_IO
../tools/testing/nvdimm/test/ndtest.c: In function ‘ndtest_create_region’:
../tools/testing/nvdimm/test/ndtest.c:630:17: error: ‘ndbr_desc’ undeclared (first use in this function); did you mean ‘ndr_desc’?
  630 |                 ndbr_desc.enable = ndtest_blk_region_enable;
      |                 ^~~~~~~~~
      |                 ndr_desc
../tools/testing/nvdimm/test/ndtest.c:630:17: note: each undeclared identifier is reported only once for each function it appears in
../tools/testing/nvdimm/test/ndtest.c:630:36: error: ‘ndtest_blk_region_enable’ undeclared (first use in this function)
  630 |                 ndbr_desc.enable = ndtest_blk_region_enable;
      |                                    ^~~~~~~~~~~~~~~~~~~~~~~~
../tools/testing/nvdimm/test/ndtest.c:631:35: error: ‘ndtest_blk_do_io’ undeclared (first use in this function); did you mean ‘ndtest_blk_mmio’?
  631 |                 ndbr_desc.do_io = ndtest_blk_do_io;
      |                                   ^~~~~~~~~~~~~~~~
      |                                   ndtest_blk_mmio

The current patch removes the specific code to cleanup all obsolete
references.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
Changelog:
Repost of v1:
Link - https://patchwork.kernel.org/project/linux-nvdimm/patch/165025395730.2821159.14794984437851867426.stgit@lep8c.aus.stglabs.ibm.com/
No changes.

 tools/testing/nvdimm/test/ndtest.c |   77 ------------------------------------
 1 file changed, 77 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 4d1a947367f9..01ceb98c15a0 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -134,39 +134,6 @@ static struct ndtest_mapping region1_mapping[] = {
 	},
 };

-static struct ndtest_mapping region2_mapping[] = {
-	{
-		.dimm = 0,
-		.position = 0,
-		.start = 0,
-		.size = DIMM_SIZE,
-	},
-};
-
-static struct ndtest_mapping region3_mapping[] = {
-	{
-		.dimm = 1,
-		.start = 0,
-		.size = DIMM_SIZE,
-	}
-};
-
-static struct ndtest_mapping region4_mapping[] = {
-	{
-		.dimm = 2,
-		.start = 0,
-		.size = DIMM_SIZE,
-	}
-};
-
-static struct ndtest_mapping region5_mapping[] = {
-	{
-		.dimm = 3,
-		.start = 0,
-		.size = DIMM_SIZE,
-	}
-};
-
 static struct ndtest_region bus0_regions[] = {
 	{
 		.type = ND_DEVICE_NAMESPACE_PMEM,
@@ -182,34 +149,6 @@ static struct ndtest_region bus0_regions[] = {
 		.size = DIMM_SIZE * 2,
 		.range_index = 2,
 	},
-	{
-		.type = ND_DEVICE_NAMESPACE_BLK,
-		.num_mappings = ARRAY_SIZE(region2_mapping),
-		.mapping = region2_mapping,
-		.size = DIMM_SIZE,
-		.range_index = 3,
-	},
-	{
-		.type = ND_DEVICE_NAMESPACE_BLK,
-		.num_mappings = ARRAY_SIZE(region3_mapping),
-		.mapping = region3_mapping,
-		.size = DIMM_SIZE,
-		.range_index = 4,
-	},
-	{
-		.type = ND_DEVICE_NAMESPACE_BLK,
-		.num_mappings = ARRAY_SIZE(region4_mapping),
-		.mapping = region4_mapping,
-		.size = DIMM_SIZE,
-		.range_index = 5,
-	},
-	{
-		.type = ND_DEVICE_NAMESPACE_BLK,
-		.num_mappings = ARRAY_SIZE(region5_mapping),
-		.mapping = region5_mapping,
-		.size = DIMM_SIZE,
-		.range_index = 6,
-	},
 };

 static struct ndtest_mapping region6_mapping[] = {
@@ -501,21 +440,6 @@ static int ndtest_create_region(struct ndtest_priv *p,
 	nd_set->altcookie = nd_set->cookie1;
 	ndr_desc->nd_set = nd_set;

-	if (region->type == ND_DEVICE_NAMESPACE_BLK) {
-		mappings[0].start = 0;
-		mappings[0].size = DIMM_SIZE;
-		mappings[0].nvdimm = p->config->dimms[ndimm].nvdimm;
-
-		ndr_desc->mapping = &mappings[0];
-		ndr_desc->num_mappings = 1;
-		ndr_desc->num_lanes = 1;
-		ndbr_desc.enable = ndtest_blk_region_enable;
-		ndbr_desc.do_io = ndtest_blk_do_io;
-		region->region = nvdimm_blk_region_create(p->bus, ndr_desc);
-
-		goto done;
-	}
-
 	for (i = 0; i < region->num_mappings; i++) {
 		ndimm = region->mapping[i].dimm;
 		mappings[i].start = region->mapping[i].start;
@@ -527,7 +451,6 @@ static int ndtest_create_region(struct ndtest_priv *p,
 	ndr_desc->num_mappings = region->num_mappings;
 	region->region = nvdimm_pmem_region_create(p->bus, ndr_desc);

-done:
 	if (!region->region) {
 		dev_err(&p->pdev.dev, "Error registering region %pR\n",
 			ndr_desc->res);



