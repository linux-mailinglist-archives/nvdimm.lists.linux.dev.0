Return-Path: <nvdimm+bounces-6114-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BA871FF4C
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Jun 2023 12:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53D551C20EEC
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Jun 2023 10:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10A018AFC;
	Fri,  2 Jun 2023 10:28:24 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A2B18AEF
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 10:28:22 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="119220281"
X-IronPort-AV: E=Sophos;i="6.00,212,1681138800"; 
   d="scan'208";a="119220281"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:27:11 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id D5463DDC60
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 19:27:08 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 09470D88D2
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 19:27:08 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 0034040FE2;
	Fri,  2 Jun 2023 19:27:06 +0900 (JST)
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
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>
Subject: [RFC PATCH makedumpfile v3 1/3] elf_info.c: Introduce is_pmem_pt_load_range
Date: Fri,  2 Jun 2023 18:26:54 +0800
Message-Id: <20230602102656.131654-6-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--6.061400-10.000000
X-TMASE-MatchedRID: uYOEf1I6Oo115zj/0di3Q+6bo2/Lq3c20MQw+++ihy86FHRWx2FGsL8F
	Hrw7frluf146W0iUu2uMQUNNVv3RZFsSYoQIc1cjSHCU59h5KrHjLrHqvAiSy0/cRvj5stP609D
	6Rw2zIrP6Ss9HyBHBXv2MF5HVqqgBYwDOL7t3RyGeAiCmPx4NwBnUJ0Ek6yhjxEHRux+uk8h+IC
	quNi0WJEs4O5JlDkki+KxOPxgcX3fuuoHGzHNMZnPOHbXzO9lIftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It checks BIT(4) of Elf64_Phdr, currently only the former 3 bits are used
by ELF. In kexec-tool, we extend the BIT(4) to indicate pmem or not.

dump_Elf_load:                phys_start         phys_end       virt_start         virt_end  is_pmem
dump_Elf_load: LOAD[ 0]         6b800000         6e42c000 ffffffffbcc00000 ffffffffbf82c000    false
dump_Elf_load: LOAD[ 1]             1000            9fc00 ffff975980001000 ffff97598009fc00    false
dump_Elf_load: LOAD[ 2]           100000         7f000000 ffff975980100000 ffff9759ff000000    false
dump_Elf_load: LOAD[ 3]         bf000000         bffd7000 ffff975a3f000000 ffff975a3ffd7000    false
dump_Elf_load: LOAD[ 4]        100000000        140000000 ffff975a80000000 ffff975ac0000000    false
dump_Elf_load: LOAD[ 5]        140000000        23e200000 ffff975ac0000000 ffff975bbe200000     true

CC: Baoquan He <bhe@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Dave Young <dyoung@redhat.com>
CC: kexec@lists.infradead.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 elf_info.c | 31 +++++++++++++++++++++++++++----
 elf_info.h |  1 +
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/elf_info.c b/elf_info.c
index bc24083655d6..41b36b2804d2 100644
--- a/elf_info.c
+++ b/elf_info.c
@@ -43,6 +43,7 @@ struct pt_load_segment {
 	unsigned long long	phys_end;
 	unsigned long long	virt_start;
 	unsigned long long	virt_end;
+	int			is_pmem;
 };
 
 static int			nr_cpus;             /* number of cpu */
@@ -153,6 +154,8 @@ check_elf_format(int fd, char *filename, int *phnum, unsigned int *num_load)
 	return FALSE;
 }
 
+#define PF_DEV (1 << 4)
+
 static int
 dump_Elf_load(Elf64_Phdr *prog, int num_load)
 {
@@ -170,17 +173,37 @@ dump_Elf_load(Elf64_Phdr *prog, int num_load)
 	pls->virt_end    = pls->virt_start + prog->p_memsz;
 	pls->file_offset = prog->p_offset;
 	pls->file_size   = prog->p_filesz;
+	pls->is_pmem     = !!(prog->p_flags & PF_DEV);
 
 	if (num_load == 0)
-		DEBUG_MSG("%8s %16s %16s %16s %16s\n", "",
-			"phys_start", "phys_end", "virt_start", "virt_end");
+		DEBUG_MSG("%8s %16s %16s %16s %16s %8s\n", "",
+			"phys_start", "phys_end", "virt_start", "virt_end",
+			"is_pmem");
 
-	DEBUG_MSG("LOAD[%2d] %16llx %16llx %16llx %16llx\n", num_load,
-		pls->phys_start, pls->phys_end, pls->virt_start, pls->virt_end);
+	DEBUG_MSG("LOAD[%2d] %16llx %16llx %16llx %16llx %8s\n", num_load,
+		pls->phys_start, pls->phys_end, pls->virt_start, pls->virt_end,
+		pls->is_pmem ? "true": "false");
 
 	return TRUE;
 }
 
+int is_pmem_pt_load_range(unsigned long long start, unsigned long long end)
+{
+	int i;
+	struct pt_load_segment *pls;
+
+	for (i = 0; i < num_pt_loads; i++) {
+		pls = &pt_loads[i];
+		if (pls->is_pmem && pls->phys_start == NOT_PADDR)
+			return TRUE;
+		if (pls->is_pmem && pls->phys_start != NOT_PADDR &&
+		    pls->phys_start <= start && pls->phys_end >= end)
+			return TRUE;
+	}
+
+	return FALSE;
+}
+
 static off_t
 offset_next_note(void *note)
 {
diff --git a/elf_info.h b/elf_info.h
index d5416b32cdd7..a08d59a331f6 100644
--- a/elf_info.h
+++ b/elf_info.h
@@ -64,6 +64,7 @@ int get_pt_load_extents(int idx,
 	off_t *file_offset,
 	off_t *file_size);
 unsigned int get_num_pt_loads(void);
+int is_pmem_pt_load_range(unsigned long long start, unsigned long long end);
 
 void set_nr_cpus(int num);
 int get_nr_cpus(void);
-- 
2.29.2


