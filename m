Return-Path: <nvdimm+bounces-3416-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD6D4EDE16
	for <lists+linux-nvdimm@lfdr.de>; Thu, 31 Mar 2022 17:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E50BF3E0E66
	for <lists+linux-nvdimm@lfdr.de>; Thu, 31 Mar 2022 15:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493B6A29;
	Thu, 31 Mar 2022 15:58:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
	(using TLSv1.2 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83347B
	for <nvdimm@lists.linux.dev>; Thu, 31 Mar 2022 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648742284; x=1680278284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7FgYWF4J7bdb/TBEmXiYCMO6B69KOL67kC6P7Wxf7pg=;
  b=OSdero/5gMyd15iLG64vmt7T4NhCEfLQZHVYdNDry29np49d6S7Jvpu4
   7v/kryUqHGxDZwSayXDrfo8S+B8is8G80Fz47+AxTeLfy/EvSBJcTJJCU
   mPJcg1xABJwMV/wK0Ni6ScA96yyOjc4S7VkSPILmSbFuxVjwcNKozBsKr
   M=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 31 Mar 2022 08:55:55 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 08:55:53 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 31 Mar 2022 08:55:53 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 31 Mar
 2022 08:55:49 -0700
Date: Thu, 31 Mar 2022 11:55:47 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<viro@zeniv.linux.org.uk>, <akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<shy828301@gmail.com>, <rcampbell@nvidia.com>, <hughd@google.com>,
	<xiyuyang19@fudan.edu.cn>, <kirill.shutemov@linux.intel.com>,
	<zwisler@kernel.org>, <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <duanxiongchun@bytedance.com>, <smuchun@gmail.com>
Subject: Re: [PATCH v5 0/6] Fix some bugs related to ramp and dax
Message-ID: <YkXPA69iLBDHFtjn@qian>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220318074529.5261-1-songmuchun@bytedance.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)

On Fri, Mar 18, 2022 at 03:45:23PM +0800, Muchun Song wrote:
> This series is based on next-20220225.
> 
> Patch 1-2 fix a cache flush bug, because subsequent patches depend on
> those on those changes, there are placed in this series.  Patch 3-4
> are preparation for fixing a dax bug in patch 5.  Patch 6 is code cleanup
> since the previous patch remove the usage of follow_invalidate_pte().

Reverting this series fixed boot crashes.

 KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
 Mem abort info:
   ESR = 0x96000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x04: level 0 translation fault
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 [dfff800000000003] address between user and kernel address ranges
 Internal error: Oops: 96000004 [#1] PREEMPT SMP
 Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cpufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce drm_ttm_helper mlx5_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas nvme_core xhci_pci raid_class drm xhci_pci_renesas
 CPU: 3 PID: 1707 Comm: systemd-udevd Not tainted 5.17.0-next-20220331-00004-g2d550916a6b9 #51
 pstate: 104000c9 (nzcV daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __lock_acquire
 lr : lock_acquire.part.0
 sp : ffff800030a16fd0
 x29: ffff800030a16fd0 x28: ffffdd876c4e9f90 x27: 0000000000000018
 x26: 0000000000000000 x25: 0000000000000018 x24: 0000000000000000
 x23: ffff08022beacf00 x22: ffffdd8772507660 x21: 0000000000000000
 x20: 0000000000000000 x19: 0000000000000000 x18: ffffdd8772417d2c
 x17: ffffdd876c5bc2e0 x16: 1fffe100457d5b06 x15: 0000000000000094
 x14: 000000000000f1f1 x13: 00000000f3f3f3f3 x12: ffff08022beacf08
 x11: 1ffffbb0ee482fa5 x10: ffffdd8772417d28 x9 : 0000000000000000
 x8 : 0000000000000003 x7 : ffffdd876c4e9f90 x6 : 0000000000000000
 x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
 x2 : 0000000000000000 x1 : 0000000000000003 x0 : dfff800000000000
 Call trace:
  __lock_acquire
  lock_acquire.part.0
  lock_acquire
  _raw_spin_lock
  page_vma_mapped_walk
  try_to_migrate_one
  rmap_walk_anon
  try_to_migrate
  __unmap_and_move
  unmap_and_move
  migrate_pages
  migrate_misplaced_page
  do_huge_pmd_numa_page
  __handle_mm_fault
  handle_mm_fault
  do_translation_fault
  do_mem_abort
  el0_da
  el0t_64_sync_handler
  el0t_64_sync
 Code: d65f03c0 d343ff61 d2d00000 f2fbffe0 (38e06820)
 ---[ end trace 0000000000000000 ]---
 Kernel panic - not syncing: Oops: Fatal exception
 SMP: stopping secondary CPUs
 Kernel Offset: 0x5d8763da0000 from 0xffff800008000000
 PHYS_OFFSET: 0x80000000
 CPU features: 0x000,00085c0d,19801c82
 Memory Limit: none
 ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> 
> v5:
> - Collect Reviewed-by from Dan Williams.
> - Fix panic reported by kernel test robot <oliver.sang@intel.com>.
> - Remove pmdpp parameter from follow_invalidate_pte() and fold it into follow_pte().
> 
> v4:
> - Fix compilation error on riscv.
> 
> v3:
> - Based on next-20220225.
> 
> v2:
> - Avoid the overly long line in lots of places suggested by Christoph.
> - Fix a compiler warning reported by kernel test robot since pmd_pfn()
>   is not defined when !CONFIG_TRANSPARENT_HUGEPAGE on powerpc architecture.
> - Split a new patch 4 for preparation of fixing the dax bug.
> 
> Muchun Song (6):
>   mm: rmap: fix cache flush on THP pages
>   dax: fix cache flush on PMD-mapped pages
>   mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
>   mm: pvmw: add support for walking devmap pages
>   dax: fix missing writeprotect the pte entry
>   mm: simplify follow_invalidate_pte()
> 
>  fs/dax.c             | 82 +++++-----------------------------------------------
>  include/linux/mm.h   |  3 --
>  include/linux/rmap.h |  3 ++
>  mm/internal.h        | 26 +++++++++++------
>  mm/memory.c          | 81 +++++++++++++++------------------------------------
>  mm/page_vma_mapped.c | 16 +++++-----
>  mm/rmap.c            | 68 +++++++++++++++++++++++++++++++++++--------
>  7 files changed, 114 insertions(+), 165 deletions(-)
> 
> -- 
> 2.11.0
> 

