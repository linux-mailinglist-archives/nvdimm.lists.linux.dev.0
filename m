Return-Path: <nvdimm+bounces-7642-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6917E87085F
	for <lists+linux-nvdimm@lfdr.de>; Mon,  4 Mar 2024 18:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B05C1C2137A
	for <lists+linux-nvdimm@lfdr.de>; Mon,  4 Mar 2024 17:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880B361676;
	Mon,  4 Mar 2024 17:36:33 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4D4612E6;
	Mon,  4 Mar 2024 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573793; cv=none; b=SpV34iuv0EJnrDPHZepBf2alEQiW2jbdUIJ2Rc37spmFH6E1rEYAwCHPB+f4fAyN31i7i2olT4OzH7p2H1lSAHgOQX6YcLX2is0DM4oKqIB8piCqzBrBESIKX41etOuVX3BVIDODeI6MaRTpZVDHAlgsdS30Grda4YEN0kg6XS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573793; c=relaxed/simple;
	bh=/TbPAStP3I3PF0/RE6UC9NYhDYpSULt1wrfrOngDNKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUSwyL3cOUQhGnYCfP7A2l62InhcTP9UJF6QU8pnOODE+W7PAGAKxYoQy2ljcCcYrLlTV6UUddl2PkDZNLwnCAhX6A/Wag8DSIN+3I0PQ77ycN0SX9CTtXUOwJ4g9C7FNGgddHJPP/Iza+67iP6ajK9DQF7hDwSDUK9K/wa3QM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4028EC433F1;
	Mon,  4 Mar 2024 17:36:31 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Alison Schofield <alison.schofield@intel.com>
Subject: [NDCTL PATCH v9 1/4] ndctl: cxl: Add QoS class retrieval for the root decoder
Date: Mon,  4 Mar 2024 10:35:32 -0700
Message-ID: <20240304173618.1580662-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240304173618.1580662-1-dave.jiang@intel.com>
References: <20240304173618.1580662-1-dave.jiang@intel.com>
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
 cxl/json.c         | 10 ++++++++++
 cxl/lib/libcxl.c   | 14 ++++++++++++++
 cxl/lib/libcxl.sym |  1 +
 cxl/lib/private.h  |  1 +
 cxl/libcxl.h       |  3 +++
 5 files changed, 29 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 6fb17582a1cb..1d380e23d6ff 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1062,6 +1062,16 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					       jobj);
 	}
 
+	if (cxl_port_is_root(port)) {
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
-- 
2.43.0


