Return-Path: <nvdimm+bounces-3677-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 11CE550C540
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 02:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 06A142E09C7
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 00:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8289633FD;
	Sat, 23 Apr 2022 00:01:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF4233EA
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 00:01:32 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 060F35345C6;
	Sat, 23 Apr 2022 10:01:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1ni3DF-003Ms4-8J; Sat, 23 Apr 2022 10:01:21 +1000
Date: Sat, 23 Apr 2022 10:01:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: [PATCH v13 0/7] fsdax: introduce fs query to support reflink
Message-ID: <20220423000121.GH1544202@dread.disaster.area>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220421012045.GR1544202@dread.disaster.area>
 <86cb0ada-208c-02de-dbc9-53c6014892c3@fujitsu.com>
 <CAPcyv4i0Noum8hqHtCpdM5HMVdmNHm3Aj2JCnZ+KZLgceiXYaA@mail.gmail.com>
 <20220421043502.GS1544202@dread.disaster.area>
 <YmDxs1Hj4H/cu2sd@infradead.org>
 <20220421074653.GT1544202@dread.disaster.area>
 <CAPcyv4jj_Z+P4BuC6EXXrzbVr1uHomQVu1A+cq55EFnSGmP7cQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jj_Z+P4BuC6EXXrzbVr1uHomQVu1A+cq55EFnSGmP7cQ@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=626341d5
	a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
	a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
	a=N97b58O49P40uwd1XQkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Fri, Apr 22, 2022 at 02:27:32PM -0700, Dan Williams wrote:
> On Thu, Apr 21, 2022 at 12:47 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Apr 20, 2022 at 10:54:59PM -0700, Christoph Hellwig wrote:
> > > On Thu, Apr 21, 2022 at 02:35:02PM +1000, Dave Chinner wrote:
> > > > Sure, I'm not a maintainer and just the stand-in patch shepherd for
> > > > a single release. However, being unable to cleanly merge code we
> > > > need integrated into our local subsystem tree for integration
> > > > testing because a patch dependency with another subsystem won't gain
> > > > a stable commit ID until the next merge window is .... distinctly
> > > > suboptimal.
> > >
> > > Yes.  Which is why we've taken a lot of mm patchs through other trees,
> > > sometimes specilly crafted for that.  So I guess in this case we'll
> > > just need to take non-trivial dependencies into the XFS tree, and just
> > > deal with small merge conflicts for the trivial ones.
> >
> > OK. As Naoyo has pointed out, the first dependency/conflict Ruan has
> > listed looks trivial to resolve.
> >
> > The second dependency, OTOH, is on a new function added in the patch
> > pointed to. That said, at first glance it looks to be independent of
> > the first two patches in that series so I might just be able to pull
> > that one patch in and have that leave us with a working
> > fsdax+reflink tree.
> >
> > Regardless, I'll wait to see how much work the updated XFS/DAX
> > reflink enablement patchset still requires when Ruan posts it before
> > deciding what to do here.  If it isn't going to be a merge
> > candidate, what to do with this patchset is moot because there's
> > little to test without reflink enabled...
> 
> I do have a use case for this work absent the reflink work.  Recall we
> had a conversation about how to communicate "dax-device has been
> ripped away from the fs" events and we ended up on the idea of reusing
> ->notify_failure(), but with the device's entire logical address range
> as the notification span. That will let me unwind and delete the
> PTE_DEVMAP infrastructure for taking extra device references to hold
> off device-removal. Instead ->notify_failure() arranges for all active
> DAX mappings to be invalidated and allow the removal to proceed
> especially since physical removal does not care about software pins.

Sure. My point is that if the reflink enablement isn't ready to go,
then from an XFS POV none of this matters in this cycle and we can
just leave the dependencies to commit via Andrew's tree. Hence by
the time we get to the reflink enablement all the prior dependencies
will have been merged and have stable commit IDs, and we can just
stage this series and the reflink enablement as we normally would in
the next cycle.

However, if we don't get the XFS reflink dax enablement sorted out
in the next week or two, then we don't need this patchset in this
cycle. Hence if you still need this patchset for other code you need
to merge in this cycle, then you're the poor schmuck that has to run
the mm-tree conflict guantlet to get a stable commit ID for the
dependent patches in this cycle, not me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

