Return-Path: <nvdimm+bounces-1606-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CBE430F44
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Oct 2021 06:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 7D0EE3E11C2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Oct 2021 04:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0813D2C9B;
	Mon, 18 Oct 2021 04:41:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD482C96
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 04:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PrmU1McI9Lz9rWePxXHiZdW7Le1GN8Zv7TzW7GRRfmk=; b=kqmSP0G28bXwqsOaac9zgy8mG9
	sgDyCDreo12HKn9hSHBatwTc+6RVOsAGfryKp5eKcp2238Kj6ixr1CLtQrI4HBYWDQxiZ7BO6SWWP
	wmp6BNvIwT2XgPJy5+WHiTvfySe3FQqJpUU9gNCh/b/uOOFVoqXyuRnR8M/W8oHybKfwu7XxnBmSy
	vWaIxgRB11YOrhj73JWsnK+0oXJv7JUKAj6adtdHb2aQo8wkNGwd6FkdNnvt5uNJZVKeGBvE8L+mr
	XneWfaX1FVA0rLX0r3NApCsXEhOqxw9ZhpR/6om21C1SjBzZmWz7FZ2gUwVo/u3KWFgEw8r/ReHdc
	jxgVAIRQ==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcKSW-00E3IX-In; Mon, 18 Oct 2021 04:41:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: [PATCH 05/11] dax: move the partition alignment check into fs_dax_get_by_bdev
Date: Mon, 18 Oct 2021 06:40:48 +0200
Message-Id: <20211018044054.1779424-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018044054.1779424-1-hch@lst.de>
References: <20211018044054.1779424-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fs_dax_get_by_bdev is the primary interface to find a dax device for a
block device, so move the partition alignment check there instead of
wiring it up through ->dax_supported.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 04fc680542e8d..482fe775324a4 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -93,6 +93,12 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 	if (!blk_queue_dax(bdev->bd_disk->queue))
 		return NULL;
 
+	if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
+	    (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {
+		pr_info("%pg: error: unaligned partition for dax\n", bdev);
+		return NULL;
+	}
+
 	id = dax_read_lock();
 	dax_dev = xa_load(&dax_hosts, (unsigned long)bdev->bd_disk);
 	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
@@ -107,10 +113,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		struct block_device *bdev, int blocksize, sector_t start,
 		sector_t sectors)
 {
-	pgoff_t pgoff, pgoff_end;
-	sector_t last_page;
-	int err;
-
 	if (blocksize != PAGE_SIZE) {
 		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
 		return false;
@@ -121,19 +123,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		return false;
 	}
 
-	err = bdev_dax_pgoff(bdev, start, PAGE_SIZE, &pgoff);
-	if (err) {
-		pr_info("%pg: error: unaligned partition for dax\n", bdev);
-		return false;
-	}
-
-	last_page = PFN_DOWN((start + sectors - 1) * 512) * PAGE_SIZE / 512;
-	err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
-	if (err) {
-		pr_info("%pg: error: unaligned partition for dax\n", bdev);
-		return false;
-	}
-
 	return true;
 }
 EXPORT_SYMBOL_GPL(generic_fsdax_supported);
-- 
2.30.2


