Return-Path: <nvdimm+bounces-1246-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 726E0406928
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 11:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id BCB9D3E106D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 09:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DC72FB3;
	Fri, 10 Sep 2021 09:33:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E23FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 09:33:53 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5Vxp5n9Mz686wq;
	Fri, 10 Sep 2021 17:31:42 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 10 Sep 2021 11:33:50 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 10:33:50 +0100
Date: Fri, 10 Sep 2021 10:33:48 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 14/21] cxl/mbox: Add exclusive kernel command support
Message-ID: <20210910103348.00005b5c@Huawei.com>
In-Reply-To: <163116436926.2460985.1268688593156766623.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116436926.2460985.1268688593156766623.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.123.213]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 8 Sep 2021 22:12:49 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

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
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Link: https://lore.kernel.org/r/162982123298.1124374.22718002900700392.stgit@dwillia2-desk3.amr.corp.intel.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

In the ideal world I'd like to have seen this as a noop patch going from devm
to non devm for cleanup followed by new stuff.  meh, the world isn't ideal
and all that sort of nice stuff takes time!

Whilst I'm not that keen on the exact form of the code in probe() it will
be easier to read when not a diff so if you prefer to keep it as you have
it I won't object - it just took a little more careful reading than I'd like.

Thanks,

Jonathan


> ---
>  drivers/cxl/core/mbox.c   |    5 +++++
>  drivers/cxl/core/memdev.c |   31 +++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h      |    4 ++++
>  drivers/cxl/pmem.c        |   43 ++++++++++++++++++++++++++++++++-----------
>  4 files changed, 72 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 422999740649..82e79da195fa 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -221,6 +221,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
>   *  * %-EINVAL	- Reserved fields or invalid values were used.
>   *  * %-ENOMEM	- Input or output buffer wasn't sized properly.
>   *  * %-EPERM	- Attempted to use a protected command.
> + *  * %-EBUSY	- Kernel has claimed exclusive access to this opcode
>   *
>   * The result of this command is a fully validated command in @out_cmd that is
>   * safe to send to the hardware.
> @@ -296,6 +297,10 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
>  	if (!test_bit(info->id, cxlm->enabled_cmds))
>  		return -ENOTTY;
>  
> +	/* Check that the command is not claimed for exclusive kernel use */
> +	if (test_bit(info->id, cxlm->exclusive_cmds))
> +		return -EBUSY;
> +
>  	/* Check the input buffer is the expected size */
>  	if (info->size_in >= 0 && info->size_in != send_cmd->in.size)
>  		return -ENOMEM;
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index df2ba87238c2..d9ade5b92330 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -134,6 +134,37 @@ static const struct device_type cxl_memdev_type = {
>  	.groups = cxl_memdev_attribute_groups,
>  };
>  
> +/**
> + * set_exclusive_cxl_commands() - atomically disable user cxl commands
> + * @cxlm: cxl_mem instance to modify
> + * @cmds: bitmap of commands to mark exclusive
> + *
> + * Flush the ioctl path and disable future execution of commands with
> + * the command ids set in @cmds.

It's not obvious this function is doing that 'flush', Perhaps consider rewording?

> + */
> +void set_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds)
> +{
> +	down_write(&cxl_memdev_rwsem);
> +	bitmap_or(cxlm->exclusive_cmds, cxlm->exclusive_cmds, cmds,
> +		  CXL_MEM_COMMAND_ID_MAX);
> +	up_write(&cxl_memdev_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(set_exclusive_cxl_commands);
> +
> +/**
> + * clear_exclusive_cxl_commands() - atomically enable user cxl commands
> + * @cxlm: cxl_mem instance to modify
> + * @cmds: bitmap of commands to mark available for userspace
> + */
> +void clear_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds)
> +{
> +	down_write(&cxl_memdev_rwsem);
> +	bitmap_andnot(cxlm->exclusive_cmds, cxlm->exclusive_cmds, cmds,
> +		      CXL_MEM_COMMAND_ID_MAX);
> +	up_write(&cxl_memdev_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(clear_exclusive_cxl_commands);
> +
>  static void cxl_memdev_shutdown(struct device *dev)
>  {
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 16201b7d82d2..468b7b8be207 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -101,6 +101,7 @@ struct cxl_mbox_cmd {
>   * @mbox_mutex: Mutex to synchronize mailbox access.
>   * @firmware_version: Firmware version for the memory device.
>   * @enabled_cmds: Hardware commands found enabled in CEL.
> + * @exclusive_cmds: Commands that are kernel-internal only
>   * @pmem_range: Active Persistent memory capacity configuration
>   * @ram_range: Active Volatile memory capacity configuration
>   * @total_bytes: sum of all possible capacities
> @@ -127,6 +128,7 @@ struct cxl_mem {
>  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
>  	char firmware_version[0x10];
>  	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
> +	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
>  
>  	struct range pmem_range;
>  	struct range ram_range;
> @@ -200,4 +202,6 @@ int cxl_mem_identify(struct cxl_mem *cxlm);
>  int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm);
>  int cxl_mem_create_range_info(struct cxl_mem *cxlm);
>  struct cxl_mem *cxl_mem_create(struct device *dev);
> +void set_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds);
> +void clear_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds);
>  #endif /* __CXL_MEM_H__ */
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 9652c3ee41e7..a972af7a6e0b 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -16,10 +16,7 @@
>   */
>  static struct workqueue_struct *cxl_pmem_wq;
>  
> -static void unregister_nvdimm(void *nvdimm)
> -{
> -	nvdimm_delete(nvdimm);
> -}
> +static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
>  
>  static int match_nvdimm_bridge(struct device *dev, const void *data)
>  {
> @@ -36,12 +33,25 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
>  	return to_cxl_nvdimm_bridge(dev);
>  }
>  
> +static void cxl_nvdimm_remove(struct device *dev)
> +{
> +	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> +	struct nvdimm *nvdimm = dev_get_drvdata(dev);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_mem *cxlm = cxlmd->cxlm;

Given cxlmd isn't used, perhaps combine the two lines above?

> +
> +	nvdimm_delete(nvdimm);
> +	clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
> +}
> +
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_mem *cxlm = cxlmd->cxlm;

Again, clxmd not used so could save a line of code
without loosing anything (unless it get used in a later patch of
course!)

>  	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct nvdimm *nvdimm = NULL;
>  	unsigned long flags = 0;
> -	struct nvdimm *nvdimm;
>  	int rc = -ENXIO;
>  
>  	cxl_nvb = cxl_find_nvdimm_bridge();
> @@ -50,25 +60,32 @@ static int cxl_nvdimm_probe(struct device *dev)
>  
>  	device_lock(&cxl_nvb->dev);
>  	if (!cxl_nvb->nvdimm_bus)
> -		goto out;
> +		goto out_unlock;
> +
> +	set_exclusive_cxl_commands(cxlm, exclusive_cmds);
>  
>  	set_bit(NDD_LABELING, &flags);
> +	rc = -ENOMEM;

Hmm. Setting rc to an error value even in the good path is a bit
unusual.  I'd just add the few lines to set rc = -ENXIO only in the error
path above and
rc = -ENOMEM here only if nvdimm_create fails.

What you have strikes me as a bit too clever :)

>  	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
>  			       NULL);
> -	if (!nvdimm)
> -		goto out;
> +	dev_set_drvdata(dev, nvdimm);
>  
> -	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
> -out:
> +out_unlock:
>  	device_unlock(&cxl_nvb->dev);
>  	put_device(&cxl_nvb->dev);
>  
> -	return rc;
> +	if (!nvdimm) {

If you change the above as suggested this becomes a simple if (ret)

> +		clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
> +		return rc;

> +	}
> +
> +	return 0;
>  }
>  
>  static struct cxl_driver cxl_nvdimm_driver = {
>  	.name = "cxl_nvdimm",
>  	.probe = cxl_nvdimm_probe,
> +	.remove = cxl_nvdimm_remove,
>  	.id = CXL_DEVICE_NVDIMM,
>  };
>  
> @@ -194,6 +211,10 @@ static __init int cxl_pmem_init(void)
>  {
>  	int rc;
>  
> +	set_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_LSA, exclusive_cmds);
> +
>  	cxl_pmem_wq = alloc_ordered_workqueue("cxl_pmem", 0);
>  	if (!cxl_pmem_wq)
>  		return -ENXIO;
> 


