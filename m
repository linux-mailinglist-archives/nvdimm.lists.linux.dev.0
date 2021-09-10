Return-Path: <nvdimm+bounces-1250-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 742DA40695F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 11:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 686201C0FAE
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 09:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5BC32FB3;
	Fri, 10 Sep 2021 09:57:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6288E3FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 09:57:09 +0000 (UTC)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5WSf48Knz67kNV;
	Fri, 10 Sep 2021 17:54:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 11:57:06 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 10:57:05 +0100
Date: Fri, 10 Sep 2021 10:57:04 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 18/21] cxl/bus: Populate the target list at decoder
 create
Message-ID: <20210910105704.000060c4@Huawei.com>
In-Reply-To: <163116439000.2460985.11713777051267946018.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116439000.2460985.11713777051267946018.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.123.213]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 8 Sep 2021 22:13:10 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> As found by cxl_test, the implementation populated the target_list for
> the single dport exceptional case, it missed populating the target_list
> for the typical multi-dport case. Root decoders always know their target
> list at the beginning of time, and even switch-level decoders should
> have a target list of one or more zeros by default, depending on the
> interleave-ways setting.
> 
> Walk the hosting port's dport list and populate based on the passed in
> map.
> 
> Move devm_cxl_add_passthrough_decoder() out of line now that it does the
> work of generating a target_map.
> 
> Before:
> $ cat /sys/bus/cxl/devices/root2/decoder*/target_list
> 0
> 
> 0
> 
> After:
> $ cat /sys/bus/cxl/devices/root2/decoder*/target_list
> 0
> 0,1,2,3
> 0
> 0,1,2,3
> 
> Where root2 is a CXL topology root object generated by 'cxl_test'.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/acpi.c     |   13 +++++++-
>  drivers/cxl/core/bus.c |   80 +++++++++++++++++++++++++++++++++++++++++-------
>  drivers/cxl/cxl.h      |   25 ++++++---------
>  3 files changed, 91 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index d31a97218593..9d881eacdae5 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -52,6 +52,12 @@ static int cxl_acpi_cfmws_verify(struct device *dev,
>  		return -EINVAL;
>  	}
>  
> +	if (CFMWS_INTERLEAVE_WAYS(cfmws) > CXL_DECODER_MAX_INTERLEAVE) {
> +		dev_err(dev, "CFMWS Interleave Ways (%d) too large\n",
> +			CFMWS_INTERLEAVE_WAYS(cfmws));
> +		return -EINVAL;
> +	}
> +
>  	expected_len = struct_size((cfmws), interleave_targets,
>  				   CFMWS_INTERLEAVE_WAYS(cfmws));
>  
> @@ -71,6 +77,7 @@ static int cxl_acpi_cfmws_verify(struct device *dev,
>  static void cxl_add_cfmws_decoders(struct device *dev,
>  				   struct cxl_port *root_port)
>  {
> +	int target_map[CXL_DECODER_MAX_INTERLEAVE];
>  	struct acpi_cedt_cfmws *cfmws;
>  	struct cxl_decoder *cxld;
>  	acpi_size len, cur = 0;
> @@ -83,6 +90,7 @@ static void cxl_add_cfmws_decoders(struct device *dev,
>  
>  	while (cur < len) {
>  		struct acpi_cedt_header *c = cedt_subtable + cur;
> +		int i;
>  
>  		if (c->type != ACPI_CEDT_TYPE_CFMWS) {
>  			cur += c->length;
> @@ -108,6 +116,9 @@ static void cxl_add_cfmws_decoders(struct device *dev,
>  			continue;
>  		}
>  
> +		for (i = 0; i < CFMWS_INTERLEAVE_WAYS(cfmws); i++)
> +			target_map[i] = cfmws->interleave_targets[i];
> +
>  		flags = cfmws_to_decoder_flags(cfmws->restrictions);
>  		cxld = devm_cxl_add_decoder(dev, root_port,
>  					    CFMWS_INTERLEAVE_WAYS(cfmws),
> @@ -115,7 +126,7 @@ static void cxl_add_cfmws_decoders(struct device *dev,
>  					    CFMWS_INTERLEAVE_WAYS(cfmws),
>  					    CFMWS_INTERLEAVE_GRANULARITY(cfmws),
>  					    CXL_DECODER_EXPANDER,
> -					    flags);
> +					    flags, target_map);
>  
>  		if (IS_ERR(cxld)) {
>  			dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
> diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> index 8073354ba232..176bede30c55 100644
> --- a/drivers/cxl/core/bus.c
> +++ b/drivers/cxl/core/bus.c
> @@ -453,11 +453,38 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport_dev, int port_id,
>  }
>  EXPORT_SYMBOL_GPL(cxl_add_dport);
>  
> +static int decoder_populate_targets(struct device *host,
> +				    struct cxl_decoder *cxld,
> +				    struct cxl_port *port, int *target_map,
> +				    int nr_targets)
> +{
> +	int rc = 0, i;
> +
> +	if (!target_map)
> +		return 0;
> +
> +	device_lock(&port->dev);
> +	for (i = 0; i < nr_targets; i++) {
> +		struct cxl_dport *dport = find_dport(port, target_map[i]);
> +
> +		if (!dport) {
> +			rc = -ENXIO;
> +			break;
> +		}
> +		dev_dbg(host, "%s: target: %d\n", dev_name(dport->dport), i);
> +		cxld->target[i] = dport;
> +	}
> +	device_unlock(&port->dev);
> +
> +	return rc;
> +}
> +
>  static struct cxl_decoder *
> -cxl_decoder_alloc(struct cxl_port *port, int nr_targets, resource_size_t base,
> -		  resource_size_t len, int interleave_ways,
> -		  int interleave_granularity, enum cxl_decoder_type type,
> -		  unsigned long flags)
> +cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
> +		  resource_size_t base, resource_size_t len,
> +		  int interleave_ways, int interleave_granularity,
> +		  enum cxl_decoder_type type, unsigned long flags,
> +		  int *target_map)
>  {
>  	struct cxl_decoder *cxld;
>  	struct device *dev;
> @@ -493,10 +520,10 @@ cxl_decoder_alloc(struct cxl_port *port, int nr_targets, resource_size_t base,
>  		.target_type = type,
>  	};
>  
> -	/* handle implied target_list */
> -	if (interleave_ways == 1)
> -		cxld->target[0] =
> -			list_first_entry(&port->dports, struct cxl_dport, list);
> +	rc = decoder_populate_targets(host, cxld, port, target_map, nr_targets);
> +	if (rc)
> +		goto err;
> +
>  	dev = &cxld->dev;
>  	device_initialize(dev);
>  	device_set_pm_not_required(dev);
> @@ -519,14 +546,19 @@ struct cxl_decoder *
>  devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
>  		     resource_size_t base, resource_size_t len,
>  		     int interleave_ways, int interleave_granularity,
> -		     enum cxl_decoder_type type, unsigned long flags)
> +		     enum cxl_decoder_type type, unsigned long flags,
> +		     int *target_map)
>  {
>  	struct cxl_decoder *cxld;
>  	struct device *dev;
>  	int rc;
>  
> -	cxld = cxl_decoder_alloc(port, nr_targets, base, len, interleave_ways,
> -				 interleave_granularity, type, flags);
> +	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
> +		return ERR_PTR(-EINVAL);
> +
> +	cxld = cxl_decoder_alloc(host, port, nr_targets, base, len,
> +				 interleave_ways, interleave_granularity, type,
> +				 flags, target_map);
>  	if (IS_ERR(cxld))
>  		return cxld;
>  
> @@ -550,6 +582,32 @@ devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
>  }
>  EXPORT_SYMBOL_GPL(devm_cxl_add_decoder);
>  
> +/*
> + * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability Structure)
> + * single ported host-bridges need not publish a decoder capability when a
> + * passthrough decode can be assumed, i.e. all transactions that the uport sees
> + * are claimed and passed to the single dport. Default the range a 0-base
> + * 0-length until the first CXL region is activated.
> + */
> +struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
> +						     struct cxl_port *port)
> +{
> +	struct cxl_dport *dport;
> +	int target_map[1];
> +
> +	device_lock(&port->dev);
> +	dport = list_first_entry_or_null(&port->dports, typeof(*dport), list);
> +	device_unlock(&port->dev);
> +
> +	if (!dport)
> +		return ERR_PTR(-ENXIO);
> +
> +	target_map[0] = dport->port_id;
> +	return devm_cxl_add_decoder(host, port, 1, 0, 0, 1, PAGE_SIZE,
> +				    CXL_DECODER_EXPANDER, 0, target_map);
> +}
> +EXPORT_SYMBOL_GPL(devm_cxl_add_passthrough_decoder);
> +
>  /**
>   * __cxl_driver_register - register a driver for the cxl bus
>   * @cxl_drv: cxl driver structure to attach
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index c5152718267e..84b8836c1f91 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -180,6 +180,12 @@ enum cxl_decoder_type {
>         CXL_DECODER_EXPANDER = 3,
>  };
>  
> +/*
> + * Current specification goes up to 8, double that seems a reasonable
> + * software max for the foreseeable future
> + */
> +#define CXL_DECODER_MAX_INTERLEAVE 16
> +
>  /**
>   * struct cxl_decoder - CXL address range decode configuration
>   * @dev: this decoder's device
> @@ -284,22 +290,11 @@ struct cxl_decoder *
>  devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
>  		     resource_size_t base, resource_size_t len,
>  		     int interleave_ways, int interleave_granularity,
> -		     enum cxl_decoder_type type, unsigned long flags);
> -
> -/*
> - * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability Structure)
> - * single ported host-bridges need not publish a decoder capability when a
> - * passthrough decode can be assumed, i.e. all transactions that the uport sees
> - * are claimed and passed to the single dport. Default the range a 0-base
> - * 0-length until the first CXL region is activated.
> - */
> -static inline struct cxl_decoder *
> -devm_cxl_add_passthrough_decoder(struct device *host, struct cxl_port *port)
> -{
> -	return devm_cxl_add_decoder(host, port, 1, 0, 0, 1, PAGE_SIZE,
> -				    CXL_DECODER_EXPANDER, 0);
> -}
> +		     enum cxl_decoder_type type, unsigned long flags,
> +		     int *target_map);
>  
> +struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
> +						     struct cxl_port *port);
>  extern struct bus_type cxl_bus_type;
>  
>  struct cxl_driver {
> 


