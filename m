Return-Path: <nvdimm+bounces-5480-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A566465FB
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Dec 2022 01:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 017E21C20912
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Dec 2022 00:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657AE38F;
	Thu,  8 Dec 2022 00:37:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDA2372
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670459836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Na/DatNEjlEBtkHIEc2JrPJeXMI6lGrn4tJNlRzZp9M=;
	b=DVlN9pioplIMljEPyvkESlQxss4No4N9Pl5F0+eq5wcmQf9dyl/kFVCX/+41vIcVsfHxmZ
	HWkONxPbyNZeE/OI1jHWdGMQl5Zxev0l6rVf/twGdEBB8AxSLH2dSgbQTa0V/Kmn3nExGv
	lzxgW0d68RGSpmQdaOe8DNi+MCEjO+4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-qCYLgktkODafZ8b_0srOJg-1; Wed, 07 Dec 2022 19:37:11 -0500
X-MC-Unique: qCYLgktkODafZ8b_0srOJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 572CA185A79C;
	Thu,  8 Dec 2022 00:37:10 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 247241121314;
	Thu,  8 Dec 2022 00:36:54 +0000 (UTC)
Date: Thu, 8 Dec 2022 08:36:49 +0800
From: Ming Lei <ming.lei@redhat.com>
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
	ming.lei@redhat.com
Subject: Re: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Message-ID: <Y5ExoZ+7Am6Nm8+h@T590>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

On Wed, Dec 07, 2022 at 10:32:04PM +0000, Gulam Mohamed wrote:
> As per the review comment from Jens Axboe, I am re-sending this patch
> against "for-6.2/block".
> 
> 
> Use ktime to change the granularity of IO accounting in block layer from
> milli-seconds to nano-seconds to get the proper latency values for the
> devices whose latency is in micro-seconds. After changing the granularity
> to nano-seconds the iostat command, which was showing incorrect values for
> %util, is now showing correct values.

Please add the theory behind why using nano-seconds can get correct accounting.

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
> From fio
> --------
> Read Latency: clat (usec): min=32, max=2335, avg=79.54, stdev=29.95
> Write Latency: clat (usec): min=38, max=130, avg=57.76, stdev= 3.25

Can you explain a bit why the above %util is correct?

BTW, %util is usually not important for SSDs, please see 'man iostat':

     %util
            Percentage of elapsed time during which I/O requests were issued to the device (bandwidth  uti‐
            lization for the device). Device saturation occurs when this value is close to 100% for devices
            serving requests serially.  But for devices serving requests in parallel, such as  RAID  arrays
            and modern SSDs, this number does not reflect their performance limits.


Thanks, 
Ming


