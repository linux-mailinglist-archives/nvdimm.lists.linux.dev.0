Return-Path: <nvdimm+bounces-8059-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A584E8CB8CC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 22 May 2024 04:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 154D61F25B3B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 22 May 2024 02:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD59D29E;
	Wed, 22 May 2024 02:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdMRNZfd"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3869228FD
	for <nvdimm@lists.linux.dev>; Wed, 22 May 2024 02:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716343524; cv=none; b=oktN2+t+GUJg6N2btFMLDDqvVfF/Senrt2bLaHhKQx2gqwdJQTf4o267+/rAlo4qRHLgTNgxAxnhGvC4xqVpsnYsgmGf2xCk79+qiOK2BoEuS6gA1Fxo/4HxpL9GS/dTlzqOLIjFFbb0rrteLhdfcpIjfj7MrZ7soKI/TmYxJRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716343524; c=relaxed/simple;
	bh=Zfjved76r4tk/R4F2I6Vyn2ILO/DKgJTa6WddGB4SV8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kb5BBgt3SPtJlT/9c4ElovNweuFbK6UGLSmKa8M5N+k3nQO+EBxjIJeyqZ+Ir3tHBXAMwqZq+23a7+WtO6guD09pPSFzVmOj5EBDYSA4gIHhPuCu/MsNbyflGiiljZxAyWL5Mr7W6+1DKK3FJZmbSiRH4J5/b4q+R7Wrpw7Gg28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VdMRNZfd; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-24544cfbc69so2084894fac.3
        for <nvdimm@lists.linux.dev>; Tue, 21 May 2024 19:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716343521; x=1716948321; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pqp9MO7zUvyQGTMo5hIooEPlrzDAs7DVP/rXiNcgUBE=;
        b=VdMRNZfdmQUgpGilEB6xyA16dY2aLD/R0VsVpu367HS+Hdnnjxy5m66EbOFPYGTBWO
         All8vwo1qh03Lqmd0+hRPZKcFQ5QJ2G/g5F5M/RYMJL3l9hs/IeRQoDBWlskn8sV+9sd
         g2dI+OrCdK7Ofi7YxqdrWdKmUM+gGardSKrtUe76N4hnzRuKWVJ9fwZocZMgKE/4YjAz
         YM3BinQKU6V9Fp1/lDC2ML8goaOFXY107ht8g+npmjtIavvGTB8Io+1mGEh4RhDN/ar/
         rRW1OJPCrNl5UYhQaYg/ZRTBhanEvUyKNa1fyKGdl9SgZarfWTtJEWQhIg12aol08aDf
         o/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716343521; x=1716948321;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pqp9MO7zUvyQGTMo5hIooEPlrzDAs7DVP/rXiNcgUBE=;
        b=kl0KqTEaKY+RWKTLU9NcI1wJ6tFbijzlXGGnaTe4b7zvz+cF/JB5OOquY1Xt2HjTGN
         rHGRBr0V1TPPVPW29kpGqDqfH5ea16xvs0Cn/68/zlvOfEvtiuuvdvodx4/QuNlcGDgz
         8gz7ZzFX1VC1oZST6CQBQRpUu8iHaXrkCZsP3LyvMEQPm4ut4E3TiwoHcBMSLuIqt5gf
         a9+2Mx2P9NK/zL2K08s4Sj5S8hHZfShWYDEDrcLrGBkT4jbnVkFOZfkQRS66N36+2b2W
         mms38xdD1wO53poFYQe8ujul4cA38duchBX9JsQYLWJbrkkbVnpQgfQfwa+6QU4luDpx
         cbig==
X-Forwarded-Encrypted: i=1; AJvYcCX7Kqde3BRNha9oI/xXGPNRhLb/s1KRwrxC1IGcgvKg6j3ECbOKam6o7ZULScn4C/N+sjpnu4zlw3Kzv27yqfNFkRzHCApe
X-Gm-Message-State: AOJu0YwWS74w3oubsILuJFzMGarZM3CDx7AcZ3HbrkufpAIANLCk3lVG
	WdSrGdKgTNFwvc8CV/KILELTd3SHGJrs6ks5mORFkIR9ISS4CSOL
X-Google-Smtp-Source: AGHT+IFHzidK4p7s1OgHfceR76fVxz5S8KRUEVvFbRfhLJxxb+D0+PBsOD+3RlG053Na2+1RqZVrEg==
X-Received: by 2002:a05:6870:f605:b0:24c:5cd6:6405 with SMTP id 586e51a60fabf-24c68df1961mr831458fac.43.1716343520999;
        Tue, 21 May 2024 19:05:20 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-24c54d17d08sm598119fac.42.2024.05.21.19.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 19:05:20 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
Date: Tue, 21 May 2024 21:05:18 -0500
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
References: <cover.1708709155.git.john@groves.net>
 <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>

Initial reply to both Amir and Miklos. Sorry for the delay - I took a few
days off after LSFMM and I'm just re-engaging now.

First an observation: these messages are on the famfs v1 patch set thread.
The v2 patch set is at [1]. That is also the default branch now if you clone
the famfs kernel from [2].

Among the biggest changes at v2 is dropping /dev/pmem support and only 
supporting /dev/dax (character) devices as backing devs for famfs.

On 24/05/19 08:59AM, Amir Goldstein wrote:
> On Fri, May 17, 2024 at 12:55 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Thu, 29 Feb 2024 at 07:52, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > I'm not virtiofs expert, but I don't think that you are wrong about this.
> > > IIUC, virtiofsd could map arbitrary memory region to any fuse file mmaped
> > > by virtiofs client.
> > >
> > > So what are the gaps between virtiofs and famfs that justify a new filesystem
> > > driver and new userspace API?
> >
> > Let me try to fill in some gaps.  I've looked at the famfs driver
> > (even tried to set it up in a VM, but got stuck with the EFI stuff).

I'm happy to help with that if you care - ping me if so; getting a VM running 
in EFI mode is not necessary if you reserve the dax memory via memmap=, or
via libvirt xml.

> >
> > - famfs has an extent list per file that indicates how each page
> > within the file should be mapped onto the dax device, IOW it has the
> > following mapping:
> >
> >   [famfs file, offset] -> [offset, length]

More generally, a famfs file extent is [daxdev, offset, len]; there may
be multiple extents per file, and in the future this definitely needs to
generalize to multiple daxdev's.

Disclaimer: I'm still coming up to speed on fuse (slowly and ignorantly, 
I think)...

A single backing device (daxdev) will contain extents of many famfs
files (plus metadata - currently a superblock and a log). I'm not sure
it's realistic to have a backing daxdev "open" per famfs file. 

In addition there is:

- struct dax_holder_operations - to allow a notify_failure() upcall
  from dax. This provides the critical capability to shut down famfs
  if there are memory errors. This is filesystem- (or technically daxdev-
  wide)

- The pmem or devdax iomap_ops - to allow the fsdax file system (famfs,
  and [soon] famfs_fuse) to call dax_iomap_rw() and dax_iomap_fault().
  I strongly suspect that famfs_fuse can't be correct unless it uses
  this path rather than just the idea of a single backing file.
  This interface explicitly supports files that map to disjoint ranges
  of one or more dax devices.

- the dev_dax_iomap portion of the famfs patchsets adds iomap_ops to
  character devdax.

- Note that dax devices, unlike files, don't support read/write - only
  mmap(). I suspect (though I'm still pretty ignorant) that this means
  we can't just treat the dax device as an extent-based backing file.


> >
> > - fuse can currently map a fuse file onto a backing file:
> >
> >   [fuse file] -> [backing file]
> >
> > The interface for the latter is
> >
> >    backing_id = ioctl(dev_fuse_fd, FUSE_DEV_IOC_BACKING_OPEN, backing_map);
> > ...
> >    fuse_open_out.flags |= FOPEN_PASSTHROUGH;
> >    fuse_open_out.backing_id = backing_id;
> 
> FYI, library and example code was recently merged to libfuse:
> https://github.com/libfuse/libfuse/pull/919
> 
> >
> > This looks suitable for doing the famfs file - > dax device mapping as
> > well.  I wouldn't extend the ioctl with extent information, since
> > famfs can just use FUSE_DEV_IOC_BACKING_OPEN once to register the dax
> > device.  The flags field could be used to tell the kernel to treat
> > this fd as a dax device instead of a a regular file.

A dax device to famfs is a lot more like a backing device for a "filesystem"
than a backing file for another file. And, as previously mentioned, there
is the iomap_ops interface and the holder_ops interface that deal with
multiple file tenants on a dax device (plus error notification, 
respectively)

Probably doable, but important distinctions...

> >
> > Letter, when the file is opened the extent list could be sent in the
> > open reply together with the backing id.  The fuse_ext_header
> > mechanism seems suitable for this.
> >
> > And I think that's it as far as API's are concerned.
> >
> > Note: this is already more generic than the current famfs prototype,
> > since multiple dax devices could be used as backing for famfs files,
> > with the constraint that a single file can only map data from a single
> > dax device.
> >
> > As for implementing dax passthrough, I think that needs a separate
> > source file, the one used by virtiofs (fs/fuse/dax.c) does not appear
> > to have many commonalities with this one.  That could be renamed to
> > virtiofs_dax.c as it's pretty much virtiofs specific, AFAICT.
> >
> > Comments?
> 
> Would probably also need to decouple CONFIG_FUSE_DAX
> from CONFIG_FUSE_VIRTIO_DAX.
> 
> What about fc->dax_mode (i.e. dax= mount option)?
> 
> What about FUSE_IS_DAX()? does it apply to both dax implementations?
> 
> Sounds like a decent plan.
> John, let us know if you need help understanding the details.

I'm certain I will need some help, but I'll try to do my part. 

First question: can you suggest an example fuse file pass-through
file system that I might use as a jumping-off point? Something that
gets the basic pass-through capability from which to start hacking
in famfs/dax capabilities?

When I started on famfs, I used ramfs because it got me all the basic
file system functionality minus a backing store. Then I built the dax
functionality by referring to xfs. 

> 
> > Am I missing something significant?
> 
> Would we need to set IS_DAX() on inode init time or can we set it
> later on first file open?
> 
> Currently, iomodes enforces that all opens are either
> mapped to same backing file or none mapped to backing file:
> 
> fuse_inode_uncached_io_start()
> {
> ...
>         /* deny conflicting backing files on same fuse inode */
> 
> The iomodes rules will need to be amended to verify that:
> - IS_DAX() inode open is always mapped to backing dax device
> - All files of the same fuse inode are mapped to the same range
>   of backing file/dax device.

I'm confused by the last item. I would think there would be a fuse
inode per famfs file, and that multiple of those would map to separate
extent lists of one or more backing dax devices.

Or maybe I misunderstand the meaning of "fuse inode". Feel free to
assign reading...

> 
> Thanks,
> Amir.

Thanks Miklos and Amir,
John

[1] https://lore.kernel.org/linux-fsdevel/cover.1714409084.git.john@groves.net/T/#m3b11e8d311eca80763c7d6f27d43efd1cdba628b
[2] https://github.com/cxl-micron-reskit/famfs-linux



