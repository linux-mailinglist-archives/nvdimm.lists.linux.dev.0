Return-Path: <nvdimm+bounces-1134-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53263FF340
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Sep 2021 20:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 631563E053D
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Sep 2021 18:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00AF52FB2;
	Thu,  2 Sep 2021 18:30:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0113FCD
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 18:30:33 +0000 (UTC)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H0qF91Hynz67jRt;
	Fri,  3 Sep 2021 02:28:45 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 2 Sep 2021 20:30:30 +0200
Received: from localhost (10.52.127.69) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 19:30:29 +0100
Date: Thu, 2 Sep 2021 19:30:31 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, <stable@vger.kernel.org>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>, <ira.weiny@intel.com>,
	<ben.widawsky@intel.com>
Subject: Re: [PATCH v3 23/28] cxl/acpi: Do not add DSDT disabled ACPI0016
 host bridge ports
Message-ID: <20210902193031.000035b4@Huawei.com>
In-Reply-To: <162982124835.1124374.16212896894542743429.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982124835.1124374.16212896894542743429.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.52.127.69]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:07:28 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Alison Schofield <alison.schofield@intel.com>
> 
> During CXL ACPI probe, host bridge ports are discovered by scanning
> the ACPI0017 root port for ACPI0016 host bridge devices. The scan
> matches on the hardware id of "ACPI0016". An issue occurs when an
> ACPI0016 device is defined in the DSDT yet disabled on the platform.
> Attempts by the cxl_acpi driver to add host bridge ports using a
> disabled device fails, and the entire cxl_acpi probe fails.
> 
> The DSDT table includes an _STA method that sets the status and the
> ACPI subsystem has checks available to examine it. One such check is
> in the acpi_pci_find_root() path. Move the call to acpi_pci_find_root()
> to the matching function to prevent this issue when adding either
> upstream or downstream ports.
You could mention that has the side effect that the existing
call in add_host_bridge_uport() is now guarantee not to fail so
can be moved closer to where it is used.  That chunk had
me briefly confused.

> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Fixes: 7d4b5ca2e2cb ("cxl/acpi: Add downstream port data to cxl_port instances")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
I'd imagine we want to get this in an early rc so perhaps pull out of
this series.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  drivers/cxl/acpi.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 8ae89273f58e..2d8f1ec1abff 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -243,6 +243,9 @@ static struct acpi_device *to_cxl_host_bridge(struct device *dev)
>  {
>  	struct acpi_device *adev = to_acpi_device(dev);
>  
> +	if (!acpi_pci_find_root(adev->handle))
> +		return NULL;
> +
>  	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
>  		return adev;
>  	return NULL;
> @@ -266,10 +269,6 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  	if (!bridge)
>  		return 0;
>  
> -	pci_root = acpi_pci_find_root(bridge->handle);
> -	if (!pci_root)
> -		return -ENXIO;
> -
>  	dport = find_dport_by_dev(root_port, match);
>  	if (!dport) {
>  		dev_dbg(host, "host bridge expected and not found\n");
> @@ -282,6 +281,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  		return PTR_ERR(port);
>  	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
>  
> +	pci_root = acpi_pci_find_root(bridge->handle);
>  	ctx = (struct cxl_walk_context){
>  		.dev = host,
>  		.root = pci_root->bus,
> 


