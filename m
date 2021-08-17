Return-Path: <nvdimm+bounces-891-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC0F3EE4C7
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Aug 2021 05:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 362CC1C0648
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Aug 2021 03:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D1E6D24;
	Tue, 17 Aug 2021 03:08:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail110.syd.optusnet.com.au (mail110.syd.optusnet.com.au [211.29.132.97])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1E1173
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 03:08:36 +0000 (UTC)
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
	by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 9EE2910B065;
	Tue, 17 Aug 2021 12:36:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1mFoxq-001alS-8K; Tue, 17 Aug 2021 12:36:30 +1000
Date: Tue, 17 Aug 2021 12:36:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH v2.1 24/30] iomap: remove iomap_apply
Message-ID: <20210817023630.GI3657114@dread.disaster.area>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-25-hch@lst.de>
 <20210811191826.GI3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811191826.GI3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
	a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
	a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
	a=7-415B0cAAAA:8 a=fYQ17_Ti0f76tTSopgYA:9 a=CjuIK1q_8ugA:10
	a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Aug 11, 2021 at 12:18:26PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> iomap_apply is unused now, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [djwong: rebase this patch to preserve git history of iomap loop control]
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/apply.c      |   91 -------------------------------------------------
>  fs/iomap/trace.h      |   40 ----------------------
>  include/linux/iomap.h |   10 -----
>  3 files changed, 141 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

