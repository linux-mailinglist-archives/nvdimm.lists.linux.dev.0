Return-Path: <nvdimm+bounces-6101-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7385719D4F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Jun 2023 15:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A39E22817B1
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Jun 2023 13:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76808FC08;
	Thu,  1 Jun 2023 13:21:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB89FBE8;
	Thu,  1 Jun 2023 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685625709; x=1717161709;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LDh3/ulcjpVzc1kWMXWyk72lw2x2F5XCJG1Yb1dhhKw=;
  b=IIifFB/XN7cmxihAwzfPaOsSrnwyTQa4g/nwQeIkyX7s+6NMiOI4eNIW
   pw9v3j8cHzqARqPY5CIVqhW1z/SWMcWVNMXPsuQmv5svvEtSsP3nf/QRg
   ktc+Q5cXPm8l3nOXXWQTHTm6gwzyTKTbi9gsXg0H9lrC1eQMOJFhgeA4Y
   NsFbMX5X5IdobzoGGwp3aki2kUAZaPx0MkpTKpT8xHJwgtlstYFUQTG3H
   KiICLv90iFWOTY5Se8r9HR9Y8wmlXeq43DPXxKv6Lho/+Ym+D9XredWrq
   WvfAZ1xz+wQVQAC6C318CHV4WADG6qy3lyssLxL7DTjTT5Jux0Ndfg0uD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="335174006"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="335174006"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:21:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="1037487848"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="1037487848"
Received: from hextor.igk.intel.com ([10.123.220.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:21:40 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: rafael@kernel.org,
	lenb@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	jdelvare@suse.com,
	linux@roeck-us.net,
	jic23@kernel.org,
	lars@metafoo.de,
	bleung@chromium.org,
	yu.c.chen@intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org,
	luzmaximilian@gmail.com,
	corentin.chary@gmail.com,
	jprvita@gmail.com,
	cascardo@holoscopio.com,
	don@syst.com.br,
	pali@kernel.org,
	jwoithe@just42.net,
	matan@svgalib.org,
	kenneth.t.chan@gmail.com,
	malattia@linux.it,
	jeremy@system76.com,
	productdev@system76.com,
	herton@canonical.com,
	coproscefalo@gmail.com,
	tytso@mit.edu,
	Jason@zx2c4.com,
	robert.moore@intel.com
Cc: linux-acpi@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-hwmon@vger.kernel.org,
	linux-iio@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	acpi4asus-user@lists.sourceforge.net,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	acpica-devel@lists.linuxfoundation.org
Subject: [PATCH v4 35/35] acpi/bus: Remove notify callback and flags
Date: Thu,  1 Jun 2023 15:21:37 +0200
Message-Id: <20230601132137.301802-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As callback has been replaced by drivers installing their handlers in
.add it's presence is not useful anymore.

Remove .notify callback and flags variable from struct acpi_driver,
as they're not needed anymore.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 include/acpi/acpi_bus.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 7fb411438b6f..3326794d5b70 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -151,12 +151,10 @@ struct acpi_hotplug_context {
 
 typedef int (*acpi_op_add) (struct acpi_device * device);
 typedef void (*acpi_op_remove) (struct acpi_device *device);
-typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
 
 struct acpi_device_ops {
 	acpi_op_add add;
 	acpi_op_remove remove;
-	acpi_op_notify notify;
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
@@ -165,7 +163,6 @@ struct acpi_driver {
 	char name[80];
 	char class[80];
 	const struct acpi_device_id *ids; /* Supported Hardware IDs */
-	unsigned int flags;
 	struct acpi_device_ops ops;
 	struct device_driver drv;
 	struct module *owner;
-- 
2.40.1


