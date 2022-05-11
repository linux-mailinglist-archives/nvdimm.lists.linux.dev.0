Return-Path: <nvdimm+bounces-3802-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC48522C2A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 May 2022 08:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1708A280A92
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 May 2022 06:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C92C15D6;
	Wed, 11 May 2022 06:21:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C1E15A5
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 06:21:25 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D9E8B10E6B15;
	Wed, 11 May 2022 16:21:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nofip-00AaTy-9h; Wed, 11 May 2022 16:21:19 +1000
Date: Wed, 11 May 2022 16:21:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jane Chu <jane.chu@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>, linmiaohe@huawei.com
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Message-ID: <20220511062119.GI1098723@dread.disaster.area>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia>
 <20220511014818.GE1098723@dread.disaster.area>
 <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com>
 <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
 <20220511024301.GD27195@magnolia>
 <20220510222428.0cc8a50bd007474c97b050b2@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510222428.0cc8a50bd007474c97b050b2@linux-foundation.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=627b55e4
	a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
	a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
	a=omOdbC7AAAAA:8 a=7-415B0cAAAA:8 a=37abNmnZhWSmtZz8jCkA:9
	a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Tue, May 10, 2022 at 10:24:28PM -0700, Andrew Morton wrote:
> On Tue, 10 May 2022 19:43:01 -0700 "Darrick J. Wong" <djwong@kernel.org> wrote:
> 
> > On Tue, May 10, 2022 at 07:28:53PM -0700, Andrew Morton wrote:
> > > On Tue, 10 May 2022 18:55:50 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> > > 
> > > > > It'll need to be a stable branch somewhere, but I don't think it
> > > > > really matters where al long as it's merged into the xfs for-next
> > > > > tree so it gets filesystem test coverage...
> > > > 
> > > > So how about let the notify_failure() bits go through -mm this cycle,
> > > > if Andrew will have it, and then the reflnk work has a clean v5.19-rc1
> > > > baseline to build from?
> > > 
> > > What are we referring to here?  I think a minimal thing would be the
> > > memremap.h and memory-failure.c changes from
> > > https://lkml.kernel.org/r/20220508143620.1775214-4-ruansy.fnst@fujitsu.com ?
> > > 
> > > Sure, I can scoot that into 5.19-rc1 if you think that's best.  It
> > > would probably be straining things to slip it into 5.19.
> > > 
> > > The use of EOPNOTSUPP is a bit suspect, btw.  It *sounds* like the
> > > right thing, but it's a networking errno.  I suppose livable with if it
> > > never escapes the kernel, but if it can get back to userspace then a
> > > user would be justified in wondering how the heck a filesystem
> > > operation generated a networking errno?
> > 
> > <shrug> most filesystems return EOPNOTSUPP rather enthusiastically when
> > they don't know how to do something...
> 
> Can it propagate back to userspace?

Maybe not this one, but the point Darrick is making is that we
really don't care if it does because we've been propagating it to
userspace in documented filesystem APIs for at least 15 years now.

e.g:

$ man 2 fallocate
.....
Errors
.....
       EOPNOTSUPP
	     The filesystem containing the file referred to by fd
	     does not support this operation; or the mode is not
	     supported by the filesystem containing the file
	     referred to by fd.
.....

Other random examples:

pwritev2(RWF_NOWAIT) can return -EOPNOTSUPP on buffered writes.
Documented in the man page.

FICLONERANGE on an filesystem that doesn't support reflink will
return -EOPNOTSUPP. Documented in the man page.

mmap(MAP_SYNC) returns -EOPNOTSUPP if the underlying filesystem
and/or storage doesn't support DAX. Documented in the man page.

I could go on, but I think I've made the point already...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

