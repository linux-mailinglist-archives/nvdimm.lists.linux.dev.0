Return-Path: <nvdimm+bounces-2846-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2374A81FF
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 10:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 3289C3E1004
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 09:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9717B2CA1;
	Thu,  3 Feb 2022 09:55:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10662F26
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 09:55:50 +0000 (UTC)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JqDTn3T2Bz67ySM;
	Thu,  3 Feb 2022 17:51:57 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Feb 2022 10:55:47 +0100
Received: from localhost (10.47.78.15) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 3 Feb
 2022 09:55:46 +0000
Date: Thu, 3 Feb 2022 09:55:45 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 32/40] cxl/core/port: Add switch port enumeration
Message-ID: <20220203095545.00000c4e@Huawei.com>
In-Reply-To: <164382166570.690900.541361103681784580.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298428940.3018233.18042207990919432824.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164382166570.690900.541361103681784580.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.47.78.15]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 02 Feb 2022 09:07:55 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> So far the platorm level CXL resources have been enumerated by the
> cxl_acpi driver, and cxl_pci has gathered all the pre-requisite
> information it needs to fire up a cxl_mem driver. However, the first
> thing the cxl_mem driver will be tasked to do is validate that all the
> PCIe Switches in its ancestry also have CXL capabilities and an CXL.mem
> link established.
> 
> Provide a common mechanism for a CXL.mem endpoint driver to enumerate
> all the ancestor CXL ports in the topology and validate CXL.mem
> connectivity.
> 
> Multiple endpoints may end up racing to establish a shared port in the
> topology. This race is resolved via taking the device-lock on a parent
> CXL Port before establishing a new child. The winner of the race
> establishes the port, the loser simply registers its interest in the
> port via 'struct cxl_ep' place-holder reference.
> 
> At endpoint teardown the same parent port lock is taken as 'struct
> cxl_ep' references are deleted. Last endpoint to drop its reference
> unregisters the port.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
A couple of places where in the various rebases function definitions
in headers have ended up in the wrong patch.  Trivial stuff that
obviously doesn't break anything because they aren't used, but
nice to clean up anyway.

Otherwise now looks good to me.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks.

J
...

> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 62b9f5dc64b5..4a52d5596243 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c

...

> +
> +struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd)
> +{
> +	return find_cxl_port(grandparent(&cxlmd->dev));
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_mem_find_port, CXL);

This one should probably be in the header from this patch, not
the next one.

> +
> +struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
> +					const struct device *dev)
> +{
> +	struct cxl_dport *dport;
> +
> +	cxl_device_lock(&port->dev);
> +	list_for_each_entry(dport, &port->dports, list)
> +		if (dport->dport == dev) {
> +			cxl_device_unlock(&port->dev);
> +			return dport;
> +		}
> +
> +	cxl_device_unlock(&port->dev);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
> +
>  static int decoder_populate_targets(struct cxl_decoder *cxld,
>  				    struct cxl_port *port, int *target_map)
>  {
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 89fbf49ebf98..1501d9388e83 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
...
> +int cxl_bus_rescan(void);

Should be in next patch I think.

> +
>  struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
>  				     struct device *dport, int port_id,
>  				     resource_size_t component_reg_phys);

