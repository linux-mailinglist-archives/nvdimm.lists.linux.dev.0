Return-Path: <nvdimm+bounces-1808-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B12445741
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 17:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 6F5CD1C0F1C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 16:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00E22C9A;
	Thu,  4 Nov 2021 16:24:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA12C96
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 16:24:26 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id s24so8156104plp.0
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=17E90qbU5W7/llxpq3Ci8EoglXdbUk5GXT8DWrgKv7g=;
        b=IixOukDCcm4ELNAVAqZJOzjCnk7lf/rubLWVOcE22LZa0xZSiAdpMolR6PT3OzDS8O
         xxSwYI1rX7ktQP0XAhmwHg7GDdsMJbBO87vLYpaLkvcwsFzTpFGmXBD9dJTfeFEr1SHF
         V+1M9t+oBfFghrhHaXrwhgKdVFerg6POaWfHnBHWtK/UL+Zc8pxxDwgno9Rcj3+Z8bQD
         4r/c9eeLKiXP8gHsf6pqcnjjtlsq5INYEBSwpziM2AGC6KZtzWSQBd2NT2qrotdNHWYz
         jL6HR1mv4YE/boLKmF0q2n/sOuVp/sbEG+nF2AgX9M5OQJ+cJvgMO9ZUs743sJBXcjy9
         jBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=17E90qbU5W7/llxpq3Ci8EoglXdbUk5GXT8DWrgKv7g=;
        b=hGW/vAcokYipGCIn++mpADGchRx4khSsJWjy9mh0nmfquIlHGzPOE6o3cDTLxiUG52
         UTWcTpux1Qb0gQ6llgmi2f/t185VTp35OjJjR8D9YO+A9ddIIAb+BycUKB3CvPJcBMR0
         jDZsof9/5cySDTaou4Op7fFQwV81EFiFH1Cvf+jUoVsTwEDQb3r2nVCFhiwePEASYmNn
         myamEXuFYaoqGDrGPG+wd/3w6RWhJUNJAc4xgXvNrIR9R2W7DEnQMtFaY5O4n8fUTu03
         mRoctXYEEpOdwiUgN6odZ67PxIsQfgCNLEVnLWCxB6/U7y41u6WRGU1JEyiiEk8QIKvE
         Y2Lw==
X-Gm-Message-State: AOAM531SBYJDUP+BGbPKWoz69hwB4wFk1DASzlusRNoolWym+sBZBTzI
	iyO4mk6FGmTjgw6Rfv3qItEnii2R2KEYxD4GF43fpQ==
X-Google-Smtp-Source: ABdhPJz79hh1l18OCSZbTUbHDcomJJsoh+bGEXb1lR6JlCXHe3pvv2Bi88QyyGqo6h13ZG3HRQJzFRzDQ7aERKx7/AU=
X-Received: by 2002:a17:90a:6c47:: with SMTP id x65mr6908694pjj.8.1636043065868;
 Thu, 04 Nov 2021 09:24:25 -0700 (PDT)
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
 <YYOaOBKgFQYzT/s/@infradead.org>
In-Reply-To: <YYOaOBKgFQYzT/s/@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 09:24:15 -0700
Message-ID: <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA flag
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Jane Chu <jane.chu@oracle.com>, 
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

On Thu, Nov 4, 2021 at 1:30 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Nov 03, 2021 at 01:33:58PM -0700, Dan Williams wrote:
> > Is the exception table requirement not already fulfilled by:
> >
> > sigaction(SIGBUS, &act, 0);
> > ...
> > if (sigsetjmp(sj_env, 1)) {
> > ...
> >
> > ...but yes, that's awkward when all you want is an error return from a
> > copy operation.
>
> Yeah.  The nice thing about the kernel uaccess / _nofault helpers is
> that they allow normal error handling flows.
>
> > For _nofault I'll note that on the kernel side Linus was explicit
> > about not mixing fault handling and memory error exception handling in
> > the same accessor. That's why copy_mc_to_kernel() and
> > copy_{to,from}_kernel_nofault() are distinct.
>
> I've always wondered why we need all this mess.  But if the head
> penguin wants it..
>
> > I only say that to probe
> > deeper about what a "copy_mc()" looks like in userspace? Perhaps an
> > interface to suppress SIGBUS generation and register a ring buffer
> > that gets filled with error-event records encountered over a given
> > MMAP I/O code sequence?
>
> Well, the equivalent to the kernel uaccess model would be to register
> a SIGBUS handler that uses an exception table like the kernel, and then
> if you use the right helpers to load/store they can return errors.
>
> The other option would be something more like the Windows Structured
> Exception Handling:
>
> https://docs.microsoft.com/en-us/cpp/cpp/structured-exception-handling-c-cpp?view=msvc-160

Yes, try-catch blocks for PMEM is what is needed if it's not there
already from PMDK. Searching for SIGBUS in PMDK finds things like:

https://github.com/pmem/pmdk/blob/26449a51a86861db17feabdfefaa5ee4d5afabc9/src/libpmem2/mcsafe_ops_posix.c

>
>
> > > I think you misunderstood me.  I don't think pmem needs to be
> > > decoupled from the read/write path.  But I'm very skeptical of adding
> > > a new flag to the common read/write path for the special workaround
> > > that a plain old write will not actually clear errors unlike every
> > > other store interfac.
> >
> > Ah, ok, yes, I agree with you there that needing to redirect writes to
> > a platform firmware call to clear errors, and notify the device that
> > its error-list has changed is exceedingly awkward.
>
> Yes.  And that is the big difference to every other modern storage
> device.  SSDs always write out of place and will just not reuse bad
> blocks, and all drivers built in the last 25-30 years will also do
> internal bad block remapping.
>

No, the big difference with every other modern storage device is
access to byte-addressable storage. Storage devices get to "cheat"
with guaranteed minimum 512-byte accesses. So you can arrange for
writes to always be large enough to scrub the ECC bits along with the
data. For PMEM and byte-granularity DAX accesses the "sector size" is
a cacheline and it needed a new CPU instruction before software could
atomically update data + ECC. Otherwise, with sub-cacheline accesses,
a RMW cycle can't always be avoided. Such a cycle pulls poison from
the device on the read and pushes it back out to the media on the
cacheline writeback.

> > That said, even if
> > the device-side error-list auto-updated on write (like the promise of
> > MOVDIR64B) there's still the question about when to do management on
> > the software error lists in the driver and/or filesytem. I.e. given
> > that XFS at least wants to be aware of the error lists for block
> > allocation and "list errors" type features. More below...
>
> Well, the whole problem is that we should not have to manage this at
> all, and this is where I blame Intel.  There is no good reason to not
> slightly overprovision the nvdimms and just do internal bad page
> remapping like every other modern storage device.

I don't understand what overprovisioning has to do with better error
management? No other storage device has seen fit to be as transparent
with communicating the error list and offering ways to proactively
scrub it. Dave and Darrick rightly saw this and said "hey, the FS
could do a much better job for the user if it knew about this error
list". So I don't get what this argument about spare blocks has to do
with what XFS wants? I.e. an rmap facility to communicate files that
have been clobbered by cosmic rays and other calamities.

> > Hasn't this been a perennial topic at LSF/MM, i.e. how to get an
> > interface for the filesystem to request "try harder" to return data?
>
> Trying harder to _get_ data or to _store_ data?  All the discussion
> here seems to be able about actually writing data.
>
> > If the device has a recovery slow-path, or error tracking granularity
> > is smaller than the I/O size, then RWF_RECOVER_DATA gives the
> > device/driver leeway to do better than the typical fast path. For
> > writes though, I can only come up with the use case of this being a
> > signal to the driver to take the opportunity to do error-list
> > management relative to the incoming write data.
>
> Well, while devices have data recovery slow path they tend to use those
> automatically.  What I'm actually seeing in practice is flags in the
> storage interfaces to skip this slow path recovery because the higher
> level software would prefer to instead recover e.g. from remote copies.

Ok.

> > However, if signaling that "now is the time to update error-lists" is
> > the requirement, I imagine the @kaddr returned from
> > dax_direct_access() could be made to point to an unmapped address
> > representing the poisoned page. Then, arrange for a pmem-driver fault
> > handler to emulate the copy operation and do the slow path updates
> > that would otherwise have been gated by RWF_RECOVER_DATA.
>
> That does sound like a much better interface than most of what we've
> discussed so far.
>
> > Although, I'm not excited about teaching every PMEM arch's fault
> > handler about this new source of kernel faults. Other ideas?
> > RWF_RECOVER_DATA still seems the most viable / cleanest option, but
> > I'm willing to do what it takes to move this error management
> > capability forward.
>
> So far out of the low instrusiveness options Janes' previous series
> to automatically retry after calling a clear_poison operation seems
> like the best idea so far.  We just need to also think about what
> we want to do for direct users of ->direct_access that do not use
> the mcsafe iov_iter helpers.

Those exist? Even dm-writecache uses copy_mc_to_kernel().

