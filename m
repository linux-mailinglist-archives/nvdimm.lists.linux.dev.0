Return-Path: <nvdimm+bounces-5723-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3022568E0FB
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Feb 2023 20:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC900280A91
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Feb 2023 19:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92EA7497;
	Tue,  7 Feb 2023 19:16:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130367480
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797416; x=1707333416;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=aiJCC2VqnMfgVX+iZFOAB+W362IZOXkYLTET8CY2Dd4=;
  b=grp3Iizsp8edLCwzEkhsOPQRRFdGprQCvrE2yRJeZYte5ZwYCNdFSaBi
   XRdeQ27onQau3qxD7RrvQiB3bNSmspYOrwiflEnEeQ2DN8NGsWrwGZUkT
   h4qb8au/U81RE1bqc4xUqUfPia9UFuIY9/nvL+qFdQ4P9e/nIP08suAVk
   Q5W5uDs/ydpSJp6wArpEtVfRy6kLbkUC8F6kMwZn3DzRJ9yUAxo6IQFZJ
   brfytmawFRH6ynzUAOmF3Xz3cGmHcty7TDAAKnBrylIgbt3VkiF4SwaZs
   oUsUxhJjJZ2+sbdKOekq+YmJ25p0qddoUOCSSw6M98ZEJnkOntVtbhXKp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331733993"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331733993"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649811"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649811"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:54 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Feb 2023 12:16:29 -0700
Subject: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=5791;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=aiJCC2VqnMfgVX+iZFOAB+W362IZOXkYLTET8CY2Dd4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi+Z1TfN3r8qzKhcs+bVkm12jDovbb+6HJtUqdW+M
 Hsdc+/fjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEykT5GRYbF109/vjc37j01S
 yA2bInb23MwWrtsCaU6WT57Fhr63VmD4Z/72zGeFijq3Z78nFW6Zw+vce4EtMl77ibz3hSN7+I/
 fYAMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add support in libcxl to create ram regions through a new
cxl_decoder_create_ram_region() API, which works similarly to its pmem
sibling.

Enable ram region creation in cxl-cli, with the only differences from
the pmem flow being:
  1/ Use the above create_ram_region API, and
  2/ Elide setting the UUID, since ram regions don't have one

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-create-region.txt |  3 ++-
 cxl/lib/libcxl.c                        | 22 +++++++++++++++++++---
 cxl/libcxl.h                            |  1 +
 cxl/region.c                            | 32 ++++++++++++++++++++++++++++----
 cxl/lib/libcxl.sym                      |  1 +
 5 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index 286779e..ada0e52 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -80,7 +80,8 @@ include::bus-option.txt[]
 -U::
 --uuid=::
 	Specify a UUID for the new region. This shouldn't usually need to be
-	specified, as one will be generated by default.
+	specified, as one will be generated by default. Only applicable to
+	pmem regions.
 
 -w::
 --ways=::
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 83f628b..c5b9b18 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2234,8 +2234,8 @@ cxl_decoder_get_region(struct cxl_decoder *decoder)
 	return NULL;
 }
 
-CXL_EXPORT struct cxl_region *
-cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
+static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
+						    enum cxl_decoder_mode mode)
 {
 	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
 	char *path = decoder->dev_buf;
@@ -2243,7 +2243,11 @@ cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
 	struct cxl_region *region;
 	int rc;
 
-	sprintf(path, "%s/create_pmem_region", decoder->dev_path);
+	if (mode == CXL_DECODER_MODE_PMEM)
+		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
+	else if (mode == CXL_DECODER_MODE_RAM)
+		sprintf(path, "%s/create_ram_region", decoder->dev_path);
+
 	rc = sysfs_read_attr(ctx, path, buf);
 	if (rc < 0) {
 		err(ctx, "failed to read new region name: %s\n",
@@ -2282,6 +2286,18 @@ cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
 	return region;
 }
 
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
+{
+	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_PMEM);
+}
+
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
+{
+	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index e6cca11..904156c 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -213,6 +213,7 @@ cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder);
 unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
 struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
 					    const char *ident);
 struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
diff --git a/cxl/region.c b/cxl/region.c
index 38aa142..0945a14 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -380,7 +380,22 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		struct json_object *jobj =
 			json_object_array_get_idx(p->memdevs, i);
 		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
-		u64 size = cxl_memdev_get_pmem_size(memdev);
+		u64 size;
+
+		switch(p->mode) {
+		case CXL_DECODER_MODE_RAM:
+			size = cxl_memdev_get_ram_size(memdev);
+			break;
+		case CXL_DECODER_MODE_PMEM:
+			size = cxl_memdev_get_pmem_size(memdev);
+			break;
+		default:
+			/*
+			 * This will 'poison' ep_min_size with a 0, and
+			 * subsequently cause the region creation to fail.
+			 */
+			size = 0;
+		}
 
 		if (!p->ep_min_size)
 			p->ep_min_size = size;
@@ -589,8 +604,15 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 				param.root_decoder);
 			return -ENXIO;
 		}
+	} else if (p->mode == CXL_DECODER_MODE_RAM) {
+		region = cxl_decoder_create_ram_region(p->root_decoder);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
 	} else {
-		log_err(&rl, "region type '%s' not supported yet\n",
+		log_err(&rl, "region type '%s' is not supported\n",
 			param.type);
 		return -EOPNOTSUPP;
 	}
@@ -602,10 +624,12 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		goto out;
 	granularity = rc;
 
-	uuid_generate(uuid);
 	try(cxl_region, set_interleave_granularity, region, granularity);
 	try(cxl_region, set_interleave_ways, region, p->ways);
-	try(cxl_region, set_uuid, region, uuid);
+	if (p->mode == CXL_DECODER_MODE_PMEM) {
+		uuid_generate(uuid);
+		try(cxl_region, set_uuid, region, uuid);
+	}
 	try(cxl_region, set_size, region, size);
 
 	for (i = 0; i < p->ways; i++) {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 9832d09..84f60ad 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -246,4 +246,5 @@ global:
 LIBCXL_5 {
 global:
 	cxl_region_get_mode;
+	cxl_decoder_create_ram_region;
 } LIBCXL_4;

-- 
2.39.1


