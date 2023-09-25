Return-Path: <nvdimm+bounces-6635-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E9C7ADA4E
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Sep 2023 16:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by am.mirrors.kernel.org (Postfix) with ESMTP id A70F01F24D4A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Sep 2023 14:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4339C1C295;
	Mon, 25 Sep 2023 14:49:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD511C28E
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695653367; x=1727189367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZAL9mmtzBPLoZZSRbfxi5bVlGrr6Q3oM+Pk6Zg20eI=;
  b=UgJil9CmSO2JpnhC5hj8HoAKXqtY+uWCRB+TgpJEKj/8CeufrVA6xI3u
   Al7aVokcbCw74VvC4puHBy9PD46od19ZxjWxzNnlQuRHDvWVRYvTVWSAH
   INLHX/yzVYicwO8k1H41Ju7EQftBIdTxXOno90ozmHQXsCCBcYAXDtwI6
   mu0BGBcAXme1aKv3MJiPW1q3kELLTM8VAutGgqhtxQypnnVi031Cm9Uq+
   hwhpbrrJNUsg/6uPuU32LUjVIrO1nfYVm3/3E7Pp+X+MMwiiSuyrzJh2L
   8M8gRwhHe+2Dk67gSF22YKAf8lx/EV2TeiThY5JEgKq5pat3q/H55/sad
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="378548034"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="378548034"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995409476"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995409476"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:24 -0700
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
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v1 4/9] ACPI: AC: Use string_choices API instead of ternary operator
Date: Mon, 25 Sep 2023 17:48:37 +0300
Message-ID: <20230925144842.586829-5-michal.wilczynski@intel.com>
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

Use modern string_choices API instead of manually determining the
output using ternary operator.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/ac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index dd04809a787c..fd8b392c19f4 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
+#include <linux/string_choices.h>
 #include <linux/acpi.h>
 #include <acpi/battery.h>
 
@@ -243,8 +244,8 @@ static int acpi_ac_add(struct acpi_device *device)
 		goto err_release_ac;
 	}
 
-	pr_info("%s [%s] (%s)\n", acpi_device_name(device),
-		acpi_device_bid(device), ac->state ? "on-line" : "off-line");
+	pr_info("%s [%s] (%s-line)\n", acpi_device_name(device),
+		acpi_device_bid(device), str_on_off(ac->state));
 
 	ac->battery_nb.notifier_call = acpi_ac_battery_notify;
 	register_acpi_notifier(&ac->battery_nb);
-- 
2.41.0


