Return-Path: <nvdimm+bounces-7093-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6790B814139
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Dec 2023 06:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB5451F2293A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Dec 2023 05:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90ED8DDD3;
	Fri, 15 Dec 2023 05:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SbKZ8Mi6"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75DA79DB
	for <nvdimm@lists.linux.dev>; Fri, 15 Dec 2023 05:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702617941; x=1734153941;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=sNbGEdgrAJp/XDJyFdtJon3rtI5vNIQSMJsEoh64H1k=;
  b=SbKZ8Mi6Shp3ZQl9acNXOUJVC4NsqMoCOMNRTaP5jnbHpNziF2qJ0Fdp
   SGJZkyECJnuA6djQqfyfSYX6QN8634KpxALMDSXFrM11wcRYIUcKoM99r
   ILMsxVCaU/DIRAtp1zFl6XR3JYMnZ6aWNgIPUwxE2rd6IsDJjPnnGZwd7
   Mi6dIAfEGDfdarQJreTHk+Fsyhf8MUAzLEy7kAKE/3m8xeJrDvawW0nQM
   hUtmcrsCcdYr0nT5Yc/CcQgBvZqgsp4y6+Xqtg+uoWgpgZArz0y/fDxiI
   580W7pIF+A1Jbj20n92o6NcLqD1F7XBwjrinnE2/PsXI3QKlwdhc/FUBI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="461695033"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="461695033"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 21:25:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="808847946"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="808847946"
Received: from mmtakalk-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.109.101])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 21:25:39 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 14 Dec 2023 22:25:28 -0700
Subject: [PATCH v6 3/4] mm/memory_hotplug: export
 mhp_supports_memmap_on_memory()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231214-vv-dax_abi-v6-3-ad900d698438@intel.com>
References: <20231214-vv-dax_abi-v6-0-ad900d698438@intel.com>
In-Reply-To: <20231214-vv-dax_abi-v6-0-ad900d698438@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, 
 Michal Hocko <mhocko@suse.com>
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4673;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=sNbGEdgrAJp/XDJyFdtJon3rtI5vNIQSMJsEoh64H1k=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKnVj/270n4d1C7Pn6OllvEj6eOC3R8OBFpMDgs02furb
 V3h077XHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIaUVGhqvHbgn7n1PPSKt8
 aNv1aHOVz+W7sd8qQ4V6SpzvsupvfMzwV6rjV/PTnz9mp3x8tmXRRvvOFYsvNPeVZ3jKPWjX1Zr
 qzQgA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for adding sysfs ABI to toggle memmap_on_memory semantics
for drivers adding memory, export the mhp_supports_memmap_on_memory()
helper. This allows drivers to check if memmap_on_memory support is
available before trying to request it, and display an appropriate
message if it isn't available. As part of this, remove the size argument
to this - with recent updates to allow memmap_on_memory for larger
ranges, and the internal splitting of altmaps into respective memory
blocks, the size argument is meaningless.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 include/linux/memory_hotplug.h |  6 ++++++
 mm/memory_hotplug.c            | 17 ++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7d2076583494..ebc9d528f00c 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -121,6 +121,7 @@ struct mhp_params {
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
 struct range mhp_get_pluggable_range(bool need_mapping);
+bool mhp_supports_memmap_on_memory(void);
 
 /*
  * Zone resizing functions
@@ -262,6 +263,11 @@ static inline bool movable_node_is_enabled(void)
 	return false;
 }
 
+static bool mhp_supports_memmap_on_memory(void)
+{
+	return false;
+}
+
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_lock_init(pg_data_t *pgdat) {}
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 926e1cfb10e9..751664c519f7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1325,7 +1325,7 @@ static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 }
 #endif
 
-static bool mhp_supports_memmap_on_memory(unsigned long size)
+bool mhp_supports_memmap_on_memory(void)
 {
 	unsigned long vmemmap_size = memory_block_memmap_size();
 	unsigned long memmap_pages = memory_block_memmap_on_memory_pages();
@@ -1334,17 +1334,11 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
 	 * Besides having arch support and the feature enabled at runtime, we
 	 * need a few more assumptions to hold true:
 	 *
-	 * a) We span a single memory block: memory onlining/offlinin;g happens
-	 *    in memory block granularity. We don't want the vmemmap of online
-	 *    memory blocks to reside on offline memory blocks. In the future,
-	 *    we might want to support variable-sized memory blocks to make the
-	 *    feature more versatile.
-	 *
-	 * b) The vmemmap pages span complete PMDs: We don't want vmemmap code
+	 * a) The vmemmap pages span complete PMDs: We don't want vmemmap code
 	 *    to populate memory from the altmap for unrelated parts (i.e.,
 	 *    other memory blocks)
 	 *
-	 * c) The vmemmap pages (and thereby the pages that will be exposed to
+	 * b) The vmemmap pages (and thereby the pages that will be exposed to
 	 *    the buddy) have to cover full pageblocks: memory onlining/offlining
 	 *    code requires applicable ranges to be page-aligned, for example, to
 	 *    set the migratetypes properly.
@@ -1356,7 +1350,7 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
 	 *       altmap as an alternative source of memory, and we do not exactly
 	 *       populate a single PMD.
 	 */
-	if (!mhp_memmap_on_memory() || size != memory_block_size_bytes())
+	if (!mhp_memmap_on_memory())
 		return false;
 
 	/*
@@ -1379,6 +1373,7 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
 
 	return arch_supports_memmap_on_memory(vmemmap_size);
 }
+EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
 static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
@@ -1512,7 +1507,7 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	 * Self hosted memmap array
 	 */
 	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
-	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
+	    mhp_supports_memmap_on_memory()) {
 		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
 		if (ret)
 			goto error;

-- 
2.41.0


