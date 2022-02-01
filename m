Return-Path: <nvdimm+bounces-2753-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD1B4A5FED
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 16:24:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 232921C0A95
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 15:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C482CA7;
	Tue,  1 Feb 2022 15:24:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F002C82
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643729052; x=1675265052;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PiisifOP6Owd2ujPZ/s8BSQ7ZkKzSF51SGkqgdrJosA=;
  b=Kt0ckzDSW2iZ++Ze/wAyT0Jsv68Ls+Iz4nH0VCI+HA1lpxW9R92B6R3Y
   R3BsYw7RSBDcD6S29Wf9Z4zVh09yuNxm6G6veC4WPYOpQ+GyKM49T8sAU
   I6IM5iiwEdeFXDar9w0uWooAq4ZxD8tvpgGb4fQ/vLFvr8sUIOl97GUmp
   Jn5e6ckjJaJHIxqC4F40cmYLgzmOCLWmTOREz9CY8xgSjm9HCKtt2Q4O5
   KM+7Vi46AHa+t/Hdc0B83ANfV6CjqjJdKHGm8ylUxvJwiEdMwtvlA2ULz
   5XR9S9BlIxhu8vR4LCKWZ09Z7EpjNfc0YKlCQCL01Qo3B52zJglzit/nx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="235106549"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="235106549"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 07:24:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="479721965"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.8])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 07:24:11 -0800
Date: Tue, 1 Feb 2022 07:24:10 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
	linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 27/40] cxl/pci: Cache device DVSEC offset
Message-ID: <20220201152410.36jvdmmpcqi3lhdw@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131181924.00006c57@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131181924.00006c57@Huawei.com>

On 22-01-31 18:19:24, Jonathan Cameron wrote:
> On Sun, 23 Jan 2022 16:31:02 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > From: Ben Widawsky <ben.widawsky@intel.com>
> > 
> > The PCIe device DVSEC, defined in the CXL 2.0 spec, 8.1.3 is required to
> > be implemented by CXL 2.0 endpoint devices. Since the information
> > contained within this DVSEC will be critically important, it makes sense
> > to find the value early, and error out if it cannot be found.
> > 
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Guess the logic makes sense about checking this early though my cynical
> mind says, that if someone is putting in devices that claim to be
> CXL ones and this isn't there it is there own problem if they
> kernel wastes effort bringing the driver up only to find later
> it can't finish doing so...

I don't remember if Dan and I discussed actually failing to bind this early if
the DVSEC isn't there. I think the concern is less about wasted effort and more
about the inability to determine if the device is actively decoding something
and then having the kernel driver tear that out when it takes over the decoder
resources. This was specifically targeted toward the DVSEC range registers
(obviously things would fail later if we couldn't find the MMIO).

I agree with your cynical mind though that it might not be our job to prevent
devices which aren't spec compliant. I'd say if we start seeing bug reports
around this we can revisit.

> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> note that I got confused by this one when checking what it was for
> as you rename it in the next patch... I'll complain about that there ;)
> 
> 
> > ---
> >  drivers/cxl/cxlmem.h |    2 ++
> >  drivers/cxl/pci.c    |    9 +++++++++
> >  2 files changed, 11 insertions(+)
> > 
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 90d67fff5bed..cedc6d3c0448 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -98,6 +98,7 @@ struct cxl_mbox_cmd {
> >   *
> >   * @dev: The device associated with this CXL state
> >   * @regs: Parsed register blocks
> > + * @device_dvsec: Offset to the PCIe device DVSEC
> >   * @payload_size: Size of space for payload
> >   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> >   * @lsa_size: Size of Label Storage Area
> > @@ -126,6 +127,7 @@ struct cxl_dev_state {
> >  	struct device *dev;
> >  
> >  	struct cxl_regs regs;
> > +	int device_dvsec;
> >  
> >  	size_t payload_size;
> >  	size_t lsa_size;
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index e54dbdf9ac15..76de39b90351 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -408,6 +408,15 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	if (IS_ERR(cxlds))
> >  		return PTR_ERR(cxlds);
> >  
> > +	cxlds->device_dvsec = pci_find_dvsec_capability(pdev,
> > +							PCI_DVSEC_VENDOR_ID_CXL,
> > +							CXL_DVSEC_PCIE_DEVICE);
> > +	if (!cxlds->device_dvsec) {
> > +		dev_err(&pdev->dev,
> > +			"Device DVSEC not present. Expect limited functionality.\n");
> > +		return -ENXIO;
> > +	}
> > +
> >  	rc = cxl_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map);
> >  	if (rc)
> >  		return rc;
> > 
> 

