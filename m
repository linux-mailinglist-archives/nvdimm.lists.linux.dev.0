Return-Path: <nvdimm+bounces-7974-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 040A58B0930
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Apr 2024 14:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF75F28405F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Apr 2024 12:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D56415ADB3;
	Wed, 24 Apr 2024 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ErhL2MA5"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B881DFCE
	for <nvdimm@lists.linux.dev>; Wed, 24 Apr 2024 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713961360; cv=none; b=HdipQM7Ka+JuLvvuD49GwAZbmMaUcT5A++sbJP9uYQtb0HWDBzuVCZNzt8ctEtvQ5xUG2hP6nj690hrI30UVFF0UExbXRMZMr6mIZ/oDcQAzDTp6oiyELilC1Q5gScbRxeuEr9pbp9XyieacoYSzmQm3qF186MJt2POwhcARwm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713961360; c=relaxed/simple;
	bh=wIMXXyKyD5c5ow2YOMt9cN4Y53S9fp9bouy48x86Ua4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiUFAmLJ4rMWYTxH4IgTLetlMAW5ShXECT6M/4HP4bq38G+9VgMJeuRP6YXN3Xe2863kOSpNr5B94zT4xfvjDXNpjiuSodzRWbywvTG1k54tAgbpVW3IwOa17mtgakuU0X/9VfyAzvWo33/Bw1H7zu5wMaKPF7uBX1q3w4WaSjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ErhL2MA5; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5ad28c0b85eso2296396eaf.2
        for <nvdimm@lists.linux.dev>; Wed, 24 Apr 2024 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713961357; x=1714566157; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uE1cjgpUK8oWztOrxcMc3TMvCTQWNLBR0SmDy+1FKPg=;
        b=ErhL2MA565j7WXw77HeCdAssOcz94Xp60lpaTWBoR9JHV/8LLrdq8qVG/lEhfy7qjW
         lQ78tS2yvkzOjVVEU00A/fjr+EL+tsQqIB9DrqWW92M1BV227FjezXGd0eIUZmniSWYI
         n1HyVs7sKShonms7l61l3dM+CKmUavMXVEhdoEgk0dPXQHXYhsRkUZodvTOUH/VWyZlk
         eBbakELbAIQdEKEI62EwOrOl3pXs4Mh7XsP+BxcexbfUi6fbP6/nVrvEVvU0/5qYo3Uo
         eEW12eLNr9MSi0MvtfU8+/TfYf+zEYRUUjaNuEyMbwDdmvs+dlZsPvDX1XQCuJvJcXSV
         bFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713961357; x=1714566157;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uE1cjgpUK8oWztOrxcMc3TMvCTQWNLBR0SmDy+1FKPg=;
        b=g+j8ByisN9VY/gm1cShORLo9WNYq4VoWeL6+gW041CNCQMgHWgMKLefA6XYJTCaCOv
         iCEtujBb+OU5faY5w+dSJFiQDozOHlD4FFvqrNevN2d4Mr2YI7VK5T3NQ8W1/mE1Kw/q
         Z/0/YK2J9tV7zq57WegiiOZJOalKa5ah2EdepJh0zp4Bfal0pelBnVCOkePyhgf49FxB
         OnxOFmZbJQfDbRPqXJh7JmKM21OwGM8GQxyR+FYTabX/NcI9Os6HGPrCQvYt0Xdlwt4L
         smcmouHwXENmW6OxJOPH1cMkwXGhogl6/sXDMw1IvgkIGLOXjq8SpDXJWilFgUTpXiK1
         XJbg==
X-Forwarded-Encrypted: i=1; AJvYcCU0IBu6MO3u6z8DPmAUvxagafSKze13yVmLtLJgpcyaQ1uWfz89evDLPGSF5KmAHLfKz/fiuuICvJ25In66y7sBfURmLxNu
X-Gm-Message-State: AOJu0YxawKDXjpI9GE1nLV6yJ5SyGvhBJ8aJOBu9QfFb4vAs8X9DD39e
	6ciLSWWabbRsKQRqZuwiNrgGOUZC60t9tQ0sYHcJxN91KVeDG7af
X-Google-Smtp-Source: AGHT+IHrPCBHIgbRQVZddO/bmqvCCCgEQ7NxF5MhFx+T2gDaeezIrKYJunS8zma39u1+tE2b6DdGWg==
X-Received: by 2002:a4a:5441:0:b0:5af:292b:6988 with SMTP id t62-20020a4a5441000000b005af292b6988mr2381042ooa.1.1713961356876;
        Wed, 24 Apr 2024 05:22:36 -0700 (PDT)
Received: from Borg-9.local ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id ck19-20020a056820229300b005a588e72c3bsm2892376oob.9.2024.04.24.05.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 05:22:36 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 24 Apr 2024 07:22:33 -0500
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd.schubert@fastmail.fm>, lsf-pc@lists.linux-foundation.org, 
	Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	Jon Grimm <jon.grimm@amd.com>, Dave Chinner <david@fromorbit.com>, john@jagalactic.com, 
	Bharata B Rao <bharata@amd.com>, Jerome Glisse <jglisse@google.com>, gregory.price@memverge.com, 
	Ajay Joshi <ajayjoshi@micron.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Hellwig <hch@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	David Rientjes <rientjes@google.com>, Ravi Shankar <venkataravis@micron.com>, 
	dave.hansen@linux.intel.com, John Hubbard <jhubbard@nvidia.com>, mykolal@meta.com, 
	Brian Morris <bsmorris@google.com>, Eishan Mirakhur <emirakhur@micron.com>, 
	Wei Xu <weixugc@google.com>, Theodore Ts'o <tytso@mit.edu>, 
	Srinivasulu Thanneeru <sthanneeru@micron.com>, John Groves <jgroves@micron.com>, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Aravind Ramesh <arramesh@micron.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Famfs: shared memory file system for
 disaggregated memory [LSF/MM/BPF ATTEND]
Message-ID: <f6ncfg4hrukc7pc5s5sl27zjvs37ywbu4qfcogs54k7v2a5g7g@t67u6jobqwns>
References: <20240229002020.85535-1-john@groves.net>
 <CAOQ4uxi83HUUmMmNs9NeeOOfVVXhpWAdeAEDq8r31p0tK1sA2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxi83HUUmMmNs9NeeOOfVVXhpWAdeAEDq8r31p0tK1sA2A@mail.gmail.com>

On 24/04/23 04:30PM, Amir Goldstein wrote:
> On Thu, Feb 29, 2024 at 2:20 AM John Groves <John@groves.net> wrote:
> >
> > John Groves, Micron
> >
> > Micron recently released the first RFC for famfs [1]. Although famfs is not
> > CXL-specific in any way, it aims to enable hosts to share data sets in shared
> > memory (such as CXL) by providing a memory-mappable fs-dax file system
> > interface to the memory.
> >
> > Sharable disaggregated memory already exists in the lab, and will be possible
> > in the wild soon. Famfs aims to do the following:
> >
> > * Provide an access method that provides isolation between files, and does not
> >   tempt developers to mmap all the memory writable on every host.
> > * Provide an an access method that can be used by unmodified apps.
> >
> > Without something like famfs, enabling the use of sharable memory will involve
> > the temptation to do things that may destabilize systems, such as
> > mapping large shared, writable global memory ranges and hooking allocators to
> > use it (potentially sacrificing isolation), and forcing the same virtual
> > address ranges in every host/process (compromising security).
> >
> > The most obvious candidate app categories are data analytics and data lakes.
> > Both make heavy use of "zero-copy" data frames - column oriented data that
> > is laid out for efficient use via (MAP_SHARED) mmap. Moreover, these use case
> > categories are generally driven by python code that wrangles data into
> > appropriate data frames - making it straightforward to put the data frames
> > into famfs. Furthermore, these use cases usually involve the shared data being
> > read-only during computation or query jobs - meaning they are often free of
> > cache coherency concerns.
> >
> > Workloads such as these often deal with data sets that are too large to fit
> > in a single server's memory, so the data gets sharded - requiring movement via
> > a network. Sharded apps also sometimes have to do expensive reshuffling -
> > moving data to nodes with available compute resources. Avoiding the sharding
> > overheads by accessing such data sets in disaggregated shared memory looks
> > promising to make make better use of memory and compute resources, and by
> > effectively de-duplicating data sets in memory.
> >
> > About sharable memory
> >
> > * Shared memory is pmem-like, in that hosts will connect in order to access
> >   pre-existing contents
> > * Onlining sharable memory as system-ram is nonsense; system-ram gets zeroed...
> > * CXL 3 provides for optionally-supported hardware-managed cache coherency
> > * But "multiple-readers, no writers" use cases don't need hardware support
> >   for coherency
> > * CXL 3.1 dynamic capacity devices (DCDs) should be thought of as devices with
> >   an allocator built in.
> > * When sharable capacity is allocated, each host that has access will see a
> >   /dev/dax device that can be found by the "tag" of the allocation. The tag is
> >   just a uuid.
> > * CXL 3.1 also allows the capacity associated with any allocated tag to be
> >   provided to each host (or host group) as either writable or read-only.
> >
> > About famfs
> >
> > Famfs is an append-only log-structured file system that places many limits
> > on what can be done. This allows famfs to tolerate clients with a stale copy
> > of metadata. All memory allocation and log maintenance is performed from user
> > space, but file extent lists are cached in the kernel for fast fault
> > resolution. The current limitations are fairly extreme, but many can be relaxed
> > by writing more code, managing Byzantine generals, etc. ;)
> >
> > A famfs-enabled kernel can be cloned at [3], and the user space repo can be
> > cloned at [4]. Even with major functional limitations in its current form
> > (e.g. famfs does not currently support deleting files), it is sufficient to
> > use in data analytics workloads - in which you 1) create a famfs file system,
> > 2) dump data sets into it, 3) run clustered jobs that consume the shared data
> > sets, and 4) dismount and deallocate the memory containing the file system.
> >
> > Famfs Open Issues
> >
> > * Volatile CXL memory is exposed as character dax devices; the famfs patch
> >   set adds the iomap API, which is required for fs-dax but until now missing
> >   from character dax.
> > * (/dev/pmem devices are block, and support the iomap api for fs-dax file
> >   systems)
> > * /dev/pmem devices can be converted to /dev/dax mode, but native /dev/dax
> >   devices cannot be converted to pmem mode.
> > * /dev/dax devices lack the iomap api that fs-dax uses with pmem, so the famfs
> >   patch set adds that.
> > * VFS layer hooks for a file system on a character device may be needed.
> > * Famfs has uncovered some previously latent bugs in the /dev/dax mmap
> >   machinery that probably require attention.
> > * Famfs currently works with either pmem or devdax devices, but our
> >   inclination is to drop pmem support to, reduce the complexity of supporting
> >   two different underlying device types - particularly since famfs is not
> >   intended for actual pmem.
> >
> >
> > Required :-
> > Dan Williams
> > Christian Brauner
> > Jonathan Cameron
> > Dave Hansen
> >
> > [LSF/MM + BPF ATTEND]
> >
> > I am the author of the famfs file system. Famfs was first introduced at LPC
> > 2023 [2]. I'm also Micron's voting member on the Software and Systems Working
> > Group (SSWG) of the CXL Consortium, and a co-author of the CXL 3.1
> > specification.
> >
> >
> > References
> >
> > [1] https://lore.kernel.org/linux-fsdevel/cover.1708709155.git.john@groves.net/#t
> > [2] https://lpc.events/event/17/contributions/1455/
> > [3] https://www.computeexpresslink.org/download-the-specification
> > [4] https://github.com/cxl-micron-reskit/famfs-linux
> >
> 
> Hi John,
> 
> Following our correspondence on your patch set [1], I am not sure that the
> details of famfs file system itself are an interesting topic for the
> LSFMM crowd??
> What I would like to do is schedule a session on:
> "Famfs: new userspace filesystem driver vs. improving FUSE/DAX"
> 
> I am hoping that Miklos and Bernd will be able to participate in this
> session remotely.
> 
> You see the last time that someone tried to introduce a specialized
> faster FUSE replacement [2], the comments from the community were
> that FUSE protocol can and should be improved instead of introducing
> another "filesystem in userspace" protocol.
> 
> Since 2019, FUSE has gained virtiofs/dax support, it recently gained
> FUSE passthrough support and Bernd is working on FUSE uring [3].
> 
> My hope is that you will be able to list the needed improvements
> to /dev/dax iomap and FUSE so that you could use the existing
> kernel infrastructure and FUSE libraries to implement famfs.
> 
> How does that sound for a discussion?
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/3jwluwrqj6rwsxdsksfvdeo5uccgmnkh7rgefaeyxf2gu75344@ybhwncywkftx/
> [2] https://lore.kernel.org/linux-fsdevel/8d119597-4543-c6a4-917f-14f4f4a6a855@netapp.com/
> [3] https://lore.kernel.org/linux-fsdevel/20230321011047.3425786-1-bschubert@ddn.com/

Amir,

That sounds good, thanks! I'll start preparing for it!

Re: [2]: I do think there are important ways that famfs is not "another 
filesystem in user space protocol" - but I'll save it for the LSFMM session!

FYI famfs v2 patches will be going out before LSFMM (and possibly before
next week).

Thanks Amir,
John


