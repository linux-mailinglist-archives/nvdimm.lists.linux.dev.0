Return-Path: <nvdimm+bounces-6272-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D7774424C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 20:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58CF41C20C6E
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 18:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75385168AE;
	Fri, 30 Jun 2023 18:34:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A499616405
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688150057; x=1719686057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+TtSlxKV+HOo4L7ax/yjcsU33lOHTI/V/imUAW6Fx3I=;
  b=btY7t+oidXlfIlxczpE1qEwEFpZk2St6iKviEeJSX4fBaU78T338H28k
   q6oNcq4JTOodYoMzd54bNzVUPm45cpM4IhBR9uyMFvreci6NuBAfuFw7z
   u33aUNpweJB4rNDvDZfsHRFDsHrk65Ff7WyKU8LdbUgtR/00sSTXs9VJ5
   kZCNMa6djAtGJWfAalSJqEFgKcBsT+cOp9/8JCWGe5jAldEw40qypFgSq
   ZVsL8kSCvHjZRq9b8lghwGshBJ5wX7J1DQmnG5/MiJIqqzhCTxbcYdm32
   JCGK3CP1KVfs3hfDSF9jr82s9ofLNTmKwMgH3RuX/ki9x6gLjHLkeLtvW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365949953"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365949953"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717896436"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717896436"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:13 -0700
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
	Michal Wilczynski <michal.wilczynski@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v6 3/9] acpi/ac: Move handler installing logic to driver
Date: Fri, 30 Jun 2023 21:33:38 +0300
Message-ID: <20230630183344.891077-4-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630183344.891077-1-michal.wilczynski@intel.com>
References: <20230630183344.891077-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently logic for installing notifications from ACPI devices is
implemented using notify callback in struct acpi_driver. Preparations
are being made to replace acpi_driver with more generic struct
platform_driver, which doesn't contain notify callback. Furthermore
as of now handlers are being called indirectly through
acpi_notify_device(), which decreases performance.

Call acpi_dev_install_notify_handler() at the end of .add() callback.
Call acpi_dev_remove_notify_handler() at the beginning of .remove()
callback. Change arguments passed to the notify function to match with
what's required by acpi_dev_install_notify_handler(). Remove .notify
callback initialization in acpi_driver.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/ac.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 1ace70b831cd..f6feff1f3118 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -34,7 +34,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_ac_add(struct acpi_device *device);
 static void acpi_ac_remove(struct acpi_device *device);
-static void acpi_ac_notify(struct acpi_device *device, u32 event);
+static void acpi_ac_notify(acpi_handle handle, u32 event, void *data);
 
 static const struct acpi_device_id ac_device_ids[] = {
 	{"ACPI0003", 0},
@@ -54,11 +54,9 @@ static struct acpi_driver acpi_ac_driver = {
 	.name = "ac",
 	.class = ACPI_AC_CLASS,
 	.ids = ac_device_ids,
-	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
 		.add = acpi_ac_add,
 		.remove = acpi_ac_remove,
-		.notify = acpi_ac_notify,
 		},
 	.drv.pm = &acpi_ac_pm,
 };
@@ -128,8 +126,9 @@ static enum power_supply_property ac_props[] = {
 };
 
 /* Driver Model */
-static void acpi_ac_notify(struct acpi_device *device, u32 event)
+static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
 {
+	struct acpi_device *device = data;
 	struct acpi_ac *ac = acpi_driver_data(device);
 
 	if (!ac)
@@ -235,7 +234,7 @@ static int acpi_ac_add(struct acpi_device *device)
 
 	result = acpi_ac_get_state(ac);
 	if (result)
-		goto end;
+		goto err_release_ac;
 
 	psy_cfg.drv_data = ac;
 
@@ -248,7 +247,7 @@ static int acpi_ac_add(struct acpi_device *device)
 					    &ac->charger_desc, &psy_cfg);
 	if (IS_ERR(ac->charger)) {
 		result = PTR_ERR(ac->charger);
-		goto end;
+		goto err_release_ac;
 	}
 
 	pr_info("%s [%s] (%s)\n", acpi_device_name(device),
@@ -256,9 +255,20 @@ static int acpi_ac_add(struct acpi_device *device)
 
 	ac->battery_nb.notifier_call = acpi_ac_battery_notify;
 	register_acpi_notifier(&ac->battery_nb);
-end:
+
+	result = acpi_dev_install_notify_handler(device,
+						 ACPI_ALL_NOTIFY,
+						 acpi_ac_notify);
 	if (result)
-		kfree(ac);
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	power_supply_unregister(ac->charger);
+	unregister_acpi_notifier(&ac->battery_nb);
+err_release_ac:
+	kfree(ac);
 
 	return result;
 }
@@ -297,6 +307,9 @@ static void acpi_ac_remove(struct acpi_device *device)
 
 	ac = acpi_driver_data(device);
 
+	acpi_dev_remove_notify_handler(device,
+				       ACPI_ALL_NOTIFY,
+				       acpi_ac_notify);
 	power_supply_unregister(ac->charger);
 	unregister_acpi_notifier(&ac->battery_nb);
 
-- 
2.41.0


