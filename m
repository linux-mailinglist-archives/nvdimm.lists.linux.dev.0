Return-Path: <nvdimm+bounces-2684-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF714A49BD
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 15:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1CA2D1C0A22
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 14:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD402CA8;
	Mon, 31 Jan 2022 14:57:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533C42CA5
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 14:57:38 +0000 (UTC)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnWJX4Ktrz67yKf;
	Mon, 31 Jan 2022 22:53:00 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 15:57:35 +0100
Received: from localhost (10.47.73.212) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 31 Jan
 2022 14:57:34 +0000
Date: Mon, 31 Jan 2022 14:57:29 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 14/40] cxl/core: Track port depth
Message-ID: <20220131145729.0000056f@Huawei.com>
In-Reply-To: <164298419321.3018233.4469731547378993606.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164298419321.3018233.4469731547378993606.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.47.73.212]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Sun, 23 Jan 2022 16:29:53 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <ben.widawsky@intel.com>
> 
> In preparation for proving CXL subsystem usage of the device_lock()
> order track the depth of ports with the expectation that  shallower port

It's nitpick Monday: double space before shallower.

> locks can be held over deeper port locks.
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/port.c |    2 ++
>  drivers/cxl/cxl.h       |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 826b300ba950..4ec5febf73fb 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -362,6 +362,8 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
>  	if (IS_ERR(port))
>  		return port;
>  
> +	if (parent_port)
> +		port->depth = parent_port->depth + 1;
>  	dev = &port->dev;
>  	if (parent_port)
>  		rc = dev_set_name(dev, "port%d", port->id);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index e60878ab4569..c1dc53492773 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -252,6 +252,7 @@ struct cxl_walk_context {
>   * @dports: cxl_dport instances referenced by decoders
>   * @decoder_ida: allocator for decoder ids
>   * @component_reg_phys: component register capability base address (optional)
> + * @depth: How deep this port is relative to the root. depth 0 is the root.
>   */
>  struct cxl_port {
>  	struct device dev;
> @@ -260,6 +261,7 @@ struct cxl_port {
>  	struct list_head dports;
>  	struct ida decoder_ida;
>  	resource_size_t component_reg_phys;
> +	unsigned int depth;
>  };
>  
>  /**
> 


