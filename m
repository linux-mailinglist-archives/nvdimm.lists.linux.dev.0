Return-Path: <nvdimm+bounces-2273-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C49A474EB1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Dec 2021 00:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id F0D613E0EBF
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Dec 2021 23:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090742CBC;
	Tue, 14 Dec 2021 23:43:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079DC2CA4
	for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 23:43:49 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id y7so14904182plp.0
        for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 15:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZgiCaY5T0l0ZMYR/Mztq5hUwLAkj4TagBnnAdRgHzk=;
        b=o60Xt32UY2brLgl906BjCGYAiHBp6YXZoHuzVMpf/TBtDvCHXRupMf0YCfnhHpR+Vo
         ENpVSux42eejaXSB6ZEshx3h13Zl9SmbgbENxP6Ri1p6CwkmqTTn5hcYInIIzggrD8/X
         gk3rCFal8xdLl4fMLMU5kKB5ailzqJJUhzcKFZshEt9xR/KcqWhkCKR1oyUBKFMLV449
         YYf1FurMhK2QwH/5A3k4eF4RmNfF8RGS96hg8jqQJNZVfEceTwyccP/YcyOJyHahBQhv
         O6h7DDmQmI+W7XhAIKaIuECI8c4odfFfK9I0cfRBHiNPO6uLMRPqzSJyCmjraYWSUCnC
         i3gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZgiCaY5T0l0ZMYR/Mztq5hUwLAkj4TagBnnAdRgHzk=;
        b=m6/mS7OGJXhIb6Jo++SxHYxJG0I7afBl9m8wgcqvlNbCq0ftDFovPlFo/nm1sFjAYW
         UT8KQrwl6EhlyFFHi3tXzuPgMvhtvaME7OBuJLt3d9F9z56BkiD2+CnhTet+KJs5mD64
         4JAkwsJnMfwTI8/pSIPi0yoBLCXpa9UK2WkO/6DiHnuW+qTUXQRUsc+lBytu7gus5nhO
         fLF0MItw9wet+S7RWX+dT8veCwzf/SaqCppRRzy+vmW3nAC+fOKex0B2raHnWyvUK0Eb
         3vTUcyOp3wu9U1kkjeIGLIYhkHxz9sPqsIkxegvZ9e2nmKGj5N+UPVWr+rxqgGP3nFv2
         MaVQ==
X-Gm-Message-State: AOAM532255Ul8RlUMpZFhYk34XoR43wfn4UCTmxabdhM4JFfyRay49ej
	u7b9sYuZAYvN17pf9L7FBe0VN4/cY0JmHXAg9Fin9g==
X-Google-Smtp-Source: ABdhPJy+4yBj3d67HMDz3DTq4QLF9yJ3cfSdJiIkjC96epZNko/gKghY4BBpEhMwNLi1UZe5rRHfaBU5MSuVxaK2JYI=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr8641641pjb.93.1639525429353;
 Tue, 14 Dec 2021 15:43:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-5-hch@lst.de>
 <YbNhPXBg7G/ridkV@redhat.com> <CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
 <20211213082318.GB21462@lst.de> <YbiosqZoG8e6rDkj@redhat.com>
 <CAPcyv4hFjKsPrPTB4NtLHiY8gyaELz9+45N1OFj3hz+uJ=9JnA@mail.gmail.com> <Ybj/azxrUyU4PZEr@redhat.com>
In-Reply-To: <Ybj/azxrUyU4PZEr@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Dec 2021 15:43:38 -0800
Message-ID: <CAPcyv4h_iFe8U8UrXCbhAYaruFm-xg0n_U3H8wnK-uGoEubTvw@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter methods
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 14, 2021 at 12:33 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Dec 14, 2021 at 08:41:30AM -0800, Dan Williams wrote:
> > On Tue, Dec 14, 2021 at 6:23 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Mon, Dec 13, 2021 at 09:23:18AM +0100, Christoph Hellwig wrote:
> > > > On Sun, Dec 12, 2021 at 06:44:26AM -0800, Dan Williams wrote:
> > > > > On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > Going forward, I am wondering should virtiofs use flushcache version as
> > > > > > well. What if host filesystem is using DAX and mapping persistent memory
> > > > > > pfn directly into qemu address space. I have never tested that.
> > > > > >
> > > > > > Right now we are relying on applications to do fsync/msync on virtiofs
> > > > > > for data persistence.
> > > > >
> > > > > This sounds like it would need coordination with a paravirtualized
> > > > > driver that can indicate whether the host side is pmem or not, like
> > > > > the virtio_pmem driver. However, if the guest sends any fsync/msync
> > > > > you would still need to go explicitly cache flush any dirty page
> > > > > because you can't necessarily trust that the guest did that already.
> > > >
> > > > Do we?  The application can't really know what backend it is on, so
> > > > it sounds like the current virtiofs implementation doesn't really, does it?
> > >
> > > Agreed that application does not know what backend it is on. So virtiofs
> > > just offers regular posix API where applications have to do fsync/msync
> > > for data persistence. No support for mmap(MAP_SYNC). We don't offer persistent
> > > memory programming model on virtiofs. That's not the expectation. DAX
> > > is used only to bypass guest page cache.
> > >
> > > With this assumption, I think we might not have to use flushcache version
> > > at all even if shared filesystem is on persistent memory on host.
> > >
> > > - We mmap() host files into qemu address space. So any dax store in virtiofs
> > >   should make corresponding pages dirty in page cache on host and when
> > >   and fsync()/msync() comes later, it should flush all the data to PMEM.
> > >
> > > - In case of file extending writes, virtiofs falls back to regular
> > >   FUSE_WRITE path (and not use DAX), and in that case host pmem driver
> > >   should make sure writes are flushed to pmem immediately.
> > >
> > > Are there any other path I am missing. If not, looks like we might not
> > > have to use flushcache version in virtiofs at all as long as we are not
> > > offering guest applications user space flushes and MAP_SYNC support.
> > >
> > > We still might have to use machine check safe variant though as loads
> > > might generate synchronous machine check. What's not clear to me is
> > > that if this MC safe variant should be used only in case of PMEM or
> > > should it be used in case of non-PMEM as well.
> >
> > It should be used on any memory address that can throw exception on
> > load, which is any physical address, in paths that can tolerate
> > memcpy() returning an error code, most I/O paths, and can tolerate
> > slower copy performance on older platforms that do not support MC
> > recovery with fast string operations, to date that's only PMEM users.
>
> Ok, So basically latest cpus can do fast string operations with MC
> recovery so that using MC safe variant is not a problem.
>
> Then there is range of cpus which can do MC recovery but do slower
> versions of memcpy and that's where the issue is.
>
> So if we knew that virtiofs dax window is backed by a pmem device
> then we should always use MC safe variant. Even if it means paying
> the price of slow version for the sake of correctness.
>
> But if we are not using pmem on host, then there is no point in
> using MC safe variant.
>
> IOW.
>
>         if (virtiofs_backed_by_pmem) {

No, PMEM should not be considered at all relative to whether to use MC
or not, it is 100% a decision of whether you expect virtiofs users
will balk more at unhandled machine checks or performance regressions
on the platforms that set "enable_copy_mc_fragile()". See
quirk_intel_brickland_xeon_ras_cap() and
quirk_intel_purley_xeon_ras_cap() in arch/x86/kernel/quirks.c.

>                 use_mc_safe_version
>         else
>                 use_non_mc_safe_version
>         }
>
> Now question is, how do we know if virtiofs dax window is backed by
> a pmem or not. I checked virtio_pmem driver and that does not seem
> to communicate anything like that. It just communicates start of the
> range and size of range, nothing else.
>
> I don't have full handle on stack of modules of virtio_pmem, but my guess
> is it probably is using MC safe version always (because it does not
> know anthing about the backing storage).
>
> /me will definitely like to pay penalty of slower memcpy if virtiofs
> device is not backed by a pmem.

I assume you meant "not like", but again PMEM has no bearing on
whether using that device will throw machine checks. I'm sure there
are people that would make the opposite tradeoff.

