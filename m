Return-Path: <nvdimm+bounces-6284-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C4707456CD
	for <lists+linux-nvdimm@lfdr.de>; Mon,  3 Jul 2023 10:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96E431C2090B
	for <lists+linux-nvdimm@lfdr.de>; Mon,  3 Jul 2023 08:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9226417E2;
	Mon,  3 Jul 2023 08:03:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94AD1379
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688371397; x=1719907397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lc4+OfSbvvX57NjX05OtAekCe3S3QQ2eQi+GYzBA354=;
  b=fmEdNkRsMI+I+gDPCg2lHzq2W4bDzL1t7qjgfleNydurANKzTZpFNWLb
   HgN8sNRQmO6QTkqA3AhSQhTROqaX5zH/X2FSHxzuZtPRZsp8OafnYYV5a
   E+NYQgP1CzuzIfVdQEY7NXDfViExgwrPyKrpqTKufWpztcDKEfQXP11zy
   v8j5FphXonrTS8iBVkvGl71JlW6OeFZcG6XrPPeZ28gKDlgT5rON5w6/6
   TGBttG2LhFfbcqTT1GvegQslWk3hZUrOVMV2RSuS3x5CdnBDRKxjg3kO1
   ai+9b4PSPVFdOXYJahecRP2Qjbf0zR16xM61H0Kn6DCKGXLhMGIALE1Jl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="366304009"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="366304009"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="862994510"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="862994510"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:14 -0700
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
Subject: [PATCH v7 1/9] acpi/bus: Introduce wrappers for ACPICA event handler install/remove
Date: Mon,  3 Jul 2023 11:02:44 +0300
Message-ID: <20230703080252.2899090-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703080252.2899090-1-michal.wilczynski@intel.com>
References: <20230703080252.2899090-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce new acpi_dev_install_notify_handler() and
acpi_dev_remove_notify_handler(). Those functions are replacing old
installers, and after all drivers switch to the new model, old installers
will be removed.

Make acpi_dev_install_notify_handler() and acpi_dev_remove_notify_handler()
non-static, and export symbols. This will allow the drivers to call them
directly, instead of relying on .notify callback.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/bus.c      | 26 ++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 20cdfb37da79..2d6f1f45d44e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -554,6 +554,32 @@ static void acpi_device_remove_notify_handler(struct acpi_device *device,
 	acpi_os_wait_events_complete();
 }
 
+int acpi_dev_install_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler)
+{
+	acpi_status status;
+
+	status = acpi_install_notify_handler(adev->handle,
+					     handler_type,
+					     handler,
+					     adev);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL(acpi_dev_install_notify_handler);
+
+void acpi_dev_remove_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler)
+{
+	acpi_remove_notify_handler(adev->handle, handler_type, handler);
+	acpi_os_wait_events_complete();
+}
+EXPORT_SYMBOL(acpi_dev_remove_notify_handler);
+
 /* Handle events targeting \_SB device (at present only graceful shutdown) */
 
 #define ACPI_SB_NOTIFY_SHUTDOWN_REQUEST 0x81
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c941d99162c0..23fbe4a16972 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -515,6 +515,12 @@ void acpi_bus_private_data_handler(acpi_handle, void *);
 int acpi_bus_get_private_data(acpi_handle, void **);
 int acpi_bus_attach_private_data(acpi_handle, void *);
 void acpi_bus_detach_private_data(acpi_handle);
+int acpi_dev_install_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler);
+void acpi_dev_remove_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler);
 extern int acpi_notifier_call_chain(struct acpi_device *, u32, u32);
 extern int register_acpi_notifier(struct notifier_block *);
 extern int unregister_acpi_notifier(struct notifier_block *);
-- 
2.41.0


