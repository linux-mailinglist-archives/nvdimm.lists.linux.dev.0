Return-Path: <nvdimm+bounces-4096-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7105616C6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 11:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 7B1C22E0A31
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 09:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79EF3ECB;
	Thu, 30 Jun 2022 09:48:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (unknown [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23867EBB;
	Thu, 30 Jun 2022 09:48:32 +0000 (UTC)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYYP42Qkcz6H6rB;
	Thu, 30 Jun 2022 17:46:00 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 30 Jun 2022 11:48:23 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 10:48:22 +0100
Date: Thu, 30 Jun 2022 10:48:20 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>
Subject: Re: [PATCH 32/46] cxl/mem: Enumerate port targets before adding
 endpoints
Message-ID: <20220630104820.00006d6e@Huawei.com>
In-Reply-To: <20220624041950.559155-7-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-7-dan.j.williams@intel.com>
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

On Thu, 23 Jun 2022 21:19:36 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The port scanning algorithm in devm_cxl_enumerate_ports() walks up the
> topology and adds cxl_port objects starting from the root down to the
> endpoint. When those ports are initially created they know all their
> dports, but they do not know the downstream cxl_port instance that
> represents the next descendant in the topology. Rework create_endpoint()
> into devm_cxl_add_endpoint() that enumerates the downstream cxl_port
> topology into each port's 'struct cxl_ep' record for each endpoint it
> that the port is an ancestor.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'm doing my normal moaning about tidying up in a patch that makes
a more serious change.  Ideally pull that out, but meh if it's a real pain
I can live with it as long as you call it out in the patch description.

With that

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/port.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |  7 ++++++-
>  drivers/cxl/mem.c       | 30 +-----------------------------
>  3 files changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 08a380d20cf1..2e56903399c2 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1089,6 +1089,47 @@ static struct cxl_ep *cxl_ep_load(struct cxl_port *port,
>  	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
>  }
>  
> +int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> +			  struct cxl_dport *parent_dport)
> +{
> +	struct cxl_port *parent_port = parent_dport->port;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct cxl_port *endpoint, *iter, *down;
> +	int rc;
> +
> +	/*
> +	 * Now that the path to the root is established record all the
> +	 * intervening ports in the chain.
> +	 */
> +	for (iter = parent_port, down = NULL; !is_cxl_root(iter);
> +	     down = iter, iter = to_cxl_port(iter->dev.parent)) {
> +		struct cxl_ep *ep;
> +
> +		ep = cxl_ep_load(iter, cxlmd);
> +		ep->next = down;
> +	}
> +
> +	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> +				     cxlds->component_reg_phys, parent_dport);
> +	if (IS_ERR(endpoint))
> +		return PTR_ERR(endpoint);
> +
> +	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
> +
> +	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
> +	if (rc)
> +		return rc;
> +
> +	if (!endpoint->dev.driver) {
> +		dev_err(&cxlmd->dev, "%s failed probe\n",
> +			dev_name(&endpoint->dev));
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(devm_cxl_add_endpoint, CXL);
> +
>  static void cxl_detach_ep(void *data)
>  {
>  	struct cxl_memdev *cxlmd = data;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 0211cf0d3574..f761cf78cc05 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -371,11 +371,14 @@ struct cxl_dport {
>  /**
>   * struct cxl_ep - track an endpoint's interest in a port
>   * @ep: device that hosts a generic CXL endpoint (expander or accelerator)
> - * @dport: which dport routes to this endpoint on this port
> + * @dport: which dport routes to this endpoint on @port

fix is good, but shouldn't be in this patch really..

> + * @next: cxl switch port across the link attached to @dport NULL if
> + *	  attached to an endpoint
>   */
>  struct cxl_ep {
>  	struct device *ep;
>  	struct cxl_dport *dport;
> +	struct cxl_port *next;
>  };
>  
>  /*
> @@ -398,6 +401,8 @@ struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
>  struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
>  				   resource_size_t component_reg_phys,
>  				   struct cxl_dport *parent_dport);
> +int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> +			  struct cxl_dport *parent_dport);
>  struct cxl_port *find_cxl_root(struct device *dev);
>  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
>  int cxl_bus_rescan(void);
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 2786d3402c9e..64ccf053d32c 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -25,34 +25,6 @@
>   * in higher level operations.
>   */
>  
> -static int create_endpoint(struct cxl_memdev *cxlmd,
> -			   struct cxl_dport *parent_dport)
> -{
> -	struct cxl_port *parent_port = parent_dport->port;
> -	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> -	struct cxl_port *endpoint;
> -	int rc;
> -
> -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> -				     cxlds->component_reg_phys, parent_dport);
> -	if (IS_ERR(endpoint))
> -		return PTR_ERR(endpoint);
> -
> -	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
> -
> -	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
> -	if (rc)
> -		return rc;
> -
> -	if (!endpoint->dev.driver) {
> -		dev_err(&cxlmd->dev, "%s failed probe\n",
> -			dev_name(&endpoint->dev));
> -		return -ENXIO;
> -	}
> -
> -	return 0;
> -}
> -
>  static void enable_suspend(void *data)
>  {
>  	cxl_mem_active_dec();
> @@ -116,7 +88,7 @@ static int cxl_mem_probe(struct device *dev)
>  		goto unlock;
>  	}
>  
> -	rc = create_endpoint(cxlmd, dport);
> +	rc = devm_cxl_add_endpoint(cxlmd, dport);
>  unlock:
>  	device_unlock(&parent_port->dev);
>  	put_device(&parent_port->dev);


