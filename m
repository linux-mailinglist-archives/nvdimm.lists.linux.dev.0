Return-Path: <nvdimm+bounces-3306-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 614B74D5E0F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Mar 2022 10:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 20EB33E0F66
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Mar 2022 09:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADE62598;
	Fri, 11 Mar 2022 09:05:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8FE7E
	for <nvdimm@lists.linux.dev>; Fri, 11 Mar 2022 09:05:53 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id u61so15906725ybi.11
        for <nvdimm@lists.linux.dev>; Fri, 11 Mar 2022 01:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m4uZHfd5TEknERkFPf+I/joPh8Butuy4Qgst4A1Cqjw=;
        b=pF6htef8BElDLh5mKnFuCbURvy+T/DgtLXd1OrtoV5iZB/kuFmt74asVUCwjaEiP1W
         VvVb0/uyuvzAHsaOwfvAPUbNjLLi/4O+SisK77Z/w6dLGflRJWAcnwFg8SMYxuEzUtm9
         Kn0yMKbWtwRnmtRjIb/fgaiA5s9Zib6MbM6LijkloeJGFeDoxalPAyalbbC5Vvm4edYz
         fKO5lHEqYrZVhfKCrzgSemS8X69xLKp4tDnuTSv1x4AULBBK4IQkDR+YI9t12YnNKIli
         OXfoMRM7zpWFlX+2+hnO36gI1Xv1n89u0KcNlYLC4ioZEqwTkHNfcCLxhOk5rKKtlYoP
         icDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m4uZHfd5TEknERkFPf+I/joPh8Butuy4Qgst4A1Cqjw=;
        b=X3t3PRzXgrTUOxihwGi5MhyPMdaXZVKFD2KcpFey4g9002QW52SSWv96ZbxIFSho+1
         6Rd/i5l4/E8WjiSswmRNRIr1jeUrNO6FRF53Ml2zOTOyz+v9lRDFQv803QyUqM5esyPZ
         T5Gu+Ok9lkGfsZIGbqvK+HDcZC1ZAmff//d4akGc3ZSU9vd8aFr7UGpd9DUNxKY19yuV
         PRnI6uOcVHgREhiXVSLua791VauAtolh5qwxFpzNpN9vfRmHndkPn3Ds2FviPQ1UXz4j
         Q4p/W4HVBY224CVyWlTAncJ3uAC0SuYA/LyYm31RdZ7VLrXFT6c3jpwdMETQ4vT5LUW9
         hljw==
X-Gm-Message-State: AOAM531ov/sOQ4oe0/AAJQwLogguLkY0TwQyUAeQTWF6nJRrjiLhjgjA
	wWfFt9xFgJB7q2V0t6dU9cYPK4P6ReYbU/VQt4Eo2w==
X-Google-Smtp-Source: ABdhPJw9qo6/6qA17qt3SommKl5Kt2eGwf1GjUaS4QRzcq/DenqfvaHGIbgh5aqK7drz/IJ4KLgY2d7lQMruWIN46Do=
X-Received: by 2002:a25:d188:0:b0:628:ba86:ee68 with SMTP id
 i130-20020a25d188000000b00628ba86ee68mr7040760ybg.427.1646989552644; Fri, 11
 Mar 2022 01:05:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com>
 <20220302082718.32268-6-songmuchun@bytedance.com> <CAPcyv4hsMWe1AreVVhGJD-St3FGtGBMeA-BX7XbA_kVX97tw4Q@mail.gmail.com>
In-Reply-To: <CAPcyv4hsMWe1AreVVhGJD-St3FGtGBMeA-BX7XbA_kVX97tw4Q@mail.gmail.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 11 Mar 2022 17:04:06 +0800
Message-ID: <CAMZfGtUmhcryboPdRC7ZhWVuV3TX0rLcKUxhvamAGbHUoATaow@mail.gmail.com>
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

On Thu, Mar 10, 2022 at 8:59 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Mar 2, 2022 at 12:30 AM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > Currently dax_mapping_entry_mkclean() fails to clean and write protect
> > the pte entry within a DAX PMD entry during an *sync operation. This
> > can result in data loss in the following sequence:
> >
> >   1) process A mmap write to DAX PMD, dirtying PMD radix tree entry and
> >      making the pmd entry dirty and writeable.
> >   2) process B mmap with the @offset (e.g. 4K) and @length (e.g. 4K)
> >      write to the same file, dirtying PMD radix tree entry (already
> >      done in 1)) and making the pte entry dirty and writeable.
> >   3) fsync, flushing out PMD data and cleaning the radix tree entry. We
> >      currently fail to mark the pte entry as clean and write protected
> >      since the vma of process B is not covered in dax_entry_mkclean().
> >   4) process B writes to the pte. These don't cause any page faults since
> >      the pte entry is dirty and writeable. The radix tree entry remains
> >      clean.
> >   5) fsync, which fails to flush the dirty PMD data because the radix tree
> >      entry was clean.
> >   6) crash - dirty data that should have been fsync'd as part of 5) could
> >      still have been in the processor cache, and is lost.
>
> Excellent description.
>
> >
> > Just to use pfn_mkclean_range() to clean the pfns to fix this issue.
>
> So the original motivation for CONFIG_FS_DAX_LIMITED was for archs
> that do not have spare PTE bits to indicate pmd_devmap(). So this fix
> can only work in the CONFIG_FS_DAX_LIMITED=n case and in that case it
> seems you can use the current page_mkclean_one(), right?

I don't know the history of CONFIG_FS_DAX_LIMITED.
page_mkclean_one() need a struct page associated with
the pfn,  do the struct pages exist when CONFIG_FS_DAX_LIMITED
and ! FS_DAX_PMD? If yes, I think you are right. But I don't
see this guarantee. I am not familiar with DAX code, so what am
I missing here?

Thanks.

