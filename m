Return-Path: <nvdimm+bounces-1033-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id A265B3F89B2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 16:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 755473E10FC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 14:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671B53FCC;
	Thu, 26 Aug 2021 14:05:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A270B3FC8
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Gzbhuz0WmF6a7tBLk+/ib1SYKeApL9wRSTVMsmubqCU=; b=Jtae9bkTuZx2Fhu3Q/FFVYaN7P
	6m9/BW3jdwFcvCM4OoLyTdd7umd7aQ2UULpSE2skQZFVpL5+Hw+8B4ecFV8iDemUJnFvapxZLSv/p
	7EmqgFecYx/oQ8mEdDnJFrEjmV0R9Cm4+w8mUNtL8bGWx9e+I2P7j3dnNcvC8pt3yFAGYWmAwKJ4d
	c6dw8DY5tdJ3a+Sz9XXYYH8rZ1oxfS86UkyspDr8VKeLuinqLflbWgo5cnyIhC5DrtT2e9v3CMXaf
	fXtwGFLGHO0de8fCBSJ4vJaiKQoAfNJ2pcl6bV3nbJSuXIhByoj3Kfkm6/rm1r+Bj7bGCXJlXpVGk
	erJJ1C0g==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJFxj-00DMTH-EX; Thu, 26 Aug 2021 14:02:57 +0000
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
Subject: [PATCH 7/9] dax: stub out dax_supported for !CONFIG_FS_DAX
Date: Thu, 26 Aug 2021 15:55:08 +0200
Message-Id: <20210826135510.6293-8-hch@lst.de>
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

dax_supported calls into ->dax_supported which checks for fsdax support.
Don't bother building it for !CONFIG_FS_DAX as it will always return
false.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c | 36 ++++++++++++++++++------------------
 include/linux/dax.h | 18 ++++++++++--------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 8e8ccb3e956b..eed02729add3 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -201,6 +201,24 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 	return true;
 }
 EXPORT_SYMBOL_GPL(generic_fsdax_supported);
+
+bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
+		int blocksize, sector_t start, sector_t len)
+{
+	bool ret = false;
+	int id;
+
+	if (!dax_dev)
+		return false;
+
+	id = dax_read_lock();
+	if (dax_alive(dax_dev) && dax_dev->ops->dax_supported)
+		ret = dax_dev->ops->dax_supported(dax_dev, bdev, blocksize,
+						  start, len);
+	dax_read_unlock(id);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_supported);
 #endif /* CONFIG_FS_DAX */
 
 /**
@@ -350,24 +368,6 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 }
 EXPORT_SYMBOL_GPL(dax_direct_access);
 
-bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
-		int blocksize, sector_t start, sector_t len)
-{
-	bool ret = false;
-	int id;
-
-	if (!dax_dev)
-		return false;
-
-	id = dax_read_lock();
-	if (dax_alive(dax_dev) && dax_dev->ops->dax_supported)
-		ret = dax_dev->ops->dax_supported(dax_dev, bdev, blocksize,
-						  start, len);
-	dax_read_unlock(id);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(dax_supported);
-
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0a3ef9701e03..32dce5763f2c 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -57,8 +57,6 @@ static inline void set_dax_synchronous(struct dax_device *dax_dev)
 {
 	__set_dax_synchronous(dax_dev);
 }
-bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
-		int blocksize, sector_t start, sector_t len);
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
@@ -101,12 +99,6 @@ static inline bool dax_synchronous(struct dax_device *dax_dev)
 static inline void set_dax_synchronous(struct dax_device *dax_dev)
 {
 }
-static inline bool dax_supported(struct dax_device *dax_dev,
-		struct block_device *bdev, int blocksize, sector_t start,
-		sector_t len)
-{
-	return false;
-}
 static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 				struct dax_device *dax_dev)
 {
@@ -127,6 +119,9 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		struct block_device *bdev, int blocksize, sector_t start,
 		sector_t sectors);
 
+bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
+		int blocksize, sector_t start, sector_t len);
+
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 	put_dax(dax_dev);
@@ -149,6 +144,13 @@ static inline bool bdev_dax_supported(struct block_device *bdev,
 
 #define generic_fsdax_supported		NULL
 
+static inline bool dax_supported(struct dax_device *dax_dev,
+		struct block_device *bdev, int blocksize, sector_t start,
+		sector_t len)
+{
+	return false;
+}
+
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 }
-- 
2.30.2


