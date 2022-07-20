Return-Path: <nvdimm+bounces-4390-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4289257BCF6
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 19:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3D9C280CFE
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 17:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D356AA6;
	Wed, 20 Jul 2022 17:42:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5296AA0
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 17:41:59 +0000 (UTC)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp2yy5SyYz67bMk;
	Thu, 21 Jul 2022 01:40:10 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 19:41:56 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 18:41:55 +0100
Date: Wed, 20 Jul 2022 18:41:51 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@lst.de>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 24/28] cxl/region: Program target lists
Message-ID: <20220720184151.00005b85@Huawei.com>
In-Reply-To: <165784337827.1758207.132121746122685208.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784337827.1758207.132121746122685208.stgit@dwillia2-xfh.jf.intel.com>
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

On Thu, 14 Jul 2022 17:02:58 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Once the region's interleave geometry (ways, granularity, size) is
> established and all the endpoint decoder targets are assigned, the next
> phase is to program all the intermediate decoders. Specifically, each
> CXL switch in the path between the endpoint and its CXL host-bridge
> (including the logical switch internal to the host-bridge) needs to have
> its decoders programmed and the target list order assigned.
> 
> The difficulty in this implementation lies in determining which endpoint
> decoder ordering combinations are valid. Consider the cxl_test case of 2
> host bridges, each of those host-bridges attached to 2 switches, and
> each of those switches attached to 2 endpoints for a potential 8-way
> interleave. The x2 interleave at the host-bridge level requires that all
> even numbered endpoint decoder positions be located on the "left" hand
> side of the topology tree, and the odd numbered positions on the other.
> The endpoints that are peers on the same switch need to have a position
> that can be routed with a dedicated address bit per-endpoint. See
> check_last_peer() for the details.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'm less confident on this one than most the other patches (and I see I skipped
reviewing it in v1) as I haven't closely checked the verification logic
but except for one trivial comment inline it looks fine to me.
I want to hit the whole series with a wide range of test cases (I'm sure you
already have) to build that confidence, but won't have time to do that till early
August. However, if there are gremlins hiding, I'd expect them to be minor.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 8ac0c557f6aa..225340529fc3 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -485,6 +485,7 @@ static struct cxl_region_ref *alloc_region_ref(struct cxl_port *port,
>  		return NULL;
>  	cxl_rr->port = port;
>  	cxl_rr->region = cxlr;
> +	cxl_rr->nr_targets = 1;
>  	xa_init(&cxl_rr->endpoints);
>  
>  	rc = xa_insert(&port->regions, (unsigned long)cxlr, cxl_rr, GFP_KERNEL);
> @@ -525,10 +526,12 @@ static int cxl_rr_ep_add(struct cxl_region_ref *cxl_rr,
>  	struct cxl_decoder *cxld = cxl_rr->decoder;
>  	struct cxl_ep *ep = cxl_ep_load(port, cxled_to_memdev(cxled));
>  
> -	rc = xa_insert(&cxl_rr->endpoints, (unsigned long)cxled, ep,
> -			 GFP_KERNEL);
> -	if (rc)
> -		return rc;
> +	if (ep) {
> +		rc = xa_insert(&cxl_rr->endpoints, (unsigned long)cxled, ep,
> +			       GFP_KERNEL);
> +		if (rc)
> +			return rc;
> +	}
>  	cxl_rr->nr_eps++;
>  
>  	if (!cxld->region) {
> @@ -565,7 +568,7 @@ static int cxl_port_attach_region(struct cxl_port *port,
>  				  struct cxl_endpoint_decoder *cxled, int pos)
>  {
>  	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> -	struct cxl_ep *ep = cxl_ep_load(port, cxlmd);
> +	const struct cxl_ep *ep = cxl_ep_load(port, cxlmd);

Why const now and not previously?  Feels like this should be in an earlier patch.
Maybe I'm missing something though.

>  	struct cxl_region_ref *cxl_rr = NULL, *iter;
>  	struct cxl_region_params *p = &cxlr->params;
>  	struct cxl_decoder *cxld = NULL;
> @@ -649,6 +652,16 @@ static int cxl_port_attach_region(struct cxl_port *port,
>  		goto out_erase;
>  	}
>  
> +	dev_dbg(&cxlr->dev,
> +		"%s:%s %s add: %s:%s @ %d next: %s nr_eps: %d nr_targets: %d\n",
> +		dev_name(port->uport), dev_name(&port->dev),
> +		dev_name(&cxld->dev), dev_name(&cxlmd->dev),
> +		dev_name(&cxled->cxld.dev), pos,
> +		ep ? ep->next ? dev_name(ep->next->uport) :
> +				      dev_name(&cxlmd->dev) :
> +			   "none",
> +		cxl_rr->nr_eps, cxl_rr->nr_targets);
> +
>  	return 0;
>  out_erase:
>  	if (cxl_rr->nr_eps == 0)



