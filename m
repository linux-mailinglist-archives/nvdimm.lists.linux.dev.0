Return-Path: <nvdimm+bounces-5960-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FB26F040F
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Apr 2023 12:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FE6E1C208D4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Apr 2023 10:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6622571;
	Thu, 27 Apr 2023 10:20:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B39523DC
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 10:20:01 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="93785519"
X-IronPort-AV: E=Sophos;i="5.99,230,1677510000"; 
   d="scan'208";a="93785519"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 19:18:49 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id A16EDC3F7E
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 19:18:47 +0900 (JST)
Received: from kws-ab1.gw.nic.fujitsu.com (kws-ab1.gw.nic.fujitsu.com [192.51.206.11])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id E5A25CFFAE
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 19:18:46 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by kws-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id AE45F114626A;
	Thu, 27 Apr 2023 19:18:44 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: x86@kernel.org,
	nvdimm@lists.linux.dev,
	kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	y-goto@fujitsu.com,
	yangx.jy@fujitsu.com,
	ruansy.fnst@fujitsu.com,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [RFC PATCH v2 2/3] drivers/nvdimm: export memmap of namespace to vmcoreinfo
Date: Thu, 27 Apr 2023 18:18:33 +0800
Message-Id: <20230427101838.12267-3-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230427101838.12267-1-lizhijian@fujitsu.com>
References: <20230427101838.12267-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27590.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27590.006
X-TMASE-Result: 10--5.296600-10.000000
X-TMASE-MatchedRID: mJ3yV3MWQwmUkDPUhpX2vh1kSRHxj+Z5A81piVnI+HU1SqhT+J6xsUbg
	XczvLJKOjx5X3FdI4UDmn3xyPJAJoh2P280ZiGmRfiKzBf4Yf9iOVGny5q72hp4Q+L3BXIWuyL5
	QmWOgMfBI7ocMJBgR6/WV3EhAhFD6Sry0z8DqbhLNgrlT5Ajc7n0tCKdnhB589yM15V5aWpj6C0
	ePs7A07Xi4XEoPXecxVvpTJmXb4dua6fR6Q+5OxeYzpCWDqqUZ3tGV3hp+Y+4=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Each namespace has its own memmap, it will be udpated when
namespace initializing/creating, updating, and deleting.

CC: Dan Williams <dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 drivers/nvdimm/namespace_devs.c | 2 ++
 drivers/nvdimm/pfn_devs.c       | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index c60ec0b373c5..096203e6203f 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/nd.h>
+#include <linux/crash_core.h>
 #include "nd-core.h"
 #include "pmem.h"
 #include "pfn.h"
@@ -853,6 +854,7 @@ static ssize_t size_store(struct device *dev,
 	if (rc == 0 && val == 0 && is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
+		devm_memmap_vmcore_delete(to_ndns(dev));
 		kfree(nspm->uuid);
 		nspm->uuid = NULL;
 	}
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index af7d9301520c..80076996b2da 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/crash_core.h>
 #include "nd-core.h"
 #include "pfn.h"
 #include "nd.h"
@@ -716,6 +717,8 @@ static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
 	} else
 		return -ENXIO;
 
+	devm_memmap_vmcore_update(ndns, altmap->base_pfn, PHYS_PFN(offset),
+				  nd_pfn->mode == PFN_MODE_PMEM);
 	return 0;
 }
 
-- 
2.29.2


