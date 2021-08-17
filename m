Return-Path: <nvdimm+bounces-889-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E19C3EE4B0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Aug 2021 05:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0273E3E0F48
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Aug 2021 03:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1A96D24;
	Tue, 17 Aug 2021 03:00:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A73B173
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 03:00:04 +0000 (UTC)
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AFB4F869CF3;
	Tue, 17 Aug 2021 12:34:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1mFow9-001ajs-JP; Tue, 17 Aug 2021 12:34:45 +1000
Date: Tue, 17 Aug 2021 12:34:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH v2.1 11/30] iomap: add the new iomap_iter model
Message-ID: <20210817023445.GG3657114@dread.disaster.area>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-12-hch@lst.de>
 <20210811191720.GG3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811191720.GG3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
	a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
	a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8
	a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=25Yfc8azc3NZfLh1rZQA:9
	a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=AjGcO6oz07-iQ99wixmX:22
	a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Aug 11, 2021 at 12:17:20PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The iomap_iter struct provides a convenient way to package up and
> maintain all the arguments to the various mapping and operation
> functions.  It is operated on using the iomap_iter() function that
> is called in loop until the whole range has been processed.  Compared
> to the existing iomap_apply() function this avoid an indirect call
> for each iteration.
> 
> For now iomap_iter() calls back into the existing ->iomap_begin and
> ->iomap_end methods, but in the future this could be further optimized
> to avoid indirect calls entirely.
> 
> Based on an earlier patch from Matthew Wilcox <willy@infradead.org>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [djwong: add to apply.c to preserve git history of iomap loop control]
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks like a straight translation of Christoph's original. Seems
fine to me as a simepl step towards preserving the git history.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

