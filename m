Return-Path: <nvdimm+bounces-1221-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D377D405AB6
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 18:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id D8BB43E102C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Sep 2021 16:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD2D3FFA;
	Thu,  9 Sep 2021 16:22:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178EB3FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 16:22:24 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="218977688"
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="218977688"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:20:08 -0700
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="539695060"
Received: from ado-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.129.108])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:20:06 -0700
Date: Thu, 9 Sep 2021 09:20:05 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	vishal.l.verma@intel.com, nvdimm@lists.linux.dev,
	alison.schofield@intel.com, Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v4 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
Message-ID: <20210909162005.ybqjh5xrbhg43wtr@intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>

On 21-09-08 22:12:15, Dan Williams wrote:
> Commit 0b9159d0ff21 ("cxl/pci: Store memory capacity values") missed
> updating the kernel-doc for 'struct cxl_mem' leading to the following
> warnings:
> 
> ./scripts/kernel-doc -v drivers/cxl/cxlmem.h 2>&1 | grep warn
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'total_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'volatile_only_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'persistent_only_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'partition_align_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_volatile_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_persistent_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_volatile_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_persistent_bytes' not described in 'cxl_mem'
> 
> Also, it is redundant to describe those same parameters in the
> kernel-doc for cxl_mem_get_partition_info(). Given the only user of that
> routine updates the values in @cxlm, just do that implicitly internal to
> the helper.
> 
> Cc: Ira Weiny <ira.weiny@intel.com>
> Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/cxlmem.h |   15 +++++++++++++--
>  drivers/cxl/pci.c    |   35 +++++++++++------------------------
>  2 files changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index d5334df83fb2..c6fce966084a 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -78,8 +78,19 @@ devm_cxl_add_memdev(struct cxl_mem *cxlm,
>   * @mbox_mutex: Mutex to synchronize mailbox access.
>   * @firmware_version: Firmware version for the memory device.
>   * @enabled_cmds: Hardware commands found enabled in CEL.
> - * @pmem_range: Persistent memory capacity information.
> - * @ram_range: Volatile memory capacity information.
> + * @pmem_range: Active Persistent memory capacity configuration
> + * @ram_range: Active Volatile memory capacity configuration
> + * @total_bytes: sum of all possible capacities
> + * @volatile_only_bytes: hard volatile capacity
> + * @persistent_only_bytes: hard persistent capacity
> + * @partition_align_bytes: soft setting for configurable capacity
> + * @active_volatile_bytes: sum of hard + soft volatile
> + * @active_persistent_bytes: sum of hard + soft persistent

Looking at this now, probably makes sense to create some helper macros or inline
functions to calculate these as needed, rather than storing them in the
structure.

> + * @next_volatile_bytes: volatile capacity change pending device reset
> + * @next_persistent_bytes: persistent capacity change pending device reset
> + *
> + * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
> + * details on capacity parameters.
>   */
>  struct cxl_mem {
>  	struct device *dev;
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index c1e1d12e24b6..8077d907e7d3 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -1262,11 +1262,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
>  
>  /**
>   * cxl_mem_get_partition_info - Get partition info
> - * @cxlm: The device to act on
> - * @active_volatile_bytes: returned active volatile capacity
> - * @active_persistent_bytes: returned active persistent capacity
> - * @next_volatile_bytes: return next volatile capacity
> - * @next_persistent_bytes: return next persistent capacity
> + * @cxlm: cxl_mem instance to update partition info
>   *
>   * Retrieve the current partition info for the device specified.  If not 0, the
>   * 'next' values are pending and take affect on next cold reset.
> @@ -1275,11 +1271,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
>   *
>   * See CXL @8.2.9.5.2.1 Get Partition Info
>   */
> -static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
> -				      u64 *active_volatile_bytes,
> -				      u64 *active_persistent_bytes,
> -				      u64 *next_volatile_bytes,
> -				      u64 *next_persistent_bytes)
> +static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
>  {
>  	struct cxl_mbox_get_partition_info {
>  		__le64 active_volatile_cap;
> @@ -1294,15 +1286,14 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
>  	if (rc)
>  		return rc;
>  
> -	*active_volatile_bytes = le64_to_cpu(pi.active_volatile_cap);
> -	*active_persistent_bytes = le64_to_cpu(pi.active_persistent_cap);
> -	*next_volatile_bytes = le64_to_cpu(pi.next_volatile_cap);
> -	*next_persistent_bytes = le64_to_cpu(pi.next_volatile_cap);
> -
> -	*active_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
> -	*active_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
> -	*next_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
> -	*next_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
> +	cxlm->active_volatile_bytes =
> +		le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> +	cxlm->active_persistent_bytes =
> +		le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
> +	cxlm->next_volatile_bytes =
> +		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> +	cxlm->next_persistent_bytes =
> +		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;

Personally, I prefer the more functional style implementation. I guess if you
wanted to make the change, my preference would be to kill
cxl_mem_get_partition_info() entirely. Up to you though...

>  
>  	return 0;
>  }
> @@ -1443,11 +1434,7 @@ static int cxl_mem_create_range_info(struct cxl_mem *cxlm)
>  		return 0;
>  	}
>  
> -	rc = cxl_mem_get_partition_info(cxlm,
> -					&cxlm->active_volatile_bytes,
> -					&cxlm->active_persistent_bytes,
> -					&cxlm->next_volatile_bytes,
> -					&cxlm->next_persistent_bytes);
> +	rc = cxl_mem_get_partition_info(cxlm);
>  	if (rc < 0) {
>  		dev_err(cxlm->dev, "Failed to query partition information\n");
>  		return rc;
> 

