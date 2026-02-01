Return-Path: <nvdimm+bounces-12992-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id PhD9NkzZfmmQfgIAu9opvQ
	(envelope-from <nvdimm+bounces-12992-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 01 Feb 2026 05:40:44 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BD6C4EB9
	for <lists+linux-nvdimm@lfdr.de>; Sun, 01 Feb 2026 05:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B309F3011742
	for <lists+linux-nvdimm@lfdr.de>; Sun,  1 Feb 2026 04:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC682798F3;
	Sun,  1 Feb 2026 04:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="J7MGQwVO"
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7D748F;
	Sun,  1 Feb 2026 04:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769920840; cv=pass; b=eEkKIht6H/Vg/f14mjXGcRdI+zKncE3f9ZHii0wSc17PbuOUYUj5TOndeVwtx3Pxc4wb0oVtAAVGVWwH6AK2HtyVFxy6rXqhdlkKnrzW+Q/oWvjzOi76rJcy08ocy7/oXS6ea1M6VvM3bqKJghABCvgpwUEwAuOTMcPfySbAnTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769920840; c=relaxed/simple;
	bh=zx3uK6OUyhKOc8SgSfvJ1t/xjxISwq/GyLbRzxjb8fM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ii9AXcQI25dyq4fs7cWkdfZlCFndGkey+ZaKxsEkObnD++nnmAzPCRwQ6c4bxsrBr0/0Jhhrmz+8+dPqmggx/V3Xg+LkTG+OfsqYb8iPz0eSafOOUwlHzvuZOpIAET2sMfXbDP4oO/uurLeqK+Schu8iLXJMLriRE4zQMa5xFZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=J7MGQwVO; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1769920830; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OCH0Bjxk+SCfTxm05bjBFgq9f4ZE/N9hSg5558ja2++fFUBUJVddhSJVFMopSXsyz36NCv8nDboU6ZYev+V9zt/0a3ipmEkipRi8sQOkx+Jk65FemvM7rIcenhKn4dAMmQ7zixo6PSvwBcN3Cu/JrTNNPoMk/aazJ1GBO/b9B5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769920830; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Mg0/vv+N2TY3Mun8A569+YtuS6aKPFTWr3H+LYPY9rA=; 
	b=hKRbiSy8FhZRqq9u0R4HLDG7GR+Vw+Dp7a4GsFnO3w3Kl/k36QlPTVgbh7cXpMaaqhm3cPi9R4io6obN+zVzWVkiFOPutHf1xqKzZkmK/1pRCeoUrbbilLUD2v2jhmd8wzN6SQAzLkuxcrOZ+wwSj+mbUH4NxmCGsqAlNCeHSF8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769920830;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:Message-ID:From:From:To:To:Cc:Cc:Subject:Subject:In-Reply-To:References:MIME-Version:Content-Type:Message-Id:Reply-To;
	bh=Mg0/vv+N2TY3Mun8A569+YtuS6aKPFTWr3H+LYPY9rA=;
	b=J7MGQwVOA5DBFqc9nmvyy3MYqMbV+CoXlv2LnLe6vejfbudQTIYQ2Ao3r615K5zV
	r3Zim2UkXrKk2wWEJ5phFZPA85Iphyo6HTOTZnCS+bRIv0xZndDuE00820g63WiTSQE
	Kec0u5krxFiTAHzQauA3oO+Ad26XuIoGlU5YEPwA=
Received: by mx.zohomail.com with SMTPS id 1769920828747568.2122837823392;
	Sat, 31 Jan 2026 20:40:28 -0800 (PST)
Date: Sun, 01 Feb 2026 12:40:15 +0800
Message-ID: <877bsxoz4g.wl-me@linux.beauty>
From: Li Chen <me@linux.beauty>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Jakub Staron <jstaron@google.com>,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm: virtio_pmem: serialize flush requests
In-Reply-To: <20260131124554-mutt-send-email-mst@kernel.org>
References: <20260113034552.62805-1-me@linux.beauty>
	<697d19fc772ad_f6311008@iweiny-mobl.notmuch>
	<20260131124554-mutt-send-email-mst@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?ISO-8859-4?Q?Goj=F2?=) APEL-LB/10.8 EasyPG/1.0.0
 Emacs/30.2 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-ZohoMailClient: External
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [9.84 / 15.00];
	URIBL_BLACK(7.50)[linux.beauty:email,linux.beauty:dkim,linux.beauty:mid];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12992-lists,linux-nvdimm=lfdr.de];
	R_DKIM_ALLOW(0.00)[linux.beauty:s=zmail];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[linux.beauty];
	FORGED_SENDER_MAILLIST(0.00)[];
	GREYLIST(0.00)[pass,meta];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,lists.linux.dev,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	R_SPF_ALLOW(0.00)[+ip4:172.234.253.10];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=2];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_SPAM(0.00)[0.766];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.beauty:email,linux.beauty:dkim,linux.beauty:mid]
X-Rspamd-Queue-Id: 37BD6C4EB9
X-Rspamd-Action: add header
X-Spam: Yes

Hi Michael,

On Sun, 01 Feb 2026 01:46:19 +0800,
Michael S. Tsirkin wrote:
> 
> On Fri, Jan 30, 2026 at 02:52:12PM -0600, Ira Weiny wrote:
> > Li Chen wrote:
> > > Under heavy concurrent flush traffic, virtio-pmem can overflow its request
> > > virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
> > > driver logs "no free slots in the virtqueue". Shortly after that the
> > > device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
> > > "virtio pmem device needs a reset".
> > > 
> > > Serialize virtio_pmem_flush() with a per-device mutex so only one flush
> > > request is in-flight at a time. This prevents req_vq descriptor overflow
> > > under high concurrency.
> > > 
> > > Reproducer (guest with virtio-pmem):
> > >   - mkfs.ext4 -F /dev/pmem0
> > >   - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
> > >   - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
> > >         direct=1 fsync=1 runtime=30s time_based=1
> > 
> > I don't see this error.
> > 
> > <file>
> > 13:28:50 > cat foo.fio 
> > # test http://lore.kernel.org/20260113034552.62805-1-me@linux.beauty
> > 
> > [global]
> > filename=/mnt/bench/foo
> > ioengine=io_uring
> > size=1G
> > bs=4K
> > iodepth=64
> > numjobs=64
> > direct=1
> > fsync=1
> > runtime=30s
> > time_based=1
> > 
> > [rand-write]
> > rw=randwrite
> > </file>
> > 
> > It's possible I'm doing something wrong.  Can you share your qemu cmdline
> > or more details on the bug yall see.
> > 
> > >   - dmesg: "no free slots in the virtqueue"
> > >            "virtio pmem device needs a reset"
> > > 
> > > Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > > Signed-off-by: Li Chen <me@linux.beauty>
> > > ---
> > >  drivers/nvdimm/nd_virtio.c   | 15 +++++++++++----
> > >  drivers/nvdimm/virtio_pmem.c |  1 +
> > >  drivers/nvdimm/virtio_pmem.h |  4 ++++
> > >  3 files changed, 16 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > index c3f07be4aa22..827a17fe7c71 100644
> > > --- a/drivers/nvdimm/nd_virtio.c
> > > +++ b/drivers/nvdimm/nd_virtio.c
> > > @@ -44,19 +44,24 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> > >  	unsigned long flags;
> > >  	int err, err1;
> > >  
> > > +	might_sleep();
> 
> 
> for that matter might_sleep not really needed near mutex_lock.
> 
> 
> > > +	mutex_lock(&vpmem->flush_lock);

Good point. mutex_lock() already does might_sleep(), so the explicit
might_sleep() next to the lock is redundant.

I'll drop it in v2 (which also switches to guard(mutex) as Ira suggested).

Regards,
Li

