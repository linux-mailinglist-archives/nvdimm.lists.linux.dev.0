Return-Path: <nvdimm+bounces-10398-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3820EABC81D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 May 2025 22:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51E654A2004
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 May 2025 20:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532A220FA94;
	Mon, 19 May 2025 20:01:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146424B1E73;
	Mon, 19 May 2025 20:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747684869; cv=none; b=Xiwk9fbhIuo1M83FGqskvt0ZFWw70pfe4YzNJv5YHfhqoRhE9KmaAnyy619Vg9GcvbVOhgz7g8ug9K7a/Pq5jR8gIy0RDMxNLgLZI0kQNK9JM5XxKYqiC6D0fV+S6jZjNIkpyb35YeE/I9xG8KsH3GlYfJFLdNX4Z3LsF2NexCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747684869; c=relaxed/simple;
	bh=ofDgc9Rb8H0hVOtbXo/ogGXQ4eqkR6plXbh7nqmjx30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM8FCHQ2QCACYWh2IZud1erhHIhg2PzR8ja54zqPnm1RpfDW9fVLpsCj3Zq0C7kz9tFLWI+RVW9OTZ+rJl1mV7TSdhP7eqH4ex+JEIQgYg6IRH0zGV1i//rY4euN0fa3ShX6PgQtG4aQKeXysRg/1qw6HpAxpkko3vBwdUZxk0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB37C4CEE4;
	Mon, 19 May 2025 20:01:08 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: [NDCTL PATCH v7 1/4] cxl: Add cxl_bus_get_by_provider()
Date: Mon, 19 May 2025 13:00:51 -0700
Message-ID: <20250519200056.3901498-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250519200056.3901498-1-dave.jiang@intel.com>
References: <20250519200056.3901498-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helper function cxl_bus_get_by_provider() in order to support unit
test that will utilize the API call.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  2 ++
 cxl/lib/libcxl.c                 | 11 +++++++++++
 cxl/lib/libcxl.sym               |  5 +++++
 cxl/libcxl.h                     |  2 ++
 4 files changed, 20 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 40598a08b9f4..25ff406c2920 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -215,6 +215,8 @@ the associated bus object.
 const char *cxl_bus_get_provider(struct cxl_bus *bus);
 const char *cxl_bus_get_devname(struct cxl_bus *bus);
 int cxl_bus_get_id(struct cxl_bus *bus);
+struct cxl_bus *cxl_bus_get_by_provider(struct cxl_ctx *ctx,
+					const char *provider);
 ----
 
 The provider name of a bus is a persistent name that is independent of
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef3acdc..bab7343e8a4a 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3358,6 +3358,17 @@ CXL_EXPORT struct cxl_ctx *cxl_bus_get_ctx(struct cxl_bus *bus)
 	return cxl_port_get_ctx(&bus->port);
 }
 
+CXL_EXPORT struct cxl_bus *cxl_bus_get_by_provider(struct cxl_ctx *ctx,
+						   const char *provider)
+{
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus)
+		if (strcmp(provider, cxl_bus_get_provider(bus)) == 0)
+			return bus;
+	return NULL;
+}
+
 CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
 {
 	if (!cmd)
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 763151fbef59..4c9760f377e6 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -287,3 +287,8 @@ global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
 } LIBCXL_7;
+
+LIBCXL_9 {
+global:
+	cxl_bus_get_by_provider;
+} LIBECXL_8;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 43c082acd836..7a32b9b65736 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -122,6 +122,8 @@ int cxl_bus_get_id(struct cxl_bus *bus);
 struct cxl_port *cxl_bus_get_port(struct cxl_bus *bus);
 struct cxl_ctx *cxl_bus_get_ctx(struct cxl_bus *bus);
 int cxl_bus_disable_invalidate(struct cxl_bus *bus);
+struct cxl_bus *cxl_bus_get_by_provider(struct cxl_ctx *ctx,
+					const char *provider);
 
 #define cxl_bus_foreach(ctx, bus)                                              \
 	for (bus = cxl_bus_get_first(ctx); bus != NULL;                        \
-- 
2.49.0


