Return-Path: <nvdimm+bounces-3453-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCDD4F8BD9
	for <lists+linux-nvdimm@lfdr.de>; Fri,  8 Apr 2022 03:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7DD3C1C09AA
	for <lists+linux-nvdimm@lfdr.de>; Fri,  8 Apr 2022 01:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDFD379;
	Fri,  8 Apr 2022 01:38:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E9A368
	for <nvdimm@lists.linux.dev>; Fri,  8 Apr 2022 01:38:17 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso8221090pjh.3
        for <nvdimm@lists.linux.dev>; Thu, 07 Apr 2022 18:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z4sY0ayTp/vh055DIkYLp+6K53mUbW2MVU3JridHXEo=;
        b=GlkX8JS2+O2TND3PKWQRDu67IA5ihu3sqlHNXgHStSouS+fez9JOmMeuT9dhVf1iGZ
         g6mZz/zyRTmvU7YTfzySSjqlcX3DTBxOhNqssrme6HaxS5QnfPtKZhRdDlda5PVj6EZi
         kPnjnXx5jLHB+y9POYhyeGdbfeH0nExOGtt9GIdXbRm1+79UNNu+fcUn4ku5Kn2jnjiJ
         tTpx9F3Y95JVfxGKUoV3/GHj+zoDWeeCp/0K5p62cCQ/CJvNHYE5MHGQUkgc4RQ4SkCl
         7DLYmY+fTpC/vro+F82G7ueaAzJZNGy2Xa4Me8xo3DWRFX1KY3TXazMpb9dODLBCmd9B
         NEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z4sY0ayTp/vh055DIkYLp+6K53mUbW2MVU3JridHXEo=;
        b=mGYQdzcj5L2qobjLFxiw4wCnjZO86kdVmWTM17cPkifv9rg2J8ZsschNfr7Qm0Ey3B
         OPqyHGmtQmKfqd9wl4o6TTkSvHiJVmjKkiix2GNEIOC+gVUQ4UMxM3RMl7ufG/+rP6r1
         1UYESCXEUXVzR9HZRfTPZjbOPADSkmqD0e4tpdppxpFJUFSz/dwpt54BTjHJZAcpwykr
         P4/R0oNcXInJF67rguQtDvb+LkDGH2bMEsL/UP/UjW3I7OlpyizfGfn9uEAoErY3c8c0
         X+UiB55I835PK5eV0RQE6AoUTQJla5z7d2q2hEZOavLasF3PHIbkVWYZ8P0Z0463AEz4
         f2nQ==
X-Gm-Message-State: AOAM531+xYalJ3APDM9nMBDkD2cOY1FJPZKFsZRakk0OXSzzTu5GScSy
	i2MLMlSDywWs1oP3JIOpPKkughY4CeXBtro+Vapbdg==
X-Google-Smtp-Source: ABdhPJztLyXTASXggdUkSdPlx1wfhE5SGsYlFzDlQBIc8mWNp6TBFUqkzdGikFL17eKHOyVYX4Tzu3OXN0IKEKAhhQg=
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id
 v10-20020a17090a00ca00b001ca5253b625mr19017847pjd.220.1649381896572; Thu, 07
 Apr 2022 18:38:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com> <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com> <YkQtOO/Z3SZ2Pksg@infradead.org>
 <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com> <YkR8CUdkScEjMte2@infradead.org>
 <20220330161812.GA27649@magnolia> <fd37cde6-318a-9faf-9bff-70bb8e5d3241@oracle.com>
 <CAPcyv4gqBmGCQM_u40cR6GVror6NjhxV5Xd7pdHedE2kHwueoQ@mail.gmail.com> <20220406203900.GR27690@magnolia>
In-Reply-To: <20220406203900.GR27690@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Apr 2022 18:38:05 -0700
Message-ID: <CAPcyv4g9m13VGq9mFHHhd301jZk-OQC47MGpB9nU=erA0i2ZCg@mail.gmail.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@infradead.org>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, david <david@fromorbit.com>, 
	"Luck, Tony" <tony.luck@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"

[ add Mauro and Tony for RAS discussion ]

On Wed, Apr 6, 2022 at 1:39 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Apr 05, 2022 at 06:22:48PM -0700, Dan Williams wrote:
> > On Tue, Apr 5, 2022 at 5:55 PM Jane Chu <jane.chu@oracle.com> wrote:
> > >
> > > On 3/30/2022 9:18 AM, Darrick J. Wong wrote:
> > > > On Wed, Mar 30, 2022 at 08:49:29AM -0700, Christoph Hellwig wrote:
> > > >> On Wed, Mar 30, 2022 at 06:58:21PM +0800, Shiyang Ruan wrote:
> > > >>> As the code I pasted before, pmem driver will subtract its ->data_offset,
> > > >>> which is byte-based. And the filesystem who implements ->notify_failure()
> > > >>> will calculate the offset in unit of byte again.
> > > >>>
> > > >>> So, leave its function signature byte-based, to avoid repeated conversions.
> > > >>
> > > >> I'm actually fine either way, so I'll wait for Dan to comment.
> > > >
> > > > FWIW I'd convinced myself that the reason for using byte units is to
> > > > make it possible to reduce the pmem failure blast radius to subpage
> > > > units... but then I've also been distracted for months. :/
> > > >
> > >
> > > Yes, thanks Darrick!  I recall that.
> > > Maybe just add a comment about why byte unit is used?
> >
> > I think we start with page failure notification and then figure out
> > how to get finer grained through the dax interface in follow-on
> > changes. Otherwise, for finer grained error handling support,
> > memory_failure() would also need to be converted to stop upcasting
> > cache-line granularity to page granularity failures. The native MCE
> > notification communicates a 'struct mce' that can be in terms of
> > sub-page bytes, but the memory management implications are all page
> > based. I assume the FS implications are all FS-block-size based?
>
> I wouldn't necessarily make that assumption -- for regular files, the
> user program is in a better position to figure out how to reset the file
> contents.
>
> For fs metadata, it really depends.  In principle, if (say) we could get
> byte granularity poison info, we could look up the space usage within
> the block to decide if the poisoned part was actually free space, in
> which case we can correct the problem by (re)zeroing the affected bytes
> to clear the poison.
>
> Obviously, if the blast radius hits the internal space info or something
> that was storing useful data, then you'd have to rebuild the whole block
> (or the whole data structure), but that's not necessarily a given.

tl;dr: dax_holder_notify_failure() != fs->notify_failure()

So I think I see some confusion between what DAX->notify_failure()
needs, memory_failure() needs, the raw information provided by the
hardware, and the failure granularity the filesystem can make use of.

DAX and memory_failure() need to make immediate page granularity
decisions. They both need to map out whole pages (in the direct map
and userspace respectively) to prevent future poison consumption, at
least until the poison is repaired.

The event that leads to a page being failed can be triggered by a
hardware error as small as an individual cacheline. While that is
interesting to a filesystem it isn't information that memory_failure()
and DAX can utilize.

The reason DAX needs to have a callback into filesystem code is to map
the page failure back to all the processes that might have that page
mapped because reflink means that page->mapping is not sufficient to
find all the affected 'struct address_space' instances. So it's more
of an address-translation / "help me kill processes" service than a
general failure notification service.

Currently when raw hardware event happens there are mechanisms like
arch-specific notifier chains, like powerpc::mce_register_notifier()
and x86::mce_register_decode_chain(), or other platform firmware code
like ghes_edac_report_mem_error() that uplevel the error to a coarse
page granularity failure, while emitting the fine granularity error
event to userspace.

All of this to say that the interface to ask the fs to do the bottom
half of memory_failure() (walking affected 'struct address_space'
instances and killing processes (mf_dax_kill_procs())) is different
than the general interface to tell the filesystem that memory has gone
bad relative to a device. So if the only caller of
fs->notify_failure() handler is this code:

+       if (pgmap->ops->memory_failure) {
+               rc = pgmap->ops->memory_failure(pgmap, PFN_PHYS(pfn), PAGE_SIZE,
+                               flags);

...then you'll never get fine-grained reports. So, I still think the
DAX, pgmap and memory_failure() interface should be pfn based. The
interface to the *filesystem* ->notify_failure() can still be
byte-based, but the trigger for that byte based interface will likely
need to be something driven by another agent. Perhaps like rasdaemon
in userspace translating all the arch specific physical address events
back into device-relative offsets and then calling a new ABI that is
serviced by fs->notify_failure() on the backend.

