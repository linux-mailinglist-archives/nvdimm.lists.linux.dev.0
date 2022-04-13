Return-Path: <nvdimm+bounces-3500-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A99E4FEF0E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 08:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 31A791C0D42
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 06:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB1123D4;
	Wed, 13 Apr 2022 06:01:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30ED23CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829694; x=1681365694;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PfDWaktmCESkI/Q8ppnRmVQE2iUjMwl7xXHFrkBc6ik=;
  b=bV7PMUEmf/NIqB0dNMvfGUlUrrHvTbk18//QMsqvW+9FFmxzBq2nn/Sp
   mkoi2Ep5/y/Nb/LvGwuzFzD0up19lZaMu3Ztleraz360fnEMv0EUA6AjG
   B07uZrW+YiTtkJgpWj/ZIK6+osASkO4Q5uSgMdptbuYa1pN6AgWxxQuXJ
   AGeDcwH+DmN6GPGh2jCNyZwfV8tp4aiDgeKvg8E987PvGCGxs5aO5Ljtv
   GDTC9AU2gDuvJ32nkz/2g+K+RNC2DhNX9fEKcOmytgA2IGX2OLloEyax/
   cds4hJ9ncpnk/xUbtt6v7PhFf3xh9U5SgnNxeXEVBKZccqFo78mJInVd3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262763032"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262763032"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:34 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="660799727"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:28 -0700
Subject: [PATCH v2 00/12] device-core: Enable device_lock() lockdep
 validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Will Deacon <will@kernel.org>,
 Waiman Long <longman@redhat.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:01:28 -0700
Message-ID: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Changes since v1 [1]:
- Improve the clarity of the cover letter and changelogs of the
  major patches (Patch2 and Patch12) (Pierre, Kevin, and Dave)
- Fix device_lock_interruptible() false negative deadlock detection
  (Kevin)
- Fix off-by-one error in the device_set_lock_class() enable case (Kevin)
- Spelling fixes in Patch2 changelog (Pierre)
- Compilation fixes when both CONFIG_CXL_BUS=n and
  CONFIG_LIBNVDIMM=n. (0day robot)

[1]: https://lore.kernel.org/all/164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com/

---

The device_lock() is why the lockdep_set_novalidate_class() API exists.
The lock is taken in too many disparate contexts, and lockdep by design
assumes that all device_lock() acquisitions are identical. The lack of
lockdep coverage leads to deadlock scenarios landing upstream. To
mitigate that problem the lockdep_mutex was added [2].

The lockdep_mutex lets a subsystem mirror device_lock() acquisitions
without lockdep_set_novalidate_class() to gain some limited lockdep
coverage. The mirroring approach is limited to taking the device_lock()
after-the-fact in a subsystem's 'struct bus_type' operations and fails
to cover device_lock() acquisition in the driver-core. It also can only
track the needs of one subsystem at a time so, for example the kernel
needs to be recompiled between CONFIG_PROVE_NVDIMM_LOCKING and
CONFIG_PROVE_CXL_LOCKING depending on which subsystem is being
regression tested. Obviously that also means that intra-subsystem
locking dependencies can not be validated.

Two enhancements are proposed to improve the current state of
device_lock() lockdep validation:

1/ Communicate a lock class to the device-core and let it acquire
   dev->lockdep_mutex per the subsystem's nested locking expectations.

2/ Go further and provide a lockdep_mutex per-subsystem so each 
   has the full span of MAX_LOCKDEP_SUBCLASSES available for its use.

This enabling has already prevented at least one device_lock() deadlock
from making its way upstream.

[2]: commit 87a30e1f05d7 ("driver-core, libnvdimm: Let device subsystems add local lockdep coverage")

---

Dan Williams (12):
      device-core: Move device_lock() lockdep init to a helper
      device-core: Add dev->lock_class to enable device_lock() lockdep validation
      cxl/core: Refactor a cxl_lock_class() out of cxl_nested_lock()
      cxl/core: Remove cxl_device_lock()
      cxl/core: Clamp max lock_class
      cxl/core: Use dev->lock_class for device_lock() lockdep validation
      cxl/acpi: Add a device_lock() lock class for the root platform device
      libnvdimm: Refactor an nvdimm_lock_class() helper
      ACPI: NFIT: Drop nfit_device_lock()
      libnvdimm: Drop nd_device_lock()
      libnvdimm: Enable lockdep validation
      device-core: Enable multi-subsystem device_lock() lockdep validation


 drivers/acpi/nfit/core.c        |   30 ++++---
 drivers/acpi/nfit/nfit.h        |   24 ------
 drivers/base/core.c             |    5 -
 drivers/cxl/acpi.c              |    1 
 drivers/cxl/core/memdev.c       |    1 
 drivers/cxl/core/pmem.c         |    6 +
 drivers/cxl/core/port.c         |   56 ++++++-------
 drivers/cxl/cxl.h               |   76 +++++++-----------
 drivers/cxl/mem.c               |    4 -
 drivers/cxl/pmem.c              |   12 +--
 drivers/cxl/port.c              |    2 
 drivers/nvdimm/btt_devs.c       |   16 ++--
 drivers/nvdimm/bus.c            |   26 +++---
 drivers/nvdimm/core.c           |   10 +-
 drivers/nvdimm/dimm_devs.c      |    8 +-
 drivers/nvdimm/namespace_devs.c |   36 ++++-----
 drivers/nvdimm/nd-core.h        |   51 +++---------
 drivers/nvdimm/pfn_devs.c       |   24 +++---
 drivers/nvdimm/pmem.c           |    2 
 drivers/nvdimm/region.c         |    2 
 drivers/nvdimm/region_devs.c    |   16 ++--
 include/linux/device.h          |  162 ++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug               |   23 ------
 23 files changed, 325 insertions(+), 268 deletions(-)

--

base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e

