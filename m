Return-Path: <nvdimm+bounces-1443-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F7E041A8C3
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 08:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 96A683E103B
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 06:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248EF3FEC;
	Tue, 28 Sep 2021 06:23:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E14A72
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 06:23:21 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AFFt0LKxfWu33+AlI5T56t+dMxyrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApGsrhjYEmGdJUTuAM/mJM2bxf98kOYq1p0pQ7MfSy4NrHQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9krF3oTJ9yEmjPnZHOqkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhhc14zs5c85K2U?=
 =?us-ascii?q?hsBMLDOmfgGTl9TFCQW0ahuoeaaeSnh4JfMp6HBWz62qxl0N2k6NJMZ9s55G2Z?=
 =?us-ascii?q?L8uYSKSxLZReG78qpwba/W8FtgMo5JcXmNY9ZvWtvpRnVBPBgQ9bcQqHO5NZdx?=
 =?us-ascii?q?x8xgNxDGbDVYM9xQTZtcxPGbDVMN00RBZZ4m/2n7lH5bTFZrVe9oass/3OVyA1?=
 =?us-ascii?q?3zairPNfLEvSKTsV9ml2E4G7Ll0zjDRYeOMOOzxKe72mhwOPC9Qv/WYQPBPi27?=
 =?us-ascii?q?fJnnlCX7nIcBQdQVlahp/S9zEmkVLp3L00S5zprrqUo8kGvZsfyUgf+o3OeuBM?=
 =?us-ascii?q?YHd1KHIUS7ACL17qR8wiCLnYLQyQHa9E8ssIyAzsw2TehgdLzAhR9vbuUVzSZ9?=
 =?us-ascii?q?7GJvXW1IydTMGxqWMOuZWPp+PG6+Mdq0E2JFY0lTcaIYhTOMWmY61i3QOIW3t3?=
 =?us-ascii?q?/VfI26pg=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AkKI7aa48P9A/22J9owPXwPTXdLJyesId70hD?=
 =?us-ascii?q?6qkRc20wTiX8ra2TdZsguyMc9wx6ZJhNo7G90cq7MBbhHPxOkOos1N6ZNWGIhI?=
 =?us-ascii?q?LCFvAB0WKN+V3dMhy73utc+IMlSKJmFeD3ZGIQse/KpCW+DPYsqePqzJyV?=
X-IronPort-AV: E=Sophos;i="5.85,328,1624291200"; 
   d="scan'208";a="115096937"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Sep 2021 14:23:14 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 13B2A4D0DC7F;
	Tue, 28 Sep 2021 14:23:13 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 28 Sep 2021 14:23:12 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 28 Sep 2021 14:23:11 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <dan.j.williams@intel.com>, <djwong@kernel.org>, <hch@lst.de>,
	<linux-xfs@vger.kernel.org>
CC: <ruansy.fnst@fujitsu.com>, <david@fromorbit.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>
Subject: [PATCH v10 0/8] fsdax,xfs: Add reflink&dedupe support for fsdax
Date: Tue, 28 Sep 2021 14:23:03 +0800
Message-ID: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 13B2A4D0DC7F.A48CF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is attempt to add CoW support for fsdax, and take XFS,
which has both reflink and fsdax feature, as an example.

Changes from V9:
 - Rebased on v5.15-rc3
 - Patch 3: Fix build error when CONFIG_FS_DAX_PMD not set
 - Patch 4: Add 'const' prefix for iomap_iter
 - Patch 7: Introduce xfs_dax_iomap_fault(),
              fix logic in xfs_dax_write_iomap_end()
 - Patch 8: Remove AIL lock check when nested locking two inodes

One of the key mechanism need to be implemented in fsdax is CoW.  Copy
the data from srcmap before we actually write data to the destance
iomap.  And we just copy range in which data won't be changed.

Another mechanism is range comparison.  In page cache case, readpage()
is used to load data on disk to page cache in order to be able to
compare data.  In fsdax case, readpage() does not work.  So, we need
another compare data with direct access support.

With the two mechanisms implemented in fsdax, we are able to make reflink
and fsdax work together in XFS.

(Rebased on v5.15-rc3)
==

Shiyang Ruan (8):
  fsdax: Output address in dax_iomap_pfn() and rename it
  fsdax: Introduce dax_iomap_cow_copy()
  fsdax: Replace mmap entry in case of CoW
  fsdax: Convert dax_iomap_zero to iter model
  fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
  fsdax: Dedup file range to use a compare function
  xfs: support CoW in fsdax mode
  xfs: Add dax dedupe support

 fs/dax.c               | 286 +++++++++++++++++++++++++++++++++--------
 fs/iomap/buffered-io.c |   3 +-
 fs/remap_range.c       |  31 ++++-
 fs/xfs/xfs_bmap_util.c |   3 +-
 fs/xfs/xfs_file.c      |   9 +-
 fs/xfs/xfs_inode.c     |  69 +++++++++-
 fs/xfs/xfs_inode.h     |   1 +
 fs/xfs/xfs_iomap.c     |  30 ++++-
 fs/xfs/xfs_iomap.h     |  44 +++++++
 fs/xfs/xfs_iops.c      |   7 +-
 fs/xfs/xfs_reflink.c   |  15 ++-
 include/linux/dax.h    |  11 +-
 include/linux/fs.h     |  12 +-
 13 files changed, 433 insertions(+), 88 deletions(-)

-- 
2.33.0




