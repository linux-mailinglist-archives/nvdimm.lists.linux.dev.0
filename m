Return-Path: <nvdimm+bounces-822-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C7A3E86D4
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 01:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4E1073E14A1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 23:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9187D2FB9;
	Tue, 10 Aug 2021 23:54:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D07177
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 23:54:19 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBDD960F38;
	Tue, 10 Aug 2021 23:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628639658;
	bh=BPt0XucTbKyfVVhoQUkTkClOhMOSHtA+n7pBWfaEhYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHs07xlZQZtqy6QcOtbbm60f34RpL8z/+XGdFIVzXuwM28rb131GPDGMD9LHssYVw
	 PyoGQpKaiKcs8fq8T4j4AyfWXtn/XuPbAbcZkl+pbXgz0dAotlkDJ0Ky0nr2PC1SLC
	 H6HiQHaqVwrTItxCNqNFFkLMbO+6b/j/Nenm4TOU79K/iOo5oSbhiy3FembRJBC9j3
	 ScrHOqvvVEuZQ5NIuVqDKjGn59ue2kBcilGo4UA9mvrjZWzOHozFR/iz6u1j5dOfw2
	 1lu0zMxLrjX4Ryzx2JgAUAizt0Fsg5RXOUpNZEV7QppTzls4Lyvh1XDJI6WiBBlr2J
	 FYG0++Kxv6pbg==
Date: Tue, 10 Aug 2021 16:54:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 14/30] iomap: switch iomap_file_unshare to use iomap_iter
Message-ID: <20210810235418.GM3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-15-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:28AM +0200, Christoph Hellwig wrote:
> Switch iomap_file_unshare to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 35 ++++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 4c7e82928cc546..4f525727462f33 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -817,10 +817,12 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
>  
> -static loff_t
> -iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> -		struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_unshare_iter(struct iomap_iter *iter)
>  {
> +	struct iomap *iomap = &iter->iomap;
> +	struct iomap *srcmap = iomap_iter_srcmap(iter);
> +	loff_t pos = iter->pos;
> +	loff_t length = iomap_length(iter);
>  	long status = 0;
>  	loff_t written = 0;
>  
> @@ -836,12 +838,12 @@ iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		unsigned long bytes = min_t(loff_t, PAGE_SIZE - offset, length);
>  		struct page *page;
>  
> -		status = iomap_write_begin(inode, pos, bytes,
> +		status = iomap_write_begin(iter->inode, pos, bytes,
>  				IOMAP_WRITE_F_UNSHARE, &page, iomap, srcmap);
>  		if (unlikely(status))
>  			return status;
>  
> -		status = iomap_write_end(inode, pos, bytes, bytes, page, iomap,
> +		status = iomap_write_end(iter->inode, pos, bytes, bytes, page, iomap,
>  				srcmap);
>  		if (WARN_ON_ONCE(status == 0))
>  			return -EIO;
> @@ -852,7 +854,7 @@ iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		written += status;
>  		length -= status;
>  
> -		balance_dirty_pages_ratelimited(inode->i_mapping);
> +		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
>  	} while (length);
>  
>  	return written;
> @@ -862,18 +864,17 @@ int
>  iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  		const struct iomap_ops *ops)
>  {
> -	loff_t ret;
> -
> -	while (len) {
> -		ret = iomap_apply(inode, pos, len, IOMAP_WRITE, ops, NULL,
> -				iomap_unshare_actor);
> -		if (ret <= 0)
> -			return ret;
> -		pos += ret;
> -		len -= ret;
> -	}
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= pos,
> +		.len		= len,
> +		.flags		= IOMAP_WRITE,
> +	};
> +	int ret;
>  
> -	return 0;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_unshare_iter(&iter);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_unshare);
>  
> -- 
> 2.30.2
> 

