Return-Path: <nvdimm+bounces-9047-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC99998845
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Oct 2024 15:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAA531F21011
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Oct 2024 13:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435B81C9B9B;
	Thu, 10 Oct 2024 13:49:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0885E1C9DD3
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568172; cv=none; b=sFaBQHHgkf1Z28uwJw25MmfIZ5bCsFm+2Y13aWnC8rTtnEgp1zA+9SzRMnlvchMg8KOxeLIsH19/ZVjoYNQvkjd+o0nm/+WAQas/s6z+daHDAo9JzK6oy7SMvaFmnue3aAgmdaZjQkk8UefZwv3TAxKwMZEklZDcTGqE07P1f38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568172; c=relaxed/simple;
	bh=nBqSAYCspXG50WnbQUQ6A0JibPo+98HLRl/jVeDw7mY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=taV9JqPbafMLUMpdDGZV9Cqeh0iPdun0eo9bxKGc0Dm103D/7Nitim75VvvtM3vgUGjuOLds0H389lXCipHaEULQ6H+yieiiAm525R28bOJk0kBc3PWM7NK3qPuzdazNazdkjTTs+PP2oGyMRsi0bWX3MbKDt0bYNjP7jPQlPDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPWGW03txz6LDJf;
	Thu, 10 Oct 2024 21:45:07 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D1559140AE5;
	Thu, 10 Oct 2024 21:49:27 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 10 Oct
 2024 15:49:27 +0200
Date: Thu, 10 Oct 2024 14:49:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-btrfs@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 17/28] cxl/events: Split event msgnum configuration
 from irq setup
Message-ID: <20241010144925.00006c2b@Huawei.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-17-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-17-c261ee6eeded@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 07 Oct 2024 18:16:23 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Dynamic Capacity Devices (DCD) require event interrupts to process
> memory addition or removal.  BIOS may have control over non-DCD event
> processing.  DCD interrupt configuration needs to be separate from
> memory event interrupt configuration.
> 
> Split cxl_event_config_msgnums() from irq setup in preparation for
> separate DCD interrupts configuration.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Trivial comment inline
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  drivers/cxl/pci.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index fc5ab74448cc..29a863331bec 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -702,35 +702,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
>  	return cxl_event_get_int_policy(mds, policy);
>  }
>  
> -static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
> +static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
> +			      struct cxl_event_interrupt_policy *policy)
>  {
>  	struct cxl_dev_state *cxlds = &mds->cxlds;
> -	struct cxl_event_interrupt_policy policy;
>  	int rc;
>  
> -	rc = cxl_event_config_msgnums(mds, &policy);
> -	if (rc)
> -		return rc;
> -
> -	rc = cxl_event_req_irq(cxlds, policy.info_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->info_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
>  		return rc;

At somepoint maybe dev_err_probe() is appropriate in here.

>  	}
>  
> -	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
>  		return rc;
>  	}
>  
> -	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
>  		return rc;
>  	}
>  
> -	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
>  		return rc;
> @@ -749,7 +745,7 @@ static bool cxl_event_int_is_fw(u8 setting)
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> -	struct cxl_event_interrupt_policy policy;
> +	struct cxl_event_interrupt_policy policy = { 0 };
>  	int rc;
>  
>  	/*
> @@ -777,11 +773,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  		return -EBUSY;
>  	}
>  
> +	rc = cxl_event_config_msgnums(mds, &policy);
> +	if (rc)
> +		return rc;
> +
>  	rc = cxl_mem_alloc_event_buf(mds);
>  	if (rc)
>  		return rc;
>  
> -	rc = cxl_event_irqsetup(mds);
> +	rc = cxl_event_irqsetup(mds, &policy);
>  	if (rc)
>  		return rc;
>  
> 


