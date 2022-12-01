Return-Path: <nvdimm+bounces-5382-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A304D63FA8F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Dec 2022 23:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B851280C7C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Dec 2022 22:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F77310798;
	Thu,  1 Dec 2022 22:30:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD7AD53C
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669933804; x=1701469804;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OdAdHfZ73Vvc7oFOd9hHRaEFIXNYMPRhuTK4KYP9RJc=;
  b=Hwtij2J4kGPsFjG5YTvd0MjypuxEUdHF3Abf60SkWgExyyALQG2VgGj+
   1iE0t622KgVVTCIg76hdXeWrxwINC6CWVbbEwEVyO1R3YMBVlYBTK0Qn0
   4JQmnAZu/X1ippxjLrNHErT0GPVuc2YYFBJRR0YU2zkYm9d9Oc+0Mvtfl
   2PQmT+AxvcI/YS99lfgPcp5Md4mvKEGq9/zAEneINMeRzcVLcXf7YBraY
   gUubYZgOILeRKu39MFNzjlf+Aeuk/OqSh+J8CQeG+OHePfGbupTqlFEfG
   Eua8RjatthThs5e65hsNO/EvaZX4DJPqZmHYI157Zo7BrRS5CzDuK9Auk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="377971084"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="377971084"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:30:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="646932259"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="646932259"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.66.184]) ([10.212.66.184])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:30:03 -0800
Message-ID: <a08e121f-db70-fbaf-3cc4-62322f70ffa0@intel.com>
Date: Thu, 1 Dec 2022 15:30:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH 2/5] cxl/region: Fix missing probe failure
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: stable@vger.kernel.org, Jonathan.Cameron@huawei.com,
 nvdimm@lists.linux.dev, dave@stgolabs.net
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/1/2022 3:03 PM, Dan Williams wrote:
> cxl_region_probe() allows for regions not in the 'commit' state to be
> enabled. Fail probe when the region is not committed otherwise the
> kernel may indicate that an address range is active when none of the
> decoders are active.
> 
> Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/region.c |    3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f9ae5ad284ff..1bc2ebefa2a5 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
>   	 */
>   	up_read(&cxl_region_rwsem);
>   
> +	if (rc)
> +		return rc;
> +
>   	switch (cxlr->mode) {
>   	case CXL_DECODER_PMEM:
>   		return devm_cxl_add_pmem_region(cxlr);
> 

