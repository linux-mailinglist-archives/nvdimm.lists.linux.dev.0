Return-Path: <nvdimm+bounces-7257-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EAC843155
	for <lists+linux-nvdimm@lfdr.de>; Wed, 31 Jan 2024 00:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C8991C2344F
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jan 2024 23:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8525E79959;
	Tue, 30 Jan 2024 23:35:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3747EF06;
	Tue, 30 Jan 2024 23:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706657736; cv=none; b=s7v7elOQdZYqwnEFSsNdHKA4wm4CKViPVPrt+p3/NuIhyU2IPALbKUHbiR6VK0A3r6PSPGejEamsQFBQxQoewgxWk+NSuJZYI8oSdTSYRHk9PKWqPbLi470qkm06243OaJNteuVt6xk+OVc5PQC2L3ufsPfXr1oB3bZA9e79Wlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706657736; c=relaxed/simple;
	bh=roijmvOyrE6L7H4uRXkZpoJwNp8Lb9gv75LC7Pt4HSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnrHhbT4XKeUoKXdPqvhQJEKa3vLNouXMx5ewGKhF0kWHbHJBIqvXQDzgqMWk0a2S2XF8zs7bfep/aof0sCDwFLKh8ttcj6WlzyMc7xqpHbk7Gknl/hhi388CkGfFihrg6Yl/l2VRE8oJLQJ9HFOyEDfQ8vg1MB6PMuAjb3pyxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C32C433C7;
	Tue, 30 Jan 2024 23:35:35 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Alison Schofield <alison.schofield@intel.com>
Subject: [NDCTL PATCH v4 1/4] ndctl: cxl: Add QoS class retrieval for the root decoder
Date: Tue, 30 Jan 2024 16:32:41 -0700
Message-ID: <20240130233526.1031801-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130233526.1031801-1-dave.jiang@intel.com>
References: <20240130233526.1031801-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add libcxl API to retrieve the QoS class for the root decoder. Also add
support to display the QoS class for the root decoder through the 'cxl
list' command. The qos_class is the QTG ID of the CFMWS window that
represents the root decoder.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v4:
- Move display of qos_class to default for root decoder.
---
 cxl/filter.h       |  4 ++++
 cxl/json.c         | 10 ++++++++++
 cxl/lib/libcxl.c   | 14 ++++++++++++++
 cxl/lib/libcxl.sym |  1 +
 cxl/lib/private.h  |  1 +
 cxl/libcxl.h       |  3 +++
 cxl/list.c         |  1 +
 util/json.h        |  1 +
 8 files changed, 35 insertions(+)

diff --git a/cxl/filter.h b/cxl/filter.h
index 1241f72ccf62..3c5f9e8a0452 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -31,6 +31,7 @@ struct cxl_filter_params {
 	bool alert_config;
 	bool dax;
 	bool poison;
+	bool qos;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -91,6 +92,9 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (param->poison)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (param->qos)
+		flags |= UTIL_JSON_QOS_CLASS;
+
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index 6fb17582a1cb..48a43ddf14b0 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1062,6 +1062,16 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					       jobj);
 	}
 
+	if ((flags & UTIL_JSON_QOS_CLASS) && cxl_port_is_root(port)) {
+		int qos_class = cxl_root_decoder_get_qos_class(decoder);
+
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdecoder, "qos_class", jobj);
+		}
+	}
+
 	json_object_set_userdata(jdecoder, decoder, NULL);
 	return jdecoder;
 }
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 1537a33d370e..9a1ac7001803 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2229,6 +2229,12 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	else
 		decoder->interleave_ways = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/qos_class", cxldecoder_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		decoder->qos_class = CXL_QOS_CLASS_NONE;
+	else
+		decoder->qos_class = atoi(buf);
+
 	switch (port->type) {
 	case CXL_PORT_ENDPOINT:
 		sprintf(path, "%s/dpa_resource", cxldecoder_base);
@@ -2423,6 +2429,14 @@ CXL_EXPORT unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder)
 	return decoder->size;
 }
 
+CXL_EXPORT int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder)
+{
+	if (!cxl_port_is_root(decoder->port))
+		return -EINVAL;
+
+	return decoder->qos_class;
+}
+
 CXL_EXPORT unsigned long long
 cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 2149f84d764e..384fea2c25e3 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -282,4 +282,5 @@ global:
 LIBCXL_8 {
 global:
 	cxl_memdev_wait_sanitize;
+	cxl_root_decoder_get_qos_class;
 } LIBCXL_7;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b26a8629e047..4847ff448f71 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -144,6 +144,7 @@ struct cxl_decoder {
 	struct list_head targets;
 	struct list_head regions;
 	struct list_head stale_regions;
+	int qos_class;
 };
 
 enum cxl_decode_state {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 352b3a866f63..e5c08da77f77 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -173,6 +173,8 @@ struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
 	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
 	     dport = cxl_dport_get_next(dport))
 
+#define CXL_QOS_CLASS_NONE		-1
+
 struct cxl_decoder;
 struct cxl_decoder *cxl_decoder_get_first(struct cxl_port *port);
 struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder);
@@ -184,6 +186,7 @@ unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
 unsigned long long
 cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
+int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
 
 enum cxl_decoder_mode {
 	CXL_DECODER_MODE_NONE,
diff --git a/cxl/list.c b/cxl/list.c
index 13fef8569340..5402575b9937 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -136,6 +136,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.regions = true;
 		/*fallthrough*/
 	case 0:
+		param.qos = true;
 		break;
 	}
 
diff --git a/util/json.h b/util/json.h
index ea370df4d1b7..b07055005084 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_QOS_CLASS	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,
-- 
2.43.0


