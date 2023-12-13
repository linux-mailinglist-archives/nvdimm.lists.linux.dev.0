Return-Path: <nvdimm+bounces-7034-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB60380DEA1
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Dec 2023 23:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3353EB20F45
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Dec 2023 22:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF7B55C2C;
	Mon, 11 Dec 2023 22:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPvOROPa"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF7E53E13
	for <nvdimm@lists.linux.dev>; Mon, 11 Dec 2023 22:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702335151; x=1733871151;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=eRjouxxYbp6BIJhAGRJgKvaoh/ihepCgDQj/UtlSTMk=;
  b=XPvOROPayMCbxTv6umRNUnsyQVrrK0lsgEp/cr6AdL/0cXT4ZbXTXZo1
   ykxq4Tnc4IT9UU9PjXTumQp+2g5YppkSIpmWXKy9Y4j/VxyO6AOAVL788
   nZ+ddZZGxvCWrt9h/UVS1cXC7w9/2tohXBhvZ6xKC7zVnuW1ciPi04S2V
   o0Xhm0CBdtP36FqPIQ/SLg4kktTf7kinvVwY2TUda7WEpGwFzRPljEyK0
   0OPqg7+dMFPBLp1vBFc6lhLwJd71JSkC6tchIA22VLjcIcW2RqWP8B7ms
   SAMLt0jNYlebUA7SXNRGf8A1ToWBykHAzdVpdJnNgMYmqsFOY5EZoWR42
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="8083748"
X-IronPort-AV: E=Sophos;i="6.04,268,1695711600"; 
   d="scan'208";a="8083748"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 14:52:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="946511328"
X-IronPort-AV: E=Sophos;i="6.04,268,1695711600"; 
   d="scan'208";a="946511328"
Received: from tlyon-mobl2.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.89.19])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 14:52:28 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 0/2] Add DAX ABI for memmap_on_memory
Date: Mon, 11 Dec 2023 15:52:16 -0700
Message-Id: <20231211-vv-dax_abi-v3-0-acf6cc1bde9f@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKGSd2UC/3WMQQ6CMBBFr2K6tmY6rQVdeQ9jTCmDTKJgWtJgC
 He34IaN+av3k/cmESkwRXHeTSJQ4sh9l0Hvd8K3rnuQ5DqzQECtAI8yJVm78e4qlqpwqE7eWCi
 syMI7UMPjGrveMrcchz581nZSy/vLINhtJikJ0hSGqrIkBOUv3A30PPj+JZZMwv8qZrUxeai1r
 aHcqvM8fwE5O/0+3wAAAA==
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, Li Zhijian <lizhijian@fujitsu.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=eRjouxxYbp6BIJhAGRJgKvaoh/ihepCgDQj/UtlSTMk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKnlk1b7del86Ps/ZemT3JJDSXPsMlaksYg2sJQ5JmU++
 1fn4Tm9o5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABNRCmH4nxGiJlTs9PKc7gKe
 /GsbXulelYp/vdkihq9lgQlrwoyqh4wM952ENK+nPHNbO3fD1si6SYtfb5GauvSdwdmOH4UbCxg
 iOAE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The DAX drivers were missing sysfs ABI documentation entirely.  Add this
missing documentation for the sysfs ABI for DAX regions and Dax devices
in patch 1. Add a new ABI for toggling memmap_on_memory semantics in
patch 2.

The missing ABI was spotted in [1], this series is a split of the new
ABI additions behind the initial documentation creation.

[1]: https://lore.kernel.org/linux-cxl/651f27b728fef_ae7e7294b3@dwillia2-xfh.jf.intel.com.notmuch/

Changes in v3:
- Fix typo in ABI docs (Zhijian Li)
- Add kernel config and module parameter dependencies to the ABI docs
  entry (David Hildenbrand)
- Ensure kmem isn't active when setting the sysfs attribute (Ying
  Huang)
- Simplify returning from memmap_on_memory_store()
- Link to v2: https://lore.kernel.org/r/20231206-vv-dax_abi-v2-0-f4f4f2336d08@intel.com

Changes in v2:
- Fix CC lists, patch 1/2 didn't get sent correctly in v1
- Link to v1: https://lore.kernel.org/r/20231206-vv-dax_abi-v1-0-474eb88e201c@intel.com

---
Vishal Verma (2):
      Documentatiion/ABI: Add ABI documentation for sys-bus-dax
      dax: add a sysfs knob to control memmap_on_memory behavior

 drivers/dax/bus.c                       |  47 +++++++++
 Documentation/ABI/testing/sysfs-bus-dax | 168 ++++++++++++++++++++++++++++++++
 2 files changed, 215 insertions(+)
---
base-commit: c4e1ccfad42352918810802095a8ace8d1c744c9
change-id: 20231025-vv-dax_abi-17a219c46076

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


