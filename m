Return-Path: <nvdimm+bounces-5135-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9064D628897
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Nov 2022 19:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83CD31C20959
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Nov 2022 18:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFA3846D;
	Mon, 14 Nov 2022 18:50:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E856579FD
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668451851; x=1699987851;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GdDop3Zb517gVHlWLT6nRTwUKcnJ2dCYJ+r/uzuNVIM=;
  b=jeVBzP4I73HMyUI8VUrfrwi8QQ/rBy7w1Nz8coQUcneQPWccub8RXwU3
   ojjXbkCbnh3hDHHckgSk1WHiuRCISi5xu5TR/SAuGYZy6kFJnWpeJHWJR
   MQTCSlVkGdj/l8d6tKVBYKrce01OX31Hn4xOsmQkL9F3PhXT+clgmZwgO
   ZZviQGHiSDsx8ab/DKLVJ92vVQpwypGQOKmcqqNTWcAnktHtXALXbXE/B
   k2dalqO5T3rzWTK3VhNLzuEbumsPuH2u6UrybXxOXe5r4XOLIm17s3P6r
   Cext3F9dYEFsqg3cYUAqJj+EZGlvOIkJUY0B6Xu1Nk4HO+rV2a/Nh1hvV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292450261"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="292450261"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 10:50:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="727639068"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="727639068"
Received: from shahr-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.78.174])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 10:50:50 -0800
Subject: [PATCH v6] memregion: Add cpu_cache_invalidate_memregion() interface
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Dave Jiang <dave.jiang@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Dave Hansen <dave.hansen@linux.intel.com>,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Mon, 14 Nov 2022 10:50:49 -0800
Message-ID: <166845177597.1351848.15454720528892170333.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166698148737.3132474.5901874516011784201.stgit@dwillia2-xfh.jf.intel.com>
References: <166698148737.3132474.5901874516011784201.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Davidlohr Bueso <dave@stgolabs.net>

With CXL security features, and CXL dynamic provisioning, global CPU
cache flushing nvdimm requirements are no longer specific to that
subsystem, even beyond the scope of security_ops. CXL will need such
semantics for features not necessarily limited to persistent memory.

The functionality this is enabling is to be able to instantaneously
secure erase potentially terabytes of memory at once and the kernel
needs to be sure that none of the data from before the erase is still
present in the cache. It is also used when unlocking a memory device
where speculative reads and firmware accesses could have cached poison
from before the device was unlocked. Lastly this facility is used when
mapping new devices, or new capacity into an established physical
address range. I.e. when the driver switches DeviceA mapping AddressX to
DeviceB mapping AddressX then any cached data from DeviceA:AddressX
needs to be invalidated.

This capability is typically only used once per-boot (for unlock), or
once per bare metal provisioning event (secure erase), like when handing
off the system to another tenant or decommissioning a device. It may
also be used for dynamic CXL region provisioning.

Users must first call cpu_cache_has_invalidate_memregion() to know
whether this functionality is available on the architecture. On x86 this
respects the constraints of when wbinvd() is tolerable. It is already
the case that wbinvd() is problematic to allow in VMs due its global
performance impact and KVM, for example, has been known to just trap and
ignore the call. With confidential computing guest execution of wbinvd()
may even trigger an exception. Given guests should not be messing with
the bare metal address map via CXL configuration changes
cpu_cache_has_invalidate_memregion() returns false in VMs.

While this global cache invalidation facility, is exported to modules,
since NVDIMM and CXL support can be built as a module, it is not for
general use. The intent is that this facility is not available outside
of specific "device-memory" use cases. To make that expectation as clear
as possible the API is scoped to a new "DEVMEM" module namespace that
only the NVDIMM and CXL subsystems are expected to import.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v5 [1]:
- A collection of build fixed reported by the 0day build robot

[1]: http://lore.kernel.org/r/166698148737.3132474.5901874516011784201.stgit@dwillia2-xfh.jf.intel.com

 arch/x86/Kconfig             |    1 +
 arch/x86/mm/pat/set_memory.c |   18 ++++++++++++++++++
 drivers/acpi/nfit/intel.c    |   43 ++++++++++++++++++++----------------------
 include/linux/memregion.h    |   38 +++++++++++++++++++++++++++++++++++++
 lib/Kconfig                  |    3 +++
 5 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 67745ceab0db..e16b2b15d67e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,6 +69,7 @@ config X86
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
+	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2e5a045731de..ef34ba21aa92 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
+#include <linux/memregion.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -330,6 +331,23 @@ void arch_invalidate_pmem(void *addr, size_t size)
 EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
 #endif
 
+#ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+bool cpu_cache_has_invalidate_memregion(void)
+{
+	return !cpu_feature_enabled(X86_FEATURE_HYPERVISOR);
+}
+EXPORT_SYMBOL_NS_GPL(cpu_cache_has_invalidate_memregion, DEVMEM);
+
+int cpu_cache_invalidate_memregion(int res_desc)
+{
+	if (WARN_ON_ONCE(!cpu_cache_has_invalidate_memregion()))
+		return -ENXIO;
+	wbinvd_on_all_cpus();
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cpu_cache_invalidate_memregion, DEVMEM);
+#endif
+
 static void __cpa_flush_all(void *arg)
 {
 	unsigned long cache = (unsigned long)arg;
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 8dd792a55730..fa0e57e35162 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -3,6 +3,7 @@
 #include <linux/libnvdimm.h>
 #include <linux/ndctl.h>
 #include <linux/acpi.h>
+#include <linux/memregion.h>
 #include <asm/smp.h>
 #include "intel.h"
 #include "nfit.h"
@@ -190,8 +191,6 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 	}
 }
 
-static void nvdimm_invalidate_cache(void);
-
 static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key_data)
 {
@@ -213,6 +212,9 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
 	memcpy(nd_cmd.cmd.passphrase, key_data->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -228,7 +230,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 	}
 
 	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 
 	return 0;
 }
@@ -297,8 +299,11 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
 	/* flush all cache before we erase DIMM */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	memcpy(nd_cmd.cmd.passphrase, key->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -318,7 +323,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 	}
 
 	/* DIMM erased, invalidate all CPU caches before we read it */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	return 0;
 }
 
@@ -341,6 +346,9 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
 	if (rc < 0)
 		return rc;
@@ -355,7 +363,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 	}
 
 	/* flush all cache before we make the nvdimms available */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	return 0;
 }
 
@@ -380,8 +388,11 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
 	/* flush all cache before we erase DIMM */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -401,22 +412,6 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 	}
 }
 
-/*
- * TODO: define a cross arch wbinvd equivalent when/if
- * NVDIMM_FAMILY_INTEL command support arrives on another arch.
- */
-#ifdef CONFIG_X86
-static void nvdimm_invalidate_cache(void)
-{
-	wbinvd_on_all_cpus();
-}
-#else
-static void nvdimm_invalidate_cache(void)
-{
-	WARN_ON_ONCE("cache invalidation required after unlock\n");
-}
-#endif
-
 static const struct nvdimm_security_ops __intel_security_ops = {
 	.get_flags = intel_security_flags,
 	.freeze = intel_security_freeze,
@@ -775,3 +770,5 @@ static const struct nvdimm_fw_ops __intel_fw_ops = {
 };
 
 const struct nvdimm_fw_ops *intel_fw_ops = &__intel_fw_ops;
+
+MODULE_IMPORT_NS(DEVMEM);
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index c04c4fd2e209..bf83363807ac 100644
--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -3,6 +3,7 @@
 #define _MEMREGION_H_
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/bug.h>
 
 struct memregion_info {
 	int target_node;
@@ -20,4 +21,41 @@ static inline void memregion_free(int id)
 {
 }
 #endif
+
+/**
+ * cpu_cache_invalidate_memregion - drop any CPU cached data for
+ *     memregions described by @res_desc
+ * @res_desc: one of the IORES_DESC_* types
+ *
+ * Perform cache maintenance after a memory event / operation that
+ * changes the contents of physical memory in a cache-incoherent manner.
+ * For example, device memory technologies like NVDIMM and CXL have
+ * device secure erase, and dynamic region provision that can replace
+ * the memory mapped to a given physical address.
+ *
+ * Limit the functionality to architectures that have an efficient way
+ * to writeback and invalidate potentially terabytes of address space at
+ * once.  Note that this routine may or may not write back any dirty
+ * contents while performing the invalidation. It is only exported for
+ * the explicit usage of the NVDIMM and CXL modules in the 'DEVMEM'
+ * symbol namespace on bare platforms.
+ *
+ * Returns 0 on success or negative error code on a failure to perform
+ * the cache maintenance.
+ */
+#ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+int cpu_cache_invalidate_memregion(int res_desc);
+bool cpu_cache_has_invalidate_memregion(void);
+#else
+static inline bool cpu_cache_has_invalidate_memregion(void)
+{
+	return false;
+}
+
+static inline int cpu_cache_invalidate_memregion(int res_desc)
+{
+	WARN_ON_ONCE("CPU cache invalidation required");
+	return -ENXIO;
+}
+#endif
 #endif /* _MEMREGION_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 9bbf8a4b2108..9eb514abcdec 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -672,6 +672,9 @@ config ARCH_HAS_PMEM_API
 config MEMREGION
 	bool
 
+config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+	bool
+
 config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
 	bool
 


