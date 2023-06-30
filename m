Return-Path: <nvdimm+bounces-6273-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AD774424E
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 20:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F6E1C20C5E
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 18:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184B1174C7;
	Fri, 30 Jun 2023 18:34:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5039B168CE
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688150061; x=1719686061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OhNb4diD7c3/96GlreLql7JOogYRt1zgUXPKOSDhXMw=;
  b=eFJb1ZpwEobhKAVWnzoffTtkghQOUSgxzzUbp3uxudZLilAzzkQgVa8g
   BPkQB8hBdN7Lg4IivyKjNlzq8Vm4KZ0B89i3vPyIAQiNHbdJWMLiqh8DF
   Uw1CKHo2QpWlHCn9lq+f7/lXpmsy7x/mvQqXBtBE5jzxXhj6nUQ6ZCbct
   1hKvoAY86qmbhb9EmavKZ+bVUOWovEuLblEKd0vXKAHznSGA7SVvWrDTb
   JJDBqG6jOAwUZhz9LOnfIDsRrBKoLarpJJYwNx6aX4VpI3kPMKkF7dffj
   daX236Y0v/szQpy0uWghR7LwgSdOU+kEfqEP0/CjB/P+Kx5B4+BIyLK41
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365949963"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365949963"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717896442"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717896442"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:17 -0700
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
Subject: [PATCH v6 4/9] acpi/video: Move handler installing logic to driver
Date: Fri, 30 Jun 2023 21:33:39 +0300
Message-ID: <20230630183344.891077-5-michal.wilczynski@intel.com>
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
 drivers/acpi/acpi_video.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 62f4364e4460..168bb43e0c65 100644
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
 
@@ -1527,8 +1526,9 @@ static int acpi_video_bus_stop_devices(struct acpi_video_bus *video)
 				  acpi_osi_is_win8() ? 0 : 1);
 }
 
-static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
+static void acpi_video_bus_notify(acpi_handle handle, u32 event, void *data)
 {
+	struct acpi_device *device = data;
 	struct acpi_video_bus *video = acpi_driver_data(device);
 	struct input_dev *input;
 	int keycode = 0;
@@ -2053,8 +2053,20 @@ static int acpi_video_bus_add(struct acpi_device *device)
 
 	acpi_video_bus_add_notify_handler(video);
 
+	error = acpi_dev_install_notify_handler(device,
+						ACPI_DEVICE_NOTIFY,
+						acpi_video_bus_notify);
+	if (error)
+		goto err_remove;
+
 	return 0;
 
+err_remove:
+	mutex_lock(&video_list_lock);
+	list_del(&video->entry);
+	mutex_unlock(&video_list_lock);
+	acpi_video_bus_remove_notify_handler(video);
+	acpi_video_bus_unregister_backlight(video);
 err_put_video:
 	acpi_video_bus_put_devices(video);
 	kfree(video->attached_array);
@@ -2075,6 +2087,10 @@ static void acpi_video_bus_remove(struct acpi_device *device)
 
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


