Return-Path: <nvdimm+bounces-3682-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 3515B50C5AE
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 02:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 1298E2E0982
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 00:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEB115A4;
	Sat, 23 Apr 2022 00:24:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECD7C
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650673472; x=1682209472;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RGmG/4suRwhGymxtXPgsRtAk8Fm5YZTgIrdgqAnQ2+c=;
  b=iyYLfx8I8fhkYt4vsTWDI3e0vEOCxKnoDQa4gwdLX7CNUN2nMTg73c/I
   nVAxqjJbxAmHN75YLSKf7F4weR0XeGybehNUiYiaKTi9hG6YGCxJHZ/xT
   pt7SBAh83BbXB8EeZVV+F8eXafrnEmgq/MqvJop5iSk8ETJrg05c1EarZ
   lXa247bfZYoMrLWidY8Q342XEBeGfivQzHNBbjYmHGEiL2yeLVsqiNdBb
   UCtyMhBAwEUOVdnX3Yq3KuuhfYQCerNzknbn039Z9sXq6WwOR7UY0ouR/
   Vm/dKPraNVOGpf61vQD/6iNqZdxtED+g+/jJO/wdaUeHVAWeQUiM2k/fl
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264991553"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264991553"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 17:24:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="615632973"
Received: from hltravis-mobl1.amr.corp.intel.com (HELO localhost) ([10.213.166.215])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 17:24:31 -0700
Date: Fri, 22 Apr 2022 17:24:31 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, peterz@infradead.org,
	alison.schofield@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] nvdimm: Drop nd_device_lock()
Message-ID: <YmNHP1I5/9OoLu8E@iweiny-desk3>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055521979.3745911.10751769706032029999.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165055521979.3745911.10751769706032029999.stgit@dwillia2-desk3.amr.corp.intel.com>

On Thu, Apr 21, 2022 at 08:33:39AM -0700, Dan Williams wrote:
> Now that all NVDIMM subsystem locking is validated with custom lock
> classes, there is no need for the custom usage of the lockdep_mutex.
> 
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/nvdimm/btt_devs.c       |   16 +++++----
>  drivers/nvdimm/bus.c            |   24 +++++---------
>  drivers/nvdimm/core.c           |   10 +++---
>  drivers/nvdimm/dimm_devs.c      |    8 ++---
>  drivers/nvdimm/namespace_devs.c |   36 +++++++++++----------
>  drivers/nvdimm/nd-core.h        |   66 ---------------------------------------
>  drivers/nvdimm/pfn_devs.c       |   24 +++++++-------
>  drivers/nvdimm/pmem.c           |    2 +
>  drivers/nvdimm/region.c         |    2 +
>  drivers/nvdimm/region_devs.c    |   16 +++++----
>  lib/Kconfig.debug               |   17 ----------
>  11 files changed, 66 insertions(+), 155 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 120821796668..fabbb31f2c35 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -50,14 +50,14 @@ static ssize_t sector_size_store(struct device *dev,
>  	struct nd_btt *nd_btt = to_nd_btt(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	rc = nd_size_select_store(dev, buf, &nd_btt->lbasize,
>  			btt_lbasize_supported);
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }
> @@ -79,11 +79,11 @@ static ssize_t uuid_store(struct device *dev,
>  	struct nd_btt *nd_btt = to_nd_btt(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	rc = nd_uuid_store(dev, &nd_btt->uuid, buf, len);
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }
> @@ -108,13 +108,13 @@ static ssize_t namespace_store(struct device *dev,
>  	struct nd_btt *nd_btt = to_nd_btt(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	rc = nd_namespace_store(dev, &nd_btt->ndns, buf, len);
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -126,14 +126,14 @@ static ssize_t size_show(struct device *dev,
>  	struct nd_btt *nd_btt = to_nd_btt(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	if (dev->driver)
>  		rc = sprintf(buf, "%llu\n", nd_btt->size);
>  	else {
>  		/* no size to convey if the btt instance is disabled */
>  		rc = -ENXIO;
>  	}
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 85ffa04e93c2..a4fc17db707c 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -88,10 +88,7 @@ static int nvdimm_bus_probe(struct device *dev)
>  			dev->driver->name, dev_name(dev));
>  
>  	nvdimm_bus_probe_start(nvdimm_bus);
> -	debug_nvdimm_lock(dev);
>  	rc = nd_drv->probe(dev);
> -	debug_nvdimm_unlock(dev);
> -
>  	if ((rc == 0 || rc == -EOPNOTSUPP) &&
>  			dev->parent && is_nd_region(dev->parent))
>  		nd_region_advance_seeds(to_nd_region(dev->parent), dev);
> @@ -111,11 +108,8 @@ static void nvdimm_bus_remove(struct device *dev)
>  	struct module *provider = to_bus_provider(dev);
>  	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
>  
> -	if (nd_drv->remove) {
> -		debug_nvdimm_lock(dev);
> +	if (nd_drv->remove)
>  		nd_drv->remove(dev);
> -		debug_nvdimm_unlock(dev);
> -	}
>  
>  	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s)\n", dev->driver->name,
>  			dev_name(dev));
> @@ -139,7 +133,7 @@ static void nvdimm_bus_shutdown(struct device *dev)
>  
>  void nd_device_notify(struct device *dev, enum nvdimm_event event)
>  {
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	if (dev->driver) {
>  		struct nd_device_driver *nd_drv;
>  
> @@ -147,7 +141,7 @@ void nd_device_notify(struct device *dev, enum nvdimm_event event)
>  		if (nd_drv->notify)
>  			nd_drv->notify(dev, event);
>  	}
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  }
>  EXPORT_SYMBOL(nd_device_notify);
>  
> @@ -569,9 +563,9 @@ void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
>  		 * or otherwise let the async path handle it if the
>  		 * unregistration was already queued.
>  		 */
> -		nd_device_lock(dev);
> +		device_lock(dev);
>  		killed = kill_device(dev);
> -		nd_device_unlock(dev);
> +		device_unlock(dev);
>  
>  		if (!killed)
>  			return;
> @@ -930,10 +924,10 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
>  		if (nvdimm_bus->probe_active == 0)
>  			break;
>  		nvdimm_bus_unlock(dev);
> -		nd_device_unlock(dev);
> +		device_unlock(dev);
>  		wait_event(nvdimm_bus->wait,
>  				nvdimm_bus->probe_active == 0);
> -		nd_device_lock(dev);
> +		device_lock(dev);
>  		nvdimm_bus_lock(dev);
>  	} while (true);
>  }
> @@ -1167,7 +1161,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  		goto out;
>  	}
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
>  	if (rc)
> @@ -1189,7 +1183,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  
>  out_unlock:
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  out:
>  	kfree(in_env);
>  	kfree(out_env);
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 69a03358817f..144926b7451c 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -215,7 +215,7 @@ EXPORT_SYMBOL_GPL(to_nvdimm_bus_dev);
>   *
>   * Enforce that uuids can only be changed while the device is disabled
>   * (driver detached)
> - * LOCKING: expects nd_device_lock() is held on entry
> + * LOCKING: expects device_lock() is held on entry
>   */
>  int nd_uuid_store(struct device *dev, uuid_t **uuid_out, const char *buf,
>  		size_t len)
> @@ -316,15 +316,15 @@ static DEVICE_ATTR_RO(provider);
>  
>  static int flush_namespaces(struct device *dev, void *data)
>  {
> -	nd_device_lock(dev);
> -	nd_device_unlock(dev);
> +	device_lock(dev);
> +	device_unlock(dev);
>  	return 0;
>  }
>  
>  static int flush_regions_dimms(struct device *dev, void *data)
>  {
> -	nd_device_lock(dev);
> -	nd_device_unlock(dev);
> +	device_lock(dev);
> +	device_unlock(dev);
>  	device_for_each_child(dev, NULL, flush_namespaces);
>  	return 0;
>  }
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 27b8f8cd1b48..c7c980577491 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -341,9 +341,9 @@ static ssize_t available_slots_show(struct device *dev,
>  {
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	rc = __available_slots_show(dev_get_drvdata(dev), buf);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -386,12 +386,12 @@ static ssize_t security_store(struct device *dev,
>  	 * done while probing is idle and the DIMM is not in active use
>  	 * in any region.
>  	 */
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	rc = nvdimm_security_store(dev, buf, len);
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 5197a813849d..bf4f5c09d9b1 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -264,7 +264,7 @@ static ssize_t alt_name_store(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev->parent);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	rc = __alt_name_store(dev, buf, len);
> @@ -272,7 +272,7 @@ static ssize_t alt_name_store(struct device *dev,
>  		rc = nd_namespace_label_update(nd_region, dev);
>  	dev_dbg(dev, "%s(%zd)\n", rc < 0 ? "fail " : "", rc);
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc < 0 ? rc : len;
>  }
> @@ -846,7 +846,7 @@ static ssize_t size_store(struct device *dev,
>  	if (rc)
>  		return rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	rc = __size_store(dev, val);
> @@ -868,7 +868,7 @@ static ssize_t size_store(struct device *dev,
>  	dev_dbg(dev, "%llx %s (%d)\n", val, rc < 0 ? "fail" : "success", rc);
>  
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc < 0 ? rc : len;
>  }
> @@ -1043,7 +1043,7 @@ static ssize_t uuid_store(struct device *dev,
>  	} else
>  		return -ENXIO;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	if (to_ndns(dev)->claim)
> @@ -1059,7 +1059,7 @@ static ssize_t uuid_store(struct device *dev,
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc < 0 ? rc : len;
>  }
> @@ -1118,7 +1118,7 @@ static ssize_t sector_size_store(struct device *dev,
>  	} else
>  		return -ENXIO;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	if (to_ndns(dev)->claim)
>  		rc = -EBUSY;
> @@ -1129,7 +1129,7 @@ static ssize_t sector_size_store(struct device *dev,
>  	dev_dbg(dev, "result: %zd %s: %s%s", rc, rc < 0 ? "tried" : "wrote",
>  			buf, buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }
> @@ -1239,9 +1239,9 @@ static ssize_t holder_show(struct device *dev,
>  	struct nd_namespace_common *ndns = to_ndns(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	rc = sprintf(buf, "%s\n", ndns->claim ? dev_name(ndns->claim) : "");
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -1278,7 +1278,7 @@ static ssize_t holder_class_store(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev->parent);
>  	int rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	rc = __holder_class_store(dev, buf);
> @@ -1286,7 +1286,7 @@ static ssize_t holder_class_store(struct device *dev,
>  		rc = nd_namespace_label_update(nd_region, dev);
>  	dev_dbg(dev, "%s(%d)\n", rc < 0 ? "fail " : "", rc);
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc < 0 ? rc : len;
>  }
> @@ -1297,7 +1297,7 @@ static ssize_t holder_class_show(struct device *dev,
>  	struct nd_namespace_common *ndns = to_ndns(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	if (ndns->claim_class == NVDIMM_CCLASS_NONE)
>  		rc = sprintf(buf, "\n");
>  	else if ((ndns->claim_class == NVDIMM_CCLASS_BTT) ||
> @@ -1309,7 +1309,7 @@ static ssize_t holder_class_show(struct device *dev,
>  		rc = sprintf(buf, "dax\n");
>  	else
>  		rc = sprintf(buf, "<unknown>\n");
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -1323,7 +1323,7 @@ static ssize_t mode_show(struct device *dev,
>  	char *mode;
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	claim = ndns->claim;
>  	if (claim && is_nd_btt(claim))
>  		mode = "safe";
> @@ -1336,7 +1336,7 @@ static ssize_t mode_show(struct device *dev,
>  	else
>  		mode = "raw";
>  	rc = sprintf(buf, "%s\n", mode);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -1456,8 +1456,8 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
>  		 * Flush any in-progess probes / removals in the driver
>  		 * for the raw personality of this namespace.
>  		 */
> -		nd_device_lock(&ndns->dev);
> -		nd_device_unlock(&ndns->dev);
> +		device_lock(&ndns->dev);
> +		device_unlock(&ndns->dev);
>  		if (ndns->dev.driver) {
>  			dev_dbg(&ndns->dev, "is active, can't bind %s\n",
>  					dev_name(dev));
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index 99b04106434b..cc86ee09d7c0 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -161,70 +161,4 @@ static inline void devm_nsio_disable(struct device *dev,
>  {
>  }
>  #endif
> -
> -#ifdef CONFIG_PROVE_NVDIMM_LOCKING
> -extern struct class *nd_class;
> -
> -enum {
> -	LOCK_BUS,
> -	LOCK_NDCTL,
> -	LOCK_REGION,
> -	LOCK_DIMM = LOCK_REGION,
> -	LOCK_NAMESPACE,
> -	LOCK_CLAIM,
> -};
> -
> -static inline void debug_nvdimm_lock(struct device *dev)
> -{
> -	if (is_nd_region(dev))
> -		mutex_lock_nested(&dev->lockdep_mutex, LOCK_REGION);
> -	else if (is_nvdimm(dev))
> -		mutex_lock_nested(&dev->lockdep_mutex, LOCK_DIMM);
> -	else if (is_nd_btt(dev) || is_nd_pfn(dev) || is_nd_dax(dev))
> -		mutex_lock_nested(&dev->lockdep_mutex, LOCK_CLAIM);
> -	else if (dev->parent && (is_nd_region(dev->parent)))
> -		mutex_lock_nested(&dev->lockdep_mutex, LOCK_NAMESPACE);
> -	else if (is_nvdimm_bus(dev))
> -		mutex_lock_nested(&dev->lockdep_mutex, LOCK_BUS);
> -	else if (dev->class && dev->class == nd_class)
> -		mutex_lock_nested(&dev->lockdep_mutex, LOCK_NDCTL);
> -	else
> -		dev_WARN(dev, "unknown lock level\n");
> -}
> -
> -static inline void debug_nvdimm_unlock(struct device *dev)
> -{
> -	mutex_unlock(&dev->lockdep_mutex);
> -}
> -
> -static inline void nd_device_lock(struct device *dev)
> -{
> -	device_lock(dev);
> -	debug_nvdimm_lock(dev);
> -}
> -
> -static inline void nd_device_unlock(struct device *dev)
> -{
> -	debug_nvdimm_unlock(dev);
> -	device_unlock(dev);
> -}
> -#else
> -static inline void nd_device_lock(struct device *dev)
> -{
> -	device_lock(dev);
> -}
> -
> -static inline void nd_device_unlock(struct device *dev)
> -{
> -	device_unlock(dev);
> -}
> -
> -static inline void debug_nvdimm_lock(struct device *dev)
> -{
> -}
> -
> -static inline void debug_nvdimm_unlock(struct device *dev)
> -{
> -}
> -#endif
>  #endif /* __ND_CORE_H__ */
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 0cd396d0024c..0e92ab4b3283 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -55,7 +55,7 @@ static ssize_t mode_store(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc = 0;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	if (dev->driver)
>  		rc = -EBUSY;
> @@ -77,7 +77,7 @@ static ssize_t mode_store(struct device *dev,
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }
> @@ -123,14 +123,14 @@ static ssize_t align_store(struct device *dev,
>  	unsigned long aligns[MAX_NVDIMM_ALIGN] = { [0] = 0, };
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	rc = nd_size_select_store(dev, buf, &nd_pfn->align,
>  			nd_pfn_supported_alignments(aligns));
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }
> @@ -152,11 +152,11 @@ static ssize_t uuid_store(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	rc = nd_uuid_store(dev, &nd_pfn->uuid, buf, len);
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }
> @@ -181,13 +181,13 @@ static ssize_t namespace_store(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	rc = nd_namespace_store(dev, &nd_pfn->ndns, buf, len);
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -199,7 +199,7 @@ static ssize_t resource_show(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	if (dev->driver) {
>  		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
>  		u64 offset = __le64_to_cpu(pfn_sb->dataoff);
> @@ -213,7 +213,7 @@ static ssize_t resource_show(struct device *dev,
>  		/* no address to convey if the pfn instance is disabled */
>  		rc = -ENXIO;
>  	}
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -225,7 +225,7 @@ static ssize_t size_show(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	if (dev->driver) {
>  		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
>  		u64 offset = __le64_to_cpu(pfn_sb->dataoff);
> @@ -241,7 +241,7 @@ static ssize_t size_show(struct device *dev,
>  		/* no size to convey if the pfn instance is disabled */
>  		rc = -ENXIO;
>  	}
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 58d95242a836..3992521c151f 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -573,7 +573,7 @@ static void nd_pmem_remove(struct device *dev)
>  		nvdimm_namespace_detach_btt(to_nd_btt(dev));
>  	else {
>  		/*
> -		 * Note, this assumes nd_device_lock() context to not
> +		 * Note, this assumes device_lock() context to not
>  		 * race nd_pmem_notify()
>  		 */
>  		sysfs_put(pmem->bb_state);
> diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
> index 188560b1c110..390123d293ea 100644
> --- a/drivers/nvdimm/region.c
> +++ b/drivers/nvdimm/region.c
> @@ -95,7 +95,7 @@ static void nd_region_remove(struct device *dev)
>  	nvdimm_bus_unlock(dev);
>  
>  	/*
> -	 * Note, this assumes nd_device_lock() context to not race
> +	 * Note, this assumes device_lock() context to not race
>  	 * nd_region_notify()
>  	 */
>  	sysfs_put(nd_region->bb_state);
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 8650e8d39c89..d976260eca7a 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -279,7 +279,7 @@ static ssize_t set_cookie_show(struct device *dev,
>  	 * the v1.1 namespace label cookie definition. To read all this
>  	 * data we need to wait for probing to settle.
>  	 */
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	if (nd_region->ndr_mappings) {
> @@ -296,7 +296,7 @@ static ssize_t set_cookie_show(struct device *dev,
>  		}
>  	}
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	if (rc)
>  		return rc;
> @@ -353,12 +353,12 @@ static ssize_t available_size_show(struct device *dev,
>  	 * memory nvdimm_bus_lock() is dropped, but that's userspace's
>  	 * problem to not race itself.
>  	 */
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	available = nd_region_available_dpa(nd_region);
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return sprintf(buf, "%llu\n", available);
>  }
> @@ -370,12 +370,12 @@ static ssize_t max_available_extent_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	unsigned long long available = 0;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	nvdimm_bus_lock(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	available = nd_region_allocatable_dpa(nd_region);
>  	nvdimm_bus_unlock(dev);
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return sprintf(buf, "%llu\n", available);
>  }
> @@ -549,12 +549,12 @@ static ssize_t region_badblocks_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	ssize_t rc;
>  
> -	nd_device_lock(dev);
> +	device_lock(dev);
>  	if (dev->driver)
>  		rc = badblocks_show(&nd_region->bb, buf, 0);
>  	else
>  		rc = -ENXIO;
> -	nd_device_unlock(dev);
> +	device_unlock(dev);
>  
>  	return rc;
>  }
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 4a2c853c948b..cfe3b092c31d 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1544,23 +1544,6 @@ config CSD_LOCK_WAIT_DEBUG
>  	  include the IPI handler function currently executing (if any)
>  	  and relevant stack traces.
>  
> -choice
> -	prompt "Lock debugging: prove subsystem device_lock() correctness"
> -	depends on PROVE_LOCKING
> -	help
> -	  For subsystems that have instrumented their usage of the device_lock()
> -	  with nested annotations, enable lock dependency checking. The locking
> -	  hierarchy 'subclass' identifiers are not compatible across
> -	  sub-systems, so only one can be enabled at a time.
> -
> -config PROVE_NVDIMM_LOCKING
> -	bool "NVDIMM"
> -	depends on LIBNVDIMM
> -	help
> -	  Enable lockdep to validate nd_device_lock() usage.
> -
> -endchoice
> -
>  endmenu # lock debugging
>  
>  config TRACE_IRQFLAGS
> 

