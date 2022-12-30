Return-Path: <nvdimm+bounces-5559-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A233653495
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Dec 2022 18:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629601C20950
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Dec 2022 17:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF662912;
	Wed, 21 Dec 2022 17:09:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E23028FC
	for <nvdimm@lists.linux.dev>; Wed, 21 Dec 2022 17:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BB4C433EF;
	Wed, 21 Dec 2022 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671642545;
	bh=HexWrl21jQsZiZHSJmWAZU7Ngb+sLT1anzFCUeX4EtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eb1rcmPIHP+2ixTURffKrMR/B0JPZHtcCp3fI8SsDi38mfPsBeBn0wkQMfGl+WqEc
	 EReXnaFgZ6dxXAFvqCA5sYZNrexaFNulst4/5VC+IhK9+dfLk0UscsoR2tDUYSthbK
	 M4awtawpM9cIjyVwb0fPcZxSuIVWiCKFWpscUxYYw2MSmsOB4vNbHTgLNgsVg+ooik
	 IcZ0YCbfl7H/IYiAM1B0U1uRfO4Z6VB3TpHQliDUvIPcxYjy+60I9d91p27S1yfLIO
	 tRRPvOOuFj9CY1ZxFso107+OjTh+UkYETvwPmtbFTmvdvXK3YHpMmeqkNjJnsQImXu
	 4WTH7RLaXi4MA==
Date: Wed, 21 Dec 2022 10:09:00 -0700
From: Keith Busch <kbusch@kernel.org>
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: linux-block@vger.kernel.org, axboe@kernel.dk,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, minchan@kernel.org,
	ngupta@vflare.org, senozhatsky@chromium.org, colyli@suse.de,
	kent.overstreet@gmail.com, agk@redhat.com, snitzer@kernel.org,
	dm-devel@redhat.com, song@kernel.org, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
	junxiao.bi@oracle.com, martin.petersen@oracle.com, kch@nvidia.com,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, konrad.wilk@oracle.com, joe.jin@oracle.com,
	rajesh.sivaramasubramaniom@oracle.com, shminderjit.singh@oracle.com
Subject: Re: [PATCH for-6.2/block V3 2/2] block: Change the granularity of io
 ticks from ms to ns
Message-ID: <Y6M9rJbw3ZMvOeDr@kbusch-mbp.dhcp.thefacebook.com>
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
 <20221221040506.1174644-2-gulam.mohamed@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221040506.1174644-2-gulam.mohamed@oracle.com>

On Wed, Dec 21, 2022 at 04:05:06AM +0000, Gulam Mohamed wrote:
> +u64  blk_get_iostat_ticks(struct request_queue *q)
> +{
> +       return (blk_queue_precise_io_stat(q) ? ktime_get_ns() : jiffies);
> +}
> +EXPORT_SYMBOL_GPL(blk_get_iostat_ticks);
> +
>  void update_io_ticks(struct block_device *part, u64 now, bool end)
>  {
>  	u64 stamp;
> @@ -968,20 +980,26 @@ EXPORT_SYMBOL(bdev_start_io_acct);
>  u64 bio_start_io_acct(struct bio *bio)
>  {
>  	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> -				  bio_op(bio), jiffies);
> +				  bio_op(bio),
> +				  blk_get_iostat_ticks(bio->bi_bdev->bd_queue));
>  }
>  EXPORT_SYMBOL_GPL(bio_start_io_acct);
>  
>  void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
>  		      u64 start_time)
>  {
> +	u64 now;
> +	u64 duration;
> +	struct request_queue *q = bdev_get_queue(bdev);
>  	const int sgrp = op_stat_group(op);
> -	u64 now = READ_ONCE(jiffies);
> -	u64 duration = (unsigned long)now -(unsigned long) start_time;
> +	now = blk_get_iostat_ticks(q);;

I don't think you can rely on the blk_queue_precise_io_stat() flag in
the completion side. The user can toggle this with data in flight, which
means the completion may use different tick units than the start. I
think you'll need to add a flag to the request in the start accounting
side to know which method to use for the completion.

> @@ -951,6 +951,7 @@ ssize_t part_stat_show(struct device *dev,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	struct disk_stats stat;
>  	unsigned int inflight;
> +	u64 stat_ioticks;
>  
>  	if (queue_is_mq(q))
>  		inflight = blk_mq_in_flight(q, bdev);
> @@ -959,10 +960,13 @@ ssize_t part_stat_show(struct device *dev,
>  
>  	if (inflight) {
>  		part_stat_lock();
> -		update_io_ticks(bdev, jiffies, true);
> +		update_io_ticks(bdev, blk_get_iostat_ticks(q), true);
>  		part_stat_unlock();
>  	}
>  	part_stat_read_all(bdev, &stat);
> +	stat_ioticks = (blk_queue_precise_io_stat(q) ?
> +				div_u64(stat.io_ticks, NSEC_PER_MSEC) :
> +				jiffies_to_msecs(stat.io_ticks));


With the user able to change the precision at will, I think these
io_ticks need to have a consistent unit size. Mixing jiffies and nsecs
is going to create garbage stats output. Could existing io_ticks using
jiffies be converted to jiffies_to_nsecs() so that you only have one
unit to consider?

