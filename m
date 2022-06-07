Return-Path: <nvdimm+bounces-3851-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CC0535B39
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 May 2022 10:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id EFCDB2E09D1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 May 2022 08:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321471853;
	Fri, 27 May 2022 08:14:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF6C46A9
	for <nvdimm@lists.linux.dev>; Fri, 27 May 2022 08:14:54 +0000 (UTC)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L8cxp6mwbz1JCC8;
	Fri, 27 May 2022 16:13:18 +0800 (CST)
Received: from dggpemm500018.china.huawei.com (7.185.36.111) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 16:14:51 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 16:14:51 +0800
From: keliu <liuke94@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: keliu <liuke94@huawei.com>
Subject: [PATCH] drivers: nvdimm: Directly use ida_alloc()/free()
Date: Fri, 27 May 2022 08:36:20 +0000
Message-ID: <20220527083620.2553637-1-liuke94@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500018.china.huawei.com (7.185.36.111)
X-CFilter-Loop: Reflected

Use ida_alloc()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove() .

Signed-off-by: keliu <liuke94@huawei.com>
---
 drivers/nvdimm/btt_devs.c       | 6 +++---
 drivers/nvdimm/bus.c            | 4 ++--
 drivers/nvdimm/dax_devs.c       | 4 ++--
 drivers/nvdimm/dimm_devs.c      | 4 ++--
 drivers/nvdimm/namespace_devs.c | 6 +++---
 drivers/nvdimm/pfn_devs.c       | 4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index e5a58520d398..25af0df89400 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -19,7 +19,7 @@ static void nd_btt_release(struct device *dev)
 
 	dev_dbg(dev, "trace\n");
 	nd_detach_ndns(&nd_btt->dev, &nd_btt->ndns);
-	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
+	ida_free(&nd_region->btt_ida, nd_btt->id);
 	kfree(nd_btt->uuid);
 	kfree(nd_btt);
 }
@@ -189,7 +189,7 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
 	if (!nd_btt)
 		return NULL;
 
-	nd_btt->id = ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);
+	nd_btt->id = ida_alloc(&nd_region->btt_ida, GFP_KERNEL);
 	if (nd_btt->id < 0)
 		goto out_nd_btt;
 
@@ -214,7 +214,7 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
 	return dev;
 
 out_put_id:
-	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
+	ida_free(&nd_region->btt_ida, nd_btt->id);
 
 out_nd_btt:
 	kfree(nd_btt);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7b0d1443217a..2fc7409f5f2f 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -291,7 +291,7 @@ static void nvdimm_bus_release(struct device *dev)
 	struct nvdimm_bus *nvdimm_bus;
 
 	nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
-	ida_simple_remove(&nd_ida, nvdimm_bus->id);
+	ida_free(&nd_ida, nvdimm_bus->id);
 	kfree(nvdimm_bus);
 }
 
@@ -346,7 +346,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	INIT_LIST_HEAD(&nvdimm_bus->list);
 	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
 	init_waitqueue_head(&nvdimm_bus->wait);
-	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	nvdimm_bus->id = ida_alloc(&nd_ida, GFP_KERNEL);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
 		return NULL;
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 99965077bac4..374b195ba8d5 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -18,7 +18,7 @@ static void nd_dax_release(struct device *dev)
 
 	dev_dbg(dev, "trace\n");
 	nd_detach_ndns(dev, &nd_pfn->ndns);
-	ida_simple_remove(&nd_region->dax_ida, nd_pfn->id);
+	ida_free(&nd_region->dax_ida, nd_pfn->id);
 	kfree(nd_pfn->uuid);
 	kfree(nd_dax);
 }
@@ -55,7 +55,7 @@ static struct nd_dax *nd_dax_alloc(struct nd_region *nd_region)
 		return NULL;
 
 	nd_pfn = &nd_dax->nd_pfn;
-	nd_pfn->id = ida_simple_get(&nd_region->dax_ida, 0, 0, GFP_KERNEL);
+	nd_pfn->id = ida_alloc(&nd_region->dax_ida, GFP_KERNEL);
 	if (nd_pfn->id < 0) {
 		kfree(nd_dax);
 		return NULL;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index ee507eed42b5..0f0e5851784f 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -194,7 +194,7 @@ static void nvdimm_release(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	ida_simple_remove(&dimm_ida, nvdimm->id);
+	ida_free(&dimm_ida, nvdimm->id);
 	kfree(nvdimm);
 }
 
@@ -583,7 +583,7 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	if (!nvdimm)
 		return NULL;
 
-	nvdimm->id = ida_simple_get(&dimm_ida, 0, 0, GFP_KERNEL);
+	nvdimm->id = ida_alloc(&dimm_ida, GFP_KERNEL);
 	if (nvdimm->id < 0) {
 		kfree(nvdimm);
 		return NULL;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 62b83b2e26e3..925e75f7382d 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -26,7 +26,7 @@ static void namespace_pmem_release(struct device *dev)
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 
 	if (nspm->id >= 0)
-		ida_simple_remove(&nd_region->ns_ida, nspm->id);
+		ida_free(&nd_region->ns_ida, nspm->id);
 	kfree(nspm->alt_name);
 	kfree(nspm->uuid);
 	kfree(nspm);
@@ -1819,7 +1819,7 @@ static struct device *nd_namespace_pmem_create(struct nd_region *nd_region)
 	res->name = dev_name(&nd_region->dev);
 	res->flags = IORESOURCE_MEM;
 
-	nspm->id = ida_simple_get(&nd_region->ns_ida, 0, 0, GFP_KERNEL);
+	nspm->id = ida_alloc(&nd_region->ns_ida, GFP_KERNEL);
 	if (nspm->id < 0) {
 		kfree(nspm);
 		return NULL;
@@ -2191,7 +2191,7 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 			struct nd_namespace_pmem *nspm;
 
 			nspm = to_nd_namespace_pmem(dev);
-			id = ida_simple_get(&nd_region->ns_ida, 0, 0,
+			id = ida_alloc(&nd_region->ns_ida,
 					    GFP_KERNEL);
 			nspm->id = id;
 		} else
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index c31e184bfa45..d814bda8040a 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -20,7 +20,7 @@ static void nd_pfn_release(struct device *dev)
 
 	dev_dbg(dev, "trace\n");
 	nd_detach_ndns(&nd_pfn->dev, &nd_pfn->ndns);
-	ida_simple_remove(&nd_region->pfn_ida, nd_pfn->id);
+	ida_free(&nd_region->pfn_ida, nd_pfn->id);
 	kfree(nd_pfn->uuid);
 	kfree(nd_pfn);
 }
@@ -321,7 +321,7 @@ static struct nd_pfn *nd_pfn_alloc(struct nd_region *nd_region)
 	if (!nd_pfn)
 		return NULL;
 
-	nd_pfn->id = ida_simple_get(&nd_region->pfn_ida, 0, 0, GFP_KERNEL);
+	nd_pfn->id = ida_alloc(&nd_region->pfn_ida, GFP_KERNEL);
 	if (nd_pfn->id < 0) {
 		kfree(nd_pfn);
 		return NULL;
-- 
2.25.1


