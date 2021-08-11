Return-Path: <nvdimm+bounces-824-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B883E86E5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 01:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 91F4C1C0B50
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 23:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7C12FB9;
	Tue, 10 Aug 2021 23:58:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88675177
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 23:58:56 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3221D60F94;
	Tue, 10 Aug 2021 23:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628639936;
	bh=DJrzutjtjo/Yj+2bRkiBSl61pRlqxhzQ6EU0MmzGhKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OzdVvvKdeU6hRoECPa4czwIhq9p6qQgTp/GEEPIROQvvFyKI6534grs+WpGM87KqL
	 CTctBHOLNNMe29jeStqovXFgivXU/Z4iS4coCqyDWS9FZfHaGWZH/jL3eOVQ4Ze78P
	 Y0e/xaM1JW0yvc9ECca0UemWtCr5hZQM9H9+RaVJVIO7TjNjixmyJRSHII3pwBXHVr
	 W6cXGoPdx6CDpK+DpJqAuVqmyT8t05Fb8UY76S1VSr3hY3Id1Wj1wzkN743bDtkuXf
	 0slg3GmO/PxmCNIsvkt8pL777M8HE7rPHMtwEcsNnNsff99sXmy9Zvx4UKZvArba9N
	 M6Ajain0FwMzg==
Date: Tue, 10 Aug 2021 16:58:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 16/30] iomap: switch iomap_page_mkwrite to use iomap_iter
Message-ID: <20210810235855.GO3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-17-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:30AM +0200, Christoph Hellwig wrote:
> Switch iomap_page_mkwrite to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 3a23f7346938fb..5ab464937d4886 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -961,15 +961,15 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
>  }
>  EXPORT_SYMBOL_GPL(iomap_truncate_page);
>  
> -static loff_t
> -iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
> -		void *data, struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_page_mkwrite_iter(struct iomap_iter *iter,
> +		struct page *page)
>  {
> -	struct page *page = data;
> +	loff_t length = iomap_length(iter);
>  	int ret;
>  
> -	if (iomap->flags & IOMAP_F_BUFFER_HEAD) {
> -		ret = __block_write_begin_int(page, pos, length, NULL, iomap);
> +	if (iter->iomap.flags & IOMAP_F_BUFFER_HEAD) {
> +		ret = __block_write_begin_int(page, iter->pos, length, NULL,
> +					      &iter->iomap);
>  		if (ret)
>  			return ret;
>  		block_commit_write(page, 0, length);
> @@ -983,29 +983,24 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
>  
>  vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
>  {
> +	struct iomap_iter iter = {
> +		.inode		= file_inode(vmf->vma->vm_file),
> +		.flags		= IOMAP_WRITE | IOMAP_FAULT,
> +	};
>  	struct page *page = vmf->page;
> -	struct inode *inode = file_inode(vmf->vma->vm_file);
> -	unsigned long length;
> -	loff_t offset;
>  	ssize_t ret;
>  
>  	lock_page(page);
> -	ret = page_mkwrite_check_truncate(page, inode);
> +	ret = page_mkwrite_check_truncate(page, iter.inode);
>  	if (ret < 0)
>  		goto out_unlock;
> -	length = ret;
> -
> -	offset = page_offset(page);
> -	while (length > 0) {
> -		ret = iomap_apply(inode, offset, length,
> -				IOMAP_WRITE | IOMAP_FAULT, ops, page,
> -				iomap_page_mkwrite_actor);
> -		if (unlikely(ret <= 0))
> -			goto out_unlock;
> -		offset += ret;
> -		length -= ret;
> -	}
> +	iter.pos = page_offset(page);
> +	iter.len = ret;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_page_mkwrite_iter(&iter, page);
>  
> +	if (ret < 0)
> +		goto out_unlock;
>  	wait_for_stable_page(page);
>  	return VM_FAULT_LOCKED;
>  out_unlock:
> -- 
> 2.30.2
> 

