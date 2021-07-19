Return-Path: <nvdimm+bounces-564-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id B69073CE090
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 18:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 73DCF3E1179
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 16:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CDD2FB3;
	Mon, 19 Jul 2021 16:04:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C8A70
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 16:04:19 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9691F61166;
	Mon, 19 Jul 2021 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1626710659;
	bh=gd5dU6PkN6n3psoB6r/nMJWAoD1wfs+t/3q7sqpMzrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iz0vjtB7RJTj7yLZWJK6qLDeoD8sQCsT+UbdgWDNdvYbk9DIw9Td3/H7MQmnoyEOf
	 uDBIeQsEzDRfWqLrl+Tjbeto/oyR76kjHVPb5jQxPirr1mtrOCPYGaaVJ7DLEvJ+Bz
	 2Q056LedVMTJUbi60BbDr1VGlsFtGL2es+RyHK65mhV5czHyYMoN4SVFttrvoxetOx
	 yFs/UGw/F3axJi+buFO1+vZgKMpRY3LmOtrJiQczTxG1evKGdr6s4XF93ylwCNkNt7
	 pLhukA2GE8c43xxZcuFuwgm8E/2IhiPKdC2HcR14gV0dPXQBcKECKusiLDVeW7B2+D
	 jIZ5RxvZlUdig==
Date: Mon, 19 Jul 2021 09:04:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 02/27] iomap: remove the iomap arguments to
 ->page_{prepare,done}
Message-ID: <20210719160419.GD22402@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-3-hch@lst.de>

On Mon, Jul 19, 2021 at 12:34:55PM +0200, Christoph Hellwig wrote:
> These aren't actually used by the only instance implementing the methods.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me finds it kind of amusing that we still don't have any ->page_prepare
use cases for actually passing the page in, but if nobody /else/ has any
objection or imminently wants to use the iomap argument, then...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/gfs2/bmap.c         | 5 ++---
>  fs/iomap/buffered-io.c | 6 +++---
>  include/linux/iomap.h  | 5 ++---
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
> index ed8b67b2171817..5414c2c3358092 100644
> --- a/fs/gfs2/bmap.c
> +++ b/fs/gfs2/bmap.c
> @@ -1002,7 +1002,7 @@ static void gfs2_write_unlock(struct inode *inode)
>  }
>  
>  static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
> -				   unsigned len, struct iomap *iomap)
> +				   unsigned len)
>  {
>  	unsigned int blockmask = i_blocksize(inode) - 1;
>  	struct gfs2_sbd *sdp = GFS2_SB(inode);
> @@ -1013,8 +1013,7 @@ static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
>  }
>  
>  static void gfs2_iomap_page_done(struct inode *inode, loff_t pos,
> -				 unsigned copied, struct page *page,
> -				 struct iomap *iomap)
> +				 unsigned copied, struct page *page)
>  {
>  	struct gfs2_trans *tr = current->journal_info;
>  	struct gfs2_inode *ip = GFS2_I(inode);
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 87ccb3438becd9..75310f6fcf8401 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -605,7 +605,7 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
>  		return -EINTR;
>  
>  	if (page_ops && page_ops->page_prepare) {
> -		status = page_ops->page_prepare(inode, pos, len, iomap);
> +		status = page_ops->page_prepare(inode, pos, len);
>  		if (status)
>  			return status;
>  	}
> @@ -638,7 +638,7 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
>  
>  out_no_page:
>  	if (page_ops && page_ops->page_done)
> -		page_ops->page_done(inode, pos, 0, NULL, iomap);
> +		page_ops->page_done(inode, pos, 0, NULL);
>  	return status;
>  }
>  
> @@ -714,7 +714,7 @@ static size_t iomap_write_end(struct inode *inode, loff_t pos, size_t len,
>  	if (old_size < pos)
>  		pagecache_isize_extended(inode, old_size, pos);
>  	if (page_ops && page_ops->page_done)
> -		page_ops->page_done(inode, pos, ret, page, iomap);
> +		page_ops->page_done(inode, pos, ret, page);
>  	put_page(page);
>  
>  	if (ret < len)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 479c1da3e2211e..093519d91cc9cc 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -108,10 +108,9 @@ iomap_sector(struct iomap *iomap, loff_t pos)
>   * associated page could not be obtained.
>   */
>  struct iomap_page_ops {
> -	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len,
> -			struct iomap *iomap);
> +	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len);
>  	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
> -			struct page *page, struct iomap *iomap);
> +			struct page *page);
>  };
>  
>  /*
> -- 
> 2.30.2
> 

