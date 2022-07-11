Return-Path: <nvdimm+bounces-4105-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5763561FA9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 17:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id B86A42E0C2B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 15:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A226D3F;
	Thu, 30 Jun 2022 15:48:13 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5FC6D19;
	Thu, 30 Jun 2022 15:48:11 +0000 (UTC)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYjPz4P6Vz67jhH;
	Thu, 30 Jun 2022 23:47:19 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 17:48:08 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 16:48:07 +0100
Date: Thu, 30 Jun 2022 16:48:05 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>
Subject: Re: [PATCH 39/46] cxl/acpi: Add a host-bridge index lookup
 mechanism
Message-ID: <20220630164805.00007b0c@Huawei.com>
In-Reply-To: <20220624041950.559155-14-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-14-dan.j.williams@intel.com>
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

On Thu, 23 Jun 2022 21:19:43 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The ACPI CXL Fixed Memory Window Structure (CFMWS) defines multiple
> methods to determine which host bridge provides access to a given
> endpoint relative to that device's position in the interleave. The
> "Interleave Arithmetic" defines either a "standard modulo" /
> round-random algorithm, or "xormap" based algorithm which can be defined
> as a non-linear transform. Given that there are already more options
> beyond "standard modulo" and that "xormap" may turn out to be ACPI CXL
> specific, provide a callback for the region provisioning code to map
> endpoint positions back to expected host bridge id (cxl_dport target).
> 
> For now just support the simple modulo math case and save the xormap for
> a follow-on change.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/port.c | 15 +++++++++++++++
>  drivers/cxl/cxl.h       |  2 ++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 562a6453249b..7756409d0a58 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1422,6 +1422,20 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
>  	return rc;
>  }
>  
> +static struct cxl_dport *cxl_hb_modulo(struct cxl_root_decoder *cxlrd, int pos)
> +{
> +	struct cxl_switch_decoder *cxlsd = &cxlrd->cxlsd;
> +	struct cxl_decoder *cxld = &cxlsd->cxld;
> +	int iw;
> +
> +	iw = cxld->interleave_ways;
> +	if (dev_WARN_ONCE(&cxld->dev, iw != cxlsd->nr_targets,
> +			  "misconfigured root decoder\n"))
> +		return NULL;
> +
> +	return cxlrd->cxlsd.target[pos % iw];
> +}
> +
>  static struct lock_class_key cxl_decoder_key;
>  
>  /**
> @@ -1466,6 +1480,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>  				if (rc < 0)
>  					goto err;
>  				atomic_set(&cxlrd->region_id, rc);
> +				cxlrd->calc_hb = cxl_hb_modulo;
>  			} else
>  				cxlsd = NULL;
>  		} else {
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 9340deccad4f..30227348f768 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -315,11 +315,13 @@ struct cxl_switch_decoder {
>   * struct cxl_root_decoder - Static platform CXL address decoder
>   * @res: host / parent resource for region allocations
>   * @region_id: region id for next region provisioning event
> + * @calc_hb: which host bridge covers the n'th position by granularity
>   * @cxlsd: base cxl switch decoder
>   */
>  struct cxl_root_decoder {
>  	struct resource *res;
>  	atomic_t region_id;
> +	struct cxl_dport *(*calc_hb)(struct cxl_root_decoder *cxlrd, int pos);
>  	struct cxl_switch_decoder cxlsd;
>  };
>  


