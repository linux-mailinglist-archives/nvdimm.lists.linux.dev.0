Return-Path: <nvdimm+bounces-4103-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC43561C0C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 15:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 163D52E0A76
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Jun 2022 13:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323F74C94;
	Thu, 30 Jun 2022 13:56:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60E3D7C;
	Thu, 30 Jun 2022 13:56:42 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYfxL5y3Cz67kFH;
	Thu, 30 Jun 2022 21:55:50 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 30 Jun 2022 15:56:39 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 14:56:38 +0100
Date: Thu, 30 Jun 2022 14:56:36 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>, "Ben
 Widawsky" <bwidawsk@kernel.org>
Subject: Re: [PATCH 37/46] cxl/region: Allocate host physical address (HPA)
 capacity to new regions
Message-ID: <20220630145636.00002f12@Huawei.com>
In-Reply-To: <20220624041950.559155-12-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-12-dan.j.williams@intel.com>
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
X-Originating-IP: [10.81.200.250]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 21:19:41 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> After a region's interleave parameters (ways and granularity) are set,
> add a way for regions to allocate HPA from the free capacity in their
> decoder. The allocator for this capacity reuses the 'struct resource'
> based allocator used for CONFIG_DEVICE_PRIVATE.
> 
> Once the tuple of "ways, granularity, and size" is set the
> region configuration transitions to the CXL_CONFIG_INTERLEAVE_ACTIVE
> state which is a precursor to allowing endpoint decoders to be added to
> a region.
> 
> Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

A few comments on the interface inline.

Thanks,

Jonathan

> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  25 ++++
>  drivers/cxl/Kconfig                     |   3 +
>  drivers/cxl/core/region.c               | 148 +++++++++++++++++++++++-
>  drivers/cxl/cxl.h                       |   2 +
>  4 files changed, 177 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 46d5295c1149..3658facc9944 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -294,3 +294,28 @@ Description:
>  		(RW) Configures the number of devices participating in the
>  		region is set by writing this value. Each device will provide
>  		1/interleave_ways of storage for the region.
> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/size
> +Date:		May, 2022
> +KernelVersion:	v5.20
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RW) System physical address space to be consumed by the region.
> +		When written to, this attribute will allocate space out of the
> +		CXL root decoder's address space. When read the size of the
> +		address space is reported and should match the span of the
> +		region's resource attribute. Size shall be set after the
> +		interleave configuration parameters.

There seem to be constraints that say you have to set this to 0 and then something
else later to force a resize. That should be mentioned here or gotten rid of.


> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/resource
> +Date:		May, 2022
> +KernelVersion:	v5.20
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) A region is a contiguous partition of a CXL root decoder
> +		address space. Region capacity is allocated by writing to the
> +		size attribute, the resulting physical address space determined
> +		by the driver is reflected here. It is therefore not useful to
> +		read this before writing a value to the size attribute.

I don't much like naming a "base address" resource.  I'd expect resource to contain
both base and size whereas this only has the base address of the region.



