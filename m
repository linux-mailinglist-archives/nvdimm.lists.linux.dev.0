Return-Path: <nvdimm+bounces-5297-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6A763CE49
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Nov 2022 05:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0643C280C10
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Nov 2022 04:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E85801;
	Wed, 30 Nov 2022 04:16:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C77C
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 04:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EC8C433C1;
	Wed, 30 Nov 2022 04:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669781787;
	bh=a1Oqeqd9LyJXcgi3AiUoH2zbyBRJpuQuP+pbYpezbw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lC5RH8zTcZck+uFDfw/z96LLUZOn4fnb4TEwy23JS/Ku3Pz39D0EhGCDqj+RD6KuG
	 0NzfdaJlLNc5wgsCmotBmdB9OM7i12FR4VNLF/gzv2iMTnNQ9AzQrmtnLp1u/cchyJ
	 B+kXGpA4YbowC3bUWTce10fFhPtHUdakOOoiHIdYibwMMCR3onIMADROqco50lLQ9/
	 fSTg4Nfbhk5D2DVBrc4Vtn/ayQlda2I5dOUEvvhyWzAj3EKgPC2m99PLBJbdc9zoBx
	 EcMo23U19Xo/jj9u5JNu6oqUJtDtsyCD4uToNFqqd8StZrNJIxgdpr1U3NTlW+2BMf
	 D2M8yTinnuecA==
Date: Tue, 29 Nov 2022 20:16:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages
Message-ID: <Y4bZGvP8Ozp+4De/@magnolia>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
 <6386d512ce3fc_c9572944e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6386d512ce3fc_c9572944e@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Tue, Nov 29, 2022 at 07:59:14PM -0800, Dan Williams wrote:
> [ add Andrew ]
> 
> Shiyang Ruan wrote:
> > Many testcases failed in dax+reflink mode with warning message in dmesg.
> > This also effects dax+noreflink mode if we run the test after a
> > dax+reflink test.  So, the most urgent thing is solving the warning
> > messages.
> > 
> > Patch 1 fixes some mistakes and adds handling of CoW cases not
> > previously considered (srcmap is HOLE or UNWRITTEN).
> > Patch 2 adds the implementation of unshare for fsdax.
> > 
> > With these fixes, most warning messages in dax_associate_entry() are
> > gone.  But honestly, generic/388 will randomly failed with the warning.
> > The case shutdown the xfs when fsstress is running, and do it for many
> > times.  I think the reason is that dax pages in use are not able to be
> > invalidated in time when fs is shutdown.  The next time dax page to be
> > associated, it still remains the mapping value set last time.  I'll keep
> > on solving it.
> > 
> > The warning message in dax_writeback_one() can also be fixed because of
> > the dax unshare.
> 
> Thank you for digging in on this, I had been pinned down on CXL tasks
> and worried that we would need to mark FS_DAX broken for a cycle, so
> this is timely.
> 
> My only concern is that these patches look to have significant collisions with
> the fsdax page reference counting reworks pending in linux-next. Although,
> those are still sitting in mm-unstable:
> 
> http://lore.kernel.org/r/20221108162059.2ee440d5244657c4f16bdca0@linux-foundation.org
> 
> My preference would be to move ahead with both in which case I can help
> rebase these fixes on top. In that scenario everything would go through
> Andrew.
> 
> However, if we are getting too late in the cycle for that path I think
> these dax-fixes take precedence, and one more cycle to let the page
> reference count reworks sit is ok.

Well now that raises some interesting questions -- dax and reflink are
totally broken on 6.1.  I was thinking about cramming them into 6.2 as a
data corruption fix on the grounds that is not an acceptable state of
affairs.

OTOH we're past -rc7, which is **really late** to be changing core code.
Then again, there aren't so many fsdax users and nobody's complained
about 6.0/6.1 being busted, so perhaps the risk of regression isn't so
bad?  Then again, that could be a sign that this could wait, if you and
Andrew are really eager to merge the reworks.

Just looking at the stuff that's still broken with dax+reflink -- I
noticed that xfs/550-552 (aka the dax poison tests) are still regressing
on reflink filesystems.

So, uh, what would this patchset need to change if the "fsdax page
reference counting reworks" were applied?  Would it be changing the page
refcount instead of stashing that in page->index?

--D

> > Shiyang Ruan (2):
> >   fsdax,xfs: fix warning messages at dax_[dis]associate_entry()
> >   fsdax,xfs: port unshare to fsdax
> > 
> >  fs/dax.c             | 166 ++++++++++++++++++++++++++++++-------------
> >  fs/xfs/xfs_iomap.c   |   6 +-
> >  fs/xfs/xfs_reflink.c |   8 ++-
> >  include/linux/dax.h  |   2 +
> >  4 files changed, 129 insertions(+), 53 deletions(-)
> > 
> > -- 
> > 2.38.1

