Return-Path: <nvdimm+bounces-3420-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A95E4EE9FE
	for <lists+linux-nvdimm@lfdr.de>; Fri,  1 Apr 2022 10:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id B26FE1C0B40
	for <lists+linux-nvdimm@lfdr.de>; Fri,  1 Apr 2022 08:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7969AED8;
	Fri,  1 Apr 2022 08:51:43 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59881ED5
	for <nvdimm@lists.linux.dev>; Fri,  1 Apr 2022 08:51:41 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2e64a6b20eeso25270657b3.3
        for <nvdimm@lists.linux.dev>; Fri, 01 Apr 2022 01:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RjJ1bjnY3yC7gcQ9YS5qaiBX2qOX1uixT7iNAUTqu/s=;
        b=Qwke0j5cNSfW+QLAH417fkXqqvprzeTvgfWCezbyZYAcEuhBvPf4dIQLDqUxYy5r4r
         8k1qcZc9m5ZitSY2JR/87JiB+hc3YH9NocaAR8HGVFi6mZ31IEuADhnGdefDZw+t6DWm
         4p90eKLtxVyL7ziemcb3oedo3B4CbgR2XdUZ2LQnlDDGjiHfK57zvc4QwEcXqpPADubr
         fQ/axZWhJGrGzckbvq9C2XznH1yhsnZvSw/vt59JucefYVYR6Bl4ENmgVL5WqR45XGR7
         XGX8adUN/4eMm91t8lzcv1sdzdZhW2BeSaddPisTG+exrR9XJtMrBWdqRB6Qs4Djz7n5
         kTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RjJ1bjnY3yC7gcQ9YS5qaiBX2qOX1uixT7iNAUTqu/s=;
        b=55N9vFJ9Yl9r0KVhhtn19iOmzdfWYQTu2iOJFir0shV3N0D0BKMIUVTXUyzdH/pKzP
         hQ6QANP0MfobkqjUGL2v7/bBlaStqFtUIKZblx3cspU1pc6gsZy4LLInoYX8/O965nhK
         4f/WezuEt2dL1Jyh/fk4zvWDWgWbiU3ejXmJHKet0spZmfDia3r5DbfP5ni/XL8yC1fZ
         /3b75urCvfO/0WbHc2QifRCruJSULypH87kOsi/DXnh8Um0vZISLuzu95WkF4WJ9oq4o
         YDwTYtn3c3dIXQOX8+ATyctDEVruzuO1d2SSmu2VjufybASH4HnsvkFf4GP/+zaTBWla
         ICFg==
X-Gm-Message-State: AOAM532ImNNgw9DftH0fV3wdiTKfyoe7KCfLC8o6R6twNcSzikObxja4
	zgsyzPVj3j7qHZvl3OjY3mCFuzWN+kuqx4NqEBznbg==
X-Google-Smtp-Source: ABdhPJwRAy6acFWGBZwFV4R+u5WXDyOLbWjYHwNmm2IBUhuVbI5bly0fqy3QmyeXvU6TE53jQncAnjgNcMES58pgicE=
X-Received: by 2002:a81:5dd6:0:b0:2d6:3041:12e0 with SMTP id
 r205-20020a815dd6000000b002d6304112e0mr8972109ywb.331.1648803100207; Fri, 01
 Apr 2022 01:51:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220318074529.5261-1-songmuchun@bytedance.com>
 <YkXPA69iLBDHFtjn@qian> <CAMZfGtWFg=khjaHsjeHA24G8DMbjbRYRhGytBHaD7FbORa+iMg@mail.gmail.com>
In-Reply-To: <CAMZfGtWFg=khjaHsjeHA24G8DMbjbRYRhGytBHaD7FbORa+iMg@mail.gmail.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 1 Apr 2022 16:50:59 +0800
Message-ID: <CAMZfGtVgWWchbSh4cH-0pGgSWaDjN=WE9Rh-Dgm_j3_ojwNEgw@mail.gmail.com>
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

On Fri, Apr 1, 2022 at 11:44 AM Muchun Song <songmuchun@bytedance.com> wrot=
e:
>
> On Thu, Mar 31, 2022 at 11:55 PM Qian Cai <quic_qiancai@quicinc.com> wrot=
e:
> >
> > On Fri, Mar 18, 2022 at 03:45:23PM +0800, Muchun Song wrote:
> > > This series is based on next-20220225.
> > >
> > > Patch 1-2 fix a cache flush bug, because subsequent patches depend on
> > > those on those changes, there are placed in this series.  Patch 3-4
> > > are preparation for fixing a dax bug in patch 5.  Patch 6 is code cle=
anup
> > > since the previous patch remove the usage of follow_invalidate_pte().
> >
> > Reverting this series fixed boot crashes.
> >
> >  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> >  Mem abort info:
> >    ESR =3D 0x96000004
> >    EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> >    SET =3D 0, FnV =3D 0
> >    EA =3D 0, S1PTW =3D 0
> >    FSC =3D 0x04: level 0 translation fault
> >  Data abort info:
> >    ISV =3D 0, ISS =3D 0x00000004
> >    CM =3D 0, WnR =3D 0
> >  [dfff800000000003] address between user and kernel address ranges
> >  Internal error: Oops: 96000004 [#1] PREEMPT SMP
> >  Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_=
cpufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xo=
r_neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce drm_ttm_helper ml=
x5_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas nvme_core xhci_pci ra=
id_class drm xhci_pci_renesas
> >  CPU: 3 PID: 1707 Comm: systemd-udevd Not tainted 5.17.0-next-20220331-=
00004-g2d550916a6b9 #51
> >  pstate: 104000c9 (nzcV daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> >  pc : __lock_acquire
> >  lr : lock_acquire.part.0
> >  sp : ffff800030a16fd0
> >  x29: ffff800030a16fd0 x28: ffffdd876c4e9f90 x27: 0000000000000018
> >  x26: 0000000000000000 x25: 0000000000000018 x24: 0000000000000000
> >  x23: ffff08022beacf00 x22: ffffdd8772507660 x21: 0000000000000000
> >  x20: 0000000000000000 x19: 0000000000000000 x18: ffffdd8772417d2c
> >  x17: ffffdd876c5bc2e0 x16: 1fffe100457d5b06 x15: 0000000000000094
> >  x14: 000000000000f1f1 x13: 00000000f3f3f3f3 x12: ffff08022beacf08
> >  x11: 1ffffbb0ee482fa5 x10: ffffdd8772417d28 x9 : 0000000000000000
> >  x8 : 0000000000000003 x7 : ffffdd876c4e9f90 x6 : 0000000000000000
> >  x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
> >  x2 : 0000000000000000 x1 : 0000000000000003 x0 : dfff800000000000
> >  Call trace:
> >   __lock_acquire
> >   lock_acquire.part.0
> >   lock_acquire
> >   _raw_spin_lock
> >   page_vma_mapped_walk
> >   try_to_migrate_one
> >   rmap_walk_anon
> >   try_to_migrate
> >   __unmap_and_move
> >   unmap_and_move
> >   migrate_pages
> >   migrate_misplaced_page
> >   do_huge_pmd_numa_page
> >   __handle_mm_fault
> >   handle_mm_fault
> >   do_translation_fault
> >   do_mem_abort
> >   el0_da
> >   el0t_64_sync_handler
> >   el0t_64_sync
> >  Code: d65f03c0 d343ff61 d2d00000 f2fbffe0 (38e06820)
> >  ---[ end trace 0000000000000000 ]---
> >  Kernel panic - not syncing: Oops: Fatal exception
> >  SMP: stopping secondary CPUs
> >  Kernel Offset: 0x5d8763da0000 from 0xffff800008000000
> >  PHYS_OFFSET: 0x80000000
> >  CPU features: 0x000,00085c0d,19801c82
> >  Memory Limit: none
> >  ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
>
> Thanks for your report. Would you mind providing the .config?

Hi Qian Cai,

Would you mind helping me test if the following patch works properly?
Thanks.

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b3bf802a6435..3da82bf65de8 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -210,7 +210,8 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *=
pvmw)
                 */
                pmde =3D READ_ONCE(*pvmw->pmd);

-               if (pmd_leaf(pmde) || is_pmd_migration_entry(pmde)) {
+               if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde) ||
+                   (pmd_present(pmde) && pmd_devmap(pmde))) {
                        pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
                        pmde =3D *pvmw->pmd;
                        if (!pmd_present(pmde)) {

