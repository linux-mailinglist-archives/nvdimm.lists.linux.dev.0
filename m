Return-Path: <nvdimm+bounces-3585-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3F2506389
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Apr 2022 06:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 522AE3E0F53
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Apr 2022 04:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA523EA4;
	Tue, 19 Apr 2022 04:52:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC644EA1
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 04:52:00 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3Au2RBvKjQPIjEua4iyUkhZ8J3X161CxEKZh0ujC4?=
 =?us-ascii?q?5NGQNrF6WrkUEyWUXXWCBOPmLYjbwfYx3aIXg/BkC78WDxoAwTFFqpXw8FHgiR?=
 =?us-ascii?q?ejtX4rAdhiqV8+xwmwvdGo+toNGLICowPkcFhcwnT/wdOixxZVA/fvQHOCkUra?=
 =?us-ascii?q?dYnkZqTJME0/NtzoywobVvaY42bBVMyvV0T/Di5W31G2NglaYAUpIg063ky6Di?=
 =?us-ascii?q?dyp0N8uUvPSUtgQ1LPWvyF94JvyvshdJVOgKmVfNrbSq+ouUNiEEm3lExcFUrt?=
 =?us-ascii?q?Jk57wdAsEX7zTIROTzHFRXsBOgDAb/mprjPl9b6FaNC+7iB3Q9zx14M9QvJqrW?=
 =?us-ascii?q?EEnOLbQsOoAURhECDw4NqpDkFPCCSHl6pLMlhKaLRMAxN0rVinaJ7Yw9u9pAG1?=
 =?us-ascii?q?m++YfLTcXZBGfwemxxdqTSuJsrsUlItPiMI4Wtjdn1z6xJfovR9bBBbrL4dtZ1?=
 =?us-ascii?q?TIrrsFIAfvaIcEebFJHYBbfZBtAElQaEpQzmKGvnHaXWzlZrk+F4K8yy2vNxQd?=
 =?us-ascii?q?ylr/3P7L9fMKGRMBQtkKZvX7duWD4BAwKctCS11Kt8Huqi6nEnT7TX5gbH7m1s?=
 =?us-ascii?q?PVthTW7wm0VFQ1TW0C3rOe0jmagVN9FbU8Z4Cwjqe417kPDZt38WQCo5X2JpBg?=
 =?us-ascii?q?RX/JOHOAgrgKA0KzZ50CeHGdsZjpAbsE28d84XhQ02VKT2dDkHzpitPuSU331y?=
 =?us-ascii?q?1s+hVteIgBMdSlbO3BCFlBDvrHeTEgIpkqnZr5e/GSd0rUZwQ3N/g0=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AOx2m76hS8LA8xk4fM2ePciqv63BQXjAji2hC?=
 =?us-ascii?q?6mlwRA09TySZ//rOoB19726StN9xYgBHpTnuAtjifZqxz/FICOoqTNOftWvdyQ?=
 =?us-ascii?q?mVxehZhOOIqVCNJ8SUzI5gPMlbHZSWcOeAaGSSk/yKmjWQIpIxxsWd6qC0iaP7?=
 =?us-ascii?q?x3dpdwtjbKZt9G5Ce36mO3wzVA9bHoA4CZbZwsJGogCrcXMRYt/+KWICW4H41q?=
 =?us-ascii?q?b2vaOjcRgbHAQm9QXLqTup7YTxGx+e0gxbcx4n+8ZazVT4?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123671746"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Apr 2022 12:50:48 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id D439E4D17171;
	Tue, 19 Apr 2022 12:50:47 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 19 Apr 2022 12:50:47 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 19 Apr 2022 12:50:49 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 19 Apr 2022 12:50:45 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v13 0/7] fsdax: introduce fs query to support reflink
Date: Tue, 19 Apr 2022 12:50:38 +0800
Message-ID: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: D439E4D17171.A07DF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is aimed to support shared pages tracking for fsdax.

Changes since V12:
  - Rebased onto next-20220414
  - Do not continue ->notify_failure() if filesystem is not ready yet
  - Simplify the logic of setting CoW flag
  - Fix build warning/error and typo

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
Shiyang Ruan (7):
  dax: Introduce holder for dax_device
  mm: factor helpers for memory_failure_dev_pagemap
  pagemap,pmem: Introduce ->memory_failure()
  fsdax: Introduce dax_lock_mapping_entry()
  mm: Introduce mf_dax_kill_procs() for fsdax case
  xfs: Implement ->notify_failure() for XFS
  fsdax: set a CoW flag when associate reflink mappings

 drivers/dax/super.c         |  67 +++++++++-
 drivers/md/dm.c             |   2 +-
 drivers/nvdimm/pmem.c       |  17 +++
 fs/dax.c                    | 113 ++++++++++++++--
 fs/erofs/super.c            |  10 +-
 fs/ext2/super.c             |   7 +-
 fs/ext4/super.c             |   9 +-
 fs/xfs/Makefile             |   5 +
 fs/xfs/xfs_buf.c            |  10 +-
 fs/xfs/xfs_fsops.c          |   3 +
 fs/xfs/xfs_mount.h          |   1 +
 fs/xfs/xfs_notify_failure.c | 220 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.h          |   1 +
 include/linux/dax.h         |  48 +++++--
 include/linux/memremap.h    |  12 ++
 include/linux/mm.h          |   2 +
 include/linux/page-flags.h  |   6 +
 mm/memory-failure.c         | 255 +++++++++++++++++++++++++-----------
 18 files changed, 682 insertions(+), 106 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.c

-- 
2.35.1




