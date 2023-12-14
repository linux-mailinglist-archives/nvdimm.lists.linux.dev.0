Return-Path: <nvdimm+bounces-7079-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E57D81298D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Dec 2023 08:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E249EB21233
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Dec 2023 07:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805C31426A;
	Thu, 14 Dec 2023 07:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iq9W8+Xj"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7112E79
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 07:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702539496; x=1734075496;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=VTyAcMOb3p9TMnLFpPQVGZqQ3IoF/IW/eEzVelz5aSE=;
  b=iq9W8+XjfK3U9yEpKOmYA04ZlXauH2jSJ8x8iXGU1QCDoDyjWZ+c5b4Z
   8cWTlYSvp9jv/Que7H/1hXKQAqcvVcvQTtcttM9rMlExDjL0L+hKGAUDb
   9VvtVqtXamyxY+NEUsPMvF+/R2a96B09MhhmDxWNT3Mri1JA0mvOtWd3c
   FNxu4AnrWz1eYKRUBRvwPFidi405uzQyMiRRflptRDk3+X0VFoxw5wcvP
   vxJrFPgo513Ww8bHD5/tuIOtjg3aM4G2YU1f1dc/iqYknhE7FO+d0TRbm
   BAbsPPEkY/i/BcBO9kEH0iIPF9iUC3Tg2iJFb4rPNWM9NyvtN8hZ6elWo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="481275526"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="481275526"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 23:38:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="723972068"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="723972068"
Received: from llblake-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.191.124])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 23:38:13 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 14 Dec 2023 00:37:56 -0700
Subject: [PATCH v5 3/4] mm/memory_hotplug: export
 mhp_supports_memmap_on_memory()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231214-vv-dax_abi-v5-3-3f7b006960b4@intel.com>
References: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
In-Reply-To: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4625;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=VTyAcMOb3p9TMnLFpPQVGZqQ3IoF/IW/eEzVelz5aSE=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKlVGx4pb98Uu1/qmbru9H/PH6bM1J0/7UV3iMK//UUCo
 ZtfqC/k7ihlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEUiMYGVbuX/Wr9FcXs9aM
 oDlX6jRyr1fI/1s065G+YX6fQ+ehP6sYGV4/iDWrnHaq9Xa2THW3oGnTxgemL7ds3qmhVXMi5Nu
 BHB4A
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


