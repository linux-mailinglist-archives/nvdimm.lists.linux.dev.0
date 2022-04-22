Return-Path: <nvdimm+bounces-3676-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 106C350C53D
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 01:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id D3BFD2E0990
	for <lists+linux-nvdimm@lfdr.de>; Fri, 22 Apr 2022 23:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDDB33FC;
	Fri, 22 Apr 2022 23:58:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452562F3B
	for <nvdimm@lists.linux.dev>; Fri, 22 Apr 2022 23:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650671910; x=1682207910;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e3FLOi/+v6B4A3waN/i8lUdjtDM+G0jjnajfyZctWxo=;
  b=dxoYcrrVO2F7AX3wFwJrGEUzOEgpH6Vv+7TSHTfYKnbDt8XlNO9tHgcv
   VFKImxz4k6ODmlGDNywfwN5IPUx6TYA3Vmow+Cxu88aZnjVkHFSQuDoYg
   wUyJ4NXCpVUW/mX1sB7PvlQWYDO++XK4f+oegh5MBvYeOeg0idT+VjmaX
   M/HCGrx6ZnWUrNzYwomUTg+NROSCcDhx7fV+c5RZQTRTIyprOkk9/mm7W
   EaSvJrUptAp5BcInofRbRc9I/KRI9M7ZFjNkjXDyvVglYjrZdZjvscxul
   qxDYhz5S5wE1oEOXZhew8yVdHHeZK0dBc6yEkwuyN7K5tPJzkoEAct3+X
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="289946472"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="289946472"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 16:58:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="659264395"
Received: from hltravis-mobl1.amr.corp.intel.com (HELO localhost) ([10.213.166.215])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 16:58:28 -0700
Date: Fri, 22 Apr 2022 16:58:28 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] cxl/acpi: Add root device lockdep validation
Message-ID: <YmNBJBTxUCvDHMbw@iweiny-desk3>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>

On Thu, Apr 21, 2022 at 08:33:18AM -0700, Dan Williams wrote:
> The CXL "root" device, ACPI0017, is an attach point for coordinating
> platform level CXL resources and is the parent device for a CXL port
> topology tree. As such it has distinct locking rules relative to other
> CXL subsystem objects, but because it is an ACPI device the lock class
> is established well before it is given to the cxl_acpi driver.
 
This final sentence gave me pause because it implied that the device lock class
was set to something other than no validate.  But I don't see that anywhere in
the acpi code.  So given that it looks to me like ACPI is just using the
default no validate class...

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> However, the lockdep API does support changing the lock class "live" for
> situations like this. Add a device_lock_set_class() helper that a driver
> can use in ->probe() to set a custom lock class, and
> device_lock_reset_class() to return to the default "no validate" class
> before the custom lock class key goes out of scope after ->remove().
> 
> Note the helpers are all macros to support dead code elimination in the
> CONFIG_PROVE_LOCKING=n case.
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c     |   15 +++++++++++++++
>  include/linux/device.h |   25 +++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index d15a6aec0331..e19cea27387e 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -275,6 +275,15 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
>  	return 1;
>  }
>  
> +static struct lock_class_key cxl_root_key;
> +
> +static void cxl_acpi_lock_reset_class(void *_dev)
> +{
> +	struct device *dev = _dev;
> +
> +	device_lock_reset_class(dev);
> +}
> +
>  static int cxl_acpi_probe(struct platform_device *pdev)
>  {
>  	int rc;
> @@ -283,6 +292,12 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  	struct acpi_device *adev = ACPI_COMPANION(host);
>  	struct cxl_cfmws_context ctx;
>  
> +	device_lock_set_class(&pdev->dev, &cxl_root_key);
> +	rc = devm_add_action_or_reset(&pdev->dev, cxl_acpi_lock_reset_class,
> +				      &pdev->dev);
> +	if (rc)
> +		return rc;
> +
>  	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
>  	if (IS_ERR(root_port))
>  		return PTR_ERR(root_port);
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 93459724dcde..82c9d307e7bd 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -850,6 +850,31 @@ static inline bool device_supports_offline(struct device *dev)
>  	return dev->bus && dev->bus->offline && dev->bus->online;
>  }
>  
> +#define __device_lock_set_class(dev, name, key) \
> +	lock_set_class(&(dev)->mutex.dep_map, name, key, 0, _THIS_IP_)
> +
> +/**
> + * device_lock_set_class - Specify a temporary lock class while a device
> + *			   is attached to a driver
> + * @dev: device to modify
> + * @key: lock class key data
> + *
> + * This must be called with the device_lock() already held, for example
> + * from driver ->probe().
> + */
> +#define device_lock_set_class(dev, key)				\
> +	__device_lock_set_class(dev, #key, key)
> +
> +/**
> + * device_lock_reset_class - Return a device to the default lockdep novalidate state
> + * @dev: device to modify
> + *
> + * This must be called with the device_lock() already held, for example
> + * from driver ->remove().
> + */
> +#define device_lock_reset_class(dev) \
> +	device_lock_set_class(dev, &__lockdep_no_validate__)
> +
>  void lock_device_hotplug(void);
>  void unlock_device_hotplug(void);
>  int lock_device_hotplug_sysfs(void);
> 

