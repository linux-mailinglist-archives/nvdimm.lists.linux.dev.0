Return-Path: <nvdimm+bounces-1241-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E884068AE
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 10:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 8E3443E1088
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 08:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3D82FB3;
	Fri, 10 Sep 2021 08:43:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6EF3FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 08:43:14 +0000 (UTC)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5Tqc1FwHz67X6t;
	Fri, 10 Sep 2021 16:41:16 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 10 Sep 2021 10:43:12 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 09:43:11 +0100
Date: Fri, 10 Sep 2021 09:43:10 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 07/21] cxl/pci: Make 'struct cxl_mem' device type
 generic
Message-ID: <20210910094310.00005cb0@Huawei.com>
In-Reply-To: <163116432973.2460985.7553504957932024222.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116432973.2460985.7553504957932024222.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Wed, 8 Sep 2021 22:12:09 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for adding a unit test provider of a cxl_memdev, convert
> the 'struct cxl_mem' driver context to carry a generic device rather
> than a pci device.
> 
> Note, some dev_dbg() lines needed extra reformatting per clang-format.
> 
> This conversion also allows the cxl_mem_create() and
> devm_cxl_add_memdev() calling conventions to be simplified. The "host"
> for a cxl_memdev, must be the same device for the driver that allocated
> @cxlm.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/memdev.c |    7 ++--
>  drivers/cxl/cxlmem.h      |    6 ++--
>  drivers/cxl/pci.c         |   75 +++++++++++++++++++++------------------------
>  3 files changed, 41 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index a9c317e32010..331ef7d6c598 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -149,7 +149,6 @@ static void cxl_memdev_unregister(void *_cxlmd)
>  static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
>  					   const struct file_operations *fops)
>  {
> -	struct pci_dev *pdev = cxlm->pdev;
>  	struct cxl_memdev *cxlmd;
>  	struct device *dev;
>  	struct cdev *cdev;
> @@ -166,7 +165,7 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
>  
>  	dev = &cxlmd->dev;
>  	device_initialize(dev);
> -	dev->parent = &pdev->dev;
> +	dev->parent = cxlm->dev;
>  	dev->bus = &cxl_bus_type;
>  	dev->devt = MKDEV(cxl_mem_major, cxlmd->id);
>  	dev->type = &cxl_memdev_type;
> @@ -182,7 +181,7 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
>  }
>  
>  struct cxl_memdev *
> -devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
> +devm_cxl_add_memdev(struct cxl_mem *cxlm,
>  		    const struct cdevm_file_operations *cdevm_fops)
>  {
>  	struct cxl_memdev *cxlmd;
> @@ -210,7 +209,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
>  	if (rc)
>  		goto err;
>  
> -	rc = devm_add_action_or_reset(host, cxl_memdev_unregister, cxlmd);
> +	rc = devm_add_action_or_reset(cxlm->dev, cxl_memdev_unregister, cxlmd);
>  	if (rc)
>  		return ERR_PTR(rc);
>  	return cxlmd;
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 6c0b1e2ea97c..d5334df83fb2 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -63,12 +63,12 @@ static inline struct cxl_memdev *to_cxl_memdev(struct device *dev)
>  }
>  
>  struct cxl_memdev *
> -devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
> +devm_cxl_add_memdev(struct cxl_mem *cxlm,
>  		    const struct cdevm_file_operations *cdevm_fops);
>  
>  /**
>   * struct cxl_mem - A CXL memory device
> - * @pdev: The PCI device associated with this CXL device.
> + * @dev: The device associated with this CXL device.
>   * @cxlmd: Logical memory device chardev / interface
>   * @regs: Parsed register blocks
>   * @payload_size: Size of space for payload
> @@ -82,7 +82,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
>   * @ram_range: Volatile memory capacity information.
>   */
>  struct cxl_mem {
> -	struct pci_dev *pdev;
> +	struct device *dev;
>  	struct cxl_memdev *cxlmd;
>  
>  	struct cxl_regs regs;
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8e45aa07d662..c1e1d12e24b6 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -250,7 +250,7 @@ static int cxl_mem_wait_for_doorbell(struct cxl_mem *cxlm)
>  		cpu_relax();
>  	}
>  
> -	dev_dbg(&cxlm->pdev->dev, "Doorbell wait took %dms",
> +	dev_dbg(cxlm->dev, "Doorbell wait took %dms",
>  		jiffies_to_msecs(end) - jiffies_to_msecs(start));
>  	return 0;
>  }
> @@ -268,7 +268,7 @@ static bool cxl_is_security_command(u16 opcode)
>  static void cxl_mem_mbox_timeout(struct cxl_mem *cxlm,
>  				 struct mbox_cmd *mbox_cmd)
>  {
> -	struct device *dev = &cxlm->pdev->dev;
> +	struct device *dev = cxlm->dev;
>  
>  	dev_dbg(dev, "Mailbox command (opcode: %#x size: %zub) timed out\n",
>  		mbox_cmd->opcode, mbox_cmd->size_in);
> @@ -300,6 +300,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
>  				   struct mbox_cmd *mbox_cmd)
>  {
>  	void __iomem *payload = cxlm->regs.mbox + CXLDEV_MBOX_PAYLOAD_OFFSET;
> +	struct device *dev = cxlm->dev;
>  	u64 cmd_reg, status_reg;
>  	size_t out_len;
>  	int rc;
> @@ -325,8 +326,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
>  
>  	/* #1 */
>  	if (cxl_doorbell_busy(cxlm)) {
> -		dev_err_ratelimited(&cxlm->pdev->dev,
> -				    "Mailbox re-busy after acquiring\n");
> +		dev_err_ratelimited(dev, "Mailbox re-busy after acquiring\n");
>  		return -EBUSY;
>  	}
>  
> @@ -345,7 +345,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
>  	writeq(cmd_reg, cxlm->regs.mbox + CXLDEV_MBOX_CMD_OFFSET);
>  
>  	/* #4 */
> -	dev_dbg(&cxlm->pdev->dev, "Sending command\n");
> +	dev_dbg(dev, "Sending command\n");
>  	writel(CXLDEV_MBOX_CTRL_DOORBELL,
>  	       cxlm->regs.mbox + CXLDEV_MBOX_CTRL_OFFSET);
>  
> @@ -362,7 +362,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
>  		FIELD_GET(CXLDEV_MBOX_STATUS_RET_CODE_MASK, status_reg);
>  
>  	if (mbox_cmd->return_code != 0) {
> -		dev_dbg(&cxlm->pdev->dev, "Mailbox operation had an error\n");
> +		dev_dbg(dev, "Mailbox operation had an error\n");
>  		return 0;
>  	}
>  
> @@ -399,7 +399,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
>   */
>  static int cxl_mem_mbox_get(struct cxl_mem *cxlm)
>  {
> -	struct device *dev = &cxlm->pdev->dev;
> +	struct device *dev = cxlm->dev;
>  	u64 md_status;
>  	int rc;
>  
> @@ -502,7 +502,7 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
>  					u64 in_payload, u64 out_payload,
>  					s32 *size_out, u32 *retval)
>  {
> -	struct device *dev = &cxlm->pdev->dev;
> +	struct device *dev = cxlm->dev;
>  	struct mbox_cmd mbox_cmd = {
>  		.opcode = cmd->opcode,
>  		.size_in = cmd->info.size_in,
> @@ -925,20 +925,19 @@ static int cxl_mem_setup_mailbox(struct cxl_mem *cxlm)
>  	 */
>  	cxlm->payload_size = min_t(size_t, cxlm->payload_size, SZ_1M);
>  	if (cxlm->payload_size < 256) {
> -		dev_err(&cxlm->pdev->dev, "Mailbox is too small (%zub)",
> +		dev_err(cxlm->dev, "Mailbox is too small (%zub)",
>  			cxlm->payload_size);
>  		return -ENXIO;
>  	}
>  
> -	dev_dbg(&cxlm->pdev->dev, "Mailbox payload sized %zu",
> +	dev_dbg(cxlm->dev, "Mailbox payload sized %zu",
>  		cxlm->payload_size);
>  
>  	return 0;
>  }
>  
> -static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
> +static struct cxl_mem *cxl_mem_create(struct device *dev)
>  {
> -	struct device *dev = &pdev->dev;
>  	struct cxl_mem *cxlm;
>  
>  	cxlm = devm_kzalloc(dev, sizeof(*cxlm), GFP_KERNEL);
> @@ -948,7 +947,7 @@ static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
>  	}
>  
>  	mutex_init(&cxlm->mbox_mutex);
> -	cxlm->pdev = pdev;
> +	cxlm->dev = dev;
>  	cxlm->enabled_cmds =
>  		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
>  				   sizeof(unsigned long),
> @@ -964,9 +963,9 @@ static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
>  static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
>  					  u8 bar, u64 offset)
>  {
> -	struct pci_dev *pdev = cxlm->pdev;
> -	struct device *dev = &pdev->dev;
>  	void __iomem *addr;
> +	struct device *dev = cxlm->dev;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	/* Basic sanity check that BAR is big enough */
>  	if (pci_resource_len(pdev, bar) < offset) {
> @@ -989,7 +988,7 @@ static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
>  
>  static void cxl_mem_unmap_regblock(struct cxl_mem *cxlm, void __iomem *base)
>  {
> -	pci_iounmap(cxlm->pdev, base);
> +	pci_iounmap(to_pci_dev(cxlm->dev), base);
>  }
>  
>  static int cxl_mem_dvsec(struct pci_dev *pdev, int dvsec)
> @@ -1018,10 +1017,9 @@ static int cxl_mem_dvsec(struct pci_dev *pdev, int dvsec)
>  static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
>  			  struct cxl_register_map *map)
>  {
> -	struct pci_dev *pdev = cxlm->pdev;
> -	struct device *dev = &pdev->dev;
>  	struct cxl_component_reg_map *comp_map;
>  	struct cxl_device_reg_map *dev_map;
> +	struct device *dev = cxlm->dev;
>  
>  	switch (map->reg_type) {
>  	case CXL_REGLOC_RBI_COMPONENT:
> @@ -1057,8 +1055,8 @@ static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
>  
>  static int cxl_map_regs(struct cxl_mem *cxlm, struct cxl_register_map *map)
>  {
> -	struct pci_dev *pdev = cxlm->pdev;
> -	struct device *dev = &pdev->dev;
> +	struct device *dev = cxlm->dev;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	switch (map->reg_type) {
>  	case CXL_REGLOC_RBI_COMPONENT:
> @@ -1096,13 +1094,12 @@ static void cxl_decode_register_block(u32 reg_lo, u32 reg_hi,
>   */
>  static int cxl_mem_setup_regs(struct cxl_mem *cxlm)
>  {
> -	struct pci_dev *pdev = cxlm->pdev;
> -	struct device *dev = &pdev->dev;
> -	u32 regloc_size, regblocks;
>  	void __iomem *base;
> -	int regloc, i, n_maps;
> +	u32 regloc_size, regblocks;
> +	int regloc, i, n_maps, ret = 0;
> +	struct device *dev = cxlm->dev;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct cxl_register_map *map, maps[CXL_REGLOC_RBI_TYPES];
> -	int ret = 0;
>  
>  	regloc = cxl_mem_dvsec(pdev, PCI_DVSEC_ID_CXL_REGLOC_DVSEC_ID);
>  	if (!regloc) {
> @@ -1226,7 +1223,7 @@ static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
>  		struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
>  
>  		if (!cmd) {
> -			dev_dbg(&cxlm->pdev->dev,
> +			dev_dbg(cxlm->dev,
>  				"Opcode 0x%04x unsupported by driver", opcode);
>  			continue;
>  		}
> @@ -1323,7 +1320,7 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
>  static int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm)
>  {
>  	struct cxl_mbox_get_supported_logs *gsl;
> -	struct device *dev = &cxlm->pdev->dev;
> +	struct device *dev = cxlm->dev;
>  	struct cxl_mem_command *cmd;
>  	int i, rc;
>  
> @@ -1418,15 +1415,14 @@ static int cxl_mem_identify(struct cxl_mem *cxlm)
>  	cxlm->partition_align_bytes = le64_to_cpu(id.partition_align);
>  	cxlm->partition_align_bytes *= CXL_CAPACITY_MULTIPLIER;
>  
> -	dev_dbg(&cxlm->pdev->dev, "Identify Memory Device\n"
> +	dev_dbg(cxlm->dev,
> +		"Identify Memory Device\n"
>  		"     total_bytes = %#llx\n"
>  		"     volatile_only_bytes = %#llx\n"
>  		"     persistent_only_bytes = %#llx\n"
>  		"     partition_align_bytes = %#llx\n",
> -			cxlm->total_bytes,
> -			cxlm->volatile_only_bytes,
> -			cxlm->persistent_only_bytes,
> -			cxlm->partition_align_bytes);
> +		cxlm->total_bytes, cxlm->volatile_only_bytes,
> +		cxlm->persistent_only_bytes, cxlm->partition_align_bytes);
>  
>  	cxlm->lsa_size = le32_to_cpu(id.lsa_size);
>  	memcpy(cxlm->firmware_version, id.fw_revision, sizeof(id.fw_revision));
> @@ -1453,19 +1449,18 @@ static int cxl_mem_create_range_info(struct cxl_mem *cxlm)
>  					&cxlm->next_volatile_bytes,
>  					&cxlm->next_persistent_bytes);
>  	if (rc < 0) {
> -		dev_err(&cxlm->pdev->dev, "Failed to query partition information\n");
> +		dev_err(cxlm->dev, "Failed to query partition information\n");
>  		return rc;
>  	}
>  
> -	dev_dbg(&cxlm->pdev->dev, "Get Partition Info\n"
> +	dev_dbg(cxlm->dev,
> +		"Get Partition Info\n"
>  		"     active_volatile_bytes = %#llx\n"
>  		"     active_persistent_bytes = %#llx\n"
>  		"     next_volatile_bytes = %#llx\n"
>  		"     next_persistent_bytes = %#llx\n",
> -			cxlm->active_volatile_bytes,
> -			cxlm->active_persistent_bytes,
> -			cxlm->next_volatile_bytes,
> -			cxlm->next_persistent_bytes);
> +		cxlm->active_volatile_bytes, cxlm->active_persistent_bytes,
> +		cxlm->next_volatile_bytes, cxlm->next_persistent_bytes);
>  
>  	cxlm->ram_range.start = 0;
>  	cxlm->ram_range.end = cxlm->active_volatile_bytes - 1;
> @@ -1487,7 +1482,7 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> -	cxlm = cxl_mem_create(pdev);
> +	cxlm = cxl_mem_create(&pdev->dev);
>  	if (IS_ERR(cxlm))
>  		return PTR_ERR(cxlm);
>  
> @@ -1511,7 +1506,7 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> -	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlm, &cxl_memdev_fops);
> +	cxlmd = devm_cxl_add_memdev(cxlm, &cxl_memdev_fops);
>  	if (IS_ERR(cxlmd))
>  		return PTR_ERR(cxlmd);
>  
> 


