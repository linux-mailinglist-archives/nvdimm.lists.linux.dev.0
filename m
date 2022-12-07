Return-Path: <nvdimm+bounces-5464-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD7D645278
	for <lists+linux-nvdimm@lfdr.de>; Wed,  7 Dec 2022 04:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BFEF280ABD
	for <lists+linux-nvdimm@lfdr.de>; Wed,  7 Dec 2022 03:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5051F390;
	Wed,  7 Dec 2022 03:16:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC42938D
	for <nvdimm@lists.linux.dev>; Wed,  7 Dec 2022 03:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670382971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=faTdYvtAe2NMddrehpXs2XQgPcQu3OATzJcZ1A/nsDA=;
	b=C3TkD5+TPZGfuMHACQKU+IMVX8AkVjxXVuG59Pvs+47dWgZdH0aB2mnzV18JIKH4Ku38Hz
	eBuO26xslstJbC8VF02ziRQmKpSOXGBq5uf2qd3z2AvwNyXMjhnD5um3tCPWQK+eopPaYX
	dSKn9qmJOfJ9vytS81GuaA8FOWyJlSY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-qPbK1vmPPgSMR5tC6UfxoA-1; Tue, 06 Dec 2022 22:16:07 -0500
X-MC-Unique: qPbK1vmPPgSMR5tC6UfxoA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3F5C811E67;
	Wed,  7 Dec 2022 03:16:05 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A29517AE5;
	Wed,  7 Dec 2022 03:15:49 +0000 (UTC)
Date: Wed, 7 Dec 2022 11:15:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org,
	axboe@kernel.dk, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
	minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
	colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
	snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, junxiao.bi@oracle.com,
	martin.petersen@oracle.com, kch@nvidia.com,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, konrad.wilk@oracle.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [RFC] block: Change the granularity of io ticks from ms to ns
Message-ID: <Y5AFX4sxLRLV4uSt@T590>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
 <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5

On Wed, Dec 07, 2022 at 10:19:08AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/12/07 2:15, Gulam Mohamed 写道:
> > Use ktime to change the granularity of IO accounting in block layer from
> > milli-seconds to nano-seconds to get the proper latency values for the
> > devices whose latency is in micro-seconds. After changing the granularity
> > to nano-seconds the iostat command, which was showing incorrect values for
> > %util, is now showing correct values.
> 
> This patch didn't correct the counting of io_ticks, just make the
> error accounting from jiffies(ms) to ns. The problem that util can be
> smaller or larger still exist.

Agree.

> 
> However, I think this change make sense consider that error margin is
> much smaller, and performance overhead should be minimum.
> 
> Hi, Ming, how do you think?

I remembered that ktime_get() has non-negligible overhead, is there any
test data(iops/cpu utilization) when running fio or t/io_uring on
null_blk with this patch?


Thanks, 
Ming


