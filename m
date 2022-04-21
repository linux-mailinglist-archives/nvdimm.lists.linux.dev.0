Return-Path: <nvdimm+bounces-3630-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D7E509603
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 06:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6BAD280A79
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 04:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C88C1849;
	Thu, 21 Apr 2022 04:35:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057E67A
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 04:35:08 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EB00153454A;
	Thu, 21 Apr 2022 14:35:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nhOX0-002eRf-Fr; Thu, 21 Apr 2022 14:35:02 +1000
Date: Thu, 21 Apr 2022 14:35:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jane Chu <jane.chu@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: [PATCH v13 0/7] fsdax: introduce fs query to support reflink
Message-ID: <20220421043502.GS1544202@dread.disaster.area>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220421012045.GR1544202@dread.disaster.area>
 <86cb0ada-208c-02de-dbc9-53c6014892c3@fujitsu.com>
 <CAPcyv4i0Noum8hqHtCpdM5HMVdmNHm3Aj2JCnZ+KZLgceiXYaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4i0Noum8hqHtCpdM5HMVdmNHm3Aj2JCnZ+KZLgceiXYaA@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6260defb
	a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
	a=IkcTkHD0fZMA:10 a=z0gMJWrwH1QA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8
	a=JfrnYn6hAAAA:8 a=7-415B0cAAAA:8 a=4wxXsGBeZjQiNu9EbwgA:9
	a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=1CNFftbPRP8L7MoqJWF3:22
	a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Apr 20, 2022 at 07:20:07PM -0700, Dan Williams wrote:
> [ add Andrew and Naoya ]
> 
> On Wed, Apr 20, 2022 at 6:48 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> >
> > Hi Dave,
> >
> > 在 2022/4/21 9:20, Dave Chinner 写道:
> > > Hi Ruan,
> > >
> > > On Tue, Apr 19, 2022 at 12:50:38PM +0800, Shiyang Ruan wrote:
> > >> This patchset is aimed to support shared pages tracking for fsdax.
> > >
> > > Now that this is largely reviewed, it's time to work out the
> > > logistics of merging it.
> >
> > Thanks!
> >
> > >
> > >> Changes since V12:
> > >>    - Rebased onto next-20220414
> > >
> > > What does this depend on that is in the linux-next kernel?
> > >
> > > i.e. can this be applied successfully to a v5.18-rc2 kernel without
> > > needing to drag in any other patchsets/commits/trees?
> >
> > Firstly, I tried to apply to v5.18-rc2 but it failed.
> >
> > There are some changes in memory-failure.c, which besides my Patch-02
> >    "mm/hwpoison: fix race between hugetlb free/demotion and
> > memory_failure_hugetlb()"
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=423228ce93c6a283132be38d442120c8e4cdb061
> >
> > Then, why it is on linux-next is: I was told[1] there is a better fix
> > about "pgoff_address()" in linux-next:
> >    "mm: rmap: introduce pfn_mkclean_range() to cleans PTEs"
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=65c9605009f8317bb3983519874d755a0b2ca746
> > so I rebased my patches to it and dropped one of mine.
> >
> > [1] https://lore.kernel.org/linux-xfs/YkPuooGD139Wpg1v@infradead.org/
> 
> From my perspective, once something has -mm dependencies it needs to
> go through Andrew's tree, and if it's going through Andrew's tree I
> think that means the reflink side of this needs to wait a cycle as
> there is no stable point that the XFS tree could merge to build on top
> of.

Ngggh. Still? Really?

Sure, I'm not a maintainer and just the stand-in patch shepherd for
a single release. However, being unable to cleanly merge code we
need integrated into our local subsystem tree for integration
testing because a patch dependency with another subsystem won't gain
a stable commit ID until the next merge window is .... distinctly
suboptimal.

We know how to do this cleanly, quickly and efficiently - we've been
doing cross-subsystem shared git branch co-ordination for
VFS/fs/block stuff when needed for many, many years. It's pretty
easy to do, just requires clear communication to decide where the
source branch will be kept. It doesn't even matter what order Linus
then merges the trees - they are self contained and git sorts out
the duplicated commits without an issue.

I mean, we've been using git for *17 years* now - this stuff should
be second nature to maintainers by now. So how is it still
considered acceptible for a core kernel subsystem not to have the
ability to provide other subsystems with stable commits/branches
so we can cleanly develop cross-subsystem functionality quickly and
efficiently?

> The last reviewed-by this wants before going through there is Naoya's
> on the memory-failure.c changes.

Naoya? 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

