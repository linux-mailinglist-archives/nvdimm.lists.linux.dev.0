Return-Path: <nvdimm+bounces-3639-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F97509971
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 09:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id B30FF2E0CF6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 07:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63B31FA2;
	Thu, 21 Apr 2022 07:47:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA52046A8
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 07:46:59 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2C10310E5C0F;
	Thu, 21 Apr 2022 17:46:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nhRWf-002hck-5w; Thu, 21 Apr 2022 17:46:53 +1000
Date: Thu, 21 Apr 2022 17:46:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20220421074653.GT1544202@dread.disaster.area>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220421012045.GR1544202@dread.disaster.area>
 <86cb0ada-208c-02de-dbc9-53c6014892c3@fujitsu.com>
 <CAPcyv4i0Noum8hqHtCpdM5HMVdmNHm3Aj2JCnZ+KZLgceiXYaA@mail.gmail.com>
 <20220421043502.GS1544202@dread.disaster.area>
 <YmDxs1Hj4H/cu2sd@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmDxs1Hj4H/cu2sd@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62610bf2
	a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
	a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
	a=Mb5XfCdAhjU6mY5isQ0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Apr 20, 2022 at 10:54:59PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 21, 2022 at 02:35:02PM +1000, Dave Chinner wrote:
> > Sure, I'm not a maintainer and just the stand-in patch shepherd for
> > a single release. However, being unable to cleanly merge code we
> > need integrated into our local subsystem tree for integration
> > testing because a patch dependency with another subsystem won't gain
> > a stable commit ID until the next merge window is .... distinctly
> > suboptimal.
> 
> Yes.  Which is why we've taken a lot of mm patchs through other trees,
> sometimes specilly crafted for that.  So I guess in this case we'll
> just need to take non-trivial dependencies into the XFS tree, and just
> deal with small merge conflicts for the trivial ones.

OK. As Naoyo has pointed out, the first dependency/conflict Ruan has
listed looks trivial to resolve.

The second dependency, OTOH, is on a new function added in the patch
pointed to. That said, at first glance it looks to be independent of
the first two patches in that series so I might just be able to pull
that one patch in and have that leave us with a working
fsdax+reflink tree.

Regardless, I'll wait to see how much work the updated XFS/DAX
reflink enablement patchset still requires when Ruan posts it before
deciding what to do here.  If it isn't going to be a merge
candidate, what to do with this patchset is moot because there's
little to test without reflink enabled...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

