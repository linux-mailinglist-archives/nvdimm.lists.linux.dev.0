Return-Path: <nvdimm+bounces-1798-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAEE444EC9
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 07:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id D93FB3E102C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 06:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D742F2C9D;
	Thu,  4 Nov 2021 06:21:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6DE2C96
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 06:21:50 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id v20so5568055plo.7
        for <nvdimm@lists.linux.dev>; Wed, 03 Nov 2021 23:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZyuA6ddRdNnvNpvSUsN4hZr4Uf2uGmRKXvml9zPHv3U=;
        b=LZQMkMEgCvdpUn1y3IGr6TRctr3Q9zUor3iSBVXWEwdAP54SnFBy+WF/4Ebp9InWiZ
         82EJ07KkJqO1IXAjeb5tQuOwY1ckueHAnmH/o6R5PLxqRYs7VaaskeCn1nugf4y2mqcY
         E6yt7u/txZYD8jXP/DpSBx32wbdzRNzBp4YXA0WR06xzBm2Tz82m9R7MZkgsmA0yPcMZ
         ToDGBKl9+nZ9SgaoC7yR0jgPCp3Cx6s1akPqKynUiynPbM1vR9RHDbsWDBq4+aqq/5sp
         U+yyphazc5dywiF0swD7YL24mIehmRIY8zog0Mlsw1WKup+EjujksqX34ab7rjp8ivql
         LdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZyuA6ddRdNnvNpvSUsN4hZr4Uf2uGmRKXvml9zPHv3U=;
        b=ClTMT/kpIE7XXjCoevbtYwEnRLVyqeUto8UpToQqMS8ef1bzgcs+oGGtfvyHSifjwi
         u0awJPYC3zKOi8ijCtLLnr8GOXgZvJvUYdqW9JihHNGRQ7OjImYF7F+dNdvMPDDmkUtp
         MwtDc0xxPDb6sA4G2RBT+GUuh/KCd2KurS4wILCsvDPAtZVrxG0Kh24fqqShk6yaXyWL
         Idvxr+5feDFxrOv4r8bu7pIEUiHH6PmoAYBieONiSNe8kh7LwE5QTKQXIyFS03WF9LvP
         SgYNm35+lB0sVsoEMWbDPcqGOi9kzu6vJ3Pnqb6G5inBm4ZImmgpLAlsLcu4/JbxSKZd
         Gswg==
X-Gm-Message-State: AOAM53018UMGgbuT1LdfRCqPZItUgOlxvcDR0YoyzWPNaeO++ybL1XS8
	o8ypZRoGSSv9MHxLaog/gWXhsHmDWMcIm4Y4ZhimRQ==
X-Google-Smtp-Source: ABdhPJx4n/3hi5QSqYsscdoJBCM1f/g8m0p4vAuABjz6+mE+bZ+8hWcuD6Y6gRvy3XYJHICi5mkaZySCeaB3JPBO+/Q=
X-Received: by 2002:a17:90a:6c47:: with SMTP id x65mr3577541pjj.8.1636006910291;
 Wed, 03 Nov 2021 23:21:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com> <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com> <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com> <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia> <YYDYUCCiEPXhZEw0@infradead.org> <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
In-Reply-To: <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Nov 2021 23:21:39 -0700
Message-ID: <CAPcyv4jLn4_SYxLtp_cUT=mm6Y3An22BA+sqex1S-CBnAm6qGA@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA flag
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	"david@fromorbit.com" <david@fromorbit.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "agk@redhat.com" <agk@redhat.com>, 
	"snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"vgoyal@redhat.com" <vgoyal@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 3, 2021 at 11:10 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/1/2021 11:18 PM, Christoph Hellwig wrote:
> > On Wed, Oct 27, 2021 at 05:24:51PM -0700, Darrick J. Wong wrote:
> >> ...so would you happen to know if anyone's working on solving this
> >> problem for us by putting the memory controller in charge of dealing
> >> with media errors?
> >
> > The only one who could know is Intel..
> >
> >> The trouble is, we really /do/ want to be able to (re)write the failed
> >> area, and we probably want to try to read whatever we can.  Those are
> >> reads and writes, not {pre,f}allocation activities.  This is where Dave
> >> and I arrived at a month ago.
> >>
> >> Unless you'd be ok with a second IO path for recovery where we're
> >> allowed to be slow?  That would probably have the same user interface
> >> flag, just a different path into the pmem driver.
> >
> > Which is fine with me.  If you look at the API here we do have the
> > RWF_ API, which them maps to the IOMAP API, which maps to the DAX_
> > API which then gets special casing over three methods.
> >
> > And while Pavel pointed out that he and Jens are now optimizing for
> > single branches like this.  I think this actually is silly and it is
> > not my point.
> >
> > The point is that the DAX in-kernel API is a mess, and before we make
> > it even worse we need to sort it first.  What is directly relevant
> > here is that the copy_from_iter and copy_to_iter APIs do not make
> > sense.  Most of the DAX API is based around getting a memory mapping
> > using ->direct_access, it is just the read/write path which is a slow
> > path that actually uses this.  I have a very WIP patch series to try
> > to sort this out here:
> >
> > http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> >
> > But back to this series.  The basic DAX model is that the callers gets a
> > memory mapping an just works on that, maybe calling a sync after a write
> > in a few cases.  So any kind of recovery really needs to be able to
> > work with that model as going forward the copy_to/from_iter path will
> > be used less and less.  i.e. file systems can and should use
> > direct_access directly instead of using the block layer implementation
> > in the pmem driver.  As an example the dm-writecache driver, the pending
> > bcache nvdimm support and the (horribly and out of tree) nova file systems
> > won't even use this path.  We need to find a way to support recovery
> > for them.  And overloading it over the read/write path which is not
> > the main path for DAX, but the absolutely fast path for 99% of the
> > kernel users is a horrible idea.
> >
> > So how can we work around the horrible nvdimm design for data recovery
> > in a way that:
> >
> >     a) actually works with the intended direct memory map use case
> >     b) doesn't really affect the normal kernel too much
> >
> > ?
> >
>
> This is clearer, I've looked at your 'dax-devirtualize' patch which
> removes pmem_copy_to/from_iter, and as you mentioned before,
> a separate API for poison-clearing is needed. So how about I go ahead
> rebase my earlier patch
>
> https://lore.kernel.org/lkml/20210914233132.3680546-2-jane.chu@oracle.com/
> on 'dax-devirtualize', provide dm support for clear-poison?
> That way, the non-dax 99% of the pwrite use-cases aren't impacted at all
> and we resolve the urgent pmem poison-clearing issue?
>
> Dan, are you okay with this?  I am getting pressure from our customers
> who are basically stuck at the moment.

The concern I have with dax_clear_poison() is that it precludes atomic
error clearing. Also, as Boris and I discussed, poisoned pages should
be marked NP (not present) rather than UC (uncacheable) [1]. With
those 2 properties combined I think that wants a custom pmem fault
handler that knows how to carefully write to pmem pages with poison
present, rather than an additional explicit dax-operation. That also
meets Christoph's requirement of "works with the intended direct
memory map use case".

[1]: https://lore.kernel.org/r/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com

