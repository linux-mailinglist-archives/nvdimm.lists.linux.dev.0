Return-Path: <nvdimm+bounces-14703-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id aNE3G0AzRGrcqQoAu9opvQ
	(envelope-from <nvdimm+bounces-14703-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 23:21:04 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C07166E81A9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 23:21:03 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=aJegruNH;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14703-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14703-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19AED310F108
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 21:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3B52E9729;
	Tue, 30 Jun 2026 21:18:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00F52EEE9B
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:18:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854332; cv=none; b=AhOVw5M7ZigXltOleGMHj2s/6S2tne6h3g/igVrVJ9b1l+iBTkOZqoCID3TG4KGokDfjrIW8VoCuLqI4gdL+TJA1+ScQAaOolNrOzB71w6DgCBFlZD1Oy3dM7RrBZzHTEvJLzL/6lO/U6Hkwb6+ii52gW7pv8RJeYuEIuqgITZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854332; c=relaxed/simple;
	bh=AxVPyNXAmBtaz2ot1Td7JrEyAQDmKXyudrs+ZGIIj8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsrbgALZNmRTq5yVoHnLCw0Tgqpib+IPssok9Sqjo5fV6lCCC1ixD59wYq/v6RbbzNotd0OeAlIbTH+1iAFeX9VcVfWBLxd4d32QzHnVX5m9hkhD4W0/uiai3nFwPlYPsAy3q49sFXs/cEZd5wrNW47W85QCOI1CNSLYmOFf/z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=aJegruNH; arc=none smtp.client-ip=209.85.219.48
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8eaa7b5e31eso9645086d6.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854330; x=1783459130; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SI86A/tUZQ+3KTQEDQQAFYWb5y1VZ6lRAmoYBSC2uM=;
        b=aJegruNHglSB6IalIux8aX6hPR5/AVCEx3HvDn0X77omzZzFTvOBuFcv0vmtg50OCT
         jpLwcNeNwBBGMeQQRJqaSacRvpeOrZdvMLwQpu0zFLbjMEq3wilMDPyZei6T3ZUjlo6+
         Ox2aZ7h7eN7JkIywonvRm1ugG0ic0MuUXECs8k4THIHJT55s7ul2qDu/9nH9Q0idirzP
         bsHxiKQo3xUAAdeNWEd6hA8K/9rR0Z/Pc9xfCCf3zi337DeJ5+qX+JiQpeesqaQHIhhy
         BIuUH1qUhBU8YSpNg7tWaS4dD9OpwxmpB7qxBv7CCDR/l8PyGlLGowe14NelC8UZvX4b
         xm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854330; x=1783459130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8SI86A/tUZQ+3KTQEDQQAFYWb5y1VZ6lRAmoYBSC2uM=;
        b=jRSFPDp8hiJR3QSqyB15ophi0oVU50FV1k2LLvCJp6eqR4U/+VY530wmkKmiF/VZSb
         itzbT/pknMVNmULCw1uVXoh4BRhX3W+Nds4/3tDwo2hWoOvLuoyPRxwFPdbf/mg6Q56G
         nY64S4b4OiLToB++PfvwXvOUTJS9DqsaKrcH0BzhPIUHJzjB8DXTs3sHSMBe7KdMekd5
         6rbBrCG807c3mxs/XF0IM9vYxT2Iz/XtDHc1XZRrvNf5HR29RLjng6QaJXI8sfIKKJrD
         9Eh+/iLXebIQBFo+48P6Zd9ECmFZa6iZ+K15C2sRU6fS7xCKCobXvZNrP87SX2uPaaoS
         gzuQ==
X-Gm-Message-State: AOJu0Yzd6tTNjibiBg9Khub4GIzjBGAht+0IRRmIe8ePpqNqqMjBILMZ
	B/bSfE+nKZL1ZXG4QFioO22udYd8UGKOnScY9rHDpbKzlVMnMm+PVh1hAQcif6xJbA8=
X-Gm-Gg: AfdE7cmyJjxyXibBTbglvU38P80Od2G3xXZa1mitnhgxMhjad2IPzUd5KFjiSnDmCj1
	XYLDnOLDkC0V1rajgnyUCkLRwGb3aGyb3Xh25Wzlaovmms1awhIo2V8lge9zfCiBWtgJm4MPSxp
	gUz5GlxuSJ1/V5z7B6DUUUnMShSGWjFNdz9yFLnzCNzjZPJUjOtixYSVPzeegqzb/femtU/Woen
	6c2AMrxCh9Dq3TL1hT8y5WQr/SD22EGrqez36DM84Mn5THHLuaDvcBZm7MoqHPk4ZfeEdODTOE6
	03I3+OtqUIZGO4dx5d5HNcEPlHmOTIDpgdQRbazI6YPOm349oLT220ywsGiNCYqzhjvlbTRxMED
	UqjAWkBCctFcpiWDcIc3wrnoOPLj4t5VTks3l/rL1Hx6/QeazXEedo6vOu6khVRfARA+lBYclmI
	6RMKxLsFpPwNFy4HujUsT9tKEUOhh+i49ruLqKAo1Vq4eyBuci5/eRCSsZ1HK+InJOEbuEN+BTv
	Q==
X-Received: by 2002:a05:620a:6019:b0:92b:3203:ea70 with SMTP id af79cd13be357-92e696f3833mr471607485a.12.1782854329895;
        Tue, 30 Jun 2026 14:18:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:49 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 01/10] mm/memory: add memory_block_aligned_range() helper
Date: Tue, 30 Jun 2026 17:18:33 -0400
Message-ID: <20260630211842.2252800-2-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:gourry@gourry.net,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14703-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[gourry.net];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gourry.net:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:dkim,gourry.net:email,gourry.net:mid,gourry.net:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C07166E81A9

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.  Guard against end underflow when the range falls below the
first memory block boundary, returning an empty range instead.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4d..592171ec10f4 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_aligned_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..1783299073e4 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_aligned_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_aligned_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
+	/* No whole block fits (e.g. range below the first boundary): empty. */
+	if (aligned.end <= aligned.start)
+		aligned.start = aligned.end;
+	else
+		aligned.end -= 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.53.0-Meta


