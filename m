Return-Path: <nvdimm+bounces-3149-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 43AE74C5AF8
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 13:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 99F261C0551
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 12:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FA548BD;
	Sun, 27 Feb 2022 12:09:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F4B48B6
	for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 12:09:04 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AhfpkI6gn03LpJm5iP9LzOcBWX161CxEKZh0ujC4?=
 =?us-ascii?q?5NGQNrF6WrkUHyjYWX2yHa/feMGenc410PIrk/EIP7JPUn9JnG1RtqHw8FHgiR?=
 =?us-ascii?q?ejtX4rAdhiqV8+xwmwvdGo+toNGLICowPkcFhcwnT/wdOixxZVA/fvQHOCkUra?=
 =?us-ascii?q?dYnkZqTJME0/NtzoywobVvaY42bBVMyvV0T/Di5W31G2NglaYAUpIg063ky6Di?=
 =?us-ascii?q?dyp0N8uUvPSUtgQ1LPWvyF94JvyvshdJVOgKmVfNrbSq+ouUNiEEm3lExcFUrt?=
 =?us-ascii?q?Jk57wdAsEX7zTIROTzHFRXsBOgDAb/mprjPl9b6FaNC+7iB3Q9zx14M9QvJqrW?=
 =?us-ascii?q?EEnOLbQsOoAURhECDw4NqpDkFPCCSHl65TIkBOWLRMAxN0rVinaJ7Yw9u9pAG1?=
 =?us-ascii?q?m++YfLTcXZBGfwemxxdqTSuJsrsUlItPiMI4Wtjdn1z6xJfovR9bBBbrL4dtZ1?=
 =?us-ascii?q?TIrrsFIAfvaIcEebFJHYBbfZBtAElQaEpQzmKGvnHaXWzlZrk+F4K8yy2vNxQd?=
 =?us-ascii?q?ylr/3P7L9fMKGRMBQtkKZvX7duWD4BAwKctCS11Kt8Huqi6nEnT7TX5gbH7m1s?=
 =?us-ascii?q?PVthTW7wm0VFQ1TW0C3rOe0jmagVN9FbU8Z4Cwjqe417kPDZt38WQCo5X2JpBg?=
 =?us-ascii?q?RX/JOHOAgrgKA0KzZ50CeHGdsZjpAbsE28d84XhQ02VKT2dDkHzpitPuSU331y?=
 =?us-ascii?q?1s+hVteIgBMdSlbO3BCFlBDvrHeTEgIpkqnZr5e/GSd07UZwQ3N/g0=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AqTB5vKvWqXOeuAG9rVpcKm5Y7skCW4Mji2hC?=
 =?us-ascii?q?6mlwRA09TyXGra2TdaUgvyMc1gx7ZJhBo7+90ci7MBfhHPtOjbX5Uo3SOTUO1F?=
 =?us-ascii?q?HYTr2KjrGSuwEIeReOj9K1vJ0IG8YeNDSZNykdsS+Q2mmF+rgbsbq6GPfCv5a4?=
 =?us-ascii?q?854hd3AbV4hQqyNCTiqLGEx/QwdLQbI/CZqn/8JC4x6tY24eYMiXDmQMG7Grna?=
 =?us-ascii?q?y4qLvWJTo9QzI34giHij2lrJb8Dhijxx8bFxdC260r/2TpmxHwoo+jr/a44BnB?=
 =?us-ascii?q?0HK71eUkpPLRjv94QOCcgMkcLTvhziyyYp56ZrGEtDcp5Mmy9VcDirD30mEdFv?=
 =?us-ascii?q?U2z0mUUnC+oBPr1QWl+i0p8WXexViRhmamidDlRQg9F9FKietiA2zkAnIbzZlB?=
 =?us-ascii?q?OZ9wrimkX8I9N2KLoM293am9a/hSrDv8nZJ4+tRjwkC2UuMlGcBsRMIkjQ9o+a?=
 =?us-ascii?q?w7bVjHAbAcYZJT5f7nlYtrmHOhHg7kVzpUsa2RtkpaJGb7fqFFgL3h7wRr?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="122037686"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Feb 2022 20:07:51 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id D5A014D169EF;
	Sun, 27 Feb 2022 20:07:48 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 27 Feb 2022 20:07:48 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 27 Feb 2022 20:07:48 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v11 0/8] fsdax: introduce fs query to support reflink
Date: Sun, 27 Feb 2022 20:07:39 +0800
Message-ID: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: D5A014D169EF.A274D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is aimed to support shared pages tracking for fsdax.

Changes since V10:
  - Use cmpxchg() to prevent concurrent registration/unregistration
  - Use phys_addr_t for ->memory_failure()
  - Add dax_entry_lock() for dax_lock_mapping_entry()
  - Fix offset and length calculation at the boundary of a filesystem

This patchset moves owner tracking from dax_assocaite_entry() to pmem
device driver, by introducing an interface ->memory_failure() for struct
pagemap.  This interface is called by memory_failure() in mm, and
implemented by pmem device.

Then call holder operations to find the filesystem which the corrupted
data located in, and call filesystem handler to track files or metadata
associated with this page.

Finally we are able to try to fix the corrupted data in filesystem and
do other necessary processing, such as killing processes who are using
the files affected.

The call trace is like this:
memory_failure()
|* fsdax case
|------------
|pgmap->ops->memory_failure()      => pmem_pgmap_memory_failure()
| dax_holder_notify_failure()      =>
|  dax_device->holder_ops->notify_failure() =>
|                                     - xfs_dax_notify_failure()
|  |* xfs_dax_notify_failure()
|  |--------------------------
|  |   xfs_rmap_query_range()
|  |    xfs_dax_failure_fn()
|  |    * corrupted on metadata
|  |       try to recover data, call xfs_force_shutdown()
|  |    * corrupted on file data
|  |       try to recover data, call mf_dax_kill_procs()
|* normal case
|-------------
|mf_generic_kill_procs()

==
Shiyang Ruan (8):
  dax: Introduce holder for dax_device
  mm: factor helpers for memory_failure_dev_pagemap
  pagemap,pmem: Introduce ->memory_failure()
  fsdax: Introduce dax_lock_mapping_entry()
  mm: move pgoff_address() to vma_pgoff_address()
  mm: Introduce mf_dax_kill_procs() for fsdax case
  xfs: Implement ->notify_failure() for XFS
  fsdax: set a CoW flag when associate reflink mappings

 drivers/dax/super.c         |  89 +++++++++++++
 drivers/nvdimm/pmem.c       |  16 +++
 fs/dax.c                    | 140 ++++++++++++++++++---
 fs/xfs/Makefile             |   1 +
 fs/xfs/xfs_buf.c            |  12 ++
 fs/xfs/xfs_fsops.c          |   3 +
 fs/xfs/xfs_mount.h          |   1 +
 fs/xfs/xfs_notify_failure.c | 235 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_notify_failure.h |  10 ++
 fs/xfs/xfs_super.c          |   6 +
 include/linux/dax.h         |  47 +++++++
 include/linux/memremap.h    |  12 ++
 include/linux/mm.h          |  17 +++
 include/linux/page-flags.h  |   6 +
 mm/memory-failure.c         | 240 ++++++++++++++++++++++++++----------
 15 files changed, 747 insertions(+), 88 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.c
 create mode 100644 fs/xfs/xfs_notify_failure.h

-- 
2.35.1




