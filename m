Return-Path: <nvdimm+bounces-1872-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB5944A8B6
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 226F33E10E6
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E4E2CAD;
	Tue,  9 Nov 2021 08:33:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1751E2C9B
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jSKGrxUZLaYd3xMk2S2xH457WrAHkLgVZbJriQpBpNE=; b=D6Qw81O+aGHdSGLIg3S1q7rPKD
	R/sWFABcNQF3AaOMWnHmnIZRzu37fjd2u/pIqQY8s6H/uib2W7f9hKQS2xALeqBy9Z/8wRU+hn1De
	sRX2ZJYcFFNwtq8BoBYJ9YFiXucGevDveM1fubg49CT5eel8Mtzd/y4fMaTvd2rD2T3+SaVC1rcRR
	XnBnxu1DevPWVNoseeq5kimfTYRxWAd2eeCepAKvQcani/qsgLIg3qsH9CAdj6CAXbwBNsVDBSRo7
	yY9ibo9efoKhptJSrdNP1b86IS3i2PjvFiHQMlTkKl4s4rSb2GTwHR7nWpa8ExhI3CSg5fudf2lSm
	XbJXksuw==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZG-000ryb-Kt; Tue, 09 Nov 2021 08:33:23 +0000
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
Subject: [PATCH 05/29] dax: remove the pgmap sanity checks in generic_fsdax_supported
Date: Tue,  9 Nov 2021 09:32:45 +0100
Message-Id: <20211109083309.584081-6-hch@lst.de>
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

Drivers that register a dax_dev should make sure it works, no need
to double check from the file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c | 49 +--------------------------------------------
 1 file changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9383c11b21853..04fc680542e8d 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -107,13 +107,9 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		struct block_device *bdev, int blocksize, sector_t start,
 		sector_t sectors)
 {
-	bool dax_enabled = false;
 	pgoff_t pgoff, pgoff_end;
-	void *kaddr, *end_kaddr;
-	pfn_t pfn, end_pfn;
 	sector_t last_page;
-	long len, len2;
-	int err, id;
+	int err;
 
 	if (blocksize != PAGE_SIZE) {
 		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
@@ -138,49 +134,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		return false;
 	}
 
-	id = dax_read_lock();
-	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
-	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
-
-	if (len < 1 || len2 < 1) {
-		pr_info("%pg: error: dax access failed (%ld)\n",
-				bdev, len < 1 ? len : len2);
-		dax_read_unlock(id);
-		return false;
-	}
-
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
-		/*
-		 * An arch that has enabled the pmem api should also
-		 * have its drivers support pfn_t_devmap()
-		 *
-		 * This is a developer warning and should not trigger in
-		 * production. dax_flush() will crash since it depends
-		 * on being able to do (page_address(pfn_to_page())).
-		 */
-		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
-		dax_enabled = true;
-	} else if (pfn_t_devmap(pfn) && pfn_t_devmap(end_pfn)) {
-		struct dev_pagemap *pgmap, *end_pgmap;
-
-		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
-		end_pgmap = get_dev_pagemap(pfn_t_to_pfn(end_pfn), NULL);
-		if (pgmap && pgmap == end_pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX
-				&& pfn_t_to_page(pfn)->pgmap == pgmap
-				&& pfn_t_to_page(end_pfn)->pgmap == pgmap
-				&& pfn_t_to_pfn(pfn) == PHYS_PFN(__pa(kaddr))
-				&& pfn_t_to_pfn(end_pfn) == PHYS_PFN(__pa(end_kaddr)))
-			dax_enabled = true;
-		put_dev_pagemap(pgmap);
-		put_dev_pagemap(end_pgmap);
-
-	}
-	dax_read_unlock(id);
-
-	if (!dax_enabled) {
-		pr_info("%pg: error: dax support not enabled\n", bdev);
-		return false;
-	}
 	return true;
 }
 EXPORT_SYMBOL_GPL(generic_fsdax_supported);
-- 
2.30.2


