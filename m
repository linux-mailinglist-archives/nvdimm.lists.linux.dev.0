Return-Path: <nvdimm+bounces-3465-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 29AAC4FAEBE
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 18:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 3053F1C04FF
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 16:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4E51382;
	Sun, 10 Apr 2022 16:09:33 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A09137A
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 16:09:31 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AUjr6dKvHp6u5eFJwS7zZCIx6lOfnVD1fMUV32f8?=
 =?us-ascii?q?akzHdYEJGY0x3yjNJD2GEPa3eYmKjLY8iO42zoEhXvZeDmNc3T1c5qylgHilAw?=
 =?us-ascii?q?SbnLY7Hdx+vZUt+DSFioHpPtpxYMp+ZRCwNZie0SiyFb/6x/RGQ6YnSHuCmULS?=
 =?us-ascii?q?cY3goLeNZYHxJZSxLyrdRbrFA0YDR7zOl4bsekuWHULOX82cc3lE8t8pvnChSU?=
 =?us-ascii?q?MHa41v0iLCRicdj5zcyn1FNZH4WyDrYw3HQGuG4FcbiLwrPIS3Qw4/Xw/stIov?=
 =?us-ascii?q?NfrfTeUtMTKPQPBSVlzxdXK3Kbhpq/3R0i/hkcqFHLxo/ZzahxridzP1XqJW2U?=
 =?us-ascii?q?hZvMKvXhMwTThtZDzpje6ZB/dcrJFDm65fPkhaWKSOEL/JGSRte0Zcj0up+H2B?=
 =?us-ascii?q?C3fICLzUKdBqCm6S9x7fTYulnhuwiKsfxNY8Ss30myivWZd4qSJaFQePV5Ntc3?=
 =?us-ascii?q?T41nehPG+rTY4wSbj8HRBjCfBpJNX8UBYg4kePugWPwGxVcqVSIte8y5kDQ0gV?=
 =?us-ascii?q?60/7qKtW9UtqUScRQm26cp3na5CL9AxcHJJqTxCTt2nClgOKJliPmcIUIHba8+?=
 =?us-ascii?q?7hhh1j77mgSDgAGEFWgrfSnh0qWRd1SMQoX9zAooKx081akJvH5XhulsDuHswQ?=
 =?us-ascii?q?aVt54DeI38keOx7DS7gLfAXILJhZFado7pIomSycCyFCEhZXqCCZpvbnTTmiSn?=
 =?us-ascii?q?op4Bxva1TM9dDdEPHFbC1BepYSLnW36tTqXJv4LLUJ/poad9enM/g23?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ApSggPaOycVo3YMBcTimjsMiBIKoaSvp037Eq?=
 =?us-ascii?q?v3oedfUzSL39qynOpoV96faaslYssR0b9exoW5PwJE80l6QFgrX5VI3KNGKN1V?=
 =?us-ascii?q?dAR7sC0WKN+VLd8lXFh4xgPLlbAtNDIey1HV5nltz7/QX9N94hxeOM+Keuify2?=
 =?us-ascii?q?9QYVcShaL7Fn8xxiChuWVml/RAx9D5I/E5aGouVdoT7IQwVuUu2LQmkCQ/PYp8?=
 =?us-ascii?q?DG0LbvYRs9DRYh7wWUyROEgYSKdSSl4g=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123453820"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Apr 2022 00:09:08 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id DE4DC4D16FF4;
	Mon, 11 Apr 2022 00:09:05 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Mon, 11 Apr 2022 00:09:07 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Mon, 11 Apr 2022 00:09:04 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v12 0/7] fsdax: introduce fs query to support reflink
Date: Mon, 11 Apr 2022 00:08:57 +0800
Message-ID: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: DE4DC4D16FF4.A3DF7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is aimed to support shared pages tracking for fsdax.

Changes since V11:
  - Rebased onto next-20220408
  - Move dax_register_holder()'s job into fs_dax_get_by_bdev(),
      and move dax_unregister_holder()'s job into fs_put_dax()
  - Change ->memory_failure() signature to page-based
  - Drop "mm: move pgoff_address() to vma_pgoff_address()"
  - Fix #ifdef ... #endif wrappers
  - Other minor fixes

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

 drivers/dax/super.c         |  66 +++++++++-
 drivers/md/dm.c             |   2 +-
 drivers/nvdimm/pmem.c       |  17 +++
 fs/dax.c                    | 128 ++++++++++++++++--
 fs/erofs/super.c            |  10 +-
 fs/ext2/super.c             |   7 +-
 fs/ext4/super.c             |   9 +-
 fs/xfs/Makefile             |   5 +
 fs/xfs/xfs_buf.c            |   6 +-
 fs/xfs/xfs_fsops.c          |   3 +
 fs/xfs/xfs_mount.h          |   1 +
 fs/xfs/xfs_notify_failure.c | 219 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.h          |   1 +
 include/linux/dax.h         |  48 +++++--
 include/linux/memremap.h    |  12 ++
 include/linux/mm.h          |   2 +
 include/linux/page-flags.h  |   6 +
 mm/memory-failure.c         | 255 +++++++++++++++++++++++++-----------
 18 files changed, 691 insertions(+), 106 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.c

-- 
2.35.1




