Return-Path: <nvdimm+bounces-2697-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id AC17A4A4DEC
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 19:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D332F1C09DB
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 18:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D498C2CA8;
	Mon, 31 Jan 2022 18:19:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD32C9C
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 18:19:33 +0000 (UTC)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnbtD0dZ8z67yjQ;
	Tue,  1 Feb 2022 02:19:00 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 31 Jan 2022 19:19:30 +0100
Received: from localhost (10.47.73.212) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 31 Jan
 2022 18:19:30 +0000
Date: Mon, 31 Jan 2022 18:19:24 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 27/40] cxl/pci: Cache device DVSEC offset
Message-ID: <20220131181924.00006c57@Huawei.com>
In-Reply-To: <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Sun, 23 Jan 2022 16:31:02 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <ben.widawsky@intel.com>
> 
> The PCIe device DVSEC, defined in the CXL 2.0 spec, 8.1.3 is required to
> be implemented by CXL 2.0 endpoint devices. Since the information
> contained within this DVSEC will be critically important, it makes sense
> to find the value early, and error out if it cannot be found.
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Guess the logic makes sense about checking this early though my cynical
mind says, that if someone is putting in devices that claim to be
CXL ones and this isn't there it is there own problem if they
kernel wastes effort bringing the driver up only to find later
it can't finish doing so...

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

note that I got confused by this one when checking what it was for
as you rename it in the next patch... I'll complain about that there ;)


> ---
>  drivers/cxl/cxlmem.h |    2 ++
>  drivers/cxl/pci.c    |    9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 90d67fff5bed..cedc6d3c0448 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -98,6 +98,7 @@ struct cxl_mbox_cmd {
>   *
>   * @dev: The device associated with this CXL state
>   * @regs: Parsed register blocks
> + * @device_dvsec: Offset to the PCIe device DVSEC
>   * @payload_size: Size of space for payload
>   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
>   * @lsa_size: Size of Label Storage Area
> @@ -126,6 +127,7 @@ struct cxl_dev_state {
>  	struct device *dev;
>  
>  	struct cxl_regs regs;
> +	int device_dvsec;
>  
>  	size_t payload_size;
>  	size_t lsa_size;
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e54dbdf9ac15..76de39b90351 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -408,6 +408,15 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (IS_ERR(cxlds))
>  		return PTR_ERR(cxlds);
>  
> +	cxlds->device_dvsec = pci_find_dvsec_capability(pdev,
> +							PCI_DVSEC_VENDOR_ID_CXL,
> +							CXL_DVSEC_PCIE_DEVICE);
> +	if (!cxlds->device_dvsec) {
> +		dev_err(&pdev->dev,
> +			"Device DVSEC not present. Expect limited functionality.\n");
> +		return -ENXIO;
> +	}
> +
>  	rc = cxl_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map);
>  	if (rc)
>  		return rc;
> 


