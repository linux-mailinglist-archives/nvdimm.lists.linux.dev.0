Return-Path: <nvdimm+bounces-2688-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2584A4BB9
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 17:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C9FC91C09AA
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 16:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BEA2CA8;
	Mon, 31 Jan 2022 16:21:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6635C2CA5
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 16:20:58 +0000 (UTC)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnYFP1Pc1z67yjQ;
	Tue,  1 Feb 2022 00:20:25 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 17:20:56 +0100
Received: from localhost (10.47.73.212) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 31 Jan
 2022 16:20:55 +0000
Date: Mon, 31 Jan 2022 16:20:50 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 19/40] cxl/port: Up-level cxl_add_dport() locking
 requirements to the caller
Message-ID: <20220131162050.000076b1@Huawei.com>
In-Reply-To: <164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Sun, 23 Jan 2022 16:30:20 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for moving dport enumeration into the core, require the
> port device lock to be acquired by the caller.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Why does it make sense to drop the cxl_device_lock() lockdep stuff
in the paths affected here?

> ---
>  drivers/cxl/acpi.c            |    2 ++
>  drivers/cxl/core/port.c       |    3 +--
>  tools/testing/cxl/mock_acpi.c |    4 ++++
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index ab2b76532272..e596dc375267 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -342,7 +342,9 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  		return 0;
>  	}
>  
> +	device_lock(&root_port->dev);
>  	rc = cxl_add_dport(root_port, match, uid, ctx.chbcr);
> +	device_unlock(&root_port->dev);
>  	if (rc) {
>  		dev_err(host, "failed to add downstream port: %s\n",
>  			dev_name(match));
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index ec9587e52423..c51a10154e29 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -516,7 +516,7 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
>  {
>  	struct cxl_dport *dup;
>  
> -	cxl_device_lock(&port->dev);
> +	device_lock_assert(&port->dev);
>  	dup = find_dport(port, new->port_id);
>  	if (dup)
>  		dev_err(&port->dev,
> @@ -525,7 +525,6 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
>  			dev_name(dup->dport));
>  	else
>  		list_add_tail(&new->list, &port->dports);
> -	cxl_device_unlock(&port->dev);
>  
>  	return dup ? -EEXIST : 0;
>  }
> diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
> index 4c8a493ace56..667c032ccccf 100644
> --- a/tools/testing/cxl/mock_acpi.c
> +++ b/tools/testing/cxl/mock_acpi.c
> @@ -57,7 +57,9 @@ static int match_add_root_port(struct pci_dev *pdev, void *data)
>  
>  	/* TODO walk DVSEC to find component register base */
>  	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
> +	device_lock(&port->dev);
>  	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
> +	device_unlock(&port->dev);
>  	if (rc) {
>  		dev_err(dev, "failed to add dport: %s (%d)\n",
>  			dev_name(&pdev->dev), rc);
> @@ -78,7 +80,9 @@ static int mock_add_root_port(struct platform_device *pdev, void *data)
>  	struct device *dev = ctx->dev;
>  	int rc;
>  
> +	device_lock(&port->dev);
>  	rc = cxl_add_dport(port, &pdev->dev, pdev->id, CXL_RESOURCE_NONE);
> +	device_unlock(&port->dev);
>  	if (rc) {
>  		dev_err(dev, "failed to add dport: %s (%d)\n",
>  			dev_name(&pdev->dev), rc);
> 


