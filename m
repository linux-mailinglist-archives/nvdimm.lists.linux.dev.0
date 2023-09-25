Return-Path: <nvdimm+bounces-6634-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FBC7ADA49
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Sep 2023 16:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sv.mirrors.kernel.org (Postfix) with ESMTP id 753F22814D2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Sep 2023 14:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307211C294;
	Mon, 25 Sep 2023 14:49:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DC21B26E
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695653364; x=1727189364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q+/woL1SUetoYx4WHnjb+jA28q5j/h55czCXRHM5v18=;
  b=EVi4jwC78Q1kyaVDxLOHzLEeZDGfnBCaQC5dthhyBxUmQ34rkB4u6e9r
   gmFQT2EcKdcqYtGagkSC59CveZKxXn2h6koVUbyd37cNkVrTtg4pfpoyo
   DOkVf0Uk2U4+emLvjtCRUzxWooTyihQq0n5gCIRATNbZadLCxYVksb/XB
   loyy79sN03mC6Mr330R9Fqhe+Px9f1fllLNUAJsnIR1vCZQxN9spafy7+
   cgnY+X4knkUYGiyuf38lZFAgYvQvlF2HLDQZACEOSVVTN44UqMTHVromg
   3rrtTOwSU7FDMsF1ZCIiIH9fo2bVOAyxIq7j608hoJYoXO220zdZsr/ad
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="378548006"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="378548006"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995409465"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995409465"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:20 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: rafael.j.wysocki@intel.com,
	andriy.shevchenko@intel.com,
	lenb@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v1 3/9] ACPI: AC: Remove unnecessary checks
Date: Mon, 25 Sep 2023 17:48:36 +0300
Message-ID: <20230925144842.586829-4-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230925144842.586829-1-michal.wilczynski@intel.com>
References: <20230925144842.586829-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unnecessary checks for NULL for variables that can't be NULL at
the point they're checked for it. Defensive programming is discouraged
in the kernel.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/ac.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 0b245f9f7ec8..dd04809a787c 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -131,9 +131,6 @@ static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
 	struct acpi_device *device = data;
 	struct acpi_ac *ac = acpi_driver_data(device);
 
-	if (!ac)
-		return;
-
 	switch (event) {
 	default:
 		acpi_handle_debug(device->handle, "Unsupported event [0x%x]\n",
@@ -216,12 +213,8 @@ static const struct dmi_system_id ac_dmi_table[]  __initconst = {
 static int acpi_ac_add(struct acpi_device *device)
 {
 	struct power_supply_config psy_cfg = {};
-	int result = 0;
-	struct acpi_ac *ac = NULL;
-
-
-	if (!device)
-		return -EINVAL;
+	struct acpi_ac *ac;
+	int result;
 
 	ac = kzalloc(sizeof(struct acpi_ac), GFP_KERNEL);
 	if (!ac)
@@ -275,16 +268,9 @@ static int acpi_ac_add(struct acpi_device *device)
 #ifdef CONFIG_PM_SLEEP
 static int acpi_ac_resume(struct device *dev)
 {
-	struct acpi_ac *ac;
+	struct acpi_ac *ac = acpi_driver_data(to_acpi_device(dev));
 	unsigned int old_state;
 
-	if (!dev)
-		return -EINVAL;
-
-	ac = acpi_driver_data(to_acpi_device(dev));
-	if (!ac)
-		return -EINVAL;
-
 	old_state = ac->state;
 	if (acpi_ac_get_state(ac))
 		return 0;
@@ -299,12 +285,7 @@ static int acpi_ac_resume(struct device *dev)
 
 static void acpi_ac_remove(struct acpi_device *device)
 {
-	struct acpi_ac *ac = NULL;
-
-	if (!device || !acpi_driver_data(device))
-		return;
-
-	ac = acpi_driver_data(device);
+	struct acpi_ac *ac = acpi_driver_data(device);
 
 	acpi_dev_remove_notify_handler(device->handle, ACPI_ALL_NOTIFY,
 				       acpi_ac_notify);
-- 
2.41.0


