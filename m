Return-Path: <nvdimm+bounces-2272-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id EE378474CB0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Dec 2021 21:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 3F6AE3E0E4E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Dec 2021 20:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A488A2CBC;
	Tue, 14 Dec 2021 20:33:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E329CA
	for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 20:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639513999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6UEz37RENDqZc874C7RATl7+g+LJCAFHhK7C3YHwPU=;
	b=MKRHbdnXL0+a8dN0cn7ewZCAVGaW+NSuIOlCWoAoI1ax3tnXnVoNtkRsIxMOhxKVcVqTLK
	4dd+DRNChkgXHaAn3euFsrWwFOahW7XtzfEffDOUw7ollPQ/9DZkWEiSZRRiSox8Cbs4xu
	5o8yRVbpQRDRJxhgHYIsVBzXolB22uA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-e3Qt5gtLO6ShEmU376si3A-1; Tue, 14 Dec 2021 15:33:16 -0500
X-MC-Unique: e3Qt5gtLO6ShEmU376si3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A0E51006AA0;
	Tue, 14 Dec 2021 20:33:14 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.33.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E3C422DFC;
	Tue, 14 Dec 2021 20:32:44 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id EB1B82233DF; Tue, 14 Dec 2021 15:32:43 -0500 (EST)
Date: Tue, 14 Dec 2021 15:32:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Matthew Wilcox <willy@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter
 methods
Message-ID: <Ybj/azxrUyU4PZEr@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
 <20211209063828.18944-5-hch@lst.de>
 <YbNhPXBg7G/ridkV@redhat.com>
 <CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
 <20211213082318.GB21462@lst.de>
 <YbiosqZoG8e6rDkj@redhat.com>
 <CAPcyv4hFjKsPrPTB4NtLHiY8gyaELz9+45N1OFj3hz+uJ=9JnA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hFjKsPrPTB4NtLHiY8gyaELz9+45N1OFj3hz+uJ=9JnA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On Tue, Dec 14, 2021 at 08:41:30AM -0800, Dan Williams wrote:
> On Tue, Dec 14, 2021 at 6:23 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Mon, Dec 13, 2021 at 09:23:18AM +0100, Christoph Hellwig wrote:
> > > On Sun, Dec 12, 2021 at 06:44:26AM -0800, Dan Williams wrote:
> > > > On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > Going forward, I am wondering should virtiofs use flushcache version as
> > > > > well. What if host filesystem is using DAX and mapping persistent memory
> > > > > pfn directly into qemu address space. I have never tested that.
> > > > >
> > > > > Right now we are relying on applications to do fsync/msync on virtiofs
> > > > > for data persistence.
> > > >
> > > > This sounds like it would need coordination with a paravirtualized
> > > > driver that can indicate whether the host side is pmem or not, like
> > > > the virtio_pmem driver. However, if the guest sends any fsync/msync
> > > > you would still need to go explicitly cache flush any dirty page
> > > > because you can't necessarily trust that the guest did that already.
> > >
> > > Do we?  The application can't really know what backend it is on, so
> > > it sounds like the current virtiofs implementation doesn't really, does it?
> >
> > Agreed that application does not know what backend it is on. So virtiofs
> > just offers regular posix API where applications have to do fsync/msync
> > for data persistence. No support for mmap(MAP_SYNC). We don't offer persistent
> > memory programming model on virtiofs. That's not the expectation. DAX
> > is used only to bypass guest page cache.
> >
> > With this assumption, I think we might not have to use flushcache version
> > at all even if shared filesystem is on persistent memory on host.
> >
> > - We mmap() host files into qemu address space. So any dax store in virtiofs
> >   should make corresponding pages dirty in page cache on host and when
> >   and fsync()/msync() comes later, it should flush all the data to PMEM.
> >
> > - In case of file extending writes, virtiofs falls back to regular
> >   FUSE_WRITE path (and not use DAX), and in that case host pmem driver
> >   should make sure writes are flushed to pmem immediately.
> >
> > Are there any other path I am missing. If not, looks like we might not
> > have to use flushcache version in virtiofs at all as long as we are not
> > offering guest applications user space flushes and MAP_SYNC support.
> >
> > We still might have to use machine check safe variant though as loads
> > might generate synchronous machine check. What's not clear to me is
> > that if this MC safe variant should be used only in case of PMEM or
> > should it be used in case of non-PMEM as well.
> 
> It should be used on any memory address that can throw exception on
> load, which is any physical address, in paths that can tolerate
> memcpy() returning an error code, most I/O paths, and can tolerate
> slower copy performance on older platforms that do not support MC
> recovery with fast string operations, to date that's only PMEM users.

Ok, So basically latest cpus can do fast string operations with MC
recovery so that using MC safe variant is not a problem.

Then there is range of cpus which can do MC recovery but do slower
versions of memcpy and that's where the issue is.

So if we knew that virtiofs dax window is backed by a pmem device
then we should always use MC safe variant. Even if it means paying
the price of slow version for the sake of correctness. 

But if we are not using pmem on host, then there is no point in
using MC safe variant.

IOW.

	if (virtiofs_backed_by_pmem) {
		use_mc_safe_version
	else
		use_non_mc_safe_version
	}

Now question is, how do we know if virtiofs dax window is backed by
a pmem or not. I checked virtio_pmem driver and that does not seem
to communicate anything like that. It just communicates start of the
range and size of range, nothing else.

I don't have full handle on stack of modules of virtio_pmem, but my guess
is it probably is using MC safe version always (because it does not
know anthing about the backing storage).

/me will definitely like to pay penalty of slower memcpy if virtiofs
device is not backed by a pmem.

Vivek


