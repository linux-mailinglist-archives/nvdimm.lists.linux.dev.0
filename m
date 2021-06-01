Return-Path: <nvdimm+bounces-102-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D12EF38E247
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 10:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A554B1C0DFB
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 May 2021 08:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4BF6D00;
	Mon, 24 May 2021 08:27:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA8F17F
	for <nvdimm@lists.linux.dev>; Mon, 24 May 2021 08:27:24 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1621844838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1F35rBDncf+ODcVO5jTKQ+c6J+Bpaijj4tb+WLiO1U=;
	b=hWbnJCzrn8D8sq7QiamSboM/nv6TN+2iWleusnloao35oVE4OyeDX0eKAMzya8OGGThQFh
	zl1nxRchNuFxstuajSgFtmryku8O1hRGBIRcM0SbrM2Dt3hLAz/KodIIf9vgrdWDs21AJk
	09tFtAADDGOyfSpK1oh2IZudvgHfbuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1621844838;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1F35rBDncf+ODcVO5jTKQ+c6J+Bpaijj4tb+WLiO1U=;
	b=/Ey/RBTrd/apAViE3Xd9DP0Lfre1LBpPPlJZl5IzG70TmMypTfoLUolyItvUQoIO9R6YkJ
	B6psOuCyZCUW50Cw==
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CBD6EAB6D;
	Mon, 24 May 2021 08:27:17 +0000 (UTC)
Subject: Re: [PATCH 14/26] md: convert to blk_alloc_disk/blk_cleanup_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
 Joshua Morris <josh.h.morris@us.ibm.com>,
 Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>,
 Nitin Gupta <ngupta@vflare.org>, Matias Bjorling <mb@lightnvm.io>,
 Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
 Song Liu <song@kernel.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
 Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, linux-m68k@lists.linux-m68k.org,
 linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
 linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-15-hch@lst.de>
 <e65de9e6-337c-3e41-b5c2-d033ff236582@suse.de>
 <20210524072642.GF23890@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <1360c598-44a9-e0c5-dd81-695cb1ec8ccf@suse.de>
Date: Mon, 24 May 2021 10:27:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210524072642.GF23890@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 5/24/21 9:26 AM, Christoph Hellwig wrote:
> On Sun, May 23, 2021 at 10:12:49AM +0200, Hannes Reinecke wrote:
>>> +	blk_set_stacking_limits(&mddev->queue->limits);
>>>    	blk_queue_write_cache(mddev->queue, true, true);
>>>    	/* Allow extended partitions.  This makes the
>>>    	 * 'mdp' device redundant, but we can't really
>>>
>> Wouldn't it make sense to introduce a helper 'blk_queue_from_disk()' or
>> somesuch to avoid having to keep an explicit 'queue' pointer?
> 
> My rought plan is that a few series from now bio based drivers will
> never directly deal with the request_queue at all.
> 
Go for it.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

