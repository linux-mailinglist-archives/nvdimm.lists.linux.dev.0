Return-Path: <nvdimm+bounces-1876-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id D172A44A8FB
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F34011C0F8F
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E6B2CB6;
	Tue,  9 Nov 2021 08:33:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9DC2C8B
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9DfHXjXpwPV16JwxKDzlwLsQrCaf21dbRLJzYHAhNZM=; b=k+J4p1sxv4GIaf/pZry1mADwB+
	Ar1HiQrfR69z+VUk+LXPZwyTUodROP6Ve2JzAJaLMLYKGRK2OL7DDKMIHeGPn3jFxKNlLvXYsyelf
	TOkCDzO0pNwMWvfo4xkbl6QMwmB+MsxPivzTRf3Y41pDkQ+OnrH5ig+xpkzEFpmu8x16htqod2pJy
	/G/Yvb1ksftU66dUi9xDWAuBfQYqIfgnrrTnDC1t60iM2U8YX9P9wjw1hVd9b8Nwa/CIq2Yf1kEUT
	WAiAtLf9ZLb3DGoYBWz/exnngImMfLdkhciTOz/OKeKkkIWbM0lVNy3hRWeXtiPMoMqgcdTTivSmi
	q/cr92yQ==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZK-000s09-9X; Tue, 09 Nov 2021 08:33:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: [PATCH 07/29] xfs: factor out a xfs_setup_dax_always helper
Date: Tue,  9 Nov 2021 09:32:47 +0100
Message-Id: <20211109083309.584081-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Factor out another DAX setup helper to simplify future changes.  Also
move the experimental warning after the checks to not clutter the log
too much if the setup failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 47 +++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e21459f9923a8..875fd3151d6c9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -340,6 +340,32 @@ xfs_buftarg_is_dax(
 			bdev_nr_sectors(bt->bt_bdev));
 }
 
+static int
+xfs_setup_dax_always(
+	struct xfs_mount	*mp)
+{
+	struct super_block	*sb = mp->m_super;
+
+	if (!xfs_buftarg_is_dax(sb, mp->m_ddev_targp) &&
+	   (!mp->m_rtdev_targp || !xfs_buftarg_is_dax(sb, mp->m_rtdev_targp))) {
+		xfs_alert(mp,
+			"DAX unsupported by block device. Turning off DAX.");
+		goto disable_dax;
+	}
+
+	if (xfs_has_reflink(mp)) {
+		xfs_alert(mp, "DAX and reflink cannot be used together!");
+		return -EINVAL;
+	}
+
+	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+	return 0;
+
+disable_dax:
+	xfs_mount_set_dax_mode(mp, XFS_DAX_NEVER);
+	return 0;
+}
+
 STATIC int
 xfs_blkdev_get(
 	xfs_mount_t		*mp,
@@ -1593,26 +1619,9 @@ xfs_fs_fill_super(
 		sb->s_flags |= SB_I_VERSION;
 
 	if (xfs_has_dax_always(mp)) {
-		bool rtdev_is_dax = false, datadev_is_dax;
-
-		xfs_warn(mp,
-		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
-
-		datadev_is_dax = xfs_buftarg_is_dax(sb, mp->m_ddev_targp);
-		if (mp->m_rtdev_targp)
-			rtdev_is_dax = xfs_buftarg_is_dax(sb,
-						mp->m_rtdev_targp);
-		if (!rtdev_is_dax && !datadev_is_dax) {
-			xfs_alert(mp,
-			"DAX unsupported by block device. Turning off DAX.");
-			xfs_mount_set_dax_mode(mp, XFS_DAX_NEVER);
-		}
-		if (xfs_has_reflink(mp)) {
-			xfs_alert(mp,
-		"DAX and reflink cannot be used together!");
-			error = -EINVAL;
+		error = xfs_setup_dax_always(mp);
+		if (error)
 			goto out_filestream_unmount;
-		}
 	}
 
 	if (xfs_has_discard(mp)) {
-- 
2.30.2


