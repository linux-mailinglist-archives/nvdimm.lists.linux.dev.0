Return-Path: <nvdimm+bounces-1779-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC43B44326C
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Nov 2021 17:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id D046C3E0F69
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Nov 2021 16:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79962C9C;
	Tue,  2 Nov 2021 16:13:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42172C85
	for <nvdimm@lists.linux.dev>; Tue,  2 Nov 2021 16:12:59 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id v20so17016440plo.7
        for <nvdimm@lists.linux.dev>; Tue, 02 Nov 2021 09:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pIALiqswCfSwk+/MEarCA9yLgBnLpJVqWRaUmM6jp5w=;
        b=YDMPEv8WJX5C5t8J+KvkqjymPpcW6bISPU13EEZn9i3ppfDrXqCBOkIiZ+qG6d/0W9
         oMQLSczBNDPwvPGAeBCQCFCpFym+2LBzFX/2J1emFCX8/PiT0sSrN/EKaU5MKnn4a0Kp
         2TPNyYUqhhBEvMdCFQyeipttIkdwn8Tm3bBSASjQz/q8pbYMW+PXgXDYQ9zDnbsNtNKj
         tEA+auAFo01awfsN/txIuLZzv2x3qAeCbidvO2qL7Rnrtfwe8Rz+IyyDyOLljZkYawzP
         JPuyPodJwGTYZZ1N8kC66Kge83QF/+vX/h8zKe7PGTocddZq4FaAT4hFeKM3Pxy/O7TW
         pClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pIALiqswCfSwk+/MEarCA9yLgBnLpJVqWRaUmM6jp5w=;
        b=2CLcCO4gpMoDbWHwg7POL09IqUw0uW3NitH8Lq+/lqy83Gq6ZzIK+GG/OoxbyYulTd
         c1WadceYePPKOkDofDZztYXhTaB0UNHUOA203I0et+XNEso5720MN8P/GaoZrb7/eEh0
         kUBrkMPoSrRInflRM//EYpwJ9oU5MOBL3bJ0omBrr9kMnZrne9s2s97ytEcEWYNMfNwI
         NrEmi9mG2A2NtnSjZuXy24WXKYmvhBY68aI8clgWh7d+NZA7patab5gDu6wJDGQggdxC
         GsyyG+z67VhCcIJtsxPfcLC914SMsuM2dmJ10UpbOMUa+kbMluEMJ3O7thL1K8ZzeX4D
         mcvg==
X-Gm-Message-State: AOAM531clwEzPMrMyjTD2riJLOUvwOuWNIpE7GjS4wcW/mGWcrzyu/kJ
	36wp83wSKkudj5/IutznMAWTaLTL7eF7TwnuXluaB8Q0qRA=
X-Google-Smtp-Source: ABdhPJyUerhRmPa3p6Y+5F6zaaUU9FmrqYmMRvdoPUtNZXczvAj1BoJWZcyxx8lp/uHInRyxjBoZleDZuAuNEyTgQ/Q=
X-Received: by 2002:a17:902:ab50:b0:13f:4c70:9322 with SMTP id
 ij16-20020a170902ab5000b0013f4c709322mr32351492plb.89.1635869579139; Tue, 02
 Nov 2021 09:12:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com> <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com> <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com> <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
In-Reply-To: <20211028002451.GB2237511@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 09:12:48 -0700
Message-ID: <CAPcyv4ge8ebFn2tBtc9_ThEYXjCczLW4H8NYrOJKbGF_Y-Wg5w@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA flag
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
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

On Wed, Oct 27, 2021 at 5:25 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Oct 26, 2021 at 11:49:59PM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 22, 2021 at 08:52:55PM +0000, Jane Chu wrote:
> > > Thanks - I try to be honest.  As far as I can tell, the argument
> > > about the flag is a philosophical argument between two views.
> > > One view assumes design based on perfect hardware, and media error
> > > belongs to the category of brokenness. Another view sees media
> > > error as a build-in hardware component and make design to include
> > > dealing with such errors.
> >
> > No, I don't think so.  Bit errors do happen in all media, which is
> > why devices are built to handle them.  It is just the Intel-style
> > pmem interface to handle them which is completely broken.
>
> Yeah, I agree, this takes me back to learning how to use DISKEDIT to
> work around a hole punched in a file (with a pen!) in the 1980s...
>
> ...so would you happen to know if anyone's working on solving this
> problem for us by putting the memory controller in charge of dealing
> with media errors?

What are you guys going on about? ECC memory corrects single-bit
errors in the background, multi-bit errors cause the memory controller
to signal that data is gone. This is how ECC memory has worked since
forever. Typically the kernel's memory-failure path is just throwing
away pages that signal data loss. Throwing away pmem pages is harder
because unlike DRAM the physical address of the page matters to upper
layers.

>
> > > errors in mind from start.  I guess I'm trying to articulate why
> > > it is acceptable to include the RWF_DATA_RECOVERY flag to the
> > > existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
> > > and its slow path (w/ error clearing) is faster than other alternative.
> > > Other alternative being 1 system call to clear the poison, and
> > > another system call to run the fast pwrite for recovery, what
> > > happens if something happened in between?
> >
> > Well, my point is doing recovery from bit errors is by definition not
> > the fast path.  Which is why I'd rather keep it away from the pmem
> > read/write fast path, which also happens to be the (much more important)
> > non-pmem read/write path.
>
> The trouble is, we really /do/ want to be able to (re)write the failed
> area, and we probably want to try to read whatever we can.  Those are
> reads and writes, not {pre,f}allocation activities.  This is where Dave
> and I arrived at a month ago.
>
> Unless you'd be ok with a second IO path for recovery where we're
> allowed to be slow?  That would probably have the same user interface
> flag, just a different path into the pmem driver.
>
> Ha, how about a int fd2 = recoveryfd(fd); call where you'd get whatever
> speshul options (retry raid mirrors!  scrape the film off the disk if
> you have to!) you want that can take forever, leaving the fast paths
> alone?

I am still failing to see the technical argument for why
RWF_RECOVER_DATA significantly impacts the fast path, and why you
think this is somehow specific to pmem. In fact the pmem effort is
doing the responsible thing and trying to plumb this path while other
storage drivers just seem to be pretending that memory errors never
happen.

