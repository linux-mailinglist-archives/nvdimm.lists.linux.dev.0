Return-Path: <nvdimm+bounces-6184-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5076A733691
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Jun 2023 18:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AFC1281876
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Jun 2023 16:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4C61ACBC;
	Fri, 16 Jun 2023 16:51:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9980A1ACA9
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934268; x=1718470268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WTF7qXCGfbqkbmMZPA53N6yTaDiYkqqqQo1UJ0g8S5s=;
  b=kLzEccjliXjt7VyQK0UtLQZ1d8MMLVXG0v4Z9FLwsjqwPQuk3klgBb/u
   pnme0HsgbuIKBHyVU5kUY0so3N2dfDrCjoRersb36a5vGVKqoLH2M00d/
   x8a0FQwdFTNawmwx0K+KwUyoK+kSWzMmd5DRNh5L3iSf9h27jTUqqx2i8
   yrZlCGVpOthTYD525opqP6ygYVX0a5nzrihf2UGbn/bPJmE8qfhBaDibi
   /ZkvjRzGMssrLtp27+x3ryZ/qYk8yg+edbYMIeRPWVECnWJOloxeqP8yD
   nqUPqnglvtDbiEiktuBDwCOCs29XzTte9TKSXox7mCvNVaU5M1vSFVSXX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422913016"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422913016"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154156"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154156"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:04 -0700
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
Subject: [PATCH v5 04/10] acpi/video: Move handler installing logic to driver
Date: Fri, 16 Jun 2023 19:50:28 +0300
Message-ID: <20230616165034.3630141-5-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230616165034.3630141-1-michal.wilczynski@intel.com>
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
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
what's required by acpi_install_notify_handler(). Remove .notify
callback initialization in acpi_driver.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/acpi_video.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 62f4364e4460..60b7013d0009 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -77,7 +77,7 @@ static DEFINE_MUTEX(video_list_lock);
 static LIST_HEAD(video_bus_head);
 static int acpi_video_bus_add(struct acpi_device *device);
 static void acpi_video_bus_remove(struct acpi_device *device);
-static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
+static void acpi_video_bus_notify(acpi_handle handle, u32 event, void *data);
 
 /*
  * Indices in the _BCL method response: the first two items are special,
@@ -104,7 +104,6 @@ static struct acpi_driver acpi_video_bus = {
 	.ops = {
 		.add = acpi_video_bus_add,
 		.remove = acpi_video_bus_remove,
-		.notify = acpi_video_bus_notify,
 		},
 };
 
@@ -1527,12 +1526,15 @@ static int acpi_video_bus_stop_devices(struct acpi_video_bus *video)
 				  acpi_osi_is_win8() ? 0 : 1);
 }
 
-static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
+static void acpi_video_bus_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_video_bus *video = acpi_driver_data(device);
+	struct acpi_device *device = data;
+	struct acpi_video_bus *video;
 	struct input_dev *input;
 	int keycode = 0;
 
+	video = acpi_driver_data(device);
+
 	if (!video || !video->input)
 		return;
 
@@ -2053,8 +2055,20 @@ static int acpi_video_bus_add(struct acpi_device *device)
 
 	acpi_video_bus_add_notify_handler(video);
 
+	error = acpi_dev_install_notify_handler(device,
+						ACPI_DEVICE_NOTIFY,
+						acpi_video_bus_notify);
+	if (error)
+		goto err_remove_and_unregister_video;
+
 	return 0;
 
+err_remove_and_unregister_video:
+	mutex_lock(&video_list_lock);
+	list_del(&video->entry);
+	mutex_unlock(&video_list_lock);
+	acpi_video_bus_remove_notify_handler(video);
+	acpi_video_bus_unregister_backlight(video);
 err_put_video:
 	acpi_video_bus_put_devices(video);
 	kfree(video->attached_array);
@@ -2075,6 +2089,10 @@ static void acpi_video_bus_remove(struct acpi_device *device)
 
 	video = acpi_driver_data(device);
 
+	acpi_dev_remove_notify_handler(device,
+				       ACPI_DEVICE_NOTIFY,
+				       acpi_video_bus_notify);
+
 	mutex_lock(&video_list_lock);
 	list_del(&video->entry);
 	mutex_unlock(&video_list_lock);
-- 
2.41.0


