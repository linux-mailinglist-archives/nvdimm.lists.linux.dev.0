Return-Path: <nvdimm+bounces-2463-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C2048CF40
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jan 2022 00:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F33D41C0AD7
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jan 2022 23:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D7C2CA5;
	Wed, 12 Jan 2022 23:48:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE92C9D;
	Wed, 12 Jan 2022 23:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642031283; x=1673567283;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D6dnueQCdz88+vZC8U8lA4/WtL0w6JeRzu7qunSkRtg=;
  b=IGK6cFjGlU25R9fdxbdJAQC20ZnVlNvJcsScX3iRYkeSzSdAs8w0OT+e
   2gBNgTld/1JyPK4FkkoLEmToER7w/FJt0jXRTwTX+HhjIFIFhFN9ealmS
   gK0UbDft07OK+2zPKhgT3jIs+m3Jq9PJFRrayamSPYegMfr63z/bZ2x6m
   pEG4gPkYtJD98l+mRojFx4LrcOZsv9qR5B0eSQ0J7+N7mrp06EkKT58PL
   BFtRV+OBnHrGOrIhbI6faicstOOW37j7YvWnSWvmSqmexx9F449C1j6nN
   8GTqGfMXboEmXusAsjqzfdgsuaDJiEQFj7e+XgKk0Xjz+iZ2h3jEPt/MK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243673284"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243673284"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="670324165"
Received: from jmaclean-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.136.131])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:48:01 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 00/15] CXL Region driver
Date: Wed, 12 Jan 2022 15:47:34 -0800
Message-Id: <20220112234749.1965960-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Major changes since v1:
- bug fixes in certain calculations for region programming
- bug fix in for_each_cxl_decoder_target
- clarify ENIW and IG from ways and granularity
- wait_for_commit bug fix
- use devm management for region removal
- remove trace points
- add basic libnvdimm connection

Original commit message follows with minor updates for correctness.

---

This patch series introduces the CXL region driver as well as associated APIs in
CXL core. The region driver enables the creation of "regions" which is a concept
defined by the CXL 2.0 specification [1]. Region verification and programming
state are owned by the cxl_region driver (implemented in the cxl_region module).
It relies on cxl_mem to determine if devices are CXL routed, and cxl_port to
actually handle the programming of the HDM decoders. Much of the region driver
is an implementation of algorithms described in the CXL Type 3 Memory Device
Software Guide [2].

The region driver will be responsible for configuring regions found on
persistent capacities in the Label Storage Area (LSA), it will also enumerate
regions configured by BIOS, usually volatile capacities, and will allow for
dynamic region creation (which can then be stored in the LSA). It is the primary
consumer of the CXL Port [3] and CXL Mem drivers introduced previously [4]. Dan
has reworked those drivers which is a requirement for this branch. A cached copy
is included in the gitlab for this project [5]. Those patches will be posted
shortly.

The patches for the region driver could be squashed. They're broken out to aid
review and because that's the order they were implemented in. My preference is
to keep those as they are.

Some things are still missing and will be worked on while these are reviewed (in
priority order):
1. Volatile regions/LSA regions (Have a plan)
2. Switch ports (Have a plan)
3. Decoder programming restrictions (No plan). The one know restriction I've
   missed is to disallow programming HDM decoders that aren't in incremental
   system physical address ranges.
4. CXL region teardown -> nd_region teardown
5. Stress testing

Here is an example of output when programming a x2 interleave region

# ./cxlctl create-region -n -a -s $((256<<20)) /sys/bus/cxl/devices/decoder0.0
[   57.564475][  T654] cxl_core:cxl_add_region:478: cxl region0.0:0: Added region0.0:0 to decoder0.0
[   57.608949][  T655] cxl_region:allocate_address_space:170: cxl_region region0.0:0: resource [mem 0x4c00000000-0x4c1fffffff]
[   57.610056][  T655] cxl_core:cxl_commit_decoder:394: cxl_port port1: decoder1.0
[   57.610056][  T655]  Base 0x0000004c00000000
[   57.610056][  T655]  Size 512M
[   57.610056][  T655]  IG 0 (256b)
[   57.610056][  T655]  ENIW 1 (x2)
[   57.610056][  T655]  TargetList: 0 1 -1 -1 -1 -1 -1 -1
[   57.613584][  T655] cxl_core:cxl_commit_decoder:394: cxl_port endpoint2: decoder2.0
[   57.613584][  T655]  Base 0x0000004c00000000
[   57.613584][  T655]  Size 512M
[   57.613584][  T655]  IG 0 (256b)
[   57.613584][  T655]  ENIW 1 (x2)
[   57.613584][  T655]  TargetList: -1 -1 -1 -1 -1 -1 -1 -1
[   57.617051][  T655] cxl_core:cxl_commit_decoder:394: cxl_port endpoint3: decoder3.0
[   57.617051][  T655]  Base 0x0000004c00000000
[   57.617051][  T655]  Size 512M
[   57.617051][  T655]  IG 0 (256b)
[   57.617051][  T655]  ENIW 1 (x2)
[   57.617051][  T655]  TargetList: -1 -1 -1 -1 -1 -1 -1 -1
[   57.619433][  T655] cxl_region region0.0:0: Bound
[   57.621435][  T655] cxl_core:cxl_bus_probe:1384: cxl_region region0.0:0: probe: 0

If you're wondering how I tested this, I've baked it into my cxlctl app [6] and
lib [7]. Eventually this will get absorbed by ndctl/cxl-cli/libcxl.


Branch can be found at gitlab [8].

---

[1]: https://www.computeexpresslink.org/download-the-specification
[2]: https://cdrdv2.intel.com/v1/dl/getContent/643805?wapkw=CXL%20memory%20device%20sw%20guide
[3]: https://lore.kernel.org/linux-cxl/20211022183709.1199701-9-ben.widawsky@intel.com/
[4]: https://lore.kernel.org/linux-cxl/20211022183709.1199701-17-ben.widawsky@intel.com/
[5]: https://gitlab.com/bwidawsk/linux/-/commit/126793e22427f7975a8f2fca373764be78012e88
[6]: https://gitlab.com/bwidawsk-cxl/cxlctl
[7]: https://gitlab.com/bwidawsk-cxl/cxl_rs
[8]: https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-v2

Ben Widawsky (15):
  cxl/core: Rename find_cxl_port
  cxl/core: Track port depth
  cxl/region: Add region creation ABI
  cxl/region: Introduce concept of region configuration
  cxl/mem: Cache port created by the mem dev
  cxl/region: Introduce a cxl_region driver
  cxl/acpi: Handle address space allocation
  cxl/region: Address space allocation
  cxl/region: Implement XHB verification
  cxl/region: HB port config verification
  cxl/region: Add infrastructure for decoder programming
  cxl/region: Collect host bridge decoders
  cxl: Program decoders for regions
  cxl/pmem: Convert nvdimm bridge API to use memdev
  cxl/region: Create an nd_region

 .clang-format                                 |   3 +
 Documentation/ABI/testing/sysfs-bus-cxl       |  63 ++
 .../driver-api/cxl/memory-devices.rst         |  14 +
 drivers/cxl/Makefile                          |   2 +
 drivers/cxl/acpi.c                            |  30 +
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   4 +
 drivers/cxl/core/hdm.c                        | 199 +++++
 drivers/cxl/core/pmem.c                       |  19 +-
 drivers/cxl/core/port.c                       | 132 ++-
 drivers/cxl/core/region.c                     | 525 ++++++++++++
 drivers/cxl/cxl.h                             |  48 +-
 drivers/cxl/cxlmem.h                          |   9 +
 drivers/cxl/mem.c                             |  16 +-
 drivers/cxl/pmem.c                            |   2 +-
 drivers/cxl/port.c                            |  42 +-
 drivers/cxl/region.c                          | 769 ++++++++++++++++++
 drivers/cxl/region.h                          |  47 ++
 tools/testing/cxl/Kbuild                      |   1 +
 19 files changed, 1903 insertions(+), 23 deletions(-)
 create mode 100644 drivers/cxl/core/region.c
 create mode 100644 drivers/cxl/region.c
 create mode 100644 drivers/cxl/region.h

-- 
2.34.1


