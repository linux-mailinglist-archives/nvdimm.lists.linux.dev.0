Return-Path: <nvdimm+bounces-1316-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AAA140CDEB
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Sep 2021 22:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 8A8951C0F32
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Sep 2021 20:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3B26D13;
	Wed, 15 Sep 2021 20:28:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352393FC9
	for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 20:27:59 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id f21so2369927plb.4
        for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 13:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8j9nsjhP2CcVqLcJ5koWV2E4sy0xlWdjoLtmRXdgCg=;
        b=jkup3/kcPwTReHA24WpMPddFFrhMEhKMphFyQO1XPxmIVWkkYHxUkdqyGZsSDwO6Th
         gcGHfPoTptuJ+dxjHSb3ODGGRst4zTjhrQfEc+pp1qiZCIlixdwtrfkVnC5HqGNgIlWU
         oetU8cus/vZuKTzJTw3r0JBrbFVcZ9sDDGNuPOexdqEPud/eOsmN0PAvogegnnY8IsGK
         4+C7S6Ab74wIZ4wMt0ZEyudDwwxIjtjAbqt33tQqjngfZqo7JObEEhk5FtqmM6JBOr6k
         XEmGhLwciJVvzzmDGsiU9CyL8oIDvis9stbORqZvLTP/eDpMjSXJ+ggpmoIrp4Dzr/b4
         CggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8j9nsjhP2CcVqLcJ5koWV2E4sy0xlWdjoLtmRXdgCg=;
        b=F4dlfFOiBLafM88TprfJs84VfjBRtn3KqWF7I6RJqxb+4XHhecWyNqN4cBF6XHkhlK
         AF3ALVbrSw8uXLItBKxZ0n/n8FdcYB+b7swFSnU95itKdJ/uJVA6FMNC7HYI1BhiyYtT
         Uvl+Sl5RjaCGSfYQ0heHsI+7VPRsPBFr3jR1Yd3WnAvl0a+pbT40qghsDFdO49KOjp3H
         QaH0a/uTIggzzQFYHv7W+pQEd9LsjsrwEcI6wdgo/uES25S//SSBgyfy683nkrql0uH/
         jUVDZw3CrLqL++UpMf628/6Dfh+wxxrznjUqhz7xB9k3ymoIpa7FzBGSL9WK59qBH4eq
         xuOw==
X-Gm-Message-State: AOAM531JqcDL865GNHx5Hk4xgFTkrtKbpLWkaxrzfQLqMqTCq4Y3qAfY
	RDMeOXTB/N6w2pgNRvWjkgbsAf4SCcix/c/FnH0X+Q==
X-Google-Smtp-Source: ABdhPJxdbwsiNFAPFJzgMiZUrKLnJg5JYCGH4ScDO+XBYA8/7hWrT+jQ4CgyR0FRoleB5jMwSOTL7HpsnFFgji7O8XY=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr1684157pjb.93.1631737678623;
 Wed, 15 Sep 2021 13:27:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210914233132.3680546-1-jane.chu@oracle.com> <CAPcyv4h3KpOKgy_Cwi5fNBZmR=n1hB33mVzA3fqOY7c3G+GrMA@mail.gmail.com>
 <516ecedc-38b9-1ae3-a784-289a30e5f6df@oracle.com> <20210915161510.GA34830@magnolia>
In-Reply-To: <20210915161510.GA34830@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Sep 2021 13:27:47 -0700
Message-ID: <CAPcyv4jaCiSXU61gsQTaoN_cdDTDMvFSfMYfBz2yLKx11fdwOQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] dax: clear poison on the fly along pwrite
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 15, 2021 at 9:15 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Sep 15, 2021 at 12:22:05AM -0700, Jane Chu wrote:
> > Hi, Dan,
> >
> > On 9/14/2021 9:44 PM, Dan Williams wrote:
> > > On Tue, Sep 14, 2021 at 4:32 PM Jane Chu <jane.chu@oracle.com> wrote:
> > > >
> > > > If pwrite(2) encounters poison in a pmem range, it fails with EIO.
> > > > This is unecessary if hardware is capable of clearing the poison.
> > > >
> > > > Though not all dax backend hardware has the capability of clearing
> > > > poison on the fly, but dax backed by Intel DCPMEM has such capability,
> > > > and it's desirable to, first, speed up repairing by means of it;
> > > > second, maintain backend continuity instead of fragmenting it in
> > > > search for clean blocks.
> > > >
> > > > Jane Chu (3):
> > > >    dax: introduce dax_operation dax_clear_poison
> > >
> > > The problem with new dax operations is that they need to be plumbed
> > > not only through fsdax and pmem, but also through device-mapper.
> > >
> > > In this case I think we're already covered by dax_zero_page_range().
> > > That will ultimately trigger pmem_clear_poison() and it is routed
> > > through device-mapper properly.
> > >
> > > Can you clarify why the existing dax_zero_page_range() is not sufficient?
> >
> > fallocate ZERO_RANGE is in itself a functionality that applied to dax
> > should lead to zero out the media range.  So one may argue it is part
> > of a block operations, and not something explicitly aimed at clearing
> > poison.
>
> Yeah, Christoph suggested that we make the clearing operation explicit
> in a related thread a few weeks ago:
> https://lore.kernel.org/linux-fsdevel/YRtnlPERHfMZ23Tr@infradead.org/

That seemed to be tied to a proposal to plumb it all the way out to an
explicit fallocate() mode, not make it a silent side effect of
pwrite(). That said pwrite() does clear errors in hard drives in
not-DAX mode, but I like the change in direction to make it explicit
going forward.

> I like Jane's patchset far better than the one that I sent, because it
> doesn't require a block device wrapper for the pmem, and it enables us
> to tell application writers that they can handle media errors by
> pwrite()ing the bad region, just like they do for nvme and spinners.

pwrite(), hmm, so you're not onboard with the explicit clearing API
proposal, or...?

> > I'm also thinking about the MOVEDIR64B instruction and how it
> > might be used to clear poison on the fly with a single 'store'.
> > Of course, that means we need to figure out how to narrow down the
> > error blast radius first.

It turns out the MOVDIR64B error clearing idea runs into problem with
the device poison tracking. Without the explicit notification that
software wanted the error cleared the device may ghost report errors
that are not there anymore. I think we should continue explicit error
clearing and notification of the device that the error has been
cleared (by asking the device to clear it).

> That was one of the advantages of Shiyang Ruan's NAKed patchset to
> enable byte-granularity media errors

...the method of triggering reverse mapping had review feedback, I
apologize if that came across of a NAK of the whole proposal. As I
clarified to Eric this morning, I think the solution is iterating
towards upstream inclusion.

> to pass upwards through the stack
> back to the filesystem, which could then tell applications exactly what
> they lost.
>
> I want to get back to that, though if Dan won't withdraw the NAK then I
> don't know how to move forward...

No NAK in place. Let's go!

>
> > With respect to plumbing through device-mapper, I thought about that,
> > and wasn't sure. I mean the clear-poison work will eventually fall on
> > the pmem driver, and thru the DM layers, how does that play out thru
> > DM?
>
> Each of the dm drivers has to add their own ->clear_poison operation
> that remaps the incoming (sector, len) parameters as appropriate for
> that device and then calls the lower device's ->clear_poison with the
> translated parameters.
>
> This (AFAICT) has already been done for dax_zero_page_range, so I sense
> that Dan is trying to save you a bunch of code plumbing work by nudging
> you towards doing s/dax_clear_poison/dax_zero_page_range/ to this series
> and then you only need patches 2-3.

Yes, but it sounds like Christoph was saying don't overload
dax_zero_page_range(). I'd be ok splitting the difference and having a
new fallocate clear poison mode map to dax_zero_page_range()
internally.

>
> > BTW, our customer doesn't care about creating dax volume thru DM, so.
>
> They might not care, but anything going upstream should work in the
> general case.

Agree.

