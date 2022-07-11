Return-Path: <nvdimm+bounces-4071-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A204F5603AC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 29 Jun 2022 16:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C98DE280BE5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 29 Jun 2022 14:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF6133CE;
	Wed, 29 Jun 2022 14:59:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132232F2E;
	Wed, 29 Jun 2022 14:59:14 +0000 (UTC)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LY4JF2RZTz688Q2;
	Wed, 29 Jun 2022 22:55:09 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 29 Jun 2022 16:59:11 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Wed, 29 Jun
 2022 15:59:11 +0100
Date: Wed, 29 Jun 2022 15:59:09 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, <hch@infradead.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, Mauro Carvalho Chehab
	<mchehab@kernel.org>
Subject: Re: [PATCH 15/46] cxl/Documentation: List attribute permissions
Message-ID: <20220629155909.00003c96@Huawei.com>
In-Reply-To: <165603881198.551046.12893348287451903699.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603881198.551046.12893348287451903699.stgit@dwillia2-xfh>
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

On Thu, 23 Jun 2022 19:46:52 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Clarify the access permission of CXL sysfs attributes in the
> documentation to help development of userspace tooling.
> 
> Reported-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Makes sense, though might be a good idea at somepoint to standardize
this in some fashion for the automated docs build.  e.g.

https://www.kernel.org/doc/html/latest/admin-guide/abi-testing.html#abi-sys-bus-cxl-devices-devtype
+CC Mauro in case he thinks it's worth looking at doing for purposes of
his runtime verification scripts...

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |   81 ++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 40 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 7c2b846521f3..1fd5984b6158 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -57,28 +57,28 @@ Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		CXL device objects export the devtype attribute which mirrors
> -		the same value communicated in the DEVTYPE environment variable
> -		for uevents for devices on the "cxl" bus.
> +		(RO) CXL device objects export the devtype attribute which
> +		mirrors the same value communicated in the DEVTYPE environment
> +		variable for uevents for devices on the "cxl" bus.
>  
>  What:		/sys/bus/cxl/devices/*/modalias
>  Date:		December, 2021
>  KernelVersion:	v5.18
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		CXL device objects export the modalias attribute which mirrors
> -		the same value communicated in the MODALIAS environment variable
> -		for uevents for devices on the "cxl" bus.
> +		(RO) CXL device objects export the modalias attribute which
> +		mirrors the same value communicated in the MODALIAS environment
> +		variable for uevents for devices on the "cxl" bus.
>  
>  What:		/sys/bus/cxl/devices/portX/uport
>  Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		CXL port objects are enumerated from either a platform firmware
> -		device (ACPI0017 and ACPI0016) or PCIe switch upstream port with
> -		CXL component registers. The 'uport' symlink connects the CXL
> -		portX object to the device that published the CXL port
> +		(RO) CXL port objects are enumerated from either a platform
> +		firmware device (ACPI0017 and ACPI0016) or PCIe switch upstream
> +		port with CXL component registers. The 'uport' symlink connects
> +		the CXL portX object to the device that published the CXL port
>  		capability.
>  
>  What:		/sys/bus/cxl/devices/portX/dportY
> @@ -86,20 +86,20 @@ Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		CXL port objects are enumerated from either a platform firmware
> -		device (ACPI0017 and ACPI0016) or PCIe switch upstream port with
> -		CXL component registers. The 'dportY' symlink identifies one or
> -		more downstream ports that the upstream port may target in its
> -		decode of CXL memory resources.  The 'Y' integer reflects the
> -		hardware port unique-id used in the hardware decoder target
> -		list.
> +		(RO) CXL port objects are enumerated from either a platform
> +		firmware device (ACPI0017 and ACPI0016) or PCIe switch upstream
> +		port with CXL component registers. The 'dportY' symlink
> +		identifies one or more downstream ports that the upstream port
> +		may target in its decode of CXL memory resources.  The 'Y'
> +		integer reflects the hardware port unique-id used in the
> +		hardware decoder target list.
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y
>  Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		CXL decoder objects are enumerated from either a platform
> +		(RO) CXL decoder objects are enumerated from either a platform
>  		firmware description, or a CXL HDM decoder register set in a
>  		PCIe device (see CXL 2.0 section 8.2.5.12 CXL HDM Decoder
>  		Capability Structure). The 'X' in decoderX.Y represents the
> @@ -111,42 +111,43 @@ Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		The 'start' and 'size' attributes together convey the physical
> -		address base and number of bytes mapped in the decoder's decode
> -		window. For decoders of devtype "cxl_decoder_root" the address
> -		range is fixed. For decoders of devtype "cxl_decoder_switch" the
> -		address is bounded by the decode range of the cxl_port ancestor
> -		of the decoder's cxl_port, and dynamically updates based on the
> -		active memory regions in that address space.
> +		(RO) The 'start' and 'size' attributes together convey the
> +		physical address base and number of bytes mapped in the
> +		decoder's decode window. For decoders of devtype
> +		"cxl_decoder_root" the address range is fixed. For decoders of
> +		devtype "cxl_decoder_switch" the address is bounded by the
> +		decode range of the cxl_port ancestor of the decoder's cxl_port,
> +		and dynamically updates based on the active memory regions in
> +		that address space.
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/locked
>  Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		CXL HDM decoders have the capability to lock the configuration
> -		until the next device reset. For decoders of devtype
> -		"cxl_decoder_root" there is no standard facility to unlock them.
> -		For decoders of devtype "cxl_decoder_switch" a secondary bus
> -		reset, of the PCIe bridge that provides the bus for this
> -		decoders uport, unlocks / resets the decoder.
> +		(RO) CXL HDM decoders have the capability to lock the
> +		configuration until the next device reset. For decoders of
> +		devtype "cxl_decoder_root" there is no standard facility to
> +		unlock them.  For decoders of devtype "cxl_decoder_switch" a
> +		secondary bus reset, of the PCIe bridge that provides the bus
> +		for this decoders uport, unlocks / resets the decoder.
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/target_list
>  Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		Display a comma separated list of the current decoder target
> -		configuration. The list is ordered by the current configured
> -		interleave order of the decoder's dport instances. Each entry in
> -		the list is a dport id.
> +		(RO) Display a comma separated list of the current decoder
> +		target configuration. The list is ordered by the current
> +		configured interleave order of the decoder's dport instances.
> +		Each entry in the list is a dport id.
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/cap_{pmem,ram,type2,type3}
>  Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		When a CXL decoder is of devtype "cxl_decoder_root", it
> +		(RO) When a CXL decoder is of devtype "cxl_decoder_root", it
>  		represents a fixed memory window identified by platform
>  		firmware. A fixed window may only support a subset of memory
>  		types. The 'cap_*' attributes indicate whether persistent
> @@ -158,8 +159,8 @@ Date:		June, 2021
>  KernelVersion:	v5.14
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
> -		When a CXL decoder is of devtype "cxl_decoder_switch", it can
> -		optionally decode either accelerator memory (type-2) or expander
> -		memory (type-3). The 'target_type' attribute indicates the
> -		current setting which may dynamically change based on what
> +		(RO) When a CXL decoder is of devtype "cxl_decoder_switch", it
> +		can optionally decode either accelerator memory (type-2) or
> +		expander memory (type-3). The 'target_type' attribute indicates
> +		the current setting which may dynamically change based on what
>  		memory regions are activated in this decode hierarchy.
> 


