Return-Path: <nvdimm+bounces-3200-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7420E4C9F38
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Mar 2022 09:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 388013E0F0D
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Mar 2022 08:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F1C2590;
	Wed,  2 Mar 2022 08:29:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769C42576
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 08:29:55 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id v4so1151623pjh.2
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 00:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4hzepAOQTsZTnVcr4QPZkWOiCoYklQmYHIbKFxu1/40=;
        b=BHUW+N1Ur7UISy6INaVLWByZSyogvV+wzA1z7v+CiybCHBc+N8nc1LoUx9B/gbMwk8
         HIxbxIEXNDbK6hfHZimmn14xUJYqq3yIVmG70INxE2KYfLl4KmUNNh9XfTB7LkU3YpoV
         FG8rJke6cX1AZ2UNkxOr9wCCg9VWLMfZ5ewsd/xbWM2tDR4yezKnqBpsuxXvnOn7EZIa
         cGtrTwXg+9wcFTsu2uis6l8DW1Civ6IoXbVOGDJpqxQ+17Wz2WPYDrgF6vrr7l0UtmwZ
         3063ZCy+GqpkS/YiXnDcw0ssHDJXt9k86JVDTmf2n/tlC+Ntv50DXrHDr7skXOtprb2j
         vqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4hzepAOQTsZTnVcr4QPZkWOiCoYklQmYHIbKFxu1/40=;
        b=dEi3gA7h8eLF0ttYSqYBxaaJWBDdRy4jDQXwAwYTxX67AXsx7eC4TODldHy6amCvln
         4Xtr25XtBc/mJg+vnKJKzaf1Hh8uuyQFAQ3XaF8ARZ9xekuuwfdRfOv37K6liWAOMptn
         fDgufRJ0E1XDASd0kb+tIggPUJ38Yhuf4lqY/paP6cYuoCo1CqBC6c/XUFDFfWTGX/M9
         kPMsyD+VwojXxy3yI9OF+uBgR9ZAIybc/qWWqR/FTFcHVKabZ4kR89JSePYa67Z4xItA
         gb5QFaxiqJIeOf+c43kpmFhjfrBw9E63DlURhA4B+KsqILoSqmW/vtYb/haH9/KZcWAS
         +D2A==
X-Gm-Message-State: AOAM5332H07rMl659mfYOMxfZTh0az0H1d2izmvogpsFgpYPfu5WcHp+
	2w7Yb3KGl3dmDISTAtmG5YXmnw==
X-Google-Smtp-Source: ABdhPJyz4uqOwKQjoCqmWeCnPA8FTI71YHNESq0Oi6Zb6fkSHMg74TLKOucvxJxvZaZ9ZDbR40TJ5g==
X-Received: by 2002:a17:90a:c901:b0:1be:ce4d:7cee with SMTP id v1-20020a17090ac90100b001bece4d7ceemr9400545pjt.213.1646209794788;
        Wed, 02 Mar 2022 00:29:54 -0800 (PST)
Received: from FVFYT0MHHV2J.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id a20-20020a056a000c9400b004f396b965a9sm20922228pfv.49.2022.03.02.00.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:29:54 -0800 (PST)
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
Subject: [PATCH v4 6/6] mm: remove range parameter from follow_invalidate_pte()
Date: Wed,  2 Mar 2022 16:27:18 +0800
Message-Id: <20220302082718.32268-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220302082718.32268-1-songmuchun@bytedance.com>
References: <20220302082718.32268-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only user (DAX) of range parameter of follow_invalidate_pte()
is gone, it safe to remove the range paramter and make it static
to simlify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h |  3 ---
 mm/memory.c        | 23 +++--------------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c9bada4096ac..be7ec4c37ebe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1871,9 +1871,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
diff --git a/mm/memory.c b/mm/memory.c
index cc6968dc8e4e..278ab6d62b54 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4964,9 +4964,8 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp)
+static int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
+				 pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4993,31 +4992,17 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 		if (!pmdpp)
 			goto out;
 
-		if (range) {
-			mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0,
-						NULL, mm, address & PMD_MASK,
-						(address & PMD_MASK) + PMD_SIZE);
-			mmu_notifier_invalidate_range_start(range);
-		}
 		*ptlp = pmd_lock(mm, pmd);
 		if (pmd_huge(*pmd)) {
 			*pmdpp = pmd;
 			return 0;
 		}
 		spin_unlock(*ptlp);
-		if (range)
-			mmu_notifier_invalidate_range_end(range);
 	}
 
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
 
-	if (range) {
-		mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
-					address & PAGE_MASK,
-					(address & PAGE_MASK) + PAGE_SIZE);
-		mmu_notifier_invalidate_range_start(range);
-	}
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
 	if (!pte_present(*ptep))
 		goto unlock;
@@ -5025,8 +5010,6 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, *ptlp);
-	if (range)
-		mmu_notifier_invalidate_range_end(range);
 out:
 	return -EINVAL;
 }
@@ -5055,7 +5038,7 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp)
 {
-	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
+	return follow_invalidate_pte(mm, address, ptepp, NULL, ptlp);
 }
 EXPORT_SYMBOL_GPL(follow_pte);
 
-- 
2.11.0


