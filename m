Return-Path: <nvdimm+bounces-3422-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 8134B4F045E
	for <lists+linux-nvdimm@lfdr.de>; Sat,  2 Apr 2022 17:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 2EF223E0F35
	for <lists+linux-nvdimm@lfdr.de>; Sat,  2 Apr 2022 15:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694801866;
	Sat,  2 Apr 2022 15:23:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E6F7A
	for <nvdimm@lists.linux.dev>; Sat,  2 Apr 2022 15:23:35 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2e5e9025c20so59889727b3.7
        for <nvdimm@lists.linux.dev>; Sat, 02 Apr 2022 08:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W5lz1yu1RFJJdDu7tlqZAj/hd2BIwyW9U6AOb+WHcfU=;
        b=VaK/YZ0LEai3SCnmIqYQjLY0MtJCmHqesh95UNNYpEp1s1eLcWGZ8+soRa+hREMxPM
         vfQAvOwhcUsNpepKcdIP4sdD0ivvdxpw9cUdhONb3oG70s0GziVXmrtBdI4xae4Gxu33
         RZL4Xv9V9Pg0ZUQW/PYfaS6Jg+R7GbcWjPjOHyXlQKVhOxWQTx71W1cKEAdGMCajwz4l
         lJSvIg3YUxr8TnQcHRlomRbIE4uJNiaZ1n1LX2YsuVHjSqTf5aguzGNNxxFytAuHz6cC
         R9DkbEOc4+WCiWwTJsINnc1KilKJTv0wpGH9jv9eZDMSL7uDtKk7CGX9HS/Aw4fRsIoI
         UR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W5lz1yu1RFJJdDu7tlqZAj/hd2BIwyW9U6AOb+WHcfU=;
        b=ibbPMLjLaSBgtuoMWHTYvg4/LJgeymYT9zdIMcxv2kmVxgt6qRxmmEAB+lxny46Beu
         aoaT9lN5qDdV7iMtLiEXJz0vCEQga0nPfZoiYW7o84nkaOVkHkmrOquCJ7WB/8KfEnpO
         CtO91AtiP5pv1Isi+/b9ETgQl7DPKA9vgNstEwmtO8D/Wo72A/8zVlvxMJd/sHHSCDFa
         YC7Z9m7ei4/1SuehQFZQSJUdQfpzugX7ltQIa2gVxNQmkVfD76TDS9vMzmBsaxhXF0Gh
         Jb8mkzpY21VIVg/kRDcTrR2hPxg4tX4gOGK1lBjTQRc3ZrtuIA2lJzA5eBuVxi2kYTT6
         zRdQ==
X-Gm-Message-State: AOAM531FZK3e3J0k1JK908ipn0QBlwiasp22JOBqKYzSm0K+vQ3tCKRM
	gc+AGsECMD9VBSIP8P0soYXX6KXs13/SfPLeBzkgew==
X-Google-Smtp-Source: ABdhPJxBtIz5h4o4ZDKE06XtUDNAYTU8cqFRU2+fDTEVoOG7eowpXHczRBTer2vdg7XNoB8BnBTepYLJukeN5EbKTFY=
X-Received: by 2002:a81:897:0:b0:2e5:f3b2:f6de with SMTP id
 145-20020a810897000000b002e5f3b2f6demr15402644ywi.141.1648913014940; Sat, 02
 Apr 2022 08:23:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220318074529.5261-1-songmuchun@bytedance.com> <YkXPA69iLBDHFtjn@qian>
In-Reply-To: <YkXPA69iLBDHFtjn@qian>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 2 Apr 2022 23:22:51 +0800
Message-ID: <CAMZfGtWgPFRK5UogHx7cSesM5=4m2cSvtmk2KhqURHoMEq+=oQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Fix some bugs related to ramp and dax
To: Qian Cai <quic_qiancai@quicinc.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Xiongchun duan <duanxiongchun@bytedance.com>, 
	Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2022 at 11:55 PM Qian Cai <quic_qiancai@quicinc.com> wrote:
>
> On Fri, Mar 18, 2022 at 03:45:23PM +0800, Muchun Song wrote:
> > This series is based on next-20220225.
> >
> > Patch 1-2 fix a cache flush bug, because subsequent patches depend on
> > those on those changes, there are placed in this series.  Patch 3-4
> > are preparation for fixing a dax bug in patch 5.  Patch 6 is code clean=
up
> > since the previous patch remove the usage of follow_invalidate_pte().
>
> Reverting this series fixed boot crashes.
>
>  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>  Mem abort info:
>    ESR =3D 0x96000004
>    EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>    SET =3D 0, FnV =3D 0
>    EA =3D 0, S1PTW =3D 0
>    FSC =3D 0x04: level 0 translation fault
>  Data abort info:
>    ISV =3D 0, ISS =3D 0x00000004
>    CM =3D 0, WnR =3D 0
>  [dfff800000000003] address between user and kernel address ranges
>  Internal error: Oops: 96000004 [#1] PREEMPT SMP
>  Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cp=
ufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_=
neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce drm_ttm_helper mlx5=
_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas nvme_core xhci_pci raid=
_class drm xhci_pci_renesas
>  CPU: 3 PID: 1707 Comm: systemd-udevd Not tainted 5.17.0-next-20220331-00=
004-g2d550916a6b9 #51
>  pstate: 104000c9 (nzcV daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>  pc : __lock_acquire
>  lr : lock_acquire.part.0
>  sp : ffff800030a16fd0
>  x29: ffff800030a16fd0 x28: ffffdd876c4e9f90 x27: 0000000000000018
>  x26: 0000000000000000 x25: 0000000000000018 x24: 0000000000000000
>  x23: ffff08022beacf00 x22: ffffdd8772507660 x21: 0000000000000000
>  x20: 0000000000000000 x19: 0000000000000000 x18: ffffdd8772417d2c
>  x17: ffffdd876c5bc2e0 x16: 1fffe100457d5b06 x15: 0000000000000094
>  x14: 000000000000f1f1 x13: 00000000f3f3f3f3 x12: ffff08022beacf08
>  x11: 1ffffbb0ee482fa5 x10: ffffdd8772417d28 x9 : 0000000000000000
>  x8 : 0000000000000003 x7 : ffffdd876c4e9f90 x6 : 0000000000000000
>  x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
>  x2 : 0000000000000000 x1 : 0000000000000003 x0 : dfff800000000000
>  Call trace:
>   __lock_acquire
>   lock_acquire.part.0
>   lock_acquire
>   _raw_spin_lock
>   page_vma_mapped_walk
>   try_to_migrate_one
>   rmap_walk_anon
>   try_to_migrate
>   __unmap_and_move
>   unmap_and_move
>   migrate_pages
>   migrate_misplaced_page
>   do_huge_pmd_numa_page
>   __handle_mm_fault
>   handle_mm_fault
>   do_translation_fault
>   do_mem_abort
>   el0_da
>   el0t_64_sync_handler
>   el0t_64_sync
>  Code: d65f03c0 d343ff61 d2d00000 f2fbffe0 (38e06820)

Hi,

I have found the root cause. It is because the implementation of
pmd_leaf() on arm64 is wrong.  It didn't consider the PROT_NONE
mapped PMD, which does not match the expectation of pmd_leaf().
I'll send a fixed patch for arm64 like the following.

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgta=
ble.h
index 94e147e5456c..09eaae46a19b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -535,7 +535,7 @@ extern pgprot_t phys_mem_access_prot(struct file
*file, unsigned long pfn,
                                 PMD_TYPE_TABLE)
 #define pmd_sect(pmd)          ((pmd_val(pmd) & PMD_TYPE_MASK) =3D=3D \
                                 PMD_TYPE_SECT)
-#define pmd_leaf(pmd)          pmd_sect(pmd)
+#define pmd_leaf(pmd)          (pmd_present(pmd) && !(pmd_val(pmd) &
PMD_TABLE_BIT))
 #define pmd_bad(pmd)           (!pmd_table(pmd))

 #define pmd_leaf_size(pmd)     (pmd_cont(pmd) ? CONT_PMD_SIZE : PMD_SIZE)

Thanks.

