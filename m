Return-Path: <nvdimm+bounces-2802-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id C72864A6DE7
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 10:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 0A3911C0D66
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 09:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE7D2CA2;
	Wed,  2 Feb 2022 09:36:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7722F25
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 09:36:55 +0000 (UTC)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JpcBD0650z67Zqk;
	Wed,  2 Feb 2022 17:36:20 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 2 Feb 2022 10:36:52 +0100
Received: from localhost (10.47.70.124) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 2 Feb
 2022 09:36:52 +0000
Date: Wed, 2 Feb 2022 09:36:51 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 27/40] cxl/pci: Cache device DVSEC offset
Message-ID: <20220202093651.000008e2@Huawei.com>
In-Reply-To: <164375309615.513620.7874131241128599893.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164375309615.513620.7874131241128599893.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.47.70.124]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 01 Feb 2022 14:06:32 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <ben.widawsky@intel.com>
> 
> The PCIe device DVSEC, defined in the CXL 2.0 spec, 8.1.3 is required to
> be implemented by CXL 2.0 endpoint devices. In preparation for consuming
> this information in a new cxl_mem driver, retrieve the CXL DVSEC
> position and warn about the implications of not finding it. Allow for
> mailbox operation even if the CXL DVSEC is missing.
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
> Changes since v3:
> - Move the s/device_dvsec/cxl_dvsec/ rename one patch sooner (Jonathan)
> - Warn, don't fail, when CXL DVSEC not found
> 
>  drivers/cxl/cxlmem.h |    2 ++
>  drivers/cxl/pci.c    |    6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 90d67fff5bed..5cf5329e13a9 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -98,6 +98,7 @@ struct cxl_mbox_cmd {
>   *
>   * @dev: The device associated with this CXL state
>   * @regs: Parsed register blocks
> + * @cxl_dvsec: Offset to the PCIe device DVSEC
>   * @payload_size: Size of space for payload
>   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
>   * @lsa_size: Size of Label Storage Area
> @@ -126,6 +127,7 @@ struct cxl_dev_state {
>  	struct device *dev;
>  
>  	struct cxl_regs regs;
> +	int cxl_dvsec;
>  
>  	size_t payload_size;
>  	size_t lsa_size;
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index bf14c365ea33..c94002166084 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -408,6 +408,12 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (IS_ERR(cxlds))
>  		return PTR_ERR(cxlds);
>  
> +	cxlds->cxl_dvsec = pci_find_dvsec_capability(
> +		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
> +	if (!cxlds->cxl_dvsec)
> +		dev_warn(&pdev->dev,
> +			 "Device DVSEC not present, skip CXL.mem init\n");
> +
>  	rc = cxl_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map);
>  	if (rc)
>  		return rc;
> 


