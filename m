Return-Path: <nvdimm+bounces-1824-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id B6EAF445A1E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 20:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C590E1C0BED
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 19:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC3F2C9C;
	Thu,  4 Nov 2021 19:00:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF5D2C99
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 19:00:24 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id b13so8850010plg.2
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 12:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2k2ICcLxOkYpmYgks+aaOogS3Up01M0dUCMOamz1iE=;
        b=qztWzrOTLAIveH0jJT+My1lV60S9NBBuoZGvf3bT2cCiy1amPUVAOa8U4/K7xanNV1
         YhcFxVjtQd99EYpqKdvI2mpDLpo+IvoLQgmSfd36JPAmmGu0GSgIsg2c1k9wjL6Aw7IP
         v1+p7NJ2mn9mi1aSVMCmwnvf4Fvyss5eFxhoctfmhjUwls1GCBfLPg70Z6rCNN1KO8Vu
         UvcWJhXZOeNfxNXqMEDF+7ZbG4T8H2agXRtokUhs6BkR1P2QmLirhzwnP4wYxDFRiLXX
         uwbk3uQPR7MTMgd6i+sYQ0CN2HEBqUy40NqhvSGBIyc3xJ4NHnjlDR1x0j7rKg4WON2B
         OhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2k2ICcLxOkYpmYgks+aaOogS3Up01M0dUCMOamz1iE=;
        b=5oVIKPtLO7cB4tDX6rYYvlY/gDZNhJyUsMeu9otws2jP6S+DeJlCnVOf1Zkjk3gXXj
         CueI0SyJ0TsHvCUzaE7vHlgYxzvwpj0ascrhGTNRMutKqJu0jLqkK4P4/9smQaG+QKqh
         x75Wv/VnBES87/TSqAI+I04iLHJ9UaKewB6k8hlZIMTCXYzXD4EZYbSeXOjh5ibsr3VK
         skhE6zJO0iXDUuBY8ejq9vqmgjeUFxS7P2nCMwh2kVYAwx7nNuwFhjhlp+e2J+R9XZQd
         4GnCfv1153vfVLhyxPxfG60XwIqc4ixc4F8gHk+6fWw+jVEBL+HccXMnam/FfMFA7q0P
         nLgg==
X-Gm-Message-State: AOAM530SqnPUnpafUsnwOIZN5DDvXdAHJhzWgqrx/9Jr23N+JACGeto+
	NCMUNUEJmBoWeWJygfr40O5PCj0zGcIgrnz4ZRXg0A==
X-Google-Smtp-Source: ABdhPJwQym6Y7uH09wOtDHKQhWIGrrYFIdBGyf7hiTeaJPAQpu4wAVAeAWHgNrP0Q55EM48GJgoNm4KYD5+8BlLUEcA=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr1444333pjb.220.1636052423615;
 Thu, 04 Nov 2021 12:00:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YXFPfEGjoUaajjL4@infradead.org> <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org> <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org> <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
 <YYK/tGfpG0CnVIO4@infradead.org> <CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
 <YYOaOBKgFQYzT/s/@infradead.org> <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
 <6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com>
In-Reply-To: <6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 12:00:12 -0700
Message-ID: <CAPcyv4hJjcy2TnOv-Y5=MUMHeDdN-BCH4d0xC-pFGcHXEU_ZEw@mail.gmail.com>
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

On Thu, Nov 4, 2021 at 11:34 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> Thanks for the enlightening discussion here, it's so helpful!
>
> Please allow me to recap what I've caught up so far -
>
> 1. recovery write at page boundary due to NP setting in poisoned
>     page to prevent undesirable prefetching
> 2. single interface to perform 3 tasks:
>       { clear-poison, update error-list, write }
>     such as an API in pmem driver.
>     For CPUs that support MOVEDIR64B, the 'clear-poison' and 'write'
>     task can be combined (would need something different from the
>     existing _copy_mcsafe though) and 'update error-list' follows
>     closely behind;
>     For CPUs that rely on firmware call to clear posion, the existing
>     pmem_clear_poison() can be used, followed by the 'write' task.
> 3. if user isn't given RWF_RECOVERY_FLAG flag, then dax recovery
>     would be automatic for a write if range is page aligned;
>     otherwise, the write fails with EIO as usual.
>     Also, user mustn't have punched out the poisoned page in which
>     case poison repairing will be a lot more complicated.
> 4. desirable to fetch as much data as possible from a poisoned range.
>
> If this understanding is in the right direction, then I'd like to
> propose below changes to
>    dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
>    and the dm layer copy_to/from_iter, dax_iomap_iter().
>
> 1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
>     is likely media error: if the API without DAX_F_RECOVERY returns
>     -EIO, then switch to recovery-read/write code.  In recovery code,
>     supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
>     'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.

I like it. It allows for an atomic write+clear implementation on
capable platforms and coordinates with potentially unmapped pages. The
best of both worlds from the dax_clear_poison() proposal and my "take
a fault and do a slow-path copy".

> 2. the _copy_to/from_iter implementation would be largely the same
>     as in my recent patch, but some changes in Christoph's
>     'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
>     virtual devices don't have the ability to clear poison, so no need
>     to complicate them.  And this also means that not every endpoint
>     dax device has to provide dax_op.copy_to/from_iter, they may use the
>     default.

Did I miss this series or are you talking about this one?
https://lore.kernel.org/all/20211018044054.1779424-1-hch@lst.de/

> I'm not sure about nova and others, if they use different 'write' other
> than via iomap, does that mean there will be need for a new set of
> dax_op for their read/write?

No, they're out-of-tree they'll adjust to the same interface that xfs
and ext4 are using when/if they go upstream.

> the 3-in-1 binding would always be
> required though. Maybe that'll be an ongoing discussion?

Yeah, let's cross that bridge when we come to it.

> Comments? Suggestions?

It sounds great to me!

