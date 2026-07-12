Return-Path: <nvdimm+bounces-14902-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /5nPF9y2U2qBeAMAu9opvQ
	(envelope-from <nvdimm+bounces-14902-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:46:36 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A135E7453FC
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 17:46:35 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=HGl1MTrq;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14902-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14902-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 752A13032584
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 15:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF3B34040A;
	Sun, 12 Jul 2026 15:45:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFCA33FE36
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:23 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871125; cv=none; b=Dg9bU4C8A0yuVqpDVIXb03L8EcJdgZ1oDcwim67ttVgz7/4i/kjpXsFFnTw7fmJUxBXX88Rd5uHveFeobD6J2JpRs3njrdOxPtIL3wi3kroUqabEQWk4vBJIV23pR61xc/Yk9YQ30PcldzAklc9TVixqJjAsc4G7XdQqI1r6oUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871125; c=relaxed/simple;
	bh=uhoFb1AdQ1YY63K+zjDeKis0/pyRtDsZVbRXxtXWIEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJ1StsCIvCjmyAdeQTSqMBl48zh0y7PF2bQ2MI4+LNRRuPvBT8iUdXD9kbGTSsHNCT0QofXylawX/WHgjGJfH8M8GhuymALYDL3XeOoYvpAkbzWcP5wj16IeRdqJO5vVtO6rQKEpFnA/Daln4pkSQRfNzVLHpvVlI5JGcORzm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=HGl1MTrq; arc=none smtp.client-ip=209.85.222.177
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e55b62640so125993985a.0
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871123; x=1784475923; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjJw3wlBuqXvLpxi0GmvsmDJYE5o3ZwGQsOl9zW5rZ8=;
        b=HGl1MTrqcT63HSYzXPoppdJ7VkFczmfjAB8yIkyvgbLLQPr16GLlDBYYDlMuVkf6Y5
         Y0hOgWkHLOyMj9IPNAPfcGEYpcx20L87F1ILgJ5y9D4qYSPI8wVdjFbQ5asMP9OiGuuG
         ohPTx/RDeLZaaGhifvp59oQ4nJ2wolTuSazyZ1pvLwcNcWlh/WPRkSrmuySX/uXHeVum
         HEZnfbLI8vlLq3QdQAgTh4oHP3CPXk+TV/VLLxOPY/2ZAb4rGoJ1rWIOPKirlDofXECG
         42yTqb7w3JVxAbNHGvw85xKDJYhkkEy5shZMJOE8KMjJRQjdrarXSnPZ1xM/8I94P9Iw
         iRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871123; x=1784475923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zjJw3wlBuqXvLpxi0GmvsmDJYE5o3ZwGQsOl9zW5rZ8=;
        b=evE1t2xln0z7Gp5s2JqUKizQP+aSrIQDVDn0+M5mUyHoeaqJqNXwn6DFc9SCjdIo0A
         FFEfB+myj4NKeLtsCYoX+NTtAYi+y1FTi/mO0VNCAXKCk73OSDbShYPm+um0vyltGO3d
         D/6S9hv1dg/UMZaq8YiF5KjyBHBAvfOxYtuSNYcgN0eEi+FLxE06Jhx7tflLQ58JNQcT
         EzZQxZEL6jP0JXS5n6NEa/pMlKkspXOw+0fA5Z2EJXgXS1ShMm4LLLfmzLQAIu30MqrC
         E/QcymNtB+7yV9h9UXyazcG6c3ej0cDa7xDKDcEStMfgglWCj1/YwcVrOIDdmBoBBeug
         10fw==
X-Forwarded-Encrypted: i=1; AHgh+Rq1Xunj/4f71QzMjxCe7mZ+0XkFnDLhdnbZIsQe17PI8QfC7u66kX+oyvy+Jlz2/SpVibN8kUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzV80PB75PbRTgb1inBD+gtvGSZlZtl1It6p9d6Q1ApOQumauZb
	Ppfh3gBNoZxToxJzGVdatoxIkz3baM+/Jqhn+9KSTc67mXhnIB5C0YdP40dkPOB9zEU=
X-Gm-Gg: AfdE7cljOBHZtsn6ZeFLfDlNpTC5xVoK2UjqxoPy8SiA1CqRpZYR8MRX/fP3rN0OMpK
	h/gYJdrBYVFkQbWw5oUjboT3VB6wcNgNHu4XCIwmfCO1yyZqXffdGTk96ZtY57apYyP1nIxXOAC
	WP62Fynny4AqayLPEovua1FEJbQ8PYUXZzD1htcsw7S6qILwx/NrsOyPDw+eDauuQeMAAuX/RoY
	KIwIVZDD1xWC8lCuLI9jmwUhF4f5J6SWIj5GzkWv03zW1XsU47jim0JYlch6drR81tH+3NwDciU
	yJC9s6G8z4m9QZQr2Q6ztbQ8YB3FsJ94nNn6FslOzIP/LRIvPTugr3XQhbMz+dase2PCutTkRJ7
	Eou0y1hBGJgNM5Ttv2wYxKvmIpMCzREjrB3A4nixCH9ugI9wzQ/K6vW7jSyfo8ofYxhHMKNNh9W
	YMRAnYM6s4O7nJ+TYxc4zS9/xhaSHzbMzLcCTF/i4nMffb5vm1g5GLDpX8hOZv/Ytd729Estte7
	A==
X-Received: by 2002:a05:620a:4711:b0:92e:5610:e479 with SMTP id af79cd13be357-92ef2bfd741mr601996885a.52.1783871122600;
        Sun, 12 Jul 2026 08:45:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:22 -0700 (PDT)
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
Subject: [PATCH v7 04/10] mm/memory_hotplug: export mhp_get_default_online_type
Date: Sun, 12 Jul 2026 11:44:58 -0400
Message-ID: <20260712154505.3564379-5-gourry@gourry.net>
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
	TAGGED_FROM(0.00)[bounces-14902-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:from_mime,gourry.net:email,gourry.net:mid,gourry.net:dkim,lists.linux.dev:from_smtp,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A135E7453FC

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
the same driver code, and chose the dax_kmem path as the default driver
path - making it difficult to require hotplug as a predicate to building
the overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either,
so we choose this to allow for defining the function with 'enum mmop'.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 8f6da2656f4e2..f19893f5fa948 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e625529baf996..be8e8e2cd1535 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.53.0-Meta


