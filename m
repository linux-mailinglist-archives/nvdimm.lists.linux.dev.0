Return-Path: <nvdimm+bounces-8615-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03376944373
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Aug 2024 08:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 785D61F2357B
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Aug 2024 06:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94DB16F91D;
	Thu,  1 Aug 2024 06:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lobL3BnM"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1016B15748B;
	Thu,  1 Aug 2024 06:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722492633; cv=none; b=GOTinUvTYA7FiUKj7FMJpyxvm2k+ZywcZZDy3SOsNOXADOqbEQ2C7TW+/Ukv/zjRnu6SFaYJ0Z563EdWgo/HCO622CB8kRFLeIFxOw3jy+39oMk3is2GUYSZusxpx9Ee3dIKHNLGZhVt/+leDkur/p0b8zpt8di8ZxdGRmmxcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722492633; c=relaxed/simple;
	bh=M/jYHd7+70Yn3Ls9O55R+dDWEJ+Dj73xIHNTwCldMLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHOArxXlDRu8T6k+Jf7bReXNKzR7gZCEMdKlih2DeL3S1s3nv+TAsHHf2WNftSCjjlyYSw+Z58ENJggUTiUhoLylRIQCJ5JoikC2vbDYvwnleGSLVPabdzbI5Ppim/125OzvomWdjakzJoiLotcTWhK9mvzK1PUn/JsQtRtBqhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lobL3BnM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4287CC4AF0D;
	Thu,  1 Aug 2024 06:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722492632;
	bh=M/jYHd7+70Yn3Ls9O55R+dDWEJ+Dj73xIHNTwCldMLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lobL3BnM6c0xUSDE/gmQjqGCSw8foPLZVeo/NqQGptvjCBs0CojEBbM5yOHo2j+aQ
	 C280b1MW1QsteD4Ix5pl+2lhaQ+XLtVM08fbLP1K+hBhpRRq6swIJG6YHeNhAjdnms
	 ch7cxpXn3X3djchL2x0KfD+Bf2Si42dLA9NqaBmFIs3VhvBo8ZVTa0kw/jUKs+fc8t
	 rpigYlgV6IJUNN4UjhtvhLvSASsiID2KsgGPMx8bhBhSDRmJvfFpSKmsLkKRzZLNsu
	 ZdaxIPHAXeoK8nW7bGDairHDEi/zUsyBohOU7c6IkMNBpuGosnlFSdRH4lwb/W2FNs
	 wJ6HDjot6JSGA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	nvdimm@lists.linux.dev,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v3 09/26] arch, mm: pull out allocation of NODE_DATA to generic code
Date: Thu,  1 Aug 2024 09:08:09 +0300
Message-ID: <20240801060826.559858-10-rppt@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801060826.559858-1-rppt@kernel.org>
References: <20240801060826.559858-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Architectures that support NUMA duplicate the code that allocates
NODE_DATA on the node-local memory with slight variations in reporting
of the addresses where the memory was allocated.

Use x86 version as the basis for the generic alloc_node_data() function
and call this function in architecture specific numa initialization.

Round up node data size to SMP_CACHE_BYTES rather than to PAGE_SIZE like
x86 used to do since the bootmem era when allocation granularity was
PAGE_SIZE anyway.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
---
 arch/loongarch/kernel/numa.c | 18 ------------------
 arch/mips/loongson64/numa.c  | 16 ++--------------
 arch/powerpc/mm/numa.c       | 24 +++---------------------
 arch/sh/mm/init.c            |  7 +------
 arch/sparc/mm/init_64.c      |  9 ++-------
 arch/x86/mm/numa.c           | 34 +---------------------------------
 drivers/base/arch_numa.c     | 21 +--------------------
 include/linux/numa.h         |  2 ++
 mm/numa.c                    | 27 +++++++++++++++++++++++++++
 9 files changed, 39 insertions(+), 119 deletions(-)

diff --git a/arch/loongarch/kernel/numa.c b/arch/loongarch/kernel/numa.c
index acada671e020..84fe7f854820 100644
--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -187,24 +187,6 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-static void __init alloc_node_data(int nid)
-{
-	void *nd;
-	unsigned long nd_pa;
-	size_t nd_sz = roundup(sizeof(pg_data_t), PAGE_SIZE);
-
-	nd_pa = memblock_phys_alloc_try_nid(nd_sz, SMP_CACHE_BYTES, nid);
-	if (!nd_pa) {
-		pr_err("Cannot find %zu Byte for node_data (initial node: %d)\n", nd_sz, nid);
-		return;
-	}
-
-	nd = __va(nd_pa);
-
-	node_data[nid] = nd;
-	memset(nd, 0, sizeof(pg_data_t));
-}
-
 static void __init node_mem_init(unsigned int node)
 {
 	unsigned long start_pfn, end_pfn;
diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
index d56238745744..8388400d052f 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -81,12 +81,8 @@ static void __init init_topology_matrix(void)
 
 static void __init node_mem_init(unsigned int node)
 {
-	struct pglist_data *nd;
 	unsigned long node_addrspace_offset;
 	unsigned long start_pfn, end_pfn;
-	unsigned long nd_pa;
-	int tnid;
-	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
 
 	node_addrspace_offset = nid_to_addrbase(node);
 	pr_info("Node%d's addrspace_offset is 0x%lx\n",
@@ -96,16 +92,8 @@ static void __init node_mem_init(unsigned int node)
 	pr_info("Node%d: start_pfn=0x%lx, end_pfn=0x%lx\n",
 		node, start_pfn, end_pfn);
 
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, node);
-	if (!nd_pa)
-		panic("Cannot allocate %zu bytes for node %d data\n",
-		      nd_size, node);
-	nd = __va(nd_pa);
-	memset(nd, 0, sizeof(struct pglist_data));
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != node)
-		pr_info("NODE_DATA(%d) on node %d\n", node, tnid);
-	node_data[node] = nd;
+	alloc_node_data(node);
+
 	NODE_DATA(node)->node_start_pfn = start_pfn;
 	NODE_DATA(node)->node_spanned_pages = end_pfn - start_pfn;
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 0744a9a2944b..3c1da08304d0 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1093,27 +1093,9 @@ void __init dump_numa_cpu_topology(void)
 static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
 {
 	u64 spanned_pages = end_pfn - start_pfn;
-	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
-	u64 nd_pa;
-	void *nd;
-	int tnid;
-
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
-	if (!nd_pa)
-		panic("Cannot allocate %zu bytes for node %d data\n",
-		      nd_size, nid);
-
-	nd = __va(nd_pa);
-
-	/* report and initialize */
-	pr_info("  NODE_DATA [mem %#010Lx-%#010Lx]\n",
-		nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		pr_info("    NODE_DATA(%d) on node %d\n", nid, tnid);
-
-	node_data[nid] = nd;
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
+
+	alloc_node_data(nid);
+
 	NODE_DATA(nid)->node_id = nid;
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = spanned_pages;
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index d1fe90b2f5ff..2a88b0c9e70f 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -212,12 +212,7 @@ void __init allocate_pgdat(unsigned int nid)
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 
 #ifdef CONFIG_NUMA
-	NODE_DATA(nid) = memblock_alloc_try_nid(
-				sizeof(struct pglist_data),
-				SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
-				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-	if (!NODE_DATA(nid))
-		panic("Can't allocate pgdat for node %d\n", nid);
+	alloc_node_data(nid);
 #endif
 
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index c6c7f43cb1e8..21f8cbbd0581 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1075,14 +1075,9 @@ static void __init allocate_node_data(int nid)
 {
 	struct pglist_data *p;
 	unsigned long start_pfn, end_pfn;
-#ifdef CONFIG_NUMA
 
-	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
-					     SMP_CACHE_BYTES, nid);
-	if (!NODE_DATA(nid)) {
-		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
-		prom_halt();
-	}
+#ifdef CONFIG_NUMA
+	alloc_node_data(nid);
 
 	NODE_DATA(nid)->node_id = nid;
 #endif
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 7de725d6bb05..5e1dde26674b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -191,39 +191,6 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-/* Allocate NODE_DATA for a node on the local memory */
-static void __init alloc_node_data(int nid)
-{
-	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	u64 nd_pa;
-	void *nd;
-	int tnid;
-
-	/*
-	 * Allocate node data.  Try node-local memory and then any node.
-	 * Never allocate in DMA zone.
-	 */
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
-	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in any node (initial node: %d)\n",
-		       nd_size, nid);
-		return;
-	}
-	nd = __va(nd_pa);
-
-	/* report and initialize */
-	printk(KERN_INFO "NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
-	       nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
-
-	node_data[nid] = nd;
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
-
-	node_set_online(nid);
-}
-
 /**
  * numa_cleanup_meminfo - Cleanup a numa_meminfo
  * @mi: numa_meminfo to clean up
@@ -571,6 +538,7 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 			continue;
 
 		alloc_node_data(nid);
+		node_set_online(nid);
 	}
 
 	/* Dump memblock with node info and return. */
diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index ceac5b59bf2b..b6af7475ec44 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -216,30 +216,11 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
  */
 static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
 {
-	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
-	u64 nd_pa;
-	void *nd;
-	int tnid;
-
 	if (start_pfn >= end_pfn)
 		pr_info("Initmem setup node %d [<memory-less node>]\n", nid);
 
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
-	if (!nd_pa)
-		panic("Cannot allocate %zu bytes for node %d data\n",
-		      nd_size, nid);
-
-	nd = __va(nd_pa);
-
-	/* report and initialize */
-	pr_info("NODE_DATA [mem %#010Lx-%#010Lx]\n",
-		nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		pr_info("NODE_DATA(%d) on node %d\n", nid, tnid);
+	alloc_node_data(nid);
 
-	node_data[nid] = nd;
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 	NODE_DATA(nid)->node_id = nid;
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
diff --git a/include/linux/numa.h b/include/linux/numa.h
index e5841d4057ab..3b12d8ca0afd 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -33,6 +33,8 @@ static inline bool numa_valid_node(int nid)
 extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)	(node_data[nid])
 
+void __init alloc_node_data(int nid);
+
 /* Generic implementation available */
 int numa_nearest_node(int node, unsigned int state);
 
diff --git a/mm/numa.c b/mm/numa.c
index 8c157d41c026..67a0d7734a98 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -1,11 +1,38 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include <linux/memblock.h>
 #include <linux/printk.h>
 #include <linux/numa.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
 
+/* Allocate NODE_DATA for a node on the local memory */
+void __init alloc_node_data(int nid)
+{
+	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
+	u64 nd_pa;
+	void *nd;
+	int tnid;
+
+	/* Allocate node data.  Try node-local memory and then any node. */
+	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
+	if (!nd_pa)
+		panic("Cannot allocate %zu bytes for node %d data\n",
+		      nd_size, nid);
+	nd = __va(nd_pa);
+
+	/* report and initialize */
+	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
+		nd_pa, nd_pa + nd_size - 1);
+	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
+	if (tnid != nid)
+		pr_info("    NODE_DATA(%d) on node %d\n", nid, tnid);
+
+	node_data[nid] = nd;
+	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
+}
+
 /* Stub functions: */
 
 #ifndef memory_add_physaddr_to_nid
-- 
2.43.0


