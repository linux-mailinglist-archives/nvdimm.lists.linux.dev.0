Return-Path: <nvdimm+bounces-3143-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8144C477F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 25 Feb 2022 15:31:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 030D83E1030
	for <lists+linux-nvdimm@lfdr.de>; Fri, 25 Feb 2022 14:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B3C23B3;
	Fri, 25 Feb 2022 14:31:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4295323AF
	for <nvdimm@lists.linux.dev>; Fri, 25 Feb 2022 14:31:21 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PEDpAJ012271;
	Fri, 25 Feb 2022 14:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bsTCRDz94aX22w3yT1v7xWJjSPm0uJKUhYVBcwAO/1Q=;
 b=X7JVvWB+58VvdS/iHjUC1TDOWXMmqAAjeZkVNaCyQXs6XUGj4+Lk03wuWUHl6L/f8ELT
 CSjNWQaa8PTUrZiKoNxArXUudU16znnlnr9IRE+tHCgK+YAe7xq1367MHz12hqjcWXWY
 nm/KFIMwOIDPPsExgh6xRxCcaW7++9V6//tYW+hc4ntGqcSkkcLyomRTaLGsynSIbyfb
 2F2cvaJoIIPMJBZAKizCsuYD24+FiTix/nj4GHw1Y5sTrUbeVgh1u+WWOnfDMzeym+73
 9vUrs+YK9ymLmqjnYWcMQpimQMl+K0a3R/m2h7FwxE+/oKfdufEjjmtIiM8uHjFxaZpd vg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3edtv9a7mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Feb 2022 14:31:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PERw0w009873;
	Fri, 25 Feb 2022 14:31:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3ear69s884-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Feb 2022 14:31:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PEV6rF46531068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Feb 2022 14:31:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44B904C04A;
	Fri, 25 Feb 2022 14:31:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2FF74C04E;
	Fri, 25 Feb 2022 14:31:01 +0000 (GMT)
Received: from li-e8dccbcc-2adc-11b2-a85c-bc1f33b9b810.ibm.com.com (unknown [9.43.81.177])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 25 Feb 2022 14:31:01 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: santosh@fossix.org, maddy@linux.ibm.com, rnsastry@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        vaibhav@linux.ibm.com, tglx@linutronix.de, kjain@linux.ibm.com
Subject: [PATCH v7 4/4] docs: ABI: sysfs-bus-nvdimm: Document sysfs event format entries for nvdimm pmu
Date: Fri, 25 Feb 2022 20:00:24 +0530
Message-Id: <20220225143024.47947-5-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220225143024.47947-1-kjain@linux.ibm.com>
References: <20220225143024.47947-1-kjain@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d5hfIPl5fcofwnwEs1zRPhHf10pY4vmE
X-Proofpoint-GUID: d5hfIPl5fcofwnwEs1zRPhHf10pY4vmE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_08,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202250084

Details are added for the event, cpumask and format attributes
in the ABI documentation.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
Changelog:
v6 -> v7
- Add Acked-by and Tested-by tag from Peter Zijlstra
  and Nageswara R Sastry.

 Documentation/ABI/testing/sysfs-bus-nvdimm | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
index bff84a16812a..1c1f5acbf53d 100644
--- a/Documentation/ABI/testing/sysfs-bus-nvdimm
+++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
@@ -6,3 +6,38 @@ Description:
 
 The libnvdimm sub-system implements a common sysfs interface for
 platform nvdimm resources. See Documentation/driver-api/nvdimm/.
+
+What:           /sys/bus/event_source/devices/nmemX/format
+Date:           February 2022
+KernelVersion:  5.18
+Contact:        Kajol Jain <kjain@linux.ibm.com>
+Description:	(RO) Attribute group to describe the magic bits
+		that go into perf_event_attr.config for a particular pmu.
+		(See ABI/testing/sysfs-bus-event_source-devices-format).
+
+		Each attribute under this group defines a bit range of the
+		perf_event_attr.config. Supported attribute is listed
+		below::
+		  event  = "config:0-4"  - event ID
+
+		For example::
+			ctl_res_cnt = "event=0x1"
+
+What:           /sys/bus/event_source/devices/nmemX/events
+Date:           February 2022
+KernelVersion:  5.18
+Contact:        Kajol Jain <kjain@linux.ibm.com>
+Description:	(RO) Attribute group to describe performance monitoring events
+                for the nvdimm memory device. Each attribute in this group
+                describes a single performance monitoring event supported by
+                this nvdimm pmu.  The name of the file is the name of the event.
+                (See ABI/testing/sysfs-bus-event_source-devices-events). A
+                listing of the events supported by a given nvdimm provider type
+                can be found in Documentation/driver-api/nvdimm/$provider.
+
+What:          /sys/bus/event_source/devices/nmemX/cpumask
+Date:          February 2022
+KernelVersion:  5.18
+Contact:        Kajol Jain <kjain@linux.ibm.com>
+Description:	(RO) This sysfs file exposes the cpumask which is designated to
+		to retrieve nvdimm pmu event counter data.
-- 
2.31.1


