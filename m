Return-Path: <nvdimm+bounces-943-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C443F4AE3
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 14:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 9A2183E105E
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 12:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C446D3FCA;
	Mon, 23 Aug 2021 12:41:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CA53FC4
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=aif7xVWwA7gdY3jS95s+0yEVpDSfPmj7Ccpz93ocEx8=; b=NelTCLplan9UVds/av0ZiyRjeC
	DqLbcz43ZW7mn1HqEUDVN+D085CVwfReY+cRjobaKkNQBHuU/zYvqNtCDVGCkMTO81QxC1U3ub9k6
	0r/eiOpJ9QHwwMk+CWShEYsmyGOUWzVaRn0WZWwaJkiETRGvvYrh8mAT82wdvRoSB462oTbr1+WW5
	INw/x2C03XBJ8jbwWcprV+iEoAcEVHhD0FwSHKwvRrhcOJOcFLSK4MNTQx+gsUwxxKlpN0BXc+/AT
	K1kTnDObgbyrzQu03xckjkLl20sOQ+0g1B3YiFm1JLkF695HQyOpAg6ehFPPjbSLMeUURyf8Kzk69
	x3XTFe+w==;
Received: from [2001:4bb8:193:fd10:c6e8:3c08:6f8b:cbf0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mI9EI-009jEW-L0; Mon, 23 Aug 2021 12:39:15 +0000
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
Subject: [PATCH 5/9] dax: move the dax_read_lock() locking into dax_supported
Date: Mon, 23 Aug 2021 14:35:12 +0200
Message-Id: <20210823123516.969486-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823123516.969486-1-hch@lst.de>
References: <20210823123516.969486-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Move the dax_read_lock/dax_read_unlock pair from the callers into
dax_supported to make it a little easier to use.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c   | 16 +++++++++-------
 drivers/md/dm-table.c |  9 ++-------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e13fde57c33e..0f74f83101ab 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -219,7 +219,6 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 	struct request_queue *q;
 	char buf[BDEVNAME_SIZE];
 	bool ret;
-	int id;
 
 	q = bdev_get_queue(bdev);
 	if (!q || !blk_queue_dax(q)) {
@@ -235,10 +234,8 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		return false;
 	}
 
-	id = dax_read_lock();
 	ret = dax_supported(dax_dev, bdev, blocksize, 0,
 			i_size_read(bdev->bd_inode) / 512);
-	dax_read_unlock(id);
 
 	put_dax(dax_dev);
 
@@ -356,13 +353,18 @@ EXPORT_SYMBOL_GPL(dax_direct_access);
 bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
 		int blocksize, sector_t start, sector_t len)
 {
-	if (!dax_dev)
-		return false;
+	bool ret = false;
+	int id;
 
-	if (!dax_alive(dax_dev))
+	if (!dax_dev)
 		return false;
 
-	return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, start, len);
+	id = dax_read_lock();
+	if (dax_alive(dax_dev))
+		ret = dax_dev->ops->dax_supported(dax_dev, bdev, blocksize,
+						  start, len);
+	dax_read_unlock(id);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_supported);
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0543cdf89e92..b53acca37581 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -809,14 +809,9 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
 int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
-	int blocksize = *(int *) data, id;
-	bool rc;
+	int blocksize = *(int *) data;
 
-	id = dax_read_lock();
-	rc = !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
-	dax_read_unlock(id);
-
-	return rc;
+	return !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
 }
 
 /* Check devices support synchronous DAX */
-- 
2.30.2


