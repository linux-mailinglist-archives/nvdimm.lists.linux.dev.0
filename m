Return-Path: <nvdimm+bounces-3866-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF6553BD1A
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Jun 2022 19:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id A94FD2E09DA
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Jun 2022 17:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5432578;
	Thu,  2 Jun 2022 17:18:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655F6256E
	for <nvdimm@lists.linux.dev>; Thu,  2 Jun 2022 17:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED6FC385A5;
	Thu,  2 Jun 2022 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1654190290;
	bh=yvMCqcIkN04XCQCazhzNm5Hd0sdQb5u+JJpsej1prc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R8N7Q5zwXYT7j0jH/IObwgf2hA9tapYuG47nLB8X0SrGqBQ1La7VSmhLpDkS32XIq
	 S9H54UFf4Y65c85S3krHVyTxCPz3t3xxr8jq6aIUp837Z3sD3Kc3HfeiLGvYT/kFoX
	 MoJ92ALYZCGrfeshTUca09gEzjD1s7qybmAjZANhO099nDAGRgLRMTw09tZ6EHUdy1
	 R5o1fLRmVKzb0nAX08uhT547ZCYP71LRYg7ehY0Pw+BySOLA3YhRQgyeU2nnExbi/9
	 gxg/EJOlnGijIMRqfAOz01rivpiDU2pvcGYj+ZTgOovnFJ1jFeDP42OXA/PBuLNZ7i
	 OEWlHh+yxkhgA==
Date: Thu, 2 Jun 2022 10:18:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>, linmiaohe@huawei.com
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Message-ID: <Ypjw0bldEIFp9+YG@magnolia>
References: <20220511000352.GY27195@magnolia>
 <20220511014818.GE1098723@dread.disaster.area>
 <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com>
 <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
 <20220511024301.GD27195@magnolia>
 <20220510222428.0cc8a50bd007474c97b050b2@linux-foundation.org>
 <20220511151955.GC27212@magnolia>
 <CAPcyv4gwV5ReuCUbJHZPVPUJjnaGFWibCLLsH-XEgyvbn9RkWA@mail.gmail.com>
 <32f51223-c671-1dc0-e14a-8887863d9071@fujitsu.com>
 <1007e895-a0e3-9a82-2524-bb7e8a0b6b8c@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1007e895-a0e3-9a82-2524-bb7e8a0b6b8c@fujitsu.com>

On Thu, Jun 02, 2022 at 05:42:13PM +0800, Shiyang Ruan wrote:
> Hi,
> 
> Is there any other work I should do with these two patchsets?  I think they
> are good for now.  So... since the 5.19-rc1 is coming, could the
> notify_failure() part be merged as your plan?

Hmm.  I don't see any of the patches 1-5,7-13 in current upstream, so
I'm guessing this means Andrew isn't taking it for 5.19?

--D

> 
> 
> --
> Thanks,
> Ruan.
> 
> 
> 在 2022/5/12 20:27, Shiyang Ruan 写道:
> > 
> > 
> > 在 2022/5/11 23:46, Dan Williams 写道:
> > > On Wed, May 11, 2022 at 8:21 AM Darrick J. Wong <djwong@kernel.org>
> > > wrote:
> > > > 
> > > > Oan Tue, May 10, 2022 at 10:24:28PM -0700, Andrew Morton wrote:
> > > > > On Tue, 10 May 2022 19:43:01 -0700 "Darrick J. Wong"
> > > > > <djwong@kernel.org> wrote:
> > > > > 
> > > > > > On Tue, May 10, 2022 at 07:28:53PM -0700, Andrew Morton wrote:
> > > > > > > On Tue, 10 May 2022 18:55:50 -0700 Dan Williams
> > > > > > > <dan.j.williams@intel.com> wrote:
> > > > > > > 
> > > > > > > > > It'll need to be a stable branch somewhere, but I don't think it
> > > > > > > > > really matters where al long as it's merged into the xfs for-next
> > > > > > > > > tree so it gets filesystem test coverage...
> > > > > > > > 
> > > > > > > > So how about let the notify_failure() bits go
> > > > > > > > through -mm this cycle,
> > > > > > > > if Andrew will have it, and then the reflnk work
> > > > > > > > has a clean v5.19-rc1
> > > > > > > > baseline to build from?
> > > > > > > 
> > > > > > > What are we referring to here?  I think a minimal thing would be the
> > > > > > > memremap.h and memory-failure.c changes from
> > > > > > > https://lkml.kernel.org/r/20220508143620.1775214-4-ruansy.fnst@fujitsu.com
> > > > > > > ?
> > > > > > > 
> > > > > > > Sure, I can scoot that into 5.19-rc1 if you think that's best.  It
> > > > > > > would probably be straining things to slip it into 5.19.
> > > > > > > 
> > > > > > > The use of EOPNOTSUPP is a bit suspect, btw.  It *sounds* like the
> > > > > > > right thing, but it's a networking errno.  I suppose
> > > > > > > livable with if it
> > > > > > > never escapes the kernel, but if it can get back to userspace then a
> > > > > > > user would be justified in wondering how the heck a filesystem
> > > > > > > operation generated a networking errno?
> > > > > > 
> > > > > > <shrug> most filesystems return EOPNOTSUPP rather
> > > > > > enthusiastically when
> > > > > > they don't know how to do something...
> > > > > 
> > > > > Can it propagate back to userspace?
> > > > 
> > > > AFAICT, the new code falls back to the current (mf_generic_kill_procs)
> > > > failure code if the filesystem doesn't provide a ->memory_failure
> > > > function or if it returns -EOPNOSUPP.  mf_generic_kill_procs can also
> > > > return -EOPNOTSUPP, but all the memory_failure() callers (madvise, etc.)
> > > > convert that to 0 before returning it to userspace.
> > > > 
> > > > I suppose the weirder question is going to be what happens when madvise
> > > > starts returning filesystem errors like EIO or EFSCORRUPTED when pmem
> > > > loses half its brains and even the fs can't deal with it.
> > > 
> > > Even then that notification is not in a system call context so it
> > > would still result in a SIGBUS notification not a EOPNOTSUPP return
> > > code. The only potential gap I see are what are the possible error
> > > codes that MADV_SOFT_OFFLINE might see? The man page is silent on soft
> > > offline failure codes. Shiyang, that's something to check / update if
> > > necessary.
> > 
> > According to the code around MADV_SOFT_OFFLINE, it will return -EIO when
> > the backend is NVDIMM.
> > 
> > Here is the logic:
> >   madvise_inject_error() {
> >       ...
> >       if (MADV_SOFT_OFFLINE) {
> >           ret = soft_offline_page() {
> >               ...
> >               /* Only online pages can be soft-offlined (esp., not
> > ZONE_DEVICE). */
> >               page = pfn_to_online_page(pfn);
> >               if (!page) {
> >                   put_ref_page(ref_page);
> >                   return -EIO;
> >               }
> >               ...
> >           }
> >       } else {
> >           ret = memory_failure()
> >       }
> >       return ret
> >   }
> > 
> > 
> > -- 
> > Thanks,
> > Ruan.
> > 
> > 
> 
> 

