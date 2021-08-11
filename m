Return-Path: <nvdimm+bounces-823-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0BC3E86DA
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 01:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 6FF1E1C0AD1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 23:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E4A6D00;
	Tue, 10 Aug 2021 23:54:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948FF2FB8
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 23:54:44 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17DF360F38;
	Tue, 10 Aug 2021 23:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628639684;
	bh=AV8haKON3va+IX/XR/OXY1ILfZLO1kB0OfxvrA3lTzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=USLSLnG13PQITsLD2mDDGZH2aDgy+6mYUgrczJbCZ5jLqaQEy5KlutaFp59nIxpo4
	 GBDkn3YInbaS42ydqA8axN5wXHkVBF/JS/jepyLgBqbIbZLWmjemdXf9XjUpmTP58r
	 LyfoabbENsMSLELCltHAn0SpmWxH5Pc+KlfR5D2dnUU3Wj0RKc4cNUZlCyeALBa5ij
	 HPEM1Tb9KQomkzzIsw75fr57bMzLRM0b8PWq15m2GbRMrgZKMrRqoRMxz74C3Opc9q
	 9xnerjP7C0ElM7wmBlTES65qDE6gr+NPzUklLBrhoOsgDdcuTOWSaSVcx+GQdDHP6+
	 STysCs1DmH+ag==
Date: Tue, 10 Aug 2021 16:54:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 15/30] iomap: switch iomap_zero_range to use iomap_iter
Message-ID: <20210810235443.GN3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-16-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:29AM +0200, Christoph Hellwig wrote:
> Switch iomap_zero_range to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Straightforward.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 4f525727462f33..3a23f7346938fb 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -896,11 +896,12 @@ static s64 iomap_zero(struct inode *inode, loff_t pos, u64 length,
>  	return iomap_write_end(inode, pos, bytes, bytes, page, iomap, srcmap);
>  }
>  
> -static loff_t iomap_zero_range_actor(struct inode *inode, loff_t pos,
> -		loff_t length, void *data, struct iomap *iomap,
> -		struct iomap *srcmap)
> +static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
>  {
> -	bool *did_zero = data;
> +	struct iomap *iomap = &iter->iomap;
> +	struct iomap *srcmap = iomap_iter_srcmap(iter);
> +	loff_t pos = iter->pos;
> +	loff_t length = iomap_length(iter);
>  	loff_t written = 0;
>  
>  	/* already zeroed?  we're done. */
> @@ -910,10 +911,11 @@ static loff_t iomap_zero_range_actor(struct inode *inode, loff_t pos,
>  	do {
>  		s64 bytes;
>  
> -		if (IS_DAX(inode))
> +		if (IS_DAX(iter->inode))
>  			bytes = dax_iomap_zero(pos, length, iomap);
>  		else
> -			bytes = iomap_zero(inode, pos, length, iomap, srcmap);
> +			bytes = iomap_zero(iter->inode, pos, length, iomap,
> +					   srcmap);
>  		if (bytes < 0)
>  			return bytes;
>  
> @@ -931,19 +933,17 @@ int
>  iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
>  		const struct iomap_ops *ops)
>  {
> -	loff_t ret;
> -
> -	while (len > 0) {
> -		ret = iomap_apply(inode, pos, len, IOMAP_ZERO,
> -				ops, did_zero, iomap_zero_range_actor);
> -		if (ret <= 0)
> -			return ret;
> -
> -		pos += ret;
> -		len -= ret;
> -	}
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= pos,
> +		.len		= len,
> +		.flags		= IOMAP_ZERO,
> +	};
> +	int ret;
>  
> -	return 0;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_zero_iter(&iter, did_zero);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_zero_range);
>  
> -- 
> 2.30.2
> 

