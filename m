Return-Path: <nvdimm+bounces-2819-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D004A7345
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 15:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2F7F11C0E36
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 14:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC772F32;
	Wed,  2 Feb 2022 14:35:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBE72F29
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 14:35:01 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id c194so6436879pfb.12
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 06:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yfAXAcV/wZ+uHO6JBR1mzR4k32V5m276WxyzPLvNLTE=;
        b=Jtk3Kzgm/acaQdPFcEkC9Vlykmm8QQmOLbTQ0WNCe5c19+7qPERmzZTnk2K/kXPWT3
         awBMTwT+IctxLSgpQTzoCPDBfv7AnZh8a7ms5e+HG/IcD4gkzcs+GVpFwq0BSaaEOBzC
         +Z8F1B1ZxZOxRnIMDLeurg++5JhMZLe2voq7jns4oadz++eOKm6B6z+X9URirr4NHkff
         oy5mB5XhSrwbAb6rAdlIm9OzVkgFJv+SE8i0xol8ijOkdIvv1Hfrr/Ck5yvb/m/I5Jrq
         45/qvfmRK3Rxch2z7W9+sPNOSQH6/gz0279qxMsX6gU59wHHjcAL2zSo6NjBGpmVSnyW
         a01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yfAXAcV/wZ+uHO6JBR1mzR4k32V5m276WxyzPLvNLTE=;
        b=BnEQ3KNrpZjiJEyy9cBNgkwOzyCimEpwlSYPoeDNTgXLWJHuYZ8C3xxWw0lZkZXAZP
         bkEWDad71Ae6po76wIHrXIlxXZjGGnxc0khPSEaBmCThlMkXmCkriW8CxBNCR6tXYFDE
         E97EmyFo5axmddSSlV+rKekf3/6UUXjatiWGcEujgWtG6bEuVeX4y1Dvw0oxE2oWMnx8
         IpQFpCs/Va1I3A/WV8HafDbZ5A9wXjnSOu1Cuy6Qo/4JI64lGxKZmJOBMl/axhJWBcwP
         T6IVlNqBfFDhN7YeeqSIWpe/rJGxDfanZgvc2ZdhaXa8uI/h3HN5YUpFhydVkMPyO2PQ
         tU/g==
X-Gm-Message-State: AOAM5301+d8W/RTBJULvBLxtY9fE+bm6rRVo156I2Z3DQtLYMyYEyiW4
	x3/qleoYx+KMw3eLq69izU0m4g==
X-Google-Smtp-Source: ABdhPJzW7VqsfdOXDPUXv6t69WSXlrB+FLAIOju7z/IcFQKVnTEKauVXBfJqD5J3XyiRSyiWJX7H4w==
X-Received: by 2002:a05:6a00:174b:: with SMTP id j11mr9475901pfc.19.1643812500607;
        Wed, 02 Feb 2022 06:35:00 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id s9sm29079268pgm.76.2022.02.02.06.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 06:35:00 -0800 (PST)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 6/6] mm: remove range parameter from follow_invalidate_pte()
Date: Wed,  2 Feb 2022 22:33:07 +0800
Message-Id: <20220202143307.96282-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220202143307.96282-1-songmuchun@bytedance.com>
References: <20220202143307.96282-1-songmuchun@bytedance.com>
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
index d211a06784d5..7895b17f6847 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1814,9 +1814,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
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
index 514a81cdd1ae..e8ce066be5f2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4869,9 +4869,8 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
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
@@ -4898,31 +4897,17 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
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
@@ -4930,8 +4915,6 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, *ptlp);
-	if (range)
-		mmu_notifier_invalidate_range_end(range);
 out:
 	return -EINVAL;
 }
@@ -4960,7 +4943,7 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp)
 {
-	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
+	return follow_invalidate_pte(mm, address, ptepp, NULL, ptlp);
 }
 EXPORT_SYMBOL_GPL(follow_pte);
 
-- 
2.11.0


