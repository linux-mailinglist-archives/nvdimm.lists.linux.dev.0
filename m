Return-Path: <nvdimm+bounces-54-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 15DCC38BF2A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 08:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 22D8F1C0EB6
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 06:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6AD2FAD;
	Fri, 21 May 2021 06:15:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2370
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 06:15:49 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C9DB4AC87;
	Fri, 21 May 2021 06:15:41 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
 drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
 Joshua Morris <josh.h.morris@us.ibm.com>,
 Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>,
 Nitin Gupta <ngupta@vflare.org>, Matias Bjorling <mb@lightnvm.io>,
 Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
 Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
 Ulf Hansson <ulf.hansson@linaro.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, linux-mmc@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-13-hch@lst.de>
From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 12/26] bcache: convert to blk_alloc_disk/blk_cleanup_disk
Message-ID: <d4f1c005-2ce0-51b5-c861-431f0ffb3dcf@suse.de>
Date: Fri, 21 May 2021 14:15:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-13-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 5/21/21 1:51 PM, Christoph Hellwig wrote:
> Convert the bcache driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/bcache/super.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index bea8c4429ae8..185246a0d855 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -890,13 +890,9 @@ static void bcache_device_free(struct bcache_device *d)
>  		if (disk_added)
>  			del_gendisk(disk);
>  
> -		if (disk->queue)
> -			blk_cleanup_queue(disk->queue);
> -
> +		blk_cleanup_disk(disk);
>  		ida_simple_remove(&bcache_device_idx,
>  				  first_minor_to_idx(disk->first_minor));
> -		if (disk_added)
> -			put_disk(disk);

The  above 2 lines are added on purpose to prevent an refcount
underflow. It is from commit 86da9f736740 ("bcache: fix refcount
underflow in bcache_device_free()").

Maybe add a parameter to blk_cleanup_disk() or checking (disk->flags &
GENHD_FL_UP) inside blk_cleanup_disk() ?

Coly Li


>  	}
>  
>  	bioset_exit(&d->bio_split);
> @@ -946,7 +942,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>  		goto err;
>  
> -	d->disk = alloc_disk(BCACHE_MINORS);
> +	d->disk = blk_alloc_disk(NUMA_NO_NODE);
>  	if (!d->disk)
>  		goto err;
>  
> @@ -955,14 +951,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk->major		= bcache_major;
>  	d->disk->first_minor	= idx_to_first_minor(idx);
> +	d->disk->minors		= BCACHE_MINORS;
>  	d->disk->fops		= ops;
>  	d->disk->private_data	= d;
>  
> -	q = blk_alloc_queue(NUMA_NO_NODE);
> -	if (!q)
> -		return -ENOMEM;
> -
> -	d->disk->queue			= q;
> +	q = d->disk->queue;
>  	q->limits.max_hw_sectors	= UINT_MAX;
>  	q->limits.max_sectors		= UINT_MAX;
>  	q->limits.max_segment_size	= UINT_MAX;
> 

The rested looks fine to me.

Thanks.

Coly Li

