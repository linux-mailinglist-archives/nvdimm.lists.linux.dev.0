Return-Path: <nvdimm+bounces-583-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A07C3CEF5A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 20 Jul 2021 00:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 17A3D3E1091
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 22:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF932FB6;
	Mon, 19 Jul 2021 22:34:16 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C098670
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 22:34:15 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 608471045436;
	Tue, 20 Jul 2021 08:10:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1m5bSf-008Ug1-At; Tue, 20 Jul 2021 08:10:05 +1000
Date: Tue, 20 Jul 2021 08:10:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 20/27] fsdax: switch dax_iomap_rw to use iomap_iter
Message-ID: <20210719221005.GL664593@dread.disaster.area>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-21-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
	a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
	a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
	a=ptF0LWpzHeEXjmLxdvQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Mon, Jul 19, 2021 at 12:35:13PM +0200, Christoph Hellwig wrote:
> Switch the dax_iomap_rw implementation to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 49 ++++++++++++++++++++++++-------------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4d63040fd71f56..51da45301350a6 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1103,20 +1103,21 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  	return size;
>  }
>  
> -static loff_t
> -dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> -		struct iomap *iomap, struct iomap *srcmap)
> +static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
> +		struct iov_iter *iter)

At first I wondered "iomi? Strange name, why is this one-off name
used?" and then I realised it's because this function also takes an
struct iov_iter named "iter".

That's going to cause confusion in the long run - iov_iter and
iomap_iter both being generally named "iter", and then one or the
other randomly changing when both are used in the same function.

Would it be better to avoid any possible confusion simply by using
"iomi" for all iomap_iter variables throughout the patchset from the
start? That way nobody is going to confuse iov_iter with iomap_iter
iteration variables and code that uses both types will naturally
have different, well known names...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

