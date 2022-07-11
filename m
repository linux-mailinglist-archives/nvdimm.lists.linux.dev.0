Return-Path: <nvdimm+bounces-4058-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C182855EA20
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Jun 2022 18:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 8A67E2E0A79
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Jun 2022 16:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673653C39;
	Tue, 28 Jun 2022 16:50:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223F3234;
	Tue, 28 Jun 2022 16:50:00 +0000 (UTC)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXVtL4d0Fz687vm;
	Wed, 29 Jun 2022 00:49:14 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 18:49:57 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 17:49:57 +0100
Date: Tue, 28 Jun 2022 17:49:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <bwidawsk@kernel.org>,
	<hch@infradead.org>, <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 10/46] cxl/core: Define a 'struct cxl_root_decoder' for
 tracking CXL window resources
Message-ID: <20220628174955.00005a53@Huawei.com>
In-Reply-To: <165603877351.551046.12325060612893557716.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603877351.551046.12325060612893557716.stgit@dwillia2-xfh>
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
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 19:46:13 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Previously the target routing specifics of switch decoders were factored
> out of 'struct cxl_decoder' into 'struct cxl_switch_decoder'.
> 
> This patch, 2 of 3, adds a 'struct cxl_root_decoder' as a superset of a
> switch decoder that also track the associated CXL window platform
> resource.
> 
> Note that the reason the resource for a given root decoder needs to be
> looked up after the fact (i.e. after cxl_parse_cfmws() and
> add_cxl_resource()) is because add_cxl_resource() may have merged CXL
> windows in order to keep them at the top of the resource tree / decode
> hierarchy.

One trivial comment below that follows from earlier patch.

Otherwise, I'll look again at this when I understand what the constraints
of CXL windows are that you are dealing with.  I don't get why they might not
be at the top of the resource tree without the merging!

> 
> Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c      |   40 ++++++++++++++++++++++++++++++++++++----
>  drivers/cxl/core/port.c |   43 +++++++++++++++++++++++++++++++++++++------
>  drivers/cxl/cxl.h       |   15 +++++++++++++--
>  3 files changed, 86 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 003fa4fde357..5972f380cdf2 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -82,7 +82,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>  	int target_map[CXL_DECODER_MAX_INTERLEAVE];
>  	struct cxl_cfmws_context *ctx = arg;
>  	struct cxl_port *root_port = ctx->root_port;
> -	struct cxl_switch_decoder *cxlsd;
> +	struct cxl_root_decoder *cxlrd;
>  	struct device *dev = ctx->dev;
>  	struct acpi_cedt_cfmws *cfmws;
>  	struct resource *cxl_res;
> @@ -128,11 +128,11 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>  	if (rc)
>  		goto err_insert;
>  
> -	cxlsd = cxl_root_decoder_alloc(root_port, ways);
> -	if (IS_ERR(cxld))
> +	cxlrd = cxl_root_decoder_alloc(root_port, ways);
> +	if (IS_ERR(cxlrd))
>  		return 0;
>  
> -	cxld = &cxlsd->cxld;
> +	cxld = &cxlrd->cxlsd.cxld;
>  	cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
>  	cxld->target_type = CXL_DECODER_EXPANDER;
>  	cxld->hpa_range = (struct range) {
> @@ -375,6 +375,32 @@ static int add_cxl_resources(struct resource *cxl)
>  	return 0;
>  }
>  
> +static int pair_cxl_resource(struct device *dev, void *data)
> +{
> +	struct resource *cxl_res = data;
> +	struct resource *p;
> +
> +	if (!is_root_decoder(dev))
> +		return 0;
> +
> +	for (p = cxl_res->child; p; p = p->sibling) {
> +		struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
> +		struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
> +		struct resource res = {
> +			.start = cxld->hpa_range.start,
> +			.end = cxld->hpa_range.end,
> +			.flags = IORESOURCE_MEM,
> +		};
> +
> +		if (resource_contains(p, &res)) {
> +			cxlrd->res = (struct resource *)p->desc;
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int cxl_acpi_probe(struct platform_device *pdev)
>  {
>  	int rc;
> @@ -425,6 +451,12 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  	if (rc)
>  		return rc;
>  
> +	/*
> +	 * Populate the root decoders with their related iomem resource,
> +	 * if present
> +	 */
> +	device_for_each_child(&root_port->dev, cxl_res, pair_cxl_resource);
> +
>  	/*
>  	 * Root level scanned with host-bridge as dports, now scan host-bridges
>  	 * for their role as CXL uports to their CXL-capable PCIe Root Ports.
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index fd1cac13cd2e..abf3455c4eff 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -259,6 +259,23 @@ static void cxl_switch_decoder_release(struct device *dev)
>  	kfree(cxlsd);
>  }
>  
> +struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev)
> +{
> +	if (dev_WARN_ONCE(dev, !is_root_decoder(dev),
> +			  "not a cxl_root_decoder device\n"))
> +		return NULL;
> +	return container_of(dev, struct cxl_root_decoder, cxlsd.cxld.dev);
> +}
> +EXPORT_SYMBOL_NS_GPL(to_cxl_root_decoder, CXL);
> +
> +static void cxl_root_decoder_release(struct device *dev)
> +{
> +	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
> +
> +	__cxl_decoder_release(&cxlrd->cxlsd.cxld);
> +	kfree(cxlrd);
> +}
> +
>  static const struct device_type cxl_decoder_endpoint_type = {
>  	.name = "cxl_decoder_endpoint",
>  	.release = cxl_decoder_release,
> @@ -273,7 +290,7 @@ static const struct device_type cxl_decoder_switch_type = {
>  
>  static const struct device_type cxl_decoder_root_type = {
>  	.name = "cxl_decoder_root",
> -	.release = cxl_switch_decoder_release,
> +	.release = cxl_root_decoder_release,
>  	.groups = cxl_decoder_root_attribute_groups,
>  };
>  
> @@ -1218,9 +1235,23 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>  
>  	if (nr_targets) {
>  		struct cxl_switch_decoder *cxlsd;
> +		struct cxl_root_decoder *cxlrd;
> +
> +		if (is_cxl_root(port)) {
> +			alloc = kzalloc(struct_size(cxlrd, cxlsd.target,
> +						    nr_targets),
> +					GFP_KERNEL);
> +			cxlrd = alloc;
> +			if (cxlrd)
> +				cxlsd = &cxlrd->cxlsd;
> +			else
> +				cxlsd = NULL;
> +		} else {
> +			alloc = kzalloc(struct_size(cxlsd, target, nr_targets),
> +					GFP_KERNEL);
> +			cxlsd = alloc;

As earlier, I'd prefer you just handled errors when they happened rather than
dancing onwards...

> +		}
>  
> -		alloc = kzalloc(struct_size(cxlsd, target, nr_targets), GFP_KERNEL);
> -		cxlsd = alloc;
>  		if (cxlsd) {
>  			cxlsd->nr_targets = nr_targets;
>  			seqlock_init(&cxlsd->target_lock);
> @@ -1279,8 +1310,8 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>   * firmware description of CXL resources into a CXL standard decode
>   * topology.
>   */
> -struct cxl_switch_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
> -						  unsigned int nr_targets)
> +struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
> +						unsigned int nr_targets)
>  {
>  	struct cxl_decoder *cxld;
>  
> @@ -1290,7 +1321,7 @@ struct cxl_switch_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
>  	cxld = cxl_decoder_alloc(port, nr_targets);
>  	if (IS_ERR(cxld))
>  		return ERR_CAST(cxld);
> -	return to_cxl_switch_decoder(&cxld->dev);
> +	return to_cxl_root_decoder(&cxld->dev);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_root_decoder_alloc, CXL);
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 7525b55b11bb..6dd1e4c57a67 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -253,6 +253,16 @@ struct cxl_switch_decoder {
>  	struct cxl_dport *target[];
>  };
>  
> +/**
> + * struct cxl_root_decoder - Static platform CXL address decoder
> + * @res: host / parent resource for region allocations
> + * @cxlsd: base cxl switch decoder
> + */
> +struct cxl_root_decoder {
> +	struct resource *res;
> +	struct cxl_switch_decoder cxlsd;

Could be nice to those container of macros and just put the cxlsd first.

> +};
> +
>  /**
>   * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
>   * @CXL_NVB_NEW: Set at bridge create and after cxl_pmem_wq is destroyed
> @@ -368,10 +378,11 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
>  					const struct device *dev);
>  
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
> +struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev);
>  bool is_root_decoder(struct device *dev);
>  bool is_endpoint_decoder(struct device *dev);
> -struct cxl_switch_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
> -						  unsigned int nr_targets);
> +struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
> +						unsigned int nr_targets);
>  struct cxl_switch_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
>  						    unsigned int nr_targets);
>  int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
> 


