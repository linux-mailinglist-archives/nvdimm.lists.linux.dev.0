Return-Path: <nvdimm+bounces-8238-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D8A9034EB
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jun 2024 10:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D8D11C23303
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jun 2024 08:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378F8173349;
	Tue, 11 Jun 2024 08:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASIoL/u9"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940522AF11;
	Tue, 11 Jun 2024 08:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093392; cv=none; b=WQbdfO5lONPHbfIKeTJMLHceaHCYiOUVArd/IcnGPuPv8yayceZaLqgW5EAkFB+Uzy/kKc1BVNAy1+v0a6xI6Wqiij8z6qleCf6w+jVvXlCcrChIvE5xu2MQHA3wbYYkfACB0lHl5wlP7InoEEMhSiD+0cZ8YbtvpQ66AFJ3/1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093392; c=relaxed/simple;
	bh=q0QC/DwdDecsb+SsO2WPgUlAOrUNDUio/s56qnb48bM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jp/OBNxEqs4ZpgIKmlwxRdyqCmTF0u7vSJIMdl4X24kTNTeWbQbXrpxPsWjzS1LpsTWdHc+a3eLSv9oSL7s5ev+e5Bu0G6NLuQzSrAeKlHP3TwrjJMq/LWjS5SZ3wqV/xChW30iEiTDh1MTFyuWk9GWQerhloxMfhG8vwzAnVWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASIoL/u9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F729C2BD10;
	Tue, 11 Jun 2024 08:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718093392;
	bh=q0QC/DwdDecsb+SsO2WPgUlAOrUNDUio/s56qnb48bM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ASIoL/u9H/6b4lUyYk5oEzSADY2SPITglYQKbn22RE2v5Zmv+Bdu4yXt2dx4LBuyj
	 NVG1rUDMHnNTWyjPGwlGMS7q0dEKke4PAWQg/UzftKu/Ly2DNOhNfxEkKQj6EFDaHU
	 gbMPLXlbaDGII4KmlbUUWCoStYYGCahBnCwU3sHyUUKQqZ1YdU0vcRocoxwls2ROg2
	 gKF/wxkN6x65ww9rMbS9NJlQNYUg7Y5U2acfwFYdpXRWwDXOcSxo1CVQbqP3uooiqP
	 0hvYmqaICGemmnL938SwljJXBPejQKyIB0+ALAtSSclYdQCRHYhtFi/CQNV4wF5aIA
	 8HiTkYhUDl6Cg==
Message-ID: <d51e4163-99e3-4435-870d-faef3887ab6a@kernel.org>
Date: Tue, 11 Jun 2024 17:09:45 +0900
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/26] block: move the io_stat flag setting to
 queue_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
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
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-17-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-17-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the io_stat flag into the queue_limits feature field so that it
> can be set atomically and all I/O is frozen when changing the flag.

Why a feature ? It seems more appropriate for io_stat to be a flag rather than
a feature as that is a block layer thing rather than a device characteristic, no ?

> 
> Simplify md and dm to set the flag unconditionally instead of avoiding
> setting a simple flag for cases where it already is set by other means,
> which is a bit pointless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

-- 
Damien Le Moal
Western Digital Research


