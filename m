Return-Path: <nvdimm+bounces-3395-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 955054EAECA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Mar 2022 15:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 066B63E0EDA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Mar 2022 13:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB98B256F;
	Tue, 29 Mar 2022 13:50:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856E42565
	for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 13:50:03 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id n18so17669442plg.5
        for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 06:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lWUQux1KtYb2lW/SJw8SxLz0dcCTGFUlQsH2e++z+XY=;
        b=G+yhSk66jiVLFXbnCli3qF1UuypYzD4UqkQIn1/aZOoVNQLq390i4W2QbZAC1uDbTv
         rZHDyKdUZch1cCyQwiItvCeWoFUVMPhHHNpNl1SsUHEKpGxXNeS2lnMlGl2mQyg9e6Td
         20C+VHU3kXJ7MkQD50IREG/ueYGfVheuUaQE2rss4yrmVFYh0hD6tO+E5CAfYUbjzLen
         91ZIRCLWjLARmAsFuj6larvZQL+0dmu5fCHPE+h/nGNEq6n4pFDmjJdWxd3UgmzovtfT
         KKja+3nR5tlwpLaEOr/W6RFWXi69I8Uy3nflR3wKh75PEib2MYmy8YG0yDgvkjLKI9Cm
         E7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWUQux1KtYb2lW/SJw8SxLz0dcCTGFUlQsH2e++z+XY=;
        b=Ir03CkEFY8E30Arp3DKXzivRFSsij6Y/h+Ej8FvBTI2VoVo4gj7POg7BxhBF4OABqj
         Sa+FxDBdxT+rEaxCKGHKIl5qc6RZ7Ul/X5T/VhAGpA+TaQx/iEFov/72TD7B0tOWldY3
         9NUyjCwjPf4pvNBqnhCNYOsE3ifJ+joGljRoKvO0P9yIpaiczyf92SIb3IfdvKttshh5
         HlzuftiYJM5iKeAjY79XcDeOhEbPhD0ROA9beXcinlbhE151DUhe+GEy/uN9eAXpbp/d
         XmPFW8gLdKa+7A4iPUTEvp1t3fMj0p1qcbc9hN46adIg2bqwqvRURM9JSsu6G3jPowxY
         H3FA==
X-Gm-Message-State: AOAM532d2lvHuIELSVmVf8SV9pmXuHcPQd1l3tH7eKbbnK3T2BjRQdpP
	+bTmIFe4bLntMhtkOOv2sHwIau49nC/hKw==
X-Google-Smtp-Source: ABdhPJxdiH3g9l4QwZUkPToArdeUP0GSfrH58csPQ0KFDVI06KXDGgJnArklayTM7bVUr37Iyzttug==
X-Received: by 2002:a17:90b:3851:b0:1c7:d26:2294 with SMTP id nl17-20020a17090b385100b001c70d262294mr4598517pjb.97.1648561802997;
        Tue, 29 Mar 2022 06:50:02 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id o14-20020a056a0015ce00b004fab49cd65csm20911293pfu.205.2022.03.29.06.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:50:02 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	shy828301@gmail.com,
	rcampbell@nvidia.com,
	hughd@google.com,
	xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com,
	zwisler@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	duanxiongchun@bytedance.com,
	smuchun@gmail.com,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 4/6] mm: pvmw: add support for walking devmap pages
Date: Tue, 29 Mar 2022 21:48:51 +0800
Message-Id: <20220329134853.68403-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220329134853.68403-1-songmuchun@bytedance.com>
References: <20220329134853.68403-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The devmap pages can not use page_vma_mapped_walk() to check if a huge
devmap page is mapped into a vma.  Add support for walking huge devmap
pages so that DAX can use it in the next patch.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_vma_mapped.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 1187f9c1ec5b..b3bf802a6435 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -210,16 +210,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 */
 		pmde = READ_ONCE(*pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_leaf(pmde) || is_pmd_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (likely(pmd_trans_huge(pmde))) {
-				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
-				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
-				return true;
-			}
 			if (!pmd_present(pmde)) {
 				swp_entry_t entry;
 
@@ -232,6 +225,13 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 					return not_found(pvmw);
 				return true;
 			}
+			if (likely(pmd_trans_huge(pmde) || pmd_devmap(pmde))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(pmd_pfn(pmde), pvmw))
+					return not_found(pvmw);
+				return true;
+			}
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
-- 
2.11.0


