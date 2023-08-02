Return-Path: <nvdimm+bounces-6445-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0293276C50C
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Aug 2023 07:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31B061C211DB
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Aug 2023 05:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E65951848;
	Wed,  2 Aug 2023 05:56:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (unknown [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E8D15BA
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 05:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690955760; x=1722491760;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=HwpJuUewgUm91iTLxWOXGqrJHkJjPxKSlGAl+Eindpk=;
  b=Jow1HzQdNdjX5grHdodqXMBZ4Xfxp3dN8pbXZG5iqvpu6MDP7nIrtDot
   YG2wtp3AUKZseg5zr4M7PbmBrPYYtk2ouuR/ia+VMsNdGWGxBJRrr2BEz
   kVxRw9UtKko1FZp7AkAdOtsSpKrt6aiXMFpC1S598mLAtzPTZgJIskU23
   hMINgqsz1rmUN1jILxZRN78WCqs7B0MU4UXq/lhC7O2hU50yL8qilCELi
   /nJkp/umsjZQlYecN65Oq1HQhBSorMfy4ohnvpZbxH1tqsfRd9jPwZ68/
   sooGGFR4IIEdvL84Oe3aDHzMxpIztNZlekmrEnbQGwyHkx4y0r/N85xMg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="455857437"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="455857437"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 22:55:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="852746656"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="852746656"
Received: from hongrudi-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.173.200])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 22:55:45 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 0/2] mm: use memmap_on_memory semantics for dax/kmem
Date: Tue, 01 Aug 2023 23:55:36 -0600
Message-Id: <20230801-vv-kmem_memmap-v3-0-406e9aaf5689@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANjvyWQC/3WNTQ6CMBhEr0K6tqa0WIor72GM6c+HNNJCWmw0h
 Ltb2GhiXMziTfJmZhQhWIjoWMwoQLLRDj4D2xVId9LfAFuTGVFCGeElwynhuwN3zXFyxIdKMC0
 MqWjdoCwpGQGrIL3usuYffZ/LMUBrn9vL+ZK5s3Eawms7TeXa/t1PJSa45QYazWVLNT9ZP0G/1
 4ND61SiH72m5EenWRdCGSkVq5qGfevLsrwB4AmAGwABAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2577;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=HwpJuUewgUm91iTLxWOXGqrJHkJjPxKSlGAl+Eindpk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCkn39+R5LpiFL9qncUi6SOmX/a+WCz5VLXH+v8fyyWP7
 3Q0tj9U7ihlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEupkY/geGR3T5WLH0dM+W
 WXiyXXn99mW/TD5+6jQ4xOd42M7k6F2Gv2LxUbPmzD6X3TtTRE+Gh32Ffu/sK/7LzglKmK/oN0o
 /zAcA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The dax/kmem driver can potentially hot-add large amounts of memory
originating from CXL memory expanders, or NVDIMMs, or other 'device
memories'. There is a chance there isn't enough regular system memory
available to fit the memmap for this new memory. It's therefore
desirable, if all other conditions are met, for the kmem managed memory
to place its memmap on the newly added memory itself.

The main hurdle for accomplishing this for kmem is that memmap_on_memory
can only be done if the memory being added is equal to the size of one
memblock. To overcome this, allow the hotplug code to split an add_memory()
request into memblock-sized chunks, and try_remove_memory() to also
expect and handle such a scenario.

Patch 1 teaches the memory_hotplug code to allow for splitting
add_memory() and remove_memory() requests over memblock sized chunks.

Patch 2 adds a sysfs control for the kmem driver that would
allow an opt-out of using memmap_on_memory for the memory being added.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v3:
- Rebase on Aneesh's patches [1]
- Drop Patch 1 - it is not needed since [1] allows for dynamic setting
  of the memmap_on_memory param (David)
- Link to v2: https://lore.kernel.org/r/20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com

[1]: https://lore.kernel.org/r/20230801044116.10674-1-aneesh.kumar@linux.ibm.com

Changes in v2:
- Drop the patch to create an override path for the memmap_on_memory
  module param (David)
- Move the chunking into memory_hotplug.c so that any caller of
  add_memory() can request this behavior. (David)
- Handle remove_memory() too. (David, Ying)
- Add a sysfs control in the kmem driver for memmap_on_memory semantics
  (David, Jonathan)
- Add a #else case to define mhp_supports_memmap_on_memory() if
  CONFIG_MEMORY_HOTPLUG is unset. (0day report)
- Link to v1: https://lore.kernel.org/r/20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com

---
Vishal Verma (2):
      mm/memory_hotplug: split memmap_on_memory requests across memblocks
      dax/kmem: allow kmem to add memory with memmap_on_memory

 drivers/dax/dax-private.h |   1 +
 drivers/dax/bus.c         |  42 +++++++++++++
 drivers/dax/kmem.c        |   8 ++-
 mm/memory_hotplug.c       | 150 ++++++++++++++++++++++++++++------------------
 4 files changed, 143 insertions(+), 58 deletions(-)
---
base-commit: 64caf0ab00a1fc954cbf0aa43d65ca70d71d614f
change-id: 20230613-vv-kmem_memmap-5483c8d04279

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


