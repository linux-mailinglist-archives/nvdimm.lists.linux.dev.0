Return-Path: <nvdimm+bounces-4731-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 648835B9766
	for <lists+linux-nvdimm@lfdr.de>; Thu, 15 Sep 2022 11:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DFFD1C2094D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 15 Sep 2022 09:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC80321E;
	Thu, 15 Sep 2022 09:27:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585C53205
	for <nvdimm@lists.linux.dev>; Thu, 15 Sep 2022 09:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1663234050; i=@fujitsu.com;
	bh=rHF3G99arO5Xb1oOl6p2CWpKaTC4O51FiBED8qOOawQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bHALgolozupaHtv90j1WQqk/WJzkKQVivGk6bXuu10yW0yLdmXtqwmv3SVNe9NIGu
	 v3C8gL01a0Xuqu753AF3T9YeGLuq1kcULEr295jnf+iUltHD4f5tVejGk9LI/V6rIp
	 YbkMtqn/u5GohnOWWuOFN9mS0oqvxMUKrSWXBTI3VpkNbCz3ZcpKdF5CpnLcxb2hd1
	 eDy1mJZAJZdpUiPsy3BWavRQ3iBbZsEkUQidN07URllpGmalIeOWw3vMDYFKk98b1I
	 er1DMKea0DHmz9li8bEq7D4Pz6yrjFm/nGOLlfXx8etqZTeNxyIklqgjYrAx6yL0Ns
	 i/YkwXmxReiYQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRWlGSWpSXmKPExsViZ8MxSZfpg1K
  ywfF/nBbTp15gtLj8hM9iz96TLBaXd81hs7i35j+rxa4/O9gtVv74w+rA7rF4z0smj02rOtk8
  Nn2axO7xYvNMRo/Pm+QCWKNYM/OS8isSWDPObVYrmMBbcWfhKfYGxlncXYxcHEICWxgllrfNZ
  INwljNJzP+0kRnC2cso8XbVS6YuRk4ONgEdiQsL/rKCJEQEJjFKHLtxkxkkwSxgLLFq1lR2EF
  tYwFbi8K8JbCA2i4CqxO91+1hAbF4BF4n1Xz6AxSUEFCSmPHzPDBEXlDg58wkLxBwJiYMvXgD
  FOYBqlCRmdsdDlFdINE4/xARhq0lcPbeJeQIj/ywk3bOQdC9gZFrFaJlUlJmeUZKbmJmja2hg
  oGtoaKprqGtqqZdYpZuol1qqW55aXKJrqJdYXqyXWlysV1yZm5yTopeXWrKJERjyKcWM1jsYO
  /p+6h1ilORgUhLlvXpUKVmILyk/pTIjsTgjvqg0J7X4EKMMB4eSBO/dN0A5waLU9NSKtMwcYP
  zBpCU4eJREeCtB0rzFBYm5xZnpEKlTjMYcaxsO7GXmmDr7335mIZa8/LxUKXHe82+BSgVASjN
  K8+AGwdLCJUZZKWFeRgYGBiGegtSi3MwSVPlXjOIcjErCvO4gC3ky80rg9r0COoUJ6BQja3mQ
  U0oSEVJSDUzZRzje+jc9nsxqKLCyhIu79PKiT+EmdpUyc35N2iM1xyAiwuB5zIOA2ZlB79atm
  tJ6JkTy6cxVXbdKlha4LP7L6fjlvsSTa4e2CJnOP/1+Ottii7mW3/5U1k3ac5Dt2NVH8m2Fc9
  /FZAUe0WjULZDarj6NqaWjm6tX758dX+OD6qp30U+SypdtyrZ8Jr1dX074ndT9mzrf562vOif
  hLhciUzSx7mjykZ7NXZ8DLdtn/LpbeOLIjgsf5vtn3ZshzL0x6U+H1G3NzwxaX+6u7HkarCAo
  bOPDcSxs99+34ldtHixz//chxlm+kOfBskXezb4XXHe/5rog1Mc22eO77MXC8BYOib9p99a/i
  8q6GXhMiaU4I9FQi7moOBEAbXydKoYDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-2.tower-591.messagelabs.com!1663234049!81541!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 17759 invoked from network); 15 Sep 2022 09:27:30 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-2.tower-591.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 15 Sep 2022 09:27:30 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id BABF41000C2;
	Thu, 15 Sep 2022 10:27:29 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id AC341100078;
	Thu, 15 Sep 2022 10:27:29 +0100 (BST)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 15 Sep 2022 10:27:26 +0100
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>
Subject: [RFC PATCH] xfs: drop experimental warning for fsdax
Date: Thu, 15 Sep 2022 09:26:42 +0000
Message-ID: <1663234002-17-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

Since reflink&fsdax can work together now, the last obstacle has been
resolved.  It's time to remove restrictions and drop this warning.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/xfs/xfs_ioctl.c | 4 ----
 fs/xfs/xfs_iops.c  | 4 ----
 fs/xfs/xfs_super.c | 1 -
 3 files changed, 9 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..13f1b2add390 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1138,10 +1138,6 @@ xfs_ioctl_setattr_xflags(
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
 		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 
-	/* Don't allow us to set DAX mode for a reflinked file for now. */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
-		return -EINVAL;
-
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
 	if (i_flags2 && !xfs_has_v3inodes(mp))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 45518b8c613c..c2e9d7c74170 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1171,10 +1171,6 @@ xfs_inode_supports_dax(
 	if (!S_ISREG(VFS_I(ip)->i_mode))
 		return false;
 
-	/* Only supported on non-reflinked files. */
-	if (xfs_is_reflink_inode(ip))
-		return false;
-
 	/* Block size must match page size */
 	if (mp->m_sb.sb_blocksize != PAGE_SIZE)
 		return false;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9ac59814bbb6..fe7e24c353b9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -358,7 +358,6 @@ xfs_setup_dax_always(
 		return -EINVAL;
 	}
 
-	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 	return 0;
 
 disable_dax:
-- 
2.37.3


