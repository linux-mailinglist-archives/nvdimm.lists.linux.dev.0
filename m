Return-Path: <nvdimm+bounces-7578-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA295867F84
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 19:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 082ED1C2B4CC
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 18:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06CC12F581;
	Mon, 26 Feb 2024 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOWBWrv0"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B4212EBD3
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708970651; cv=none; b=uxkn5/fJrqTf2bjVs8H0DFA0ZiYgee4C1acmGOblDFZE89ADAmld4MIrjKpMAAX3z6ZenYmTBLLi1SpnB7gcf0Fl+pyvZPuU2gHHHOtLN/kYB65+uPZasEfeq+uBoRc3BqLdTK0/+VLcAk4ttnO056em6mxUZ+Xii71dwDBhpLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708970651; c=relaxed/simple;
	bh=tDPb8vlw/ZoRmRrLyIh3Zsy28YswYOKaPkn8/G0z84Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYacR1eiQHnMYFm4Tosj+w/Wp+LfOKgqClUl7meCyPIp1StYynPEpQlffH7hoTXcFe3VTpFNFgPKzHgM/yVZOwkko+sXCId30MESBp/MP/Jr9XKOORqoFvBiJV9IELaicgxLLt3JHOQC+1OCTDCJ8JekQlwJgHnRHzDlj2g4UGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOWBWrv0; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a02e5c5d2dso1431635eaf.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 10:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708970648; x=1709575448; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b7s8IUy8czqrAQYpGOzabD/DmImOT4f/IOsvl+2f5BQ=;
        b=WOWBWrv0957GaXHttIWeXlar+m3aUE8eqK2NHNP3qyXeN1AlZsQFgKv9QxkSNGUsUW
         Wf/CgQeur1JUK9Rc+JLRWzgt/8HsBGzefb4NApAHPTXTwHZpw31M7WUluzONNpjaSjBy
         qsKUliOzZUVaBdD8h6ZW++Jy8vopq6SSJad7YmFH4e0OqkfFeMvXmoGus+DjbU576XB3
         fkUSynNKPWDAs17nq5hrHXAa4VpYbyA4L5es/lvrJyM1VlwGG4s1doX0he4IZCeWDcUe
         ykvFpqYbwVixdOrHPtRXssC2MbzciEeVdlJW97sOCdrksKgGkqq1tC7aXeMXWNkIWtMM
         PTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708970648; x=1709575448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7s8IUy8czqrAQYpGOzabD/DmImOT4f/IOsvl+2f5BQ=;
        b=adQwGvTMQrqkXeYxXg+T28hkzQXARkNVZco9VypOLKbqnsngRkQKIrW1Kxk0ZN9IMR
         m43N6ecCZxk7ZejEw9zmbnS/+SyvxuQpJ7H3LLEN+Ptk1IfFYQ0eTzC4OBvCqI8SVQ3M
         Ihy/v+HUC+lfA6qmcrisVVGDQZFuk9DIFn9LwtBXJlo7bdnaecGUSB8lDh84S2XNtH2h
         qyzwbQYDewFEl905RQ+TINwnopZvE2QV4/VMG636E1Wl6Rx4jMi6seNz5yK5YvKAddQZ
         wAFJe/zxj3J7F3NXw3c6BBL0QNx5IxY8taF6RweKndddHd7+ycLoqq//2JAL+9mRqrr6
         L9lw==
X-Forwarded-Encrypted: i=1; AJvYcCVD4SrJELShrgjK1Z7eftIEwfqICSQN2lKUfCoEsxenUZbvwRN8Sht5V0LCN5M9nx8GPkQ24mu30RJ/KbDD8ydOYndDMGTV
X-Gm-Message-State: AOJu0Yy1YLX+fK/njnr7M1VN5S6JSkjMPwsdpuslaGSd7Scj6iaZd1Bk
	UZycuYpDmiljoFRi2CB9OL2FKvz8o/bPFRO9Z3MUUEGCWz4yf5+W
X-Google-Smtp-Source: AGHT+IHO3JQJqrUqgBn9egOt4HQjL1Epy1k4IOgfQYCQYmmcGSlN0f4WlPT0wFFWU2jOVnrpPNk8kA==
X-Received: by 2002:a4a:bd83:0:b0:5a0:6b03:a660 with SMTP id k3-20020a4abd83000000b005a06b03a660mr2448473oop.2.1708970648068;
        Mon, 26 Feb 2024 10:04:08 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id x14-20020a4a620e000000b005a0a1249615sm179887ooc.5.2024.02.26.10.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 10:04:07 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 12:04:05 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 07/20] famfs: Add include/linux/famfs_ioctl.h
Message-ID: <4v6ug44nrtk2tqvio2teglsm4auhdvocgyyggtlwc3xkv7b6zw@ntw24jye7omz>
References: <cover.1708709155.git.john@groves.net>
 <b40ca30e4bf689249a8c237909d9a7aaca9861e4.1708709155.git.john@groves.net>
 <20240226123940.0000692c@Huawei.com>
 <z3fx5uiv6uu4sawvxrhfvx42qetchmq4ozxhq2huwg2rrcyk5c@odbiisdhop2m>
 <20240226165639.000025c6@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226165639.000025c6@Huawei.com>

On 24/02/26 04:56PM, Jonathan Cameron wrote:
> On Mon, 26 Feb 2024 10:44:43 -0600
> John Groves <John@groves.net> wrote:
> 
> > On 24/02/26 12:39PM, Jonathan Cameron wrote:
> > > On Fri, 23 Feb 2024 11:41:51 -0600
> > > John Groves <John@Groves.net> wrote:
> > >   
> > > > Add uapi include file for famfs. The famfs user space uses ioctl on
> > > > individual files to pass in mapping information and file size. This
> > > > would be hard to do via sysfs or other means, since it's
> > > > file-specific.
> > > > 
> > > > Signed-off-by: John Groves <john@groves.net>
> > > > ---
> > > >  include/uapi/linux/famfs_ioctl.h | 56 ++++++++++++++++++++++++++++++++
> > > >  1 file changed, 56 insertions(+)
> > > >  create mode 100644 include/uapi/linux/famfs_ioctl.h
> > > > 
> > > > diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
> > > > new file mode 100644
> > > > index 000000000000..6b3e6452d02f
> > > > --- /dev/null
> > > > +++ b/include/uapi/linux/famfs_ioctl.h
> > > > @@ -0,0 +1,56 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > > > +/*
> > > > + * famfs - dax file system for shared fabric-attached memory
> > > > + *
> > > > + * Copyright 2023-2024 Micron Technology, Inc.
> > > > + *
> > > > + * This file system, originally based on ramfs the dax support from xfs,
> > > > + * is intended to allow multiple host systems to mount a common file system
> > > > + * view of dax files that map to shared memory.
> > > > + */
> > > > +#ifndef FAMFS_IOCTL_H
> > > > +#define FAMFS_IOCTL_H
> > > > +
> > > > +#include <linux/ioctl.h>
> > > > +#include <linux/uuid.h>
> > > > +
> > > > +#define FAMFS_MAX_EXTENTS 2  
> > > Why 2?  
> > 
> > You catch everything! 
> > 
> > This limit is in place to avoid supporting somethign we're not testing. It
> > will probably be raised later.
> > 
> > Currently user space doesn't support deleting files, which makes it easy
> > to ignore whether any clients have a stale view of metadata. If there is
> > no delete, there's actually no reason to have more than 1 extent.
> Then have 1. + a Comment on why it is 1.

Actually we test the 2 case. That seemed important to testing ioctl and
famfs_meta_to_dax_offset(). It just doesn't yet happen in the wild. Will
clarify with a comment.

> > 
> > > > +
> > > > +enum extent_type {
> > > > +	SIMPLE_DAX_EXTENT = 13,  
> > > 
> > > Comment on this would be good to have  
> > 
> > Done. Basically we anticipate there being other types of extents in the
> > future.
> 
> I was more curious about the 13!

I think I was just being feisty that day. Will drop that...

> 
> > 
> > >   
> > > > +	INVALID_EXTENT_TYPE,
> > > > +};
> > > > +
> > > > +struct famfs_extent {
> > > > +	__u64              offset;
> > > > +	__u64              len;
> > > > +};
> > > > +
> > > > +enum famfs_file_type {
> > > > +	FAMFS_REG,
> > > > +	FAMFS_SUPERBLOCK,
> > > > +	FAMFS_LOG,
> > > > +};
> > > > +
> > > > +/**
> > > > + * struct famfs_ioc_map
> > > > + *
> > > > + * This is the metadata that indicates where the memory is for a famfs file
> > > > + */
> > > > +struct famfs_ioc_map {
> > > > +	enum extent_type          extent_type;
> > > > +	enum famfs_file_type      file_type;  
> > > 
> > > These are going to be potentially varying in size depending on arch, compiler
> > > settings etc.  Been a while, but I though best practice for uapi was always
> > > fixed size elements even though we lose the typing.  
> > 
> > I might not be following you fully here. User space is running the same
> > arch as kernel, so an enum can't be a different size, right? It could be
> > a different size on different arches, but this is just between user/kernel.
> 
> I can't remember why, but this has bitten me in the past.
> Ah, should have known Daniel would have written something on it ;)
> https://www.kernel.org/doc/html/next/process/botching-up-ioctls.html
> 
> It's the fun of need for compat ioctls with 32bit userspace on 64bit kernels.
> 
> The alignment one is key as well. That bit me more than once due to
> 32bit x86 aligning 64 bit integers at 32 bits.
> 
> We could just not support these cases but it's easy to get right so why
> bother with complexity of ruling them out.

Makes sense. Will do.

> 
> > 
> > I initially thought of XDR for on-media-format, which file systems need
> > to do with on-media structs (superblocks, logs, inodes, etc. etc.). But
> > this struct is not used in that way.
> > 
> > In fact, famfs' on-media/in-memory metadata (superblock, log, log entries)
> > is only ever read read and written by user space - so it's the user space
> > code that needs XDR on-media-format handling.
> > 
> > So to clarify - do you think those enums should be u32 or the like?
> 
> Yes. As it's userspace, uint32_t maybe or __u32. I 'think'
> both are acceptable in uapi headers these days.

Roger that.

Thanks,
John

