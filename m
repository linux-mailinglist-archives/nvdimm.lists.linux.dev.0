Return-Path: <nvdimm+bounces-1223-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF54405AF8
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 18:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 96E061C0F7F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 16:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A133FFA;
	Thu,  9 Sep 2021 16:35:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EDD3FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 16:35:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="220871320"
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="220871320"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:34:59 -0700
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="606904699"
Received: from ado-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.129.108])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:34:58 -0700
Date: Thu, 9 Sep 2021 09:34:57 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	vishal.l.verma@intel.com, nvdimm@lists.linux.dev,
	alison.schofield@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH v4 10/21] cxl/pci: Drop idr.h
Message-ID: <20210909163457.mir5khmdf26awtzc@intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116434668.2460985.12264757586266849616.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163116434668.2460985.12264757586266849616.stgit@dwillia2-desk3.amr.corp.intel.com>

On 21-09-08 22:12:26, Dan Williams wrote:
> Commit 3d135db51024 ("cxl/core: Move memdev management to core") left
> this straggling include for cxl_memdev setup. Clean it up.
> 
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

> ---
>  drivers/cxl/pci.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e2f27671c6b2..9d8050fdd69c 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -8,7 +8,6 @@
>  #include <linux/mutex.h>
>  #include <linux/list.h>
>  #include <linux/cdev.h>
> -#include <linux/idr.h>
>  #include <linux/pci.h>
>  #include <linux/io.h>
>  #include <linux/io-64-nonatomic-lo-hi.h>
> 

