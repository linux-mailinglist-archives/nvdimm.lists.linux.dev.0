Return-Path: <nvdimm+bounces-2957-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A52C4B070B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 08:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 651EB1C0EDD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 07:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82812F4F;
	Thu, 10 Feb 2022 07:28:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB72F4C
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C///xZ3+TITjSxyh3y8Q4LCkclrtiG/6WkLtdkMN5H8=; b=1K0aXTJH978QGa743NcTZ3JvOe
	f7AtT5DYKnUGEa/vdvhJQ6PxUUbhJS92qUc9R2c3fb+m1MhBSqRTkCxa3IQe61LMhtV7ZdEuuzbZT
	V3CMqrP0ChR31mj0QeD9a74YCd+uIT8aGMzo2Yz7TzMwyYQ6GJUQV8eqwIDrGFzv8YQwsE/uElvI+
	kS3ytlOl+sGSaEYsKLG6e3w1PU76o0bLPUNVBrsDvr6STcnqm1QjNHl/BBZkuadO8JTStiFH4zs0v
	w2FktCi1xMFaTth2tRisGRaV+W2Hmelk9Z5+btBa7DNy+ohLePdib0C5T5gEHqlk+oS6FemEc0M1l
	eTTsKZ5Q==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3sj-002rmo-7q; Thu, 10 Feb 2022 07:28:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 05/27] mm: simplify freeing of devmap managed pages
Date: Thu, 10 Feb 2022 08:28:06 +0100
Message-Id: <20220210072828.2930359-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210072828.2930359-1-hch@lst.de>
References: <20220210072828.2930359-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make put_devmap_managed_page return if it took charge of the page
or not and remove the separate page_is_devmap_managed helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h | 34 ++++++++++------------------------
 mm/memremap.c      | 20 +++++++++-----------
 mm/swap.c          | 10 +---------
 3 files changed, 20 insertions(+), 44 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 91dd0bc786a9ec..26baadcef4556b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1094,33 +1094,24 @@ static inline bool is_zone_movable_page(const struct page *page)
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-static inline bool page_is_devmap_managed(struct page *page)
+bool __put_devmap_managed_page(struct page *page);
+static inline bool put_devmap_managed_page(struct page *page)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	switch (page->pgmap->type) {
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_FS_DAX:
-		return true;
-	default:
-		break;
-	}
-	return false;
+	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    page->pgmap->type != MEMORY_DEVICE_FS_DAX)
+		return false;
+	return __put_devmap_managed_page(page);
 }
 
-void put_devmap_managed_page(struct page *page);
-
 #else /* CONFIG_DEV_PAGEMAP_OPS */
-static inline bool page_is_devmap_managed(struct page *page)
+static inline bool put_devmap_managed_page(struct page *page)
 {
 	return false;
 }
-
-static inline void put_devmap_managed_page(struct page *page)
-{
-}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
 static inline bool is_device_private_page(const struct page *page)
@@ -1220,16 +1211,11 @@ static inline void put_page(struct page *page)
 	struct folio *folio = page_folio(page);
 
 	/*
-	 * For devmap managed pages we need to catch refcount transition from
-	 * 2 to 1, when refcount reach one it means the page is free and we
-	 * need to inform the device driver through callback. See
-	 * include/linux/memremap.h and HMM for details.
+	 * For some devmap managed pages we need to catch refcount transition
+	 * from 2 to 1:
 	 */
-	if (page_is_devmap_managed(&folio->page)) {
-		put_devmap_managed_page(&folio->page);
+	if (put_devmap_managed_page(&folio->page))
 		return;
-	}
-
 	folio_put(folio);
 }
 
diff --git a/mm/memremap.c b/mm/memremap.c
index 55d23e9f5c04ec..f41233a67edb12 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -502,24 +502,22 @@ void free_devmap_managed_page(struct page *page)
 	page->pgmap->ops->page_free(page);
 }
 
-void put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page(struct page *page)
 {
-	int count;
-
-	if (WARN_ON_ONCE(!page_is_devmap_managed(page)))
-		return;
-
-	count = page_ref_dec_return(page);
-
 	/*
 	 * devmap page refcounts are 1-based, rather than 0-based: if
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (count == 1)
+	switch (page_ref_dec_return(page)) {
+	case 1:
 		free_devmap_managed_page(page);
-	else if (!count)
+		break;
+	case 0:
 		__put_page(page);
+		break;
+	}
+	return true;
 }
-EXPORT_SYMBOL(put_devmap_managed_page);
+EXPORT_SYMBOL(__put_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
diff --git a/mm/swap.c b/mm/swap.c
index 08058f74cae23e..25b55c56614311 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -930,16 +930,8 @@ void release_pages(struct page **pages, int nr)
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			/*
-			 * ZONE_DEVICE pages that return 'false' from
-			 * page_is_devmap_managed() do not require special
-			 * processing, and instead, expect a call to
-			 * put_page_testzero().
-			 */
-			if (page_is_devmap_managed(page)) {
-				put_devmap_managed_page(page);
+			if (put_devmap_managed_page(page))
 				continue;
-			}
 			if (put_page_testzero(page))
 				put_dev_pagemap(page->pgmap);
 			continue;
-- 
2.30.2


