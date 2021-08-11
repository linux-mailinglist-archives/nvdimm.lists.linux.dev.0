Return-Path: <nvdimm+bounces-821-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B133E86CA
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 01:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 5F2FE1C0A68
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 23:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E1F2FB9;
	Tue, 10 Aug 2021 23:53:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F8A177
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 23:53:27 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0155060F55;
	Tue, 10 Aug 2021 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628639607;
	bh=VuC14IWrypcQZbYXPu3Lw2huX+WjjiahTYa2Uojq8Tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1fkqhCIp/tPJX8BV1QzFNiKRDkSGVa1NrL9zxypp81HfypD/HOxF6IZwzR96TTb4
	 tqIgkzFy+2xGVRhWZongW4jDMeTcUBpU7JDkbWjF+RQO4GJY28gRn5K96GQ2+Z1Xf0
	 XijcJROq7Q4BaiEvAmf7J0X7t4i9sblfwlPWSBlFlqM6lQLuEcKT4JCAtEeRcAuUsp
	 rT7i9G1+IGT82UETFg9WNFvJhA1lzxz2d9ulg6j+cVsZTGmoryO4y9/KVFXWTCTONa
	 mmRxA4386demxJHCT3yrAk6UuAaTZlm3lSozFvhdagAQy9n6ShTVeoIERcYj5ns5yX
	 QGxZ+WEe8baVw==
Date: Tue, 10 Aug 2021 16:53:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 13/30] iomap: switch iomap_file_buffered_write to use
 iomap_iter
Message-ID: <20210810235326.GL3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-14-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:27AM +0200, Christoph Hellwig wrote:
> Switch iomap_file_buffered_write to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems pretty straightforward.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 49 +++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 9cda461887afad..4c7e82928cc546 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -726,13 +726,14 @@ static size_t iomap_write_end(struct inode *inode, loff_t pos, size_t len,
>  	return ret;
>  }
>  
> -static loff_t
> -iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> -		struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  {
> -	struct iov_iter *i = data;
> -	long status = 0;
> +	struct iomap *srcmap = iomap_iter_srcmap(iter);
> +	struct iomap *iomap = &iter->iomap;
> +	loff_t length = iomap_length(iter);
> +	loff_t pos = iter->pos;
>  	ssize_t written = 0;
> +	long status = 0;
>  
>  	do {
>  		struct page *page;
> @@ -758,18 +759,18 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			break;
>  		}
>  
> -		status = iomap_write_begin(inode, pos, bytes, 0, &page, iomap,
> -				srcmap);
> +		status = iomap_write_begin(iter->inode, pos, bytes, 0, &page,
> +					   iomap, srcmap);
>  		if (unlikely(status))
>  			break;
>  
> -		if (mapping_writably_mapped(inode->i_mapping))
> +		if (mapping_writably_mapped(iter->inode->i_mapping))
>  			flush_dcache_page(page);
>  
>  		copied = copy_page_from_iter_atomic(page, offset, bytes, i);
>  
> -		status = iomap_write_end(inode, pos, bytes, copied, page, iomap,
> -				srcmap);
> +		status = iomap_write_end(iter->inode, pos, bytes, copied, page,
> +					 iomap, srcmap);
>  
>  		if (unlikely(copied != status))
>  			iov_iter_revert(i, copied - status);
> @@ -790,29 +791,29 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		written += status;
>  		length -= status;
>  
> -		balance_dirty_pages_ratelimited(inode->i_mapping);
> +		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
>  	} while (iov_iter_count(i) && length);
>  
>  	return written ? written : status;
>  }
>  
>  ssize_t
> -iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
> +iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  		const struct iomap_ops *ops)
>  {
> -	struct inode *inode = iocb->ki_filp->f_mapping->host;
> -	loff_t pos = iocb->ki_pos, ret = 0, written = 0;
> -
> -	while (iov_iter_count(iter)) {
> -		ret = iomap_apply(inode, pos, iov_iter_count(iter),
> -				IOMAP_WRITE, ops, iter, iomap_write_actor);
> -		if (ret <= 0)
> -			break;
> -		pos += ret;
> -		written += ret;
> -	}
> +	struct iomap_iter iter = {
> +		.inode		= iocb->ki_filp->f_mapping->host,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(i),
> +		.flags		= IOMAP_WRITE,
> +	};
> +	int ret;
>  
> -	return written ? written : ret;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_write_iter(&iter, i);
> +	if (iter.pos == iocb->ki_pos)
> +		return ret;
> +	return iter.pos - iocb->ki_pos;
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
>  
> -- 
> 2.30.2
> 

