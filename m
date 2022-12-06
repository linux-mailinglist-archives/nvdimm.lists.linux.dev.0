Return-Path: <nvdimm+bounces-5457-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB884644C9C
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Dec 2022 20:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04343280C41
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Dec 2022 19:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF5A5668;
	Tue,  6 Dec 2022 19:39:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA135664
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 19:39:52 +0000 (UTC)
Received: from [192.168.0.2] (ip5f5aeffe.dynamic.kabel-deutschland.de [95.90.239.254])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id EAFA660027FC0;
	Tue,  6 Dec 2022 20:31:27 +0100 (CET)
Message-ID: <b28ab260-7a5a-4801-4d33-80c66ae25f89@molgen.mpg.de>
Date: Tue, 6 Dec 2022 20:31:27 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] block: Change the granularity of io ticks from ms to ns
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, philipp.reisner@linbit.com,
 lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
 minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
 colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, junxiao.bi@oracle.com, martin.petersen@oracle.com,
 kch@nvidia.com, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev, konrad.wilk@oracle.com
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221206181536.13333-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Gulam,


Thank you for the patch.

Am 06.12.22 um 19:15 schrieb Gulam Mohamed:
> Use ktime to change the granularity of IO accounting in block layer from
> milli-seconds to nano-seconds to get the proper latency values for the
> devices whose latency is in micro-seconds. After changing the granularity
> to nano-seconds the iostat command, which was showing incorrect values for
> %util, is now showing correct values.
> 
> We did not work on the patch to drop the logic for
> STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.
> 
> The iostat command was run after starting the fio with following command
> on an NVME disk. For the same fio command, the iostat %util was showing
> ~100% for the disks whose latencies are in the range of microseconds.
> With the kernel changes (granularity to nano-seconds), the %util was
> showing correct values. Following are the details of the test and their
> output:
> 
> fio command
> -----------
> [global]
> bs=128K
> iodepth=1
> direct=1
> ioengine=libaio
> group_reporting
> time_based
> runtime=90
> thinktime=1ms
> numjobs=1
> name=raw-write
> rw=randrw
> ignore_error=EIO:EIO
> [job1]
> filename=/dev/nvme0n1
> 
> Correct values after kernel changes:
> ====================================
> iostat output
> -------------
> iostat -d /dev/nvme0n1 -x 1
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.05   0.06   128.00   128.00   0.07   6.50
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.06   0.06   128.00   128.00   0.07   6.30
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.06    0.05   0.06   128.00   128.00   0.06   5.70
> 
>  From fio
> --------
> Read Latency: clat (usec): min=32, max=2335, avg=79.54, stdev=29.95
> Write Latency: clat (usec): min=38, max=130, avg=57.76, stdev= 3.25
> 
> Values before kernel changes
> ============================
> iostat output
> -------------
> 
> iostat -d /dev/nvme0n1 -x 1
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.06   0.06   128.00   128.00   1.07  97.70
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.06   0.06   128.00   128.00   1.08  98.80
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.05   0.06   128.00   128.00   1.06  97.20
> 
>  From fio
> --------
> Read Latency: clat (usec): min=33, max=468, avg=79.56, stdev=28.04
> Write Latency: clat (usec): min=9, max=139, avg=57.10, stdev= 3.79

I’d order the numbers before the change first, but it’s not important.

> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>

(If Junxiao is the patch author, that name should be documented as the 
patch author.)

> ---
>   block/blk-core.c                  | 26 +++++++++++++-------------
>   block/blk-mq.c                    |  4 ++--
>   block/blk.h                       |  2 +-
>   block/genhd.c                     |  8 ++++----
>   drivers/block/drbd/drbd_debugfs.c |  4 ++--
>   drivers/block/drbd/drbd_int.h     |  2 +-
>   drivers/block/zram/zram_drv.c     |  4 ++--
>   drivers/md/bcache/request.c       | 10 +++++-----
>   drivers/md/dm-core.h              |  2 +-
>   drivers/md/dm.c                   |  8 ++++----
>   drivers/md/md.h                   |  2 +-
>   drivers/md/raid1.h                |  2 +-
>   drivers/md/raid10.h               |  2 +-
>   drivers/md/raid5.c                |  2 +-
>   drivers/nvdimm/btt.c              |  2 +-
>   drivers/nvdimm/pmem.c             |  2 +-
>   include/linux/blk_types.h         |  2 +-
>   include/linux/blkdev.h            | 14 +++++++-------
>   include/linux/part_stat.h         |  2 +-
>   19 files changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5487912befe8..069c29dad3e7 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -912,12 +912,12 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
>   }
>   EXPORT_SYMBOL_GPL(iocb_bio_iopoll);
>   
> -void update_io_ticks(struct block_device *part, unsigned long now, bool end)
> +void update_io_ticks(struct block_device *part, u64 now, bool end)
>   {
> -	unsigned long stamp;
> +	u64 stamp;

Did you check the code size difference with `scripts/bloat-o-meter`?

Instead of the fixed-size type, I’d use `unsigned long long` to ensure 
the minimum size is 64-bit.

>   again:
>   	stamp = READ_ONCE(part->bd_stamp);
> -	if (unlikely(time_after(now, stamp))) {
> +	if (unlikely(time_after64(now, stamp))) {

No idea, if it’s possible with `time_after64()` though, as that uses 
`__u64`.

[…]


Kind regards,

Paul

