Return-Path: <nvdimm+bounces-4624-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A6B5AAC96
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Sep 2022 12:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D68781C2095D
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Sep 2022 10:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4428F1870;
	Fri,  2 Sep 2022 10:36:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail3.bemta32.messagelabs.com (mail3.bemta32.messagelabs.com [195.245.230.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4893C186C
	for <nvdimm@lists.linux.dev>; Fri,  2 Sep 2022 10:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1662114998; i=@fujitsu.com;
	bh=FNSKVPiakbEzPRjuYrjQOYTkDqJpVisojC0UYVUlJhQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type;
	b=MrrhVO8PnBM/dpTrtHKX1dNzihkVeMlZTmc7ceJ3Eqtem7XpGWcu3DXdUM7b4+qBg
	 kg8IQFuM8Px6xEg+hGrEDUgmM3fAGH47pb1h17fR2S+7N3d3vR9pysq7m+Fn7DMMDb
	 NrlILK5j3gnaYVMVpRNLnrh5jJSSX6FnMcGaznSrq5dUhsw0fHqs2BEkOmVfOdx8Ge
	 1mdb22O0/obQn9sxdQC8Cgg92Onp2f0Jk9uS5GP/VzqxPoYMek9OMloexq7RGZM2PP
	 VltNWCDyVLMFSR3zEe4+WuERrrWRPaxlyhi0TwzlC9AMiD3OzRArq3OIAi/jLwQmt/
	 1ZGEhjFN73DMA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRWlGSWpSXmKPExsViZ8ORqLv1jmC
  ywZc11hbTp15gtNhy7B6jxeUnfBanJyxistj9+iabxZ69J1ksLu+aw2Zxb81/Votdf3awW6z8
  8YfVgcvj1CIJj80rtDwW73nJ5LFpVSebx6ZPk9g9Xmyeyejx8ektFo/Pm+QCOKJYM/OS8isSW
  DNuvrvJXnBfoaLz3QWWBsYd0l2MXBxCAlsYJTadusMM4SxnktjQ9J8FwtnDKHG3ZxFrFyMnB5
  uAjsSFBX9ZQRIiApMYJY7duMkMkmAWKJfYv/EGG4gtLOAmcXrzGrAGFgEVicP/n7KD2LwCLhL
  XHy4Fq5cQUJCY8vA9mM0p4Cqxvec2UxcjB9C2ConV2zkgygUlTs58wgIxXkLi4IsXzCAlEgJK
  EjO74yGmVEg0Tj/EBGGrSVw9t4l5AqPgLCTds5B0L2BkWsVomVSUmZ5RkpuYmaNraGCga2hoq
  muia2msl1ilm6iXWqpbnlpcomuol1herJdaXKxXXJmbnJOil5dasokRGFspxSyxOxi39v3UO8
  QoycGkJMqbeEswWYgvKT+lMiOxOCO+qDQntfgQowwHh5IELz9ITrAoNT21Ii0zBxjnMGkJDh4
  lEd4wkDRvcUFibnFmOkTqFKMxx9qGA3uZOabO/refWYglLz8vVUqc9wVIqQBIaUZpHtwgWPq5
  xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmY9xnIFJ7MvBK4fa+ATmECOmX6TH6QU0oSEVJSD
  UwlBzOdPJkKEidY2Qit/Ks3f5pCiVrYapVlfstbo1ZderPULj3olu6lFROjYpwv535TEP/Grn
  Or/GBvW3hYsLLMmlWs735eMagsmzX53xzFRzfz9FfdKZkcuNV+adWxgu1OgszPFhW83fF/zn0
  Lnby2JeWd9XF8H57Ly1zYOVOQISVBS3iu3uO5/lua/25av35Zj/DTlmMLmV49uPLrufKKSVdX
  rn69YbPYzTORlVv8/mw4qfvKiHuy0DItGZEqq8LUr3fT1iWf0eL5rxvVk3H+lseszoCdk08VP
  Ih+0rpA3YD5rq+Cr9jagwpGZnHMzB3SQufOTefv2Bmc13X/VuuCV5cnrpwb+ld3kel0D4+XSi
  zFGYmGWsxFxYkAkjNFqroDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-15.tower-585.messagelabs.com!1662114997!653077!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21403 invoked from network); 2 Sep 2022 10:36:37 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-15.tower-585.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 2 Sep 2022 10:36:37 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 7ECEA10019C;
	Fri,  2 Sep 2022 11:36:37 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 7BE3A10019B;
	Fri,  2 Sep 2022 11:36:37 +0100 (BST)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Fri, 2 Sep 2022 11:36:33 +0100
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH 3/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Date: Fri, 2 Sep 2022 10:36:01 +0000
Message-ID: <1662114961-66-4-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
 <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
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

This patch is inspired by Dan's "mm, dax, pmem: Introduce
dev_pagemap_failure()"[1].  With the help of dax_holder and
->notify_failure() mechanism, the pmem driver is able to ask filesystem
(or mapped device) on it to unmap all files in use and notify processes
who are using those files.

Call trace:
trigger unbind
 -> unbind_store()
  -> ... (skip)
   -> devres_release_all()   # was pmem driver ->remove() in v1
    -> kill_dax()
     -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
      -> xfs_dax_notify_failure()

Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
event.  So do not shutdown filesystem directly if something not
supported, or if failure range includes metadata area.  Make sure all
files and processes are handled correctly.

[1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 drivers/dax/super.c         |  3 ++-
 fs/xfs/xfs_notify_failure.c | 23 +++++++++++++++++++++++
 include/linux/mm.h          |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9b5e2a5eb0ae..cf9a64563fbe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -323,7 +323,8 @@ void kill_dax(struct dax_device *dax_dev)
 		return;
 
 	if (dax_dev->holder_data != NULL)
-		dax_holder_notify_failure(dax_dev, 0, U64_MAX, 0);
+		dax_holder_notify_failure(dax_dev, 0, U64_MAX,
+				MF_MEM_PRE_REMOVE);
 
 	clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
 	synchronize_srcu(&dax_srcu);
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 3830f908e215..5e04ba7fa403 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -22,6 +22,7 @@
 
 #include <linux/mm.h>
 #include <linux/dax.h>
+#include <linux/fs.h>
 
 struct xfs_failure_info {
 	xfs_agblock_t		startblock;
@@ -77,6 +78,9 @@ xfs_dax_failure_fn(
 
 	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
 	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
+		/* The device is about to be removed.  Not a really failure. */
+		if (notify->mf_flags & MF_MEM_PRE_REMOVE)
+			return 0;
 		notify->want_shutdown = true;
 		return 0;
 	}
@@ -182,12 +186,23 @@ xfs_dax_notify_failure(
 	struct xfs_mount	*mp = dax_holder(dax_dev);
 	u64			ddev_start;
 	u64			ddev_end;
+	int			error;
 
 	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
 		return -EIO;
 	}
 
+	if (mf_flags & MF_MEM_PRE_REMOVE) {
+		xfs_info(mp, "device is about to be removed!");
+		down_write(&mp->m_super->s_umount);
+		error = sync_filesystem(mp->m_super);
+		drop_pagecache_sb(mp->m_super, NULL);
+		up_write(&mp->m_super->s_umount);
+		if (error)
+			return error;
+	}
+
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
 		xfs_debug(mp,
 			 "notify_failure() not supported on realtime device!");
@@ -196,6 +211,8 @@ xfs_dax_notify_failure(
 
 	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
 	    mp->m_logdev_targp != mp->m_ddev_targp) {
+		if (mf_flags & MF_MEM_PRE_REMOVE)
+			return 0;
 		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
 		return -EFSCORRUPTED;
@@ -209,6 +226,12 @@ xfs_dax_notify_failure(
 	ddev_start = mp->m_ddev_targp->bt_dax_part_off;
 	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
 
+	/* Notify failure on the whole device */
+	if (offset == 0 && len == U64_MAX) {
+		offset = ddev_start;
+		len = bdev_nr_bytes(mp->m_ddev_targp->bt_bdev);
+	}
+
 	/* Ignore the range out of filesystem area */
 	if (offset + len - 1 < ddev_start)
 		return -ENXIO;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21f8b27bd9fd..9122a1c57dd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3183,6 +3183,7 @@ enum mf_flags {
 	MF_UNPOISON = 1 << 4,
 	MF_SW_SIMULATED = 1 << 5,
 	MF_NO_RETRY = 1 << 6,
+	MF_MEM_PRE_REMOVE = 1 << 7,
 };
 int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 		      unsigned long count, int mf_flags);
-- 
2.37.2


