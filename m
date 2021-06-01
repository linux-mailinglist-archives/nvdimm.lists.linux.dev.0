Return-Path: <nvdimm+bounces-90-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id CE82A38DA71
	for <lists+linux-nvdimm@lfdr.de>; Sun, 23 May 2021 10:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D88431C0DF3
	for <lists+linux-nvdimm@lfdr.de>; Sun, 23 May 2021 08:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF466D00;
	Sun, 23 May 2021 08:25:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914F717F
	for <nvdimm@lists.linux.dev>; Sun, 23 May 2021 08:25:26 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1621758325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVOkU6mPxfn5BVd8GlNU1HfGC6hDoW8TTxQlBhTR3w4=;
	b=i84+upGPrpeJEmerMBQJF8+vWdmEewYx5EjW7zLq6a/Sd5XWtPkssabYioaGiBH/ol/7RV
	FKOJhUGVlyY0Pn7Yudmj2SLwKy3IxGFWAVQM/OubG3+Ll6DH37tGIs6JOI9Pz78rRYWVcV
	r45V4o9tzsbKOWL/LET+rvYyDrmOroI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1621758325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVOkU6mPxfn5BVd8GlNU1HfGC6hDoW8TTxQlBhTR3w4=;
	b=BxnwIpSQOILsGXJCLzFOCfyUewZzX7miKhHWSWPYYMp0u4/JoaXtnu/6UQ7IUzRln4yuju
	eRhUjWD+2qtDE3Bw==
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 19B96AC3A;
	Sun, 23 May 2021 08:25:25 +0000 (UTC)
Subject: Re: [PATCH 25/26] null_blk: convert to
 blk_alloc_disk/blk_cleanup_disk
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Chris Zankel <chris@zankel.net>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
 Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>,
 Nitin Gupta <ngupta@vflare.org>, Matias Bjorling <mb@lightnvm.io>,
 Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
 Song Liu <song@kernel.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
 Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
 drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-26-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <a900d30c-811c-c90f-c24c-22134e750b3d@suse.de>
Date: Sun, 23 May 2021 10:25:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-26-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 5/21/21 7:51 AM, Christoph Hellwig wrote:
> Convert the null_blk driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.  Note that the
> blk-mq mode is left with its own allocations scheme, to be handled later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/null_blk/main.c | 38 +++++++++++++++++------------------
>   1 file changed, 19 insertions(+), 19 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

