Return-Path: <nvdimm+bounces-828-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D50D03E870F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 02:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A3A721C0F4E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 00:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C9D2FB9;
	Wed, 11 Aug 2021 00:12:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09268177
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 00:12:25 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B88260F25;
	Wed, 11 Aug 2021 00:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628640745;
	bh=Yt+kMsdwDL774Fw12K5/rXYBwm/6VkmxXAJo596EOLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qsvFf+9yjcOSRNcrVsO/gzcg8fVOCoQGvIdVmkyqNvaa5gfNs1gycd3HQ9oOgNuDl
	 2CfDkDEe1kBGZoZEunIQWZ5l6jg6af5osq9daEzxX+/VHUNhAJPur/gWDP+9GscT6w
	 nXKyf4PPYMzUCYaqA4Pk/dUFE7DDQNhZB8NJyEmBAC4PtjpB9iLZ8n3oBV+FMbg3kg
	 YyeGgbs10NGClZGhKxMjuEhTulWOupOxR5RFqY3MC0Yo0XmBetX5f7uvHqnxXWyBB4
	 sGtTVas3Wm9zUuqgBy4J8I16tEpVHxle0AaMc1b1ciapJTHWtpJhORQ3LicVpk0o9H
	 c8QdRduuAPmkA==
Date: Tue, 10 Aug 2021 17:12:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 21/30] iomap: switch iomap_seek_data to use iomap_iter
Message-ID: <20210811001225.GS3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-22-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-22-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:35AM +0200, Christoph Hellwig wrote:
> Rewrite iomap_seek_data to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/seek.c | 47 ++++++++++++++++++++++++-----------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> index fed8f9005f9e46..a845c012b50c67 100644
> --- a/fs/iomap/seek.c
> +++ b/fs/iomap/seek.c
> @@ -56,47 +56,48 @@ iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
>  }
>  EXPORT_SYMBOL_GPL(iomap_seek_hole);
>  
> -static loff_t
> -iomap_seek_data_actor(struct inode *inode, loff_t start, loff_t length,
> -		      void *data, struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_seek_data_iter(const struct iomap_iter *iter,
> +		loff_t *hole_pos)
>  {
> -	loff_t offset = start;
> +	loff_t length = iomap_length(iter);
>  
> -	switch (iomap->type) {
> +	switch (iter->iomap.type) {
>  	case IOMAP_HOLE:
>  		return length;
>  	case IOMAP_UNWRITTEN:
> -		offset = mapping_seek_hole_data(inode->i_mapping, start,
> -				start + length, SEEK_DATA);
> -		if (offset < 0)
> +		*hole_pos = mapping_seek_hole_data(iter->inode->i_mapping,
> +				iter->pos, iter->pos + length, SEEK_DATA);
> +		if (*hole_pos < 0)
>  			return length;
> -		fallthrough;
> +		return 0;
>  	default:
> -		*(loff_t *)data = offset;
> +		*hole_pos = iter->pos;
>  		return 0;
>  	}
>  }
>  
>  loff_t
> -iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
> +iomap_seek_data(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
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
> -				  ops, &offset, iomap_seek_data_actor);
> -		if (ret < 0)
> -			return ret;
> -		if (ret == 0)
> -			return offset;
> -		offset += ret;
> -	}
> -
> +	iter.len = size - pos;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_seek_data_iter(&iter, &pos);
> +	if (ret < 0)
> +		return ret;
> +	if (iter.len) /* found data before EOF */
> +		return pos;
>  	/* We've reached the end of the file without finding data */
>  	return -ENXIO;
>  }
> -- 
> 2.30.2
> 

