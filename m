Return-Path: <nvdimm+bounces-4037-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD90455BDCB
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Jun 2022 05:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 416AC280CB2
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Jun 2022 03:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E654385;
	Tue, 28 Jun 2022 03:17:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4E1368;
	Tue, 28 Jun 2022 03:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656386242; x=1687922242;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qnBjJ5OmfEyFYsZp3EsIO2f9zoA7umjSyIJHqXM0up4=;
  b=efFEyuHMuSu2KJwobhpz3O8LzDCUZGRduDoA3oWEdAWHsRFRDKTVRtcW
   HURg4kDvmKInM58jjPobfbfy7uHOphyjtVKVDZxbO5x52nKHOVxl7C0ub
   KqP+20Td9nlKed1bZzwEW3bj3FiheL1auefQ8lzkYZFp4lFRNSjHGFd8r
   FEJCFq4BIFs6ogms+J1mJAyq36Qwu47RTz2Jmx4EXr5pDvLNw0+IJG41z
   Dfdomz0Q/dfH3Boeptbrtw6p7Y5JCw9EPL//GZz2x/V0EGl6PWz1jNro8
   ErTY1V7IC3LLM6QaV3UQB1XLEpSL2rShO4W/60ZOQWaF44pDb5on0qO5Z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282356359"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282356359"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:17:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="916991440"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:17:22 -0700
Date: Mon, 27 Jun 2022 20:16:37 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 15/46] cxl/Documentation: List attribute permissions
Message-ID: <20220628031637.GB1575206@alison-desk>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
 <165603881198.551046.12893348287451903699.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165603881198.551046.12893348287451903699.stgit@dwillia2-xfh>

On Thu, Jun 23, 2022 at 07:46:52PM -0700, Dan Williams wrote:
> Clarify the access permission of CXL sysfs attributes in the
> documentation to help development of userspace tooling.
> 
> Reported-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


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

