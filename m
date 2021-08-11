Return-Path: <nvdimm+bounces-829-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id C25783E8716
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 02:13:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 5117F3E14CF
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 00:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D3F6D00;
	Wed, 11 Aug 2021 00:13:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C202FB8
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 00:13:17 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D56260F55;
	Wed, 11 Aug 2021 00:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628640797;
	bh=/fOcg1dl4Xjqdn4SOoikXdodyoSAvsQkw3o7YM/HjAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HhMbugBqEMoHU6ngmGQUZuIhUwkxgBDMUy+PuTuYnsCsvpYfbupQhSnLDckECUbec
	 sjm6bTKl5cMKnijTbR2VLbk8JeS4i9xmtXhj0p3BUhV1/+n3cQyrk+ma1rbZlZMDy7
	 ckAoNQ7rrcyoWhg7rhBbxv1jLR+gMrqPWcMgBu0gzQsPLScSj2/85tbolSQfOx4Or4
	 lQmKZ9SQWf+mVUvu/exBvSAyKH0/42PyUfzMvXmGnSoR/ciJB1Ie5DSMxCtKbSGesd
	 VowK1r2e0+bGZ+1MR/DegLB8phV5ut79yTueQU93n+JsD4nqfm8jFc/4xz9cQWLv0W
	 fLpv59NDc2JXA==
Date: Tue, 10 Aug 2021 17:13:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 20/30] iomap: switch iomap_seek_hole to use iomap_iter
Message-ID: <20210811001316.GT3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-21-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:34AM +0200, Christoph Hellwig wrote:
> Rewrite iomap_seek_hole to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/seek.c | 51 +++++++++++++++++++++++++------------------------
>  1 file changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> index ce6fb810854fec..fed8f9005f9e46 100644
> --- a/fs/iomap/seek.c
> +++ b/fs/iomap/seek.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) 2017 Red Hat, Inc.
> - * Copyright (c) 2018 Christoph Hellwig.
> + * Copyright (c) 2018-2021 Christoph Hellwig.
>   */
>  #include <linux/module.h>
>  #include <linux/compiler.h>
> @@ -10,21 +10,20 @@
>  #include <linux/pagemap.h>
>  #include <linux/pagevec.h>
>  
> -static loff_t
> -iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
> -		      void *data, struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter,
> +		loff_t *hole_pos)
>  {
> -	loff_t offset = start;
> +	loff_t length = iomap_length(iter);
>  
> -	switch (iomap->type) {
> +	switch (iter->iomap.type) {
>  	case IOMAP_UNWRITTEN:
> -		offset = mapping_seek_hole_data(inode->i_mapping, start,
> -				start + length, SEEK_HOLE);
> -		if (offset == start + length)
> +		*hole_pos = mapping_seek_hole_data(iter->inode->i_mapping,
> +				iter->pos, iter->pos + length, SEEK_HOLE);
> +		if (*hole_pos == iter->pos + length)
>  			return length;
> -		fallthrough;
> +		return 0;
>  	case IOMAP_HOLE:
> -		*(loff_t *)data = offset;
> +		*hole_pos = iter->pos;
>  		return 0;
>  	default:
>  		return length;
> @@ -32,26 +31,28 @@ iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
>  }
>  
>  loff_t
> -iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
> +iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
>  {
>  	loff_t size = i_size_read(inode);
> -	loff_t ret;
> +	struct iomap_iter iter = {
> +		.inode	= inode,
> +		.pos	= pos,
> +		.flags	= IOMAP_REPORT,
> +	};
> +	int ret;
>  
>  	/* Nothing to be found before or beyond the end of the file. */
> -	if (offset < 0 || offset >= size)
> +	if (pos < 0 || pos >= size)
>  		return -ENXIO;
>  
> -	while (offset < size) {
> -		ret = iomap_apply(inode, offset, size - offset, IOMAP_REPORT,
> -				  ops, &offset, iomap_seek_hole_actor);
> -		if (ret < 0)
> -			return ret;
> -		if (ret == 0)
> -			break;
> -		offset += ret;
> -	}
> -
> -	return offset;
> +	iter.len = size - pos;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_seek_hole_iter(&iter, &pos);
> +	if (ret < 0)
> +		return ret;
> +	if (iter.len) /* found hole before EOF */
> +		return pos;
> +	return size;
>  }
>  EXPORT_SYMBOL_GPL(iomap_seek_hole);
>  
> -- 
> 2.30.2
> 

