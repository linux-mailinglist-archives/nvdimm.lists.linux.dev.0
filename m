Return-Path: <nvdimm+bounces-1375-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F2B414D2F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 22 Sep 2021 17:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 429201C0A18
	for <lists+linux-nvdimm@lfdr.de>; Wed, 22 Sep 2021 15:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A12B3FCF;
	Wed, 22 Sep 2021 15:35:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B8E3FC7
	for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 15:35:28 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EF98113E;
	Wed, 22 Sep 2021 08:29:31 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B135F3F718;
	Wed, 22 Sep 2021 08:29:28 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH] ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect
Date: Wed, 22 Sep 2021 23:29:19 +0800
Message-Id: <20210922152919.6940-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When ACPI NFIT table is failing to populate correct numa information
on arm64, dax_kmem will get NUMA_NO_NODE from the NFIT driver.

Without this patch, pmem can't be probed as RAM devices on arm64 guest:
  $ndctl create-namespace -fe namespace0.0 --mode=devdax --map=dev -s 1g -a 128M
  kmem dax0.0: rejecting DAX region [mem 0x240400000-0x2bfffffff] with invalid node: -1
  kmem: probe of dax0.0 failed with error -22

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/acpi/nfit/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a3ef6cce644c..7dd80acf92c7 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3007,6 +3007,18 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		ndr_desc->target_node = NUMA_NO_NODE;
 	}
 
+	/* Fallback to address based numa information if node lookup failed */
+	if (ndr_desc->numa_node == NUMA_NO_NODE) {
+		ndr_desc->numa_node = memory_add_physaddr_to_nid(spa->address);
+		dev_info(acpi_desc->dev, "changing numa node from %d to %d for nfit region [%pa-%pa]",
+			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+	}
+	if (ndr_desc->target_node == NUMA_NO_NODE) {
+		ndr_desc->target_node = phys_to_target_node(spa->address);
+		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
+			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+	}
+
 	/*
 	 * Persistence domain bits are hierarchical, if
 	 * ACPI_NFIT_CAPABILITY_CACHE_FLUSH is set then
-- 
2.17.1


