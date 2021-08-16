Return-Path: <nvdimm+bounces-881-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789E83ECE67
	for <lists+linux-nvdimm@lfdr.de>; Mon, 16 Aug 2021 08:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 380AB1C0A0A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 16 Aug 2021 06:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69816D19;
	Mon, 16 Aug 2021 06:05:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67856D13
	for <nvdimm@lists.linux.dev>; Mon, 16 Aug 2021 06:05:21 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AoMiQhKGhF1zFyE6epLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.84,324,1620662400"; 
   d="scan'208";a="112944832"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 16 Aug 2021 14:04:10 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 031C54D0D4BB;
	Mon, 16 Aug 2021 14:04:08 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Mon, 16 Aug 2021 14:04:04 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Mon, 16 Aug 2021 14:04:01 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <djwong@kernel.org>, <hch@lst.de>, <linux-xfs@vger.kernel.org>
CC: <ruansy.fnst@fujitsu.com>, <dan.j.williams@intel.com>,
	<david@fromorbit.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>
Subject: [PATCH v7 0/8] fsdax,xfs: Add reflink&dedupe support for fsdax
Date: Mon, 16 Aug 2021 14:03:51 +0800
Message-ID: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 031C54D0D4BB.A521A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is attempt to add CoW support for fsdax, and take XFS,
which has both reflink and fsdax feature, as an example.

Changes from V6:
 - Rebased on switch iomap to an iterator model v2[1]
 - Replace iomap_apply2() with iomap_iter2() because of the new model
 - Introduce dax_iomap_ops and dax_iomap_ops->actor_end() to handle the end
     of CoW before iomap_ops->iomap_end()

One of the key mechanism need to be implemented in fsdax is CoW.  Copy
the data from srcmap before we actually write data to the destance
iomap.  And we just copy range in which data won't be changed.

Another mechanism is range comparison.  In page cache case, readpage()
is used to load data on disk to page cache in order to be able to
compare data.  In fsdax case, readpage() does not work.  So, we need
another compare data with direct access support.

With the two mechanisms implemented in fsdax, we are able to make reflink
and fsdax work together in XFS.

(Rebased on v5.14-rc4 and Christoph's "switch iomap to an iterator model v2"[1])
[1]: https://lore.kernel.org/linux-xfs/20210809061244.1196573-1-hch@lst.de/
==

Shiyang Ruan (8):
  fsdax: Output address in dax_iomap_pfn() and rename it
  fsdax: Introduce dax_iomap_cow_copy()
  fsdax: Replace mmap entry in case of CoW
  fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
  iomap: Introduce iomap_iter2 for two files
  fsdax: Dedup file range to use a compare function
  fsdax: Introduce dax_iomap_ops for end of reflink
  fs/xfs: Add dax dedupe support

 fs/dax.c               | 307 ++++++++++++++++++++++++++++++++++++-----
 fs/ext2/ext2.h         |   3 +
 fs/ext2/file.c         |   6 +-
 fs/ext2/inode.c        |  11 +-
 fs/ext4/ext4.h         |   3 +
 fs/ext4/file.c         |   6 +-
 fs/ext4/inode.c        |  13 +-
 fs/iomap/buffered-io.c |   7 +-
 fs/iomap/core.c        |  51 +++++++
 fs/remap_range.c       |  39 ++++--
 fs/xfs/xfs_bmap_util.c |   3 +-
 fs/xfs/xfs_file.c      |  10 +-
 fs/xfs/xfs_inode.c     |  57 ++++++++
 fs/xfs/xfs_inode.h     |   1 +
 fs/xfs/xfs_iomap.c     |  36 ++++-
 fs/xfs/xfs_iomap.h     |  33 +++++
 fs/xfs/xfs_iops.c      |   7 +-
 fs/xfs/xfs_reflink.c   |  15 +-
 include/linux/dax.h    |  32 ++++-
 include/linux/fs.h     |  12 +-
 include/linux/iomap.h  |   3 +
 21 files changed, 570 insertions(+), 85 deletions(-)

-- 
2.32.0




