Return-Path: <nvdimm+bounces-779-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFC93E498C
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 18:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 516631C0B50
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 16:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860512FB9;
	Mon,  9 Aug 2021 16:17:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4467177
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 16:17:02 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 479C460EB9;
	Mon,  9 Aug 2021 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628525822;
	bh=7bNCWOmmSl2og9wQXTzG/9IxTAKeX6wugcbzpZsamQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZJKbNCE4hwgW+/mgyqgYeZokawCkWSAdgvDq63knI6jOXZfa1BKhybohH8nY75RF
	 HQmRI3TdJ18B9ye7/MJ9XCrviia+yr4L2QM6QktQk1FepIY6+9fgho193pyXelis79
	 RHWvgRsJ3ZZ6cMAZbU2URg4sFk7r1piJfFCpDptCXelIhxX2/GyxtLNs2AqPYTW2ct
	 KHmF7izpAFd6mtBltQzl3HgafDV/H4E6OdjFkuvsaddnaHUsL4jPALs23fKLMQZZOq
	 WtP/g2ZK75k6QsSo9XBaXk0QX4nok8LIfzfBUFwK2/tCkodFCx53rModJbRktlFlgh
	 NE3rEhkp0C/9Q==
Date: Mon, 9 Aug 2021 09:17:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 04/30] iomap: mark the iomap argument to
 iomap_inline_data const
Message-ID: <20210809161701.GD3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-5-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:18AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  include/linux/iomap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 8030483331d17f..560247130357b5 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -99,7 +99,7 @@ static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
>  /*
>   * Returns the inline data pointer for logical offset @pos.
>   */
> -static inline void *iomap_inline_data(struct iomap *iomap, loff_t pos)
> +static inline void *iomap_inline_data(const struct iomap *iomap, loff_t pos)
>  {
>  	return iomap->inline_data + pos - iomap->offset;
>  }
> -- 
> 2.30.2
> 

