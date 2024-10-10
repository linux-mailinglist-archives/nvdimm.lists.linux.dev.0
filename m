Return-Path: <nvdimm+bounces-9062-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F51C998CD4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Oct 2024 18:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42B33B37412
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Oct 2024 15:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF021CDA05;
	Thu, 10 Oct 2024 15:58:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AB81CCB5E
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728575891; cv=none; b=VUDuF2rWJv/AA/ptCGK/Ag0o23cotlf6o4EmjCAOlmmzLnV/cxOAcIXTwDcH8qN/3IMDyhB7tEf30bZLEhqWVp9cvhXLq8by7xBm6w5eWWOOWwMxWFuhBW8Y/epysMSqIeFM95Z+gt/rnTfppUYLXsZQUEkOnYjeGXEKOiOSFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728575891; c=relaxed/simple;
	bh=linrfMuZIcX2ctx+ttIzMvMROoVAvMRa7N7PgX7xi6w=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEHgD4AojyuM+7pCfdbmhpOWKq/eTTzs2fAB5//17uST+flKydPzxmc0WZeXohRgmIqRPc9yxcsLgrBKqni7cKb/zOU9v80+60jYs+8LsfkDKVgMgNv0IkFdn217dzWRopXxDyy3NAaGL1cGg/6P/Clx2xZrv5iJRhjxsUf66Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPZ6x6qC5z67n0t;
	Thu, 10 Oct 2024 23:53:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id E4F93140B3C;
	Thu, 10 Oct 2024 23:58:06 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 10 Oct
 2024 17:58:06 +0200
Date: Thu, 10 Oct 2024 16:58:04 +0100
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
Subject: Re: [PATCH v4 28/28] tools/testing/cxl: Add DC Regions to mock mem
 data
Message-ID: <20241010165804.00005391@Huawei.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-28-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-28-c261ee6eeded@intel.com>
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
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 07 Oct 2024 18:16:34 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> cxl_test provides a good way to ensure quick smoke and regression
> testing.  The complexity of Dynamic Capacity (DC) extent processing as
> well as the complexity of the new sparse DAX regions can mostly be
> tested through cxl_test.  This includes management of sparse regions and
> DAX devices on those regions; the management of extent device lifetimes;
> and the processing of DCD events.
> 
> The only missing functionality from this test is actual interrupt
> processing.
> 
> Mock memory devices can easily mock DC information and manage fake
> extent data.
> 
> Define mock_dc_region information within the mock memory data.  Add
> sysfs entries on the mock device to inject and delete extents.
> 
> The inject format is <start>:<length>:<tag>:<more_flag>
> The delete format is <start>:<length>
> 
> Directly call the event irq callback to simulate irqs to process the
> test extents.
> 
> Add DC mailbox commands to the CEL and implement those commands.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Superficial review only.

Looks fine to me but I've been reviewing too long today to be at all sure
I'd spot if it was wrong in a subtle way.  So no tag for now.

> +static void dc_delete_extent(struct device *dev, unsigned long long start,
> +			     unsigned long long length)
> +{
> +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> +	unsigned long long end = start + length;
> +	struct cxl_extent_data *ext;
> +	unsigned long index;
> +
> +	dev_dbg(dev, "Deleting extent at %#llx len:%#llx\n", start, length);
> +
> +	guard(mutex)(&mdata->ext_lock);
> +	xa_for_each(&mdata->dc_extents, index, ext) {
> +		u64 extent_end = ext->dpa_start + ext->length;
> +
> +		/*
> +		 * Any extent which 'touches' the released delete range will be
> +		 * removed.
> +		 */
> +		if ((start <= ext->dpa_start && ext->dpa_start < end) ||
> +		    (start <= extent_end && extent_end < end)) {
Really trivial but no {} for single line statement

> +			xa_erase(&mdata->dc_extents, ext->dpa_start);
> +		}
> +	}
> +
> +	/*
> +	 * If the extent was accepted let it be for the host to drop
> +	 * later.
> +	 */
> +}

> @@ -1703,14 +2146,261 @@ static ssize_t sanitize_timeout_store(struct device *dev,
>  
>  	return count;
>  }
> -
Noise.

>  static DEVICE_ATTR_RW(sanitize_timeout);
>  


