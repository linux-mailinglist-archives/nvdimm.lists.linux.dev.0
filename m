Return-Path: <nvdimm+bounces-10601-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A5AAD3EA8
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Jun 2025 18:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6B263A3227
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Jun 2025 16:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C9723BCEC;
	Tue, 10 Jun 2025 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Qrb5syym"
X-Original-To: nvdimm@lists.linux.dev
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C138BFF
	for <nvdimm@lists.linux.dev>; Tue, 10 Jun 2025 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749572296; cv=none; b=HU+JBBCnypIFoRXdd5Re0AilOAKmYks6GdNuaKhzHPPgbMzskHEs48CN9K5LeT/Y3k0nT8K07SN4KVwCylFVpvWOxQYw8Hik6TLR6ejjUPSwIYG1kUd224tjc2P8MZ2L+ZZJI6ZQ9XS/jg0eS6SxZJebc6gOiEVYQdhwAJ20OJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749572296; c=relaxed/simple;
	bh=Otn7uUWDHRH/tgHSK/zpXK1rZWcg7LGnbrHiZK9HH0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Kf2AYQRPK9onToc4vXTL5vOuc6Pd+cEp4ns2nA0D3szz4LqzYZiK3q3hMr8qxPq8QxcNo6IAlsPheS87nA/r9/iOn6vByFgcR/4P3B6HKRZ/y/tE+R37JFQT9FYjkctw0lW5D2MI1AtXUaSseqC4VW2JJnbr85pFWwnZsrt/r4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Qrb5syym; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250610161811euoutp024091f215db62e9681cd9ae041150cd3c~HurrTSs-N2862228622euoutp02p
	for <nvdimm@lists.linux.dev>; Tue, 10 Jun 2025 16:18:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250610161811euoutp024091f215db62e9681cd9ae041150cd3c~HurrTSs-N2862228622euoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1749572291;
	bh=pE6uccDncawBTaeE/O1XebhcejC0XaTINrmaJXRgnJw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Qrb5syymTTlgVW1CdHrabdecFe+3HW/W0tOjr+seluTlv+QTE59KG65YpUlLRDqUE
	 eLvfvG9qAWD3EJ75jQAFHSLCrsl5fhvWNnxIIY5dSIhgwUlumI2Gtulg1b711TS1yV
	 SHnK3kgMwPL1wtmCuVmI2yCbxZYcV99JLZhIYlno=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e~Hurq601QC1524815248eucas1p1F;
	Tue, 10 Jun 2025 16:18:11 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250610161809eusmtip2eda1a549605472f8ef4597e13d09bde6~HurpBKaGe2938129381eusmtip2F;
	Tue, 10 Jun 2025 16:18:09 +0000 (GMT)
Message-ID: <957c0d9d-2c37-4d5f-a8b8-8bf90cd0aedb@samsung.com>
Date: Tue, 10 Jun 2025 18:18:09 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and
 PFN_SG_LAST
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>
Cc: David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>, gerald.schaefer@linux.ibm.com,
	dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, jhubbard@nvidia.com,
	zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
	balbirs@nvidia.com, lorenzo.stoakes@oracle.com, John@Groves.net
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20250604032145.463934-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e
X-EPHeader: CA
X-CMS-RootMailID: 20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e
References: <20250604032145.463934-1-apopple@nvidia.com>
	<CGME20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e@eucas1p1.samsung.com>

Dear All,

On 04.06.2025 05:21, Alistair Popple wrote:
> The PFN_MAP flag is no longer used for anything, so remove it.
> The PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been
> used so also remove them. The last user of PFN_SPECIAL was removed
> by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
> support").
>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Cc: gerald.schaefer@linux.ibm.com
> Cc: dan.j.williams@intel.com
> Cc: jgg@ziepe.ca
> Cc: willy@infradead.org
> Cc: david@redhat.com
> Cc: linux-kernel@vger.kernel.org
> Cc: nvdimm@lists.linux.dev
> Cc: jhubbard@nvidia.com
> Cc: hch@lst.de
> Cc: zhang.lyra@gmail.com
> Cc: debug@rivosinc.com
> Cc: bjorn@kernel.org
> Cc: balbirs@nvidia.com
> Cc: lorenzo.stoakes@oracle.com
> Cc: John@Groves.net
>
> ---
>
> Splitting this off from the rest of my series[1] as a separate clean-up
> for consideration for the v6.16 merge window as suggested by Christoph.
>
> [1] - https://lore.kernel.org/linux-mm/cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com/
> ---
>   include/linux/pfn_t.h             | 31 +++----------------------------
>   mm/memory.c                       |  2 --
>   tools/testing/nvdimm/test/iomap.c |  4 ----
>   3 files changed, 3 insertions(+), 34 deletions(-)

This patch landed in today's linux-next as commit 28be5676b4a3 ("mm: 
remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST"). In my tests 
I've noticed that it breaks operation of all RISC-V 64bit boards on my 
test farm (VisionFive2, BananaPiF3 as well as QEMU's Virt machine). I've 
isolated the changes responsible for this issue, see the inline comments 
in the patch below. Here is an example of the issues observed in the 
logs from those machines:

BUG: Bad page map in process modprobe  pte:20682653 pmd:20f23c01
page: refcount:1 mapcount:-1 mapping:0000000000000000 index:0x0 pfn:0x81a09
flags: 0x2004(referenced|reserved|zone=0)
raw: 0000000000002004 ff1c000000068248 ff1c000000068248 0000000000000000
raw: 0000000000000000 0000000000000000 00000001fffffffe 0000000000000000
page dumped because: bad pte
addr:00007fff84619000 vm_flags:04044411 anon_vma:0000000000000000 
mapping:0000000000000000 index:0
file:(null) fault:special_mapping_fault mmap:0x0 mmap_prepare: 0x0 
read_folio:0x0
CPU: 1 UID: 0 PID: 58 Comm: modprobe Not tainted 
6.16.0-rc1-next-20250610+ #15719 NONE
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff80016152>] dump_backtrace+0x1c/0x24
[<ffffffff8000147a>] show_stack+0x28/0x34
[<ffffffff8000f61e>] dump_stack_lvl+0x5e/0x86
[<ffffffff8000f65a>] dump_stack+0x14/0x1c
[<ffffffff80234b7e>] print_bad_pte+0x1b4/0x1ee
[<ffffffff8023854a>] unmap_page_range+0x4da/0xf74
[<ffffffff80239042>] unmap_single_vma.constprop.0+0x5e/0x90
[<ffffffff8023913a>] unmap_vmas+0xc6/0x1c4
[<ffffffff80244a70>] exit_mmap+0xb6/0x418
[<ffffffff80021dc4>] mmput+0x56/0xf2
[<ffffffff8002b84e>] do_exit+0x182/0x80e
[<ffffffff8002c02a>] do_group_exit+0x24/0x70
[<ffffffff8002c092>] pid_child_should_wake+0x0/0x54
[<ffffffff80b66112>] do_trap_ecall_u+0x29c/0x4cc
[<ffffffff80b747e6>] handle_exception+0x146/0x152
Disabling lock debugging due to kernel taint


> diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
> index 2d9148221e9a..46afa12eb33b 100644
> --- a/include/linux/pfn_t.h
> +++ b/include/linux/pfn_t.h
> @@ -5,26 +5,13 @@
>   
>   /*
>    * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
> - * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
> - * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
>    * PFN_DEV - pfn is not covered by system memmap by default
> - * PFN_MAP - pfn has a dynamic page mapping established by a device driver
> - * PFN_SPECIAL - for CONFIG_FS_DAX_LIMITED builds to allow XIP, but not
> - *		 get_user_pages
>    */
>   #define PFN_FLAGS_MASK (((u64) (~PAGE_MASK)) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
> -#define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
> -#define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
>   #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
> -#define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
> -#define PFN_SPECIAL (1ULL << (BITS_PER_LONG_LONG - 5))
>   
>   #define PFN_FLAGS_TRACE \
> -	{ PFN_SPECIAL,	"SPECIAL" }, \
> -	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
> -	{ PFN_SG_LAST,	"SG_LAST" }, \
> -	{ PFN_DEV,	"DEV" }, \
> -	{ PFN_MAP,	"MAP" }
> +	{ PFN_DEV,	"DEV" }
>   
>   static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
>   {
> @@ -46,7 +33,7 @@ static inline pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
>   
>   static inline bool pfn_t_has_page(pfn_t pfn)
>   {
> -	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
> +	return (pfn.val & PFN_DEV) == 0;
>   }
>   
>   static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
> @@ -100,7 +87,7 @@ static inline pud_t pfn_t_pud(pfn_t pfn, pgprot_t pgprot)
>   #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
>   static inline bool pfn_t_devmap(pfn_t pfn)
>   {
> -	const u64 flags = PFN_DEV|PFN_MAP;
> +	const u64 flags = PFN_DEV;
>   
>   	return (pfn.val & flags) == flags;
>   }

The above change causes the stability issues on RISC-V based boards. To 
get them working again with today's linux-next I had to apply the 
following change:

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 6ff7dd305639..f502860f2a76 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -46,7 +46,6 @@ config RISCV
         select ARCH_HAS_PREEMPT_LAZY
         select ARCH_HAS_PREPARE_SYNC_CORE_CMD
         select ARCH_HAS_PTDUMP if MMU
-       select ARCH_HAS_PTE_DEVMAP if 64BIT && MMU
         select ARCH_HAS_PTE_SPECIAL
         select ARCH_HAS_SET_DIRECT_MAP if MMU
         select ARCH_HAS_SET_MEMORY if MMU

I'm not sure if this is really the desired solution and frankly speaking 
I don't understand the code behind the 'devmap' related bits. I can help 
testing other patches that will fix this issue properly.


> @@ -116,16 +103,4 @@ pmd_t pmd_mkdevmap(pmd_t pmd);
>   pud_t pud_mkdevmap(pud_t pud);
>   #endif
>   #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
> -
> -#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
> -static inline bool pfn_t_special(pfn_t pfn)
> -{
> -	return (pfn.val & PFN_SPECIAL) == PFN_SPECIAL;
> -}
> -#else
> -static inline bool pfn_t_special(pfn_t pfn)
> -{
> -	return false;
> -}
> -#endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
>   #endif /* _LINUX_PFN_T_H_ */
> diff --git a/mm/memory.c b/mm/memory.c
> index 49199410805c..cc85f814bc1c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2569,8 +2569,6 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn, bool mkwrite)
>   		return true;
>   	if (pfn_t_devmap(pfn))
>   		return true;
> -	if (pfn_t_special(pfn))
> -		return true;
>   	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
>   		return true;
>   	return false;
> diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
> index e4313726fae3..ddceb04b4a9a 100644
> --- a/tools/testing/nvdimm/test/iomap.c
> +++ b/tools/testing/nvdimm/test/iomap.c
> @@ -137,10 +137,6 @@ EXPORT_SYMBOL_GPL(__wrap_devm_memremap_pages);
>   
>   pfn_t __wrap_phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
>   {
> -	struct nfit_test_resource *nfit_res = get_nfit_res(addr);
> -
> -	if (nfit_res)
> -		flags &= ~PFN_MAP;
>           return phys_to_pfn_t(addr, flags);
>   }
>   EXPORT_SYMBOL(__wrap_phys_to_pfn_t);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


