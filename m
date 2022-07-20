Return-Path: <nvdimm+bounces-4377-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2E357BB8E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 18:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F3D01C209E4
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 16:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22B56037;
	Wed, 20 Jul 2022 16:40:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B92633D5
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 16:40:38 +0000 (UTC)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp1cB1lL8z67mMG;
	Thu, 21 Jul 2022 00:38:50 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 18:40:35 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 17:40:34 +0100
Date: Wed, 20 Jul 2022 17:40:31 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <bwidawsk@kernel.org>,
	<hch@lst.de>, <nvdimm@lists.linux.dev>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 06/28] cxl/hdm: Enumerate allocated DPA
Message-ID: <20220720174031.00006f78@Huawei.com>
In-Reply-To: <165784327682.1758207.7914919426043855876.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784327682.1758207.7914919426043855876.stgit@dwillia2-xfh.jf.intel.com>
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
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 14 Jul 2022 17:01:16 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for provisioning CXL regions, add accounting for the DPA
> space consumed by existing regions / decoders. Recall, a CXL region is a
> memory range comprised from one or more endpoint devices contributing a
> mapping of their DPA into HPA space through a decoder.
> 
> Record the DPA ranges covered by committed decoders at initial probe of
> endpoint ports relative to a per-device resource tree of the DPA type
> (pmem or volatile-ram).
> 
> The cxl_dpa_rwsem semaphore is introduced to globally synchronize DPA
> state across all endpoints and their decoders at once. The vast majority
> of DPA operations are reads as region creation is expected to be as rare
> as disk partitioning and volume creation. The device_lock() for this
> synchronization is specifically avoided for concern of entangling with
> sysfs attribute removal.
> 
> Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com> 

One trivial ordering question inline. I'm not that bothered whether you
do anything about it though as it's all very local.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/hdm.c |  143 ++++++++++++++++++++++++++++++++++++++++++++----
>  drivers/cxl/cxl.h      |    2 +
>  drivers/cxl/cxlmem.h   |   13 ++++
>  3 files changed, 147 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 650363d5272f..d4c17325001b 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -153,10 +153,105 @@ void cxl_dpa_debug(struct seq_file *file, struct cxl_dev_state *cxlds)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dpa_debug, CXL);
>  
> +/*
> + * Must be called in a context that synchronizes against this decoder's
> + * port ->remove() callback (like an endpoint decoder sysfs attribute)
> + */
> +static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct resource *res = cxled->dpa_res;
> +
> +	lockdep_assert_held_write(&cxl_dpa_rwsem);
> +
> +	if (cxled->skip)
> +		__release_region(&cxlds->dpa_res, res->start - cxled->skip,
> +				 cxled->skip);
> +	cxled->skip = 0;
> +	__release_region(&cxlds->dpa_res, res->start, resource_size(res));

Minor but I think the ordering in here is unnecessarily not the opposite
of what is going on in __cxl_dpa_reserve()  Should be releasing the
actual rs first, then releasing the skip.

> +	cxled->dpa_res = NULL;
> +}
> +
> +static void cxl_dpa_release(void *cxled)
> +{
> +	down_write(&cxl_dpa_rwsem);
> +	__cxl_dpa_release(cxled);
> +	up_write(&cxl_dpa_rwsem);
> +}
> +
> +static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
> +			     resource_size_t base, resource_size_t len,
> +			     resource_size_t skipped)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	struct cxl_port *port = cxled_to_port(cxled);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct device *dev = &port->dev;
> +	struct resource *res;
> +
> +	lockdep_assert_held_write(&cxl_dpa_rwsem);
> +
> +	if (!len)
> +		return 0;
> +
> +	if (cxled->dpa_res) {
> +		dev_dbg(dev, "decoder%d.%d: existing allocation %pr assigned\n",
> +			port->id, cxled->cxld.id, cxled->dpa_res);
> +		return -EBUSY;
> +	}
> +
> +	if (skipped) {
> +		res = __request_region(&cxlds->dpa_res, base - skipped, skipped,
> +				       dev_name(&cxled->cxld.dev), 0);
> +		if (!res) {
> +			dev_dbg(dev,
> +				"decoder%d.%d: failed to reserve skipped space\n",
> +				port->id, cxled->cxld.id);
> +			return -EBUSY;
> +		}
> +	}
> +	res = __request_region(&cxlds->dpa_res, base, len,
> +			       dev_name(&cxled->cxld.dev), 0);
> +	if (!res) {
> +		dev_dbg(dev, "decoder%d.%d: failed to reserve allocation\n",
> +			port->id, cxled->cxld.id);
> +		if (skipped)
> +			__release_region(&cxlds->dpa_res, base - skipped,
> +					 skipped);
> +		return -EBUSY;
> +	}
> +	cxled->dpa_res = res;
> +	cxled->skip = skipped;
> +
> +	return 0;
> +}
> +

...


