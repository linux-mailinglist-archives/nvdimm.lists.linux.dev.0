Return-Path: <nvdimm+bounces-662-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D083DB558
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jul 2021 10:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 89D971C0AF3
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jul 2021 08:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BFD3489;
	Fri, 30 Jul 2021 08:52:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0922C70
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 08:52:55 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ANiX2cqnqx3FARrJ6zCopma8oMGzpDfIQ3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fw9vre+MjzsCWYtN9/Yh8dcK+7UpVoLUm8yXcX2/h1AV7BZniEhI?=
 =?us-ascii?q?LAFugLgrcKqAeQeREWmNQ86Y5QN4B6CPDVSWNxlNvG5mCDeOoI8Z2q97+JiI7l?=
 =?us-ascii?q?o0tQcQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,281,1620662400"; 
   d="scan'208";a="112070560"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Jul 2021 16:52:52 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id C2E894D0D49D;
	Fri, 30 Jul 2021 16:52:48 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 30 Jul 2021 16:52:49 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 30 Jul 2021 16:52:47 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
CC: <djwong@kernel.com>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@lst.de>, <agk@redhat.com>, <snitzer@redhat.com>
Subject: [PATCH v6 0/9] fsdax: introduce fs query to support reflink
Date: Fri, 30 Jul 2021 16:52:36 +0800
Message-ID: <20210730085245.3069812-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: C2E894D0D49D.A3ADA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is aimed to support shared pages tracking for fsdax.

Change from V5:
  - fix dax_load_pfn(), take locked,empty,zero dax entry into
       consideration
  - fix the usage of rwsem lock for dax_device's holder
  - fix build error reported by kernelbot
  - keep functionality of dax_{,dis}assocaite_entry() for filesystems
       doesn't have rmapbt feature
  - Rebased to v5.14-rc3

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
|                                     - md_dax_notify_failure()
|  |* xfs_dax_notify_failure()
|  |--------------------------
|  |   xfs_rmap_query_range()
|  |    xfs_currupt_helper()
|  |    * corrupted on metadata
|  |       try to recover data, call xfs_force_shutdown()
|  |    * corrupted on file data
|  |       try to recover data, call mf_dax_kill_procs()
|  |* md_dax_notify_failure()
|  |-------------------------
|      md_targets->iterate_devices()
|      md_targets->rmap()          => linear_rmap()
|       dax_holder_notify_failure()
|* normal case
|-------------
 mf_generic_kill_procs()

The fsdax & reflink support for XFS is not contained in this patchset.

(Rebased on v5.14-rc3)
==

Shiyang Ruan (9):
  pagemap: Introduce ->memory_failure()
  dax: Introduce holder for dax_device
  mm: factor helpers for memory_failure_dev_pagemap
  pmem,mm: Implement ->memory_failure in pmem driver
  mm: Introduce mf_dax_kill_procs() for fsdax case
  xfs: Implement ->corrupted_range() for XFS
  dm: Introduce ->rmap() to find bdev offset
  md: Implement dax_holder_operations
  fsdax: add exception for reflinked files

 block/genhd.c                 |  56 +++++++++++
 drivers/dax/super.c           |  58 ++++++++++++
 drivers/md/dm-linear.c        |  20 ++++
 drivers/md/dm.c               | 126 ++++++++++++++++++++++++-
 drivers/nvdimm/pmem.c         |  13 +++
 fs/dax.c                      |  59 ++++++++----
 fs/xfs/xfs_fsops.c            |   5 +
 fs/xfs/xfs_mount.h            |   1 +
 fs/xfs/xfs_super.c            | 135 +++++++++++++++++++++++++++
 include/linux/dax.h           |  46 +++++++++
 include/linux/device-mapper.h |   5 +
 include/linux/genhd.h         |   1 +
 include/linux/memremap.h      |   9 ++
 include/linux/mm.h            |  10 ++
 mm/memory-failure.c           | 169 +++++++++++++++++++++++-----------
 15 files changed, 641 insertions(+), 72 deletions(-)

-- 
2.32.0




