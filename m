Return-Path: <nvdimm+bounces-5394-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C23663FC73
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Dec 2022 01:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E38A1C209B3
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Dec 2022 00:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4203EEA2;
	Fri,  2 Dec 2022 00:05:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957577B
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 00:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD4CC43150;
	Fri,  2 Dec 2022 00:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669939538;
	bh=L6gBULzhRK7OzgCLtfjp0tObT6lwTFeGydXQwDKFfuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AFNa4HAUVNlhARyuZW89QcJfCEhpDVZfAximztn5gJjqfia5fU6wXOGMwYoXNV/Da
	 jEvzG7bmCGisu0B1vC6cD8ExXWesbkPElbPgWH0zLaAaP6B0+2c3wkIF716fqgQ9LP
	 ur7HipbKaPkCTeNGCRja0aJzLcUranYd//32/Y3xLg6bBPG6K9Zjqd7aIvh2mDIhEt
	 euqq0i9vXsBR69y1Kh+lkVlHPc1qMOKRKh1DHLpLmy4TYgU4aQEZ5757mMs2fM+WeX
	 fWuVjeh30Th6ETK6FTOqZoOIDs+2H8+EHy5ZigvF0aqv1Mgmap+PINku4SGCDDB+1g
	 3NQnfLfSBfY4Q==
Date: Thu, 1 Dec 2022 16:05:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH v2 5/8] fsdax: dedupe: iter two files at the same time
Message-ID: <Y4lBUX/XzCjrRQCc@magnolia>
References: <1669908538-55-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1669908701-93-1-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669908701-93-1-git-send-email-ruansy.fnst@fujitsu.com>

On Thu, Dec 01, 2022 at 03:31:41PM +0000, Shiyang Ruan wrote:
> The iomap_iter() on a range of one file may loop more than once.  In
> this case, the inner dst_iter can update its iomap but the outer
> src_iter can't.  This may cause the wrong remapping in filesystem.  Let
> them called at the same time.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Thank you for adding that explanation, it makes the problem much more
obvious. :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index f1eb59bee0b5..354be56750c2 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1964,15 +1964,15 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		.len		= len,
>  		.flags		= IOMAP_DAX,
>  	};
> -	int ret;
> +	int ret, compared = 0;
>  
> -	while ((ret = iomap_iter(&src_iter, ops)) > 0) {
> -		while ((ret = iomap_iter(&dst_iter, ops)) > 0) {
> -			dst_iter.processed = dax_range_compare_iter(&src_iter,
> -						&dst_iter, len, same);
> -		}
> -		if (ret <= 0)
> -			src_iter.processed = ret;
> +	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
> +	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
> +		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
> +						  same);
> +		if (compared < 0)
> +			return ret;
> +		src_iter.processed = dst_iter.processed = compared;
>  	}
>  	return ret;
>  }
> -- 
> 2.38.1
> 

