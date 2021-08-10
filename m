Return-Path: <nvdimm+bounces-616-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id C41C73D6F63
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jul 2021 08:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0F9353E0E4B
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jul 2021 06:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB0B2F80;
	Tue, 27 Jul 2021 06:24:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8431670
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 06:24:27 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R5e9ef013296;
	Tue, 27 Jul 2021 01:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=qP8qjsBX0kDV3Z3Gdyq1zi1RVT7v+6SgYK5rps1ogJo=;
 b=j1AkGfP8vpTg6b2enKjxj2PjLrbgipmS10EZMfHBbBX97d1cqRdWz6uVKXVDCzX2Zd62
 cRE1og2C1rSnHb/zdIM/o4WtYBEVwB7LaxYnC9NEdVdxCZQ3eUv9PsGmXmmEtXpaKNBF
 ij05D5P6PeVDyteiip5uu/qGFAUvLySyW5vxZHmifQF79ECBzOHHn8GPTAdG4XPcfCqy
 PpWCylzhriSrYB1aNb8sndZ+qC1XlbvZiyiSnYOIjbqgwRk8HCFEzTEWohcl04lpP/Hn
 cVNpHzS25npGNIfmBQ3RCUEJ9tytShdOGgekALSOHOzq1zy6x1DRThIByGQgxdCv5Ne7 WA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a2btw8pyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 01:50:49 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R5h2PU009219;
	Tue, 27 Jul 2021 05:50:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3a235kg6rd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 05:50:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R5m3h933685932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 05:48:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0804B52050;
	Tue, 27 Jul 2021 05:50:43 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A79BB5204F;
	Tue, 27 Jul 2021 05:50:41 +0000 (GMT)
Subject: [PATCH] tests/nvdimm/ndtest: Simulate nvdimm health,
 DSC and smart-inject
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, ellerman@au1.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, aneesh.kumar@linux.ibm.com,
        sbhat@linux.ibm.com, vaibhav@linux.ibm.com, santosh@fossix.org,
        dan.j.williams@intel.com, ira.weiny@intel.com
Date: Tue, 27 Jul 2021 00:50:40 -0500
Message-ID: 
 <162736501859.3933744.5222414342236795914.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: acU7U-2xOTQOHsGmXBvSd5fyjby8cVwW
X-Proofpoint-ORIG-GUID: acU7U-2xOTQOHsGmXBvSd5fyjby8cVwW
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_04:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270031

The 'papr_scm' module and 'papr' implementation in libndctl supports
PDSMs for reporting PAPR NVDIMM health, its dirty-shutdown-count and
injecting smart-error. This patch adds support for those PDSMs in
ndtest module so that PDSM specific paths in libndctl can be exercised.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
The patch depends on the PAPR PDSM smart-inject payload definitions
added with the patch - https://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg191337.html

 tools/testing/nvdimm/test/ndtest.c |  149 ++++++++++++++++++++++++++++++++++++
 tools/testing/nvdimm/test/ndtest.h |    7 ++
 2 files changed, 156 insertions(+)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 00ec2c213061..6622e8adbd11 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -14,6 +14,7 @@
 #include <linux/printk.h>
 #include <linux/seq_buf.h>
 #include <linux/papr_scm.h>
+#include <uapi/linux/papr_pdsm.h>
 
 #include "../watermark.h"
 #include "nfit_test.h"
@@ -49,6 +50,10 @@ static struct ndtest_dimm dimm_group1[] = {
 		.uuid_str = "1e5c75d2-b618-11ea-9aa3-507b9ddc0f72",
 		.physical_id = 0,
 		.num_formats = 2,
+		.flags = PAPR_PMEM_HEALTH_NON_CRITICAL,
+		.extension_flags = PDSM_DIMM_DSC_VALID | PDSM_DIMM_HEALTH_RUN_GAUGE_VALID,
+		.dimm_fuel_gauge = 95,
+		.dimm_dsc = 42,
 	},
 	{
 		.size = DIMM_SIZE,
@@ -56,6 +61,10 @@ static struct ndtest_dimm dimm_group1[] = {
 		.uuid_str = "1c4d43ac-b618-11ea-be80-507b9ddc0f72",
 		.physical_id = 1,
 		.num_formats = 2,
+		.flags = PAPR_PMEM_HEALTH_NON_CRITICAL,
+		.extension_flags = PDSM_DIMM_DSC_VALID | PDSM_DIMM_HEALTH_RUN_GAUGE_VALID,
+		.dimm_fuel_gauge = 95,
+		.dimm_dsc = 42,
 	},
 	{
 		.size = DIMM_SIZE,
@@ -63,6 +72,10 @@ static struct ndtest_dimm dimm_group1[] = {
 		.uuid_str = "a9f17ffc-b618-11ea-b36d-507b9ddc0f72",
 		.physical_id = 2,
 		.num_formats = 2,
+		.flags = PAPR_PMEM_HEALTH_NON_CRITICAL,
+		.extension_flags = PDSM_DIMM_DSC_VALID | PDSM_DIMM_HEALTH_RUN_GAUGE_VALID,
+		.dimm_fuel_gauge = 95,
+		.dimm_dsc = 42,
 	},
 	{
 		.size = DIMM_SIZE,
@@ -70,6 +83,10 @@ static struct ndtest_dimm dimm_group1[] = {
 		.uuid_str = "b6b83b22-b618-11ea-8aae-507b9ddc0f72",
 		.physical_id = 3,
 		.num_formats = 2,
+		.flags = PAPR_PMEM_HEALTH_NON_CRITICAL,
+		.extension_flags = PDSM_DIMM_DSC_VALID | PDSM_DIMM_HEALTH_RUN_GAUGE_VALID,
+		.dimm_fuel_gauge = 95,
+		.dimm_dsc = 42,
 	},
 	{
 		.size = DIMM_SIZE,
@@ -297,6 +314,103 @@ static int ndtest_get_config_size(struct ndtest_dimm *dimm, unsigned int buf_len
 	return 0;
 }
 
+static int ndtest_pdsm_health(struct ndtest_dimm *dimm,
+			union nd_pdsm_payload *payload,
+			unsigned int buf_len)
+{
+	struct nd_papr_pdsm_health *health = &payload->health;
+
+	if (buf_len < sizeof(health))
+		return -EINVAL;
+
+	health->extension_flags = 0;
+	health->dimm_unarmed = !!(dimm->flags & PAPR_PMEM_UNARMED_MASK);
+	health->dimm_bad_shutdown = !!(dimm->flags & PAPR_PMEM_BAD_SHUTDOWN_MASK);
+	health->dimm_bad_restore = !!(dimm->flags & PAPR_PMEM_BAD_RESTORE_MASK);
+	health->dimm_health = PAPR_PDSM_DIMM_HEALTHY;
+
+	if (dimm->flags & PAPR_PMEM_HEALTH_FATAL)
+		health->dimm_health = PAPR_PDSM_DIMM_FATAL;
+	else if (dimm->flags & PAPR_PMEM_HEALTH_CRITICAL)
+		health->dimm_health = PAPR_PDSM_DIMM_CRITICAL;
+	else if (dimm->flags & PAPR_PMEM_HEALTH_UNHEALTHY ||
+		 dimm->flags & PAPR_PMEM_HEALTH_NON_CRITICAL)
+		health->dimm_health = PAPR_PDSM_DIMM_UNHEALTHY;
+
+	health->extension_flags = 0;
+	if (dimm->extension_flags & PDSM_DIMM_HEALTH_RUN_GAUGE_VALID) {
+		health->dimm_fuel_gauge = dimm->dimm_fuel_gauge;
+		health->extension_flags |= PDSM_DIMM_HEALTH_RUN_GAUGE_VALID;
+	}
+	if (dimm->extension_flags & PDSM_DIMM_DSC_VALID) {
+		health->dimm_dsc = dimm->dimm_dsc;
+		health->extension_flags |= PDSM_DIMM_DSC_VALID;
+	}
+
+	return 0;
+}
+
+static void smart_notify(struct ndtest_dimm *dimm)
+{
+	struct device *bus = dimm->dev->parent;
+
+	if (!(dimm->flags & PAPR_PMEM_HEALTH_NON_CRITICAL) ||
+	    (dimm->flags & PAPR_PMEM_BAD_SHUTDOWN_MASK)) {
+		device_lock(bus);
+		/* send smart notification */
+		if (dimm->notify_handle)
+			sysfs_notify_dirent(dimm->notify_handle);
+		device_unlock(bus);
+	}
+}
+
+static int ndtest_pdsm_smart_inject(struct ndtest_dimm *dimm,
+				union nd_pdsm_payload *payload,
+				unsigned int buf_len)
+{
+	struct nd_papr_pdsm_smart_inject *inj = &payload->smart_inject;
+
+	if (buf_len < sizeof(inj))
+		return -EINVAL;
+
+	if (inj->flags & PDSM_SMART_INJECT_HEALTH_FATAL) {
+		if (inj->fatal_enable)
+			dimm->flags |= PAPR_PMEM_HEALTH_FATAL;
+		else
+			dimm->flags &= ~PAPR_PMEM_HEALTH_FATAL;
+	}
+	if (inj->flags & PDSM_SMART_INJECT_BAD_SHUTDOWN) {
+		if (inj->unsafe_shutdown_enable)
+			dimm->flags |= PAPR_PMEM_SHUTDOWN_DIRTY;
+		else
+			dimm->flags &= ~PAPR_PMEM_SHUTDOWN_DIRTY;
+	}
+	smart_notify(dimm);
+
+	return 0;
+}
+
+static int ndtest_dimm_cmd_call(struct ndtest_dimm *dimm, unsigned int buf_len,
+			   void *buf)
+{
+	struct nd_cmd_pkg *call_pkg = buf;
+	unsigned int len = call_pkg->nd_size_in + call_pkg->nd_size_out;
+	struct nd_pkg_pdsm *pdsm = (struct nd_pkg_pdsm *) call_pkg->nd_payload;
+	union nd_pdsm_payload *payload = &(pdsm->payload);
+	unsigned int func = call_pkg->nd_command;
+
+	switch (func) {
+	case PAPR_PDSM_HEALTH:
+		return ndtest_pdsm_health(dimm, payload, len);
+	case PAPR_PDSM_SMART_INJECT:
+		return ndtest_pdsm_smart_inject(dimm, payload, len);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ndtest_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		      struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		      unsigned int buf_len, int *cmd_rc)
@@ -326,6 +440,9 @@ static int ndtest_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	case ND_CMD_SET_CONFIG_DATA:
 		*cmd_rc = ndtest_config_set(dimm, buf_len, buf);
 		break;
+	case ND_CMD_CALL:
+		*cmd_rc = ndtest_dimm_cmd_call(dimm, buf_len, buf);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -615,6 +732,8 @@ static void put_dimms(void *data)
 
 	for (i = 0; i < p->config->dimm_count; i++)
 		if (p->config->dimms[i].dev) {
+			if (p->config->dimms[i].notify_handle)
+				sysfs_put(p->config->dimms[i].notify_handle);
 			device_unregister(p->config->dimms[i].dev);
 			p->config->dimms[i].dev = NULL;
 		}
@@ -827,6 +946,18 @@ static ssize_t flags_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(flags);
 
+#define PAPR_PMEM_DIMM_CMD_MASK				\
+	 ((1U << PAPR_PDSM_HEALTH)			\
+	 | (1U << PAPR_PDSM_SMART_INJECT))
+
+static ssize_t dsm_mask_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%#x\n", PAPR_PMEM_DIMM_CMD_MASK);
+}
+
+static DEVICE_ATTR_RO(dsm_mask);
+
 static struct attribute *ndtest_nvdimm_attributes[] = {
 	&dev_attr_nvdimm_show_handle.attr,
 	&dev_attr_vendor.attr,
@@ -838,6 +969,7 @@ static struct attribute *ndtest_nvdimm_attributes[] = {
 	&dev_attr_format.attr,
 	&dev_attr_format1.attr,
 	&dev_attr_flags.attr,
+	&dev_attr_dsm_mask.attr,
 	NULL,
 };
 
@@ -857,6 +989,7 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
 {
 	struct device *dev = &priv->pdev.dev;
 	unsigned long dimm_flags = dimm->flags;
+	struct kernfs_node *papr_kernfs;
 
 	if (dimm->num_formats > 1) {
 		set_bit(NDD_ALIASING, &dimm_flags);
@@ -883,6 +1016,20 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
 		return -ENOMEM;
 	}
 
+	nd_synchronize();
+
+	papr_kernfs = sysfs_get_dirent(nvdimm_kobj(dimm->nvdimm)->sd, "papr");
+	if (!papr_kernfs) {
+		pr_err("Could not initialize the notifier handle\n");
+		return 0;
+	}
+
+	dimm->notify_handle = sysfs_get_dirent(papr_kernfs, "flags");
+	sysfs_put(papr_kernfs);
+	if (!dimm->notify_handle) {
+		pr_err("Could not initialize the notifier handle\n");
+		return 0;
+	}
 	return 0;
 }
 
@@ -954,6 +1101,8 @@ static int ndtest_bus_register(struct ndtest_priv *p)
 	p->bus_desc.provider_name = NULL;
 	p->bus_desc.attr_groups = ndtest_attribute_groups;
 
+	set_bit(NVDIMM_FAMILY_PAPR, &p->bus_desc.dimm_family_mask);
+
 	p->bus = nvdimm_bus_register(&p->pdev.dev, &p->bus_desc);
 	if (!p->bus) {
 		dev_err(&p->pdev.dev, "Error creating nvdimm bus %pOF\n", p->dn);
diff --git a/tools/testing/nvdimm/test/ndtest.h b/tools/testing/nvdimm/test/ndtest.h
index 8f27ad6f7319..e18b3b006fa2 100644
--- a/tools/testing/nvdimm/test/ndtest.h
+++ b/tools/testing/nvdimm/test/ndtest.h
@@ -49,6 +49,13 @@ struct ndtest_dimm {
 	int id;
 	int fail_cmd_code;
 	u8 no_alias;
+
+	struct kernfs_node *notify_handle;
+
+	/* SMART Health information */
+	u32 extension_flags;
+	u16 dimm_fuel_gauge;
+	u64 dimm_dsc;
 };
 
 struct ndtest_mapping {



