Return-Path: <nvdimm+bounces-276-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C4FA3B29DD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 24 Jun 2021 10:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 0BD2C1C0EC2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 24 Jun 2021 08:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FCD2FBF;
	Thu, 24 Jun 2021 08:06:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D722FB6
	for <nvdimm@lists.linux.dev>; Thu, 24 Jun 2021 08:06:51 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O83KFG024921;
	Thu, 24 Jun 2021 04:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=AOnMUfeuSDHxx0zvFVCqfh1sIu81mMK+wG/fR+cIeqQ=;
 b=rIsgBnmdE6ytAwSJpoAzmR4EYBJS6Ci60kF2mMfamNRZI9DI7Tu1mhR2lJ/3Vw4P4wid
 8tZPqWJYfpn6/ooZgIYcNnJIKzHJzetf6NgB/7tVofPiGQ6hmpTZZJ+9yaiFDFDRmcSV
 FAaY56Qtyp8DUd7FFNGCbg10foX/F4ifwCMefDqI0brb2U0PHFHpooIi5Ybvb2a5qPLC
 sy5YB5olTNuR0xi1DEGH2cCjhYs3b0Vm6pzc/oBDtfRfwoJb0Vr/Zr39ZpHF/jK/aF5e
 88lu6zTLkhNVjV8ULTPDCJDWdYGsWzi8+axW6RKG/+dVFcXkfTyFSHFxbjY7KmVSaY2M YA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0b-001b2d01.pphosted.com with ESMTP id 39cp5er7cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jun 2021 04:06:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O7pZ1K027415;
	Thu, 24 Jun 2021 08:06:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma06ams.nl.ibm.com with ESMTP id 3997uhad2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jun 2021 08:06:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O86aTr16843174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jun 2021 08:06:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E51284203F;
	Thu, 24 Jun 2021 08:06:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D69442041;
	Thu, 24 Jun 2021 08:06:33 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.115.192])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Thu, 24 Jun 2021 08:06:32 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Thu, 24 Jun 2021 13:36:32 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linux-nvdimm@lists.01.org, nvdimm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Santosh Sivaraj <santosh@fossix.org>, Ira Weiny <ira.weiny@intel.com>
Subject: [RESEND-PATCH v2] powerpc/papr_scm: Add support for reporting dirty-shutdown-count
Date: Thu, 24 Jun 2021 13:36:21 +0530
Message-Id: <20210624080621.252038-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W9Whd-LHrkJupxE8WEpMHaK8V7LXlTIw
X-Proofpoint-ORIG-GUID: W9Whd-LHrkJupxE8WEpMHaK8V7LXlTIw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-23,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 impostorscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240044

Persistent memory devices like NVDIMMs can loose cached writes in case
something prevents flush on power-fail. Such situations are termed as
dirty shutdown and are exposed to applications as
last-shutdown-state (LSS) flag and a dirty-shutdown-counter(DSC) as
described at [1]. The latter being useful in conditions where multiple
applications want to detect a dirty shutdown event without racing with
one another.

PAPR-NVDIMMs have so far only exposed LSS style flags to indicate a
dirty-shutdown-state. This patch further adds support for DSC via the
"ibm,persistence-failed-count" device tree property of an NVDIMM. This
property is a monotonic increasing 64-bit counter thats an indication
of number of times an NVDIMM has encountered a dirty-shutdown event
causing persistence loss.

Since this value is not expected to change after system-boot hence
papr_scm reads & caches its value during NVDIMM probe and exposes it
as a PAPR sysfs attributed named 'dirty_shutdown' to match the name of
similarly named NFIT sysfs attribute. Also this value is available to
libnvdimm via PAPR_PDSM_HEALTH payload. 'struct nd_papr_pdsm_health'
has been extended to add a new member called 'dimm_dsc' presence of
which is indicated by the newly introduced PDSM_DIMM_DSC_VALID flag.

References:
[1] https://pmem.io/documents/Dirty_Shutdown_Handling-V1.0.pdf

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
Changelog:

Resend:
* Added ack by Aneesh.
* Minor fix to changelog of v2 patch

v2:
* Rebased the patch on latest ppc-next tree
* s/psdm/pdsm/g   [ Santosh ]
---
 arch/powerpc/include/uapi/asm/papr_pdsm.h |  6 +++++
 arch/powerpc/platforms/pseries/papr_scm.c | 30 +++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/powerpc/include/uapi/asm/papr_pdsm.h b/arch/powerpc/include/uapi/asm/papr_pdsm.h
index 50ef95e2f5b1..82488b1e7276 100644
--- a/arch/powerpc/include/uapi/asm/papr_pdsm.h
+++ b/arch/powerpc/include/uapi/asm/papr_pdsm.h
@@ -77,6 +77,9 @@
 /* Indicate that the 'dimm_fuel_gauge' field is valid */
 #define PDSM_DIMM_HEALTH_RUN_GAUGE_VALID 1
 
+/* Indicate that the 'dimm_dsc' field is valid */
+#define PDSM_DIMM_DSC_VALID 2
+
 /*
  * Struct exchanged between kernel & ndctl in for PAPR_PDSM_HEALTH
  * Various flags indicate the health status of the dimm.
@@ -105,6 +108,9 @@ struct nd_papr_pdsm_health {
 
 			/* Extension flag PDSM_DIMM_HEALTH_RUN_GAUGE_VALID */
 			__u16 dimm_fuel_gauge;
+
+			/* Extension flag PDSM_DIMM_DSC_VALID */
+			__u64 dimm_dsc;
 		};
 		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
 	};
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 11e7b90a3360..eb8be0eb6119 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -114,6 +114,9 @@ struct papr_scm_priv {
 	/* Health information for the dimm */
 	u64 health_bitmap;
 
+	/* Holds the last known dirty shutdown counter value */
+	u64 dirty_shutdown_counter;
+
 	/* length of the stat buffer as expected by phyp */
 	size_t stat_buffer_len;
 };
@@ -603,6 +606,16 @@ static int papr_pdsm_fuel_gauge(struct papr_scm_priv *p,
 	return rc;
 }
 
+/* Add the dirty-shutdown-counter value to the pdsm */
+static int papr_pdsm_dsc(struct papr_scm_priv *p,
+			 union nd_pdsm_payload *payload)
+{
+	payload->health.extension_flags |= PDSM_DIMM_DSC_VALID;
+	payload->health.dimm_dsc = p->dirty_shutdown_counter;
+
+	return sizeof(struct nd_papr_pdsm_health);
+}
+
 /* Fetch the DIMM health info and populate it in provided package. */
 static int papr_pdsm_health(struct papr_scm_priv *p,
 			    union nd_pdsm_payload *payload)
@@ -646,6 +659,8 @@ static int papr_pdsm_health(struct papr_scm_priv *p,
 
 	/* Populate the fuel gauge meter in the payload */
 	papr_pdsm_fuel_gauge(p, payload);
+	/* Populate the dirty-shutdown-counter field */
+	papr_pdsm_dsc(p, payload);
 
 	rc = sizeof(struct nd_papr_pdsm_health);
 
@@ -907,6 +922,16 @@ static ssize_t flags_show(struct device *dev,
 }
 DEVICE_ATTR_RO(flags);
 
+static ssize_t dirty_shutdown_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *dimm = to_nvdimm(dev);
+	struct papr_scm_priv *p = nvdimm_provider_data(dimm);
+
+	return sysfs_emit(buf, "%llu\n", p->dirty_shutdown_counter);
+}
+DEVICE_ATTR_RO(dirty_shutdown);
+
 static umode_t papr_nd_attribute_visible(struct kobject *kobj,
 					 struct attribute *attr, int n)
 {
@@ -925,6 +950,7 @@ static umode_t papr_nd_attribute_visible(struct kobject *kobj,
 static struct attribute *papr_nd_attributes[] = {
 	&dev_attr_flags.attr,
 	&dev_attr_perf_stats.attr,
+	&dev_attr_dirty_shutdown.attr,
 	NULL,
 };
 
@@ -1149,6 +1175,10 @@ static int papr_scm_probe(struct platform_device *pdev)
 	p->is_volatile = !of_property_read_bool(dn, "ibm,cache-flush-required");
 	p->hcall_flush_required = of_property_read_bool(dn, "ibm,hcall-flush-required");
 
+	if (of_property_read_u64(dn, "ibm,persistence-failed-count",
+				 &p->dirty_shutdown_counter))
+		p->dirty_shutdown_counter = 0;
+
 	/* We just need to ensure that set cookies are unique across */
 	uuid_parse(uuid_str, (uuid_t *) uuid);
 	/*
-- 
2.31.1


