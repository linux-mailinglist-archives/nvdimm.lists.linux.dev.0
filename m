Return-Path: <nvdimm+bounces-4823-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4396C5C01B5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 17:33:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F4301C2098A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 15:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBAD5CB9;
	Wed, 21 Sep 2022 15:33:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D05A97
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774399; x=1695310399;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4qjbB7qrrNMduiAlaEfkM/oScb+4kC9ooHVEGxNEn2E=;
  b=j9L+ZHZQ+zitx1TS1PJXc8LXAmRpJLnTyfammNoJ8ANUDX+/rgvmhdQG
   vbceGgI0pnVOGxLfcVPgeGZpfVqEQyUqRcUQke2aGaUV8PcAj5EYmuegH
   nwlFc4GSB8Eh+mFVrGGAdsxLwunmtkipv0H8mYTyjtMpDjfEGb8Hf5gSt
   0hRenAmR7sUksZfil0IaOjiZA2MLotCUhlFtN/ee6z4o/LY/OZoai3hch
   lCZ1CnJBAfzlw6GnyiURdXWJATm9Wtxa8amYzLq7119gkQcSJ5eIxvu2w
   TP9CvzA48RUINP7m9aOb9iJjeWt6yy7jM0G0H/9L1/mOrScsVE3hRWxju
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300877254"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300877254"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:33:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="723257340"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:33:15 -0700
Subject: [PATCH v2 18/19] libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST
 flag
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:33:15 -0700
Message-ID: 
 <166377439534.430546.10690686781480251163.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

nfit_test overrode the security_show() sysfs attribute function in nvdimm
dimm_devs in order to allow testing of security unlock. With the
introduction of CXL security commands, the trick to override
security_show() becomes significantly more complicated. By introdcing a
security flag CONFIG_NVDIMM_SECURITY_TEST, libnvdimm can just toggle the
check via a compile option. In addition the original override can can be
removed from tools/testing/nvdimm/.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/Kconfig           |    9 +++++++++
 drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
 drivers/nvdimm/security.c        |    4 ++++
 tools/testing/nvdimm/Kbuild      |    1 -
 tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
 5 files changed, 21 insertions(+), 32 deletions(-)
 delete mode 100644 tools/testing/nvdimm/dimm_devs.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5a29046e3319..fd336d138eda 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -114,4 +114,13 @@ config NVDIMM_TEST_BUILD
 	  core devm_memremap_pages() implementation and other
 	  infrastructure.
 
+config NVDIMM_SECURITY_TEST
+	bool "Nvdimm security test code toggle"
+	depends on NVDIMM_KEYS
+	help
+	  Debug flag for security testing when using nfit_test or cxl_test
+	  modules in tools/testing/.
+
+	  Select Y if using nfit_test or cxl_test for security testing.
+
 endif
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c7c980577491..1fc081dcf631 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -349,11 +349,18 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
-__weak ssize_t security_show(struct device *dev,
+ssize_t security_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
+	/*
+	 * For the test version we need to poll the "hardware" in order
+	 * to get the updated status for unlock testing.
+	 */
+	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
+		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
+
 	if (test_bit(NVDIMM_SECURITY_OVERWRITE, &nvdimm->sec.flags))
 		return sprintf(buf, "overwrite\n");
 	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index c1c9d0feae9d..6ae924d8f2d7 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| !nvdimm->sec.flags)
 		return -EIO;
 
+	/* While nfit_test does not need this, cxl_test does */
+	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
+		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
+
 	/* No need to go further if security is disabled */
 	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
 		return 0;
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 5eb5c23b062f..8153251ea389 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -79,7 +79,6 @@ libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
 libnvdimm-$(CONFIG_NVDIMM_KEYS) += $(NVDIMM_SRC)/security.o
-libnvdimm-y += dimm_devs.o
 libnvdimm-y += libnvdimm_test.o
 libnvdimm-y += config_check.o
 
diff --git a/tools/testing/nvdimm/dimm_devs.c b/tools/testing/nvdimm/dimm_devs.c
deleted file mode 100644
index 57bd27dedf1f..000000000000
--- a/tools/testing/nvdimm/dimm_devs.c
+++ /dev/null
@@ -1,30 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright Intel Corp. 2018 */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/nd.h>
-#include "pmem.h"
-#include "pfn.h"
-#include "nd.h"
-#include "nd-core.h"
-
-ssize_t security_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-
-	/*
-	 * For the test version we need to poll the "hardware" in order
-	 * to get the updated status for unlock testing.
-	 */
-	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
-
-	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
-		return sprintf(buf, "disabled\n");
-	if (test_bit(NVDIMM_SECURITY_UNLOCKED, &nvdimm->sec.flags))
-		return sprintf(buf, "unlocked\n");
-	if (test_bit(NVDIMM_SECURITY_LOCKED, &nvdimm->sec.flags))
-		return sprintf(buf, "locked\n");
-	return -ENOTTY;
-}



