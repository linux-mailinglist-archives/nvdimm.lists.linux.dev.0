Return-Path: <nvdimm+bounces-2100-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B78C646123C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Nov 2021 11:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id CDF9A1C076D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Nov 2021 10:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F412CAC;
	Mon, 29 Nov 2021 10:22:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F25B2C97
	for <nvdimm@lists.linux.dev>; Mon, 29 Nov 2021 10:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=uudfL2VOAfnu+ewydEXNpXNrXSozdwtbo/7yz/6Xsyc=; b=GajxwQfnuRf8VNuHWwzpK3w2Kr
	TqdSnuptioNAUf6g2eYsDUaOY3wUSVh6WJEaaeuiIaRQdtIMtFzwXgznsr/myS1f4+p6gNtCq1PA3
	j+ngJRZXUiLF7NuiXS4EcXSUdQS1M1N4XPMQf0Jv+uaU6xYi6mSorvMUo0XDc9GwXwLixh8kk2VuU
	XNwgx/QQqXU+oU8o7DBBsRLxvPasm/bh55cCZ9HZB4Hdl27txeSkLuQ+zYL/BHZi9Sm8eaZP7AN5J
	GMFt5WgLHfNNj9gg/9v2kOoce//299JKLbvqaL5Td+Gyfcooc55mX3WgnyZO8W1NMQIf4DGTE2IJJ
	vorV2FIQ==;
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnd-0073N9-Jt; Mon, 29 Nov 2021 10:22:18 +0000
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
Subject: [PATCH 10/29] dm-log-writes: add a log_writes_dax_pgoff helper
Date: Mon, 29 Nov 2021 11:21:44 +0100
Message-Id: <20211129102203.2243509-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to perform the entire remapping for DAX accesses.  This
helper open codes bdev_dax_pgoff given that the alignment checks have
already been done by the submitting file system and don't need to be
repeated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm-log-writes.c | 42 +++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 3155875d4e5b0..cdb22e7a1d0da 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -947,17 +947,21 @@ static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
 	return 0;
 }
 
+static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
+		pgoff_t *pgoff)
+{
+	struct log_writes_c *lc = ti->private;
+
+	*pgoff += (get_start_sect(lc->dev->bdev) >> PAGE_SECTORS_SHIFT);
+	return lc->dev->dax_dev;
+}
+
 static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 					 long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
-	int ret;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	ret = bdev_dax_pgoff(lc->dev->bdev, sector, nr_pages * PAGE_SIZE, &pgoff);
-	if (ret)
-		return ret;
-	return dax_direct_access(lc->dev->dax_dev, pgoff, nr_pages, kaddr, pfn);
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
 static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
@@ -966,11 +970,9 @@ static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
 {
 	struct log_writes_c *lc = ti->private;
 	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 	int err;
 
-	if (bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
-
 	/* Don't bother doing anything if logging has been disabled */
 	if (!lc->logging_enabled)
 		goto dax_copy;
@@ -981,34 +983,24 @@ static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
 		return 0;
 	}
 dax_copy:
-	return dax_copy_from_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static size_t log_writes_dax_copy_to_iter(struct dm_target *ti,
 					  pgoff_t pgoff, void *addr, size_t bytes,
 					  struct iov_iter *i)
 {
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	if (bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
-	return dax_copy_to_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
+	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 					  size_t nr_pages)
 {
-	int ret;
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	ret = bdev_dax_pgoff(lc->dev->bdev, sector, nr_pages << PAGE_SHIFT,
-			     &pgoff);
-	if (ret)
-		return ret;
-	return dax_zero_page_range(lc->dev->dax_dev, pgoff,
-				   nr_pages << PAGE_SHIFT);
+	return dax_zero_page_range(dax_dev, pgoff, nr_pages << PAGE_SHIFT);
 }
 
 #else
-- 
2.30.2


