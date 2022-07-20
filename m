Return-Path: <nvdimm+bounces-4372-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8323357B768
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 15:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20E58280CB1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 13:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1E35393;
	Wed, 20 Jul 2022 13:27:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583C94C9B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 13:27:07 +0000 (UTC)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LnxFg5VVxz67xv7;
	Wed, 20 Jul 2022 21:22:31 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 15:27:04 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 14:27:03 +0100
Date: Wed, 20 Jul 2022 14:26:59 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@lst.de>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 01/28] Documentation/cxl: Use a double line break
 between entries
Message-ID: <20220720142659.0000538f@Huawei.com>
In-Reply-To: <165784324750.1758207.10379257962719807754.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784324750.1758207.10379257962719807754.stgit@dwillia2-xfh.jf.intel.com>
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
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 14 Jul 2022 17:00:47 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Make it easier to read delineations between the "Description" line
> break, new paragraph line breaks, and new entries.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'm not that fussed either way on this (indentation was enough for my
brain), but this is at least consistent and I can't see it breaking
the docs build or similar.  Just hope no one decides this is a 'fix' they
want to propagate to all the other ABI docs!

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 1fd5984b6158..16d9ffa94bbd 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -7,6 +7,7 @@ Description:
>  		all descendant memdevs for unbind. Writing '1' to this attribute
>  		flushes that work.
>  
> +
>  What:		/sys/bus/cxl/devices/memX/firmware_version
>  Date:		December, 2020
>  KernelVersion:	v5.12
> @@ -16,6 +17,7 @@ Description:
>  		Memory Device Output Payload in the CXL-2.0
>  		specification.
>  
> +
>  What:		/sys/bus/cxl/devices/memX/ram/size
>  Date:		December, 2020
>  KernelVersion:	v5.12
> @@ -25,6 +27,7 @@ Description:
>  		identically named field in the Identify Memory Device Output
>  		Payload in the CXL-2.0 specification.
>  
> +
>  What:		/sys/bus/cxl/devices/memX/pmem/size
>  Date:		December, 2020
>  KernelVersion:	v5.12
> @@ -34,6 +37,7 @@ Description:
>  		identically named field in the Identify Memory Device Output
>  		Payload in the CXL-2.0 specification.
>  
> +
>  What:		/sys/bus/cxl/devices/memX/serial
>  Date:		January, 2022
>  KernelVersion:	v5.18
> @@ -43,6 +47,7 @@ Description:
>  		capability. Mandatory for CXL devices, see CXL 2.0 8.1.12.2
>  		Memory Device PCIe Capabilities and Extended Capabilities.
>  
> +
>  What:		/sys/bus/cxl/devices/memX/numa_node
>  Date:		January, 2022
>  KernelVersion:	v5.18
> @@ -52,6 +57,7 @@ Description:
>  		host PCI device for this memory device, emit the CPU node
>  		affinity for this device.
>  
> +
>  What:		/sys/bus/cxl/devices/*/devtype
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -61,6 +67,7 @@ Description:
>  		mirrors the same value communicated in the DEVTYPE environment
>  		variable for uevents for devices on the "cxl" bus.
>  
> +
>  What:		/sys/bus/cxl/devices/*/modalias
>  Date:		December, 2021
>  KernelVersion:	v5.18
> @@ -70,6 +77,7 @@ Description:
>  		mirrors the same value communicated in the MODALIAS environment
>  		variable for uevents for devices on the "cxl" bus.
>  
> +
>  What:		/sys/bus/cxl/devices/portX/uport
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -81,6 +89,7 @@ Description:
>  		the CXL portX object to the device that published the CXL port
>  		capability.
>  
> +
>  What:		/sys/bus/cxl/devices/portX/dportY
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -94,6 +103,7 @@ Description:
>  		integer reflects the hardware port unique-id used in the
>  		hardware decoder target list.
>  
> +
>  What:		/sys/bus/cxl/devices/decoderX.Y
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -106,6 +116,7 @@ Description:
>  		cxl_port container of this decoder, and 'Y' represents the
>  		instance id of a given decoder resource.
>  
> +
>  What:		/sys/bus/cxl/devices/decoderX.Y/{start,size}
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -120,6 +131,7 @@ Description:
>  		and dynamically updates based on the active memory regions in
>  		that address space.
>  
> +
>  What:		/sys/bus/cxl/devices/decoderX.Y/locked
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -132,6 +144,7 @@ Description:
>  		secondary bus reset, of the PCIe bridge that provides the bus
>  		for this decoders uport, unlocks / resets the decoder.
>  
> +
>  What:		/sys/bus/cxl/devices/decoderX.Y/target_list
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -142,6 +155,7 @@ Description:
>  		configured interleave order of the decoder's dport instances.
>  		Each entry in the list is a dport id.
>  
> +
>  What:		/sys/bus/cxl/devices/decoderX.Y/cap_{pmem,ram,type2,type3}
>  Date:		June, 2021
>  KernelVersion:	v5.14
> @@ -154,6 +168,7 @@ Description:
>  		memory, volatile memory, accelerator memory, and / or expander
>  		memory may be mapped behind this decoder's memory window.
>  
> +
>  What:		/sys/bus/cxl/devices/decoderX.Y/target_type
>  Date:		June, 2021
>  KernelVersion:	v5.14
> 


