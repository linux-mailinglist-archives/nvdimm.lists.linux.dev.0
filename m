Return-Path: <nvdimm+bounces-2963-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C68A4B0728
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 08:29:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E2AB13E10C3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 07:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2A82F5D;
	Thu, 10 Feb 2022 07:29:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B682F49
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wCdTPi8sABXHaeJsId/JTSLi+c8Rwwiec5m8oAEznlg=; b=0e+HFPbe1yvFskke6QJO8jYN43
	BL27P4rhMpZrOyRnm/Q2IFdFK02AdjcEHuLHbNOgqaLpJ3k/+8sdPvBcS5BMSWbYwm818f8/pHJQ9
	N6oYv7ggwmp8pNG9UCE+nV9x3jkbmqJnBv5FDZzSl++H9pOEAFWok4hWRhxOgmkhE64XUtmaenhWA
	Lh/ETXt+Tg9Ly39G8h9Zs+lMnNyI8iCH6l06TLjGId++3ApOcROW1jra68QUFiTSPijOLQlJqTfYy
	PPFccOKbpQRr0/fwy/8IDnvxqIcU/bJJQOB6XJcncTYxCVdGbrUPwCTMYwjK/GOD7R6PdxZnOrdmu
	srX0uIbw==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3t0-002ryS-8V; Thu, 10 Feb 2022 07:29:02 +0000
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
	linux-mm@kvack.org
Subject: [PATCH 11/27] mm: refactor the ZONE_DEVICE handling in migrate_vma_insert_page
Date: Thu, 10 Feb 2022 08:28:12 +0100
Message-Id: <20220210072828.2930359-12-hch@lst.de>
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

Make the flow a little more clear and prepare for adding a new
ZONE_DEVICE memory type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/migrate.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8e0370a73f8a43..30ecd7223656c1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2670,26 +2670,25 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	 */
 	__SetPageUptodate(page);
 
-	if (is_zone_device_page(page)) {
-		if (is_device_private_page(page)) {
-			swp_entry_t swp_entry;
+	if (is_device_private_page(page)) {
+		swp_entry_t swp_entry;
 
-			if (vma->vm_flags & VM_WRITE)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page));
-			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page));
-			entry = swp_entry_to_pte(swp_entry);
-		} else {
-			/*
-			 * For now we only support migrating to un-addressable
-			 * device memory.
-			 */
+		if (vma->vm_flags & VM_WRITE)
+			swp_entry = make_writable_device_private_entry(
+						page_to_pfn(page));
+		else
+			swp_entry = make_readable_device_private_entry(
+						page_to_pfn(page));
+		entry = swp_entry_to_pte(swp_entry);
+	} else {
+		/*
+		 * For now we only support migrating to un-addressable device
+		 * memory.
+		 */
+		if (is_zone_device_page(page)) {
 			pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
 			goto abort;
 		}
-	} else {
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (vma->vm_flags & VM_WRITE)
 			entry = pte_mkwrite(pte_mkdirty(entry));
-- 
2.30.2


