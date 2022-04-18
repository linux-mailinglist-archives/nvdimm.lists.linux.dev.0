Return-Path: <nvdimm+bounces-3564-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31099504C40
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Apr 2022 07:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 31D9B1C03CE
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Apr 2022 05:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFF97E5;
	Mon, 18 Apr 2022 05:22:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BC97E0
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 05:22:23 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23I13Qnv026767;
	Mon, 18 Apr 2022 05:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=1B9HmxI97eZmALrkLGN8vR22mu6dkzI6rcrbvJVUpZU=;
 b=jRRUERDBMDMVpp3Is1SKjX0fBMP5DY21ybzicOFHS1rlT8I/0PYVQgVmnBTZWzfoMfUr
 0IQBLCZSl6JPTsvjWfJMH0JxHmpkC5o319nSUZZtaY4xFb94n4QsB2+XkMri1JsMZSTx
 55A9JKaILWtiHEe6Vx6qOPOr9MaaEQd9Yy8udkwA99l1M2P/xu/pzChgRo5sRKcTygq5
 pCRbK291+ErZy31r50EIWPYgNp95RJ+UJiOyqD/yupJwmoTv14jtnLzuO+aRWFehx7Ly
 tLJ1XMfGn8/zXPYvD0nZKzdyXh+tHI9Il40E0SALrKkA7PMuB82MLPlxNTt8rrWwdEyf 9A== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7k9ccjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 05:08:38 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23I56ln3030023;
	Mon, 18 Apr 2022 05:08:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma05fra.de.ibm.com with ESMTP id 3ffne8ssnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 05:08:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23I58XJK39911710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 05:08:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E2D711C04C;
	Mon, 18 Apr 2022 05:08:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E09511C04A;
	Mon, 18 Apr 2022 05:08:32 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 05:08:31 +0000 (GMT)
Subject: [RFC PATCH] ndtest: Make ndtest a module on its own
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        dan.j.williams@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        ira.weiny@intel.com, mpe@ellerman.id.au, linux-kernel@vger.kernel.org
Date: Mon, 18 Apr 2022 00:08:31 -0500
Message-ID: 
 <165025849452.2974989.6131145460098517848.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YWSwhUvagZgljzKvY77wYBufnpNLGhba
X-Proofpoint-GUID: YWSwhUvagZgljzKvY77wYBufnpNLGhba
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_01,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=668 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204180031

Today ndtest module is compiled as nfit_test.ko depending on
if the CONFIG_ACPI_NFIT defined or not.

It is more advantageous to make ndtest a module on its own
so that the unit tests can be run serially on the same host
without a need for recompilation of sources.

The patch modifies the Kbuild file to take care of that.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 tools/testing/nvdimm/test/Kbuild |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/nvdimm/test/Kbuild b/tools/testing/nvdimm/test/Kbuild
index 197bcb2b7f35..4d4835f73b46 100644
--- a/tools/testing/nvdimm/test/Kbuild
+++ b/tools/testing/nvdimm/test/Kbuild
@@ -2,12 +2,12 @@
 ccflags-y := -I$(srctree)/drivers/nvdimm/
 ccflags-y += -I$(srctree)/drivers/acpi/nfit/
 
-obj-m += nfit_test.o
+obj-m += ndtest.o
 obj-m += nfit_test_iomap.o
 
 ifeq  ($(CONFIG_ACPI_NFIT),m)
+	obj-m += nfit_test.o
 	nfit_test-y := nfit.o
-else
-	nfit_test-y := ndtest.o
 endif
+
 nfit_test_iomap-y := iomap.o



