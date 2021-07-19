Return-Path: <nvdimm+bounces-568-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 595AC3CE80D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 19:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7FDDF1C0E86
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 17:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4BE2FB3;
	Mon, 19 Jul 2021 17:22:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61048173
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 17:22:49 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E42C6112D;
	Mon, 19 Jul 2021 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1626715368;
	bh=J+u6feVH38ijIKaZSYQ5HhPF/utdLMNKixdiuNBTil8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BI+C1bL3B6s/hY6b08wdpt/D7iZbIBAk8Xrk2aOLqATuj9QSqZ/XphY3YhXuwX/By
	 P6eLtLR6hOnZrEmGqyxUw69/C1rc6xvyx3IMyjOpZZpJJM3wR3ZcPphRLz0qFRz3dv
	 xGyfCWPCmzGd5mXqXirX8r8f3CKCi88zuGLPcMBxl7/2g6LDzQnKRsAqZ8uyX1MaY3
	 b3DzmHcdl77yoiltVZS2QhcejTStXWo71Cd36QP4/KThPAvMEqGvq0pSW3kxFWWjGO
	 /NWUwRMKQy7C7Bwj47/6BY9VCYqYrA8wOK9z0MhBD8MzGQs+GQzEKjaVCUnQvJcBO7
	 MTsa0g3q0X7KQ==
Date: Mon, 19 Jul 2021 10:22:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 17/27] iomap: switch iomap_seek_hole to use iomap_iter
Message-ID: <20210719172247.GG22402@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-18-hch@lst.de>

On Mon, Jul 19, 2021 at 12:35:10PM +0200, Christoph Hellwig wrote:
> Rewrite iomap_seek_hole to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/seek.c | 46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> index ce6fb810854fec..7d6ed9af925e96 100644
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
> @@ -10,21 +10,19 @@
>  #include <linux/pagemap.h>
>  #include <linux/pagevec.h>
>  
> -static loff_t
> -iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
> -		      void *data, struct iomap *iomap, struct iomap *srcmap)
> +static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter, loff_t *pos)

/me wonders if @pos should be named hole_pos (here and in the caller) to
make it a little easier to read...

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
> +		*pos = mapping_seek_hole_data(iter->inode->i_mapping,
> +				iter->pos, iter->pos + length, SEEK_HOLE);
> +		if (*pos == iter->pos + length)
>  			return length;
> -		fallthrough;
> +		return 0;
>  	case IOMAP_HOLE:
> -		*(loff_t *)data = offset;
> +		*pos = iter->pos;
>  		return 0;
>  	default:
>  		return length;
> @@ -35,23 +33,25 @@ loff_t
>  iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
>  {
>  	loff_t size = i_size_read(inode);
> -	loff_t ret;
> +	struct iomap_iter iter = {
> +		.inode	= inode,
> +		.pos	= offset,
> +		.flags	= IOMAP_REPORT,
> +	};
> +	int ret;
>  
>  	/* Nothing to be found before or beyond the end of the file. */
>  	if (offset < 0 || offset >= size)
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
> +	iter.len = size - offset;
> +	while ((ret = iomap_iter(&iter, ops)) > 0)
> +		iter.processed = iomap_seek_hole_iter(&iter, &offset);
> +	if (ret < 0)
> +		return ret;
> +	if (iter.len)
> +		return offset;

...because what we're really saying here is that if seek_hole_iter found
a hole (and returned zero, thereby terminating the loop before iter.len
could reach zero), we want to return the position of the hole.

> +	return size;

Not sure why we return size here...?  Oh, because there's an implicit
hole at EOF, so we return i_size.  Uh, does this do the right thing if
->iomap_begin returns posteof mappings?  I don't see anything in
iomap_iter_advance that would stop iteration at EOF.

--D

>  }
>  EXPORT_SYMBOL_GPL(iomap_seek_hole);
>  
> -- 
> 2.30.2
> 

