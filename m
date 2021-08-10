Return-Path: <nvdimm+bounces-811-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45253E8567
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 23:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 9FD021C0B3E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 21:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6573B2FB8;
	Tue, 10 Aug 2021 21:35:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D7217F
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 21:35:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="237015055"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="237015055"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 14:35:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="515994293"
Received: from luisdsan-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.128.20])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 14:35:01 -0700
Date: Tue, 10 Aug 2021 14:34:59 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Jonathan.Cameron@huawei.com, vishal.l.verma@intel.com,
	alison.schofield@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH 17/23] cxl/mbox: Add exclusive kernel command support
Message-ID: <20210810213459.5zpvfrvbo2rztwmc@intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854815819.1980150.14391324052281496748.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162854815819.1980150.14391324052281496748.stgit@dwillia2-desk3.amr.corp.intel.com>

On 21-08-09 15:29:18, Dan Williams wrote:
> The CXL_PMEM driver expects exclusive control of the label storage area
> space. Similar to the LIBNVDIMM expectation that the label storage area
> is only writable from userspace when the corresponding memory device is
> not active in any region, the expectation is the native CXL_PCI UAPI
> path is disabled while the cxl_nvdimm for a given cxl_memdev device is
> active in LIBNVDIMM.
> 
> Add the ability to toggle the availability of a given command for the
> UAPI path. Use that new capability to shutdown changes to partitions and
> the label storage area while the cxl_nvdimm device is actively proxying
> commands for LIBNVDIMM.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core/mbox.c |    5 +++++
>  drivers/cxl/cxlmem.h    |    2 ++
>  drivers/cxl/pmem.c      |   35 +++++++++++++++++++++++++++++------
>  3 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 23100231e246..f26962d7cb65 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -409,6 +409,11 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
>  		}
>  	}
>  
> +	if (test_bit(cmd->info.id, cxlm->exclusive_cmds)) {
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +

This breaks our current definition for cxl_raw_allow_all. All the test machinery
for whether a command can be submitted was supposed to happen in
cxl_validate_cmd_from_user(). Various versions of the original patches made
cxl_mem_raw_command_allowed() grow more intelligence (ie. more than just the
opcode). I think this check belongs there with more intelligence.

I don't love the EBUSY because it already had a meaning for concurrent use of
the mailbox, but I can't think of a better errno.

>  	dev_dbg(dev,
>  		"Submitting %s command for user\n"
>  		"\topcode: %x\n"
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index df4f3636a999..f6cfe84a064c 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -102,6 +102,7 @@ struct cxl_mbox_cmd {
>   * @mbox_mutex: Mutex to synchronize mailbox access.
>   * @firmware_version: Firmware version for the memory device.
>   * @enabled_cmds: Hardware commands found enabled in CEL.
> + * @exclusive_cmds: Commands that are kernel-internal only
>   * @pmem_range: Persistent memory capacity information.
>   * @ram_range: Volatile memory capacity information.
>   * @mbox_send: @dev specific transport for transmitting mailbox commands
> @@ -117,6 +118,7 @@ struct cxl_mem {
>  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
>  	char firmware_version[0x10];
>  	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
> +	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
>  
>  	struct range pmem_range;
>  	struct range ram_range;
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 9652c3ee41e7..11410df77444 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -16,9 +16,23 @@
>   */
>  static struct workqueue_struct *cxl_pmem_wq;
>  
> -static void unregister_nvdimm(void *nvdimm)
> +static void unregister_nvdimm(void *_cxl_nvd)
>  {
> -	nvdimm_delete(nvdimm);
> +	struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_mem *cxlm = cxlmd->cxlm;
> +	struct device *dev = &cxl_nvd->dev;
> +	struct nvdimm *nvdimm;
> +
> +	nvdimm = dev_get_drvdata(dev);
> +	if (nvdimm)
> +		nvdimm_delete(nvdimm);
> +
> +	mutex_lock(&cxlm->mbox_mutex);
> +	clear_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, cxlm->exclusive_cmds);
> +	clear_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, cxlm->exclusive_cmds);
> +	clear_bit(CXL_MEM_COMMAND_ID_SET_LSA, cxlm->exclusive_cmds);
> +	mutex_unlock(&cxlm->mbox_mutex);
>  }
>  
>  static int match_nvdimm_bridge(struct device *dev, const void *data)
> @@ -39,6 +53,8 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_mem *cxlm = cxlmd->cxlm;
>  	struct cxl_nvdimm_bridge *cxl_nvb;
>  	unsigned long flags = 0;
>  	struct nvdimm *nvdimm;
> @@ -52,17 +68,24 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	if (!cxl_nvb->nvdimm_bus)
>  		goto out;
>  
> +	mutex_lock(&cxlm->mbox_mutex);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, cxlm->exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, cxlm->exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_LSA, cxlm->exclusive_cmds);
> +	mutex_unlock(&cxlm->mbox_mutex);
> +

What's the concurrency this lock is trying to protect against?

>  	set_bit(NDD_LABELING, &flags);
>  	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
>  			       NULL);
> -	if (!nvdimm)
> -		goto out;
> -
> -	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
> +	dev_set_drvdata(dev, nvdimm);
> +	rc = devm_add_action_or_reset(dev, unregister_nvdimm, cxl_nvd);
>  out:
>  	device_unlock(&cxl_nvb->dev);
>  	put_device(&cxl_nvb->dev);
>  
> +	if (!nvdimm && rc == 0)
> +		rc = -ENOMEM;
> +
>  	return rc;
>  }
>  
> 

