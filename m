Return-Path: <nvdimm+bounces-4503-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D3658F4AD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Aug 2022 01:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9BDE280C5D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Aug 2022 23:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DD14C6A;
	Wed, 10 Aug 2022 23:09:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAD44A06
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 23:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660172978; x=1691708978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DHge/EVQgO1JKhklBNSNtxSIQ7jb0FVT7YQXbuAZ3Mg=;
  b=Ldsyl4RqVGvX/TGHBEd2zz/3nz+yWy3oUqMxQZ2yfdcHEn3gUSwP3eCV
   XSMt5zfg64+r5TYwvT7eczffuL4D61clAiTaYmdR8CpBBoDPMHukzYcHx
   pT+UPxZ7g2PEcssdxKmofzTBFMpC6gU8nPCf55OV+/olbajehfIYpKQMW
   BvaKG7BBzSBkXNW5WHEEKpI9kIYjNiW+iv9OA8KkE3+mn/k7QecWnwtRb
   qhPdeY9vOqt777w+aWJgwz/0z6ngB9qnExQpCznOSlfmLcECSurytwYmV
   4DCwyuf75jZUBBLHFcAndJR0P1I2QPl3o2jG8ZXHk0Kz/uwxQKV4wKVee
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="292471273"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="292471273"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581429429"
Received: from maughenb-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.94.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:31 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 03/10] libcxl: Introduce libcxl region and mapping objects
Date: Wed, 10 Aug 2022 17:09:07 -0600
Message-Id: <20220810230914.549611-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810230914.549611-1-vishal.l.verma@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18477; h=from:subject; bh=DHge/EVQgO1JKhklBNSNtxSIQ7jb0FVT7YQXbuAZ3Mg=; b=owGbwMvMwCXGf25diOft7jLG02pJDElfrGa4CYk+vThLo+6G8rnsV3Ul1+fN7Wype7hszgznrVmi Qg5yHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIohYjw91U/SP6mg/rFQ9xfL6t/j L7e/6tCyo1F2I2L+0Umf/y5wuGfzoTYkTnPCmWFF+Y3JlttMjkqP1ZhYW7DDs+P+TpZzEw5wYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a cxl_region object to libcxl that represents a CXL region. CXL
regions are made up of one or more cxl_memdev 'targets'. The
relationship between a target and a region is conveyed with a
cxl_memdev_mapping object.

CXL regions are childeren of root decoders, and are organized as such.
Mapping objects are childeren of a CXL region.  Introduce the two
classes of objects themselves, and common accessors related to them.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  34 ++++
 cxl/lib/libcxl.c   | 431 +++++++++++++++++++++++++++++++++++++++++++--
 cxl/libcxl.h       |  41 +++++
 .clang-format      |   2 +
 cxl/lib/libcxl.sym |  20 +++
 5 files changed, 518 insertions(+), 10 deletions(-)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 832a815..da49a6c 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -116,7 +116,41 @@ struct cxl_decoder {
 	bool accelmem_capable;
 	bool locked;
 	enum cxl_decoder_target_type target_type;
+	int regions_init;
 	struct list_head targets;
+	struct list_head regions;
+};
+
+enum cxl_decode_state {
+	CXL_DECODE_UNKNOWN = -1,
+	CXL_DECODE_RESET = 0,
+	CXL_DECODE_COMMIT,
+};
+
+struct cxl_region {
+	struct cxl_decoder *decoder;
+	struct list_node list;
+	int mappings_init;
+	struct cxl_ctx *ctx;
+	void *dev_buf;
+	size_t buf_len;
+	char *dev_path;
+	int id;
+	uuid_t uuid;
+	u64 start;
+	u64 size;
+	unsigned int interleave_ways;
+	unsigned int interleave_granularity;
+	enum cxl_decode_state decode_state;
+	struct kmod_module *module;
+	struct list_head mappings;
+};
+
+struct cxl_memdev_mapping {
+	struct cxl_region *region;
+	struct cxl_decoder *decoder;
+	unsigned int position;
+	struct list_node list;
 };
 
 enum cxl_cmd_query_status {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 946cd4b..8dd804c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -79,6 +79,31 @@ static void free_target(struct cxl_target *target, struct list_head *head)
 	free(target);
 }
 
+static void free_region(struct cxl_region *region)
+{
+	struct cxl_decoder *decoder = region->decoder;
+	struct cxl_memdev_mapping *mapping, *_m;
+
+	list_for_each_safe(&region->mappings, mapping, _m, list) {
+		list_del_from(&region->mappings, &mapping->list);
+		free(mapping);
+	}
+	list_del_from(&decoder->regions, &region->list);
+	kmod_module_unref(region->module);
+	free(region->dev_buf);
+	free(region->dev_path);
+	free(region);
+}
+
+static void free_regions(struct cxl_decoder *decoder)
+{
+	struct cxl_region *region, *_r;
+
+	list_for_each_safe(&decoder->regions, region, _r, list)
+		free_region(region);
+	decoder->regions_init = 0;
+}
+
 static void free_decoder(struct cxl_decoder *decoder, struct list_head *head)
 {
 	struct cxl_target *target, *_t;
@@ -87,6 +112,7 @@ static void free_decoder(struct cxl_decoder *decoder, struct list_head *head)
 		list_del_from(head, &decoder->list);
 	list_for_each_safe(&decoder->targets, target, _t, list)
 		free_target(target, &decoder->targets);
+	free_regions(decoder);
 	free(decoder->dev_buf);
 	free(decoder->dev_path);
 	free(decoder);
@@ -304,6 +330,400 @@ CXL_EXPORT void cxl_set_log_priority(struct cxl_ctx *ctx, int priority)
 	ctx->ctx.log_priority = priority;
 }
 
+static int is_enabled(const char *drvpath)
+{
+	struct stat st;
+
+	if (lstat(drvpath, &st) < 0 || !S_ISLNK(st.st_mode))
+		return 0;
+	else
+		return 1;
+}
+
+CXL_EXPORT int cxl_region_is_enabled(struct cxl_region *region)
+{
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *path = region->dev_buf;
+	int len = region->buf_len;
+
+	if (snprintf(path, len, "%s/driver", region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", cxl_region_get_devname(region));
+		return 0;
+	}
+
+	return is_enabled(path);
+}
+
+CXL_EXPORT int cxl_region_disable(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+
+	util_unbind(region->dev_path, ctx);
+
+	if (cxl_region_is_enabled(region)) {
+		err(ctx, "%s: failed to disable\n", devname);
+		return -EBUSY;
+	}
+
+	dbg(ctx, "%s: disabled\n", devname);
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_enable(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *path = region->dev_buf;
+	int len = region->buf_len;
+	char buf[SYSFS_ATTR_SIZE];
+	u64 resource = ULLONG_MAX;
+
+	if (cxl_region_is_enabled(region))
+		return 0;
+
+	util_bind(devname, region->module, "cxl", ctx);
+
+	if (!cxl_region_is_enabled(region)) {
+		err(ctx, "%s: failed to enable\n", devname);
+		return -ENXIO;
+	}
+
+	/*
+	 * Currently 'resource' is the only attr that may change after enabling.
+	 * Just refresh it here. If there are additional resources that need
+	 * to be refreshed here later, split these out into a common helper
+	 * for this and add_cxl_region()
+	 */
+	if (snprintf(path, len, "%s/resource", region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return 0;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		resource = strtoull(buf, NULL, 0);
+
+	if (resource < ULLONG_MAX)
+		region->start = resource;
+
+	dbg(ctx, "%s: enabled\n", devname);
+
+	return 0;
+}
+
+static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
+{
+	const char *devname = devpath_to_devname(cxlregion_base);
+	char *path = calloc(1, strlen(cxlregion_base) + 100);
+	struct cxl_region *region, *region_dup;
+	struct cxl_decoder *decoder = parent;
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	char buf[SYSFS_ATTR_SIZE];
+	u64 resource = ULLONG_MAX;
+
+	dbg(ctx, "%s: base: \'%s\'\n", devname, cxlregion_base);
+
+	if (!path)
+		return NULL;
+
+	region = calloc(1, sizeof(*region));
+	if (!region)
+		goto err;
+
+	region->id = id;
+	region->ctx = ctx;
+	region->decoder = decoder;
+	list_head_init(&region->mappings);
+
+	region->dev_path = strdup(cxlregion_base);
+	if (!region->dev_path)
+		goto err;
+
+	region->dev_buf = calloc(1, strlen(cxlregion_base) + 50);
+	if (!region->dev_buf)
+		goto err;
+	region->buf_len = strlen(cxlregion_base) + 50;
+
+	sprintf(path, "%s/size", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		region->size = ULLONG_MAX;
+	else
+		region->size = strtoull(buf, NULL, 0);
+
+	sprintf(path, "%s/resource", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		resource = strtoull(buf, NULL, 0);
+
+	if (resource < ULLONG_MAX)
+		region->start = resource;
+
+	sprintf(path, "%s/uuid", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		goto err;
+	if (strlen(buf) && uuid_parse(buf, region->uuid) < 0) {
+		dbg(ctx, "%s:%s\n", path, buf);
+		goto err;
+	}
+
+	sprintf(path, "%s/interleave_granularity", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		region->interleave_granularity = UINT_MAX;
+	else
+		region->interleave_granularity = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/interleave_ways", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		region->interleave_ways = UINT_MAX;
+	else
+		region->interleave_ways = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/commit", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		region->decode_state = CXL_DECODE_UNKNOWN;
+	else
+		region->decode_state = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/modalias", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		region->module = util_modalias_to_module(ctx, buf);
+
+	cxl_region_foreach(decoder, region_dup)
+		if (region_dup->id == region->id) {
+			free_region(region);
+			return region_dup;
+		}
+
+	list_add(&decoder->regions, &region->list);
+
+	return region;
+err:
+	free(region->dev_path);
+	free(region->dev_buf);
+	free(region);
+	free(path);
+	return NULL;
+}
+
+static void cxl_regions_init(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+
+	if (decoder->regions_init)
+		return;
+
+	/* Only root port decoders may have child regions */
+	if (!cxl_port_is_root(port))
+		return;
+
+	decoder->regions_init = 1;
+
+	sysfs_device_parse(ctx, decoder->dev_path, "region", decoder,
+			   add_cxl_region);
+}
+
+CXL_EXPORT struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder)
+{
+	cxl_regions_init(decoder);
+
+	return list_top(&decoder->regions, struct cxl_region, list);
+}
+
+CXL_EXPORT struct cxl_region *cxl_region_get_next(struct cxl_region *region)
+{
+	struct cxl_decoder *decoder = region->decoder;
+
+	return list_next(&decoder->regions, region, list);
+}
+
+CXL_EXPORT struct cxl_ctx *cxl_region_get_ctx(struct cxl_region *region)
+{
+	return region->ctx;
+}
+
+CXL_EXPORT struct cxl_decoder *cxl_region_get_decoder(struct cxl_region *region)
+{
+	return region->decoder;
+}
+
+CXL_EXPORT int cxl_region_get_id(struct cxl_region *region)
+{
+	return region->id;
+}
+
+CXL_EXPORT const char *cxl_region_get_devname(struct cxl_region *region)
+{
+	return devpath_to_devname(region->dev_path);
+}
+
+CXL_EXPORT void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu)
+{
+	memcpy(uu, region->uuid, sizeof(uuid_t));
+}
+
+CXL_EXPORT unsigned long long cxl_region_get_size(struct cxl_region *region)
+{
+	return region->size;
+}
+
+CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
+{
+	return region->start;
+}
+
+CXL_EXPORT unsigned int
+cxl_region_get_interleave_ways(struct cxl_region *region)
+{
+	return region->interleave_ways;
+}
+
+CXL_EXPORT int cxl_region_decode_is_committed(struct cxl_region *region)
+{
+	return (region->decode_state == CXL_DECODE_COMMIT) ? 1 : 0;
+}
+
+CXL_EXPORT unsigned int
+cxl_region_get_interleave_granularity(struct cxl_region *region)
+{
+	return region->interleave_granularity;
+}
+
+static struct cxl_decoder *__cxl_port_match_decoder(struct cxl_port *port,
+						    const char *ident)
+{
+	struct cxl_decoder *decoder;
+
+	cxl_decoder_foreach(port, decoder)
+		if (strcmp(cxl_decoder_get_devname(decoder), ident) == 0)
+			return decoder;
+
+	return NULL;
+}
+
+static struct cxl_decoder *cxl_port_find_decoder(struct cxl_port *port,
+						 const char *ident)
+{
+	struct cxl_decoder *decoder;
+	struct cxl_endpoint *ep;
+
+	/* First, check decoders directly under @port */
+	decoder = __cxl_port_match_decoder(port, ident);
+	if (decoder)
+		return decoder;
+
+	/* Next, iterate over the endpoints under @port */
+	cxl_endpoint_foreach(port, ep) {
+		decoder = __cxl_port_match_decoder(cxl_endpoint_get_port(ep),
+						   ident);
+		if (decoder)
+			return decoder;
+	}
+
+	return NULL;
+}
+
+static struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
+						   const char *ident)
+{
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus) {
+		struct cxl_decoder *decoder;
+		struct cxl_port *port, *top;
+
+		port = cxl_bus_get_port(bus);
+		decoder = cxl_port_find_decoder(port, ident);
+		if (decoder)
+			return decoder;
+
+		top = port;
+		cxl_port_foreach_all (top, port) {
+			decoder = cxl_port_find_decoder(port, ident);
+			if (decoder)
+				return decoder;
+		}
+	}
+
+	return NULL;
+}
+
+static void cxl_mappings_init(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *mapping_path, buf[SYSFS_ATTR_SIZE];
+	unsigned int i;
+
+	if (region->mappings_init)
+		return;
+	region->mappings_init = 1;
+
+	mapping_path = calloc(1, strlen(region->dev_path) + 100);
+	if (!mapping_path) {
+		err(ctx, "%s: allocation failure\n", devname);
+		return;
+	}
+
+	for (i = 0; i < region->interleave_ways; i++) {
+		struct cxl_memdev_mapping *mapping;
+		struct cxl_decoder *decoder;
+
+		sprintf(mapping_path, "%s/target%d", region->dev_path, i);
+		if (sysfs_read_attr(ctx, mapping_path, buf) < 0) {
+			err(ctx, "%s: failed to read target%d\n", devname, i);
+			continue;
+		}
+
+		decoder = cxl_decoder_get_by_name(ctx, buf);
+		if (!decoder) {
+			err(ctx, "%s target%d: %s lookup failure\n",
+			    devname, i, buf);
+			continue;
+		}
+
+		mapping = calloc(1, sizeof(*mapping));
+		if (!mapping) {
+			err(ctx, "%s target%d: allocation failure\n", devname, i);
+			continue;
+		}
+
+		mapping->region = region;
+		mapping->decoder = decoder;
+		mapping->position = i;
+		list_add(&region->mappings, &mapping->list);
+	}
+	free(mapping_path);
+}
+
+CXL_EXPORT struct cxl_memdev_mapping *
+cxl_mapping_get_first(struct cxl_region *region)
+{
+	cxl_mappings_init(region);
+
+	return list_top(&region->mappings, struct cxl_memdev_mapping, list);
+}
+
+CXL_EXPORT struct cxl_memdev_mapping *
+cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
+{
+	struct cxl_region *region = mapping->region;
+
+	return list_next(&region->mappings, mapping, list);
+}
+
+CXL_EXPORT struct cxl_decoder *
+cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping)
+{
+	return mapping->decoder;
+}
+
+CXL_EXPORT unsigned int
+cxl_mapping_get_position(struct cxl_memdev_mapping *mapping)
+{
+	return mapping->position;
+}
+
 static void *add_cxl_pmem(void *parent, int id, const char *br_base)
 {
 	const char *devname = devpath_to_devname(br_base);
@@ -681,16 +1101,6 @@ CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
 	return memdev->lsa_size;
 }
 
-static int is_enabled(const char *drvpath)
-{
-	struct stat st;
-
-	if (lstat(drvpath, &st) < 0 || !S_ISLNK(st.st_mode))
-		return 0;
-	else
-		return 1;
-}
-
 CXL_EXPORT int cxl_memdev_is_enabled(struct cxl_memdev *memdev)
 {
 	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
@@ -939,6 +1349,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	decoder->ctx = ctx;
 	decoder->port = port;
 	list_head_init(&decoder->targets);
+	list_head_init(&decoder->regions);
 
 	decoder->dev_path = strdup(cxldecoder_base);
 	if (!decoder->dev_path)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 33a216e..c77a7b9 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -224,6 +224,47 @@ int cxl_memdev_is_enabled(struct cxl_memdev *memdev);
 	for (endpoint = cxl_endpoint_get_first(port); endpoint != NULL;        \
 	     endpoint = cxl_endpoint_get_next(endpoint))
 
+struct cxl_region;
+struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
+struct cxl_region *cxl_region_get_next(struct cxl_region *region);
+int cxl_region_decode_is_committed(struct cxl_region *region);
+int cxl_region_is_enabled(struct cxl_region *region);
+int cxl_region_disable(struct cxl_region *region);
+int cxl_region_enable(struct cxl_region *region);
+struct cxl_ctx *cxl_region_get_ctx(struct cxl_region *region);
+struct cxl_decoder *cxl_region_get_decoder(struct cxl_region *region);
+int cxl_region_get_id(struct cxl_region *region);
+const char *cxl_region_get_devname(struct cxl_region *region);
+void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
+unsigned long long cxl_region_get_size(struct cxl_region *region);
+unsigned long long cxl_region_get_resource(struct cxl_region *region);
+unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
+unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
+
+#define cxl_region_foreach(decoder, region)                                    \
+	for (region = cxl_region_get_first(decoder); region != NULL;           \
+	     region = cxl_region_get_next(region))
+
+#define cxl_region_foreach_safe(decoder, region, _region)                      \
+	for (region = cxl_region_get_first(decoder),                           \
+	     _region = region ? cxl_region_get_next(region) : NULL;            \
+	     region != NULL;                                                   \
+	     region = _region,                                                 \
+	     _region = _region ? cxl_region_get_next(_region) : NULL)
+
+struct cxl_memdev_mapping;
+struct cxl_memdev_mapping *cxl_mapping_get_first(struct cxl_region *region);
+struct cxl_memdev_mapping *
+cxl_mapping_get_next(struct cxl_memdev_mapping *mapping);
+struct cxl_decoder *cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping);
+struct cxl_region *cxl_mapping_get_region(struct cxl_memdev_mapping *mapping);
+unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
+
+#define cxl_mapping_foreach(region, mapping) \
+        for (mapping = cxl_mapping_get_first(region); \
+             mapping != NULL; \
+             mapping = cxl_mapping_get_next(mapping))
+
 struct cxl_cmd;
 const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);
diff --git a/.clang-format b/.clang-format
index 7254a1b..b6169e1 100644
--- a/.clang-format
+++ b/.clang-format
@@ -86,6 +86,8 @@ ForEachMacros:
   - 'cxl_dport_foreach'
   - 'cxl_endpoint_foreach'
   - 'cxl_port_foreach_all'
+  - 'cxl_region_foreach'
+  - 'cxl_region_foreach_safe'
   - 'daxctl_dev_foreach'
   - 'daxctl_mapping_foreach'
   - 'daxctl_region_foreach'
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 7712de0..e410298 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -177,4 +177,24 @@ global:
 	cxl_decoder_get_prev;
 	cxl_decoder_set_dpa_size;
 	cxl_decoder_set_mode;
+	cxl_region_get_first;
+	cxl_region_get_next;
+	cxl_region_decode_is_committed;
+	cxl_region_is_enabled;
+	cxl_region_disable;
+	cxl_region_enable;
+	cxl_region_get_ctx;
+	cxl_region_get_decoder;
+	cxl_region_get_id;
+	cxl_region_get_devname;
+	cxl_region_get_uuid;
+	cxl_region_get_size;
+	cxl_region_get_resource;
+	cxl_region_get_interleave_ways;
+	cxl_region_get_interleave_granularity;
+	cxl_mapping_get_first;
+	cxl_mapping_get_next;
+	cxl_mapping_get_decoder;
+	cxl_mapping_get_region;
+	cxl_mapping_get_position;
 } LIBCXL_2;
-- 
2.37.1


