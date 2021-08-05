Return-Path: <nvdimm+bounces-734-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EF13E0CA3
	for <lists+linux-nvdimm@lfdr.de>; Thu,  5 Aug 2021 05:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 484121C0AB4
	for <lists+linux-nvdimm@lfdr.de>; Thu,  5 Aug 2021 03:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2692FAF;
	Thu,  5 Aug 2021 03:01:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE170
	for <nvdimm@lists.linux.dev>; Thu,  5 Aug 2021 03:01:48 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA57B60E97;
	Thu,  5 Aug 2021 03:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628132507;
	bh=yAZJuzyctHp6akkNiCxo+Iu3DAhWAT7FwQvPoTN17og=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=K3xwqgWn6GLThh4Df0a+R5lEzlsHQFag5HSqF/U7UpYfxABWa4HZXjfKnutBycrPu
	 nzYxqjdNS/UkE0L2jyi7A7E6a7tuns6i/mCB8MOY2cLnCq1gq5Zchz7EBNOlwTbQf4
	 NtSkAFA5aGQuABdOAjMHSHB6MgmyySmWDqHX2N6YgQeXJilNA4qanHm4TBkiV4G3ls
	 20fkk9a5g+tDJul41XU56r12byPPHTWv7yTQvo5x15CVRukMLC/v+qLBZ3Bw7aaCxC
	 XPVrY1+IvkMRK+MGLH0x+VGiycMlX1Umy9mShBRwlRdAeUSLRCkgzEmd7JyFqF+D0L
	 o+2MzLPzIGTfg==
Subject: Re: [PATCH v3 2/3] erofs: dax support for non-tailpacking regular
 file
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Liu Bo <bo.liu@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Liu Jiang <gerry@linux.alibaba.com>, Huang Jianan <huangjianan@oppo.com>,
 Tao Ma <boyu.mt@taobao.com>
References: <20210805003601.183063-1-hsiangkao@linux.alibaba.com>
 <20210805003601.183063-3-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <7aa650b8-a853-368d-7a81-f435194eec33@kernel.org>
Date: Thu, 5 Aug 2021 11:01:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210805003601.183063-3-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2021/8/5 8:36, Gao Xiang wrote:
> DAX is quite useful for some VM use cases in order to save guest
> memory extremely with minimal lightweight EROFS.
> 
> In order to prepare for such use cases, add preliminary dax support
> for non-tailpacking regular files for now.
> 
> Tested with the DRAM-emulated PMEM and the EROFS image generated by
> "mkfs.erofs -Enoinline_data enwik9.fsdax.img enwik9"
> 
> Cc: nvdimm@lists.linux.dev
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>   Documentation/filesystems/erofs.rst |  2 +
>   fs/erofs/data.c                     | 42 +++++++++++++++++++-
>   fs/erofs/inode.c                    |  4 ++
>   fs/erofs/internal.h                 |  3 ++
>   fs/erofs/super.c                    | 59 ++++++++++++++++++++++++++++-
>   5 files changed, 106 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index 832839fcf4c3..ffd2ae7be511 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -84,6 +84,8 @@ cache_strategy=%s      Select a strategy for cached decompression from now on:
>                                      It still does in-place I/O decompression
>                                      for the rest compressed physical clusters.
>   		       ==========  =============================================
> +dax                    Use direct access (no page cache).  See

dax or dax=%s

Otherwise, it looks good to me.

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

