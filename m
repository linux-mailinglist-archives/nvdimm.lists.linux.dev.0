Return-Path: <nvdimm+bounces-3780-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 175C651EE29
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 16:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48A51280AB1
	for <lists+linux-nvdimm@lfdr.de>; Sun,  8 May 2022 14:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1181859;
	Sun,  8 May 2022 14:37:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625BE184B
	for <nvdimm@lists.linux.dev>; Sun,  8 May 2022 14:37:38 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3A9n+Pf6hck/Mud4EYtngkXHvUX161uBEKZh0ujC4?=
 =?us-ascii?q?5NGQNrF6WrkUCzzBOCDyCbvmJZWGkfIwlboWy9kpUuJbRzYcyHFM4q3w8FHgiR?=
 =?us-ascii?q?ejtX4rAdhiqV8+xwmwvdGo+toNGLICowPkcFhcwnT/wdOixxZVA/fvQHOCkUra?=
 =?us-ascii?q?dYnkZqTJME0/NtzoywobVvaY42bBVMyvV0T/Di5W31G2NglaYAUpIg063ky6Di?=
 =?us-ascii?q?dyp0N8uUvPSUtgQ1LPWvyF94JvyvshdJVOgKmVfNrbSq+ouUNiEEm3lExcFUrt?=
 =?us-ascii?q?Jk57wdAsEX7zTIROTzHFRXsBOgDAb/mprjPl9b6FaNC+7iB3Q9zx14M9QvJqrW?=
 =?us-ascii?q?EEnOLbQsOoAURhECDw4NqpDkFPCCSHl7ZTMkhKdKBMAxN0rVinaJ7Yw9u9pAG1?=
 =?us-ascii?q?m++YfLTcXZBGfwemxxdqTTuhqg8UqK8nmFIMCs25tzHfSCvNOaZDIQ43L49FC1?=
 =?us-ascii?q?Ts9j8wIGuzRD+IGaD5rfTzBZRNVM1saAZ54m/2n7lHzejseqhSKpK4z4mHW1yR?=
 =?us-ascii?q?w1qTgNJzefdnibclXgUGeqUrF8n7/DxVcM8aQoRKB83SxlqrKmAv4RosZF/u/7?=
 =?us-ascii?q?PECqFuNym0WDTUSVECnur+9i0ijS5RTJlJ80iwnqrk7skysVNjyQha4oVaCsxV?=
 =?us-ascii?q?aUN1Ve8U44QeAjKHU/i6eHGEPSjMHY9sj3OcsSjsu2kCYmfvyGCdi9rGYIVqZ9?=
 =?us-ascii?q?7GJvXa8IiQYM2IGTTELQBFD4NT5pow3yBXVQb5LFK+zk82wGjzqxT2OhDYxiq9?=
 =?us-ascii?q?VjsMR0ai/u1fdjFqEopnPUx5w9gvMdnyq4xk/Z4O/YYGsr1/B4p5oMoeDSXGTs?=
 =?us-ascii?q?X4FhY6a7eYTHdeKjiPLXeZlIV0Dz55pKxWF2Rg2QcZnrG/rphaekUlryGkWDC9?=
 =?us-ascii?q?U3gwsIlcFuHPuhD4=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A5w5ta657PAYRiMjBqwPXwCDXdLJyesId70hD?=
 =?us-ascii?q?6qhwISY6TiX+rbHLoB17726StN9/YhEdcLy7VJVoIkmskKKdg7NhXotKNTOO0A?=
 =?us-ascii?q?DDQb2KhrGC/9SPIULDH5ZmpMVdmrZFeabNJGk/ncDn+xO5Dtpl5NGG9ZqjjeDY?=
 =?us-ascii?q?w2wFd3ASV4hQqxd+Fh2AElB7AC1PBZ8CHpKa4cZd4xW6f3B/VLXCOlA1G/jEu8?=
 =?us-ascii?q?bQlI/rJToPBxsc4gGIij+yrJ7WeiLouCsjbw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124075733"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 May 2022 22:36:25 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 1A2BF4D16FDF;
	Sun,  8 May 2022 22:36:22 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 8 May 2022 22:36:24 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 8 May 2022 22:36:20 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>, <naoya.horiguchi@nec.com>,
	<linmiaohe@huawei.com>
Subject: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Date: Sun, 8 May 2022 22:36:06 +0800
Message-ID: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 1A2BF4D16FDF.A278D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This is a combination of two patchsets:
 1.fsdax-rmap: https://lore.kernel.org/linux-xfs/20220419045045.1664996-1-ruansy.fnst@fujitsu.com/
 2.fsdax-reflink: https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/

 Changes since v13 of fsdax-rmap:
  1. Fixed mistakes during rebasing code to latest next-
  2. Rebased to next-20220504

 Changes since v10 of fsdax-reflink:
  1. Rebased to next-20220504 and fsdax-rmap
  2. Dropped a needless cleanup patch: 'fsdax: Convert dax_iomap_zero to
      iter model'
  3. Fixed many conflicts during rebasing
  4. Fixed a dedupe bug in Patch 05: the actuall length to compare could be
      shorter than smap->length or dmap->length.
  PS: There are many changes during rebasing.  I think it's better to
      review again.

==
Shiyang Ruan (14):
  fsdax-rmap:
    dax: Introduce holder for dax_device
    mm: factor helpers for memory_failure_dev_pagemap
    pagemap,pmem: Introduce ->memory_failure()
    fsdax: Introduce dax_lock_mapping_entry()
    mm: Introduce mf_dax_kill_procs() for fsdax case
    xfs: Implement ->notify_failure() for XFS
    fsdax: set a CoW flag when associate reflink mappings
  fsdax-reflink:
    fsdax: Output address in dax_iomap_pfn() and rename it
    fsdax: Introduce dax_iomap_cow_copy()
    fsdax: Replace mmap entry in case of CoW
    fsdax: Add dax_iomap_cow_copy() for dax zero
    fsdax: Dedup file range to use a compare function
    xfs: support CoW in fsdax mode
    xfs: Add dax dedupe support

 drivers/dax/super.c         |  67 +++++-
 drivers/md/dm.c             |   2 +-
 drivers/nvdimm/pmem.c       |  17 ++
 fs/dax.c                    | 398 ++++++++++++++++++++++++++++++------
 fs/erofs/super.c            |  13 +-
 fs/ext2/super.c             |   7 +-
 fs/ext4/super.c             |   9 +-
 fs/remap_range.c            |  31 ++-
 fs/xfs/Makefile             |   5 +
 fs/xfs/xfs_buf.c            |  10 +-
 fs/xfs/xfs_file.c           |   9 +-
 fs/xfs/xfs_fsops.c          |   3 +
 fs/xfs/xfs_inode.c          |  69 ++++++-
 fs/xfs/xfs_inode.h          |   1 +
 fs/xfs/xfs_iomap.c          |  46 ++++-
 fs/xfs/xfs_iomap.h          |   3 +
 fs/xfs/xfs_mount.h          |   1 +
 fs/xfs/xfs_notify_failure.c | 220 ++++++++++++++++++++
 fs/xfs/xfs_reflink.c        |  12 +-
 fs/xfs/xfs_super.h          |   1 +
 include/linux/dax.h         |  56 ++++-
 include/linux/fs.h          |  12 +-
 include/linux/memremap.h    |  12 ++
 include/linux/mm.h          |   2 +
 include/linux/page-flags.h  |   6 +
 mm/memory-failure.c         | 257 ++++++++++++++++-------
 26 files changed, 1087 insertions(+), 182 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.c

-- 
2.35.1




