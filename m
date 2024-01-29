Return-Path: <nvdimm+bounces-7226-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55EF58414E2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Jan 2024 22:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CE992854FB
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Jan 2024 21:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834FE15959B;
	Mon, 29 Jan 2024 21:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="IBO1D6SV"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742B3157E87
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706562415; cv=none; b=X29VNt6iFASJZYTk7TILyJ5wXEieHTQyFwvOTa4tJ2K2+2kW5bJaszEZc0RCHwfBW04nNpJE7fVk0lHB8pDNpDfeDg348F52I2VrF2cTI4m0LHdlDjnj2vPB5IcSHhw5NCS1DoOFU6Qvt5fjfEZ2p1OFJVwc3KW2G/t9hBLv+Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706562415; c=relaxed/simple;
	bh=DRZ2yg+8WAlTHni5bhZssW4ALgjBmA8zDamvFNbz2wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GUBzgMBa9RXmRgaGEYQnJa765+8+xU+zU2BE4kUgL0SP3P2mEI0cJA561FyilzNYLnlPK2Z/hDZJNfDwElxGMgd5+b0jwoCQhvnyZJKP9/URsJebBaVdeqnXfTYS98Qi0umBXf4QwjJPzRoBj+s0xiHXk/dA8JnutmQQNxjTVno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=IBO1D6SV; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1706562409;
	bh=DRZ2yg+8WAlTHni5bhZssW4ALgjBmA8zDamvFNbz2wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBO1D6SVr6kuOxDwo+YKtrvcGFP5ZQytUZIn9EMCouTRbD33DxR9fRucjWYWLtOcA
	 q1NOIdMWb4jdTarPKYG/Zomn22fefTasueYm03yyeEsgTLeqMl8a0kcWVF5CGDsVIy
	 w4GdLEoNCMHYe3S1DCGYpTFwtfTxFyZEpoqI1oQ8K3frsxpOMRCVqcuvMlmg/I9+Lk
	 aGfw/mJ9DsZ/eGckf3GDMcJjSjuBCwWtVdohFSdwlZ1JcfggC8Pl0WiYA2JrUyJf3k
	 vIsJxMxTzHqXCFtkZQZzfb6WjI1Oi4By1B+ZclaNc8bVhlIkMZvn53NltXfdGwu96q
	 68dFRT0YKIr4A==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TP17s53WCzVXV;
	Mon, 29 Jan 2024 16:06:49 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [RFC PATCH 2/7] dax: Fix incorrect list of cache aliasing architectures
Date: Mon, 29 Jan 2024 16:06:26 -0500
Message-Id: <20240129210631.193493-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129210631.193493-1-mathieu.desnoyers@efficios.com>
References: <20240129210631.193493-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs/Kconfig:FS_DAX prevents DAX from building on architectures with
virtually aliased dcache with:

  depends on !(ARM || MIPS || SPARC)

This check is too broad (e.g. recent ARMv7 don't have virtually aliased
dcaches), and also misses many other architectures with virtually
aliased dcache.

This is a regression introduced in the v5.13 Linux kernel where the
dax mount option is removed for 32-bit ARMv7 boards which have no dcache
aliasing, and therefore should work fine with FS_DAX.

Use this instead in Kconfig to prevent FS_DAX from being built on
architectures with virtually aliased dcache:

  depends on !ARCH_HAS_CACHE_ALIASING

For architectures which detect dcache aliasing at runtime, introduce
a new dax_is_supported() static inline which uses "cache_is_aliasing()"
to figure out whether the environment has aliasing dcaches.

This new dax_is_supported() helper will be used in each filesystem
supporting the dax mount option to validate whether dax is indeed
supported.

Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
---
 fs/Kconfig          | 2 +-
 include/linux/dax.h | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 42837617a55b..6746fe403761 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -56,7 +56,7 @@ endif # BLOCK
 config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
-	depends on !(ARM || MIPS || SPARC)
+	depends on !ARCH_HAS_CACHE_ALIASING
 	depends on ZONE_DEVICE || FS_DAX_LIMITED
 	select FS_IOMAP
 	select DAX
diff --git a/include/linux/dax.h b/include/linux/dax.h
index b463502b16e1..8c595b04deeb 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -5,6 +5,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/radix-tree.h>
+#include <linux/cacheinfo.h>
 
 typedef unsigned long dax_entry_t;
 
@@ -78,6 +79,10 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 		return false;
 	return dax_synchronous(dax_dev);
 }
+static inline bool dax_is_supported(void)
+{
+	return !cache_is_aliasing();
+}
 #else
 static inline void *dax_holder(struct dax_device *dax_dev)
 {
@@ -122,6 +127,10 @@ static inline size_t dax_recovery_write(struct dax_device *dax_dev,
 {
 	return 0;
 }
+static inline bool dax_is_supported(void)
+{
+	return false;
+}
 #endif
 
 void set_dax_nocache(struct dax_device *dax_dev);
-- 
2.39.2


