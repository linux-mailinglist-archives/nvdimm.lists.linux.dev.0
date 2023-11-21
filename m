Return-Path: <nvdimm+bounces-6926-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5847F3694
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Nov 2023 19:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A11F281EE0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Nov 2023 18:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F4659161;
	Tue, 21 Nov 2023 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m4nDCkxJ"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2067F1F182
	for <nvdimm@lists.linux.dev>; Tue, 21 Nov 2023 18:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700593135; x=1732129135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=475C0nd9cgnN83xWfqsRcNENVDE6uggJElMQ3a6D3HQ=;
  b=m4nDCkxJ55zWgr1+eorUnvv7WLUphsjoShd+paXFYqaWaFfqjqClH21p
   iIN+McvwbENeC0VblhhhBHDZCnX0CjHAZejIktFItu6+8q4m94jXWn5++
   37y3c7pgAbYNa32c+K+audTBOW1k58OjuS7r7qcnOQRjY0UXnENpaS42S
   bkAqJoP+rOYBkc8jZXykHbUUoHvJPxStNhzqZWkEsJzaDvWtA2JbJaq09
   qurM3cpeIXJ/NgEKrOOCDTZunk18BEY+iVm9V8tA7f9nmmxrvymKWg5RK
   KB0QfnJqWX2P/v5LETREgK9T47cBOWumjj8dFojlOYYjXiIjpHL7A9e7u
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="376939699"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="376939699"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 10:58:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="743139562"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="743139562"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.90.75])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 10:58:53 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v4 0/5] Support poison list retrieval
Date: Tue, 21 Nov 2023 10:58:46 -0800
Message-Id: <cover.1700591754.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>


Changes since v3:
- Exclude poison record where address belongs to a different region
- Add unit test case for above scenario
- Refactor unit test handling of poison record checks (Vishal)
- Address shellcheck complaints in the unit test (Vishal)
- Remove empty json fields from cxl-list man page
- Omit json "flags" field when no flags exist
- Minor flow updates in the unit test
- Link to v3:
  https://lore.kernel.org/linux-cxl/cover.1700258145.git.alison.schofield@intel.com/

Begin cover letter:

Add the option to include a memory device poison list in cxl list json output.
Examples appended below: by memdev, by region, by memdev and coincidentally
in a region, and no poison found.

Example: By memdev
cxl list -m mem1 --poison -u
{
  "memdev":"mem1",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0x1",
  "numa_node":1,
  "host":"cxl_mem.1",
  "poison":{
    "nr_records":4,
    "records":[
      {
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
      },
      {
        "dpa":"0x40001000",
        "dpa_length":64,
        "source":"Injected",
      },
      {
        "dpa":"0",
        "dpa_length":64,
        "source":"Injected",
      },
      {
        "dpa":"0x600",
        "dpa_length":64,
        "source":"Injected",
      }
    ]
  }
}

Example: By region
cxl list -r region5 --poison -u
{
  "region":"region5",
  "resource":"0xf110000000",
  "size":"2.00 GiB (2.15 GB)",
  "type":"pmem",
  "interleave_ways":2,
  "interleave_granularity":4096,
  "decode_state":"commit",
  "poison":{
    "nr_records":2,
    "records":[
      {
        "memdev":"mem1",
        "region":"region5",
        "hpa":"0xf110001000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
      },
      {
        "memdev":"mem0",
        "region":"region5",
        "hpa":"0xf110000000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
      }
    ]
  }
}

Example: By memdev and coincidentally in a region
# cxl list -m mem0 --poison -u
{
  "memdev":"mem0",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0",
  "numa_node":0,
  "host":"cxl_mem.0",
  "poison":{
    "nr_records":1,
    "records":[
      {
        "region":"region5",
        "hpa":"0xf110000000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
      }
    ]
  }
}

Example: No poison found
cxl list -m mem9 --poison -u
{
  "memdev":"mem9",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0x9",
  "numa_node":1,
  "host":"cxl_mem.9",
  "poison":{
    "nr_records":0
  }
}


Alison Schofield (5):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl: add an optional pid check to event parsing
  cxl/list: collect and parse the poison list records
  cxl/list: add --poison option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  58 +++++++++
 cxl/event_trace.c              |   5 +
 cxl/event_trace.h              |   1 +
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 211 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++++
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   2 +
 test/cxl-poison.sh             | 154 ++++++++++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 491 insertions(+)
 create mode 100644 test/cxl-poison.sh


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3


