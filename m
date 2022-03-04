Return-Path: <nvdimm+bounces-3233-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F23784CCC16
	for <lists+linux-nvdimm@lfdr.de>; Fri,  4 Mar 2022 04:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id AD6321C0F8F
	for <lists+linux-nvdimm@lfdr.de>; Fri,  4 Mar 2022 03:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C357EE;
	Fri,  4 Mar 2022 03:06:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73407C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 03:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646363190; x=1677899190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lc9qHdOlafcJNOz8evKbREjH7xRoVMfzT76IGNVrBPY=;
  b=QBlfF2LJyC3Lrs/hHEruWOhPtIN/MUm85E9FkM73I5fTKdG7DciwLr6L
   SKC9fv8rOYAFIwvZ7t9VnSR3gPA3g8JKXSZrIEfnHdwPBZ5XLnhaJjS62
   Jcb2V/gCqnnuLKx1n/OQUp0AuUQURu32hGRHWx0gdbMxRNVnByQOmPvjr
   H3GeoQNhl5AqcJ1FxgH5ro5/dxPI2t5jS5mWKNYkrBdEh83Eif9sKK/Ze
   kH3uf0gDb41VZ7PTNUpuOJku3v06+HNQmz45k9hnBOEqHy5TW1P/m7Gjx
   khOt/T/L6njIiyZYGDez3dVlS65E7vEpAtttzBYxhCjxUO1pvEtccHC7A
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="314595013"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="314595013"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 19:06:12 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="546100598"
Received: from harikara-mobl.amr.corp.intel.com (HELO localhost) ([10.212.33.238])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 19:06:11 -0800
Date: Thu, 3 Mar 2022 19:06:11 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>, Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 07/10] bcache: use bvec_kmap_local in bio_csum
Message-ID: <YiGCIzAwEO+o9pEj@iweiny-desk3>
References: <20220303111905.321089-1-hch@lst.de>
 <20220303111905.321089-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303111905.321089-8-hch@lst.de>

On Thu, Mar 03, 2022 at 02:19:02PM +0300, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/md/bcache/request.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6869e010475a3..fdd0194f84dd0 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -44,10 +44,10 @@ static void bio_csum(struct bio *bio, struct bkey *k)
>  	uint64_t csum = 0;
>  
>  	bio_for_each_segment(bv, bio, iter) {
> -		void *d = kmap(bv.bv_page) + bv.bv_offset;
> +		void *d = bvec_kmap_local(&bv);
>  
>  		csum = crc64_be(csum, d, bv.bv_len);
> -		kunmap(bv.bv_page);
> +		kunmap_local(d);
>  	}
>  
>  	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
> -- 
> 2.30.2
> 

