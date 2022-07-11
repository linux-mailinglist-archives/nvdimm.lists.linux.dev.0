Return-Path: <nvdimm+bounces-4112-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B3F562156
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 19:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D1EF280C02
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 17:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33BB37465;
	Thu, 30 Jun 2022 17:35:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE157B;
	Thu, 30 Jun 2022 17:34:58 +0000 (UTC)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYlnB4fZmz67lcR;
	Fri,  1 Jul 2022 01:34:06 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 19:34:55 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 18:34:54 +0100
Date: Thu, 30 Jun 2022 18:34:53 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>, "Ben
 Widawsky" <bwidawsk@kernel.org>
Subject: Re: [PATCH 46/46] cxl/region: Introduce cxl_pmem_region objects
Message-ID: <20220630183453.00007b56@Huawei.com>
In-Reply-To: <20220624041950.559155-21-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-21-dan.j.williams@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.200.250]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 21:19:50 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The LIBNVDIMM subsystem is a platform agnostic representation of system
> NVDIMM / persistent memory resources. To date, the CXL subsystem's
> interaction with LIBNVDIMM has been to register an nvdimm-bridge device
> and cxl_nvdimm objects to proxy CXL capabilities into existing LIBNVDIMM
> subsystem mechanics.
> 
> With regions the approach is the same. Create a new cxl_pmem_region
> object to proxy CXL region details into a LIBNVDIMM definition. With
> this enabling LIBNVDIMM can partition CXL persistent memory regions with
> legacy namespace labels. A follow-on patch will add CXL region label and
> CXL namespace label support to persist region configurations across
> driver reload / system-reset events.
ah. Now I see why we share ID space with NVDIMMs. Fair enough, I should
have read to the end ;)

> 
> Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

End of day, so a fairly superficial review on this and I'll hopefully
take a second look at one or two of the earlier patches when time allows.

Jonathan

...

> +static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = ERR_PTR(-ENXIO);

Rarely used, so better to set it where it is.

> +	struct cxl_region_params *p = &cxlr->params;
> +	struct device *dev;
> +	int i;
> +
> +	down_read(&cxl_region_rwsem);
> +	if (p->state != CXL_CONFIG_COMMIT)
> +		goto out;
> +	cxlr_pmem = kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets),
> +			    GFP_KERNEL);
> +	if (!cxlr_pmem) {
> +		cxlr_pmem = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	cxlr_pmem->hpa_range.start = p->res->start;
> +	cxlr_pmem->hpa_range.end = p->res->end;
> +
> +	/* Snapshot the region configuration underneath the cxl_region_rwsem */
> +	cxlr_pmem->nr_mappings = p->nr_targets;
> +	for (i = 0; i < p->nr_targets; i++) {
> +		struct cxl_endpoint_decoder *cxled = p->targets[i];
> +		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
> +
> +		m->cxlmd = cxlmd;
> +		get_device(&cxlmd->dev);
> +		m->start = cxled->dpa_res->start;
> +		m->size = resource_size(cxled->dpa_res);
> +		m->position = i;
> +	}
> +
> +	dev = &cxlr_pmem->dev;
> +	cxlr_pmem->cxlr = cxlr;
> +	device_initialize(dev);
> +	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
> +	device_set_pm_not_required(dev);
> +	dev->parent = &cxlr->dev;
> +	dev->bus = &cxl_bus_type;
> +	dev->type = &cxl_pmem_region_type;
> +out:
> +	up_read(&cxl_region_rwsem);
> +
> +	return cxlr_pmem;
> +}
> +
> +static void cxlr_pmem_unregister(void *dev)
> +{
> +	device_unregister(dev);
> +}
> +
> +/**
> + * devm_cxl_add_pmem_region() - add a cxl_region to nd_region bridge
> + * @host: same host as @cxlmd

Run kernel-doc over these and clean all the warning sup.
Parameter if cxlr not host


> + *
> + * Return: 0 on success negative error code on failure.
> + */


>  /*
>   * Unit test builds overrides this to __weak, find the 'strong' version
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index b271f6e90b91..4ba7248275ac 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -7,6 +7,7 @@

>  


> +static int match_cxl_nvdimm(struct device *dev, void *data)
> +{
> +	return is_cxl_nvdimm(dev);
> +}
> +
> +static void unregister_region(void *nd_region)

Better to give this a more specific name as we have several
unregister_region() functions in CXL now.

> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct cxl_pmem_region *cxlr_pmem;
> +	int i;
> +
> +	cxlr_pmem = nd_region_provider_data(nd_region);
> +	cxl_nvb = cxlr_pmem->bridge;
> +	device_lock(&cxl_nvb->dev);
> +	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
> +		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
> +		struct cxl_nvdimm *cxl_nvd = m->cxl_nvd;
> +
> +		if (cxl_nvd->region) {
> +			put_device(&cxlr_pmem->dev);
> +			cxl_nvd->region = NULL;
> +		}
> +	}
> +	device_unlock(&cxl_nvb->dev);
> +
> +	nvdimm_region_delete(nd_region);
> +}
> +

> +
> +static int cxl_pmem_region_probe(struct device *dev)
> +{
> +	struct nd_mapping_desc mappings[CXL_DECODER_MAX_INTERLEAVE];
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	struct cxl_pmem_region_info *info = NULL;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct nd_interleave_set *nd_set;
> +	struct nd_region_desc ndr_desc;
> +	struct cxl_nvdimm *cxl_nvd;
> +	struct nvdimm *nvdimm;
> +	struct resource *res;
> +	int rc = 0, i;
> +
> +	cxl_nvb = cxl_find_nvdimm_bridge(&cxlr_pmem->mapping[0].cxlmd->dev);
> +	if (!cxl_nvb) {
> +		dev_dbg(dev, "bridge not found\n");
> +		return -ENXIO;
> +	}
> +	cxlr_pmem->bridge = cxl_nvb;
> +
> +	device_lock(&cxl_nvb->dev);
> +	if (!cxl_nvb->nvdimm_bus) {
> +		dev_dbg(dev, "nvdimm bus not found\n");
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	memset(&mappings, 0, sizeof(mappings));
> +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> +
> +	res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
> +	if (!res) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	res->name = "Persistent Memory";
> +	res->start = cxlr_pmem->hpa_range.start;
> +	res->end = cxlr_pmem->hpa_range.end;
> +	res->flags = IORESOURCE_MEM;
> +	res->desc = IORES_DESC_PERSISTENT_MEMORY;
> +
> +	rc = insert_resource(&iomem_resource, res);
> +	if (rc)
> +		goto out;
> +
> +	rc = devm_add_action_or_reset(dev, cxlr_pmem_remove_resource, res);
> +	if (rc)
> +		goto out;
> +
> +	ndr_desc.res = res;
> +	ndr_desc.provider_data = cxlr_pmem;
> +
> +	ndr_desc.numa_node = memory_add_physaddr_to_nid(res->start);
> +	ndr_desc.target_node = phys_to_target_node(res->start);
> +	if (ndr_desc.target_node == NUMA_NO_NODE) {
> +		ndr_desc.target_node = ndr_desc.numa_node;
> +		dev_dbg(&cxlr->dev, "changing target node from %d to %d",
> +			NUMA_NO_NODE, ndr_desc.target_node);
> +	}
> +
> +	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
> +	if (!nd_set) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ndr_desc.memregion = cxlr->id;
> +	set_bit(ND_REGION_CXL, &ndr_desc.flags);
> +	set_bit(ND_REGION_PERSIST_MEMCTRL, &ndr_desc.flags);
> +
> +	info = kmalloc_array(cxlr_pmem->nr_mappings, sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		goto out;
> +
> +	rc = -ENODEV;

Personal taste, but I'd much rather see that set in the error handlers
so I can quickly see where it applies.

> +	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
> +		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
> +		struct cxl_memdev *cxlmd = m->cxlmd;
> +		struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +		struct device *d;
> +
> +		d = device_find_child(&cxlmd->dev, NULL, match_cxl_nvdimm);
> +		if (!d) {
> +			dev_dbg(dev, "[%d]: %s: no cxl_nvdimm found\n", i,
> +				dev_name(&cxlmd->dev));
> +			goto err;
> +		}
> +
> +		/* safe to drop ref now with bridge lock held */
> +		put_device(d);
> +
> +		cxl_nvd = to_cxl_nvdimm(d);
> +		nvdimm = dev_get_drvdata(&cxl_nvd->dev);
> +		if (!nvdimm) {
> +			dev_dbg(dev, "[%d]: %s: no nvdimm found\n", i,
> +				dev_name(&cxlmd->dev));
> +			goto err;
> +		}
> +		cxl_nvd->region = cxlr_pmem;
> +		get_device(&cxlr_pmem->dev);
> +		m->cxl_nvd = cxl_nvd;
> +		mappings[i] = (struct nd_mapping_desc) {
> +			.nvdimm = nvdimm,
> +			.start = m->start,
> +			.size = m->size,
> +			.position = i,
> +		};
> +		info[i].offset = m->start;
> +		info[i].serial = cxlds->serial;
> +	}
> +	ndr_desc.num_mappings = cxlr_pmem->nr_mappings;
> +	ndr_desc.mapping = mappings;
> +
> +	/*
> +	 * TODO enable CXL labels which skip the need for 'interleave-set cookie'
> +	 */
> +	nd_set->cookie1 =
> +		nd_fletcher64(info, sizeof(*info) * cxlr_pmem->nr_mappings, 0);
> +	nd_set->cookie2 = nd_set->cookie1;
> +	ndr_desc.nd_set = nd_set;
> +
> +	cxlr_pmem->nd_region =
> +		nvdimm_pmem_region_create(cxl_nvb->nvdimm_bus, &ndr_desc);
> +	if (IS_ERR(cxlr_pmem->nd_region)) {
> +		rc = PTR_ERR(cxlr_pmem->nd_region);
> +		goto err;
> +	} else

no need for else as other branch has gone flying off down to
err.

> +		rc = devm_add_action_or_reset(dev, unregister_region,
> +					      cxlr_pmem->nd_region);
> +out:

Having labels out: and err: where both are used for errors is pretty
confusing naming...  Perhaps you are better off just not sharing the
good exit path with any of the error paths.


> +	device_unlock(&cxl_nvb->dev);
> +	put_device(&cxl_nvb->dev);
> +	kfree(info);

Ok, so safe to do this here, but would be nice to do this
in reverse order of setup with multiple labels so we can avoid
paths that free things that were never created. Doesn't look
like it would hurt much to move kfree(info) above the device_unlock()
and only do that if we have allocated info.





> +
> +	if (rc)
> +		dev_dbg(dev, "failed to create nvdimm region\n");
> +	return rc;
> +
> +err:
> +	for (i--; i >= 0; i--) {
> +		nvdimm = mappings[i].nvdimm;
> +		cxl_nvd = nvdimm_provider_data(nvdimm);
> +		put_device(&cxl_nvd->region->dev);
> +		cxl_nvd->region = NULL;
> +	}
> +	goto out;
> +}
> +



