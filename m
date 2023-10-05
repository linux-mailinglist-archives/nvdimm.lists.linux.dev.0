Return-Path: <nvdimm+bounces-6725-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA70A7BA926
	for <lists+linux-nvdimm@lfdr.de>; Thu,  5 Oct 2023 20:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sv.mirrors.kernel.org (Postfix) with ESMTP id 803B0281F3E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  5 Oct 2023 18:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E04D405C0;
	Thu,  5 Oct 2023 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPghufRX"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900BB3FB25
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696530720; x=1728066720;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=/oSquPe50FjL5XM1xo2u1juCDXoKE0v8k5E8iBZtEIw=;
  b=LPghufRXgmW+FpkS+XZa3l4lxugkUkTdnijw03C1lR6U0JTV+wXIa6no
   EFEWvIOVNcWpLWR/mTLybgIR74zYc2cQtGpP89yvZS4w6nAviMjh1bAhR
   iaPAhOwj2ec/uYNEnlrm8HLy4cZbSCoZ6fv0mvWLaUc/fY/K2/ud3EVMF
   q9wB7O8sVtb+bgXl5v5lF5UvoUWdaAlceq/aoYOqshHPBP5gLoFVJWurD
   w3SJBPE94tsM1rUknPPPMuKpsag5YD4/6hiJBhJnvjFDlQXgfJIvIlJec
   MlahbTJts7hswlqBZNqYE13F8QwDLC9MNouhu9c/eQDLnTIky6CvTHOYd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="363860722"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="363860722"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 11:31:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="781342809"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="781342809"
Received: from amykuo-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.12.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 11:31:52 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v5 0/2] mm: use memmap_on_memory semantics for dax/kmem
Date: Thu, 05 Oct 2023 12:31:38 -0600
Message-Id: <20231005-vv-kmem_memmap-v5-0-a54d1981f0a3@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAoBH2UC/3XNQW7DIBAF0KtErEuFAWPIqveoomqMhxrVxhEkq
 FXku3eSjatYXczif+n9ubGCOWJhx8ONZayxxCVRaF8OzI+QPpHHgTKTQiphGsVr5V8zzh90M5x
 5q63ydhBado4R6qEg7zMkPxJL12mi8pwxxO/Hl/cT5TGWy5J/Hk9rc2//3a8NFzyYAZ03EKQ3b
 zFdcHr1y8zuU1VuvJNixyVxa/sBoFfaOfXM1cataHZcEdfCoAMIrbHumeuNO2l3XBM3IXQqoG8
 bB3/5uq6/ecPnLX4BAAA=
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
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3836;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=/oSquPe50FjL5XM1xo2u1juCDXoKE0v8k5E8iBZtEIw=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKnyjMLySb8bv+wJd3nTr7TeqNDswTLnqZtspXept0Se3
 sM9+1lwRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZi8p3hf3LZ3uDd+/aeZPnw
 4uZs5ow39yy/rQhZpegvfPizImvNhVMMf/j7d/7VfaqYvV1hoXrIRcachTsOW1w/+1DVZFvQnW3
 HzDgA
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
Changes in v5:
- Separate out per-memblock operations from per memory block operations
  in try_remove_memory(), and rename the inner function appropriately.
  This does expand the scope of the memory hotplug lock to include
  remove_memory_block_devices(), but the alternative was to drop the
  lock in the inner function separately for each iteration, and then
  re-acquire it in try_remove_memory() creating a small window where
  the lock isn't held. (David Hildenbrand)
- Remove unnecessary rc check from the memmap_on_memory_store sysfs
  helper in patch 2 (Dan Carpenter)
- Link to v4: https://lore.kernel.org/r/20230928-vv-kmem_memmap-v4-0-6ff73fec519a@intel.com

Changes in v4:
- Rebase to Aneesh's PPC64 memmap_on_memory series v8 [2].
- Tweak a goto / error path in add_memory_create_devices() (Jonathan)
- Retain the old behavior for dax devices, only default to
  memmap_on_memory for CXL (Jonathan)
- Link to v3: https://lore.kernel.org/r/20230801-vv-kmem_memmap-v3-0-406e9aaf5689@intel.com

[2]: https://lore.kernel.org/linux-mm/20230808091501.287660-1-aneesh.kumar@linux.ibm.com

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

 drivers/dax/bus.h         |   1 +
 drivers/dax/dax-private.h |   1 +
 drivers/dax/bus.c         |  38 +++++++++++
 drivers/dax/cxl.c         |   1 +
 drivers/dax/hmem/hmem.c   |   1 +
 drivers/dax/kmem.c        |   8 ++-
 drivers/dax/pmem.c        |   1 +
 mm/memory_hotplug.c       | 162 ++++++++++++++++++++++++++++------------------
 8 files changed, 149 insertions(+), 64 deletions(-)
---
base-commit: 25b5b1a0646c3d39e1d885e27c10be1c9e202bf2
change-id: 20230613-vv-kmem_memmap-5483c8d04279

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


