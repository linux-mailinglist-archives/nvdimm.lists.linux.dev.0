Return-Path: <nvdimm+bounces-1251-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08ACD40697C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 12:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1FE363E1096
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Sep 2021 10:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914C92FB3;
	Fri, 10 Sep 2021 10:09:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C293FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 10:09:32 +0000 (UTC)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5Wky25slz67kyq;
	Fri, 10 Sep 2021 18:07:22 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 10 Sep 2021 12:09:30 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 11:09:29 +0100
Date: Fri, 10 Sep 2021 11:09:27 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	"kernel test robot" <lkp@intel.com>, <vishal.l.verma@intel.com>,
	<nvdimm@lists.linux.dev>, <alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 20/21] tools/testing/cxl: Introduce a mock memory
 device + driver
Message-ID: <20210910110927.0000357a@Huawei.com>
In-Reply-To: <163116440099.2460985.10692549614409346604.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116440099.2460985.10692549614409346604.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Wed, 8 Sep 2021 22:13:21 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Introduce an emulated device-set plus driver to register CXL memory
> devices, 'struct cxl_memdev' instances, in the mock cxl_test topology.
> This enables the development of HDM Decoder (Host-managed Device Memory
> Decoder) programming flow (region provisioning) in an environment that
> can be updated alongside the kernel as it gains more functionality.
> 
> Whereas the cxl_pci module looks for CXL memory expanders on the 'pci'
> bus, the cxl_mock_mem module attaches to CXL expanders on the platform
> bus emitted by cxl_test.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/pmem.c       |    6 -
>  drivers/cxl/cxl.h             |    2 
>  drivers/cxl/pmem.c            |    2 
>  tools/testing/cxl/Kbuild      |    2 
>  tools/testing/cxl/mock_pmem.c |   24 ++++
>  tools/testing/cxl/test/Kbuild |    4 +
>  tools/testing/cxl/test/cxl.c  |   69 +++++++++++
>  tools/testing/cxl/test/mem.c  |  256 +++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 359 insertions(+), 6 deletions(-)
>  create mode 100644 tools/testing/cxl/mock_pmem.c
>  create mode 100644 tools/testing/cxl/test/mem.c
> 
> diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> index 9e56be3994f1..74be5132df1c 100644
> --- a/drivers/cxl/core/pmem.c
> +++ b/drivers/cxl/core/pmem.c
> @@ -51,16 +51,16 @@ struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(to_cxl_nvdimm_bridge);
>  
> -static int match_nvdimm_bridge(struct device *dev, const void *data)
> +__mock int match_nvdimm_bridge(struct device *dev, const void *data)
>  {
>  	return dev->type == &cxl_nvdimm_bridge_type;
>  }
>  
> -struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> +struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd)
>  {
>  	struct device *dev;
>  
> -	dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
> +	dev = bus_find_device(&cxl_bus_type, NULL, cxl_nvd, match_nvdimm_bridge);
>  	if (!dev)
>  		return NULL;
>  	return to_cxl_nvdimm_bridge(dev);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 84b8836c1f91..9af5745ba2c0 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -327,7 +327,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
>  struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
>  bool is_cxl_nvdimm(struct device *dev);
>  int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
> -struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void);
> +struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
>  
>  /*
>   * Unit test builds overrides this to __weak, find the 'strong' version
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 877b0a84e586..569e6ff2a456 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -40,7 +40,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	struct nvdimm *nvdimm = NULL;
>  	int rc = -ENXIO;
>  
> -	cxl_nvb = cxl_find_nvdimm_bridge();
> +	cxl_nvb = cxl_find_nvdimm_bridge(cxl_nvd);
>  	if (!cxl_nvb)
>  		return -ENXIO;
>  
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index 63a4a07e71c4..86deba8308a1 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -33,4 +33,6 @@ cxl_core-y += $(CXL_CORE_SRC)/memdev.o
>  cxl_core-y += $(CXL_CORE_SRC)/mbox.o
>  cxl_core-y += config_check.o
>  
> +cxl_core-y += mock_pmem.o
> +
>  obj-m += test/
> diff --git a/tools/testing/cxl/mock_pmem.c b/tools/testing/cxl/mock_pmem.c
> new file mode 100644
> index 000000000000..f7315e6f52c0
> --- /dev/null
> +++ b/tools/testing/cxl/mock_pmem.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
> +#include <cxl.h>
> +#include "test/mock.h"
> +#include <core/core.h>
> +
> +int match_nvdimm_bridge(struct device *dev, const void *data)
> +{
> +	int index, rc = 0;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	const struct cxl_nvdimm *cxl_nvd = data;
> +
> +	if (ops) {
> +		if (dev->type == &cxl_nvdimm_bridge_type &&
> +		    (ops->is_mock_dev(dev->parent->parent) ==
> +		     ops->is_mock_dev(cxl_nvd->dev.parent->parent)))
> +			rc = 1;
> +	} else
> +		rc = dev->type == &cxl_nvdimm_bridge_type;
> +
> +	put_cxl_mock_ops(index);
> +
> +	return rc;
> +}
> diff --git a/tools/testing/cxl/test/Kbuild b/tools/testing/cxl/test/Kbuild
> index 7de4ddecfd21..4e59e2c911f6 100644
> --- a/tools/testing/cxl/test/Kbuild
> +++ b/tools/testing/cxl/test/Kbuild
> @@ -1,6 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0
> +ccflags-y := -I$(srctree)/drivers/cxl/
> +
>  obj-m += cxl_test.o
>  obj-m += cxl_mock.o
> +obj-m += cxl_mock_mem.o
>  
>  cxl_test-y := cxl.o
>  cxl_mock-y := mock.o
> +cxl_mock_mem-y := mem.o
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index 1c47b34244a4..cb32f9e27d5d 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -17,6 +17,7 @@ static struct platform_device *cxl_acpi;
>  static struct platform_device *cxl_host_bridge[NR_CXL_HOST_BRIDGES];
>  static struct platform_device
>  	*cxl_root_port[NR_CXL_HOST_BRIDGES * NR_CXL_ROOT_PORTS];
> +struct platform_device *cxl_mem[NR_CXL_HOST_BRIDGES * NR_CXL_ROOT_PORTS];
>  
>  static struct acpi_device acpi0017_mock;
>  static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES] = {
> @@ -36,6 +37,11 @@ static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES] = {
>  
>  static bool is_mock_dev(struct device *dev)
>  {
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_mem); i++)
> +		if (dev == &cxl_mem[i]->dev)
> +			return true;
>  	if (dev == &cxl_acpi->dev)
>  		return true;
>  	return false;
> @@ -405,6 +411,44 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
>  #define SZ_512G (SZ_64G * 8)
>  #endif
>  
> +static struct platform_device *alloc_memdev(int id)
> +{
> +	struct resource res[] = {
> +		[0] = {
> +			.flags = IORESOURCE_MEM,
> +		},
> +		[1] = {
> +			.flags = IORESOURCE_MEM,
> +			.desc = IORES_DESC_PERSISTENT_MEMORY,
> +		},
> +	};
> +	struct platform_device *pdev;
> +	int i, rc;
> +
> +	for (i = 0; i < ARRAY_SIZE(res); i++) {
> +		struct cxl_mock_res *r = alloc_mock_res(SZ_256M);
> +
> +		if (!r)
> +			return NULL;
> +		res[i].start = r->range.start;
> +		res[i].end = r->range.end;
> +	}
> +
> +	pdev = platform_device_alloc("cxl_mem", id);
> +	if (!pdev)
> +		return NULL;
> +
> +	rc = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> +	if (rc)
> +		goto err;
> +
> +	return pdev;
> +
> +err:
> +	platform_device_put(pdev);
> +	return NULL;
> +}
> +
>  static __init int cxl_test_init(void)
>  {
>  	int rc, i;
> @@ -460,9 +504,27 @@ static __init int cxl_test_init(void)
>  		cxl_root_port[i] = pdev;
>  	}
>  
> +	BUILD_BUG_ON(ARRAY_SIZE(cxl_mem) != ARRAY_SIZE(cxl_root_port));
> +	for (i = 0; i < ARRAY_SIZE(cxl_mem); i++) {
> +		struct platform_device *port = cxl_root_port[i];
> +		struct platform_device *pdev;
> +
> +		pdev = alloc_memdev(i);
> +		if (!pdev)
> +			goto err_mem;
> +		pdev->dev.parent = &port->dev;
> +
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_mem;
> +		}
> +		cxl_mem[i] = pdev;
> +	}
> +
>  	cxl_acpi = platform_device_alloc("cxl_acpi", 0);
>  	if (!cxl_acpi)
> -		goto err_port;
> +		goto err_mem;
>  
>  	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
>  	acpi0017_mock.dev.bus = &platform_bus_type;
> @@ -475,6 +537,9 @@ static __init int cxl_test_init(void)
>  
>  err_add:
>  	platform_device_put(cxl_acpi);
> +err_mem:
> +	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--)
> +		platform_device_unregister(cxl_mem[i]);
>  err_port:
>  	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
>  		platform_device_unregister(cxl_root_port[i]);
> @@ -495,6 +560,8 @@ static __exit void cxl_test_exit(void)
>  	int i;
>  
>  	platform_device_unregister(cxl_acpi);
> +	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--)
> +		platform_device_unregister(cxl_mem[i]);
>  	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
>  		platform_device_unregister(cxl_root_port[i]);
>  	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--)
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> new file mode 100644
> index 000000000000..12a8437a9ca0
> --- /dev/null
> +++ b/tools/testing/cxl/test/mem.c
> @@ -0,0 +1,256 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +// Copyright(c) 2021 Intel Corporation. All rights reserved.
> +
> +#include <linux/platform_device.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/sizes.h>
> +#include <linux/bits.h>
> +#include <cxlmem.h>
> +
> +#define LSA_SIZE SZ_128K
> +#define EFFECT(x) (1U << x)
> +
> +static struct cxl_cel_entry mock_cel[] = {
> +	{
> +		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_SUPPORTED_LOGS),
> +		.effect = cpu_to_le16(0),
> +	},
> +	{
> +		.opcode = cpu_to_le16(CXL_MBOX_OP_IDENTIFY),
> +		.effect = cpu_to_le16(0),
> +	},
> +	{
> +		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_LSA),
> +		.effect = cpu_to_le16(0),
> +	},
> +	{
> +		.opcode = cpu_to_le16(CXL_MBOX_OP_SET_LSA),
> +		.effect = cpu_to_le16(EFFECT(1) | EFFECT(2)),
> +	},
> +};
> +
> +static struct {
> +	struct cxl_mbox_get_supported_logs gsl;
> +	struct cxl_gsl_entry entry;
> +} mock_gsl_payload = {
> +	.gsl = {
> +		.entries = cpu_to_le16(1),
> +	},
> +	.entry = {
> +		.uuid = DEFINE_CXL_CEL_UUID,
> +		.size = cpu_to_le32(sizeof(mock_cel)),
> +	},
> +};
> +
> +static int mock_gsl(struct cxl_mbox_cmd *cmd)
> +{
> +	if (cmd->size_out < sizeof(mock_gsl_payload))
> +		return -EINVAL;
> +
> +	memcpy(cmd->payload_out, &mock_gsl_payload, sizeof(mock_gsl_payload));
> +	cmd->size_out = sizeof(mock_gsl_payload);
> +
> +	return 0;
> +}
> +
> +static int mock_get_log(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mbox_get_log *gl = cmd->payload_in;
> +	u32 offset = le32_to_cpu(gl->offset);
> +	u32 length = le32_to_cpu(gl->length);
> +	uuid_t uuid = DEFINE_CXL_CEL_UUID;
> +	void *data = &mock_cel;
> +
> +	if (cmd->size_in < sizeof(*gl))
> +		return -EINVAL;
> +	if (length > cxlm->payload_size)
> +		return -EINVAL;
> +	if (offset + length > sizeof(mock_cel))
> +		return -EINVAL;
> +	if (!uuid_equal(&gl->uuid, &uuid))
> +		return -EINVAL;
> +	if (length > cmd->size_out)
> +		return -EINVAL;
> +
> +	memcpy(cmd->payload_out, data + offset, length);
> +
> +	return 0;
> +}
> +
> +static int mock_id(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> +{
> +	struct platform_device *pdev = to_platform_device(cxlm->dev);
> +	struct cxl_mbox_identify id = {
> +		.fw_revision = { "mock fw v1 " },
> +		.lsa_size = cpu_to_le32(LSA_SIZE),
> +		/* FIXME: Add partition support */
> +		.partition_align = cpu_to_le64(0),
> +	};
> +	u64 capacity = 0;
> +	int i;
> +
> +	if (cmd->size_out < sizeof(id))
> +		return -EINVAL;
> +
> +	for (i = 0; i < 2; i++) {
> +		struct resource *res;
> +
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		if (!res)
> +			break;
> +
> +		capacity += resource_size(res) / CXL_CAPACITY_MULTIPLIER;
> +
> +		if (le64_to_cpu(id.partition_align))
> +			continue;
> +
> +		if (res->desc == IORES_DESC_PERSISTENT_MEMORY)
> +			id.persistent_capacity = cpu_to_le64(
> +				resource_size(res) / CXL_CAPACITY_MULTIPLIER);
> +		else
> +			id.volatile_capacity = cpu_to_le64(
> +				resource_size(res) / CXL_CAPACITY_MULTIPLIER);
> +	}
> +
> +	id.total_capacity = cpu_to_le64(capacity);
> +
> +	memcpy(cmd->payload_out, &id, sizeof(id));
> +
> +	return 0;
> +}
> +
> +static int mock_get_lsa(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> +	void *lsa = dev_get_drvdata(cxlm->dev);
> +	u32 offset, length;
> +
> +	if (sizeof(*get_lsa) > cmd->size_in)
> +		return -EINVAL;
> +	offset = le32_to_cpu(get_lsa->offset);
> +	length = le32_to_cpu(get_lsa->length);
> +	if (offset + length > LSA_SIZE)
> +		return -EINVAL;
> +	if (length > cmd->size_out)
> +		return -EINVAL;
> +
> +	memcpy(cmd->payload_out, lsa + offset, length);
> +	return 0;
> +}
> +
> +static int mock_set_lsa(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mbox_set_lsa *set_lsa = cmd->payload_in;
> +	void *lsa = dev_get_drvdata(cxlm->dev);
> +	u32 offset, length;
> +
> +	if (sizeof(*set_lsa) > cmd->size_in)
> +		return -EINVAL;
> +	offset = le32_to_cpu(set_lsa->offset);
> +	length = cmd->size_in - sizeof(*set_lsa);
> +	if (offset + length > LSA_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(lsa + offset, &set_lsa->data[0], length);
> +	return 0;
> +}
> +
> +static int cxl_mock_mbox_send(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> +{
> +	struct device *dev = cxlm->dev;
> +	int rc = -EIO;
> +
> +	switch (cmd->opcode) {
> +	case CXL_MBOX_OP_GET_SUPPORTED_LOGS:
> +		rc = mock_gsl(cmd);
> +		break;
> +	case CXL_MBOX_OP_GET_LOG:
> +		rc = mock_get_log(cxlm, cmd);
> +		break;
> +	case CXL_MBOX_OP_IDENTIFY:
> +		rc = mock_id(cxlm, cmd);
> +		break;
> +	case CXL_MBOX_OP_GET_LSA:
> +		rc = mock_get_lsa(cxlm, cmd);
> +		break;
> +	case CXL_MBOX_OP_SET_LSA:
> +		rc = mock_set_lsa(cxlm, cmd);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	dev_dbg(dev, "opcode: %#x sz_in: %zd sz_out: %zd rc: %d\n", cmd->opcode,
> +		cmd->size_in, cmd->size_out, rc);
> +
> +	return rc;
> +}
> +
> +static void label_area_release(void *lsa)
> +{
> +	vfree(lsa);
> +}
> +
> +static int cxl_mock_mem_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_mem *cxlm;
> +	void *lsa;
> +	int rc;
> +
> +	lsa = vmalloc(LSA_SIZE);
> +	if (!lsa)
> +		return -ENOMEM;
> +	rc = devm_add_action_or_reset(dev, label_area_release, lsa);
> +	if (rc)
> +		return rc;
> +	dev_set_drvdata(dev, lsa);
> +
> +	cxlm = cxl_mem_create(dev);
> +	if (IS_ERR(cxlm))
> +		return PTR_ERR(cxlm);
> +
> +	cxlm->mbox_send = cxl_mock_mbox_send;
> +	cxlm->payload_size = SZ_4K;
> +
> +	rc = cxl_mem_enumerate_cmds(cxlm);
> +	if (rc)
> +		return rc;
> +
> +	rc = cxl_mem_identify(cxlm);
> +	if (rc)
> +		return rc;
> +
> +	rc = cxl_mem_create_range_info(cxlm);
> +	if (rc)
> +		return rc;
> +
> +	cxlmd = devm_cxl_add_memdev(cxlm);
> +	if (IS_ERR(cxlmd))
> +		return PTR_ERR(cxlmd);
> +
> +	if (range_len(&cxlm->pmem_range) && IS_ENABLED(CONFIG_CXL_PMEM))
> +		rc = devm_cxl_add_nvdimm(dev, cxlmd);
> +
> +	return 0;
> +}
> +
> +static const struct platform_device_id cxl_mock_mem_ids[] = {
> +	{ .name = "cxl_mem", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, cxl_mock_mem_ids);
> +
> +static struct platform_driver cxl_mock_mem_driver = {
> +	.probe = cxl_mock_mem_probe,
> +	.id_table = cxl_mock_mem_ids,
> +	.driver = {
> +		.name = KBUILD_MODNAME,
> +	},
> +};
> +
> +module_platform_driver(cxl_mock_mem_driver);
> +MODULE_LICENSE("GPL v2");
> +MODULE_IMPORT_NS(CXL);
> 


