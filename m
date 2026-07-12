Return-Path: <nvdimm+bounces-14900-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id gB7tBau2U2p4eAMAu9opvQ
	(envelope-from <nvdimm+bounces-14900-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:45:47 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A59107453E8
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:45:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=ZYxWvttk;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14900-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14900-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E81230179D7
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 15:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1AB340408;
	Sun, 12 Jul 2026 15:45:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6C2580D7
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871121; cv=none; b=T6WM375ZvIktNEyWbHQdgDJp0IYtS72jyU+urZQzdjb4CfVlBbQieV7aSo6cb0t4nmws5syTyfDanSwOBV7OeY26W0YLWGjVHuabo9zYKipl0X/MdvMVBj2JTqccClfyDXV/mL1n/UNkQFzYVlkosAEVGSmU2KDnyHd/ZB8IjUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871121; c=relaxed/simple;
	bh=cwLO8vv7b1rjOVh5x79fdH+sMlDL6NVKrF3rLUAYwY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujooU4BGeyO4EdreWYvtpttRF0G0RRf46ZdBIZ3UrMBaOBuKERpccYb7vmbkeglB7i7Nsf1akjuCDYzT56H5HyPm4QxrKTGOrvco61Afa2RLubuYEwHIY456m5wjIUp824Gd+XhlTqMObUyll+pQLtWKeHYaP0zsRSQC7sZWXFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ZYxWvttk; arc=none smtp.client-ip=209.85.222.182
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e4fd65b2bso126159085a.0
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871117; x=1784475917; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=57EncVwQTApdVwF+AHEoxJEEP6dVsKbM0q+e+B9wKPc=;
        b=ZYxWvttkjMbZj/AEeDxcNMkwnzfPJPAi+E2zZ/OpmTjWZ5weOg73p+kFlaGXTnjTSA
         U6K8L3FxPd/uwoXlcZxxXq4gwqjE52jGlVVtHogWnZbzYPkmiULlL/U0iZLWNFtinbd/
         Iz/mqNvx4doPcqahsUXfDDOJXwo7uAWOQ1xkPBO3uX8h/6Wo4jGLi9fBhxG5aFaPLIRa
         KPHd/5NPLNIhxv7sGZ4DRWzyNZtBIfB2N/K4YHUYnrg1SKEAYZJ/kXGqc5XEwqEzLyx2
         0H1TwLVvQfbB2lP91nZb4YQomiaxA3DtUL384rLGUY2bru0MzflrnRsHxZF4q3NUUCLH
         G+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871117; x=1784475917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=57EncVwQTApdVwF+AHEoxJEEP6dVsKbM0q+e+B9wKPc=;
        b=TTarguHeBAfC3wtWUA3TgcRwEMhpNJNvW/BYLMUT/JNdWh7eyYmkxHmCvx3CRK7mpZ
         OcyXO4/b25Of41Ed6VIgKTtNA2plWEWNk2UhvrMke41WzYJfUCukq0KVC3rzcpNsiN3K
         wqXXEm3F2hDyhmiiHQSw9tYGoBJ9fJerzwVm5Fenbs8nZbmx26j9pvdBKr2zqcQ1sJHK
         1o+/PFIhqen4Zho7G2rbUQLsSfh4uV3DBtcWF7IjZTKFtN/MhixG4PnQc+0VftTmNCWn
         HyT+yBLjR72LspqHxCbaW7KEmyM8DKPJCeg0U3RLHHnf+QgMPQ9CUJ4MYSdcNHadHMs7
         IPGA==
X-Forwarded-Encrypted: i=1; AHgh+RqfhFA9YiCqB72/H8csNPhioZUe2ZwicuS4cV14LnGvvvi+50YmVQAYV1R42Gop9VtUG6X7IhU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz42RjSwVJpMDd+Qb/EAeoXq9O3s95u/Cq8gQCcx/XTTi2qWQuL
	qWSrhytDByCbx7NVJMZOJhZKEJlgKl0FjQ5fBVv4yKPQdgivTD8/LuVmjvAwyzPCAKA=
X-Gm-Gg: AfdE7cmEoNNo+bFKO1F951cHFLgu24reEfbRDsAhPJ1pP2/U0CqX3IACIm8cxhYSSOt
	5nHkDNzZ3igoF+vbDPiovTjmB7au9tKSTXZejx0uWHIb09iGtJ5hWx7IlI7ekSXK4zRY8VCCEGp
	ZSUIqHS3GdrY6gYDExp9eoFkJ+v4deff53Fsy4A2pK6KVsd8/5k38vyI1w9U5o3dzRVHnUwZonX
	9vdu1GugcRwMFuflForJqywaTHEJqFPE4KhVAVnO9ty5W6VWrvgFzPrcFcWtoxI90A/Cz1Go0QU
	tlQ27eoPLlBSxLfzjnS292XojGZW9cgQX769x+eLuOD2FbyCLh6q0CfP6oBSDe3za/M1iHi+7sP
	HKWKI1KHDKOTRaJzMP4E3eR9m0kj5JY5gNFOrRtSxN15XpVH2ZYUAYEcVlGG6qhD+nxRgL9QEXQ
	yUGSgrECsUqL1FnIlmP17u5a4xjlsN1yRievJdoAR3ke48wbL1vkqyP2Ps1DmnKKGHi+8ECtjGX
	w==
X-Received: by 2002:a05:620a:a00b:b0:92f:199:b035 with SMTP id af79cd13be357-92f0199d1d7mr265410885a.3.1783871116930;
        Sun, 12 Jul 2026 08:45:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:16 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
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
	gourry@gourry.net
Subject: [PATCH v7 01/10] mm/memory: add memory_block_aligned_range() helper
Date: Sun, 12 Jul 2026 11:44:55 -0400
Message-ID: <20260712154505.3564379-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
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
	FORGED_RECIPIENTS(0.00)[m:linux-mm@kvack.org,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:gourry@gourry.net,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14900-lists,linux-nvdimm=lfdr.de];
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
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:from_mime,gourry.net:email,gourry.net:mid,gourry.net:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A59107453E8

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.  Guard against end underflow when the range falls below the
first memory block boundary, returning an empty range instead.

Update dax/kmem to use this helper.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4da..592171ec10f49 100644
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
index 463dc02f6cff0..1783299073e47 100644
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


