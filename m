Return-Path: <nvdimm+bounces-6780-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 552D97C4D3F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Oct 2023 10:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B0D9282351
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Oct 2023 08:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13F018E2B;
	Wed, 11 Oct 2023 08:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hyuBPz+u"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F5C199CD
	for <nvdimm@lists.linux.dev>; Wed, 11 Oct 2023 08:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697013250; x=1728549250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQEJb1Lz3l1aI2jv3xJq6wSzHRp1z4wipFCT9nVMLO4=;
  b=hyuBPz+uU/MQwnCwXXXfnaQ1cX1KmiaiOyFTnfeROY+zuKEZoKO37wwu
   sn77yKzzNBV26Ih4q3j87NotN9bU/RoJ9ZzoFyMsBSm1FOzF6DFdV62nc
   sB7D8WypSFH/raz3kFmU2VnuXxXH5vcu22g0kzvDN3Id76NQ5tHiiuGlQ
   5eJsdJyilVpoXOx/5JlxO3JkZE/li4Cxj29m9/9Fedp4l4iT/yt+HbTj7
   ESRooswjdQElZ1H00bdehnmfjZogHb+uM3sD9AI5ACeOpVCFNrOrzwZ7W
   j/XoFj4YjmfUNNseg3EF4qGwDOk8EKtbKlA8R6epGbhuxLRXXbONn2Ij/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="388480225"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="388480225"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 01:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="897548215"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="897548215"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 01:32:23 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org
Cc: rafael@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	lenb@kernel.org,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v3 4/6] ACPI: AC: Rename ACPI device from device to adev
Date: Wed, 11 Oct 2023 11:33:32 +0300
Message-ID: <20231011083334.3987477-5-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011083334.3987477-1-michal.wilczynski@intel.com>
References: <20231011083334.3987477-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since transformation from ACPI driver to platform driver there are two
devices on which the driver operates - ACPI device and platform device.
For the sake of reader this calls for the distinction in their naming,
to avoid confusion. Rename device to adev, as corresponding
platform device is called pdev.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/ac.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 1dd4919be7ac..2618a7ccc11c 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -121,11 +121,11 @@ static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct device *dev = data;
 	struct acpi_ac *ac = dev_get_drvdata(dev);
-	struct acpi_device *device = ACPI_COMPANION(dev);
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 
 	switch (event) {
 	default:
-		acpi_handle_debug(device->handle, "Unsupported event [0x%x]\n",
+		acpi_handle_debug(adev->handle, "Unsupported event [0x%x]\n",
 				  event);
 		fallthrough;
 	case ACPI_AC_NOTIFY_STATUS:
@@ -142,11 +142,11 @@ static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
 			msleep(ac_sleep_before_get_state_ms);
 
 		acpi_ac_get_state(ac);
-		acpi_bus_generate_netlink_event(device->pnp.device_class,
+		acpi_bus_generate_netlink_event(adev->pnp.device_class,
 						dev_name(dev),
 						event,
 						ac->state);
-		acpi_notifier_call_chain(device, event, ac->state);
+		acpi_notifier_call_chain(adev, event, ac->state);
 		kobject_uevent(&ac->charger->dev.kobj, KOBJ_CHANGE);
 	}
 }
@@ -205,7 +205,7 @@ static const struct dmi_system_id ac_dmi_table[]  __initconst = {
 
 static int acpi_ac_probe(struct platform_device *pdev)
 {
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 	struct power_supply_config psy_cfg = {};
 	struct acpi_ac *ac;
 	int result;
@@ -214,9 +214,9 @@ static int acpi_ac_probe(struct platform_device *pdev)
 	if (!ac)
 		return -ENOMEM;
 
-	ac->device = device;
-	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
-	strcpy(acpi_device_class(device), ACPI_AC_CLASS);
+	ac->device = adev;
+	strcpy(acpi_device_name(adev), ACPI_AC_DEVICE_NAME);
+	strcpy(acpi_device_class(adev), ACPI_AC_CLASS);
 
 	platform_set_drvdata(pdev, ac);
 
@@ -226,7 +226,7 @@ static int acpi_ac_probe(struct platform_device *pdev)
 
 	psy_cfg.drv_data = ac;
 
-	ac->charger_desc.name = acpi_device_bid(device);
+	ac->charger_desc.name = acpi_device_bid(adev);
 	ac->charger_desc.type = POWER_SUPPLY_TYPE_MAINS;
 	ac->charger_desc.properties = ac_props;
 	ac->charger_desc.num_properties = ARRAY_SIZE(ac_props);
@@ -238,13 +238,13 @@ static int acpi_ac_probe(struct platform_device *pdev)
 		goto err_release_ac;
 	}
 
-	pr_info("%s [%s] (%s-line)\n", acpi_device_name(device),
-		acpi_device_bid(device), str_on_off(ac->state));
+	pr_info("%s [%s] (%s-line)\n", acpi_device_name(adev),
+		acpi_device_bid(adev), str_on_off(ac->state));
 
 	ac->battery_nb.notifier_call = acpi_ac_battery_notify;
 	register_acpi_notifier(&ac->battery_nb);
 
-	result = acpi_dev_install_notify_handler(device, ACPI_ALL_NOTIFY,
+	result = acpi_dev_install_notify_handler(adev, ACPI_ALL_NOTIFY,
 						 acpi_ac_notify, &pdev->dev);
 	if (result)
 		goto err_unregister;
-- 
2.41.0


