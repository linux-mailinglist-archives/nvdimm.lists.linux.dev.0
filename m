Return-Path: <nvdimm+bounces-2679-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 0037C4A4946
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 15:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 6EF973E09CA
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 14:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254852CA8;
	Mon, 31 Jan 2022 14:26:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0A29CA
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 14:26:39 +0000 (UTC)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnVcn5fV8z685ZM;
	Mon, 31 Jan 2022 22:22:01 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 15:26:36 +0100
Received: from localhost (10.47.73.212) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 31 Jan
 2022 14:26:36 +0000
Date: Mon, 31 Jan 2022 14:26:30 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 22/40] cxl/core/hdm: Add CXL standard decoder
 enumeration to the core
Message-ID: <20220131142630.000045fd@Huawei.com>
In-Reply-To: <164316647461.3437452.7695738236907745246.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298423561.3018233.8938479363856921038.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164316647461.3437452.7695738236907745246.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Tue, 25 Jan 2022 19:09:25 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Unlike the decoder enumeration for "root decoders" described by platform
> firmware, standard coders can be enumerated from the component registers
> space once the base address has been identified (via PCI, ACPI, or
> another mechanism).
> 
> Add common infrastructure for HDM (Host-managed-Device-Memory) Decoder
> enumeration and share it between host-bridge, upstream switch port, and
> cxl_test defined decoders.
> 
> The locking model for switch level decoders is to hold the port lock
> over the enumeration. This facilitates moving the dport and decoder
> enumeration to a 'port' driver. For now, the only enumerator of decoder
> resources is the cxl_acpi root driver.
> 
> [ben: fixup kdoc]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

One trivial thing noticed.

> ---
> Changes since v3:
> - Fixup kdoc for devm_cxl_enumerate_decoders() (Ben)
> - Cleanup a sparse warning around __iomem usage (Ben)

...
> +/**
> + * devm_cxl_setup_hdm - map HDM decoder component registers
> + * @port: cxl_port to map

I think you drop it again later in the series, but it would be nice to
avoid kernel doc warnings whilst the host parameter is here.

> + */
> +struct cxl_hdm *devm_cxl_setup_hdm(struct device *host, struct cxl_port *port)
> +{
> +	struct device *dev = &port->dev;
> +	void __iomem *crb, *hdm;
> +	struct cxl_hdm *cxlhdm;
> +
> +	cxlhdm = devm_kzalloc(host, sizeof(*cxlhdm), GFP_KERNEL);
> +	if (!cxlhdm)
> +		return ERR_PTR(-ENOMEM);
> +
> +	cxlhdm->port = port;
> +	crb = devm_cxl_iomap_block(host, port->component_reg_phys,
> +				   CXL_COMPONENT_REG_BLOCK_SIZE);
> +	if (!crb) {
> +		dev_err(dev, "No component registers mapped\n");
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	hdm = map_hdm_decoder_regs(port, crb);
> +	if (IS_ERR(hdm))
> +		return ERR_CAST(hdm);
> +	cxlhdm->regs.hdm_decoder = hdm;
> +
> +	parse_hdm_decoder_caps(cxlhdm);
> +	if (cxlhdm->decoder_count == 0) {
> +		dev_err(dev, "Spec violation. Caps invalid\n");
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	return cxlhdm;
> +}
> +EXPORT_SYMBOL_NS_GPL(devm_cxl_setup_hdm, CXL);

> 


