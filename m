Return-Path: <nvdimm+bounces-6380-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7EE75A783
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jul 2023 09:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71D4E1C212EB
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jul 2023 07:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110EF171AF;
	Thu, 20 Jul 2023 07:14:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89C171A1
	for <nvdimm@lists.linux.dev>; Thu, 20 Jul 2023 07:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689837273; x=1721373273;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=k4XpCfq0ZxU/xUvbPf7nQuvL2vPIJUVSa8ob3/AsbKg=;
  b=IcGN5VpMwNNlzRNLcLRoBnOjw9uwnroVKWzjaiR4qqlMd43jDA0Sy9QZ
   auEsoSQCbR2O9DLV0ukjN9/gwozT8wja5qkbsojZu/L1bIJ1sro3QFhBK
   /0q/7QJZMxRj3M2kbwBq5LmzWfj1ay2H7MMG2hFJWkX0HvR4/OdTm0w/f
   d0K894rABZ99Hj1atgiFCJB8XY9p4Mjhrq//y6jkzwC4WaB4yx1tCiHtp
   iymFNP/Q+CJL4AXl3LEcKfAZzeg2ZFryrvU45vQbQ4U+P7IR3x2q7fI2l
   /t6YnKGnd9KfSaiMBm+sPN6WuOQ4bYaI86gPgKrMIiUbDDc3F5m8jfhsz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="430424010"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="430424010"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 00:14:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="794334967"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="794334967"
Received: from mfgalan-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.172.204])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 00:14:29 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 20 Jul 2023 01:14:23 -0600
Subject: [PATCH v2 2/3] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230720-vv-kmem_memmap-v2-2-88bdaab34993@intel.com>
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
In-Reply-To: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7769;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=k4XpCfq0ZxU/xUvbPf7nQuvL2vPIJUVSa8ob3/AsbKg=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCk77l1RLYhbXWCzitdb+8Lhnk2Tb7DpHwm7w/ZyWs22J
 ZYZZ1KEO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRdbcY/ueUHputFtleKatx
 u6V+w0y1WofLhnM4luy4NinkuyBXswXDX9FDsx8wlRm5XmgKW2f8xVBd7s+bqcw/30wwLHTduvi
 AJBMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is currently
restricted to 'memblock_size' chunks of memory being added. Adding a
larger span of memory precludes memmap_on_memory semantics.

For users of hotplug such as kmem, large amounts of memory might get
added from the CXL subsystem. In some cases, this amount may exceed the
available 'main memory' to store the memmap for the memory being added.
In this case, it is useful to have a way to place the memmap on the
memory being added, even if it means splitting the addition into
memblock-sized chunks.

Change add_memory_resource() to loop over memblock-sized chunks of
memory if caller requested memmap_on_memory, and if other conditions for
it are met,. Teach try_remove_memory() to also expect that a memory
range being removed might have been split up into memblock sized chunks,
and to loop through those as needed.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 mm/memory_hotplug.c | 154 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 91 insertions(+), 63 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e9bcacbcbae2..20456f0d28e6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1286,6 +1286,35 @@ bool mhp_supports_memmap_on_memory(unsigned long size)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
+static int add_memory_create_devices(int nid, struct memory_group *group,
+				     u64 start, u64 size, mhp_t mhp_flags)
+{
+	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	struct vmem_altmap mhp_altmap = {};
+	int ret;
+
+	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY)) {
+		mhp_altmap.free = PHYS_PFN(size);
+		mhp_altmap.base_pfn = PHYS_PFN(start);
+		params.altmap = &mhp_altmap;
+	}
+
+	/* call arch's memory hotadd */
+	ret = arch_add_memory(nid, start, size, &params);
+	if (ret < 0)
+		return ret;
+
+	/* create memory block devices after memory was added */
+	ret = create_memory_block_devices(start, size, mhp_altmap.alloc,
+					  group);
+	if (ret) {
+		arch_remove_memory(start, size, NULL);
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1294,11 +1323,10 @@ EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
  */
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
-	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	unsigned long memblock_size = memory_block_size_bytes();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
-	struct vmem_altmap mhp_altmap = {};
 	struct memory_group *group = NULL;
-	u64 start, size;
+	u64 start, size, cur_start;
 	bool new_node = false;
 	int ret;
 
@@ -1339,27 +1367,20 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	/*
 	 * Self hosted memmap array
 	 */
-	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
-		if (!mhp_supports_memmap_on_memory(size)) {
-			ret = -EINVAL;
+	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
+	    mhp_supports_memmap_on_memory(memblock_size)) {
+		for (cur_start = start; cur_start < start + size;
+		     cur_start += memblock_size) {
+			ret = add_memory_create_devices(nid, group, cur_start,
+							memblock_size,
+							mhp_flags);
+			if (ret)
+				goto error;
+		}
+	} else {
+		ret = add_memory_create_devices(nid, group, start, size, mhp_flags);
+		if (ret)
 			goto error;
-		}
-		mhp_altmap.free = PHYS_PFN(size);
-		mhp_altmap.base_pfn = PHYS_PFN(start);
-		params.altmap = &mhp_altmap;
-	}
-
-	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size, &params);
-	if (ret < 0)
-		goto error;
-
-	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size, mhp_altmap.alloc,
-					  group);
-	if (ret) {
-		arch_remove_memory(start, size, NULL);
-		goto error;
 	}
 
 	if (new_node) {
@@ -2035,12 +2056,38 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
-static int __ref try_remove_memory(u64 start, u64 size)
+static void __ref __try_remove_memory(int nid, u64 start, u64 size,
+				     struct vmem_altmap *altmap)
 {
-	struct vmem_altmap mhp_altmap = {};
-	struct vmem_altmap *altmap = NULL;
-	unsigned long nr_vmemmap_pages;
-	int rc = 0, nid = NUMA_NO_NODE;
+	/* remove memmap entry */
+	firmware_map_remove(start, start + size, "System RAM");
+
+	/*
+	 * Memory block device removal under the device_hotplug_lock is
+	 * a barrier against racing online attempts.
+	 */
+	remove_memory_block_devices(start, size);
+
+	mem_hotplug_begin();
+
+	arch_remove_memory(start, size, altmap);
+
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		memblock_phys_free(start, size);
+		memblock_remove(start, size);
+	}
+
+	release_mem_region_adjustable(start, size);
+
+	if (nid != NUMA_NO_NODE)
+		try_offline_node(nid);
+
+	mem_hotplug_done();
+}
+
+static int try_remove_memory(u64 start, u64 size)
+{
+	int rc, nid = NUMA_NO_NODE;
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
@@ -2058,20 +2105,21 @@ static int __ref try_remove_memory(u64 start, u64 size)
 		return rc;
 
 	/*
-	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
-	 * the same granularity it was added - a single memory block.
+	 * For memmap_on_memory, the altmaps could have been added on
+	 * a per-memblock basis. Loop through the entire range if so,
+	 * and remove each memblock and its altmap
 	 */
 	if (mhp_memmap_on_memory()) {
-		nr_vmemmap_pages = walk_memory_blocks(start, size, NULL,
-						      get_nr_vmemmap_pages_cb);
-		if (nr_vmemmap_pages) {
-			if (size != memory_block_size_bytes()) {
-				pr_warn("Refuse to remove %#llx - %#llx,"
-					"wrong granularity\n",
-					start, start + size);
-				return -EINVAL;
-			}
+		unsigned long memblock_size = memory_block_size_bytes();
+		struct vmem_altmap mhp_altmap = {};
+		struct vmem_altmap *altmap;
+		u64 cur_start;
 
+		for (cur_start = start; cur_start < start + size;
+		     cur_start += memblock_size) {
+			unsigned long nr_vmemmap_pages =
+				walk_memory_blocks(start, memblock_size, NULL,
+						   get_nr_vmemmap_pages_cb);
 			/*
 			 * Let remove_pmd_table->free_hugepage_table do the
 			 * right thing if we used vmem_altmap when hot-adding
@@ -2079,33 +2127,13 @@ static int __ref try_remove_memory(u64 start, u64 size)
 			 */
 			mhp_altmap.alloc = nr_vmemmap_pages;
 			altmap = &mhp_altmap;
+			__try_remove_memory(nid, cur_start, memblock_size,
+						 altmap);
 		}
+	} else {
+		__try_remove_memory(nid, start, size, NULL);
 	}
 
-	/* remove memmap entry */
-	firmware_map_remove(start, start + size, "System RAM");
-
-	/*
-	 * Memory block device removal under the device_hotplug_lock is
-	 * a barrier against racing online attempts.
-	 */
-	remove_memory_block_devices(start, size);
-
-	mem_hotplug_begin();
-
-	arch_remove_memory(start, size, altmap);
-
-	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		memblock_phys_free(start, size);
-		memblock_remove(start, size);
-	}
-
-	release_mem_region_adjustable(start, size);
-
-	if (nid != NUMA_NO_NODE)
-		try_offline_node(nid);
-
-	mem_hotplug_done();
 	return 0;
 }
 

-- 
2.41.0


