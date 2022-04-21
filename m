Return-Path: <nvdimm+bounces-3627-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9895094AF
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 03:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 012D32E0CC4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Apr 2022 01:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9430D1865;
	Thu, 21 Apr 2022 01:40:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA2A1840
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 01:40:05 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A59B8534640;
	Thu, 21 Apr 2022 11:20:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nhLUz-002b2q-G6; Thu, 21 Apr 2022 11:20:45 +1000
Date: Thu, 21 Apr 2022 11:20:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v13 0/7] fsdax: introduce fs query to support reflink
Message-ID: <20220421012045.GR1544202@dread.disaster.area>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6260b170
	a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
	a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
	a=7EZY2-qYyHQqCbfsKPUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

Hi Ruan,

On Tue, Apr 19, 2022 at 12:50:38PM +0800, Shiyang Ruan wrote:
> This patchset is aimed to support shared pages tracking for fsdax.

Now that this is largely reviewed, it's time to work out the
logistics of merging it.

> Changes since V12:
>   - Rebased onto next-20220414

What does this depend on that is in the linux-next kernel?

i.e. can this be applied successfully to a v5.18-rc2 kernel without
needing to drag in any other patchsets/commits/trees?

What are your plans for the followup patches that enable
reflink+fsdax in XFS? AFAICT that patchset hasn't been posted for
while so I don't know what it's status is. Is that patchset anywhere
near ready for merge in this cycle?

If that patchset is not a candidate for this cycle, then it largely
doesn't matter what tree this is merged through as there shouldn't
be any major XFS or dax dependencies being built on top of it during
this cycle. The filesystem side changes are isolated and won't
conflict with other work in XFS, either, so this could easily go
through Dan's tree.

However, if the reflink enablement is ready to go, then this all
needs to be in the XFS tree so that we can run it through filesystem
level DAX+reflink testing. That will mean we need this in a stable
shared topic branch and tighter co-ordination between the trees.

So before we go any further we need to know if the dax+reflink
enablement patchset is near being ready to merge....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

