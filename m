Return-Path: <nvdimm+bounces-1424-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C94A41A1D2
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 00:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2D5C21C0D2B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Sep 2021 22:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4DB26D1B;
	Mon, 27 Sep 2021 22:00:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746932FB6
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hsYRy5mW2eSZFEqOw8JTWcpX/S1jq2Dljgzx3k3VBB0=; b=VUhrw8hzQFU5q/FEnWuCu9vNeC
	DCvMINggtEXTZJxRA2FK/rIecWzokE3v00zXQby0C8xhCkSHSknRiHDJShGvvg5/WB7yFgDIDckZK
	PpnRl/rPKh332VtV3wML8z1zrXFA3i55GxnQCfAaEYw70wUGbzTEjF/468zPMAbP4jhENcEZMIqJm
	2Mu0n0pLv7IctMpH2UsQFSSaGesroZ0HRe1tGdCY1b4Bk06qhpX4Xv9n9tTQWerqKdilNkIIQwwUJ
	1JFfO38L6zcxmIzVXP2nckVh/bimkBRtBsjOqfHtqRjhaQH2lAQbVW3sNXoQ6wYWq6VFluDHCOtLw
	Cug+py4Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mUyfw-004SvG-Ll; Mon, 27 Sep 2021 22:00:40 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	colyli@suse.de,
	kent.overstreet@gmail.com,
	kbusch@kernel.org,
	sagi@grimberg.me,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	konrad.wilk@oracle.com,
	roger.pau@citrix.com,
	boris.ostrovsky@oracle.com,
	jgross@suse.com,
	sstabellini@kernel.org,
	minchan@kernel.org,
	ngupta@vflare.org,
	senozhatsky@chromium.org
Cc: xen-devel@lists.xenproject.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 07/10] nvdimm/blk: avoid calling del_gendisk() on early failures
Date: Mon, 27 Sep 2021 15:00:36 -0700
Message-Id: <20210927220039.1064193-8-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

If nd_integrity_init() fails we'd get del_gendisk() called,
but that's not correct as we should only call that if we're
done with device_add_disk(). Fix this by providing unwinding
prior to the devm call being registered and moving the devm
registration to the very end.

This should fix calling del_gendisk() if nd_integrity_init()
fails. I only spotted this issue through code inspection. It
does not fix any real world bug.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/blk.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 088d3dd6f6fa..591fa1f86f1e 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -240,6 +240,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	resource_size_t available_disk_size;
 	struct gendisk *disk;
 	u64 internal_nlba;
+	int rc;
 
 	internal_nlba = div_u64(nsblk->size, nsblk_internal_lbasize(nsblk));
 	available_disk_size = internal_nlba * nsblk_sector_size(nsblk);
@@ -256,20 +257,26 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	blk_queue_logical_block_size(disk->queue, nsblk_sector_size(nsblk));
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 
-	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
-		return -ENOMEM;
-
 	if (nsblk_meta_size(nsblk)) {
-		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
+		rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
 
 		if (rc)
-			return rc;
+			goto out_before_devm_err;
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
 	device_add_disk(dev, disk, NULL);
+
+	/* nd_blk_release_disk() is called if this fails */
+	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
+		return -ENOMEM;
+
 	nvdimm_check_and_set_ro(disk);
 	return 0;
+
+out_before_devm_err:
+	blk_cleanup_disk(disk);
+	return rc;
 }
 
 static int nd_blk_probe(struct device *dev)
-- 
2.30.2


