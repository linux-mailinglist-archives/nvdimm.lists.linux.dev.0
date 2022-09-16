Return-Path: <nvdimm+bounces-4742-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 334975BA53B
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 05:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B86AD280CBA
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 03:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737532100;
	Fri, 16 Sep 2022 03:35:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D523420EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299339; x=1694835339;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MOEX+9Os5MyF4ZlF0WkG4j7W52nt+aIbvJOvJCH+Qx0=;
  b=BORjjSFG6XoBZ18eUXdhDCE31/Ef8kKjPh6pUp5Q2/+K8RZzdwO1ERjl
   O/P3fI3LOgvXhfebVrd8QaRoeznvU2kJBKiqPGF0s3CGRqr5aMU/XenTW
   BSIJ2NtVxzp/U3DzpnzHxX7hVBSkBruF13bnvUCV9FfFXbmrVJhivcrOC
   sHwtzEy5/YiXRwgzu3GE841xClv3szMranp+FRjus3B7FsBQGef4BcRzu
   EyduCgI/pJBaY8BzBE1gnXVjAnYl5ZJfx3RF1H46UMBiHXVQ1GVbkOCi7
   ej/Y4IrNt+hvSH+E6GvidWygseRDKcAu/3K007VC41SWRFTOD6LZrEt3o
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="362866864"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="362866864"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="792961859"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:39 -0700
Subject: [PATCH v2 05/18] xfs: Add xfs_break_layouts() to the inode eviction
 path
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:38 -0700
Message-ID: <166329933874.2786261.18236541386474985669.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for moving DAX pages to be 0-based rather than 1-based
for the idle refcount, the fsdax core wants to have all mappings in a
"zapped" state before truncate. For typical pages this happens naturally
via unmap_mapping_range(), for DAX pages some help is needed to record
this state in the 'struct address_space' of the inode(s) where the page
is mapped.

That "zapped" state is recorded in DAX entries as a side effect of
xfs_break_layouts(). Arrange for it to be called before all truncation
events which already happens for truncate() and PUNCH_HOLE, but not
truncate_inode_pages_final(). Arrange for xfs_break_layouts() before
truncate_inode_pages_final().

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c  |   13 +++++++++----
 fs/xfs/xfs_inode.c |    3 ++-
 fs/xfs/xfs_inode.h |    6 ++++--
 fs/xfs/xfs_super.c |   22 ++++++++++++++++++++++
 4 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 556e28d06788..d3ff692d5546 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -816,7 +816,8 @@ xfs_wait_dax_page(
 int
 xfs_break_dax_layouts(
 	struct inode		*inode,
-	bool			*retry)
+	bool			*retry,
+	int			state)
 {
 	struct page		*page;
 
@@ -827,8 +828,8 @@ xfs_break_dax_layouts(
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(page, dax_page_idle(page), TASK_INTERRUPTIBLE,
-				 0, 0, xfs_wait_dax_page(inode));
+	return ___wait_var_event(page, dax_page_idle(page), state, 0, 0,
+				 xfs_wait_dax_page(inode));
 }
 
 int
@@ -839,14 +840,18 @@ xfs_break_layouts(
 {
 	bool			retry;
 	int			error;
+	int			state = TASK_INTERRUPTIBLE;
 
 	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
 
 	do {
 		retry = false;
 		switch (reason) {
+		case BREAK_UNMAP_FINAL:
+			state = TASK_UNINTERRUPTIBLE;
+			fallthrough;
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry);
+			error = xfs_break_dax_layouts(inode, &retry, state);
 			if (error || retry)
 				break;
 			fallthrough;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 28493c8e9bb2..72ce1cb72736 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3452,6 +3452,7 @@ xfs_mmaplock_two_inodes_and_break_dax_layout(
 	struct xfs_inode	*ip1,
 	struct xfs_inode	*ip2)
 {
+	int			state = TASK_INTERRUPTIBLE;
 	int			error;
 	bool			retry;
 	struct page		*page;
@@ -3463,7 +3464,7 @@ xfs_mmaplock_two_inodes_and_break_dax_layout(
 	retry = false;
 	/* Lock the first inode */
 	xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
-	error = xfs_break_dax_layouts(VFS_I(ip1), &retry);
+	error = xfs_break_dax_layouts(VFS_I(ip1), &retry, state);
 	if (error || retry) {
 		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
 		if (error == 0 && retry)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..e4994eb6e521 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -454,11 +454,13 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  * layout-holder has a consistent view of the file's extent map. While
  * BREAK_WRITE breaks can be satisfied by recalling FL_LAYOUT leases,
  * BREAK_UNMAP breaks additionally require waiting for busy dax-pages to
- * go idle.
+ * go idle. BREAK_UNMAP_FINAL is an uninterruptible version of
+ * BREAK_UNMAP.
  */
 enum layout_break_reason {
         BREAK_WRITE,
         BREAK_UNMAP,
+        BREAK_UNMAP_FINAL,
 };
 
 /*
@@ -531,7 +533,7 @@ xfs_itruncate_extents(
 }
 
 /* from xfs_file.c */
-int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
+int	xfs_break_dax_layouts(struct inode *inode, bool *retry, int state);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9ac59814bbb6..ebb4a6eba3fc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -725,6 +725,27 @@ xfs_fs_drop_inode(
 	return generic_drop_inode(inode);
 }
 
+STATIC void
+xfs_fs_evict_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	long			error;
+
+	xfs_ilock(ip, iolock);
+
+	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP_FINAL);
+
+	/* The final layout break is uninterruptible */
+	ASSERT_ALWAYS(!error);
+
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+
+	xfs_iunlock(ip, iolock);
+}
+
 static void
 xfs_mount_free(
 	struct xfs_mount	*mp)
@@ -1144,6 +1165,7 @@ static const struct super_operations xfs_super_operations = {
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.dirty_inode		= xfs_fs_dirty_inode,
 	.drop_inode		= xfs_fs_drop_inode,
+	.evict_inode		= xfs_fs_evict_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,


