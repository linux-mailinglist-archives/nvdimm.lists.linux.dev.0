Return-Path: <nvdimm+bounces-571-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D5F3CE8D7
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 19:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D84941C0F7C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 17:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AEF2FB2;
	Mon, 19 Jul 2021 17:35:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABE42FAE
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 17:35:32 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC826113A;
	Mon, 19 Jul 2021 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1626716131;
	bh=ctaebXMBllXiQLQACsNI6rLNkFdU4WNfaBVmh0Lu2H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lGARtMy7qP392pvtKMaN9slO8tp7u3jU1T7FtRmizgaxllz3pA2eIVTAspsTS3MDL
	 zAzebTFuFR1CNRPPmMnd+oXz5FBMTdrc+7RC2dzYQvdmgOZCyf6uDhTh+gjtXjPaDo
	 STutVxGkpuwfYoN9IaVsM2tLMcKeeISmrwbLp7+q+SItqxbEQoeKZOfzQqajbkudKN
	 yT1CuH5w5PqGPZ6FUs7pgQeFSuz645p8GsjhKF7msocIQUIPqYhJovDU8mIwFDDKTj
	 dVCczixBsbnp0oeUzFT0dT+w84lhxNLH5BuMh5psLoOCW0LhOcbuP4HSRN9sQJRvVV
	 qeGaZW3/NuVPw==
Date: Mon, 19 Jul 2021 10:35:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 05/27] fsdax: mark the iomap argument to dax_iomap_sector
 as const
Message-ID: <20210719173530.GE22357@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-6-hch@lst.de>

On Mon, Jul 19, 2021 at 12:34:58PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index da41f9363568e0..4d63040fd71f56 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1005,7 +1005,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>  
> -static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
> +static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
>  {
>  	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
>  }
> -- 
> 2.30.2
> 

