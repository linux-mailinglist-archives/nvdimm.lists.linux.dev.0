Return-Path: <nvdimm+bounces-2022-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FC545AF2A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 23:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id DFD9A3E0F44
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 22:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5D52C96;
	Tue, 23 Nov 2021 22:33:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9C2C81
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 22:33:27 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB4B60F5B;
	Tue, 23 Nov 2021 22:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1637706806;
	bh=SG6EdrV2iuRFaD+Ge9einOddVfpnmRARc8QmBaBuuzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a28vYZhcK/L0+J3l2uz5lhbmBhpTNulgccQeW1VL7mEr/zZaDVT126YrHPn7DruBK
	 8Dy2V7WvHSnxPoMv3Gmu/1GTlY8EPd2dzNH9XHbolRma1e6Zpqtzf6JbsTjbYzzl6q
	 /LVxnqhglf1xKWmfXFryoBxBdoHQQS2TGBau2wxcst2u36MyQbyUVzIbr1colB13gR
	 wQzb+Dj6/firAkz9pcYUjB0iNOa3KRetffwJcQeOR7c+gKFW1h2B5nylwGkZa95fAU
	 cFRVmzlVAG8TbWgvsCffLBfLECxv6dPoy5cc+WVPS/yPlzYpaMN7vsLCMga9wFzZD7
	 Bx6joLa58GHEQ==
Date: Tue, 23 Nov 2021 14:33:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 12/29] fsdax: remove a pointless __force cast in
 copy_cow_page_dax
Message-ID: <20211123223326.GG266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
 <20211109083309.584081-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083309.584081-13-hch@lst.de>

On Tue, Nov 09, 2021 at 09:32:52AM +0100, Christoph Hellwig wrote:
> Despite its name copy_user_page expected kernel addresses, which is what
> we already have.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4e3e5a283a916..73bd1439d8089 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -728,7 +728,7 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
>  		return rc;
>  	}
>  	vto = kmap_atomic(to);
> -	copy_user_page(vto, (void __force *)kaddr, vaddr, to);
> +	copy_user_page(vto, kaddr, vaddr, to);
>  	kunmap_atomic(vto);
>  	dax_read_unlock(id);
>  	return 0;
> -- 
> 2.30.2
> 

