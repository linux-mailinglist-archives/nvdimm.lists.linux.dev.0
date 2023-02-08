Return-Path: <nvdimm+bounces-5749-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E4B368F882
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Feb 2023 21:01:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A965280BF1
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Feb 2023 20:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FED79CF;
	Wed,  8 Feb 2023 20:00:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8572A7481
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886445; x=1707422445;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=tj30CiWrHmwuRBIF22lg+gB169wt098YpkJ/DZ2p6XY=;
  b=bRHuazGI4H9oFKYcSdKZ2fV1tefA08L3f47H3HfR99xWI8ydh8gxi6T+
   UxaGDPuW+nmANNHfFxJxP1PwlyPvr/H4eKaxd8lsyg0zST+dm4/CqwzJ3
   wQReAnPvPnFGvSmQCh12dj4Jz+xL9PF6xqha8yfJ4/UaLO2TAg4Lwnuq0
   0oUf9oK8xCatch2lBwLwHrfDCGE+L/ZnghpgPYPK2oT4wBW72vD25u6tD
   RzWPrTBf24JoCj4YhUjV+6EW7julMhFPm/7KhCPIMR61KSe5YGjpFLTx9
   YrK0ZejP52qC9gv0nQJk1BNJI6mahpA3p3+uK4PxsEjNZ8XvbQ7wrR1mZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935466"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935466"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174674"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174674"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:43 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 08 Feb 2023 13:00:31 -0700
Subject: [PATCH ndctl v2 3/7] cxl: add core plumbing for creation of ram
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v2-3-4ea6253000e5@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=5741;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=tj30CiWrHmwuRBIF22lg+gB169wt098YpkJ/DZ2p6XY=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2eWPd3+KPLgsaJYJaWtq/meN+SctNusq/k+7XXTV
 KG/dVsvdJSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiRRmMDPPm8ale6cq9u/X6
 DZnslcd29Ff4mJXePt7C0/Sj8NFWwWuMDMcispVmqzi/k2gxnGK17+CZLS5ZeznnLvNXmyWoNHG
 dBy8A
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-create-region.txt |  3 ++-
 cxl/lib/libcxl.c                        | 22 +++++++++++++++++++---
 cxl/libcxl.h                            |  1 +
 cxl/region.c                            | 28 ++++++++++++++++++++++++----
 cxl/lib/libcxl.sym                      |  1 +
 5 files changed, 47 insertions(+), 8 deletions(-)

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
index 38aa142..c69cb9a 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -380,7 +380,18 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		struct json_object *jobj =
 			json_object_array_get_idx(p->memdevs, i);
 		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
-		u64 size = cxl_memdev_get_pmem_size(memdev);
+		u64 size = 0;
+
+		switch(p->mode) {
+		case CXL_DECODER_MODE_RAM:
+			size = cxl_memdev_get_ram_size(memdev);
+			break;
+		case CXL_DECODER_MODE_PMEM:
+			size = cxl_memdev_get_pmem_size(memdev);
+			break;
+		default:
+			/* Shouldn't ever get here */ ;
+		}
 
 		if (!p->ep_min_size)
 			p->ep_min_size = size;
@@ -589,8 +600,15 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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
@@ -602,10 +620,12 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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


