Return-Path: <nvdimm+bounces-186-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAA13A5C68
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Jun 2021 07:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0C6133E100F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Jun 2021 05:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAFE6D1A;
	Mon, 14 Jun 2021 05:24:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BE86D15
	for <nvdimm@lists.linux.dev>; Mon, 14 Jun 2021 05:24:17 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15E53iSi095506;
	Mon, 14 Jun 2021 01:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gXb92jLZltP0TlGgpp4tnPgvWeahwiv76pBDu+u4I1U=;
 b=qzGazO2kJOJCe6de0TuORyD9Dcjv7HccmB7wzLKSmyoeOh+vfmftP110+x7T2QxHKRMX
 RxDtVPj3D5Bm2IcTfOhTS+1cs8Wu6W1KgDUwtM3v77QrEGMDafmhMwu39jWtKAms3pYK
 14UMVrkDFh7/lpZ9SBRGDmqjgaQkJt9pqe2yKaIvZjNeHt2+R/lVw4WEjHM5n7t+CUud
 owvdVfYOZIkQ+JbdtOjWziF8MsBsmqpTe6JOeQuqEw86qcsiBYm5T8TmBRm0TjBHe46S
 bvfMMCg7ecsxoTyoUl3tfVvWpb1VrhXcS/TsG/J+Huyr5e+W5tiMiCB8AivNHcon8tRc 7A== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3960dyrk3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jun 2021 01:23:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15E5Gn5E027355;
	Mon, 14 Jun 2021 05:23:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma03fra.de.ibm.com with ESMTP id 394mj90ct2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jun 2021 05:23:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15E5Nni113959548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jun 2021 05:23:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CE7752052;
	Mon, 14 Jun 2021 05:23:49 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.33.211])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 47D2D5204E;
	Mon, 14 Jun 2021 05:23:46 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: maddy@linux.vnet.ibm.com, santosh@fossix.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, dan.j.williams@intel.com, ira.weiny@intel.com,
        atrajeev@linux.vnet.ibm.com, tglx@linutronix.de, kjain@linux.ibm.com,
        rnsastry@linux.ibm.com
Subject: [PATCH v2 4/4] powerpc/papr_scm: Document papr_scm sysfs event format entries
Date: Mon, 14 Jun 2021 10:53:26 +0530
Message-Id: <20210614052326.285710-5-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614052326.285710-1-kjain@linux.ibm.com>
References: <20210614052326.285710-1-kjain@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7FwRtp6goBst1m_1bOMdxu71PcUoKtSf
X-Proofpoint-ORIG-GUID: 7FwRtp6goBst1m_1bOMdxu71PcUoKtSf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-13_11:2021-06-11,2021-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140037

Details is added for the event, cpumask and format attributes
in the ABI documentation.

Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
 Documentation/ABI/testing/sysfs-bus-papr-pmem | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentation/ABI/testing/sysfs-bus-papr-pmem
index 92e2db0e2d3d..be91de341454 100644
--- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
+++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
@@ -59,3 +59,34 @@ Description:
 		* "CchRHCnt" : Cache Read Hit Count
 		* "CchWHCnt" : Cache Write Hit Count
 		* "FastWCnt" : Fast Write Count
+
+What:		/sys/devices/nmemX/format
+Date:		June 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
+Description:	(RO) Attribute group to describe the magic bits
+                that go into perf_event_attr.config for a particular pmu.
+                (See ABI/testing/sysfs-bus-event_source-devices-format).
+
+                Each attribute under this group defines a bit range of the
+                perf_event_attr.config. Supported attribute is listed
+                below::
+
+		    event  = "config:0-4"  - event ID
+
+		For example::
+		    noopstat = "event=0x1"
+
+What:		/sys/devices/nmemX/events
+Date:		June 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
+Description:    (RO) Attribute group to describe performance monitoring
+                events specific to papr-scm. Each attribute in this group describes
+                a single performance monitoring event supported by this nvdimm pmu.
+                The name of the file is the name of the event.
+                (See ABI/testing/sysfs-bus-event_source-devices-events).
+
+What:		/sys/devices/nmemX/cpumask
+Date:		June 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
+Description:	(RO) This sysfs file exposes the cpumask which is designated to make
+                HCALLs to retrieve nvdimm pmu event counter data.
-- 
2.27.0


