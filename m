Return-Path: <nvdimm+bounces-4075-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 905345604A9
	for <lists+linux-nvdimm@lfdr.de>; Wed, 29 Jun 2022 17:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 47E172E0A59
	for <lists+linux-nvdimm@lfdr.de>; Wed, 29 Jun 2022 15:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0129A3D6C;
	Wed, 29 Jun 2022 15:31:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4920B33CE;
	Wed, 29 Jun 2022 15:31:07 +0000 (UTC)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LY52z2JWXz687mw;
	Wed, 29 Jun 2022 23:28:43 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 29 Jun 2022 17:31:04 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Wed, 29 Jun
 2022 16:31:03 +0100
Date: Wed, 29 Jun 2022 16:31:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@infradead.org>,
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 17/46] cxl/hdm: Track next decoder to allocate
Message-ID: <20220629163102.000016c4@Huawei.com>
In-Reply-To: <165603882752.551046.12620934370518380800.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603882752.551046.12620934370518380800.stgit@dwillia2-xfh>
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
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 19:47:07 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The CXL specification enforces that endpoint decoders are committed in
> hw instance id order. In preparation for adding dynamic DPA allocation,
> record the hw instance id in endpoint decoders, and enforce allocations
> to occur in hw instance id order.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

dpa_end isn't a good name given the value isn't a Device Physical Address.

Otherwise looks fine,

Jonathan

> ---
>  drivers/cxl/core/hdm.c  |   14 ++++++++++++++
>  drivers/cxl/core/port.c |    1 +
>  drivers/cxl/cxl.h       |    2 ++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 3f929231b822..8805afe63ebf 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -153,6 +153,7 @@ static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled, bool remove_ac
>  	cxled->skip = 0;
>  	__release_region(&cxlds->dpa_res, res->start, resource_size(res));
>  	cxled->dpa_res = NULL;
> +	port->dpa_end--;
>  }
>  
>  static void cxl_dpa_release(void *cxled)
> @@ -183,6 +184,18 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>  		return -EBUSY;
>  	}
>  
> +	if (port->dpa_end + 1 != cxled->cxld.id) {
> +		/*
> +		 * Assumes alloc and commit order is always in hardware instance
> +		 * order per expectations from 8.2.5.12.20 Committing Decoder
> +		 * Programming that enforce decoder[m] committed before
> +		 * decoder[m+1] commit start.
> +		 */
> +		dev_dbg(dev, "decoder%d.%d: expected decoder%d.%d\n", port->id,
> +			cxled->cxld.id, port->id, port->dpa_end + 1);
> +		return -EBUSY;
> +	}
> +
>  	if (skip) {
>  		res = __request_region(&cxlds->dpa_res, base - skip, skip,
>  				       dev_name(dev), 0);
> @@ -213,6 +226,7 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>  			cxled->cxld.id, cxled->dpa_res);
>  		cxled->mode = CXL_DECODER_MIXED;
>  	}
> +	port->dpa_end++;
>  
>  	return 0;
>  }
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 9d632c8c580b..54bf032cbcb7 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -485,6 +485,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	port->uport = uport;
>  	port->component_reg_phys = component_reg_phys;
>  	ida_init(&port->decoder_ida);
> +	port->dpa_end = -1;
>  	INIT_LIST_HEAD(&port->dports);
>  	INIT_LIST_HEAD(&port->endpoints);
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index aa223166f7ef..d8edbdaa6208 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -326,6 +326,7 @@ struct cxl_nvdimm {
>   * @dports: cxl_dport instances referenced by decoders
>   * @endpoints: cxl_ep instances, endpoints that are a descendant of this port
>   * @decoder_ida: allocator for decoder ids
> + * @dpa_end: cursor to track highest allocated decoder for allocation ordering

dpa_end not a good name as this isn't a Device Physical Address.

>   * @component_reg_phys: component register capability base address (optional)
>   * @dead: last ep has been removed, force port re-creation
>   * @depth: How deep this port is relative to the root. depth 0 is the root.
> @@ -337,6 +338,7 @@ struct cxl_port {
>  	struct list_head dports;
>  	struct list_head endpoints;
>  	struct ida decoder_ida;
> +	int dpa_end;
>  	resource_size_t component_reg_phys;
>  	bool dead;
>  	unsigned int depth;
> 


