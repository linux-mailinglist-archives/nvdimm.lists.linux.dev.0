Return-Path: <nvdimm+bounces-2747-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8564A5C98
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 13:53:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7298E1C06FD
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 12:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933E82CA7;
	Tue,  1 Feb 2022 12:53:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015DC2C9C
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 12:53:13 +0000 (UTC)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jp4VT6w49z67gQT;
	Tue,  1 Feb 2022 20:48:33 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Feb 2022 13:53:11 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 1 Feb
 2022 12:53:10 +0000
Date: Tue, 1 Feb 2022 12:53:09 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 40/40] tools/testing/cxl: Add a physical_node link
Message-ID: <20220201125309.0000358e@Huawei.com>
In-Reply-To: <164298433209.3018233.18101085948127163720.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164298433209.3018233.18101085948127163720.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Sun, 23 Jan 2022 16:32:12 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Emulate what ACPI does to link a host bridge platform firmware device to
> device node on the PCI bus. In this case it's just self referencing
> link, but it otherwise lets the tooling test out its lookup code.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

FWIW the last 5 patches all look good to me, but I'm not familiar
enough with the mocking code to be able to do a detailed review,
so I'll leave that for others.

Thanks,

Jonathan

> ---
>  tools/testing/cxl/test/cxl.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index 1b36e67dcd7e..431f2bddf6c8 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -641,7 +641,12 @@ static __init int cxl_test_init(void)
>  			platform_device_put(pdev);
>  			goto err_bridge;
>  		}
> +
>  		cxl_host_bridge[i] = pdev;
> +		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
> +				       "physical_node");
> +		if (rc)
> +			goto err_bridge;
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
> @@ -745,8 +750,14 @@ static __init int cxl_test_init(void)
>  	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
>  		platform_device_unregister(cxl_root_port[i]);
>  err_bridge:
> -	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--)
> +	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_host_bridge[i];
> +
> +		if (!pdev)
> +			continue;
> +		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
>  		platform_device_unregister(cxl_host_bridge[i]);
> +	}
>  err_populate:
>  	depopulate_all_mock_resources();
>  err_gen_pool_add:
> @@ -769,8 +780,14 @@ static __exit void cxl_test_exit(void)
>  		platform_device_unregister(cxl_switch_uport[i]);
>  	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
>  		platform_device_unregister(cxl_root_port[i]);
> -	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--)
> +	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_host_bridge[i];
> +
> +		if (!pdev)
> +			continue;
> +		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
>  		platform_device_unregister(cxl_host_bridge[i]);
> +	}
>  	depopulate_all_mock_resources();
>  	gen_pool_destroy(cxl_mock_pool);
>  	unregister_cxl_mock_ops(&cxl_mock_ops);
> 


