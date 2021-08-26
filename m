Return-Path: <nvdimm+bounces-1034-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 232AC3F89C2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 16:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id BEC973E103A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 14:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D333FCC;
	Thu, 26 Aug 2021 14:06:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EBA3FC8
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=GQ/gJN8CFicuEaThGpULH2pYA5bMJDXYq/1YZIZJlJU=; b=efPqwyYfbcgScqpEVQt48wS6DM
	aedVSd2UoOhBVM+fs/kljIMt/bkMdcBWo2igLXpjdqpCkotLI2n1mnPpC+Wfg+ODvPEcpi86KGGQq
	xV2ZUVPjPlx9+tJ/ki1aC+CTElkPWOjs2iyVYY1wd1h3nf1STm9kydHEv62TnMcq5ce/jV2eXrTd8
	qZxVnjoPiaYb517S/TmcfE0OaLSXGW7ZOoi8/YSyEa8elRtzULX0VaeUYd5IsGmacwZzRu3YJvdPi
	4qQ5U1PjMHvOEtV49Xcy1EZUJ4VX47yjOJpiU4J5r2Mg+XTiTwe9gac27d6R370LCq63F6o0CmsRk
	PehupZAw==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJFyp-00DMYu-No; Thu, 26 Aug 2021 14:04:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 8/9] xfs: factor out a xfs_buftarg_is_dax helper
Date: Thu, 26 Aug 2021 15:55:09 +0200
Message-Id: <20210826135510.6293-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826135510.6293-1-hch@lst.de>
References: <20210826135510.6293-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Refactor the DAX setup code in preparation of removing
bdev_dax_supported.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_super.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2c9e26a44546..5a89bf601d97 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -314,6 +314,14 @@ xfs_set_inode_alloc(
 	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
 }
 
+static bool
+xfs_buftarg_is_dax(
+	struct super_block	*sb,
+	struct xfs_buftarg	*bt)
+{
+	return bdev_dax_supported(bt->bt_bdev, sb->s_blocksize);
+}
+
 STATIC int
 xfs_blkdev_get(
 	xfs_mount_t		*mp,
@@ -1549,11 +1557,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 
-		datadev_is_dax = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
-			sb->s_blocksize);
+		datadev_is_dax = xfs_buftarg_is_dax(sb, mp->m_ddev_targp);
 		if (mp->m_rtdev_targp)
-			rtdev_is_dax = bdev_dax_supported(
-				mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
+			rtdev_is_dax = xfs_buftarg_is_dax(sb,
+						mp->m_rtdev_targp);
 		if (!rtdev_is_dax && !datadev_is_dax) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
-- 
2.30.2


