Return-Path: <nvdimm+bounces-7384-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CECC84E83E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 19:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1CBFB2767F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 18:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A053D37716;
	Thu,  8 Feb 2024 18:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="G+MCYgcI"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF4928DA4;
	Thu,  8 Feb 2024 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707418176; cv=none; b=TOD0Q/fPzLFN5DToOLhF52wx8jMeewP0OvO8668b2eZICMSOZZBvyuNhp2TOMw7k3IlZKmLsg4J8dONNJpiw9kb2GQUxKmtCOUlH9tmobkDCgGmbGrxTsQvbKOZW8CuWwcrYzAkm6zNL4A7MUwe9a/1VwfumUd7zjQWR7XxMV0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707418176; c=relaxed/simple;
	bh=MgteUY0CjaNYCNu4ZJjdjfbOYQwaLS6hDEa6C2rXhOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d14xIyeVEhtLhXlq0wmsqaZ3MXlSILRzIdBEOly6TA3raUGeuMz4JVk6Ul8Bpq1SqA2uFuP3lXNBVxtBuuZDNYxnm8Rtl0wphyU1u2J5kbgwKqX6iliLgJfRGurwJoswBfXPeb1Ohm7ytP2J3LIrOn/vXEXLGEFQraFvVsCecYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=G+MCYgcI; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707418166;
	bh=MgteUY0CjaNYCNu4ZJjdjfbOYQwaLS6hDEa6C2rXhOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+MCYgcI7iOhUtOG80uDYEEj9WDUFtjZj9v5kigEOVyg1Gl0p5tefCTOJimzq7BIl
	 Bntq03Tcm/N+e6ObNbaOTegq2ADAQ6pQAwKRVSja1uTLw5yeNuWK/hvvwPRF7XXbX/
	 M6nZvFFxMKHg5SQuBdBtw17hxlxVb8oD+kSkJNaegeMMMlHzHo5f/VuV5nAyz64Pyw
	 A0gPrGc0Vnc/Vms7OHuOkBj+zaxkVYidiXOcY2aohU+UyZ2+NFyxkSnkI7UeA2jGpn
	 EkUAuevUw1ZVowe9kZH+93MAkvXFLN/9+SJBI+P9oBDLUkZMEhunrIKZMVOfThz2S7
	 T2GUX150wzk3A==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TW5cj6MmwzY5R;
	Thu,  8 Feb 2024 13:49:25 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Russell King <linux@armlinux.org.uk>,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: [PATCH v4 08/12] dax: Fix incorrect list of data cache aliasing architectures
Date: Thu,  8 Feb 2024 13:49:09 -0500
Message-Id: <20240208184913.484340-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
References: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
prevents DAX from building on architectures with virtually aliased
dcache with:

  depends on !(ARM || MIPS || SPARC)

This check is too broad (e.g. recent ARMv7 don't have virtually aliased
dcaches), and also misses many other architectures with virtually
aliased data cache.

This is a regression introduced in the v4.0 Linux kernel where the
dax mount option is removed for 32-bit ARMv7 boards which have no data
cache aliasing, and therefore should work fine with FS_DAX.

This was turned into the following check in alloc_dax() by a preparatory
change:

        if (ops && (IS_ENABLED(CONFIG_ARM) ||
            IS_ENABLED(CONFIG_MIPS) ||
            IS_ENABLED(CONFIG_SPARC)))
                return NULL;

Use cpu_dcache_is_aliasing() instead to figure out whether the environment
has aliasing data caches.

Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arch@vger.kernel.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Cc: dm-devel@lists.linux.dev
Cc: nvdimm@lists.linux.dev
---
 drivers/dax/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ce5bffa86bba..a21a7c262382 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -13,6 +13,7 @@
 #include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
+#include <linux/cacheinfo.h>
 #include "dax-private.h"
 
 /**
@@ -455,9 +456,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 	 * except for device-dax (NULL operations pointer), which does
 	 * not use aliased mappings from the kernel.
 	 */
-	if (ops && (IS_ENABLED(CONFIG_ARM) ||
-	    IS_ENABLED(CONFIG_MIPS) ||
-	    IS_ENABLED(CONFIG_SPARC)))
+	if (ops && cpu_dcache_is_aliasing())
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (WARN_ON_ONCE(ops && !ops->zero_page_range))
-- 
2.39.2


