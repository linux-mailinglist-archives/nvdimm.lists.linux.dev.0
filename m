Return-Path: <nvdimm+bounces-1006-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 4813C3F625D
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Aug 2021 18:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 564241C1046
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Aug 2021 16:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86643FEC;
	Tue, 24 Aug 2021 16:08:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2B53FCE
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:08:29 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="215501751"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="215501751"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="425514782"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:41 -0700
Subject: [PATCH v3 03/28] libnvdimm/labels: Introduce label setter helpers
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:05:41 -0700
Message-ID: <162982114123.1124374.17153270107594686116.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for LIBNVDIMM to manage labels on CXL devices deploy
helpers that abstract the label type from the implementation. The CXL
label format is mostly similar to the EFI label format with concepts /
fields added, like dynamic region creation and label type guids, and
other concepts removed like BLK-mode and interleave-set-cookie ids.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c          |   61 ++++++++++++++++------------------
 drivers/nvdimm/namespace_devs.c |    2 +
 drivers/nvdimm/nd.h             |   69 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 33 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index b6d845cfb70e..b40a4eda1d89 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -358,9 +358,9 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
 		u64 sum, sum_save;
 
 		sum_save = nsl_get_checksum(ndd, nd_label);
-		nd_label->checksum = __cpu_to_le64(0);
+		nsl_set_checksum(ndd, nd_label, 0);
 		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
-		nd_label->checksum = __cpu_to_le64(sum_save);
+		nsl_set_checksum(ndd, nd_label, sum_save);
 		if (sum != sum_save) {
 			dev_dbg(ndd->dev, "fail checksum. slot: %d expect: %#llx\n",
 				slot, sum);
@@ -797,16 +797,15 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nd_label = to_label(ndd, slot);
 	memset(nd_label, 0, sizeof_namespace_label(ndd));
 	memcpy(nd_label->uuid, nspm->uuid, NSLABEL_UUID_LEN);
-	if (nspm->alt_name)
-		memcpy(nd_label->name, nspm->alt_name, NSLABEL_NAME_LEN);
-	nd_label->flags = __cpu_to_le32(flags);
-	nd_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
-	nd_label->position = __cpu_to_le16(pos);
-	nd_label->isetcookie = __cpu_to_le64(cookie);
-	nd_label->rawsize = __cpu_to_le64(resource_size(res));
-	nd_label->lbasize = __cpu_to_le64(nspm->lbasize);
-	nd_label->dpa = __cpu_to_le64(res->start);
-	nd_label->slot = __cpu_to_le32(slot);
+	nsl_set_name(ndd, nd_label, nspm->alt_name);
+	nsl_set_flags(ndd, nd_label, flags);
+	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
+	nsl_set_position(ndd, nd_label, pos);
+	nsl_set_isetcookie(ndd, nd_label, cookie);
+	nsl_set_rawsize(ndd, nd_label, resource_size(res));
+	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
+	nsl_set_dpa(ndd, nd_label, res->start);
+	nsl_set_slot(ndd, nd_label, slot);
 	if (namespace_label_has(ndd, type_guid))
 		guid_copy(&nd_label->type_guid, &nd_set->type_guid);
 	if (namespace_label_has(ndd, abstraction_guid))
@@ -816,9 +815,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	if (namespace_label_has(ndd, checksum)) {
 		u64 sum;
 
-		nd_label->checksum = __cpu_to_le64(0);
+		nsl_set_checksum(ndd, nd_label, 0);
 		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
-		nd_label->checksum = __cpu_to_le64(sum);
+		nsl_set_checksum(ndd, nd_label, sum);
 	}
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
 
@@ -1017,10 +1016,8 @@ static int __blk_label_update(struct nd_region *nd_region,
 		nd_label = to_label(ndd, slot);
 		memset(nd_label, 0, sizeof_namespace_label(ndd));
 		memcpy(nd_label->uuid, nsblk->uuid, NSLABEL_UUID_LEN);
-		if (nsblk->alt_name)
-			memcpy(nd_label->name, nsblk->alt_name,
-					NSLABEL_NAME_LEN);
-		nd_label->flags = __cpu_to_le32(NSLABEL_FLAG_LOCAL);
+		nsl_set_name(ndd, nd_label, nsblk->alt_name);
+		nsl_set_flags(ndd, nd_label, NSLABEL_FLAG_LOCAL);
 
 		/*
 		 * Use the presence of the type_guid as a flag to
@@ -1029,23 +1026,23 @@ static int __blk_label_update(struct nd_region *nd_region,
 		 */
 		if (namespace_label_has(ndd, type_guid)) {
 			if (i == min_dpa_idx) {
-				nd_label->nlabel = __cpu_to_le16(nsblk->num_resources);
-				nd_label->position = __cpu_to_le16(0);
+				nsl_set_nlabel(ndd, nd_label, nsblk->num_resources);
+				nsl_set_position(ndd, nd_label, 0);
 			} else {
-				nd_label->nlabel = __cpu_to_le16(0xffff);
-				nd_label->position = __cpu_to_le16(0xffff);
+				nsl_set_nlabel(ndd, nd_label, 0xffff);
+				nsl_set_position(ndd, nd_label, 0xffff);
 			}
-			nd_label->isetcookie = __cpu_to_le64(nd_set->cookie2);
+			nsl_set_isetcookie(ndd, nd_label, nd_set->cookie2);
 		} else {
-			nd_label->nlabel = __cpu_to_le16(0); /* N/A */
-			nd_label->position = __cpu_to_le16(0); /* N/A */
-			nd_label->isetcookie = __cpu_to_le64(0); /* N/A */
+			nsl_set_nlabel(ndd, nd_label, 0); /* N/A */
+			nsl_set_position(ndd, nd_label, 0); /* N/A */
+			nsl_set_isetcookie(ndd, nd_label, 0); /* N/A */
 		}
 
-		nd_label->dpa = __cpu_to_le64(res->start);
-		nd_label->rawsize = __cpu_to_le64(resource_size(res));
-		nd_label->lbasize = __cpu_to_le64(nsblk->lbasize);
-		nd_label->slot = __cpu_to_le32(slot);
+		nsl_set_dpa(ndd, nd_label, res->start);
+		nsl_set_rawsize(ndd, nd_label, resource_size(res));
+		nsl_set_lbasize(ndd, nd_label, nsblk->lbasize);
+		nsl_set_slot(ndd, nd_label, slot);
 		if (namespace_label_has(ndd, type_guid))
 			guid_copy(&nd_label->type_guid, &nd_set->type_guid);
 		if (namespace_label_has(ndd, abstraction_guid))
@@ -1056,10 +1053,10 @@ static int __blk_label_update(struct nd_region *nd_region,
 		if (namespace_label_has(ndd, checksum)) {
 			u64 sum;
 
-			nd_label->checksum = __cpu_to_le64(0);
+			nsl_set_checksum(ndd, nd_label, 0);
 			sum = nd_fletcher64(nd_label,
 					sizeof_namespace_label(ndd), 1);
-			nd_label->checksum = __cpu_to_le64(sum);
+			nsl_set_checksum(ndd, nd_label, sum);
 		}
 
 		/* update label */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index f33245c27cc4..fb9e080ce654 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2569,7 +2569,7 @@ static int init_active_labels(struct nd_region *nd_region)
 				u32 flags = nsl_get_flags(ndd, label);
 
 				flags &= ~NSLABEL_FLAG_LOCAL;
-				label->flags = __cpu_to_le32(flags);
+				nsl_set_flags(ndd, label, flags);
 			}
 			label_ent->label = label;
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b3feaf3699f7..9bf9cd4a9a2d 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -47,42 +47,89 @@ static inline u8 *nsl_get_name(struct nvdimm_drvdata *ndd,
 	return memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
 }
 
+static inline u8 *nsl_set_name(struct nvdimm_drvdata *ndd,
+			       struct nd_namespace_label *nd_label, u8 *name)
+{
+	if (!name)
+		return NULL;
+	return memcpy(nd_label->name, name, NSLABEL_NAME_LEN);
+}
+
 static inline u32 nsl_get_slot(struct nvdimm_drvdata *ndd,
 			       struct nd_namespace_label *nd_label)
 {
 	return __le32_to_cpu(nd_label->slot);
 }
 
+static inline void nsl_set_slot(struct nvdimm_drvdata *ndd,
+				struct nd_namespace_label *nd_label, u32 slot)
+{
+	nd_label->slot = __cpu_to_le32(slot);
+}
+
 static inline u64 nsl_get_checksum(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label)
 {
 	return __le64_to_cpu(nd_label->checksum);
 }
 
+static inline void nsl_set_checksum(struct nvdimm_drvdata *ndd,
+				    struct nd_namespace_label *nd_label,
+				    u64 checksum)
+{
+	nd_label->checksum = __cpu_to_le64(checksum);
+}
+
 static inline u32 nsl_get_flags(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label)
 {
 	return __le32_to_cpu(nd_label->flags);
 }
 
+static inline void nsl_set_flags(struct nvdimm_drvdata *ndd,
+				 struct nd_namespace_label *nd_label, u32 flags)
+{
+	nd_label->flags = __cpu_to_le32(flags);
+}
+
 static inline u64 nsl_get_dpa(struct nvdimm_drvdata *ndd,
 			      struct nd_namespace_label *nd_label)
 {
 	return __le64_to_cpu(nd_label->dpa);
 }
 
+static inline void nsl_set_dpa(struct nvdimm_drvdata *ndd,
+			       struct nd_namespace_label *nd_label, u64 dpa)
+{
+	nd_label->dpa = __cpu_to_le64(dpa);
+}
+
 static inline u64 nsl_get_rawsize(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label)
 {
 	return __le64_to_cpu(nd_label->rawsize);
 }
 
+static inline void nsl_set_rawsize(struct nvdimm_drvdata *ndd,
+				   struct nd_namespace_label *nd_label,
+				   u64 rawsize)
+{
+	nd_label->rawsize = __cpu_to_le64(rawsize);
+}
+
 static inline u64 nsl_get_isetcookie(struct nvdimm_drvdata *ndd,
 				     struct nd_namespace_label *nd_label)
 {
 	return __le64_to_cpu(nd_label->isetcookie);
 }
 
+static inline void nsl_set_isetcookie(struct nvdimm_drvdata *ndd,
+				      struct nd_namespace_label *nd_label,
+				      u64 isetcookie)
+{
+	nd_label->isetcookie = __cpu_to_le64(isetcookie);
+}
+
 static inline bool nsl_validate_isetcookie(struct nvdimm_drvdata *ndd,
 					   struct nd_namespace_label *nd_label,
 					   u64 cookie)
@@ -96,18 +143,40 @@ static inline u16 nsl_get_position(struct nvdimm_drvdata *ndd,
 	return __le16_to_cpu(nd_label->position);
 }
 
+static inline void nsl_set_position(struct nvdimm_drvdata *ndd,
+				    struct nd_namespace_label *nd_label,
+				    u16 position)
+{
+	nd_label->position = __cpu_to_le16(position);
+}
+
+
 static inline u16 nsl_get_nlabel(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label)
 {
 	return __le16_to_cpu(nd_label->nlabel);
 }
 
+static inline void nsl_set_nlabel(struct nvdimm_drvdata *ndd,
+				  struct nd_namespace_label *nd_label,
+				  u16 nlabel)
+{
+	nd_label->nlabel = __cpu_to_le16(nlabel);
+}
+
 static inline u64 nsl_get_lbasize(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label)
 {
 	return __le64_to_cpu(nd_label->lbasize);
 }
 
+static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
+				   struct nd_namespace_label *nd_label,
+				   u64 lbasize)
+{
+	nd_label->lbasize = __cpu_to_le64(lbasize);
+}
+
 struct nd_region_data {
 	int ns_count;
 	int ns_active;


