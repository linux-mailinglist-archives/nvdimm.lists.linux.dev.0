Return-Path: <nvdimm+bounces-6216-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAED173A35E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jun 2023 16:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F83B1C210D6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jun 2023 14:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A616B1E539;
	Thu, 22 Jun 2023 14:43:16 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF8918AF0
	for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 14:43:12 +0000 (UTC)
Received: from ed3e173716be.home.arpa (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowAAXHcWBW5RkGTrGAg--.21392S2;
	Thu, 22 Jun 2023 22:32:34 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: ira.weiny@intel.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	oohall@gmail.com,
	aneesh.kumar@linux.ibm.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] libnvdimm/of_pmem: Replace kstrdup with devm_kstrdup and add check
Date: Thu, 22 Jun 2023 22:32:32 +0800
Message-Id: <20230622143232.16863-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXHcWBW5RkGTrGAg--.21392S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFWfWr4fZrW5ZrWrAFWfGrg_yoWDWFgEkr
	1UXa43Wr4UCa9IkwsIywnakr9Ikw48uF4ruF1Fq3W3Ja98KF13JrWUArn8G393Zrn7JFsr
	Cr4DtFn8Jry7GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJV
	WxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6ry5
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbkR65UUUUU==
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/

Replace kstrdup() with devm_kstrdup() to avoid memory leak and
add check for the return value of the devm_kstrdup() to avoid
NULL pointer dereference

Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/nvdimm/of_pmem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 10dbdcdfb9ce..5106dfe0147b 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -30,7 +30,12 @@ static int of_pmem_region_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);
+	priv->bus_desc.provider_name = devm_kstrdup(pdev->name, GFP_KERNEL);
+	if (!priv->bus_desc.provider_name) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
 	priv->bus_desc.module = THIS_MODULE;
 	priv->bus_desc.of_node = np;
 
-- 
2.25.1


