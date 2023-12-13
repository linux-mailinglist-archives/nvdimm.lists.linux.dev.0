Return-Path: <nvdimm+bounces-7070-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4757811A5E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Dec 2023 18:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0E7A1C212BD
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Dec 2023 17:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDBB39FD7;
	Wed, 13 Dec 2023 17:05:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADAD1D52D
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Sr1yb1L7qz6K7Xr;
	Thu, 14 Dec 2023 01:03:19 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C7FC1400CA;
	Thu, 14 Dec 2023 01:05:15 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 13 Dec
 2023 17:05:14 +0000
Date: Wed, 13 Dec 2023 17:05:13 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, David Hildenbrand
	<david@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Huang Ying
	<ying.huang@intel.com>, Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v4 2/3] dax/bus: Introduce guard(device) for
 device_{lock,unlock} flows
Message-ID: <20231213170513.000036e8@Huawei.com>
In-Reply-To: <20231212-vv-dax_abi-v4-2-1351758f0c92@intel.com>
References: <20231212-vv-dax_abi-v4-0-1351758f0c92@intel.com>
	<20231212-vv-dax_abi-v4-2-1351758f0c92@intel.com>
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
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Tue, 12 Dec 2023 12:08:31 -0700
Vishal Verma <vishal.l.verma@intel.com> wrote:

> Introduce a guard(device) macro to lock a 'struct device', and unlock it
> automatically when going out of scope using Scope Based Resource
> Management semantics. A lot of the sysfs attribute writes in
> drivers/dax/bus.c benefit from a cleanup using these, so change these
> where applicable.
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Hi Vishal,

I'm a big fan of this cleanup.h stuff so very happen to see this getting used here.
There are added opportunities for cleanup that result.

Note that almost every time I see people using this stuff they don't look again
at the code post the change so miss the wider cleanup that it enables. So you are
in good company ;)

Jonathan

> ---
>  include/linux/device.h |   2 +
>  drivers/dax/bus.c      | 109 +++++++++++++++++++------------------------------
>  2 files changed, 44 insertions(+), 67 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index d7a72a8749ea..a83efd9ae949 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1131,6 +1131,8 @@ void set_secondary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
>  void device_set_of_node_from_dev(struct device *dev, const struct device *dev2);
>  void device_set_node(struct device *dev, struct fwnode_handle *fwnode);
>  
> +DEFINE_GUARD(device, struct device *, device_lock(_T), device_unlock(_T))

Nice. I'd expect this to be widely adopted, so maybe to make things less painful
for backporting changes that depend on it, make this a separate trivial patch
rather than having this in here.

> +
>  static inline int dev_num_vf(struct device *dev)
>  {
>  	if (dev->bus && dev->bus->num_vf)
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1ff1ab5fa105..ce1356ac6dc2 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -296,9 +296,8 @@ static ssize_t available_size_show(struct device *dev,
>  	struct dax_region *dax_region = dev_get_drvdata(dev);
>  	unsigned long long size;
>  
> -	device_lock(dev);
> +	guard(device)(dev);
>  	size = dax_region_avail_size(dax_region);
> -	device_unlock(dev);
>  
>  	return sprintf(buf, "%llu\n", size);
	return sprintf(buf, @%llu\n@, dax_region_avail_size(dax_region));
and drop the local variable that adds little perhaps?

>  }
> @@ -314,10 +313,9 @@ static ssize_t seed_show(struct device *dev,
>  	if (is_static(dax_region))
>  		return -EINVAL;
>  
> -	device_lock(dev);
> +	guard(device)(dev);
>  	seed = dax_region->seed;
>  	rc = sprintf(buf, "%s\n", seed ? dev_name(seed) : "");

return sprintf();

> -	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -333,10 +331,9 @@ static ssize_t create_show(struct device *dev,
>  	if (is_static(dax_region))
>  		return -EINVAL;
>  
> -	device_lock(dev);
> +	guard(device)(dev);
>  	youngest = dax_region->youngest;
>  	rc = sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");

return sprintf();

> -	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -345,7 +342,14 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
>  		const char *buf, size_t len)
>  {
>  	struct dax_region *dax_region = dev_get_drvdata(dev);
> +	struct dev_dax_data data = {
> +		.dax_region = dax_region,
> +		.size = 0,
> +		.id = -1,
> +		.memmap_on_memory = false,
> +	};
>  	unsigned long long avail;
> +	struct dev_dax *dev_dax;
>  	ssize_t rc;
>  	int val;
>  
> @@ -358,38 +362,26 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
>  	if (val != 1)
>  		return -EINVAL;
>  
> -	device_lock(dev);
> +	guard(device)(dev);
>  	avail = dax_region_avail_size(dax_region);
>  	if (avail == 0)
> -		rc = -ENOSPC;
> -	else {
> -		struct dev_dax_data data = {
> -			.dax_region = dax_region,
> -			.size = 0,
> -			.id = -1,
> -			.memmap_on_memory = false,
> -		};
> -		struct dev_dax *dev_dax = devm_create_dev_dax(&data);
> +		return -ENOSPC;
>  
> -		if (IS_ERR(dev_dax))
> -			rc = PTR_ERR(dev_dax);
> -		else {
> -			/*
> -			 * In support of crafting multiple new devices
> -			 * simultaneously multiple seeds can be created,
> -			 * but only the first one that has not been
> -			 * successfully bound is tracked as the region
> -			 * seed.
> -			 */
> -			if (!dax_region->seed)
> -				dax_region->seed = &dev_dax->dev;
> -			dax_region->youngest = &dev_dax->dev;
> -			rc = len;
> -		}
> -	}
> -	device_unlock(dev);
> +	dev_dax = devm_create_dev_dax(&data);
> +	if (IS_ERR(dev_dax))
> +		return PTR_ERR(dev_dax);
>  
> -	return rc;
> +	/*
> +	 * In support of crafting multiple new devices

rewrap this comment for the new indent.

> +	 * simultaneously multiple seeds can be created,
> +	 * but only the first one that has not been
> +	 * successfully bound is tracked as the region
> +	 * seed.
> +	 */
> +	if (!dax_region->seed)
> +		dax_region->seed = &dev_dax->dev;
> +	dax_region->youngest = &dev_dax->dev;

Trivial but blank line here would be a nice to have

> +	return len;
>  }


...

> @@ -1138,18 +1123,14 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  
>  	rc = -ENXIO;

Not needed with suggested changes that follow.

> -	device_lock(dax_region->dev);
> -	if (!dax_region->dev->driver) {
> -		device_unlock(dax_region->dev);
> +	guard(device)(dax_region->dev);
> +	if (!dax_region->dev->driver)
>  		return rc;
		return -ENXIO;
> -	}
> -	device_lock(dev);
>  
> +	guard(device)(dev);
>  	to_alloc = range_len(&r);
>  	if (alloc_is_aligned(dev_dax, to_alloc))
>  		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
Flip logic here and I'd drop the ternary stuff as well - same in other
similar cases in this patch (though that is just personal taste)

	if (!alloc_is_aligned(dev_dax, to_allco))
		return -ENXIO.

	rc = alloc_dev_dax_range(dev_dax, r.start, to_allco)
	if (rc)
		return rc;

	return len;

> -	device_unlock(dev);
> -	device_unlock(dax_region->dev);
>  
>  	return rc == 0 ? len : rc;
>  }

> 


