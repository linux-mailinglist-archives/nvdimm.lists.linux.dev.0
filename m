Return-Path: <nvdimm+bounces-4080-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A5156058D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 29 Jun 2022 18:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 1F9B72E0A38
	for <lists+linux-nvdimm@lfdr.de>; Wed, 29 Jun 2022 16:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAA83D77;
	Wed, 29 Jun 2022 16:14:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFF43D6C;
	Wed, 29 Jun 2022 16:14:11 +0000 (UTC)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LY60h09M6z6H7M9;
	Thu, 30 Jun 2022 00:11:48 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 29 Jun 2022 18:14:08 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Wed, 29 Jun
 2022 17:14:07 +0100
Date: Wed, 29 Jun 2022 17:14:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@infradead.org>,
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 22/46] tools/testing/cxl: Expand CFMWS windows
Message-ID: <20220629171406.00005019@Huawei.com>
In-Reply-To: <165603886721.551046.8682583835505795210.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603886721.551046.8682583835505795210.stgit@dwillia2-xfh>
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
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 19:47:47 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> For the x2 host-bridge interleave windows, allow for a
> x8-endpoint-interleave configuration per memory-type with each device
> contributing the minimum 256MB extent. Similarly, for the x1 host-bridge
> interleave windows, allow for a x4-endpoint-interleave configuration per
> memory-type.
> 
> Bump up the number of decoders per-port to support hosting 8 regions.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Hmm. I should get around to adding multiple decoders to the programmable
bits of the QEMU emulation to give us more flexibility.  Mind you
volatile memory support would probably also be good ;)

Jonathan

> ---
>  tools/testing/cxl/test/cxl.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index b6e6bc02a507..599326796b83 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -14,7 +14,7 @@
>  #define NR_CXL_HOST_BRIDGES 2
>  #define NR_CXL_ROOT_PORTS 2
>  #define NR_CXL_SWITCH_PORTS 2
> -#define NR_CXL_PORT_DECODERS 2
> +#define NR_CXL_PORT_DECODERS 8
>  
>  static struct platform_device *cxl_acpi;
>  static struct platform_device *cxl_host_bridge[NR_CXL_HOST_BRIDGES];
> @@ -118,7 +118,7 @@ static struct {
>  			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
>  					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
>  			.qtg_id = 0,
> -			.window_size = SZ_256M,
> +			.window_size = SZ_256M * 4UL,
>  		},
>  		.target = { 0 },
>  	},
> @@ -133,7 +133,7 @@ static struct {
>  			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
>  					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
>  			.qtg_id = 1,
> -			.window_size = SZ_256M * 2,
> +			.window_size = SZ_256M * 8UL,
>  		},
>  		.target = { 0, 1, },
>  	},
> @@ -148,7 +148,7 @@ static struct {
>  			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
>  					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
>  			.qtg_id = 2,
> -			.window_size = SZ_256M,
> +			.window_size = SZ_256M * 4UL,
>  		},
>  		.target = { 0 },
>  	},
> @@ -163,7 +163,7 @@ static struct {
>  			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
>  					ACPI_CEDT_CFMWS_RESTRICT_PMEM,
>  			.qtg_id = 3,
> -			.window_size = SZ_256M * 2,
> +			.window_size = SZ_256M * 8UL,
>  		},
>  		.target = { 0, 1, },
>  	},
> 


