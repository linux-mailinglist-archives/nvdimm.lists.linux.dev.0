Return-Path: <nvdimm+bounces-3232-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8EB4CCC12
	for <lists+linux-nvdimm@lfdr.de>; Fri,  4 Mar 2022 04:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 0892F1C0F21
	for <lists+linux-nvdimm@lfdr.de>; Fri,  4 Mar 2022 03:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44DB7ED;
	Fri,  4 Mar 2022 03:05:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018587C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 03:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646363115; x=1677899115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NGtX8x+qRt4S4GlNdmZaoqv+f3P3AFsYWBvI67NNPak=;
  b=GpaAOreTY4fMHkJPX9LwW12dUhJbnVxcDg7SSGbilNxtuDXSP7jTNgZ2
   fI0I2AznkoA4+0E5gfPNYhkw+jtjDF08bVQKpJO2D9XpMn2jZRWFjulcu
   5O702xe0zvOtfL+vlOCjbxzwIC5cWO+UA//eXAk2Guyt7LCWS039YAq5K
   xL8qR6S7l/qHkSnPy7JBMm6i0Cn6X+K6/zsFlTGBa//se0mgVGIrql4Nt
   +BEnKtR02afR8Faw19iuQAsQK0JaWvDZLHuCQjGjtmHKpqaH6nCCJTAJG
   +gF0CdZVO1t76YIDbckQAyJ9Y8Yfo4+I23/vg2EtuMyLN3c1Isal9Zv+8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="251455949"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="251455949"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 19:05:15 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="576746893"
Received: from harikara-mobl.amr.corp.intel.com (HELO localhost) ([10.212.33.238])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 19:05:13 -0800
Date: Thu, 3 Mar 2022 19:05:13 -0800
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
Subject: Re: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Message-ID: <YiGB6bQGr4Yq6vpn@iweiny-desk3>
References: <20220303111905.321089-1-hch@lst.de>
 <20220303111905.321089-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303111905.321089-7-hch@lst.de>

On Thu, Mar 03, 2022 at 02:19:01PM +0300, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/nvdimm/btt.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index cbd994f7f1fe6..9613e54c7a675 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
>  		 */
>  
>  		cur_len = min(len, bv.bv_len);
> -		mem = kmap_atomic(bv.bv_page);
> +		mem = bvec_kmap_local(&bv);
>  		if (rw)
> -			ret = arena_write_bytes(arena, meta_nsoff,
> -					mem + bv.bv_offset, cur_len,
> +			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
>  					NVDIMM_IO_ATOMIC);
>  		else
> -			ret = arena_read_bytes(arena, meta_nsoff,
> -					mem + bv.bv_offset, cur_len,
> +			ret = arena_read_bytes(arena, meta_nsoff, mem, cur_len,
>  					NVDIMM_IO_ATOMIC);
>  
> -		kunmap_atomic(mem);
> +		kunmap_local(mem);
>  		if (ret)
>  			return ret;
>  
> -- 
> 2.30.2
> 

