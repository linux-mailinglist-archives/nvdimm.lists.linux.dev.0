Return-Path: <nvdimm+bounces-4791-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BABED5BF269
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 02:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB0811C2096D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 00:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0031389;
	Wed, 21 Sep 2022 00:46:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A21365
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 00:46:26 +0000 (UTC)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id PZN00112;
        Wed, 21 Sep 2022 08:44:12 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201608.home.langchao.com (10.100.2.8) with Microsoft SMTP Server id
 15.1.2507.12; Wed, 21 Sep 2022 08:44:12 +0800
From: Bo Liu <liubo03@inspur.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Bo Liu
	<liubo03@inspur.com>
Subject: [PATCH v2 1/1] dax: Check dev_set_name() return value
Date: Tue, 20 Sep 2022 20:44:06 -0400
Message-ID: <20220921004406.2560-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid: 20229210844123c3628e480bf2508a5a076800163e699
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

It's possible that dev_set_name() returns -ENOMEM, catch and handle this.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 Changes from v1:
 -use put_device() replace free()
	
 drivers/dax/bus.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..2e736c7df46c 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -765,7 +765,12 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	device_initialize(dev);
 	dev->parent = &dev_dax->dev;
 	dev->type = &dax_mapping_type;
-	dev_set_name(dev, "mapping%d", mapping->id);
+	rc = dev_set_name(dev, "mapping%d", mapping->id);
+	if (rc) {
+		put_device(dev);
+		return rc;
+	}
+
 	rc = device_add(dev);
 	if (rc) {
 		put_device(dev);
@@ -1334,7 +1339,9 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	dev_dax->region = dax_region;
 	dev = &dev_dax->dev;
 	device_initialize(dev);
-	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
+	rc = dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
+	if (rc)
+		goto err_range;
 
 	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
 	if (rc)
-- 
2.27.0


