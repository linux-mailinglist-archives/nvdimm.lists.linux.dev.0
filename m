Return-Path: <nvdimm+bounces-100-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id F01F738E1A2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 09:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2FA851C0EE3
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 07:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C309A6D00;
	Mon, 24 May 2021 07:26:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FF36D0D
	for <nvdimm@lists.linux.dev>; Mon, 24 May 2021 07:26:45 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1676267373; Mon, 24 May 2021 09:26:43 +0200 (CEST)
Date: Mon, 24 May 2021 09:26:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
	drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
	linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 14/26] md: convert to blk_alloc_disk/blk_cleanup_disk
Message-ID: <20210524072642.GF23890@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-15-hch@lst.de> <e65de9e6-337c-3e41-b5c2-d033ff236582@suse.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e65de9e6-337c-3e41-b5c2-d033ff236582@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, May 23, 2021 at 10:12:49AM +0200, Hannes Reinecke wrote:
>> +	blk_set_stacking_limits(&mddev->queue->limits);
>>   	blk_queue_write_cache(mddev->queue, true, true);
>>   	/* Allow extended partitions.  This makes the
>>   	 * 'mdp' device redundant, but we can't really
>>
> Wouldn't it make sense to introduce a helper 'blk_queue_from_disk()' or 
> somesuch to avoid having to keep an explicit 'queue' pointer?

My rought plan is that a few series from now bio based drivers will
never directly deal with the request_queue at all.

