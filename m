Return-Path: <nvdimm+bounces-3874-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A173553C465
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 07:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07A4728098B
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 05:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9F2A5E;
	Fri,  3 Jun 2022 05:37:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D315A4C
	for <nvdimm@lists.linux.dev>; Fri,  3 Jun 2022 05:37:54 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AoybKC6IRENG85+JmFE+RLJQlxSXFcZb7ZxGrkP8?=
 =?us-ascii?q?bfHCwhT4mgzMFzjcbDG/SPPqMZTCgfNl+Pdi3oR4F7Z7QzINqS1BcGVNFFSwT8?=
 =?us-ascii?q?ZWfbTi6wuYcBwvLd4ubChsPA/w2MrEsF+hpCC+MzvuRGuK59yMkj/nRHuOU5NP?=
 =?us-ascii?q?sYUideyc1EU/Ntjozw4bVsqYw6TSIK1vlVeHa+qUzC3f5s9JACV/43orYwP9ZU?=
 =?us-ascii?q?FsejxtD1rA2TagjUFYzDBD5BrpHTU26ByOQroW5goeHq+j/ILGRpgs1/j8mDJW?=
 =?us-ascii?q?rj7T6blYXBLXVOGBiiFIPA+773EcE/Xd0j87XN9JFAatToy+UltZq2ZNDs4esY?=
 =?us-ascii?q?Qk0PKzQg/lbWB5de817FfQcpOGXfyjn66R/yGWDKRMA2c5GAEgoPIEw9PxwBGZ?=
 =?us-ascii?q?U//0EbjsKa3irg+OwxbOyTelhrsQ+JdbmPcUUvXQI5THSDd4nR57ZSqnH7NMe2?=
 =?us-ascii?q?y0/7uhRHPLaduIYbzR1ZRjNahEJPU0YYLoyleHuhD/gcjlcqVuQvoI25XTeyEp?=
 =?us-ascii?q?6172FGNbXZduMSu1Wk1yeq2aA+H72ajkeNdqC2X+A91qvmObEnmX8Qo16PLS77?=
 =?us-ascii?q?vtChFyV23xWBhoLU1eyvfi+jAi5Qd03A0oK9isrqIA29Ve3VZ/5XhulsDiIswB?=
 =?us-ascii?q?0c9xZFPwzrgGK0Kvb/g2ZB0ACQzUHY9sj3Oc0TDonkFSJgvvuHzVktLDTQnWYn?=
 =?us-ascii?q?p+OojS2NTcEK0cZeDQJCwcIi/HnoYcunlfBVdpuDqOxpsP6FCu2wD2QqiU6wbI?=
 =?us-ascii?q?JgqYj06S94ECCgD+2oJXNZhA66x+RXW+/6A59Iom/aOSA7Vnd8OYFPIiCZkeOs?=
 =?us-ascii?q?WJCmMWE6u0KS5aXm0SlXuQXG5m76vCELnvYgFhyD98m7Tvr5n3LQGz6yFmSP28?=
 =?us-ascii?q?waoBdJ2CvOxSV5GtsCFZoFCPCRcdKj0iZV6zGFZTdKOk=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AV2RlyakWU/iGSUXqst/NsziZbFLpDfLE3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fxl6iV8sjzsiWE7Ar5OUtQ/uxoV5PhfZqxz/JICOoqTNKftWvdyQ?=
 =?us-ascii?q?iVxehZhOOIqVDd8kbFl9K1u50OT0EHMqyTMbFlt7eA3CCIV8Yn3MKc8L2lwcPX?=
 =?us-ascii?q?z3JWRwlsbK16hj0JczqzIwlnQhVcH5olGN657spDnTCpfnMadYCVHX8ANtKz3+?=
 =?us-ascii?q?Hjpdb3ZwIcHR475E2rhTOs0rTzFB+VxVM/flp0sNEfzVQ=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124686802"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Jun 2022 13:37:45 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id ECBEC4D17189;
	Fri,  3 Jun 2022 13:37:40 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 3 Jun 2022 13:37:41 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 3 Jun 2022 13:37:40 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <akpm@linux-foundation.org>, <jane.chu@oracle.com>,
	<rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>, <willy@infradead.org>,
	<naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>
Subject: [PATCHSETS v2]  v14 fsdax-rmap + v11 fsdax-reflink
Date: Fri, 3 Jun 2022 13:37:24 +0800
Message-ID: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: ECBEC4D17189.A392F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

 Changes since v1[1]:
  1. Rebased to mm-unstable, solved many conflicts

[1] https://lore.kernel.org/linux-xfs/20220508143620.1775214-1-ruansy.fnst@fujitsu.com/


This is an *updated* combination of two patchsets:
 1.fsdax-rmap: https://lore.kernel.org/linux-xfs/20220419045045.1664996-1-ruansy.fnst@fujitsu.com/
 2.fsdax-reflink: https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/


==
Shiyang Ruan (14):
  dax: Introduce holder for dax_device
  mm: factor helpers for memory_failure_dev_pagemap
  pagemap,pmem: Introduce ->memory_failure()
  fsdax: Introduce dax_lock_mapping_entry()
  mm: Introduce mf_dax_kill_procs() for fsdax case
  xfs: Implement ->notify_failure() for XFS
  fsdax: set a CoW flag when associate reflink mappings
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
 fs/dax.c                    | 399 ++++++++++++++++++++++++++++++------
 fs/erofs/super.c            |  10 +-
 fs/ext2/super.c             |   7 +-
 fs/ext4/super.c             |   9 +-
 fs/remap_range.c            |  31 ++-
 fs/xfs/Makefile             |   5 +
 fs/xfs/xfs_buf.c            |  10 +-
 fs/xfs/xfs_file.c           |  35 +++-
 fs/xfs/xfs_fsops.c          |   3 +
 fs/xfs/xfs_inode.c          |  69 ++++++-
 fs/xfs/xfs_inode.h          |   1 +
 fs/xfs/xfs_iomap.c          |  30 ++-
 fs/xfs/xfs_iomap.h          |   1 +
 fs/xfs/xfs_mount.h          |   1 +
 fs/xfs/xfs_notify_failure.c | 220 ++++++++++++++++++++
 fs/xfs/xfs_reflink.c        |  12 +-
 fs/xfs/xfs_super.h          |   1 +
 include/linux/dax.h         |  56 ++++-
 include/linux/fs.h          |  12 +-
 include/linux/memremap.h    |  12 ++
 include/linux/mm.h          |   2 +
 include/linux/page-flags.h  |   6 +
 mm/memory-failure.c         | 265 +++++++++++++++++-------
 26 files changed, 1098 insertions(+), 185 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.c

-- 
2.36.1




