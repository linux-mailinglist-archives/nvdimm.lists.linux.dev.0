Return-Path: <nvdimm+bounces-3709-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1067A50E942
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Apr 2022 21:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6ADA280C3D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Apr 2022 19:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB1533DB;
	Mon, 25 Apr 2022 19:13:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C944C29B4
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 19:13:56 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHrw3A019569;
	Mon, 25 Apr 2022 19:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Of6frm+KRe3P3zNITXS63JaWyfE/TIzooDMkcEqUj8c=;
 b=h/+QyHQSxGxb9NLCThwqE21ld8o3AHU+QX5tdZI2ymr7s4RhHrSfgNkwMtXHhar4Y1YP
 9BMI41CPwFFRypTpsLwq/aLjRWJZmXSqYD1BGyLNiIsqbRaylV5WS4bQ9GXZ7bPbiXU/
 4hKSb54uCC3eOS1oCJSrSi0DFhc1BKQryEeh6C9GY9pMVSw/28ZricMYO3htQT+SpKZr
 1J9zUzrd5Kw59KPejLCMvOxeElVl/dWwmPbi7YGS3xG08OLJbCy348IwXXllgG915s77
 YOjt7UOcolQAVhMwhiKo6dVojLprINwEOsUc+X2HNukFfEWno+OKEWnz9qzK1Twm+qie Iw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fnun4gwu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 19:13:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PJAbA8032735;
	Mon, 25 Apr 2022 19:13:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3fm938ttcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 19:13:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PJE1N544499366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Apr 2022 19:14:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1EE65204F;
	Mon, 25 Apr 2022 19:13:48 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.7.86])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4C37552050;
	Mon, 25 Apr 2022 19:13:46 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v2 2/2] ndctl/namespace:Implement  write-infoblock for sector mode namespaces
Date: Tue, 26 Apr 2022 00:43:29 +0530
Message-Id: <20220425191329.59213-3-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425191329.59213-1-tsahu@linux.ibm.com>
References: <20220425191329.59213-1-tsahu@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4OA9H3ycWlAxs_CFIE7i2FA7sxwAMlUI
X-Proofpoint-GUID: 4OA9H3ycWlAxs_CFIE7i2FA7sxwAMlUI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204250085

Following to the previous patch in this series,
once the namespace info has been collected in ns_info,
while writing to the infoblock for sector mode, it can be
written with original infoblock values except the ones that
have been provided by parameter arguments to write-infoblock command.

Currently, this patch allows only uuid and parent_uuid to be
changed, In future support for other values can be implemented easily by adding condition inside write_btt_sb function, which has been created to write BTT sector mode specific namespace.

$ ./ndctl read-infoblock namespace0.0 -j
[
  {
    "dev":"namespace0.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"7296ebd6-7039-4d02-9ed9-ac5f351ff0e4",
    "parent_uuid":"46850d31-8fb5-4492-b630-9f3cd7b77500",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":8380160,
    "internal_lbasize":4096,
    "internal_nlba":8380416,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":34326196224,
    "logoff":34359717888,
    "info2off":34359734272
  }
]
read 1 infoblock

$ ./ndctl write-infoblock namespace0.0 \
>	--uuid "d0b19883-0874-4847-8c71-71549590949c"
wrote 1 infoblock

$ ./ndctl read-infoblock namespace0.0 -j
[
  {
    "dev":"namespace0.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"d0b19883-0874-4847-8c71-71549590949c",
    "parent_uuid":"46850d31-8fb5-4492-b630-9f3cd7b77500",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":8380160,
    "internal_lbasize":4096,
    "internal_nlba":8380416,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":34326196224,
    "logoff":34359717888,
    "info2off":34359734272
  }
]
read 1 infoblock

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
---
 ndctl/namespace.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 028c517..fe26202 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -253,6 +253,7 @@ static int set_defaults(enum device_action action)
 			break;
 		case NDCTL_NS_MODE_FSDAX:
 		case NDCTL_NS_MODE_DEVDAX:
+		case NDCTL_NS_MODE_SECTOR:
 			break;
 		default:
 			if (action == ACTION_WRITE_INFOBLOCK) {
@@ -2014,6 +2015,48 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	return 0;
 }
 
+static int write_btt_sb(const int fd, unsigned long long size, struct ns_info *ns_info)
+{
+	int rc = 0;
+	uuid_t uuid, parent_uuid;
+
+	// updating the original values which are asked to change,
+	// rest will be unchanged
+	if (param.uuid) {
+		rc = uuid_parse(param.uuid, uuid);
+		if (rc) {
+			error("Failed to parse UUID");
+			return rc;
+		}
+		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->uuid,
+				uuid, sizeof(uuid_t));
+	}
+	if (param.parent_uuid) {
+		rc = uuid_parse(param.parent_uuid, parent_uuid);
+		if (rc) {
+			error("Failed to parse UUID");
+			return rc;
+		}
+		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->parent_uuid,
+				parent_uuid, sizeof(uuid_t));
+	}
+
+	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
+			       ns_info->offset) < 0) {
+		pr_verbose("Unable to write the info block: %s\n",
+				strerror(errno));
+		rc = -errno;
+	}
+
+	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
+				size - sizeof(struct btt_sb)) < 0) {
+		pr_verbose("Unable to write the info block: %s\n",
+			strerror(errno));
+		rc = -errno;
+	}
+	return rc;
+}
+
 static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 {
 	unsigned long long size = parse_size64(param.size);
@@ -2061,6 +2104,14 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 	case NDCTL_NS_MODE_DEVDAX:
 		rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
 		break;
+	case NDCTL_NS_MODE_SECTOR:
+		if (ns_info->mode == NDCTL_NS_MODE_SECTOR)
+			rc = write_btt_sb(fd, size, ns_info);
+		else {
+			pr_verbose("Non-sector mode namespaces can't be converted to sector mode namespaces");
+			rc = -EPERM;
+		}
+		break;
 	case NDCTL_NS_MODE_UNKNOWN:
 		switch (ns_info->mode) {
 		case NDCTL_NS_MODE_FSDAX:
@@ -2069,6 +2120,9 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 		case NDCTL_NS_MODE_DEVDAX:
 			rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
 			break;
+		case NDCTL_NS_MODE_SECTOR:
+			rc = write_btt_sb(fd, size, ns_info);
+			break;
 		default:
 			rc = -EINVAL;
 			break;
-- 
2.35.1


