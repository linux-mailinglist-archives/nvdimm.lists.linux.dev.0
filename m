Return-Path: <nvdimm+bounces-4136-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CD9565280
	for <lists+linux-nvdimm@lfdr.de>; Mon,  4 Jul 2022 12:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85CAB280C2D
	for <lists+linux-nvdimm@lfdr.de>; Mon,  4 Jul 2022 10:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0FD28F6;
	Mon,  4 Jul 2022 10:38:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4044C7E
	for <nvdimm@lists.linux.dev>; Mon,  4 Jul 2022 10:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bgFpDRJ1phHQqdCoJBko0cJC9ngsJhc8l5GKh4nATgo=; b=rSgWnvQEmiowdltF5/el1vzXCe
	EouJ0fQsqVyuBzwEgkUO/ew48ICBo4l6H1cJc+N/MR1v+uMNj3mbLq0RDNvRygBYzO3xqLdtaWTce
	JqeMO6RsgfJ+n0AeIFuo1oWQuW9yyBtXVqlGlZ2orNkHOJZRGlyNAf2D5kg5iMm0959zGWd13jboR
	qpX+oF9PeFyB3pFOqV9dUr3NVFQLBAp9nJ3Of3Kx+0fwekZlbOisV7XugG9/ZzvX9gwnarHiOmMxc
	4/AUFNBs96GW3W+jWK6WEZYSAUhxYZFmNJnvsltMLtdytDmbe0jQe97UrRuPLt4emehZsKnv8V6UD
	19e6+GEw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1o8JT6-00HBd7-Bw; Mon, 04 Jul 2022 10:38:16 +0000
Date: Mon, 4 Jul 2022 11:38:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
	william.kucharski@oracle.com, dan.j.williams@intel.com,
	jack@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] mm: fix missing wake-up event for FSDAX pages
Message-ID: <YsLDGEiVSHN3Xx/g@casper.infradead.org>
References: <20220704074054.32310-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704074054.32310-1-songmuchun@bytedance.com>

On Mon, Jul 04, 2022 at 03:40:54PM +0800, Muchun Song wrote:
> FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> then they will be unpinned via unpin_user_page() using a folio variant
> to put the page, however, folio variants did not consider this special
> case, the result will be to miss a wakeup event (like the user of
> __fuse_dax_break_layouts()).

Argh, no.  The 1-based refcounts are a blight on the entire kernel.
They need to go away, not be pushed into folios as well.  I think
we're close to having that fixed, but until then, this should do
the trick?

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cc98ab012a9b..4cef5e0f78b6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1129,18 +1129,18 @@ static inline bool is_zone_movable_page(const struct page *page)
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-bool __put_devmap_managed_page(struct page *page);
-static inline bool put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page(struct page *page, int refs);
+static inline bool put_devmap_managed_page(struct page *page, int refs)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	return __put_devmap_managed_page(page);
+	return __put_devmap_managed_page(page, refs);
 }
 
 #else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page(struct page *page)
+static inline bool put_devmap_managed_page(struct page *page, int refs)
 {
 	return false;
 }
@@ -1246,7 +1246,7 @@ static inline void put_page(struct page *page)
 	 * For some devmap managed pages we need to catch refcount transition
 	 * from 2 to 1:
 	 */
-	if (put_devmap_managed_page(&folio->page))
+	if (put_devmap_managed_page(&folio->page, 1))
 		return;
 	folio_put(folio);
 }
diff --git a/mm/gup.c b/mm/gup.c
index d1132b39aa8f..28df02121c78 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -88,7 +88,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		folio_put_refs(folio, refs);
+		if (!put_devmap_managed_page(&folio->page, refs))
+			folio_put_refs(folio, refs);
 		goto retry;
 	}
 
@@ -177,6 +178,8 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
+	if (put_devmap_managed_page(&folio->page, refs))
+		return;
 	folio_put_refs(folio, refs);
 }
 
diff --git a/mm/memremap.c b/mm/memremap.c
index b870a659eee6..b25e40e3a11e 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -499,7 +499,7 @@ void free_zone_device_page(struct page *page)
 }
 
 #ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page(struct page *page, int refs)
 {
 	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
@@ -509,7 +509,7 @@ bool __put_devmap_managed_page(struct page *page)
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (page_ref_dec_return(page) == 1)
+	if (page_ref_sub_return(page, refs) == 1)
 		wake_up_var(&page->_refcount);
 	return true;
 }
diff --git a/mm/swap.c b/mm/swap.c
index c6194cfa2af6..94e42a9bab92 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -960,7 +960,7 @@ void release_pages(struct page **pages, int nr)
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (put_devmap_managed_page(&folio->page))
+			if (put_devmap_managed_page(&folio->page, 1))
 				continue;
 			if (folio_put_testzero(folio))
 				free_zone_device_page(&folio->page);

