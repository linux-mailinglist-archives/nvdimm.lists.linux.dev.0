Return-Path: <nvdimm+bounces-6577-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9586178BD34
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Aug 2023 05:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DA75280F72
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Aug 2023 03:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFADEA9;
	Tue, 29 Aug 2023 03:17:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F59A47
	for <nvdimm@lists.linux.dev>; Tue, 29 Aug 2023 03:17:26 +0000 (UTC)
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowABnbY09Y+1kHcQ+Bw--.20458S2;
	Tue, 29 Aug 2023 11:17:17 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	oohall@gmail.com
Cc: aneesh.kumar@linux.ibm.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH v2] nvdimm: of_pmem: Check return value and add kfree for kstrdup
Date: Tue, 29 Aug 2023 03:16:37 +0000
Message-Id: <20230829031637.8103-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnbY09Y+1kHcQ+Bw--.20458S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKw4kGr4UAry3tFWfCr48Zwb_yoWDuFgEkr
	1UXFySgr48CwsIk39Fywna9r9Ika18uF4rZr1ag3W5XF9rAF43JrWUZrn5GwsxZrs7JF9F
	kr1jkF98Cr17JjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
	Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUnQ6pDUUUU
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Check the return value of kstrdup() and add kfree() for kstrdup() to 
avoid memory leak.

Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
Changelog:

v1 -> v2:

1.Add a fixes tag.
2.Update commit message.
---
 drivers/nvdimm/of_pmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 10dbdcdfb9ce..fe6edb7e6631 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -31,11 +31,17 @@ static int of_pmem_region_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);
+	if (!priv->bus_desc.provider_name) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
 	priv->bus_desc.module = THIS_MODULE;
 	priv->bus_desc.of_node = np;
 
 	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
 	if (!bus) {
+		kfree(priv->bus_desc.provider_name);
 		kfree(priv);
 		return -ENODEV;
 	}
-- 
2.25.1


