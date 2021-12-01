Return-Path: <nvdimm+bounces-2133-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B3D465351
	for <lists+linux-nvdimm@lfdr.de>; Wed,  1 Dec 2021 17:49:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 45AAE3E0E7A
	for <lists+linux-nvdimm@lfdr.de>; Wed,  1 Dec 2021 16:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F2C2CA8;
	Wed,  1 Dec 2021 16:48:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A82C9D
	for <nvdimm@lists.linux.dev>; Wed,  1 Dec 2021 16:48:53 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 71F7021155;
	Wed,  1 Dec 2021 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1638377332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZKC77PkRmt0LF81L8tNeddd6Z7fS1292wB4TtyQg1o=;
	b=x/nw4L3295nBKy0igKSy9CSbR92h8z2AZlAlBhzAAorTdvD6oNdFYmOpvfC4YWeTudyTFG
	9nW5KTTn4Av52zqdEYRcbINBv1OZha1yHN0lXkk3dNKIU51Q2yYHHB5goQtGFbv2lFiqGc
	zpuCLVp/hSylcMIlKT23TW/dbkpHK4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1638377332;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZKC77PkRmt0LF81L8tNeddd6Z7fS1292wB4TtyQg1o=;
	b=tXkJajbJhS3Zrr2scZ16SpnUxc3LADSEB8+jR4nRRjStcG/ZFwqkrviCveL3LOi8qFwZHm
	ewYFVPwI/Y/rVrCg==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id E47E1A3B85;
	Wed,  1 Dec 2021 16:48:49 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: dan.williams@intel.com
Cc: nvdimm@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH v2] libnvdimm: call devm_namespace_disable() on error
Date: Thu,  2 Dec 2021 00:48:44 +0800
Message-Id: <20211201164844.125296-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

Once devm_namespace_enable() has been called the error path in the
calling function will not call devm_namespace_disable(), leaving the
namespace enabled on error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Santosh Sivaraj <santosh@fossix.org>
---
Changelog,
v2: fix the errors by review comments from Santosh,
    - don't call devm_namespace_disable() in nd_pfn_clear_memmap_errors().
    - change EOPNOTSUPP to -EOPNOTSUPP in nd_pmem_probe()
    rebase the patch against latest mainline kernel.
v1: the initial version for review.

 drivers/dax/pmem/core.c |  2 +-
 drivers/nvdimm/btt.c    |  5 ++++-
 drivers/nvdimm/claim.c  |  9 +++++++--
 drivers/nvdimm/pmem.c   | 20 ++++++++++----------
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/pmem/core.c b/drivers/dax/pmem/core.c
index 062e8bc14223..215ce6ed5693 100644
--- a/drivers/dax/pmem/core.c
+++ b/drivers/dax/pmem/core.c
@@ -32,9 +32,9 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 	if (rc)
 		return ERR_PTR(rc);
 	rc = nvdimm_setup_pfn(nd_pfn, &pgmap);
+	devm_namespace_disable(dev, ndns);
 	if (rc)
 		return ERR_PTR(rc);
-	devm_namespace_disable(dev, ndns);
 
 	/* reserve the metadata area, device-dax will reserve the data */
 	pfn_sb = nd_pfn->pfn_sb;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index da3f007a1211..4c47f629a06c 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1695,13 +1695,16 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 		dev_dbg(&nd_btt->dev, "%s must be at least %ld bytes\n",
 				dev_name(&ndns->dev),
 				ARENA_MIN_SIZE + nd_btt->initial_offset);
+		devm_namespace_disable(&nd_btt->dev, ndns);
 		return -ENXIO;
 	}
 	nd_region = to_nd_region(nd_btt->dev.parent);
 	btt = btt_init(nd_btt, rawsize, nd_btt->lbasize, nd_btt->uuid,
 		       nd_region);
-	if (!btt)
+	if (!btt) {
+		devm_namespace_disable(&nd_btt->dev, ndns);
 		return -ENOMEM;
+	}
 	nd_btt->btt = btt;
 
 	return 0;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 030dbde6b088..cd9aa41d526b 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -318,13 +318,18 @@ int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio,
 	}
 
 	ndns->rw_bytes = nsio_rw_bytes;
-	if (devm_init_badblocks(dev, &nsio->bb))
+	if (devm_init_badblocks(dev, &nsio->bb)) {
+		devm_release_mem_region(dev, range.start, size);
 		return -ENOMEM;
+	}
 	nvdimm_badblocks_populate(to_nd_region(ndns->dev.parent), &nsio->bb,
 			&range);
 
 	nsio->addr = devm_memremap(dev, range.start, size, ARCH_MEMREMAP_PMEM);
-
+	if (IS_ERR(nsio->addr)) {
+		devm_exit_badblocks(dev, &nsio->bb);
+		devm_release_mem_region(dev, range.start, size);
+	}
 	return PTR_ERR_OR_ZERO(nsio->addr);
 }
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fe7ece1534e1..5230dd04e349 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -416,8 +416,10 @@ static int pmem_attach_disk(struct device *dev,
 	if (is_nd_pfn(dev)) {
 		nd_pfn = to_nd_pfn(dev);
 		rc = nvdimm_setup_pfn(nd_pfn, &pmem->pgmap);
-		if (rc)
+		if (rc) {
+			devm_namespace_disable(dev, ndns);
 			return rc;
+		}
 	}
 
 	/* we're attaching a block device, disable raw namespace access */
@@ -564,17 +566,15 @@ static int nd_pmem_probe(struct device *dev)
 	ret = nd_pfn_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
-		return ret;
-
-	ret = nd_dax_probe(dev, ndns);
-	if (ret == 0)
-		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
-		return ret;
-
+	else if (ret != -EOPNOTSUPP) {
+		ret = nd_dax_probe(dev, ndns);
+		if (ret == 0)
+			return -ENXIO;
+	}
 	/* probe complete, attach handles namespace enabling */
 	devm_namespace_disable(dev, ndns);
+	if (ret == -EOPNOTSUPP)
+		return ret;
 
 	return pmem_attach_disk(dev, ndns);
 }
-- 
2.31.1


