Return-Path: <nvdimm+bounces-1887-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 281D444A937
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 22D981C0FED
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244A33FE8;
	Tue,  9 Nov 2021 08:33:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081D13FDB
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=SW8Zo8xNPpf5PRQj/yoxD2eK+vSZCdgKjxBBcNAut5E=; b=IAd2z0n4+rSaZjOAQAcHkUiG7e
	AHKwIW3QT0BU34bqCQuvoimP884y7lMTrSi4ev67fFNWoK1dDvk5amFAb1n/57yJ+Cb+3n1zj4Gbe
	YQPgAi5L5rz7YsX4eE0j3hCuAMWPdWSq6kU6krKBw+bSRtv/zYPnHKCRNminIPWP6laGvD1ySu1/T
	onyeNMCfFyCWBxzeP2yuXUxNRqQg/kDKSkylEst+HmEWCXAPXsfje13JJ/FKQNbF/0EmnJ+G2P9v1
	SSDU4goh3tuk4pjnxSDpwGrNlqzT2hYG7o05V7aC4jrXohtehEvjw1MAGEkXVzVVTQXeoF3k/MQXg
	T5uHRctQ==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZb-000s5r-P1; Tue, 09 Nov 2021 08:33:44 +0000
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
Subject: [PATCH 17/29] fsdax: factor out a dax_memzero helper
Date: Tue,  9 Nov 2021 09:32:57 +0100
Message-Id: <20211109083309.584081-18-hch@lst.de>
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

Factor out a helper for the "manual" zeroing of a DAX range to clean
up dax_iomap_zero a lot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d7a923d152240..dc9ebeff850ab 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1121,34 +1121,36 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 }
 #endif /* CONFIG_FS_DAX_PMD */
 
+static int dax_memzero(struct dax_device *dax_dev, pgoff_t pgoff,
+		unsigned int offset, size_t size)
+{
+	void *kaddr;
+	long rc;
+
+	rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
+	if (rc >= 0) {
+		memset(kaddr + offset, 0, size);
+		dax_flush(dax_dev, kaddr + offset, size);
+	}
+	return rc;
+}
+
 s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
 	long rc, id;
-	void *kaddr;
-	bool page_aligned = false;
 	unsigned offset = offset_in_page(pos);
 	unsigned size = min_t(u64, PAGE_SIZE - offset, length);
 
-	if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
-		page_aligned = true;
-
 	id = dax_read_lock();
-
-	if (page_aligned)
+	if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
 		rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
 	else
-		rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
-	if (rc < 0) {
-		dax_read_unlock(id);
-		return rc;
-	}
-
-	if (!page_aligned) {
-		memset(kaddr + offset, 0, size);
-		dax_flush(iomap->dax_dev, kaddr + offset, size);
-	}
+		rc = dax_memzero(iomap->dax_dev, pgoff, offset, size);
 	dax_read_unlock(id);
+
+	if (rc < 0)
+		return rc;
 	return size;
 }
 
-- 
2.30.2


