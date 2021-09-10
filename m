Return-Path: <nvdimm+bounces-1244-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87BEC4068CD
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 10:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 854B01C0FCF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 08:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB602FB6;
	Fri, 10 Sep 2021 08:58:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880C2FAE
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 08:58:53 +0000 (UTC)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5V9R0WLQz67x48;
	Fri, 10 Sep 2021 16:56:43 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 10:58:51 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 09:58:50 +0100
Date: Fri, 10 Sep 2021 09:58:48 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 09/21] cxl/mbox: Introduce the mbox_send operation
Message-ID: <20210910095848.0000687b@Huawei.com>
In-Reply-To: <163116434098.2460985.9004760022659400540.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116434098.2460985.9004760022659400540.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Wed, 8 Sep 2021 22:12:21 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for implementing a unit test backend transport for ioctl
> operations, and making the mailbox available to the cxl/pmem
> infrastructure, move the existing PCI specific portion of mailbox handling
> to an "mbox_send" operation.
> 
> With this split all the PCI-specific transport details are comprehended
> by a single operation and the rest of the mailbox infrastructure is
> 'struct cxl_mem' and 'struct cxl_memdev' generic.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Looks good.  Not sure why I didn't give a provisional tag for this one
in v4 given the trivial nature of my only review comment.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/cxlmem.h |   42 ++++++++++++++++++++++++++++
>  drivers/cxl/pci.c    |   76 ++++++++++++++------------------------------------
>  2 files changed, 63 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index c6fce966084a..9be5e26c5b48 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -66,6 +66,45 @@ struct cxl_memdev *
>  devm_cxl_add_memdev(struct cxl_mem *cxlm,
>  		    const struct cdevm_file_operations *cdevm_fops);
>  
> +/**
> + * struct cxl_mbox_cmd - A command to be submitted to hardware.
> + * @opcode: (input) The command set and command submitted to hardware.
> + * @payload_in: (input) Pointer to the input payload.
> + * @payload_out: (output) Pointer to the output payload. Must be allocated by
> + *		 the caller.
> + * @size_in: (input) Number of bytes to load from @payload_in.
> + * @size_out: (input) Max number of bytes loaded into @payload_out.
> + *            (output) Number of bytes generated by the device. For fixed size
> + *            outputs commands this is always expected to be deterministic. For
> + *            variable sized output commands, it tells the exact number of bytes
> + *            written.
> + * @return_code: (output) Error code returned from hardware.
> + *
> + * This is the primary mechanism used to send commands to the hardware.
> + * All the fields except @payload_* correspond exactly to the fields described in
> + * Command Register section of the CXL 2.0 8.2.8.4.5. @payload_in and
> + * @payload_out are written to, and read from the Command Payload Registers
> + * defined in CXL 2.0 8.2.8.4.8.
> + */
> +struct cxl_mbox_cmd {
> +	u16 opcode;
> +	void *payload_in;
> +	void *payload_out;
> +	size_t size_in;
> +	size_t size_out;
> +	u16 return_code;
> +#define CXL_MBOX_SUCCESS 0
> +};
> +
> +/*
> + * CXL 2.0 - Memory capacity multiplier
> + * See Section 8.2.9.5
> + *
> + * Volatile, Persistent, and Partition capacities are specified to be in
> + * multiples of 256MB - define a multiplier to convert to/from bytes.
> + */
> +#define CXL_CAPACITY_MULTIPLIER SZ_256M
> +
>  /**
>   * struct cxl_mem - A CXL memory device
>   * @dev: The device associated with this CXL device.
> @@ -88,6 +127,7 @@ devm_cxl_add_memdev(struct cxl_mem *cxlm,
>   * @active_persistent_bytes: sum of hard + soft persistent
>   * @next_volatile_bytes: volatile capacity change pending device reset
>   * @next_persistent_bytes: persistent capacity change pending device reset
> + * @mbox_send: @dev specific transport for transmitting mailbox commands
>   *
>   * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
>   * details on capacity parameters.
> @@ -115,5 +155,7 @@ struct cxl_mem {
>  	u64 active_persistent_bytes;
>  	u64 next_volatile_bytes;
>  	u64 next_persistent_bytes;
> +
> +	int (*mbox_send)(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd);
>  };
>  #endif /* __CXL_MEM_H__ */
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8077d907e7d3..e2f27671c6b2 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -64,45 +64,6 @@ enum opcode {
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  
> -/*
> - * CXL 2.0 - Memory capacity multiplier
> - * See Section 8.2.9.5
> - *
> - * Volatile, Persistent, and Partition capacities are specified to be in
> - * multiples of 256MB - define a multiplier to convert to/from bytes.
> - */
> -#define CXL_CAPACITY_MULTIPLIER SZ_256M
> -
> -/**
> - * struct mbox_cmd - A command to be submitted to hardware.
> - * @opcode: (input) The command set and command submitted to hardware.
> - * @payload_in: (input) Pointer to the input payload.
> - * @payload_out: (output) Pointer to the output payload. Must be allocated by
> - *		 the caller.
> - * @size_in: (input) Number of bytes to load from @payload_in.
> - * @size_out: (input) Max number of bytes loaded into @payload_out.
> - *            (output) Number of bytes generated by the device. For fixed size
> - *            outputs commands this is always expected to be deterministic. For
> - *            variable sized output commands, it tells the exact number of bytes
> - *            written.
> - * @return_code: (output) Error code returned from hardware.
> - *
> - * This is the primary mechanism used to send commands to the hardware.
> - * All the fields except @payload_* correspond exactly to the fields described in
> - * Command Register section of the CXL 2.0 8.2.8.4.5. @payload_in and
> - * @payload_out are written to, and read from the Command Payload Registers
> - * defined in CXL 2.0 8.2.8.4.8.
> - */
> -struct mbox_cmd {
> -	u16 opcode;
> -	void *payload_in;
> -	void *payload_out;
> -	size_t size_in;
> -	size_t size_out;
> -	u16 return_code;
> -#define CXL_MBOX_SUCCESS 0
> -};
> -
>  static DECLARE_RWSEM(cxl_memdev_rwsem);
>  static struct dentry *cxl_debugfs;
>  static bool cxl_raw_allow_all;
> @@ -266,7 +227,7 @@ static bool cxl_is_security_command(u16 opcode)
>  }
>  
>  static void cxl_mem_mbox_timeout(struct cxl_mem *cxlm,
> -				 struct mbox_cmd *mbox_cmd)
> +				 struct cxl_mbox_cmd *mbox_cmd)
>  {
>  	struct device *dev = cxlm->dev;
>  
> @@ -297,7 +258,7 @@ static void cxl_mem_mbox_timeout(struct cxl_mem *cxlm,
>   * mailbox.
>   */
>  static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
> -				   struct mbox_cmd *mbox_cmd)
> +				   struct cxl_mbox_cmd *mbox_cmd)
>  {
>  	void __iomem *payload = cxlm->regs.mbox + CXLDEV_MBOX_PAYLOAD_OFFSET;
>  	struct device *dev = cxlm->dev;
> @@ -472,6 +433,20 @@ static void cxl_mem_mbox_put(struct cxl_mem *cxlm)
>  	mutex_unlock(&cxlm->mbox_mutex);
>  }
>  
> +static int cxl_pci_mbox_send(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> +{
> +	int rc;
> +
> +	rc = cxl_mem_mbox_get(cxlm);
> +	if (rc)
> +		return rc;
> +
> +	rc = __cxl_mem_mbox_send_cmd(cxlm, cmd);
> +	cxl_mem_mbox_put(cxlm);
> +
> +	return rc;
> +}
> +
>  /**
>   * handle_mailbox_cmd_from_user() - Dispatch a mailbox command for userspace.
>   * @cxlm: The CXL memory device to communicate with.
> @@ -503,7 +478,7 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
>  					s32 *size_out, u32 *retval)
>  {
>  	struct device *dev = cxlm->dev;
> -	struct mbox_cmd mbox_cmd = {
> +	struct cxl_mbox_cmd mbox_cmd = {
>  		.opcode = cmd->opcode,
>  		.size_in = cmd->info.size_in,
>  		.size_out = cmd->info.size_out,
> @@ -525,10 +500,6 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
>  		}
>  	}
>  
> -	rc = cxl_mem_mbox_get(cxlm);
> -	if (rc)
> -		goto out;
> -
>  	dev_dbg(dev,
>  		"Submitting %s command for user\n"
>  		"\topcode: %x\n"
> @@ -539,8 +510,7 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
>  	dev_WARN_ONCE(dev, cmd->info.id == CXL_MEM_COMMAND_ID_RAW,
>  		      "raw command path used\n");
>  
> -	rc = __cxl_mem_mbox_send_cmd(cxlm, &mbox_cmd);
> -	cxl_mem_mbox_put(cxlm);
> +	rc = cxlm->mbox_send(cxlm, &mbox_cmd);
>  	if (rc)
>  		goto out;
>  
> @@ -874,7 +844,7 @@ static int cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm, u16 opcode,
>  				 void *out, size_t out_size)
>  {
>  	const struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
> -	struct mbox_cmd mbox_cmd = {
> +	struct cxl_mbox_cmd mbox_cmd = {
>  		.opcode = opcode,
>  		.payload_in = in,
>  		.size_in = in_size,
> @@ -886,12 +856,7 @@ static int cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm, u16 opcode,
>  	if (out_size > cxlm->payload_size)
>  		return -E2BIG;
>  
> -	rc = cxl_mem_mbox_get(cxlm);
> -	if (rc)
> -		return rc;
> -
> -	rc = __cxl_mem_mbox_send_cmd(cxlm, &mbox_cmd);
> -	cxl_mem_mbox_put(cxlm);
> +	rc = cxlm->mbox_send(cxlm, &mbox_cmd);
>  	if (rc)
>  		return rc;
>  
> @@ -913,6 +878,7 @@ static int cxl_mem_setup_mailbox(struct cxl_mem *cxlm)
>  {
>  	const int cap = readl(cxlm->regs.mbox + CXLDEV_MBOX_CAPS_OFFSET);
>  
> +	cxlm->mbox_send = cxl_pci_mbox_send;
>  	cxlm->payload_size =
>  		1 << FIELD_GET(CXLDEV_MBOX_CAP_PAYLOAD_SIZE_MASK, cap);
>  
> 


