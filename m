Return-Path: <nvdimm+bounces-3311-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F07E4D95B0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Mar 2022 08:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 76BD73E0E4A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Mar 2022 07:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AF41B99;
	Tue, 15 Mar 2022 07:53:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF351B75
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 07:53:21 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id u103so316898ybi.9
        for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 00:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fx9f/dGI0jG5qMZR80BsY4AEIW3adegKwssDhY/VxU=;
        b=X3kXd8IgVsb6phSuLDtCPMN6ZSj5LyxjrsIZNHgQ1y74uWx+8ke/pSvk5/wrAfN+AV
         lwpxSb95g8tsy1IKUKROLcWljPhTXP8G8CdfQvYCYBCD4WKDaNM1W7gd26JURACTcKTK
         U3+872+E2nf2ZnX6YFLLKzHo1LqglmwIRHhnzsh/9xpK3F76XwIov/1a/2/lc3AjvK3y
         WJ3CsWyLfDSnxyYDTEkXFcjTEtAy0l249WxSCqLrNslHL2R5ohpXwQGVELyaSdGfbjGW
         r8S2HA/zPdzeDW0xO6HOu5NqHdJUdjPlrWCCjkMuxlduawfSy2iACKrnAHZi4WI2RqB9
         NLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fx9f/dGI0jG5qMZR80BsY4AEIW3adegKwssDhY/VxU=;
        b=tX46ZJ4E6E8ziXtVvrpuAVXvyWuiihnfDBTTP/vZJA9IJkUl8SeIzZAS6tgFJTFsAU
         gF4MHIu1V8MfJUZnlLjBupmGvh0hLPtRwM8Zc76X8zOxhLzGFE2wLfb4np1CYMkFWeOc
         bgbxhoxzSFSOCozohMnsKAeaQnno04WzQOLT1zapsKdf448jYS+NIseBIN03j6TUsMCd
         hYSyR3HgQfPHwEfShMBcFKQ53JibABK8lboTBT24+pINHVcCNcmx3Gduqkpins/c5KnN
         dWZeeTQyxzp4ky0I3H+ZlXmUIgGixKeVNyP7UwW1CchKZzLtTxP/grXK1czRPEF4OXHS
         3r8g==
X-Gm-Message-State: AOAM5309c4engT/N3g898vV+5DwDHqSex/H7sYGJm2X/x7nyjZOCMwPr
	ghGTRVz1J2+XnP+9M2Ql2YO6kRLJqs56bhCRhR+A5A==
X-Google-Smtp-Source: ABdhPJxOY+Gd7fbyVQ1ZM8TF+hRcSWHjS8y0g3Rs/rRlJp/i6LSmbPejo0CMOLJoPxKwDrAWMN6zwhZl7EOhjTmKxxw=
X-Received: by 2002:a25:dc4:0:b0:629:2337:f9ea with SMTP id
 187-20020a250dc4000000b006292337f9eamr21531864ybn.6.1647330800437; Tue, 15
 Mar 2022 00:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com>
 <20220302082718.32268-6-songmuchun@bytedance.com> <CAPcyv4hsMWe1AreVVhGJD-St3FGtGBMeA-BX7XbA_kVX97tw4Q@mail.gmail.com>
 <CAMZfGtUmhcryboPdRC7ZhWVuV3TX0rLcKUxhvamAGbHUoATaow@mail.gmail.com> <CAPcyv4gdP+FSsQW2+W3+NKNGnM3fAfF3d=ZxuCDc+r_AnRBCUg@mail.gmail.com>
In-Reply-To: <CAPcyv4gdP+FSsQW2+W3+NKNGnM3fAfF3d=ZxuCDc+r_AnRBCUg@mail.gmail.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 15 Mar 2022 15:51:31 +0800
Message-ID: <CAMZfGtX1tgMQX3iCMO_x=HG1y2c21038YQUWuSzhaO2miUTLcA@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] dax: fix missing writeprotect the pte entry
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	Xiongchun duan <duanxiongchun@bytedance.com>, Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 15, 2022 at 4:50 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Mar 11, 2022 at 1:06 AM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > On Thu, Mar 10, 2022 at 8:59 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > On Wed, Mar 2, 2022 at 12:30 AM Muchun Song <songmuchun@bytedance.com> wrote:
> > > >
> > > > Currently dax_mapping_entry_mkclean() fails to clean and write protect
> > > > the pte entry within a DAX PMD entry during an *sync operation. This
> > > > can result in data loss in the following sequence:
> > > >
> > > >   1) process A mmap write to DAX PMD, dirtying PMD radix tree entry and
> > > >      making the pmd entry dirty and writeable.
> > > >   2) process B mmap with the @offset (e.g. 4K) and @length (e.g. 4K)
> > > >      write to the same file, dirtying PMD radix tree entry (already
> > > >      done in 1)) and making the pte entry dirty and writeable.
> > > >   3) fsync, flushing out PMD data and cleaning the radix tree entry. We
> > > >      currently fail to mark the pte entry as clean and write protected
> > > >      since the vma of process B is not covered in dax_entry_mkclean().
> > > >   4) process B writes to the pte. These don't cause any page faults since
> > > >      the pte entry is dirty and writeable. The radix tree entry remains
> > > >      clean.
> > > >   5) fsync, which fails to flush the dirty PMD data because the radix tree
> > > >      entry was clean.
> > > >   6) crash - dirty data that should have been fsync'd as part of 5) could
> > > >      still have been in the processor cache, and is lost.
> > >
> > > Excellent description.
> > >
> > > >
> > > > Just to use pfn_mkclean_range() to clean the pfns to fix this issue.
> > >
> > > So the original motivation for CONFIG_FS_DAX_LIMITED was for archs
> > > that do not have spare PTE bits to indicate pmd_devmap(). So this fix
> > > can only work in the CONFIG_FS_DAX_LIMITED=n case and in that case it
> > > seems you can use the current page_mkclean_one(), right?
> >
> > I don't know the history of CONFIG_FS_DAX_LIMITED.
> > page_mkclean_one() need a struct page associated with
> > the pfn,  do the struct pages exist when CONFIG_FS_DAX_LIMITED
> > and ! FS_DAX_PMD?
>
> CONFIG_FS_DAX_LIMITED was created to preserve some DAX use for S390
> which does not have CONFIG_ARCH_HAS_PTE_DEVMAP. Without PTE_DEVMAP
> then get_user_pages() for DAX mappings fails.
>
> To your question, no, there are no pages at all in the
> CONFIG_FS_DAX_LIMITED=y case. So page_mkclean_one() could only be
> deployed for PMD mappings, but I think it is reasonable to just
> disable PMD mappings for the CONFIG_FS_DAX_LIMITED=y case.
>
> Going forward the hope is to remove the ARCH_HAS_PTE_DEVMAP
> requirement for DAX, and use PTE_SPECIAL for the S390 case. However,
> that still wants to have 'struct page' availability as an across the
> board requirement.

Got it. Thanks for your patient explanation.

>
> > If yes, I think you are right. But I don't
> > see this guarantee. I am not familiar with DAX code, so what am
> > I missing here?
>
> Perhaps I missed a 'struct page' dependency? I thought the bug you are
> fixing only triggers in the presence of PMDs. The

Right.

> CONFIG_FS_DAX_LIMITED=y case can still use the current "page-less"
> mkclean path for PTEs.

But I think introducing pfn_mkclean_range() could make the code
simple and easy to maintain here since it could handle both PTE
and PMD mappings.  And page_vma_mapped_walk() could work
on PFNs since commit [1], which is the case here, we do not need
extra code to handle the page-less case here.  What do you
think?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=b786e44a4dbfe64476e7120ec7990b89a37be37d

