Return-Path: <nvdimm+bounces-1691-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id EABA943793A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 22 Oct 2021 16:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4EA623E1185
	for <lists+linux-nvdimm@lfdr.de>; Fri, 22 Oct 2021 14:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A46E2CA5;
	Fri, 22 Oct 2021 14:47:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91362C8B
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 14:47:32 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MCXcXp007034;
	Fri, 22 Oct 2021 10:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=QxgIO95lQ3S0i1bOguvdw06HV6s8Xm/5ZpnENOHKZDg=;
 b=TdmBFWrLesKEn2ywBau20+YIg1hlpeGUYg78dvXvPQBA+RdCFA+lqY4CWMjjRhqelOpB
 tIu5fniFxpES7jt/gTIdg+HFglXh0mp0p2kLwtYotB90kQGyVo3feKOmyUBDY2QcJTr6
 4So8DPgiobp/WwQlkPGpH6i7mvSFZHbkIXMJjslu7qw8pzR8wRAvOfN+t/Cq1ogu4mKG
 X/rIMg+1Bs+UVgqugEtcUCYuVLlGbA6sqx3VfsDe55PEyql6MaYEemeFeaLc9TeLQ4eg
 T/mwUYwslYx4WDeKJbsXZY1jFFHcScUritAjVB7Vq/CifeEiUc/y27KKHpsjHQJ1tYHj XQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3buwdetp5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 10:47:24 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MEhnsa023330;
	Fri, 22 Oct 2021 14:47:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma05fra.de.ibm.com with ESMTP id 3bqpcanxbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 14:47:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MElJOL53281134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 14:47:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F3D7A4040;
	Fri, 22 Oct 2021 14:47:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E184A4051;
	Fri, 22 Oct 2021 14:47:18 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 22 Oct 2021 14:47:17 +0000 (GMT)
Subject: [REPOST PATCH v3] libndctl: Update nvdimm flags in ndctl_cmd_submit()
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 09:47:17 -0500
Message-ID: 
 <163491400532.1639819.11570987846001897684.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p_N6pqENcKoJ2rHNNmpgrGir8cGuV9Px
X-Proofpoint-ORIG-GUID: p_N6pqENcKoJ2rHNNmpgrGir8cGuV9Px
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_04,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220083

From: Vaibhav Jain <vaibhav@linux.ibm.com>

Presently after performing an inject-smart the nvdimm flags reported are
out of date as shown below where no 'smart_notify' or 'flush_fail' flags
were reported even though they are set after injecting the smart error:

$ sudo inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]
$ sudo cat /sys/class/nd/ndctl0/device/nmem0/papr/flags
flush_fail smart_notify

This happens because nvdimm flags are only parsed once during its probe
and not refreshed even after a inject-smart operation makes them out of
date. To fix this the patch forces an update of nvdimm flags via newly
introduced ndctl_refresh_dimm_flags() thats called successfully submitting
a 'struct ndctl_cmd' in ndctl_cmd_submit(). This ensures that correct
nvdimm flags are reported after an interaction with the kernel module which
may trigger a change nvdimm-flags. With this implemented correct nvdimm
flags are reported after a inject-smart operation:

$ sudo ndctl inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "flag_failed_flush":true,
    "flag_smart_event":true,
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]

The patch refactors populate_dimm_attributes() to move the nvdimm flags
parsing code to the newly introduced ndctl_refresh_dimm_flags()
export. Since reading nvdimm flags requires constructing path using
'bus_prefix' which is only available during add_dimm(), the patch
introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
value. During ndctl_refresh_dimm_flags() the cached bus_prefix is used to
read the contents of the nvdimm flag file and pass it on to the appropriate
flag parsing function. Finally ndctl_refresh_dimm_flags() is invoked at the
end of ndctl_cmd_submit() if nd-command submission succeeds.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
Changelog:

Since v2:
Link: https://lore.kernel.org/nvdimm/20210716072104.11808-1-vaibhav@linux.ibm.com
* Fixed an issue of "nvdimm_test" cmd_family not being set in add_papr_dimm(). [Shiva]
* Fixed an issue of "health_eventfd" not being populated correctly in
populate_dimm_attributes. [Shiva]
* Check if the 'cmd' is dimm specific in ndctl_cmd_submit() and only then call
ndctl_refresh_dimm_flags() [Shiva]

Since v1:
Link: https://lore.kernel.org/nvdimm/20210713202523.190113-1-vaibhav@linux.ibm.com
* Remove the export of ndctl_refresh_dimm_flags().
* Remove the call to ndctl_refresh_dimm_flags() from dimm_inject_smart().
* Add call to ndctl_refresh_dimm_flags() at end of ndctl_cmd_submit().

 ndctl/lib/libndctl.c |   52 +++++++++++++++++++++++++++++++++++++-------------
 ndctl/lib/private.h  |    1 +
 ndctl/libndctl.h     |    1 +
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index bb0ea094..4a7c2e5f 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -588,6 +588,7 @@ static void free_dimm(struct ndctl_dimm *dimm)
 	free(dimm->unique_id);
 	free(dimm->dimm_buf);
 	free(dimm->dimm_path);
+	free(dimm->bus_prefix);
 	if (dimm->module)
 		kmod_module_unref(dimm->module);
 	if (dimm->health_eventfd > -1)
@@ -1650,14 +1651,34 @@ static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
 static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
 static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
 
+void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = dimm->bus->ctx;
+	char *path = dimm->dimm_buf;
+	char buf[SYSFS_ATTR_SIZE];
+
+	/* Construct path to dimm flags sysfs file */
+	sprintf(path, "%s/%s/flags", dimm->dimm_path, dimm->bus_prefix);
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return;
+
+	/* Reset the flags */
+	dimm->flags.flags = 0;
+	if (ndctl_bus_has_nfit(dimm->bus))
+		parse_nfit_mem_flags(dimm, buf);
+	else if (ndctl_bus_is_papr_scm(dimm->bus))
+		parse_papr_flags(dimm, buf);
+}
+
 static int populate_dimm_attributes(struct ndctl_dimm *dimm,
-				    const char *dimm_base,
-				    const char *bus_prefix)
+				    const char *dimm_base)
 {
 	int i, rc = -1;
 	char buf[SYSFS_ATTR_SIZE];
 	struct ndctl_ctx *ctx = dimm->bus->ctx;
 	char *path = calloc(1, strlen(dimm_base) + 100);
+	const char *bus_prefix = dimm->bus_prefix;
 
 	if (!path)
 		return -ENOMEM;
@@ -1741,16 +1762,10 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
 	}
 
 	sprintf(path, "%s/%s/flags", dimm_base, bus_prefix);
-	if (sysfs_read_attr(ctx, path, buf) == 0) {
-		if (ndctl_bus_has_nfit(dimm->bus))
-			parse_nfit_mem_flags(dimm, buf);
-		else if (ndctl_bus_is_papr_scm(dimm->bus)) {
-			dimm->cmd_family = NVDIMM_FAMILY_PAPR;
-			parse_papr_flags(dimm, buf);
-		}
-	}
-
 	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
+
+	ndctl_refresh_dimm_flags(dimm);
+
 	rc = 0;
  err_read:
 
@@ -1806,8 +1821,9 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
 
 		rc = 0;
 	} else if (strcmp(buf, "nvdimm_test") == 0) {
+		dimm->cmd_family = NVDIMM_FAMILY_PAPR;
 		/* probe via common populate_dimm_attributes() */
-		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
+		rc = populate_dimm_attributes(dimm, dimm_base);
 	}
 out:
 	free(path);
@@ -1904,9 +1920,13 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->formats = formats;
 	/* Check if the given dimm supports nfit */
 	if (ndctl_bus_has_nfit(bus)) {
-		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
+		dimm->bus_prefix = strdup("nfit");
+		rc = dimm->bus_prefix ?
+			populate_dimm_attributes(dimm, dimm_base) : -ENOMEM;
 	} else if (ndctl_bus_has_of_node(bus)) {
-		rc = add_papr_dimm(dimm, dimm_base);
+		dimm->bus_prefix = strdup("papr");
+		rc = dimm->bus_prefix ?
+			add_papr_dimm(dimm, dimm_base) : -ENOMEM;
 	}
 
 	if (rc == -ENODEV) {
@@ -3486,6 +3506,10 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
 		rc = -ENXIO;
 	}
 	close(fd);
+
+	/* update dimm-flags if command submitted successfully */
+	if (!rc && cmd->dimm)
+		ndctl_refresh_dimm_flags(cmd->dimm);
  out:
 	cmd->status = rc;
 	return rc;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 8f4510e5..a4b920ca 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -75,6 +75,7 @@ struct ndctl_dimm {
 	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
+	char *bus_prefix;
 	int health_eventfd;
 	int buf_len;
 	int id;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 87d07b74..cdadd5fd 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -214,6 +214,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
 int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
+void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,



