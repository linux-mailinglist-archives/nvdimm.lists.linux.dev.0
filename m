Return-Path: <nvdimm+bounces-8264-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F0390404E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jun 2024 17:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5F201C22757
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jun 2024 15:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E72383A0;
	Tue, 11 Jun 2024 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3ImpHwF"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1031383A2
	for <nvdimm@lists.linux.dev>; Tue, 11 Jun 2024 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120615; cv=none; b=U5E0xCH8IzFefJpn06Tt+8kHw+WqmUxckvaCuyeEyBFyDEYr8iOvwNOWxAqyS0UGPzfUxJGu/SdOxdmC/a6RnJkvRZpXDMkeCkr5Vig8qiiZZoEF6nHlEaj1cFVGItoNXob0cjlcQMT7653oFatxLyHj6asF33fuKNODxzxsHO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120615; c=relaxed/simple;
	bh=hxyesTbSn4JUu13b+/8fKE9DKC9Hdh6kphyvoTo4A04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wjuwp8vSRvZV3LgxZBdIF/f33NQS5jMeS6iXZHWfkNbliP5ouuA3iJdpTCG/e4IQ9G6euk9VM1k/cEbJhS8MrHedEu4FJpaURh8E0FKqgAs3L/qV3FYUuPrE1wHAB3f2Dy6NNlNJWkzOh9r2Jekrh6kNk8ko1qmSZprrZrh5eog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g3ImpHwF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718120612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m3mVOlE8X03VcFujwgTUstJqoq0FTNeRmucJ5uXzzb4=;
	b=g3ImpHwFPd3zYDbSo6+DyCmL/sFBqBusrGTGQ+nUJ1Jc3pjC2QGt6IElAywhXBseiygDNC
	z6Eh48Xu/zfSEPDq602vJsDch/Zk73o2E+gsTG0mWXmfLdGVuBh2n43fjFcUbiwN2993ci
	LMQuTert1Fi/8EYVt+zdL5AN8obFP8c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-M7gCHZsfNvaRoPk4wQQxjw-1; Tue,
 11 Jun 2024 11:43:27 -0400
X-MC-Unique: M7gCHZsfNvaRoPk4wQQxjw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8414F1956068;
	Tue, 11 Jun 2024 15:43:15 +0000 (UTC)
Received: from localhost (unknown [10.39.193.36])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DD4331954AC1;
	Tue, 11 Jun 2024 15:43:10 +0000 (UTC)
Date: Tue, 11 Jun 2024 11:43:09 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
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
Subject: Re: [PATCH 08/26] virtio_blk: remove virtblk_update_cache_mode
Message-ID: <20240611154309.GA371660@fedora.redhat.com>
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RRHJimCDVdpqhQ+7"
Content-Disposition: inline
In-Reply-To: <20240611051929.513387-9-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


--RRHJimCDVdpqhQ+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 07:19:08AM +0200, Christoph Hellwig wrote:
> virtblk_update_cache_mode boils down to a single call to
> blk_queue_write_cache.  Remove it in preparation for moving the cache
> control flags into the queue_limits.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/virtio_blk.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--RRHJimCDVdpqhQ+7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmZocI0ACgkQnKSrs4Gr
c8gYxQf+MiHN7lIto5cvBArHuLRaYXdHSqN8WkOxjyk6pKDVJN3zByol4IsQ1or0
gi3U/1yXaU1lyM8v76HhRI789ZE9OXHiRD8iKWM54w0uldvJLPNzByqsrvapKvmR
XjYyMxgp/uFJZ4qxg3nonI2Fa2FzSjqA/ct/sTYj8AbXOsOEK/bUZasvnrwUuIhP
FwODujdCtfIpzMvn4c262LUiz3TOY+p3nH/CSKsYZwR5xiUbbZCf30PKrwN4RcmU
ti4hIKoOJcLH5gjgeXpfx7jOM/6Qr7eQrEelsDnuMAKYXC9WMj48+O6Cf8mFja4M
N1txQKX0NepjOjzDmydD5Dx/69S/sg==
=ehtQ
-----END PGP SIGNATURE-----

--RRHJimCDVdpqhQ+7--


