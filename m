Return-Path: <nvdimm+bounces-4267-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 185A557583A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Jul 2022 02:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BF79280CD2
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Jul 2022 00:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D1A6D22;
	Fri, 15 Jul 2022 00:00:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820686D19
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843249; x=1689379249;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IX0zDmBSJKnXh8wY1T5AtKjkfjgtsxcgcyDoSxKglnk=;
  b=gPMFj9bYae/odJNPoBlfI14CkLbEkFuanInvUtO8KiZF7pjlebS2kyBM
   zKpnKU4zkhJwT7sUPypPXTJcRRUhKWR7txlgaopzhbTfkTepMHjSD6/W0
   iy42uwqXNfd8UtqpPI2cHsmELjimZPug5YSJtjDaiv4n6lPFlTQBr0wO/
   4xlO0ngLfunlCtb6aSdKBfPQ/rq7Nm/ji3LCcj2zWds25NnTpwanQ3zI1
   y3Vj7CBuaS6iVmb+7T8w3yqYVxDpP7IjMFnF6HomDWnnVwRLmr8yKVHMv
   a9ywiClxw8VmwCjEpSoJAVv2w+TcG3nuCJ1mS0eMQPiU7H8BHkrBpTaIJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286799304"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286799304"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:00:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="738462685"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:00:48 -0700
Subject: [PATCH v2 01/28] Documentation/cxl: Use a double line break between
 entries
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: hch@lst.de, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:00:47 -0700
Message-ID: <165784324750.1758207.10379257962719807754.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Make it easier to read delineations between the "Description" line
break, new paragraph line breaks, and new entries.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 1fd5984b6158..16d9ffa94bbd 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -7,6 +7,7 @@ Description:
 		all descendant memdevs for unbind. Writing '1' to this attribute
 		flushes that work.
 
+
 What:		/sys/bus/cxl/devices/memX/firmware_version
 Date:		December, 2020
 KernelVersion:	v5.12
@@ -16,6 +17,7 @@ Description:
 		Memory Device Output Payload in the CXL-2.0
 		specification.
 
+
 What:		/sys/bus/cxl/devices/memX/ram/size
 Date:		December, 2020
 KernelVersion:	v5.12
@@ -25,6 +27,7 @@ Description:
 		identically named field in the Identify Memory Device Output
 		Payload in the CXL-2.0 specification.
 
+
 What:		/sys/bus/cxl/devices/memX/pmem/size
 Date:		December, 2020
 KernelVersion:	v5.12
@@ -34,6 +37,7 @@ Description:
 		identically named field in the Identify Memory Device Output
 		Payload in the CXL-2.0 specification.
 
+
 What:		/sys/bus/cxl/devices/memX/serial
 Date:		January, 2022
 KernelVersion:	v5.18
@@ -43,6 +47,7 @@ Description:
 		capability. Mandatory for CXL devices, see CXL 2.0 8.1.12.2
 		Memory Device PCIe Capabilities and Extended Capabilities.
 
+
 What:		/sys/bus/cxl/devices/memX/numa_node
 Date:		January, 2022
 KernelVersion:	v5.18
@@ -52,6 +57,7 @@ Description:
 		host PCI device for this memory device, emit the CPU node
 		affinity for this device.
 
+
 What:		/sys/bus/cxl/devices/*/devtype
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -61,6 +67,7 @@ Description:
 		mirrors the same value communicated in the DEVTYPE environment
 		variable for uevents for devices on the "cxl" bus.
 
+
 What:		/sys/bus/cxl/devices/*/modalias
 Date:		December, 2021
 KernelVersion:	v5.18
@@ -70,6 +77,7 @@ Description:
 		mirrors the same value communicated in the MODALIAS environment
 		variable for uevents for devices on the "cxl" bus.
 
+
 What:		/sys/bus/cxl/devices/portX/uport
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -81,6 +89,7 @@ Description:
 		the CXL portX object to the device that published the CXL port
 		capability.
 
+
 What:		/sys/bus/cxl/devices/portX/dportY
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -94,6 +103,7 @@ Description:
 		integer reflects the hardware port unique-id used in the
 		hardware decoder target list.
 
+
 What:		/sys/bus/cxl/devices/decoderX.Y
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -106,6 +116,7 @@ Description:
 		cxl_port container of this decoder, and 'Y' represents the
 		instance id of a given decoder resource.
 
+
 What:		/sys/bus/cxl/devices/decoderX.Y/{start,size}
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -120,6 +131,7 @@ Description:
 		and dynamically updates based on the active memory regions in
 		that address space.
 
+
 What:		/sys/bus/cxl/devices/decoderX.Y/locked
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -132,6 +144,7 @@ Description:
 		secondary bus reset, of the PCIe bridge that provides the bus
 		for this decoders uport, unlocks / resets the decoder.
 
+
 What:		/sys/bus/cxl/devices/decoderX.Y/target_list
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -142,6 +155,7 @@ Description:
 		configured interleave order of the decoder's dport instances.
 		Each entry in the list is a dport id.
 
+
 What:		/sys/bus/cxl/devices/decoderX.Y/cap_{pmem,ram,type2,type3}
 Date:		June, 2021
 KernelVersion:	v5.14
@@ -154,6 +168,7 @@ Description:
 		memory, volatile memory, accelerator memory, and / or expander
 		memory may be mapped behind this decoder's memory window.
 
+
 What:		/sys/bus/cxl/devices/decoderX.Y/target_type
 Date:		June, 2021
 KernelVersion:	v5.14


