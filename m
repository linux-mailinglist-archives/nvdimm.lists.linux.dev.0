Return-Path: <nvdimm+bounces-7553-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 414C08674A8
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 13:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72B331C22A59
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 12:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE66C604C5;
	Mon, 26 Feb 2024 12:21:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFB41D53D
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 12:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708950106; cv=none; b=CaDn8Hzxu+hesd82M9aMUec5aiEjdKtKTbB3xKDk66rloaQsthLcBkkC8kau9M0Ajm85gAljmfco5lIhe1bLkEsKKx57d3i8dGVzd9l3U9KPSj4IY9X1MtnCa9nCetu5g/MN6gozq2VtpIB6XPv6uHPB1LjIOogc8GdFyAnOT80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708950106; c=relaxed/simple;
	bh=pi3BrUr3ur1vJpL7LOfjfmoG+suaosBkg1tWLQHk5BU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ly+6zPZynVAef0pKdXaLm6MZec1ejG+5MLEI64ldtEQ8RfSMf1LoWev6PDtqbSblIGhkiRM4sji6fY0chZQlF0U3qcT493fi8Mn66GmvPKPU2IEblps+D89tykPPB9gu2cYh+TCBSTTnS4OWIDj39gH6dRqJhgmYE8QfC17/NhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tk04k1G1Pz6K9M8;
	Mon, 26 Feb 2024 20:17:58 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C7CA1400DB;
	Mon, 26 Feb 2024 20:21:41 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 12:21:40 +0000
Date: Mon, 26 Feb 2024 12:21:39 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: John Groves <John@Groves.net>
CC: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <john@jagalactic.com>, Dave Chinner
	<david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	<dave.hansen@linux.intel.com>, <gregory.price@memverge.com>
Subject: Re: [RFC PATCH 04/20] dev_dax_iomap: Save the kva from memremap
Message-ID: <20240226122139.0000135b@Huawei.com>
In-Reply-To: <66620f69fa3f3664d955649eba7da63fdf8d65ad.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
	<66620f69fa3f3664d955649eba7da63fdf8d65ad.1708709155.git.john@groves.net>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Feb 2024 11:41:48 -0600
John Groves <John@Groves.net> wrote:

> Save the kva from memremap because we need it for iomap rw support
> 
> Prior to famfs, there were no iomap users of /dev/dax - so the virtual
> address from memremap was not needed.
> 
> Also: in some cases dev_dax_probe() is called with the first
> dev_dax->range offset past pgmap[0].range. In those cases we need to
> add the difference to virt_addr in order to have the physaddr's in
> dev_dax->ranges match dev_dax->virt_addr.

Probably good to have info on when this happens and preferably why
this dragon is there.

> 
> Dragons...
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/dax-private.h |  1 +
>  drivers/dax/device.c      | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 446617b73aea..894eb1c66b4a 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -63,6 +63,7 @@ struct dax_mapping {
>  struct dev_dax {
>  	struct dax_region *region;
>  	struct dax_device *dax_dev;
> +	u64 virt_addr;

Why as a u64? If it's a virt address why not just void *?

>  	unsigned int align;
>  	int target_node;
>  	bool dyn_id;
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 40ba660013cf..6cd79d00fe1b 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -372,6 +372,7 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  	struct dax_device *dax_dev = dev_dax->dax_dev;
>  	struct device *dev = &dev_dax->dev;
>  	struct dev_pagemap *pgmap;
> +	u64 data_offset = 0;
>  	struct inode *inode;
>  	struct cdev *cdev;
>  	void *addr;
> @@ -426,6 +427,20 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  	if (IS_ERR(addr))
>  		return PTR_ERR(addr);
>  
> +	/* Detect whether the data is at a non-zero offset into the memory */
> +	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
> +		u64 phys = (u64)dev_dax->ranges[0].range.start;

Why the cast? Ranges use u64s internally.

> +		u64 pgmap_phys = (u64)dev_dax->pgmap[0].range.start;
> +		u64 vmemmap_shift = (u64)dev_dax->pgmap[0].vmemmap_shift;
> +
> +		if (!WARN_ON(pgmap_phys > phys))
> +			data_offset = phys - pgmap_phys;
> +
> +		pr_notice("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx shift=%llx\n",
> +		       __func__, phys, pgmap_phys, data_offset, vmemmap_shift);

pr_debug() + dynamic debug will then deal with __func__ for you.

> +	}
> +	dev_dax->virt_addr = (u64)addr + data_offset;
> +
>  	inode = dax_inode(dax_dev);
>  	cdev = inode->i_cdev;
>  	cdev_init(cdev, &dax_fops);


