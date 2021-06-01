Return-Path: <nvdimm+bounces-99-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id D416938E196
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 09:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 64E963E107A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 07:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C55F6D0D;
	Mon, 24 May 2021 07:26:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C1D2FB1
	for <nvdimm@lists.linux.dev>; Mon, 24 May 2021 07:25:59 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1B4B67373; Mon, 24 May 2021 09:25:57 +0200 (CEST)
Date: Mon, 24 May 2021 09:25:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>, Philip Kelleher <pjk1939@linux.ibm.com>,
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
Subject: Re: [PATCH 13/26] dm: convert to blk_alloc_disk/blk_cleanup_disk
Message-ID: <20210524072557.GE23890@lst.de>
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-14-hch@lst.de> <de3b0976-1299-17d8-240a-2ecd8b9fbc2d@suse.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de3b0976-1299-17d8-240a-2ecd8b9fbc2d@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, May 23, 2021 at 10:10:34AM +0200, Hannes Reinecke wrote:
> Can't these conditionals be merged into a single 'if (md->disk)'?
> Eg like:
>
> 	if (md->disk) {
> 		spin_lock(&_minor_lock);
> 		md->disk->private_data = NULL;
> 		spin_unlock(&_minor_lock);
> 		del_gendisk(md->disk);
> 		dm_queue_destroy_keyslot_manager(md->queue);
> 		blk_cleanup_disk(md->queue);
> 	}
>
> We're now always allocating 'md->disk' and 'md->queue' together,
> so how can we end up in a situation where one is set without the other?

I guess we could do that, not sure it is worth the churn, though.

