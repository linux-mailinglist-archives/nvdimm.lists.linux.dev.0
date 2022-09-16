Return-Path: <nvdimm+bounces-4737-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 306485BA529
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 05:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB48F1C2095F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 03:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3BEC20FD;
	Fri, 16 Sep 2022 03:35:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBAE20EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299310; x=1694835310;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SLVv9pi7vEhZVM1xN6gyr4FHAmbLxVDLK3Xakj+D/Kc=;
  b=k1iAswIj748rrdqPP79b6cpn8VDfIZQXxsrIlidF08rxz78wX5B+QynO
   izcp47sTtBBD2cqFHdvJ+bKXyaEgKgfMW6pJzL0ly2MaCTVG3i7kQcXO6
   YB1gW30IO4JkHRGGoJkWwlIwoSEtk3qetD6FvKcD0eFZhLY5SbGp5GsS0
   QdIZ9cGtPgXBPuzBw7PiAHj6KmLEAWaDd/egH+Cbnv0HbCBI2gt/CIL0s
   Hspr42nhDREuBZivinm6HAHxW1zLg/KeMlLUHKL5HLnxeFqauDH7wyf7C
   8YnxcuFUU2EZZo1av8qIL9nzAMhWOJ9/vbLy7cdVCZuUOHeXTUdvXihxl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="281930376"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="281930376"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="679809134"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:09 -0700
Subject: [PATCH v2 00/18] Fix the DAX-gup mistake
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:08 -0700
Message-ID: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
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
- Jason rightly pointed out that the approach taken in v1 still did not
  properly handle the case of waiting for all page pins to drop to zero.
  The new approach in this set fixes that and more closely mirrors what
  happens for typical pages, details below.

[1]: https://lore.kernel.org/nvdimm/166225775968.2351842.11156458342486082012.stgit@dwillia2-xfh.jf.intel.com/
---

Typical pages have their reference count elevated when they are
allocated and installed in the page cache, elevated again when they are
mapped into userspace, and elevated for gup. The DAX-gup mistake is that
page-references were only ever taken for gup and the device backing the
memory was only pinned (get_dev_pagemap()) at gup time. That leaves a
hole where the page is mapped for userspace access without a pin on the
device.

Rework the DAX page reference scheme to be more like typical pages. DAX
pages start life at reference count 0, elevate their reference count at
map time and gup time. Unlike typical pages that can be safely truncated
from files while they are pinned for gup, DAX pages can only be
truncated while their reference count is 0. The device is pinned via
get_dev_pagemap() whenever a DAX page transitions from _refcount 0 -> 1,
and unpinned only after the 1 -> 0 transition and being truncated from
their host inode.

To facilitate this reference counting and synchronization a new
dax_zap_pages() operation is introduced before any truncate event. That
dax_zap_pages() operation is carried out as a side effect of any 'break
layouts' event. Effectively dax_zap_pages() and the new DAX_ZAP flag (in
the DAX-inode i_pages entries), is mimicking what _mapcount tracks for
typical pages. The zap state allows the Xarray to cache page->mapping
information for entries until the page _refcount drops to zero and is
finally truncated from the file / no longer in use.

This hackery continues the status of DAX pages as special cases in the
VM. The thought being carrying the Xarray / mapping infrastructure
forward still allows for the continuation of the page-less DAX effort.
Otherwise, the work to convert DAX pages to behave like typical
vm_normal_page() needs more investigation to untangle transparent huge
page assumptions.

This passes the "ndctl:dax" suite of tests from the ndctl project.
Thanks to Jason for the discussion on v1 to come up with this new
approach.

---

Dan Williams (18):
      fsdax: Wait on @page not @page->_refcount
      fsdax: Use dax_page_idle() to document DAX busy page checking
      fsdax: Include unmapped inodes for page-idle detection
      ext4: Add ext4_break_layouts() to the inode eviction path
      xfs: Add xfs_break_layouts() to the inode eviction path
      fsdax: Rework dax_layout_busy_page() to dax_zap_mappings()
      fsdax: Update dax_insert_entry() calling convention to return an error
      fsdax: Cleanup dax_associate_entry()
      fsdax: Rework dax_insert_entry() calling convention
      fsdax: Manage pgmap references at entry insertion and deletion
      devdax: Minor warning fixups
      devdax: Move address_space helpers to the DAX core
      dax: Prep mapping helpers for compound pages
      devdax: add PUD support to the DAX mapping infrastructure
      devdax: Use dax_insert_entry() + dax_delete_mapping_entry()
      mm/memremap_pages: Support initializing pages to a zero reference count
      fsdax: Delete put_devmap_managed_page_refs()
      mm/gup: Drop DAX pgmap accounting


 .clang-format             |    1 
 drivers/Makefile          |    2 
 drivers/dax/Kconfig       |    5 
 drivers/dax/Makefile      |    1 
 drivers/dax/bus.c         |   15 +
 drivers/dax/dax-private.h |    2 
 drivers/dax/device.c      |   74 ++-
 drivers/dax/mapping.c     | 1055 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dax/super.c       |    6 
 drivers/nvdimm/Kconfig    |    1 
 drivers/nvdimm/pmem.c     |    2 
 fs/dax.c                  | 1049 ++-------------------------------------------
 fs/ext4/inode.c           |   17 +
 fs/fuse/dax.c             |    9 
 fs/xfs/xfs_file.c         |   16 -
 fs/xfs/xfs_inode.c        |    7 
 fs/xfs/xfs_inode.h        |    6 
 fs/xfs/xfs_super.c        |   22 +
 include/linux/dax.h       |  128 ++++-
 include/linux/huge_mm.h   |   23 -
 include/linux/memremap.h  |   29 +
 include/linux/mm.h        |   30 -
 mm/gup.c                  |   89 +---
 mm/huge_memory.c          |   54 --
 mm/memremap.c             |   46 +-
 mm/page_alloc.c           |    2 
 mm/swap.c                 |    2 
 27 files changed, 1415 insertions(+), 1278 deletions(-)
 create mode 100644 drivers/dax/mapping.c

base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555

