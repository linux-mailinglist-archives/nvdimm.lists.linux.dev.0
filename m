Return-Path: <nvdimm+bounces-3885-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B377653C491
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 07:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52372280C08
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 05:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F51BED5;
	Fri,  3 Jun 2022 05:38:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B3AEBB
	for <nvdimm@lists.linux.dev>; Fri,  3 Jun 2022 05:38:03 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AxeOwdK7chXUbYdZzXXSiBwxRtLnGchMFZxGqfqr?=
 =?us-ascii?q?LsXjdYENS1mQCzmpKC2/TPvjYMWbxfdByYYW1/E8DsZ/Wy9dlHlQ5pCpnJ55og?=
 =?us-ascii?q?ZCbXIzGdC8cHM8zwvXrFRsht4NHAjX5BJhcokT0+1H9YtANkVEmjfvSHuCkUba?=
 =?us-ascii?q?dUsxMbVQMpBkJ2EsLd9ER0tYAbeiRW2thiPuqyyHtEAbNNw1cbgr435m+RCZH5?=
 =?us-ascii?q?5wejt+3UmsWPpintHeG/5Uc4Ql2yauZdxMUSaEMdgK2qnqq8V23wo/Z109F5tK?=
 =?us-ascii?q?NmbC9fFAIQ6LJIE6FjX8+t6qK20AE/3JtlP1gcqd0hUR/0l1lm/hr1dxLro32R?=
 =?us-ascii?q?wEyIoXCheYcTwJFVSp5OMWq/ZeeeyTh4ZLDlhCun3zEhq8G4FsNFYER5Od7KW9?=
 =?us-ascii?q?U8vkfMjoMclaIgOfe6La6TOxtj8MjIeHrIYoAt3AmxjbcZd4mSpDrQqPE/9ZU0?=
 =?us-ascii?q?T48wMdUEp72eMsdbStHbRLOeRRDN14bTpUkk4+AinD5NT8et1ORoas+5nP7zQp?=
 =?us-ascii?q?t3byrO93QEvSGR9pSmEmwpW/c+Wn9RBYAO7S3zTuD72Lpg+rnnj3yU4FUE6e3n?=
 =?us-ascii?q?tZjg0WW7mgSDgAGEFW8vP+1g1K/XNQZLFYbkgIos6Qz8UmDStjmQwb+pH+Cow5?=
 =?us-ascii?q?aV9dOe8U64wGlzrHIpQqUbkACRzlQYZoms9U3SiEh1l6hmd7iQzdotdW9S3ub+?=
 =?us-ascii?q?/GfrS6aPjIcJmsPIyQDSGMt+dbkpI0snxTnVct4Hei5g7XdHTD23iDPojMyiqs?=
 =?us-ascii?q?eieYV2Kihu1PKmTShot7OVAFdzgHWWH+1qwB0foioY6S25lXBq/VNNoCUSh+Gp?=
 =?us-ascii?q?ndss8yf6v0eSIGDjwSTT+gXWrKk/fCINHvbm1EHN4cg7TOF6XOlfJ4W5DB4OVc?=
 =?us-ascii?q?vNdwLPyLqCHI/Eys5CIR7ZSPsNPEoJdnqTZlC8EQpLvy9Pti8UzaESsQZmNe7w?=
 =?us-ascii?q?RxT?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ArEtrYq7CpTBYfigboQPXwCzXdLJyesId70hD?=
 =?us-ascii?q?6qhwISY6TiX+rbHJoB17726MtN9/YhEdcLy7VJVoBEmskKKdgrNhWotKPjOW21?=
 =?us-ascii?q?dARbsKheCJrgEIWReOktK1vp0AT0ERMrLN5CBB/KTHCReDYqsd6ejC4Ka1nv3f?=
 =?us-ascii?q?0nsoaQlrbptr5wB/Bh3zKDwMeCB2QYo+CIGH5tdK4x6peXEsZMy9AXUfG8fZod?=
 =?us-ascii?q?mjruOdXTc2Qw4g9BKVjS6lrJrzEx2j1B8YVD9VhZcOmFK16zDE2g=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124686815"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Jun 2022 13:37:57 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id EE6884D17199;
	Fri,  3 Jun 2022 13:37:52 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 3 Jun 2022 13:37:53 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 3 Jun 2022 13:37:52 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <akpm@linux-foundation.org>, <jane.chu@oracle.com>,
	<rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>, <willy@infradead.org>,
	<naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>, Christoph Hellwig
	<hch@lst.de>
Subject: [PATCH v2 14/14] xfs: Add dax dedupe support
Date: Fri, 3 Jun 2022 13:37:38 +0800
Message-ID: <20220603053738.1218681-15-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
References: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: EE6884D17199.A0B2C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Introduce xfs_mmaplock_two_inodes_and_break_dax_layout() for dax files
who are going to be deduped.  After that, call compare range function
only when files are both DAX or not.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c    |  2 +-
 fs/xfs/xfs_inode.c   | 69 +++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.h   |  1 +
 fs/xfs/xfs_reflink.c |  4 +--
 4 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 07ec4ada5163..9f433006edcd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -808,7 +808,7 @@ xfs_wait_dax_page(
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 }
 
-static int
+int
 xfs_break_dax_layouts(
 	struct inode		*inode,
 	bool			*retry)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b2879870a17e..96308065a2b3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3767,6 +3767,50 @@ xfs_iolock_two_inodes_and_break_layout(
 	return 0;
 }
 
+static int
+xfs_mmaplock_two_inodes_and_break_dax_layout(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	int			error;
+	bool			retry;
+	struct page		*page;
+
+	if (ip1->i_ino > ip2->i_ino)
+		swap(ip1, ip2);
+
+again:
+	retry = false;
+	/* Lock the first inode */
+	xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
+	error = xfs_break_dax_layouts(VFS_I(ip1), &retry);
+	if (error || retry) {
+		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+		if (error == 0 && retry)
+			goto again;
+		return error;
+	}
+
+	if (ip1 == ip2)
+		return 0;
+
+	/* Nested lock the second inode */
+	xfs_ilock(ip2, xfs_lock_inumorder(XFS_MMAPLOCK_EXCL, 1));
+	/*
+	 * We cannot use xfs_break_dax_layouts() directly here because it may
+	 * need to unlock & lock the XFS_MMAPLOCK_EXCL which is not suitable
+	 * for this nested lock case.
+	 */
+	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
+	if (page && page_ref_count(page) != 1) {
+		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+		goto again;
+	}
+
+	return 0;
+}
+
 /*
  * Lock two inodes so that userspace cannot initiate I/O via file syscalls or
  * mmap activity.
@@ -3781,8 +3825,19 @@ xfs_ilock2_io_mmap(
 	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
 	if (ret)
 		return ret;
-	filemap_invalidate_lock_two(VFS_I(ip1)->i_mapping,
-				    VFS_I(ip2)->i_mapping);
+
+	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
+		ret = xfs_mmaplock_two_inodes_and_break_dax_layout(ip1, ip2);
+		if (ret) {
+			inode_unlock(VFS_I(ip2));
+			if (ip1 != ip2)
+				inode_unlock(VFS_I(ip1));
+			return ret;
+		}
+	} else
+		filemap_invalidate_lock_two(VFS_I(ip1)->i_mapping,
+					    VFS_I(ip2)->i_mapping);
+
 	return 0;
 }
 
@@ -3792,8 +3847,14 @@ xfs_iunlock2_io_mmap(
 	struct xfs_inode	*ip1,
 	struct xfs_inode	*ip2)
 {
-	filemap_invalidate_unlock_two(VFS_I(ip1)->i_mapping,
-				      VFS_I(ip2)->i_mapping);
+	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
+		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+		if (ip1 != ip2)
+			xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+	} else
+		filemap_invalidate_unlock_two(VFS_I(ip1)->i_mapping,
+					      VFS_I(ip2)->i_mapping);
+
 	inode_unlock(VFS_I(ip2));
 	if (ip1 != ip2)
 		inode_unlock(VFS_I(ip1));
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7be6f8e705ab..8313cc83b6ee 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -467,6 +467,7 @@ xfs_itruncate_extents(
 }
 
 /* from xfs_file.c */
+int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cbaf36d21020..d07f06ff0f13 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1363,8 +1363,8 @@ xfs_reflink_remap_prep(
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
 
-	/* Don't share DAX file data for now. */
-	if (IS_DAX(inode_in) || IS_DAX(inode_out))
+	/* Don't share DAX file data with non-DAX file. */
+	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
 	if (!IS_DAX(inode_in))
-- 
2.36.1




