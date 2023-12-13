Return-Path: <nvdimm+bounces-7037-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0501780E053
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Dec 2023 01:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34A1282361
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Dec 2023 00:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEEF63E;
	Tue, 12 Dec 2023 00:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUlzn2wy"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981B6370
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 00:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702341149; x=1733877149;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=sPE11n3k/pEWxftH1qy2EYfcLYrjmwVTl6Ayyfeju2w=;
  b=MUlzn2wyWEQrHN14U9f4lwUBuxDMaL1aQod5Tu8xr0jWp6mlgE1Yg1Rf
   hSrbaKVRKcCDmnqZ2bPPnRH78O0WVRJiMR2g0srUMAAUgCQ40QEBapL6U
   b5bZXKKGXw2Ax+kdxnN9Kn07Scyzw+z0k2hVZY5hP9OomiVMt1GUPyodm
   gtdT2kVeeJLO3V7m0nnYSG6gNcas5cEHyqA2Wrl4AJd3Zh9pdg+LeFvQW
   cAhxMKEFbkxd9FJEq/YPINW98lWLJJF1IbIF1Wie8kICUf9QSWtvbeRsy
   cSKlZxa1Rf+qJ3HsGHkFoez5/bPt5Hzi9QzpHwrLG+boJ41HGNRR2aqF2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="393605447"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="393605447"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 16:32:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="1020466528"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="1020466528"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 16:32:25 -0800
From: "Huang, Ying" <ying.huang@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,  Dave Jiang
 <dave.jiang@intel.com>,  <linux-kernel@vger.kernel.org>,
  <nvdimm@lists.linux.dev>,  <linux-cxl@vger.kernel.org>,  David
 Hildenbrand <david@redhat.com>,  "Dave Hansen"
 <dave.hansen@linux.intel.com>,  "Li Zhijian" <lizhijian@fujitsu.com>,
  Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v3 2/2] dax: add a sysfs knob to control
 memmap_on_memory behavior
In-Reply-To: <20231211-vv-dax_abi-v3-2-acf6cc1bde9f@intel.com> (Vishal Verma's
	message of "Mon, 11 Dec 2023 15:52:18 -0700")
References: <20231211-vv-dax_abi-v3-0-acf6cc1bde9f@intel.com>
	<20231211-vv-dax_abi-v3-2-acf6cc1bde9f@intel.com>
Date: Tue, 12 Dec 2023 08:30:26 +0800
Message-ID: <87msugxnx9.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Vishal Verma <vishal.l.verma@intel.com> writes:

> Add a sysfs knob for dax devices to control the memmap_on_memory setting
> if the dax device were to be hotplugged as system memory.
>
> The default memmap_on_memory setting for dax devices originating via
> pmem or hmem is set to 'false' - i.e. no memmap_on_memory semantics, to
> preserve legacy behavior. For dax devices via CXL, the default is on.
> The sysfs control allows the administrator to override the above
> defaults if needed.
>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/dax/bus.c                       | 47 +++++++++++++++++++++++++++++++++
>  Documentation/ABI/testing/sysfs-bus-dax | 17 ++++++++++++
>  2 files changed, 64 insertions(+)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1ff1ab5fa105..2871e5188f0d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1270,6 +1270,52 @@ static ssize_t numa_node_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(numa_node);
>  
> +static ssize_t memmap_on_memory_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +
> +	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
> +}
> +
> +static ssize_t memmap_on_memory_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t len)
> +{
> +	struct device_driver *drv = dev->driver;
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	struct dax_region *dax_region = dev_dax->region;
> +	struct dax_device_driver *dax_drv = to_dax_drv(drv);
> +	ssize_t rc;
> +	bool val;
> +
> +	rc = kstrtobool(buf, &val);
> +	if (rc)
> +		return rc;
> +
> +	if (dev_dax->memmap_on_memory == val)
> +		return len;
> +
> +	device_lock(dax_region->dev);
> +	if (!dax_region->dev->driver) {
> +		device_unlock(dax_region->dev);
> +		return -ENXIO;
> +	}

I think that it should be OK to write to "memmap_on_memory" if no driver
is bound to the device.  We just need to avoid to write to it when kmem
driver is bound.

--
Best Regards,
Huang, Ying

> +
> +	if (dax_drv->type == DAXDRV_KMEM_TYPE) {
> +		device_unlock(dax_region->dev);
> +		return -EBUSY;
> +	}
> +
> +	device_lock(dev);
> +	dev_dax->memmap_on_memory = val;
> +	device_unlock(dev);
> +
> +	device_unlock(dax_region->dev);
> +	return len;
> +}
> +static DEVICE_ATTR_RW(memmap_on_memory);
> +
>  static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
>  	struct device *dev = container_of(kobj, struct device, kobj);
> @@ -1296,6 +1342,7 @@ static struct attribute *dev_dax_attributes[] = {
>  	&dev_attr_align.attr,
>  	&dev_attr_resource.attr,
>  	&dev_attr_numa_node.attr,
> +	&dev_attr_memmap_on_memory.attr,
>  	NULL,
>  };
>  
> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index a61a7b186017..b1fd8bf8a7de 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -149,3 +149,20 @@ KernelVersion:	v5.1
>  Contact:	nvdimm@lists.linux.dev
>  Description:
>  		(RO) The id attribute indicates the region id of a dax region.
> +
> +What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
> +Date:		October, 2023
> +KernelVersion:	v6.8
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Control the memmap_on_memory setting if the dax device
> +		were to be hotplugged as system memory. This determines whether
> +		the 'altmap' for the hotplugged memory will be placed on the
> +		device being hotplugged (memmap_on_memory=1) or if it will be
> +		placed on regular memory (memmap_on_memory=0). This attribute
> +		must be set before the device is handed over to the 'kmem'
> +		driver (i.e.  hotplugged into system-ram). Additionally, this
> +		depends on CONFIG_MHP_MEMMAP_ON_MEMORY, and a globally enabled
> +		memmap_on_memory parameter for memory_hotplug. This is
> +		typically set on the kernel command line -
> +		memory_hotplug.memmap_on_memory set to 'true' or 'force'."

