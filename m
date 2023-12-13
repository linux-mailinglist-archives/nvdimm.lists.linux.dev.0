Return-Path: <nvdimm+bounces-7032-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0166980BC53
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Dec 2023 18:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95313B2089F
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Dec 2023 17:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E971863E;
	Sun, 10 Dec 2023 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Ym/78Ppf"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAAB7472
	for <nvdimm@lists.linux.dev>; Sun, 10 Dec 2023 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from pop-os.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id CNMfrZCRcvumxCNMgrCEpi; Sun, 10 Dec 2023 18:13:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1702228396;
	bh=rcjCWYjJHAMlpZ0Yk1Euqbw2V9DTH6RMOjoIxBb+Yi8=;
	h=From:To:Cc:Subject:Date;
	b=Ym/78PpfeJGeur44+gRGBXxG75EXyjCRCalSoudtmzKt2SWfHwM46nXPBjSRpL9q3
	 5pM+69VDDlCUVxdQouaYxN6MYzZyCBHUAGUSx9PXL6QAQnPLJFFlvao3J6fdGDL6un
	 O19DKLiL8cMyalwsKr2A6aZjw8SX8oX2U9SD6vHlf9ptAZnQaUKaFexSyYUzmFdvy5
	 y4Ed0DpGtftzHZCdLea3o+hfr9FLd27GWpTpd0y/n9zF0+MF48N33+oWHfxskexQTo
	 tD+2YIf1nccFQmhAaNdZR4+3dHQiGtj6VDM63g3oFsgBY0kaFdauq8m+yEvtsOOat1
	 QYjSPNk/gEMSw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 10 Dec 2023 18:13:16 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	nvdimm@lists.linux.dev
Subject: [PATCH] nvdimm: Remove usage of the deprecated ida_simple_xx() API
Date: Sun, 10 Dec 2023 18:13:09 +0100
Message-Id: <50719568e4108f65f3b989ba05c1563e17afba3f.1702228319.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nvdimm/btt_devs.c       | 6 +++---
 drivers/nvdimm/bus.c            | 4 ++--
 drivers/nvdimm/dax_devs.c       | 4 ++--
 drivers/nvdimm/dimm_devs.c      | 4 ++--
 drivers/nvdimm/namespace_devs.c | 7 +++----
 drivers/nvdimm/pfn_devs.c       | 4 ++--
 6 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index fabbb31f2c35..497fd434a6a1 100644
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
@@ -191,7 +191,7 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
 	if (!nd_btt)
 		return NULL;
 
-	nd_btt->id = ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);
+	nd_btt->id = ida_alloc(&nd_region->btt_ida, GFP_KERNEL);
 	if (nd_btt->id < 0)
 		goto out_nd_btt;
 
@@ -217,7 +217,7 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
 	return dev;
 
 out_put_id:
-	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
+	ida_free(&nd_region->btt_ida, nd_btt->id);
 
 out_nd_btt:
 	kfree(nd_btt);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 5852fe290523..ef3d0f83318b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -285,7 +285,7 @@ static void nvdimm_bus_release(struct device *dev)
 	struct nvdimm_bus *nvdimm_bus;
 
 	nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
-	ida_simple_remove(&nd_ida, nvdimm_bus->id);
+	ida_free(&nd_ida, nvdimm_bus->id);
 	kfree(nvdimm_bus);
 }
 
@@ -342,7 +342,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	INIT_LIST_HEAD(&nvdimm_bus->list);
 	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
 	init_waitqueue_head(&nvdimm_bus->wait);
-	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	nvdimm_bus->id = ida_alloc(&nd_ida, GFP_KERNEL);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
 		return NULL;
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 3bd61f245788..6b4922de3047 100644
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
index 1273873582be..3ceddae0509f 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -194,7 +194,7 @@ static void nvdimm_release(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	ida_simple_remove(&dimm_ida, nvdimm->id);
+	ida_free(&dimm_ida, nvdimm->id);
 	kfree(nvdimm);
 }
 
@@ -592,7 +592,7 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	if (!nvdimm)
 		return NULL;
 
-	nvdimm->id = ida_simple_get(&dimm_ida, 0, 0, GFP_KERNEL);
+	nvdimm->id = ida_alloc(&dimm_ida, GFP_KERNEL);
 	if (nvdimm->id < 0) {
 		kfree(nvdimm);
 		return NULL;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 07177eadc56e..fa1202e848d9 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -27,7 +27,7 @@ static void namespace_pmem_release(struct device *dev)
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 
 	if (nspm->id >= 0)
-		ida_simple_remove(&nd_region->ns_ida, nspm->id);
+		ida_free(&nd_region->ns_ida, nspm->id);
 	kfree(nspm->alt_name);
 	kfree(nspm->uuid);
 	kfree(nspm);
@@ -1810,7 +1810,7 @@ static struct device *nd_namespace_pmem_create(struct nd_region *nd_region)
 	res->name = dev_name(&nd_region->dev);
 	res->flags = IORESOURCE_MEM;
 
-	nspm->id = ida_simple_get(&nd_region->ns_ida, 0, 0, GFP_KERNEL);
+	nspm->id = ida_alloc(&nd_region->ns_ida, GFP_KERNEL);
 	if (nspm->id < 0) {
 		kfree(nspm);
 		return NULL;
@@ -2188,8 +2188,7 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 			struct nd_namespace_pmem *nspm;
 
 			nspm = to_nd_namespace_pmem(dev);
-			id = ida_simple_get(&nd_region->ns_ida, 0, 0,
-					    GFP_KERNEL);
+			id = ida_alloc(&nd_region->ns_ida, GFP_KERNEL);
 			nspm->id = id;
 		} else
 			id = i;
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 0d08e21a1cea..586348125b61 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -22,7 +22,7 @@ static void nd_pfn_release(struct device *dev)
 
 	dev_dbg(dev, "trace\n");
 	nd_detach_ndns(&nd_pfn->dev, &nd_pfn->ndns);
-	ida_simple_remove(&nd_region->pfn_ida, nd_pfn->id);
+	ida_free(&nd_region->pfn_ida, nd_pfn->id);
 	kfree(nd_pfn->uuid);
 	kfree(nd_pfn);
 }
@@ -326,7 +326,7 @@ static struct nd_pfn *nd_pfn_alloc(struct nd_region *nd_region)
 	if (!nd_pfn)
 		return NULL;
 
-	nd_pfn->id = ida_simple_get(&nd_region->pfn_ida, 0, 0, GFP_KERNEL);
+	nd_pfn->id = ida_alloc(&nd_region->pfn_ida, GFP_KERNEL);
 	if (nd_pfn->id < 0) {
 		kfree(nd_pfn);
 		return NULL;
-- 
2.34.1


