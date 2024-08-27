Return-Path: <nvdimm+bounces-8868-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A46960D43
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Aug 2024 16:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6E991F21EBD
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Aug 2024 14:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8710B1C4607;
	Tue, 27 Aug 2024 14:12:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1591D551
	for <nvdimm@lists.linux.dev>; Tue, 27 Aug 2024 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724767964; cv=none; b=RzsewrzpdaDLTBlI7FdrGwO9nxZBD0J/ysE9w7KOTWmnFp0OFcbwwIT741FEw/4o27Tgjgq9xwMQ7J75BkMJ1uE6BXs6FKipxS3O/bRQOVOB/aza06teZCShHTeWRym630Dg+MEnpW0k/6Mr4RPf/zgA5m6HbDBYe7jo4tXwUhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724767964; c=relaxed/simple;
	bh=pRO3hQo72E3xr5ws/O5Z0MvWxXXaTaBCouA/PEAwMYw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VH+10buF541bXRXchkRVrIJGWoIOQddvxvI4N6wsSbXvRGoT4QMC9VASaCKw5PHowrimD2cY2PLVPAqfJyT3Yf2HiRXOOxWyTgCQEl2bPtByM4Edd9Ovlj/WQXIZiWkderDMs9mSPzF5Bd4C1u52DtaO6+hd7NWPPJVn9BrSu5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WtTt02yq2z6J75G;
	Tue, 27 Aug 2024 22:08:40 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id C1F4C140A87;
	Tue, 27 Aug 2024 22:12:38 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 27 Aug
 2024 15:12:38 +0100
Date: Tue, 27 Aug 2024 15:12:37 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Chris Mason <clm@fb.com>, Josef Bacik
	<josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Petr Mladek
	<pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-btrfs@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 21/25] dax/region: Create resources on sparse DAX
 regions
Message-ID: <20240827151237.00000f2b@Huawei.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-21-7c9b96cba6d7@intel.com>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
	<20240816-dcd-type2-upstream-v3-21-7c9b96cba6d7@intel.com>
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
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 16 Aug 2024 09:44:29 -0500
ira.weiny@intel.com wrote:

> From: Navneet Singh <navneet.singh@intel.com>
> 
> DAX regions which map dynamic capacity partitions require that memory be
> allowed to come and go.  Recall sparse regions were created for this
> purpose.  Now that extents can be realized within DAX regions the DAX
> region driver can start tracking sub-resource information.
> 
> The tight relationship between DAX region operations and extent
> operations require memory changes to be controlled synchronously with
> the user of the region.  Synchronize through the dax_region_rwsem and by
> having the region driver drive both the region device as well as the
> extent sub-devices.
> 
> Recall requests to remove extents can happen at any time and that a host
> is not obligated to release the memory until it is not being used.  If
> an extent is not used allow a release response.
> 
> The DAX layer has no need for the details of the CXL memory extent
> devices.  Expose extents to the DAX layer as device children of the DAX
> region device.  A single callback from the driver aids the DAX layer to
> determine if the child device is an extent.  The DAX layer also
> registers a devres function to automatically clean up when the device is
> removed from the region.
> 
> There is a race between extents being surfaced and the dax_cxl driver
> being loaded.  The driver must therefore scan for any existing extents
> while still under the device lock.
> 
> Respond to extent notifications.  Manage the DAX region resource tree
> based on the extents lifetime.  Return the status of remove
> notifications to lower layers such that it can manage the hardware
> appropriately.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
A few minor comments inline.

Jonathan

> 
> ---
> Changes:
> [iweiny: patch reorder]
> [iweiny: move hunks from other patches to clarify code changes and
>          add/release flows WRT dax regions]
> [iweiny: use %par]
> [iweiny: clean up variable names]
> [iweiny: Simplify sparse_ops]
> [Fan: avoid open coding range_len()]
> [djbw: s/reg_ext/region_extent]
> ---
>  drivers/cxl/core/extent.c |  76 +++++++++++++--
>  drivers/cxl/cxl.h         |   6 ++
>  drivers/dax/bus.c         | 243 +++++++++++++++++++++++++++++++++++++++++-----
>  drivers/dax/bus.h         |   3 +-
>  drivers/dax/cxl.c         |  63 +++++++++++-
>  drivers/dax/dax-private.h |  34 +++++++
>  drivers/dax/hmem/hmem.c   |   2 +-
>  drivers/dax/pmem.c        |   2 +-
>  8 files changed, 391 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index d7d526a51e2b..103b0bec3a4a 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -271,20 +271,67 @@ static void calc_hpa_range(struct cxl_endpoint_decoder *cxled,
>  	hpa_range->end = hpa_range->start + range_len(dpa_range) - 1;
>  }
>  
> +static int cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
> +			      struct region_extent *region_extent)
> +{
> +	struct cxl_dax_region *cxlr_dax;
> +	struct device *dev;
> +	int rc = 0;
> +
> +	cxlr_dax = cxlr->cxlr_dax;
> +	dev = &cxlr_dax->dev;
> +	dev_dbg(dev, "Trying notify: type %d HPA %par\n",
> +		event, &region_extent->hpa_range);
> +
> +	/*
> +	 * NOTE the lack of a driver indicates a notification has failed.  No
> +	 * user space coordiantion was possible.
> +	 */
> +	device_lock(dev);

I'd use guard() for this as then can just return the notify result
and drop local variable rc.


> +	if (dev->driver) {
> +		struct cxl_driver *driver = to_cxl_drv(dev->driver);
> +		struct cxl_notify_data notify_data = (struct cxl_notify_data) {
> +			.event = event,
> +			.region_extent = region_extent,
> +		};
> +
> +		if (driver->notify) {
> +			dev_dbg(dev, "Notify: type %d HPA %par\n",
> +				event, &region_extent->hpa_range);
> +			rc = driver->notify(dev, &notify_data);
> +		}
> +	}
> +	device_unlock(dev);
> +	return rc;
> +}
>
> @@ -338,8 +390,20 @@ static int cxlr_add_extent(struct cxl_dax_region *cxlr_dax,
>  		return rc;
>  	}
>  
> -	/* device model handles freeing region_extent */
> -	return online_region_extent(region_extent);
> +	rc = online_region_extent(region_extent);
> +	/* device model handled freeing region_extent */
> +	if (rc)
> +		return rc;
> +
> +	rc = cxlr_notify_extent(cxlr_dax->cxlr, DCD_ADD_CAPACITY, region_extent);
> +	/*
> +	 * The region device was breifly live but DAX layer ensures it was not

briefly

> +	 * used
> +	 */
> +	if (rc)
> +		region_rm_extent(region_extent);	
> +
> +	return rc;
>  }

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 975860371d9f..f14b0cfa7edd 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c

> +EXPORT_SYMBOL_GPL(dax_region_add_resource);
> +
> +int dax_region_rm_resource(struct dax_region *dax_region,
> +			   struct device *dev)
> +{
> +	struct dax_resource *dax_resource;
> +
> +	guard(rwsem_write)(&dax_region_rwsem);
> +
> +	dax_resource = dev_get_drvdata(dev);
> +	if (!dax_resource)
> +		return 0;
> +
> +	if (dax_resource->use_cnt)
> +		return -EBUSY;
> +
> +	/* avoid races with users trying to use the extent */

Not obvious to me from local code, why does releasing the resource
here avoid a race?  Perhaps the comment needs expanding.

> +	__dax_release_resource(dax_resource);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_region_rm_resource);
> +


> +static ssize_t dev_dax_resize_sparse(struct dax_region *dax_region,
> +				     struct dev_dax *dev_dax,
> +				     resource_size_t to_alloc)
> +{
> +	struct dax_resource *dax_resource;
> +	resource_size_t available_size;
> +	struct device *extent_dev;
> +	ssize_t alloc;
> +
> +	extent_dev = device_find_child(dax_region->dev, dax_region,
> +				       find_free_extent);

There is a __free for put device and it will tidy this up a tiny bit.

> +	if (!extent_dev)
> +		return 0;
> +
> +	dax_resource = dev_get_drvdata(extent_dev);
> +	if (!dax_resource)
> +		return 0;
> +
> +	available_size = dax_avail_size(dax_resource->res);
> +	to_alloc = min(available_size, to_alloc);
I'd put those two inline and skip the local variables unless
they have more use in later patches.

	alloc = __dev_dax_resize(dax_resources->res, dev_dax,
				 min(dax_avail_size(dax_resources->res), to_alloc),
				 dax_resource);
	
				
> +	alloc = __dev_dax_resize(dax_resource->res, dev_dax, to_alloc, dax_resource);
> +	if (alloc > 0)
> +		dax_resource->use_cnt++;
> +	put_device(extent_dev);
> +	return alloc;
> +}
> +

> @@ -1494,8 +1679,14 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	device_initialize(dev);
>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
>  
> +	if (is_sparse(dax_region) && data->size) {
> +		dev_err(parent, "Sparse DAX region devices are created initially with 0 size");
must be created initially with 0 size.

Otherwise this error message says that they are, so why is it an error?

> +		rc = -EINVAL;
> +		goto err_id;
> +	}
> +
>  	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
> -				 data->size);
> +				 data->size, NULL);
>  	if (rc)
>  		goto err_range;
>  

> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 367e86b1c22a..bf3b82b0120d 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -5,6 +5,60 @@

...

> +static int cxl_dax_region_notify(struct device *dev,
> +				 struct cxl_notify_data *notify_data)
> +{
> +	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
> +	struct dax_region *dax_region = dev_get_drvdata(dev);
> +	struct region_extent *region_extent = notify_data->region_extent;
> +
> +	switch (notify_data->event) {
> +	case DCD_ADD_CAPACITY:
> +		return __cxl_dax_add_resource(dax_region, region_extent);
> +	case DCD_RELEASE_CAPACITY:
> +		return dax_region_rm_resource(dax_region, &region_extent->dev);
> +	case DCD_FORCED_CAPACITY_RELEASE:
> +	default:
> +		dev_err(&cxlr_dax->dev, "Unknown DC event %d\n",
> +			notify_data->event);
> +		break;
Might as well return here and not below.
Makes it really really obvious this is the error path and currently the only
one that hits the return statement.
> +	}
> +
> +	return -ENXIO;
> +}

>  static int cxl_dax_region_probe(struct device *dev)
>  {
> @@ -24,14 +78,16 @@ static int cxl_dax_region_probe(struct device *dev)
>  		flags |= IORESOURCE_DAX_SPARSE_CAP;
>  
>  	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
> -				      PMD_SIZE, flags);
> +				      PMD_SIZE, flags, &sparse_ops);
>  	if (!dax_region)
>  		return -ENOMEM;
>  
> -	if (cxlr->mode == CXL_REGION_DC)
> +	if (cxlr->mode == CXL_REGION_DC) {
> +		device_for_each_child(&cxlr_dax->dev, dax_region,
> +				      cxl_dax_add_resource);
>  		/* Add empty seed dax device */
>  		dev_size = 0;
> -	else
> +	} else

Coding style says that you need brackets for all branches if
one needs them (as multiline).  Just above:
https://www.kernel.org/doc/html/v4.10/process/coding-style.html#spaces


>  		dev_size = range_len(&cxlr_dax->hpa_range);
>  
>  	data = (struct dev_dax_data) {


