Return-Path: <nvdimm+bounces-6283-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C66F7456CC
	for <lists+linux-nvdimm@lfdr.de>; Mon,  3 Jul 2023 10:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FCDB1C208CA
	for <lists+linux-nvdimm@lfdr.de>; Mon,  3 Jul 2023 08:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A48251371;
	Mon,  3 Jul 2023 08:03:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C6A34
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 08:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688371395; x=1719907395;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ou+WLzTPwdntIetfd+7MaSPig1ii75haZd/L4ui/vkg=;
  b=ZOXK64uwmrHdZzZNy4YbhUu5rOO3LL0w5dw6AQ96Dkej/A4ZBAUJGrmu
   43iAXm1uU6xzqkE43XvqOUhQDOGelH9jXtgswURmmCuqkRX7KQ52YekWA
   oP2Dv3+g8syPk3qm0PRmZE/k32X9ZNCUVwUIUB15hk/b9cDl8ZOQsV2E+
   gYM2WYiDcTBUQnUciWoQL0+lg7o3/h5OdUHVdb6HP9FWdguGSFQsvXYQS
   bPzNEHfA5svXFpIyOV0192wtezFDe74+UbqTz9CIRyBNEyRXW2ZDi165g
   M2QrONzt6APclAg4RqQmu0Iq0cM+VvJi5dlbKoe5tX/0j91zUYp/Y1/Vr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="366303998"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="366303998"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="862994498"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="862994498"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:11 -0700
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
Subject: [PATCH v7 0/9] Remove .notify callback in acpi_device_ops
Date: Mon,  3 Jul 2023 11:02:43 +0300
Message-ID: <20230703080252.2899090-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

*** IMPORTANT ***
This is part 1 - only drivers in acpi directory to ease up review
process. Rest of the drivers will be handled in separate patchsets.

Currently drivers support ACPI event handlers by defining .notify
callback in acpi_device_ops. This solution is suboptimal as event
handler installer installs intermediary function acpi_notify_device as a
handler in every driver. Also this approach requires extra variable
'flags' for specifying event types that the driver want to subscribe to.
Additionally this is a pre-work required to align acpi_driver with
platform_driver and eventually replace acpi_driver with platform_driver.

Remove .notify callback from the acpi_device_ops. Replace it with each
driver installing and removing it's event handlers.

This is part 1 - only drivers in acpi directory to ease up review
process.

v7:
 - fix warning by declaring acpi_nfit_remove_notify_handler() as static

v6:
 - fixed unnecessary RCT in all drivers, as it's not a purpose of
   this patch series
 - changed error label names to simplify them
 - dropped commit that remove a comma
 - squashed commit moving code for nfit
 - improved nfit driver to use devm instead of .remove()
 - re-based as Rafael changes [1] are merged already

v5:
 - rebased on top of Rafael changes [1], they're not merged yet
 - fixed rollback in multiple drivers so they don't leak resources on
   failure
 - made this part 1, meaning only drivers in acpi directory, rest of
   the drivers will be handled in separate patchsets to ease up review

v4:
 - added one commit for previously missed driver sony-laptop,
   refactored return statements, added NULL check for event installer
v3:
 - lkp still reported some failures for eeepc, fujitsu and
   toshiba_bluetooth, fix those
v2:
 - fix compilation errors for drivers

[1]: https://lore.kernel.org/linux-acpi/1847933.atdPhlSkOF@kreacher/

Michal Wilczynski (9):
  acpi/bus: Introduce wrappers for ACPICA event handler install/remove
  acpi/bus: Set driver_data to NULL every time .add() fails
  acpi/ac: Move handler installing logic to driver
  acpi/video: Move handler installing logic to driver
  acpi/battery: Move handler installing logic to driver
  acpi/hed: Move handler installing logic to driver
  acpi/nfit: Move handler installing logic to driver
  acpi/nfit: Remove unnecessary .remove callback
  acpi/thermal: Move handler installing logic to driver

 drivers/acpi/ac.c         | 29 ++++++++++++++++++-------
 drivers/acpi/acpi_video.c | 22 ++++++++++++++++---
 drivers/acpi/battery.c    | 26 +++++++++++++++++-----
 drivers/acpi/bus.c        | 30 +++++++++++++++++++++++++-
 drivers/acpi/hed.c        | 17 ++++++++++++---
 drivers/acpi/nfit/core.c  | 45 +++++++++++++++++++++++++++------------
 drivers/acpi/thermal.c    | 25 +++++++++++++++++-----
 include/acpi/acpi_bus.h   |  6 ++++++
 8 files changed, 161 insertions(+), 39 deletions(-)

-- 
2.41.0


