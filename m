Return-Path: <nvdimm+bounces-5702-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4CC688A68
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Feb 2023 00:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5EAC280A52
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Feb 2023 23:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC13AD41;
	Thu,  2 Feb 2023 23:01:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2EEAD3A
	for <nvdimm@lists.linux.dev>; Thu,  2 Feb 2023 23:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U96BQSukhueTg5b9SilnykHoY2bEaDS7yq/+1W3CybU=; b=EGpW+mYRg6uxPrqK1Bv3tSB4VN
	zRyAddZ+ZtTSYNrRWVblzhiFQbwVbAdpXyuagMzQKte6HckWpoUPXKR8kal8vGocyNZ07H2L9Q6VP
	cWhSbw6kyak1HX5PvGgOo6R6go92gvGAq/hYIHg6VlxdJ8WwEDslmrtOcO0H5ZN5HE4/IZygvUPjU
	O2ZHSFkBb8OX8oqdWM1rNG9hnp6+oMORoSJ3jkXjuYzi6dLmqwfJmjZPJiRKWBxQla3U0kGgcHPB9
	Li3oNK5vm2tfMAL7YwCFdiNigzFxd0LDxhFq29hdt8oKzGhOF2Jp/Se8Mu2dZoUgMrYSUay/cwCUj
	jpJIsojQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pNia3-00Dnyf-VY; Thu, 02 Feb 2023 23:01:24 +0000
Date: Thu, 2 Feb 2023 23:01:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH] fsdax: dax_unshare_iter() should return a valid length
Message-ID: <Y9xAw+poZxOyMk1J@casper.infradead.org>
References: <1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com>

On Thu, Feb 02, 2023 at 12:33:47PM +0000, Shiyang Ruan wrote:
> The copy_mc_to_kernel() will return 0 if it executed successfully.
> Then the return value should be set to the length it copied.
> 
> Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index c48a3a93ab29..a5b4deb5def3 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1274,6 +1274,7 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
>  	ret = copy_mc_to_kernel(daddr, saddr, length);
>  	if (ret)
>  		ret = -EIO;
> +	ret = length;

Umm.  Surely should be:

	else
		ret = length;

otherwise you've just overwritten the -EIO.

And maybe this should be:

	ret = length - copy_mc_to_kernel(daddr, saddr, length);
	if (ret < length)
		ret = -EIO;

What do you think?

