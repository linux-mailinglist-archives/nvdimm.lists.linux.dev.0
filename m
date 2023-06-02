Return-Path: <nvdimm+bounces-6110-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6DF71FF46
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Jun 2023 12:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 885D81C20D98
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Jun 2023 10:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B0D18AF9;
	Fri,  2 Jun 2023 10:27:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E8D18AE5
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 10:27:18 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="97964625"
X-IronPort-AV: E=Sophos;i="6.00,212,1681138800"; 
   d="scan'208";a="97964625"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:27:08 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 98E4CC3F94
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 19:27:06 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id E5BF4C4A15
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 19:27:05 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id DD90630C425;
	Fri,  2 Jun 2023 19:27:04 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: kexec@lists.infradead.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	bhe@redhat.com,
	ruansy.fnst@fujitsu.com,
	y-goto@fujitsu.com,
	yangx.jy@fujitsu.com,
	Li Zhijian <lizhijian@fujitsu.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Subject: [RFC PATCH v3 2/3] x86/crash: Add pmem region into PT_LOADs of vmcore
Date: Fri,  2 Jun 2023 18:26:51 +0800
Message-Id: <20230602102656.131654-3-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230602102656.131654-1-lizhijian@fujitsu.com>
References: <20230602102656.131654-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27666.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27666.006
X-TMASE-Result: 10--8.329300-10.000000
X-TMASE-MatchedRID: SzbEz7SZt2uKi1hWqQY8Ws7ggHewVGq2wwrHF5pwze+fHrjLA9DhZkop
	D+RCCRBkWW2Dmwvfm8fHs1P4pGN3CkKry8ky4RfFrMZ+BqQt2NqDnmblFLAswsC5DTEMxpeQfiq
	1gj2xET/kizndBEr04aS6UDs/n0a68yMI2JjGZ9a628cXbnOhTxgff28UuvITQmw1cPfvj6kgfJ
	3S34h6EV+3LSA0WzRX64sVlliWKx8fE8yM4pjsDwtuKBGekqUpI/NGWt0UYPBTsAAS6F7IXbxSS
	Tr43YbG2CTYFQRbaau5CD61Mvm0FlqwxgxViRpo
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Only the region described by PT_LOADs of /proc/vmcore are dumpable/readble
by dumping applications. Previously, on x86/x86_64 only system ram resources
will be injected into PT_LOADs.
So in order to make the entire pmem resource is dumpable/readable, we need
to add pmem region into the PT_LOADs of /proc/vmcore.

Here we introduce a new API walk_pmem_res() to sort out the pmem region. Note
that, unlike other walk_xxx_res() API in resource.c, we walk through
pmem resources without IORESOUCE_BUSY flag.

This is kexec_file_load() specific, for kexec_load(), kexec-tools will have a
similar change.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Baoquan He <bhe@redhat.com>
CC: x86@kernel.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 arch/x86/kernel/crash.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index cdd92ab43cda..97763ea804c6 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -168,6 +168,17 @@ static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
 	return 0;
 }
 
+/*
+ * This function calls the @func callback against all memory ranges, which
+ * are ranges marked as IORESOURCE_MEM and IORES_DESC_PERSISTENT_MEMORY.
+ */
+static int walk_pmem_res(u64 start, u64 end, void *arg,
+			 int (*func)(struct resource *, void *))
+{
+	return walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY, IORESOURCE_MEM,
+				   start, end, arg, func);
+}
+
 /* Gather all the required information to prepare elf headers for ram regions */
 static struct crash_mem *fill_up_crash_elf_data(void)
 {
@@ -178,6 +189,7 @@ static struct crash_mem *fill_up_crash_elf_data(void)
 	if (!nr_ranges)
 		return NULL;
 
+	walk_pmem_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
 	/*
 	 * Exclusion of crash region and/or crashk_low_res may cause
 	 * another range split. So add extra two slots here.
@@ -243,6 +255,7 @@ static int prepare_elf_headers(struct kimage *image, void **addr,
 	ret = walk_system_ram_res(0, -1, cmem, prepare_elf64_ram_headers_callback);
 	if (ret)
 		goto out;
+	walk_pmem_res(0, -1, cmem, prepare_elf64_ram_headers_callback);
 
 	/* Exclude unwanted mem ranges */
 	ret = elf_header_exclude_ranges(cmem);
-- 
2.29.2


