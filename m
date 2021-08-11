Return-Path: <nvdimm+bounces-825-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D1613E86F8
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 02:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 9381F3E14A5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 00:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941422FB9;
	Wed, 11 Aug 2021 00:05:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3B6177
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 00:05:38 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F340861019;
	Wed, 11 Aug 2021 00:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628640338;
	bh=WOt9HlI6bm2svbXnH2JhtreKegkyLKTBhiqXzndv+84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tuBMp4izhgJTlVOiLT5X+xMRSMdaPbYH9TUQA/5NpjT+rNjx2qtbsNRsX6WPbwPVN
	 +xdcdjB8xkpxExs/3tsVdY7hxt5R4RX8fdZARBPMhLD0DzLI87AXcvUxUzfDv/6Y88
	 zTpT4mrzt32OWmEPPoB8YMque912w7xySssU3Md4dyL8MYhRtNDB8dSjO7Zm6mSWcm
	 cv95tQGgxQ7362fAwYmm+rLHlkoLO0vxOZvGJy3zY09KQ/tVd9WJI6qMxeYqzoTt2Z
	 Ejbq903wP8BP1jvFqDJbglMNT9vtATyFg1lQAVNFL1hmxv6d3WaIYwf4xUsGsCmR38
	 dpNBjd/fqY5nw==
Date: Tue, 10 Aug 2021 17:05:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 18/30] iomap: switch iomap_fiemap to use iomap_iter
Message-ID: <20210811000537.GP3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-19-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:32AM +0200, Christoph Hellwig wrote:
> Rewrite the ->fiemap implementation based on iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanups!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/fiemap.c | 70 ++++++++++++++++++++---------------------------
>  1 file changed, 29 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
> index aab070df4a2175..acad09a8c188df 100644
> --- a/fs/iomap/fiemap.c
> +++ b/fs/iomap/fiemap.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright (c) 2016-2018 Christoph Hellwig.
> + * Copyright (c) 2016-2021 Christoph Hellwig.
>   */
>  #include <linux/module.h>
>  #include <linux/compiler.h>
> @@ -8,13 +8,8 @@
>  #include <linux/iomap.h>
>  #include <linux/fiemap.h>
>  
> -struct fiemap_ctx {
> -	struct fiemap_extent_info *fi;
> -	struct iomap prev;
> -};
> -
>  static int iomap_to_fiemap(struct fiemap_extent_info *fi,
> -		struct iomap *iomap, u32 flags)
> +		const struct iomap *iomap, u32 flags)
>  {
>  	switch (iomap->type) {
>  	case IOMAP_HOLE:
> @@ -43,24 +38,22 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
>  			iomap->length, flags);
>  }
>  
> -static loff_t
> -iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> -		struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_fiemap_iter(const struct iomap_iter *iter,
> +		struct fiemap_extent_info *fi, struct iomap *prev)
>  {
> -	struct fiemap_ctx *ctx = data;
> -	loff_t ret = length;
> +	int ret;
>  
> -	if (iomap->type == IOMAP_HOLE)
> -		return length;
> +	if (iter->iomap.type == IOMAP_HOLE)
> +		return iomap_length(iter);
>  
> -	ret = iomap_to_fiemap(ctx->fi, &ctx->prev, 0);
> -	ctx->prev = *iomap;
> +	ret = iomap_to_fiemap(fi, prev, 0);
> +	*prev = iter->iomap;
>  	switch (ret) {
>  	case 0:		/* success */
> -		return length;
> +		return iomap_length(iter);
>  	case 1:		/* extent array full */
>  		return 0;
> -	default:
> +	default:	/* error */
>  		return ret;
>  	}
>  }
> @@ -68,38 +61,33 @@ iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  		u64 start, u64 len, const struct iomap_ops *ops)
>  {
> -	struct fiemap_ctx ctx;
> -	loff_t ret;
> -
> -	memset(&ctx, 0, sizeof(ctx));
> -	ctx.fi = fi;
> -	ctx.prev.type = IOMAP_HOLE;
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= start,
> +		.len		= len,
> +		.flags		= IOMAP_REPORT,
> +	};
> +	struct iomap prev = {
> +		.type		= IOMAP_HOLE,
> +	};
> +	int ret;
>  
> -	ret = fiemap_prep(inode, fi, start, &len, 0);
> +	ret = fiemap_prep(inode, fi, start, &iter.len, 0);
>  	if (ret)
>  		return ret;
>  
> -	while (len > 0) {
> -		ret = iomap_apply(inode, start, len, IOMAP_REPORT, ops, &ctx,
> -				iomap_fiemap_actor);
> -		/* inode with no (attribute) mapping will give ENOENT */
> -		if (ret == -ENOENT)
> -			break;
> -		if (ret < 0)
> -			return ret;
> -		if (ret == 0)
> -			break;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_fiemap_iter(&iter, fi, &prev);
>  
> -		start += ret;
> -		len -= ret;
> -	}
> -
> -	if (ctx.prev.type != IOMAP_HOLE) {
> -		ret = iomap_to_fiemap(fi, &ctx.prev, FIEMAP_EXTENT_LAST);
> +	if (prev.type != IOMAP_HOLE) {
> +		ret = iomap_to_fiemap(fi, &prev, FIEMAP_EXTENT_LAST);
>  		if (ret < 0)
>  			return ret;
>  	}
>  
> +	/* inode with no (attribute) mapping will give ENOENT */
> +	if (ret < 0 && ret != -ENOENT)
> +		return ret;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iomap_fiemap);
> -- 
> 2.30.2
> 

