Return-Path: <nvdimm+bounces-6040-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 244747068B3
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 May 2023 14:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ACCB1C20969
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 May 2023 12:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F374718B18;
	Wed, 17 May 2023 12:55:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06F18B16
	for <nvdimm@lists.linux.dev>; Wed, 17 May 2023 12:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1ABC433EF;
	Wed, 17 May 2023 12:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684328138;
	bh=xzTFDNsRybxFIhfNkT5pB/3ffJE+aIzn77Ij9JsNwhQ=;
	h=From:To:Cc:Subject:Date:From;
	b=rEDgMEQLFO1dHrTu7bk05PSagPHSLbTz1soCR9EqbVytR1qDw1CdCDpr1gTBIArLp
	 4Cw0/Ce9LHK5C0X9w9BavIkXm8rDgBeduEKjGPPyZ9FVgRUWbbSd0T1RKcpDwx8Rqg
	 f75QcnNaqJn2rS+98JjDV2RveeLeB3EF8HAaLFhGPhBMJdwoI3QNA6/8xCuFjJJAk4
	 Ib+SHm+mYwlO33nBBfFnkCYn8wbzMirsE4hPYInVtidxX7Zx4tj1ZPPZqO94cpzHs8
	 pQYzRbnQMwJ4d5zNG9wnmNYRy7fFZ47xzC/cc3ZKSlwxzdHUZLCNgHHeZfDL6dE8KF
	 wNPaEFdrVTzvw==
From: Arnd Bergmann <arnd@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jane Chu <jane.chu@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Gregory Price <gregory.price@memverge.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dax: fix missing-prototype warnings
Date: Wed, 17 May 2023 14:55:09 +0200
Message-Id: <20230517125532.931157-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

dev_dax_probe declaration for this function was removed with the only
caller outside of device.c. Mark it static to avoid a W=1
warning:
drivers/dax/device.c:399:5: error: no previous prototype for 'dev_dax_probe'

Similarly, run_dax() causes a warning, but this one is because the
declaration needs to be included:

drivers/dax/super.c:337:6: error: no previous prototype for 'run_dax'

Fixes: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/dax/device.c | 3 +--
 drivers/dax/super.c  | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index af9930c03c9c..30665a3ff6ea 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -396,7 +396,7 @@ static void dev_dax_kill(void *dev_dax)
 	kill_dev_dax(dev_dax);
 }
 
-int dev_dax_probe(struct dev_dax *dev_dax)
+static int dev_dax_probe(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct device *dev = &dev_dax->dev;
@@ -471,7 +471,6 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	run_dax(dax_dev);
 	return devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
 }
-EXPORT_SYMBOL_GPL(dev_dax_probe);
 
 static struct dax_device_driver device_dax_driver = {
 	.probe = dev_dax_probe,
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c4c4728a36e4..8c05dae19bfe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -14,6 +14,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include "dax-private.h"
+#include "bus.h"
 
 /**
  * struct dax_device - anchor object for dax services
-- 
2.39.2


