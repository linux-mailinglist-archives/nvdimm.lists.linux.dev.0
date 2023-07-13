Return-Path: <nvdimm+bounces-6350-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC6D751806
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jul 2023 07:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 299931C212A8
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jul 2023 05:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0FB53AA;
	Thu, 13 Jul 2023 05:25:33 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7553A4
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 05:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689225931; x=1720761931;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PqMtmngtRcubSkXM9hoe5DDxR3B47yx0wzaPIxBHvLI=;
  b=hXZmT6xXpUab9KPVJh3IiAT/7pBQgBAYOP6c4r8Gl+0YMZ4r1rSrw5l4
   UUo06Ve0cre+S3f4z0Hy/g3jEtW+2eKxfAjIYe7HxToIqaXLLMimz4zGf
   xBuAEvJ6FdjSufwprPWONewfC/EG+0BSrmYfVsBWCOZfQD6QJBRRV5ul4
   20uLXekIbz3cY2VJwTIwBNg6gV4d3EjbZtnPuYNzkkDI1QDtLXrqSZj/W
   qmnc814iU7CGLpQn9SBZuVmK0RyeozM6F0KEY+lq0O+mnUc5qhX6m0bgV
   8jVUTOK+958zYzsN0hNPQ+d5S83xaCA5JkNPwbR1YBPUicIkXJ68DxYra
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="355006662"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="355006662"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 22:25:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="968470497"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="968470497"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.210.253])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 22:25:30 -0700
Date: Wed, 12 Jul 2023 22:25:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org
Subject: Re: [RESEND v2] ACPI: NFIT: limit string attribute write
Message-ID: <ZK+KxTWNQDm+mDhj@aschofie-mobl2>
References: <20230712115753.20688-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712115753.20688-1-ben.dooks@codethink.co.uk>

On Wed, Jul 12, 2023 at 12:57:53PM +0100, Ben Dooks wrote:
> If we're writing what could be an arbitrary sized string into an attribute
> we should probably use sysfs_emit() just to be safe. Most of the other
> attriubtes are some sort of integer so unlikely to be an issue so not
> altered at this time.

Hi Ben,

Documentation/process/submitting-patches.rst says:
"Don't add "RESEND" when you are submitting a modified version of your
patch or patch series - "RESEND" only applies to resubmission of a
patch or patch series which have not been modified in any way from the
previous submission."

I see maybe you are going to go back and use sysfs_emit in all the
_show functions. I'd suggest either justify it as either a) or b),
Both are more explicit than 'just to be safe'

a) following the recommendations of Documentation/filesystems/sysfs.rst
which says to only use sysfs_emit in show() functions.

b) explain that you are doing it because sprintf does not know the
PAGE_SIZE maximum of the temporary buffer used for outputting sysfs
content requests and it's possible to overrun the buffer length.

I vote for doing 'em all!

Alison


> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> v2:
>   - use sysfs_emit() instead of snprintf.
> ---
>  drivers/acpi/nfit/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 9213b426b125..59c354137627 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1579,7 +1579,7 @@ static ssize_t id_show(struct device *dev,
>  {
>  	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
>  
> -	return sprintf(buf, "%s\n", nfit_mem->id);
> +	return sysfs_emit(buf, "%s\n", nfit_mem->id);
>  }
>  static DEVICE_ATTR_RO(id);
>  
> -- 
> 2.40.1
> 
> 

