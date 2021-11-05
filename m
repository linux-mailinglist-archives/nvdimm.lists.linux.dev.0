Return-Path: <nvdimm+bounces-1834-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE20F445EA2
	for <lists+linux-nvdimm@lfdr.de>; Fri,  5 Nov 2021 04:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id E38391C0F76
	for <lists+linux-nvdimm@lfdr.de>; Fri,  5 Nov 2021 03:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E4D2C9C;
	Fri,  5 Nov 2021 03:32:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C4E2C99
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 03:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vYTj4+Qj7wwu4cVg0DWamUnt0bl+yIq5bTcfsNjRRqw=; b=GDZA848HxP31gXPJrbJb1hsEqw
	0f4xGgqaPeTYr/jnGmCuCwIDm9/vBUN70m1anN1+xf4jYdLKo8bnkpv98Tz/4LSFfutV+5RUbsHcn
	xvpui7RzzIwOqB9/ri4wv9GDDtkkShT1u8edH0UBE2oBmmJEo1CNw0G0wxCGXXKlubAjOM2Ro/Ehs
	bQ0RTb1mP+goFvBzd5NdSO+UkHqegStEbVRdq3ZH+RO1ssVK/8iJEk/+Yic/9NxIG4O8ZIrUL3aQU
	GV3eG6t1cGKVIkDmU4bZ62AO0lzIYsinGEt5zLBc3KGEkXCrJ55GrQMAElwFrvICgT/tM4n5HS7z3
	Ew1FygLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mipvv-006JD0-HF; Fri, 05 Nov 2021 03:30:39 +0000
Date: Fri, 5 Nov 2021 03:30:27 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@sandeen.net>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: futher decouple DAX from block devices
Message-ID: <YYSlU48wcKt4qixx@casper.infradead.org>
References: <20211018044054.1779424-1-hch@lst.de>
 <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
 <20211104081740.GA23111@lst.de>
 <20211104173417.GJ2237511@magnolia>
 <20211104173559.GB31740@lst.de>
 <CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
 <20211104190443.GK24333@magnolia>
 <YYSgX9FI0kaGLeR0@mit.edu>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYSgX9FI0kaGLeR0@mit.edu>

On Thu, Nov 04, 2021 at 11:09:19PM -0400, Theodore Ts'o wrote:
> On Thu, Nov 04, 2021 at 12:04:43PM -0700, Darrick J. Wong wrote:
> > > Note that I've avoided implementing read/write fops for dax devices
> > > partly out of concern for not wanting to figure out shared-mmap vs
> > > write coherence issues, but also because of a bet with Dave Hansen
> > > that device-dax not grow features like what happened to hugetlbfs. So
> > > it would seem mkfs would need to switch to mmap I/O, or bite the
> > > bullet and implement read/write fops in the driver.
> > 
> > That ... would require a fair amount of userspace changes, though at
> > least e2fsprogs has pluggable io drivers, which would make mmapping a
> > character device not too awful.
> > 
> > xfsprogs would be another story -- porting the buffer cache mignt not be
> > too bad, but mkfs and repair seem to issue pread/pwrite calls directly.
> > Note that xfsprogs explicitly screens out chardevs.
> 
> It's not just e2fsprogs and xfsprogs.  There's also udev, blkid,
> potententially systemd unit generators to kick off fsck runs, etc.
> There are probably any number of user scripts which assume that file
> systems are mounted on block devices --- for example, by looking at
> the output of lsblk, etc.
> 
> Also note that block devices have O_EXCL support to provide locking
> against attempts to run mkfs on a mounted file system.  If you move
> dax file systems to be mounted on a character mode device, that would
> have to be replicated as well, etc.  So I suspect that a large number
> of subtle things would break, and I'd strongly recommend against going
> down that path.

Agreed.  There were reasons we decided to present pmem as "block
device with extra functionality" rather than try to cram all the block
layer functionality (eg submitting BIOs for filesystem metadata) into a
character device.  Some of those assumptions might be worth re-examining,
but I haven't seen anything that makes me say "this is obviously better
than what we did at the time".

