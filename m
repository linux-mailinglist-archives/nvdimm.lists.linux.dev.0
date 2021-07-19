Return-Path: <nvdimm+bounces-582-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD1E3CEF01
	for <lists+linux-nvdimm@lfdr.de>; Tue, 20 Jul 2021 00:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 7371B3E1165
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 22:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433AB2FB6;
	Mon, 19 Jul 2021 22:20:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail107.syd.optusnet.com.au (mail107.syd.optusnet.com.au [211.29.132.53])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3A072
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 22:20:38 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
	by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D3E955E74;
	Tue, 20 Jul 2021 07:48:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1m5b7u-008UI5-A0; Tue, 20 Jul 2021 07:48:38 +1000
Date: Tue, 20 Jul 2021 07:48:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 08/27] iomap: add the new iomap_iter model
Message-ID: <20210719214838.GK664593@dread.disaster.area>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-9-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
	a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
	a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=JfrnYn6hAAAA:8 a=7-415B0cAAAA:8
	a=7pAWPZz2LBkM90URnJoA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
	a=biEYGPWJfzWAr4FL6Ov7:22

On Mon, Jul 19, 2021 at 12:35:01PM +0200, Christoph Hellwig wrote:
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
> ---
>  fs/iomap/Makefile     |  1 +
>  fs/iomap/iter.c       | 74 +++++++++++++++++++++++++++++++++++++++++++
>  fs/iomap/trace.h      | 37 +++++++++++++++++++++-
>  include/linux/iomap.h | 56 ++++++++++++++++++++++++++++++++
>  4 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 fs/iomap/iter.c
> 
> diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
> index eef2722d93a183..85034deb5a2f19 100644
> --- a/fs/iomap/Makefile
> +++ b/fs/iomap/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_FS_IOMAP)		+= iomap.o
>  
>  iomap-y				+= trace.o \
>  				   apply.o \
> +				   iter.o \

Can we break this cycle of creating new files and removing old files
when changing the iomap core code? It breaks the ability to troll
git history easily through git blame and other techniques that are
file based.

If we are going to create a new file, then the core iomap code that
every thing depends on should just be in a neutrally names file such
as "iomap.c" so that we don't need to play these games in future.

....

> +/**
> + * iomap_iter - iterate over a ranges in a file
> + * @iter: iteration structue
> + * @ops: iomap ops provided by the file system
> + *
> + * Iterate over file system provided contiguous ranges of blocks with the same
> + * state.  Should be called in a loop that continues as long as this function
> + * returns a positive value.  If 0 or a negative value is returned the caller
> + * should break out of the loop - a negative value is an error either from the
> + * file system or from the last iteration stored in @iter.copied.
> + */
> +int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +{

We should avoid namespace conflicts where function names shadow
object types. iomap_iterate() is fine as the function name - there's
no need for abbreviation here because it's not an overly long name.
This will makes it clearly different to the struct iomap_iter that
is passed to it and it will also make grep, cscope and other
code searching tools much more precise...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

