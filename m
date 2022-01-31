Return-Path: <nvdimm+bounces-2689-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BBA4A4BDC
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 17:23:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id C260C3E0F0C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 16:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2ED2CA8;
	Mon, 31 Jan 2022 16:23:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C942CA5
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 16:23:00 +0000 (UTC)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnYD320HGz67Pf9;
	Tue,  1 Feb 2022 00:19:15 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 17:22:57 +0100
Received: from localhost (10.47.73.212) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 31 Jan
 2022 16:22:57 +0000
Date: Mon, 31 Jan 2022 16:22:51 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, kernel test robot <lkp@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 20/40] cxl/pci: Rename pci.h to cxlpci.h
Message-ID: <20220131162251.000023fe@Huawei.com>
In-Reply-To: <164298422510.3018233.14693126572756675563.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164298422510.3018233.14693126572756675563.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.73.212]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Sun, 23 Jan 2022 16:30:25 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Similar to the mem.h rename, if the core wants to reuse definitions from
> drivers/cxl/pci.h it is unable to use <pci.h> as that collides with
> archs that have an arch/$arch/include/asm/pci.h, like MIPS.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Does this perhaps want a fixes tag?

Otherwise, fair enough I guess.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  drivers/cxl/acpi.c      |    2 +-
>  drivers/cxl/core/regs.c |    2 +-
>  drivers/cxl/cxlpci.h    |    1 +
>  drivers/cxl/pci.c       |    2 +-
>  4 files changed, 4 insertions(+), 3 deletions(-)
>  rename drivers/cxl/{pci.h => cxlpci.h} (99%)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index e596dc375267..3485ae9d3baf 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -6,8 +6,8 @@
>  #include <linux/kernel.h>
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
> +#include "cxlpci.h"
>  #include "cxl.h"
> -#include "pci.h"
>  
>  /* Encode defined in CXL 2.0 8.2.5.12.7 HDM Decoder Control Register */
>  #define CFMWS_INTERLEAVE_WAYS(x)	(1 << (x)->interleave_ways)
> diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
> index 12a6cbddf110..65d7f5880671 100644
> --- a/drivers/cxl/core/regs.c
> +++ b/drivers/cxl/core/regs.c
> @@ -5,7 +5,7 @@
>  #include <linux/slab.h>
>  #include <linux/pci.h>
>  #include <cxlmem.h>
> -#include <pci.h>
> +#include <cxlpci.h>
>  
>  /**
>   * DOC: cxl registers
> diff --git a/drivers/cxl/pci.h b/drivers/cxl/cxlpci.h
> similarity index 99%
> rename from drivers/cxl/pci.h
> rename to drivers/cxl/cxlpci.h
> index 0623bb85f30a..eb00f597a157 100644
> --- a/drivers/cxl/pci.h
> +++ b/drivers/cxl/cxlpci.h
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
>  #ifndef __CXL_PCI_H__
>  #define __CXL_PCI_H__
> +#include "cxl.h"
>  
>  #define CXL_MEMORY_PROGIF	0x10
>  
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index bdfeb92ed028..c29d50660c21 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -10,7 +10,7 @@
>  #include <linux/pci.h>
>  #include <linux/io.h>
>  #include "cxlmem.h"
> -#include "pci.h"
> +#include "cxlpci.h"
>  #include "cxl.h"
>  
>  /**
> 


