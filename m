Return-Path: <nvdimm+bounces-2709-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE95F4A5241
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 23:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 74FE23E0EC6
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 22:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8093FE5;
	Mon, 31 Jan 2022 22:21:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F2D2C82
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 22:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643667664; x=1675203664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xLvWi7iNzzHbAeE/HUpENMW6kzoJZd4Uqflerx8m0/E=;
  b=cWkKBQERPNRWMETNYnChJQ4rrrjxVRCbH8cffHOc6IJi4Qb1AMnFrl/S
   2pd3JFKoNA9qtzk0k8W87cdtbhyJns8Yu9GemGvcPGDXdRmLoqYqkZHq3
   bg7/htupTZ7xiXTf2zrEsfM8rf/8Fysf26ouhrN3KZ8Nu0qejundhrfC6
   L2JOWZE73u21FWmx2w9K7f9l1wjbag+1MMtJLYZA1s2AvSk95vuPE4r5V
   r2iZml22wa/KfKGonItvJsbn5rUyfqLklf4tE4IZlFlRFD0DWXAlWcvJl
   X6w5mcbsacPjh3N4r7gPBSFhKIAu7le6mY4UAcAdlcraEPLC8Lf9SHbcQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="333919092"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="333919092"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:21:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="619535111"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:21:03 -0800
Date: Mon, 31 Jan 2022 14:21:01 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 02/40] cxl/pci: Implement Interface Ready Timeout
Message-ID: <20220131222101.tckwbcxheuuorkiq@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298412919.3018233.12491722885382120190.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298412919.3018233.12491722885382120190.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:28:49, Dan Williams wrote:
> From: Ben Widawsky <ben.widawsky@intel.com>
> 
> The original driver implementation used the doorbell timeout for the
> Mailbox Interface Ready bit to piggy back off of, since the latter does
> not have a defined timeout. This functionality, introduced in commit
> 8adaf747c9f0 ("cxl/mem: Find device capabilities"), needs improvement as
> the recent "Add Mailbox Ready Time" ECN timeout indicates that the
> mailbox ready time can be significantly longer that 2 seconds.
> 
> While the specification limits the maximum timeout to 256s, the cxl_pci
> driver gives up on the mailbox after 60s. This value corresponds with
> important timeout values already present in the kernel. A module
> parameter is provided as an emergency override and represents the
> default Linux policy for all devices.
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> [djbw: add modparam, drop check_device_status()]
> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/pci.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8dc91fd3396a..ed8de9eac970 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -1,7 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
>  #include <linux/io-64-nonatomic-lo-hi.h>
> +#include <linux/moduleparam.h>
>  #include <linux/module.h>
> +#include <linux/delay.h>
>  #include <linux/sizes.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
> @@ -35,6 +37,20 @@
>  /* CXL 2.0 - 8.2.8.4 */
>  #define CXL_MAILBOX_TIMEOUT_MS (2 * HZ)
>  
> +/*
> + * CXL 2.0 ECN "Add Mailbox Ready Time" defines a capability field to
> + * dictate how long to wait for the mailbox to become ready. The new
> + * field allows the device to tell software the amount of time to wait
> + * before mailbox ready. This field per the spec theoretically allows
> + * for up to 255 seconds. 255 seconds is unreasonably long, its longer
> + * than the maximum SATA port link recovery wait. Default to 60 seconds
> + * until someone builds a CXL device that needs more time in practice.
> + */
> +static unsigned short mbox_ready_timeout = 60;
> +module_param(mbox_ready_timeout, ushort, 0600);

Any reason not to make it 0644?

> +MODULE_PARM_DESC(mbox_ready_timeout,
> +		 "seconds to wait for mailbox ready status");
> +
>  static int cxl_pci_mbox_wait_for_doorbell(struct cxl_dev_state *cxlds)
>  {
>  	const unsigned long start = jiffies;
> @@ -281,6 +297,25 @@ static int cxl_pci_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *c
>  static int cxl_pci_setup_mailbox(struct cxl_dev_state *cxlds)
>  {
>  	const int cap = readl(cxlds->regs.mbox + CXLDEV_MBOX_CAPS_OFFSET);
> +	unsigned long timeout;
> +	u64 md_status;
> +
> +	timeout = jiffies + mbox_ready_timeout * HZ;
> +	do {
> +		md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
> +		if (md_status & CXLMDEV_MBOX_IF_READY)
> +			break;
> +		if (msleep_interruptible(100))
> +			break;
> +	} while (!time_after(jiffies, timeout));

Just pointing out the [probably] obvious. If the user specifies a zero second
timeout, the code will still wait 100ms.

> +
> +	if (!(md_status & CXLMDEV_MBOX_IF_READY)) {
> +		dev_err(cxlds->dev,
> +			"timeout awaiting mailbox ready, device state:%s%s\n",
> +			md_status & CXLMDEV_DEV_FATAL ? " fatal" : "",
> +			md_status & CXLMDEV_FW_HALT ? " firmware-halt" : "");
> +		return -EIO;
> +	}
>  
>  	cxlds->mbox_send = cxl_pci_mbox_send;
>  	cxlds->payload_size =
> 

