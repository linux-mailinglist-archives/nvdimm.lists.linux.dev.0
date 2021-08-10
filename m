Return-Path: <nvdimm+bounces-813-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E213E85C1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 23:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 482453E148E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Aug 2021 21:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4882C2FB8;
	Tue, 10 Aug 2021 21:57:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF25717F
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 21:57:38 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="202171170"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="202171170"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 14:57:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="675428108"
Received: from luisdsan-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.128.20])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 14:57:37 -0700
Date: Tue, 10 Aug 2021 14:57:34 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Jonathan.Cameron@huawei.com, vishal.l.verma@intel.com,
	alison.schofield@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH 20/23] tools/testing/cxl: Introduce a mocked-up CXL port
 hierarchy
Message-ID: <20210810215734.qb4ik65uangytvbm@intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854817382.1980150.11827836438841211401.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162854817382.1980150.11827836438841211401.stgit@dwillia2-desk3.amr.corp.intel.com>

On 21-08-09 15:29:33, Dan Williams wrote:
> Create an environment for CXL plumbing unit tests. Especially when it
> comes to an algorithm for HDM Decoder (Host-managed Device Memory
> Decoder) programming, the availability of an in-kernel-tree emulation
> environment for CXL configuration complexity and corner cases speeds
> development and deters regressions.
> 
> The approach taken mirrors what was done for tools/testing/nvdimm/. I.e.
> an external module, cxl_test.ko built out of the tools/testing/cxl/
> directory, provides mock implementations of kernel APIs and kernel
> objects to simulate a real world device hierarchy.
> 
> One feedback for the tools/testing/nvdimm/ proposal was "why not do this
> in QEMU?". In fact, the CXL development community has developed a QEMU
> model for CXL [1]. However, there are a few blocking issues that keep
> QEMU from being a tight fit for topology + provisioning unit tests:
> 
> 1/ The QEMU community has yet to show interest in merging any of this
>    support that has had patches on the list since November 2020. So,
>    testing CXL to date involves building custom QEMU with out-of-tree
>    patches.
> 
> 2/ CXL mechanisms like cross-host-bridge interleave do not have a clear
>    path to be emulated by QEMU without major infrastructure work. This
>    is easier to achieve with the alloc_mock_res() approach taken in this
>    patch to shortcut-define emulated system physical address ranges with
>    interleave behavior.

I just want to say that this was discussed on the mailing list, and I think
there is a reasonable plan (albeit a lot of work). However, #1 is the true
blocker IMHO.

> 
> The QEMU enabling has been critical to get the driver off the ground,
> and may still move forward, but it does not address the ongoing needs of
> a regression testing environment and test driven development.
> 

The really nice thing QEMU provides over this (assuming one implemented
interleaving properly), is it does allow a programmatic (via commandline) way to
test an infinite set of topologies, configurations, and hotplug scenarios. I
therefore disagree here in that I think QEMU is a better theoretical vehicle for
regression testing and test driven development, however, my unfinished branch
with no upstream interest in sight is problematic at best for longer term.

I didn't look super closely, but I have one comment/question below. Otherwise,
LGTM.

> This patch adds an ACPI CXL Platform definition with emulated CXL
> multi-ported host-bridges. A follow on patch adds emulated memory
> expander devices.
> 
> Link: https://lore.kernel.org/r/20210202005948.241655-1-ben.widawsky@intel.com [1]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c            |   52 +++-
>  drivers/cxl/cxl.h             |    8 +
>  tools/testing/cxl/Kbuild      |   27 ++
>  tools/testing/cxl/mock_acpi.c |  105 ++++++++
>  tools/testing/cxl/test/Kbuild |    6 
>  tools/testing/cxl/test/cxl.c  |  508 +++++++++++++++++++++++++++++++++++++++++
>  tools/testing/cxl/test/mock.c |  155 +++++++++++++
>  tools/testing/cxl/test/mock.h |   26 ++
>  8 files changed, 866 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/cxl/Kbuild
>  create mode 100644 tools/testing/cxl/mock_acpi.c
>  create mode 100644 tools/testing/cxl/test/Kbuild
>  create mode 100644 tools/testing/cxl/test/cxl.c
>  create mode 100644 tools/testing/cxl/test/mock.c
>  create mode 100644 tools/testing/cxl/test/mock.h
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 8ae89273f58e..e0cd9df85ca5 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -182,15 +182,7 @@ static resource_size_t get_chbcr(struct acpi_cedt_chbs *chbs)
>  	return IS_ERR(chbs) ? CXL_RESOURCE_NONE : chbs->base;
>  }
>  
> -struct cxl_walk_context {
> -	struct device *dev;
> -	struct pci_bus *root;
> -	struct cxl_port *port;
> -	int error;
> -	int count;
> -};
> -
> -static int match_add_root_ports(struct pci_dev *pdev, void *data)
> +__weak int match_add_root_ports(struct pci_dev *pdev, void *data)
>  {
>  	struct cxl_walk_context *ctx = data;
>  	struct pci_bus *root_bus = ctx->root;
> @@ -214,6 +206,8 @@ static int match_add_root_ports(struct pci_dev *pdev, void *data)
>  	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
>  	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
>  	if (rc) {
> +		dev_err(dev, "failed to add dport: %s (%d)\n",
> +			dev_name(&pdev->dev), rc);
>  		ctx->error = rc;
>  		return rc;
>  	}
> @@ -239,12 +233,15 @@ static struct cxl_dport *find_dport_by_dev(struct cxl_port *port, struct device
>  	return NULL;
>  }
>  
> -static struct acpi_device *to_cxl_host_bridge(struct device *dev)
> +__weak struct acpi_device *to_cxl_host_bridge(struct device *host,
> +					      struct device *dev)
>  {
>  	struct acpi_device *adev = to_acpi_device(dev);
>  
> -	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
> +	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0) {
> +		dev_dbg(host, "found host bridge %s\n", dev_name(&adev->dev));
>  		return adev;
> +	}
>  	return NULL;
>  }
>  
> @@ -254,14 +251,14 @@ static struct acpi_device *to_cxl_host_bridge(struct device *dev)
>   */
>  static int add_host_bridge_uport(struct device *match, void *arg)
>  {
> -	struct acpi_device *bridge = to_cxl_host_bridge(match);
> +	struct cxl_port *port;
> +	struct cxl_dport *dport;
> +	struct cxl_decoder *cxld;
> +	struct cxl_walk_context ctx;
> +	struct acpi_pci_root *pci_root;
>  	struct cxl_port *root_port = arg;
>  	struct device *host = root_port->dev.parent;
> -	struct acpi_pci_root *pci_root;
> -	struct cxl_walk_context ctx;
> -	struct cxl_decoder *cxld;
> -	struct cxl_dport *dport;
> -	struct cxl_port *port;
> +	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
>  
>  	if (!bridge)
>  		return 0;
> @@ -319,7 +316,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  	struct acpi_cedt_chbs *chbs;
>  	struct cxl_port *root_port = arg;
>  	struct device *host = root_port->dev.parent;
> -	struct acpi_device *bridge = to_cxl_host_bridge(match);
> +	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
>  
>  	if (!bridge)
>  		return 0;
> @@ -371,6 +368,17 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
>  	return 1;
>  }
>  
> +static u32 cedt_instance(struct platform_device *pdev)
> +{
> +	const bool *native_acpi0017 = acpi_device_get_match_data(&pdev->dev);
> +
> +	if (native_acpi0017 && *native_acpi0017)
> +		return 0;
> +
> +	/* for cxl_test request a non-canonical instance */
> +	return U32_MAX;
> +}
> +
>  static int cxl_acpi_probe(struct platform_device *pdev)
>  {
>  	int rc;
> @@ -384,7 +392,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  		return PTR_ERR(root_port);
>  	dev_dbg(host, "add: %s\n", dev_name(&root_port->dev));
>  
> -	status = acpi_get_table(ACPI_SIG_CEDT, 0, &acpi_cedt);
> +	status = acpi_get_table(ACPI_SIG_CEDT, cedt_instance(pdev), &acpi_cedt);
>  	if (ACPI_FAILURE(status))
>  		return -ENXIO;
>  
> @@ -415,9 +423,11 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static bool native_acpi0017 = true;
> +
>  static const struct acpi_device_id cxl_acpi_ids[] = {
> -	{ "ACPI0017", 0 },
> -	{ "", 0 },
> +	{ "ACPI0017", (unsigned long) &native_acpi0017 },
> +	{ },
>  };
>  MODULE_DEVICE_TABLE(acpi, cxl_acpi_ids);
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 1b2e816e061e..09c81cf8b800 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -226,6 +226,14 @@ struct cxl_nvdimm {
>  	struct nvdimm *nvdimm;
>  };
>  
> +struct cxl_walk_context {
> +	struct device *dev;
> +	struct pci_bus *root;
> +	struct cxl_port *port;
> +	int error;
> +	int count;
> +};
> +
>  /**
>   * struct cxl_port - logical collection of upstream port devices and
>   *		     downstream port devices to construct a CXL memory
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> new file mode 100644
> index 000000000000..6ea0c7df36f0
> --- /dev/null
> +++ b/tools/testing/cxl/Kbuild
> @@ -0,0 +1,27 @@
> +# SPDX-License-Identifier: GPL-2.0
> +ldflags-y += --wrap=is_acpi_device_node
> +ldflags-y += --wrap=acpi_get_table
> +ldflags-y += --wrap=acpi_put_table
> +ldflags-y += --wrap=acpi_evaluate_integer
> +ldflags-y += --wrap=acpi_pci_find_root
> +ldflags-y += --wrap=pci_walk_bus
> +
> +DRIVERS := ../../../drivers
> +CXL_SRC := $(DRIVERS)/cxl
> +CXL_CORE_SRC := $(DRIVERS)/cxl/core
> +ccflags-y := -I$(srctree)/drivers/cxl/
> +
> +obj-$(CONFIG_CXL_ACPI) += cxl_acpi.o
> +
> +cxl_acpi-y := $(CXL_SRC)/acpi.o
> +cxl_acpi-y += mock_acpi.o
> +
> +obj-$(CONFIG_CXL_BUS) += cxl_core.o
> +
> +cxl_core-y := $(CXL_CORE_SRC)/bus.o
> +cxl_core-y += $(CXL_CORE_SRC)/pmem.o
> +cxl_core-y += $(CXL_CORE_SRC)/regs.o
> +cxl_core-y += $(CXL_CORE_SRC)/memdev.o
> +cxl_core-y += $(CXL_CORE_SRC)/mbox.o
> +
> +obj-m += test/
> diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
> new file mode 100644
> index 000000000000..256bdf9e1ce8
> --- /dev/null
> +++ b/tools/testing/cxl/mock_acpi.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
> +
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/acpi.h>
> +#include <linux/pci.h>
> +#include <cxl.h>
> +#include "test/mock.h"
> +
> +struct acpi_device *to_cxl_host_bridge(struct device *host, struct device *dev)
> +{
> +	int index;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	struct acpi_device *adev = NULL;
> +
> +	if (ops && ops->is_mock_bridge(dev)) {
> +		adev = ACPI_COMPANION(dev);
> +		goto out;
> +	}

Here, and below ops->is_mock_port()... I'm a bit confused why a mock driver
would ever attempt to do anything with real hardware. ie, why not

> +
> +	if (dev->bus == &platform_bus_type)
> +		goto out;
> +
> +	if (strcmp(acpi_device_hid(to_acpi_device(dev)), "ACPI0016") == 0) {
> +		adev = to_acpi_device(dev);
> +		dev_dbg(host, "found host bridge %s\n", dev_name(&adev->dev));
> +	}
> +out:
> +	put_cxl_mock_ops(index);
> +	return adev;
> +}
> +
> +static int match_add_root_port(struct pci_dev *pdev, void *data)
> +{
> +	struct cxl_walk_context *ctx = data;
> +	struct pci_bus *root_bus = ctx->root;
> +	struct cxl_port *port = ctx->port;
> +	int type = pci_pcie_type(pdev);
> +	struct device *dev = ctx->dev;
> +	u32 lnkcap, port_num;
> +	int rc;
> +
> +	if (pdev->bus != root_bus)
> +		return 0;
> +	if (!pci_is_pcie(pdev))
> +		return 0;
> +	if (type != PCI_EXP_TYPE_ROOT_PORT)
> +		return 0;
> +	if (pci_read_config_dword(pdev, pci_pcie_cap(pdev) + PCI_EXP_LNKCAP,
> +				  &lnkcap) != PCIBIOS_SUCCESSFUL)
> +		return 0;
> +
> +	/* TODO walk DVSEC to find component register base */
> +	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
> +	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
> +	if (rc) {
> +		dev_err(dev, "failed to add dport: %s (%d)\n",
> +			dev_name(&pdev->dev), rc);
> +		ctx->error = rc;
> +		return rc;
> +	}
> +	ctx->count++;
> +
> +	dev_dbg(dev, "add dport%d: %s\n", port_num, dev_name(&pdev->dev));
> +
> +	return 0;
> +}
> +
> +static int mock_add_root_port(struct platform_device *pdev, void *data)
> +{
> +	struct cxl_walk_context *ctx = data;
> +	struct cxl_port *port = ctx->port;
> +	struct device *dev = ctx->dev;
> +	int rc;
> +
> +	rc = cxl_add_dport(port, &pdev->dev, pdev->id, CXL_RESOURCE_NONE);
> +	if (rc) {
> +		dev_err(dev, "failed to add dport: %s (%d)\n",
> +			dev_name(&pdev->dev), rc);
> +		ctx->error = rc;
> +		return rc;
> +	}
> +	ctx->count++;
> +
> +	dev_dbg(dev, "add dport%d: %s\n", pdev->id, dev_name(&pdev->dev));
> +
> +	return 0;
> +}
> +
> +int match_add_root_ports(struct pci_dev *dev, void *data)
> +{
> +	int index, rc;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	struct platform_device *pdev = (struct platform_device *) dev;
> +
> +	if (ops && ops->is_mock_port(pdev))
> +		rc = mock_add_root_port(pdev, data);
> +	else
> +		rc = match_add_root_port(dev, data);
> +
> +	put_cxl_mock_ops(index);
> +
> +	return rc;
> +}
> diff --git a/tools/testing/cxl/test/Kbuild b/tools/testing/cxl/test/Kbuild
> new file mode 100644
> index 000000000000..7de4ddecfd21
> --- /dev/null
> +++ b/tools/testing/cxl/test/Kbuild
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-m += cxl_test.o
> +obj-m += cxl_mock.o
> +
> +cxl_test-y := cxl.o
> +cxl_mock-y := mock.o
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> new file mode 100644
> index 000000000000..5213d6e23dde
> --- /dev/null
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -0,0 +1,508 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +// Copyright(c) 2021 Intel Corporation. All rights reserved.
> +
> +#include <linux/platform_device.h>
> +#include <linux/genalloc.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/acpi.h>
> +#include <linux/pci.h>
> +#include <linux/mm.h>
> +#include "mock.h"
> +
> +#define NR_CXL_HOST_BRIDGES 4
> +#define NR_CXL_ROOT_PORTS 2
> +
> +static struct platform_device *cxl_acpi;
> +static struct platform_device *cxl_host_bridge[NR_CXL_HOST_BRIDGES];
> +static struct platform_device
> +	*cxl_root_port[NR_CXL_HOST_BRIDGES * NR_CXL_ROOT_PORTS];
> +
> +static struct acpi_device acpi0017_mock;
> +static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES] = {
> +	[0] = {
> +		.handle = &host_bridge[0],
> +	},
> +	[1] = {
> +		.handle = &host_bridge[1],
> +	},
> +	[2] = {
> +		.handle = &host_bridge[2],
> +	},
> +	[3] = {
> +		.handle = &host_bridge[3],
> +	},
> +};
> +
> +static bool is_mock_adev(struct acpi_device *adev)
> +{
> +	int i;
> +
> +	if (adev == &acpi0017_mock)
> +		return true;
> +
> +	for (i = 0; i < ARRAY_SIZE(host_bridge); i++)
> +		if (adev == &host_bridge[i])
> +			return true;
> +
> +	return false;
> +}
> +
> +static struct {
> +	struct acpi_table_cedt cedt;
> +	struct acpi_cedt_chbs chbs[NR_CXL_HOST_BRIDGES];
> +	struct {
> +		struct acpi_cedt_cfmws cfmws;
> +		u32 target[1];
> +	} cfmws0;
> +	struct {
> +		struct acpi_cedt_cfmws cfmws;
> +		u32 target[4];
> +	} cfmws1;
> +	struct {
> +		struct acpi_cedt_cfmws cfmws;
> +		u32 target[1];
> +	} cfmws2;
> +	struct {
> +		struct acpi_cedt_cfmws cfmws;
> +		u32 target[4];
> +	} cfmws3;
> +} __packed mock_cedt = {
> +	.cedt = {
> +		.header = {
> +			.signature = "CEDT",
> +			.length = sizeof(mock_cedt),
> +			.revision = 1,
> +		},
> +	},
> +	.chbs[0] = {
> +		.header = {
> +			.type = ACPI_CEDT_TYPE_CHBS,
> +			.length = sizeof(mock_cedt.chbs[0]),
> +		},
> +		.uid = 0,
> +		.cxl_version = ACPI_CEDT_CHBS_VERSION_CXL20,
> +	},
> +	.chbs[1] = {
> +		.header = {
> +			.type = ACPI_CEDT_TYPE_CHBS,
> +			.length = sizeof(mock_cedt.chbs[0]),
> +		},
> +		.uid = 1,
> +		.cxl_version = ACPI_CEDT_CHBS_VERSION_CXL20,
> +	},
> +	.chbs[2] = {
> +		.header = {
> +			.type = ACPI_CEDT_TYPE_CHBS,
> +			.length = sizeof(mock_cedt.chbs[0]),
> +		},
> +		.uid = 2,
> +		.cxl_version = ACPI_CEDT_CHBS_VERSION_CXL20,
> +	},
> +	.chbs[3] = {
> +		.header = {
> +			.type = ACPI_CEDT_TYPE_CHBS,
> +			.length = sizeof(mock_cedt.chbs[0]),
> +		},
> +		.uid = 3,
> +		.cxl_version = ACPI_CEDT_CHBS_VERSION_CXL20,
> +	},
> +	.cfmws0 = {
> +		.cfmws = {
> +			.header = {
> +				.type = ACPI_CEDT_TYPE_CFMWS,
> +				.length = sizeof(mock_cedt.cfmws0),
> +			},
> +			.interleave_ways = 0,
> +			.granularity = 4,
> +			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
> +					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
> +			.qtg_id = 0,
> +		},
> +		.target = { 0 },
> +	},
> +	.cfmws1 = {
> +		.cfmws = {
> +			.header = {
> +				.type = ACPI_CEDT_TYPE_CFMWS,
> +				.length = sizeof(mock_cedt.cfmws1),
> +			},
> +			.interleave_ways = 2,
> +			.granularity = 4,
> +			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
> +					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
> +			.qtg_id = 1,
> +		},
> +		.target = { 0, 1, 2, 3 },
> +	},
> +	.cfmws2 = {
> +		.cfmws = {
> +			.header = {
> +				.type = ACPI_CEDT_TYPE_CFMWS,
> +				.length = sizeof(mock_cedt.cfmws2),
> +			},
> +			.interleave_ways = 0,
> +			.granularity = 4,
> +			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
> +					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
> +			.qtg_id = 2,
> +		},
> +		.target = { 0 },
> +	},
> +	.cfmws3 = {
> +		.cfmws = {
> +			.header = {
> +				.type = ACPI_CEDT_TYPE_CFMWS,
> +				.length = sizeof(mock_cedt.cfmws3),
> +			},
> +			.interleave_ways = 2,
> +			.granularity = 4,
> +			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
> +					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
> +			.qtg_id = 3,
> +		},
> +		.target = { 0, 1, 2, 3 },
> +	},
> +};
> +
> +struct cxl_mock_res {
> +	struct list_head list;
> +	struct range range;
> +};
> +
> +static LIST_HEAD(mock_res);
> +static DEFINE_MUTEX(mock_res_lock);
> +static struct gen_pool *cxl_mock_pool;
> +
> +static void free_mock_res(void)
> +{
> +	struct cxl_mock_res *res, *_res;
> +
> +	mutex_lock(&mock_res_lock);
> +	list_for_each_entry_safe(res, _res, &mock_res, list) {
> +		gen_pool_free(cxl_mock_pool, res->range.start,
> +			      range_len(&res->range));
> +		list_del(&res->list);
> +		kfree(res);
> +	}
> +	mutex_unlock(&mock_res_lock);
> +}
> +
> +static struct cxl_mock_res *alloc_mock_res(resource_size_t size)
> +{
> +	struct cxl_mock_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
> +	struct genpool_data_align data = {
> +		.align = SZ_256M,
> +	};
> +	unsigned long phys;
> +
> +	INIT_LIST_HEAD(&res->list);
> +	phys = gen_pool_alloc_algo(cxl_mock_pool, size,
> +				   gen_pool_first_fit_align, &data);
> +	if (!phys)
> +		return NULL;
> +
> +	res->range = (struct range) {
> +		.start = phys,
> +		.end = phys + size - 1,
> +	};
> +	mutex_lock(&mock_res_lock);
> +	list_add(&res->list, &mock_res);
> +	mutex_unlock(&mock_res_lock);
> +
> +	return res;
> +}
> +
> +static int populate_cedt(void)
> +{
> +	struct acpi_cedt_cfmws *cfmws[4] = {
> +		[0] = &mock_cedt.cfmws0.cfmws,
> +		[1] = &mock_cedt.cfmws1.cfmws,
> +		[2] = &mock_cedt.cfmws2.cfmws,
> +		[3] = &mock_cedt.cfmws3.cfmws,
> +	};
> +	struct cxl_mock_res *res;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(mock_cedt.chbs); i++) {
> +		struct acpi_cedt_chbs *chbs = &mock_cedt.chbs[i];
> +		resource_size_t size;
> +
> +		if (chbs->cxl_version == ACPI_CEDT_CHBS_VERSION_CXL20)
> +			size = ACPI_CEDT_CHBS_LENGTH_CXL20;
> +		else
> +			size = ACPI_CEDT_CHBS_LENGTH_CXL11;
> +
> +		res = alloc_mock_res(size);
> +		if (!res)
> +			return -ENOMEM;
> +		chbs->base = res->range.start;
> +		chbs->length = size;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(cfmws); i++) {
> +		struct acpi_cedt_cfmws *window = cfmws[i];
> +		int ways = 1 << window->interleave_ways;
> +
> +		res = alloc_mock_res(SZ_256M * ways);
> +		if (!res)
> +			return -ENOMEM;
> +		window->base_hpa = res->range.start;
> +		window->window_size = range_len(&res->range);
> +	}
> +
> +	return 0;
> +}
> +
> +static acpi_status mock_acpi_get_table(char *signature, u32 instance,
> +				       struct acpi_table_header **out_table)
> +{
> +	if (instance < U32_MAX || strcmp(signature, ACPI_SIG_CEDT) != 0)
> +		return acpi_get_table(signature, instance, out_table);
> +
> +	*out_table = (struct acpi_table_header *) &mock_cedt;
> +	return AE_OK;
> +}
> +
> +static void mock_acpi_put_table(struct acpi_table_header *table)
> +{
> +	if (table == (struct acpi_table_header *) &mock_cedt)
> +		return;
> +	acpi_put_table(table);
> +}
> +
> +static bool is_mock_bridge(struct device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_host_bridge); i++)
> +		if (dev == &cxl_host_bridge[i]->dev)
> +			return true;
> +
> +	return false;
> +}
> +
> +static int host_bridge_index(struct acpi_device *adev)
> +{
> +	return adev - host_bridge;
> +}
> +
> +static struct acpi_device *find_host_bridge(acpi_handle handle)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(host_bridge); i++)
> +		if (handle == host_bridge[i].handle)
> +			return &host_bridge[i];
> +	return NULL;
> +}
> +
> +static acpi_status
> +mock_acpi_evaluate_integer(acpi_handle handle, acpi_string pathname,
> +			   struct acpi_object_list *arguments,
> +			   unsigned long long *data)
> +{
> +	struct acpi_device *adev = find_host_bridge(handle);
> +
> +	if (!adev || strcmp(pathname, METHOD_NAME__UID) != 0)
> +		return acpi_evaluate_integer(handle, pathname, arguments, data);
> +
> +	*data = host_bridge_index(adev);
> +	return AE_OK;
> +}
> +
> +static struct pci_bus mock_pci_bus[NR_CXL_HOST_BRIDGES];
> +static struct acpi_pci_root mock_pci_root[NR_CXL_HOST_BRIDGES] = {
> +	[0] = {
> +		.bus = &mock_pci_bus[0],
> +	},
> +	[1] = {
> +		.bus = &mock_pci_bus[1],
> +	},
> +	[2] = {
> +		.bus = &mock_pci_bus[2],
> +	},
> +	[3] = {
> +		.bus = &mock_pci_bus[3],
> +	},
> +};
> +
> +static struct platform_device *mock_cxl_root_port(struct pci_bus *bus, int index)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(mock_pci_bus); i++)
> +		if (bus == &mock_pci_bus[i])
> +			return cxl_root_port[index + i * NR_CXL_ROOT_PORTS];
> +	return NULL;
> +}
> +
> +static bool is_mock_port(struct platform_device *pdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++)
> +		if (pdev == cxl_root_port[i])
> +			return true;
> +	return false;
> +}
> +
> +static bool is_mock_bus(struct pci_bus *bus)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(mock_pci_bus); i++)
> +		if (bus == &mock_pci_bus[i])
> +			return true;
> +	return false;
> +}
> +
> +static struct acpi_pci_root *mock_acpi_pci_find_root(acpi_handle handle)
> +{
> +	struct acpi_device *adev = find_host_bridge(handle);
> +
> +	if (!adev)
> +		return acpi_pci_find_root(handle);
> +	return &mock_pci_root[host_bridge_index(adev)];
> +}
> +
> +static struct cxl_mock_ops cxl_mock_ops = {
> +	.is_mock_adev = is_mock_adev,
> +	.is_mock_bridge = is_mock_bridge,
> +	.is_mock_bus = is_mock_bus,
> +	.is_mock_port = is_mock_port,
> +	.mock_port = mock_cxl_root_port,
> +	.acpi_get_table = mock_acpi_get_table,
> +	.acpi_put_table = mock_acpi_put_table,
> +	.acpi_evaluate_integer = mock_acpi_evaluate_integer,
> +	.acpi_pci_find_root = mock_acpi_pci_find_root,
> +	.list = LIST_HEAD_INIT(cxl_mock_ops.list),
> +};
> +
> +static void mock_companion(struct acpi_device *adev, struct device *dev)
> +{
> +	device_initialize(&adev->dev);
> +	fwnode_init(&adev->fwnode, NULL);
> +	dev->fwnode = &adev->fwnode;
> +	adev->fwnode.dev = dev;
> +}
> +
> +#ifndef SZ_64G
> +#define SZ_64G (SZ_32G * 2)
> +#endif
> +
> +#ifndef SZ_512G
> +#define SZ_512G (SZ_64G * 8)
> +#endif
> +
> +static __init int cxl_test_init(void)
> +{
> +	int rc, i;
> +
> +	register_cxl_mock_ops(&cxl_mock_ops);
> +
> +	cxl_mock_pool = gen_pool_create(ilog2(SZ_2M), NUMA_NO_NODE);
> +	if (!cxl_mock_pool) {
> +		rc = -ENOMEM;
> +		goto err_gen_pool_create;
> +	}
> +
> +	rc = gen_pool_add(cxl_mock_pool, SZ_512G, SZ_64G, NUMA_NO_NODE);
> +	if (rc)
> +		goto err_gen_pool_add;
> +
> +	rc = populate_cedt();
> +	if (rc)
> +		goto err_populate;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_host_bridge); i++) {
> +		struct acpi_device *adev = &host_bridge[i];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_host_bridge", i);
> +		if (!pdev)
> +			goto err_bridge;
> +
> +		mock_companion(adev, &pdev->dev);
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_bridge;
> +		}
> +		cxl_host_bridge[i] = pdev;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
> +		struct platform_device *bridge =
> +			cxl_host_bridge[i / NR_CXL_ROOT_PORTS];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_root_port", i);
> +		if (!pdev)
> +			goto err_port;
> +		pdev->dev.parent = &bridge->dev;
> +
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_port;
> +		}
> +		cxl_root_port[i] = pdev;
> +	}
> +
> +	cxl_acpi = platform_device_alloc("cxl_acpi", 0);
> +	if (!cxl_acpi)
> +		goto err_port;
> +
> +	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
> +	acpi0017_mock.dev.bus = &platform_bus_type;
> +
> +	rc = platform_device_add(cxl_acpi);
> +	if (rc)
> +		goto err_add;
> +
> +	return 0;
> +
> +err_add:
> +	platform_device_put(cxl_acpi);
> +err_port:
> +	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_root_port[i]);
> +		platform_device_put(cxl_root_port[i]);
> +	}
> +err_bridge:
> +	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_host_bridge[i]);
> +		platform_device_put(cxl_host_bridge[i]);
> +	}
> +err_populate:
> +	free_mock_res();
> +err_gen_pool_add:
> +	gen_pool_destroy(cxl_mock_pool);
> +err_gen_pool_create:
> +	unregister_cxl_mock_ops(&cxl_mock_ops);
> +	return rc;
> +}
> +
> +static __exit void cxl_test_exit(void)
> +{
> +	int i;
> +
> +	platform_device_del(cxl_acpi);
> +	platform_device_put(cxl_acpi);
> +	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_root_port[i]);
> +		platform_device_put(cxl_root_port[i]);
> +	}
> +	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_host_bridge[i]);
> +		platform_device_put(cxl_host_bridge[i]);
> +	}
> +	free_mock_res();
> +	gen_pool_destroy(cxl_mock_pool);
> +	unregister_cxl_mock_ops(&cxl_mock_ops);
> +}
> +
> +module_init(cxl_test_init);
> +module_exit(cxl_test_exit);
> +MODULE_LICENSE("GPL v2");
> diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
> new file mode 100644
> index 000000000000..5b61373a4f1d
> --- /dev/null
> +++ b/tools/testing/cxl/test/mock.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//Copyright(c) 2021 Intel Corporation. All rights reserved.
> +
> +#include <linux/rculist.h>
> +#include <linux/device.h>
> +#include <linux/export.h>
> +#include <linux/acpi.h>
> +#include <linux/pci.h>
> +#include "mock.h"
> +
> +static LIST_HEAD(mock);
> +
> +void register_cxl_mock_ops(struct cxl_mock_ops *ops)
> +{
> +	list_add_rcu(&ops->list, &mock);
> +}
> +EXPORT_SYMBOL_GPL(register_cxl_mock_ops);
> +
> +static DEFINE_SRCU(cxl_mock_srcu);
> +
> +void unregister_cxl_mock_ops(struct cxl_mock_ops *ops)
> +{
> +	list_del_rcu(&ops->list);
> +	synchronize_srcu(&cxl_mock_srcu);
> +}
> +EXPORT_SYMBOL_GPL(unregister_cxl_mock_ops);
> +
> +struct cxl_mock_ops *get_cxl_mock_ops(int *index)
> +{
> +	*index = srcu_read_lock(&cxl_mock_srcu);
> +	return list_first_or_null_rcu(&mock, struct cxl_mock_ops, list);
> +}
> +EXPORT_SYMBOL_GPL(get_cxl_mock_ops);
> +
> +void put_cxl_mock_ops(int index)
> +{
> +	srcu_read_unlock(&cxl_mock_srcu, index);
> +}
> +EXPORT_SYMBOL_GPL(put_cxl_mock_ops);
> +
> +bool __wrap_is_acpi_device_node(const struct fwnode_handle *fwnode)
> +{
> +	struct acpi_device *adev =
> +		container_of(fwnode, struct acpi_device, fwnode);
> +	int index;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	bool retval = false;
> +
> +	if (ops)
> +		retval = ops->is_mock_adev(adev);
> +
> +	if (!retval)
> +		retval = is_acpi_device_node(fwnode);
> +
> +	put_cxl_mock_ops(index);
> +	return retval;
> +}
> +EXPORT_SYMBOL(__wrap_is_acpi_device_node);
> +
> +acpi_status __wrap_acpi_get_table(char *signature, u32 instance,
> +				  struct acpi_table_header **out_table)
> +{
> +	int index;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	acpi_status status;
> +
> +	if (ops)
> +		status = ops->acpi_get_table(signature, instance, out_table);
> +	else
> +		status = acpi_get_table(signature, instance, out_table);
> +
> +	put_cxl_mock_ops(index);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL(__wrap_acpi_get_table);
> +
> +void __wrap_acpi_put_table(struct acpi_table_header *table)
> +{
> +	int index;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +
> +	if (ops)
> +		ops->acpi_put_table(table);
> +	else
> +		acpi_put_table(table);
> +	put_cxl_mock_ops(index);
> +}
> +EXPORT_SYMBOL(__wrap_acpi_put_table);
> +
> +acpi_status __wrap_acpi_evaluate_integer(acpi_handle handle,
> +					 acpi_string pathname,
> +					 struct acpi_object_list *arguments,
> +					 unsigned long long *data)
> +{
> +	int index;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	acpi_status status;
> +
> +	if (ops)
> +		status = ops->acpi_evaluate_integer(handle, pathname, arguments,
> +						    data);
> +	else
> +		status = acpi_evaluate_integer(handle, pathname, arguments,
> +					       data);
> +	put_cxl_mock_ops(index);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL(__wrap_acpi_evaluate_integer);
> +
> +struct acpi_pci_root *__wrap_acpi_pci_find_root(acpi_handle handle)
> +{
> +	int index;
> +	struct acpi_pci_root *root;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +
> +	if (ops)
> +		root = ops->acpi_pci_find_root(handle);
> +	else
> +		root = acpi_pci_find_root(handle);
> +
> +	put_cxl_mock_ops(index);
> +
> +	return root;
> +}
> +EXPORT_SYMBOL_GPL(__wrap_acpi_pci_find_root);
> +
> +void __wrap_pci_walk_bus(struct pci_bus *bus,
> +			 int (*cb)(struct pci_dev *, void *), void *userdata)
> +{
> +	int index;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +
> +	if (ops && ops->is_mock_bus(bus)) {
> +		int rc, i;
> +
> +		/*
> +		 * Simulate 2 root ports per host-bridge and no
> +		 * depth recursion.
> +		 */
> +		for (i = 0; i < 2; i++) {
> +			rc = cb((struct pci_dev *) ops->mock_port(bus, i),
> +				userdata);
> +			if (rc)
> +				break;
> +		}
> +	} else
> +		pci_walk_bus(bus, cb, userdata);
> +
> +	put_cxl_mock_ops(index);
> +}
> +EXPORT_SYMBOL_GPL(__wrap_pci_walk_bus);
> +
> +MODULE_LICENSE("GPL v2");
> diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
> new file mode 100644
> index 000000000000..7d3b3fa6ffec
> --- /dev/null
> +++ b/tools/testing/cxl/test/mock.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <linux/list.h>
> +#include <linux/acpi.h>
> +
> +struct cxl_mock_ops {
> +	struct list_head list;
> +	bool (*is_mock_adev)(struct acpi_device *dev);
> +	acpi_status (*acpi_get_table)(char *signature, u32 instance,
> +				      struct acpi_table_header **out_table);
> +	void (*acpi_put_table)(struct acpi_table_header *table);
> +	bool (*is_mock_bridge)(struct device *dev);
> +	acpi_status (*acpi_evaluate_integer)(acpi_handle handle,
> +					     acpi_string pathname,
> +					     struct acpi_object_list *arguments,
> +					     unsigned long long *data);
> +	struct acpi_pci_root *(*acpi_pci_find_root)(acpi_handle handle);
> +	struct platform_device *(*mock_port)(struct pci_bus *bus, int index);
> +	bool (*is_mock_bus)(struct pci_bus *bus);
> +	bool (*is_mock_port)(struct platform_device *pdev);
> +};
> +
> +void register_cxl_mock_ops(struct cxl_mock_ops *ops);
> +void unregister_cxl_mock_ops(struct cxl_mock_ops *ops);
> +struct cxl_mock_ops *get_cxl_mock_ops(int *index);
> +void put_cxl_mock_ops(int index);
> 

