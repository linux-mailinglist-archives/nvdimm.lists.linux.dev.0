Return-Path: <nvdimm+bounces-7287-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0E5846449
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Feb 2024 00:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98CB81F2406F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Feb 2024 23:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E163447F4B;
	Thu,  1 Feb 2024 23:06:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EDD3CF6B;
	Thu,  1 Feb 2024 23:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706828817; cv=none; b=faIGYCLqUlOVreXjgabrIV34W+8Y0nU+Wenq8mMaAzAEsqWlGGYRtx/JwicwpVKBO0H26xR6TE3JtWXDHNz2R/nYnQshb4wjr7mjwQ0itGlLN8nbiKDku6mjMOoF7ya28xYivxZ80SOBk2FdGBuiiU52FiocgUOiFNo+ZuxtFqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706828817; c=relaxed/simple;
	bh=sdhTZJ5XcK2rP+SP6rH0lZkdC7DbH0p5JYVoFFaDSlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBldWGYYXbYjmO/269gwYegvyktb4HoqfUEhUloBA0bhZv6GyEzNDZPd4z61qDw4nnCqH1Id9iEvig2QRzh1vByH3o3iARqSVlSC+BKxiEetgp3TIJobGRYBu1TlTsyExbAlW+LEhPTDoYB6MSmP5vCpuVv4VhZhiN8t3TQOV54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B57CC433F1;
	Thu,  1 Feb 2024 23:06:56 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Alison Schofield <alison.schofield@intel.com>
Subject: [NDCTL PATCH v5 3/4] ndctl: cxl: add QoS class check for CXL region creation
Date: Thu,  1 Feb 2024 16:05:06 -0700
Message-ID: <20240201230646.1328211-4-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201230646.1328211-1-dave.jiang@intel.com>
References: <20240201230646.1328211-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
represents the CFMWS. A qos_class attribute is exported via sysfs for the root
decoder.

One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
device for a CXL memory device. The input for the _DSM is the read and write
latency and bandwidth for the path between the device and the CPU. The
numbers are constructed by the kernel driver for the _DSM input. When a
device is probed, QoS class tokens  are retrieved. This is useful for a
hot-plugged CXL memory device that does not have regions created.

Add a QoS check during region creation. Emit a warning if the qos_class
token from the root decoder is different than the mem device qos_class
token. User parameter options are provided to fail instead of just
warning.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/cxl-create-region.txt |  9 ++++
 cxl/region.c                            | 56 ++++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index f11a412bddfe..d5e34cf38236 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -105,6 +105,15 @@ include::bus-option.txt[]
 	supplied, the first cross-host bridge (if available), decoder that
 	supports the largest interleave will be chosen.
 
+-e::
+--strict::
+	Enforce strict execution where any potential error will force failure.
+	For example, if qos_class mismatches region creation will fail.
+
+-q::
+--no-enforce-qos::
+	Parameter to bypass qos_class mismatch failure. Will only emit warning.
+
 include::human-option.txt[]
 
 include::debug-option.txt[]
diff --git a/cxl/region.c b/cxl/region.c
index 3a762db4800e..f9033fa0afbf 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -32,6 +32,8 @@ static struct region_params {
 	bool force;
 	bool human;
 	bool debug;
+	bool strict;
+	bool no_qos;
 } param = {
 	.ways = INT_MAX,
 	.granularity = INT_MAX,
@@ -49,6 +51,8 @@ struct parsed_params {
 	const char **argv;
 	struct cxl_decoder *root_decoder;
 	enum cxl_decoder_mode mode;
+	bool strict;
+	bool no_qos;
 };
 
 enum region_actions {
@@ -81,7 +85,9 @@ OPT_STRING('U', "uuid", &param.uuid, \
 	   "region uuid", "uuid for the new region (default: autogenerate)"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
 	    "non-option arguments are memdevs"), \
-OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
+OPT_BOOLEAN('e', "strict", &param.strict, "strict execution enforcement"), \
+OPT_BOOLEAN('q', "no-enforce-qos", &param.no_qos, "no enforce of qos_class")
 
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
@@ -360,6 +366,9 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		}
 	}
 
+	p->strict = param.strict;
+	p->no_qos = param.no_qos;
+
 	return 0;
 
 err:
@@ -467,6 +476,49 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 		p->mode = CXL_DECODER_MODE_PMEM;
 }
 
+static int create_region_validate_qos_class(struct cxl_ctx *ctx,
+					    struct parsed_params *p)
+{
+	int root_qos_class;
+	int qos_class;
+	int i;
+
+	root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
+	if (root_qos_class == CXL_QOS_CLASS_NONE)
+		return 0;
+
+	for (i = 0; i < p->ways; i++) {
+		struct json_object *jobj =
+			json_object_array_get_idx(p->memdevs, i);
+		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+
+		if (p->mode == CXL_DECODER_MODE_RAM)
+			qos_class = cxl_memdev_get_ram_qos_class(memdev);
+		else
+			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+
+		/* No qos_class entries. Possibly no kernel support */
+		if (qos_class == CXL_QOS_CLASS_NONE)
+			break;
+
+		if (qos_class != root_qos_class) {
+			if (p->strict && !p->no_qos) {
+				log_err(&rl, "%s QoS Class mismatches %s\n",
+					cxl_decoder_get_devname(p->root_decoder),
+					cxl_memdev_get_devname(memdev));
+
+				return -ENXIO;
+			}
+
+			log_notice(&rl, "%s QoS Class mismatches %s\n",
+				   cxl_decoder_get_devname(p->root_decoder),
+				   cxl_memdev_get_devname(memdev));
+		}
+	}
+
+	return 0;
+}
+
 static int create_region_validate_config(struct cxl_ctx *ctx,
 					 struct parsed_params *p)
 {
@@ -507,6 +559,8 @@ found:
 		return rc;
 
 	collect_minsize(ctx, p);
+	create_region_validate_qos_class(ctx, p);
+
 	return 0;
 }
 
-- 
2.43.0


