Return-Path: <nvdimm+bounces-7030-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D4680B9E5
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Dec 2023 09:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A39371C2084C
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Dec 2023 08:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CCE6FB4;
	Sun, 10 Dec 2023 08:58:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5A2522F
	for <nvdimm@lists.linux.dev>; Sun, 10 Dec 2023 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from localhost.localdomain (unknown [10.192.120.142])
	by mail-app3 (Coremail) with SMTP id cC_KCgB3f4+qfXVl+7eqAA--.2815S4;
	Sun, 10 Dec 2023 16:58:25 +0800 (CST)
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
To: dinghao.liu@zju.edu.cn
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] nvdimm-btt: fix several memleaks
Date: Sun, 10 Dec 2023 16:58:17 +0800
Message-Id: <20231210085817.30161-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:cC_KCgB3f4+qfXVl+7eqAA--.2815S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGF1kuF4rJrWUGF4UAw17Awb_yoWrtFy8pF
	4fJF98tFs8JFs7ur1DJ3yDu34aka1rKFyUKFy5Cw1Fyr15Aw4jqF4rCF15Z3s0krWrZ3W3
	CFWktw1UKr4UAw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
	1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
	18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgcFBmV0OhUYjgAAsu
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Resources allocated by kcalloc() in btt_freelist_init(),
btt_rtt_init(), and btt_maplocks_init() are not correctly
released in their callers when an error happens. For
example, when an error happens in btt_freelist_init(), its
caller discover_arenas() will directly free arena, which makes
arena->freelist a leaked memory. Fix these memleaks by using
devm_kcalloc() to make the memory auto-freed on driver detach.

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---

Changelog:

v2: -Use devm_kcalloc() to fix the memleaks.
    -Fix the potential leaked memory in btt_rtt_init()
     and btt_maplocks_init().
---
 drivers/nvdimm/btt.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index d5593b0dc700..c55231f42617 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -531,13 +531,13 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 	return ret;
 }
 
-static int btt_freelist_init(struct arena_info *arena)
+static int btt_freelist_init(struct device *dev, struct arena_info *arena)
 {
 	int new, ret;
 	struct log_entry log_new;
 	u32 i, map_entry, log_oldmap, log_newmap;
 
-	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
+	arena->freelist = devm_kcalloc(dev, arena->nfree, sizeof(struct free_entry),
 					GFP_KERNEL);
 	if (!arena->freelist)
 		return -ENOMEM;
@@ -718,20 +718,20 @@ static int log_set_indices(struct arena_info *arena)
 	return 0;
 }
 
-static int btt_rtt_init(struct arena_info *arena)
+static int btt_rtt_init(struct device *dev, struct arena_info *arena)
 {
-	arena->rtt = kcalloc(arena->nfree, sizeof(u32), GFP_KERNEL);
+	arena->rtt = devm_kcalloc(dev, arena->nfree, sizeof(u32), GFP_KERNEL);
 	if (arena->rtt == NULL)
 		return -ENOMEM;
 
 	return 0;
 }
 
-static int btt_maplocks_init(struct arena_info *arena)
+static int btt_maplocks_init(struct device *dev, struct arena_info *arena)
 {
 	u32 i;
 
-	arena->map_locks = kcalloc(arena->nfree, sizeof(struct aligned_lock),
+	arena->map_locks = devm_kcalloc(dev, arena->nfree, sizeof(struct aligned_lock),
 				GFP_KERNEL);
 	if (!arena->map_locks)
 		return -ENOMEM;
@@ -805,9 +805,6 @@ static void free_arenas(struct btt *btt)
 
 	list_for_each_entry_safe(arena, next, &btt->arena_list, list) {
 		list_del(&arena->list);
-		kfree(arena->rtt);
-		kfree(arena->map_locks);
-		kfree(arena->freelist);
 		debugfs_remove_recursive(arena->debugfs_dir);
 		kfree(arena);
 	}
@@ -843,7 +840,7 @@ static void parse_arena_meta(struct arena_info *arena, struct btt_sb *super,
 	arena->flags = le32_to_cpu(super->flags);
 }
 
-static int discover_arenas(struct btt *btt)
+static int discover_arenas(struct device *dev, struct btt *btt)
 {
 	int ret = 0;
 	struct arena_info *arena;
@@ -893,15 +890,15 @@ static int discover_arenas(struct btt *btt)
 			goto out;
 		}
 
-		ret = btt_freelist_init(arena);
+		ret = btt_freelist_init(dev, arena);
 		if (ret)
 			goto out;
 
-		ret = btt_rtt_init(arena);
+		ret = btt_rtt_init(dev, arena);
 		if (ret)
 			goto out;
 
-		ret = btt_maplocks_init(arena);
+		ret = btt_maplocks_init(dev, arena);
 		if (ret)
 			goto out;
 
@@ -1022,7 +1019,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
  * This function completes the initialization for the BTT namespace
  * such that it is ready to accept IOs
  */
-static int btt_meta_init(struct btt *btt)
+static int btt_meta_init(struct device *dev, struct btt *btt)
 {
 	int ret = 0;
 	struct arena_info *arena;
@@ -1033,15 +1030,15 @@ static int btt_meta_init(struct btt *btt)
 		if (ret)
 			goto unlock;
 
-		ret = btt_freelist_init(arena);
+		ret = btt_freelist_init(dev, arena);
 		if (ret)
 			goto unlock;
 
-		ret = btt_rtt_init(arena);
+		ret = btt_rtt_init(dev, arena);
 		if (ret)
 			goto unlock;
 
-		ret = btt_maplocks_init(arena);
+		ret = btt_maplocks_init(dev, arena);
 		if (ret)
 			goto unlock;
 	}
@@ -1584,7 +1581,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	nsio = to_nd_namespace_io(&nd_btt->ndns->dev);
 	btt->phys_bb = &nsio->bb;
 
-	ret = discover_arenas(btt);
+	ret = discover_arenas(dev, btt);
 	if (ret) {
 		dev_err(dev, "init: error in arena_discover: %d\n", ret);
 		return NULL;
@@ -1606,7 +1603,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 			return NULL;
 		}
 
-		ret = btt_meta_init(btt);
+		ret = btt_meta_init(dev, btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
 			return NULL;
-- 
2.17.1


