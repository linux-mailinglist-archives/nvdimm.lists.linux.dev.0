Return-Path: <nvdimm+bounces-9449-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 565F79E41DE
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Dec 2024 18:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DC86B3495A
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Dec 2024 16:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78E820CCFB;
	Wed,  4 Dec 2024 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jwLrm3XJ";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jwLrm3XJ"
X-Original-To: nvdimm@lists.linux.dev
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD46B20B80D
	for <nvdimm@lists.linux.dev>; Wed,  4 Dec 2024 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330565; cv=none; b=q50J10B6pw8TNAES+LzGjnPJR7oagIZVxUcKUABqfsOZZSeRsl8oQSSM16EPRgxrJInEqnbvR0Gj2K09sqiwG1159r3ABesMNez4M/KqL5TrLUoEHNkIZLDTF9WQi1FvF8PHiz9opMgoQdRz3KGKTje/WGowG3ksnl21lTMSbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330565; c=relaxed/simple;
	bh=/tV2/rqC9g/RzItU4xjpFfq9TJiKncFzSdSN5cVSPCI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ps0RVQQ3j3Inz8OjyB3o2K1XtiNAUVpQ9ikYpz41UzOh2qpHidfY2Cic4QUWX68zTvvtirtTrpOYTwEIM36HTXUO8WDbd2UN1BQYI9i6zv5ibS8efdedOdi18jK0DUkbmK6+OtwPajhjcwRX1phFBZ3yTN1d2cUi1I/JaP1bqlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=jwLrm3XJ; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=jwLrm3XJ; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1733330561;
	bh=/tV2/rqC9g/RzItU4xjpFfq9TJiKncFzSdSN5cVSPCI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=jwLrm3XJJg0bE+y+jmRYNMFwEElygfQC2HGQiHPd5Xz/u0WtyW7YWY3rX060euBo7
	 f9S1jUzBwKhA2RFoWPD/ZkuHcVNkBdGsPnMe1XGCn2DaqvTsyQjVXKsqZzFLZSZ0Tt
	 bvl4/NIRU0Ww5p2EbpvPP+Glg6xJuhny+E4/K7oQ=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id DBE1112816C9;
	Wed, 04 Dec 2024 11:42:41 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id H1OGkhq900B6; Wed,  4 Dec 2024 11:42:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1733330561;
	bh=/tV2/rqC9g/RzItU4xjpFfq9TJiKncFzSdSN5cVSPCI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=jwLrm3XJJg0bE+y+jmRYNMFwEElygfQC2HGQiHPd5Xz/u0WtyW7YWY3rX060euBo7
	 f9S1jUzBwKhA2RFoWPD/ZkuHcVNkBdGsPnMe1XGCn2DaqvTsyQjVXKsqZzFLZSZ0Tt
	 bvl4/NIRU0Ww5p2EbpvPP+Glg6xJuhny+E4/K7oQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 13309128116A;
	Wed, 04 Dec 2024 11:42:36 -0500 (EST)
Message-ID: <5c905df49a332b1136787a524955b46b6153c012.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 00/32] driver core: Constify API device_find_child()
 and adapt for various existing usages
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Zijun Hu <zijun_hu@icloud.com>, Thomas =?ISO-8859-1?Q?Wei=DFschuh?=
	 <thomas@t-8ch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Uwe
 =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Chun-Kuang Hu <chunkuang.hu@kernel.org>, Philipp Zabel
 <p.zabel@pengutronix.de>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Jean
 Delvare <jdelvare@suse.com>,  Guenter Roeck <linux@roeck-us.net>, Martin
 Tuma <martin.tuma@digiteqautomotive.com>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Andreas Noever <andreas.noever@gmail.com>, Michael
 Jamet <michael.jamet@intel.com>, Mika Westerberg
 <mika.westerberg@linux.intel.com>,  Yehezkel Bernat
 <YehezkelShB@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Bartosz
 Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean
 <olteanv@gmail.com>,  "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Takashi
 Sakamoto <o-takashi@sakamocchi.jp>, Jiri Slaby <jirislaby@kernel.org>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, Srinivas Kandagatla
 <srinivas.kandagatla@linaro.org>, Lee Duncan <lduncan@suse.com>, Chris
 Leech <cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali
 <njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Davidlohr Bueso
 <dave@stgolabs.net>, Jonathan Cameron <jonathan.cameron@huawei.com>, Alison
 Schofield <alison.schofield@intel.com>, Andreas Larsson
 <andreas@gaisler.com>, Stuart Yoder <stuyoder@gmail.com>, Laurentiu Tudor
 <laurentiu.tudor@nxp.com>, Jens Axboe <axboe@kernel.dk>, Sudeep Holla
 <sudeep.holla@arm.com>, Cristian Marussi <cristian.marussi@arm.com>, Ard
 Biesheuvel <ardb@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-usb@vger.kernel.org, linux-gpio@vger.kernel.org,
 netdev@vger.kernel.org,  linux-pwm@vger.kernel.org, nvdimm@lists.linux.dev,
  linux1394-devel@lists.sourceforge.net, linux-serial@vger.kernel.org, 
 linux-sound@vger.kernel.org, open-iscsi@googlegroups.com, 
 linux-scsi@vger.kernel.org, linux-cxl@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-block@vger.kernel.org, 
 arm-scmi@vger.kernel.org, linux-efi@vger.kernel.org, 
 linux-remoteproc@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Date: Wed, 04 Dec 2024 11:42:34 -0500
In-Reply-To: <235ce0a9-1db1-4558-817b-6f92f22be5ab@icloud.com>
References: <20241203-const_dfc_done-v2-0-7436a98c497f@quicinc.com>
	 <g32cigmktmj4egkq2tof27el2yss4liccfxgebkgqvkil32mlb@e3ta4ezv7y4m>
	 <9d34bd6f-b120-428a-837b-5a5813e14618@icloud.com>
	 <2024120320-manual-jockey-dfd1@gregkh>
	 <b9885785-d4d4-4c72-b425-3dc552651d7e@icloud.com>
	 <8eb7c0c54b280b8eb72f82032ede802c001ab087.camel@HansenPartnership.com>
	 <8fb887a0-3634-4e07-9f0d-d8d7c72ca802@t-8ch.de>
	 <f5ea7e17-5550-4658-8f4c-1c51827c7627@icloud.com>
	 <108c63c753f2f637a72c2e105ac138f80d4b0859.camel@HansenPartnership.com>
	 <235ce0a9-1db1-4558-817b-6f92f22be5ab@icloud.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2024-12-04 at 20:26 +0800, Zijun Hu wrote:
> On 2024/12/3 23:34, James Bottomley wrote:
> > > > This also enables an incremental migration.
> > > change the API prototype from:
> > > device_find_child(..., void *data_0, int (*match)(struct device
> > > *dev, void *data));
> > > 
> > > to:
> > > device_find_child(..., const void *data_0, int (*match)(struct
> > > device *dev, const void *data));
> > > 
> > > For @data_0,  void * -> const void * is okay.
> > > but for @match, the problem is function pointer type
> > > incompatibility.
> > > 
> > > there are two solutions base on discussions.
> > > 
> > > 1) squashing likewise Greg mentioned.
> > >    Do all of the "prep work" first, and then
> > >    do the const change at the very end, all at once.
> > > 
> > > 2)  as changing platform_driver's remove() prototype.
> > > Commit: e70140ba0d2b ("Get rid of 'remove_new' relic from
> > > platform driver struct")
> > > 
> > >  introduce extra device_find_child_new() which is constified  ->
> > > use *_new() replace ALL device_find_child() instances one by one
> > > -> remove device_find_child() -> rename *_new() to
> > > device_find_child() once.
> > Why bother with the last step, which churns the entire code base
> > again?
> 
> keep the good API name device_find_child().

Well, I think it's a good opportunity to rename the API better, but if
that's the goal, you can still do it with _Generic() without churning
the code base a second time.  The example is in
slab.h:kmem_cache_create

> > Why not call the new function device_find_child_const() and simply
> > keep it (it's descriptive of its function).  That way you can have
> > a patch series without merging and at the end simply remove the old
> > function.
> 
> device_find_child is a good name for the API, 'find' already means
> const.

Not to me it doesn't, but that's actually not what I think is wrong
with the API name: it actually only returns the first match, so I'd
marginally prefer it to be called device_find_first_child() ... not
enough to churn the code to change it, but since you're doing that
anyway it might make sense as an update.

Regards,

James


