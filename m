Return-Path: <nvdimm+bounces-95-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640C238E16B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 09:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 7F7833E1015
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 07:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8120C6D00;
	Mon, 24 May 2021 07:20:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9490817F
	for <nvdimm@lists.linux.dev>; Mon, 24 May 2021 07:20:23 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A686B67373; Mon, 24 May 2021 09:20:13 +0200 (CEST)
Date: Mon, 24 May 2021 09:20:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Luis Chamberlain <mcgrof@kernel.org>
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
	linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 01/26] block: refactor device number setup
 in __device_add_disk
Message-ID: <20210524072013.GA23890@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-2-hch@lst.de> <20210521171646.GA25017@42.do-not-panic.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521171646.GA25017@42.do-not-panic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 21, 2021 at 05:16:46PM +0000, Luis Chamberlain wrote:
> > -	/* in consecutive minor range? */
> > -	if (bdev->bd_partno < disk->minors) {
> > -		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
> > -		return 0;
> > -	}
> > -
> 
> It is not obviously clear to me, why this was part of add_disk()
> path, and ...
> 
> > diff --git a/block/partitions/core.c b/block/partitions/core.c
> > index dc60ecf46fe6..504297bdc8bf 100644
> > --- a/block/partitions/core.c
> > +++ b/block/partitions/core.c
> > @@ -379,9 +380,15 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
> >  	pdev->type = &part_type;
> >  	pdev->parent = ddev;
> >  
> > -	err = blk_alloc_devt(bdev, &devt);
> > -	if (err)
> > -		goto out_put;
> > +	/* in consecutive minor range? */
> > +	if (bdev->bd_partno < disk->minors) {
> > +		devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
> > +	} else {
> > +		err = blk_alloc_ext_minor();
> > +		if (err < 0)
> > +			goto out_put;
> > +		devt = MKDEV(BLOCK_EXT_MAJOR, err);
> > +	}
> >  	pdev->devt = devt;
> >  
> >  	/* delay uevent until 'holders' subdir is created */
> 
> ... and why we only add this here now.

For the genhd minors == 0 (aka GENHD_FL_EXT_DEVT) implies having to
allocate a dynamic dev_t, so it can be folded into another conditional.

