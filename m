Return-Path: <nvdimm+bounces-4757-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC0E5BB6B7
	for <lists+linux-nvdimm@lfdr.de>; Sat, 17 Sep 2022 08:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 892EE1C209A7
	for <lists+linux-nvdimm@lfdr.de>; Sat, 17 Sep 2022 06:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A674F626;
	Sat, 17 Sep 2022 06:41:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239E839D
	for <nvdimm@lists.linux.dev>; Sat, 17 Sep 2022 06:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=n9TQa
	rA5HFDvEKCCTRUTj+Y9jic5HRzWblDS8dMVBcs=; b=piZsHqUmKrV9g5gYH+XAj
	slB5OEMIlxz0ZAfscZrxoOeOlX3lAZ/AkcO5Z9mIhOHDuouF0n15Dk/E0G9WNpUR
	CRn6XiG9w8tbgpts5xEtDjRKFKeeaG5xhILoM9KDL/puwJSbz/9Jl3yjoFnqESy0
	vSa0KKfeecrW10IAbF9jsc=
Received: from DESKTOP-CE2KKHI.localdomain (unknown [124.160.210.227])
	by smtp2 (Coremail) with SMTP id GtxpCgC3K+5_aCVj8qg3eQ--.56440S2;
	Sat, 17 Sep 2022 14:26:09 +0800 (CST)
From: williamsukatube@163.com
To: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	William Dean <williamsukatube@163.com>
Subject: [PATH -next] device-dax: simplify code in devm_register_dax_mapping
Date: Sat, 17 Sep 2022 14:26:06 +0800
Message-Id: <20220917062606.1701-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:GtxpCgC3K+5_aCVj8qg3eQ--.56440S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFWfAFWDuw4xtr1fGFWrGrg_yoW3trX_Gr
	yrAFyxWwnIg3WfGw17Crn3Zry3tF1DuF4fZrs0qa43Gw18Ca1kuF4vyrnrCr97XrWxWr98
	t3Z0gr1FyFnrGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRM5l8DUUUUU==
X-Originating-IP: [124.160.210.227]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/1tbiUQF-g2DEPMIy+wAAs-

From: William Dean <williamsukatube@163.com>

It could directly return 'devm_add_action_or_reset' to simplify code.

Signed-off-by: William Dean <williamsukatube@163.com>
---
 drivers/dax/bus.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..251c53061764 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -772,11 +772,8 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 		return rc;
 	}
 
-	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_mapping,
+	return devm_add_action_or_reset(dax_region->dev, unregister_dax_mapping,
 			dev);
-	if (rc)
-		return rc;
-	return 0;
 }
 
 static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
-- 
2.25.1


