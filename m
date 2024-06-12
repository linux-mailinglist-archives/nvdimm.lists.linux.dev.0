Return-Path: <nvdimm+bounces-8292-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DBD905620
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jun 2024 17:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87FAE1C24648
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jun 2024 15:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857481802A1;
	Wed, 12 Jun 2024 15:00:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348E17E908;
	Wed, 12 Jun 2024 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718204438; cv=none; b=U9olWZhmmpzkJVfQRScHPbS72Y5GyxohpNsDsNR2yQnvQ4jeYtPltRIhpkpqWcDZlajD9WSH10le9BLiVEuVtBAt59AKF/AiM2ahUliE7iUkMoLIo3Go26e7sFvfKXDtvOBH+GTnM5MYlvmeDC78YHkiP0hs8+3KtKIQ3KDedjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718204438; c=relaxed/simple;
	bh=D9AKY16RIxKwWo5ffG5YBSyB4zSbRy1JLPHVsaztKec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsG0DqrZW7xA8Ia6EKTijnXLeGE5rLIpIRrp6rY2N2yhoVdaEyNhlkjCoI5Q9yqmtROrEyc2Gljc/htTR9JLELRwPF9crjyVXY0bxaB0tEwRu3cOPzS4iMudCAbtyZI/eOzZS6kkq4TFWVGFlaBq7kZ42CX9cGhb5H0ek6v4U+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E11668AFE; Wed, 12 Jun 2024 17:00:30 +0200 (CEST)
Date: Wed, 12 Jun 2024 17:00:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 10/26] xen-blkfront: don't disable cache flushes when
 they fail
Message-ID: <20240612150030.GA29188@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-11-hch@lst.de> <ZmlVziizbaboaBSn@macbook>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZmlVziizbaboaBSn@macbook>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 12, 2024 at 10:01:18AM +0200, Roger Pau Monn� wrote:
> On Tue, Jun 11, 2024 at 07:19:10AM +0200, Christoph Hellwig wrote:
> > blkfront always had a robust negotiation protocol for detecting a write
> > cache.  Stop simply disabling cache flushes when they fail as that is
> > a grave error.
> 
> It's my understanding the current code attempts to cover up for the
> lack of guarantees the feature itself provides:

> So even when the feature is exposed, the backend might return
> EOPNOTSUPP for the flush/barrier operations.

How is this supposed to work?  I mean in the worst case we could
just immediately complete the flush requests in the driver, but
we're really lying to any upper layer.

> Such failure is tied on whether the underlying blkback storage
> supports REQ_OP_WRITE with REQ_PREFLUSH operation.  blkback will
> expose "feature-barrier" and/or "feature-flush-cache" without knowing
> whether the underlying backend supports those operations, hence the
> weird fallback in blkfront.

If we are just talking about the Linux blkback driver (I know there
probably are a few other implementations) it won't every do that.
I see it has code to do so, but the Linux block layer doesn't
allow the flush operation to randomly fail if it was previously
advertised.  Note that even blkfront conforms to this as it fixes
up the return value when it gets this notsupp error to ok.

> Overall blkback should ensure that REQ_PREFLUSH is supported before
> exposing "feature-barrier" or "feature-flush-cache", as then the
> exposed features would really match what the underlying backend
> supports (rather than the commands blkback knows about).

Yes.  The in-tree xen-blkback does that, but even without that the
Linux block layer actually makes sure flushes sent by upper layers
always succeed even when not supported.


