Return-Path: <nvdimm+bounces-14317-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id y8u9Nd89I2qhlgEAu9opvQ
	(envelope-from <nvdimm+bounces-14317-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 05 Jun 2026 23:21:35 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CCE64B59D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 05 Jun 2026 23:21:35 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=YuNvRbws;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14317-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14317-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A82633046FE5
	for <lists+linux-nvdimm@lfdr.de>; Fri,  5 Jun 2026 21:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC633CD8CA;
	Fri,  5 Jun 2026 21:19:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33D1305691
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694363; cv=none; b=Gc+V/ikqrGb1KgRqI8WyFCh5+WYymNjMTF0OAOTj+K4Kii4He6bKA2kNUHpOQ9CsAYcaTlXq5glhM/PnUpyI4/Iv1YUeT4mkCAt87mXJIkivzvsBckDMQB02JggyC6eWWzxT2kqHstXrCyL1mR2EJJpsy8g3ybDll9L8WaISivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694363; c=relaxed/simple;
	bh=bzVWvGN8pdlnq4o4z+hOySj1+S3a7FDyojT5FT1eDQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AA8lkhYNB/RvF0GsdqyL2u6j3u9ql7EryRDZnlXLiR0vpjKr/93vEf+kQUoHv3AL8SoeBDn1Kt1wsoqNRvv++/aU8e6E5ukMC6q1x1OkeTPzyHGo9SQrxDE8TJyUtZkCh3LK8EiYbEiHvzLLUVsZve7VEY5zeaXhY+LyGirigXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YuNvRbws; arc=none smtp.client-ip=209.85.219.48
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ccf887de87so27329236d6.0
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694361; x=1781299161; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oI6t/rke/+VLpdgjZBrnvU5+vhrLOr9MvTf8Ltd88rk=;
        b=YuNvRbwsnO3bLKMUqLlBXl4Cthxc+qzD99AP4khIXnV93jcQtzceKx1HcIvCgbS3ax
         VywEHCEbGPNXVsen/bNbSdV0XVsZPxKqGf0niUfqYs3ay5MQWpxnXpAyUDZfeGi3Q1BH
         siGm3yQliN49w868BrzkpbjjayNNf16CUYmo8EdOn3HyYL9Fj8RSIYaIRJ5X3Pmqm0QW
         xTQ2FTVj9Z3dt9RQEIiRAmnptBIMUbdwV2KOpX1dGrGMfp00tMHDovVm3oJKqemvO9qX
         6Zp2DSbGDRk5KQsorB2xuYOZxJd39wgNHxMu9GlVDSgvdN1rdXXJDE3QLaXriJPBu6jo
         jf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694361; x=1781299161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oI6t/rke/+VLpdgjZBrnvU5+vhrLOr9MvTf8Ltd88rk=;
        b=X8LMbeElJHNKqulUHVQh+ZFqjdA6Z60ewZnVkrxI7iHKRuszYqjucNxRp00MaT03I2
         pg8Tjt1e8KKZKQdVONjjRgR327lTjunib/FN2rXkzDGCrbHyaJniOfP6HsrlzdVXuWGU
         PVM1at3iqwgrFe18+Rwlb8XwMAbAd0Qo6hSlrFAW3a0Xw3M2E40uYf5Up00WcDDISv5V
         Js1NfAAHoKYUTMuTzv8+ap78vodqGgSCpdarEvlfqtxgwD1444iGS50d9hdecPWIDtyg
         zfdjaBEnietpkybtBlk37m7A3xtOnzAgX80bdXZ2bVhc6hZa/zylbEyjIILma7jfM51M
         xvQA==
X-Forwarded-Encrypted: i=1; AFNElJ8sYO4aMpftcms47jgejI1Tu9YCQY1vu7aLVBIAu8Omy+y3j9UfbD+aQuVSgav+4DJpTwb6uX0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyC54y3eUrme04670AfrhqNp+465v2A4sDpyA3laRP2XUkcKq8u
	9pUBCsd61TTrIWOey9TIsdvqNQ+FzmnTolazlT8HdWSvahIr33B+yYHBz7VeNADACBw=
X-Gm-Gg: Acq92OFkslg6FHzZ+l/q4z9E3CUu8cKvPjYPOZy/PpTMVp6gS8DY4H9UON8xbackMrf
	FeVTfddnFHBsryz7Tk3tTRUHr2ximhigQ+he3LduTsMwnuaqvxFQGznmROP8JF3J2b68XB9jHSG
	DU7/YOml6g6jkXN6CoNHq5P66hYZ/IxZKl/z7EERwhs/y4kmDOGjatMN6Wi0w7bbpJylbQJa5jU
	KqBfy4efRe34D7ged2uT3/enNHxICnUUFrR8NsKtXFJGv4gr0nzwVWrppromvGJNKu7c65k9/mL
	aCZPldB/f5ldVz/mBpLUVGD+rWm2elF3xfIPQAMk3GazB1XBCQ0TD7qex74Mp3zrzAvky93yYgP
	GAIXdXiP+6CmDMjbJztXBwrw1cTQw7CxUpWF4e+edwqCu4dQkzAKHkIeH8fONNXlcu7N3iXgL//
	lNXgxcWq4pzr6CVQQDd0yf57RUK/78lgtGoC0IWUWxVpFUt5ze2p7/OhzOrXwM6gjWziB6j6U4L
	fNVQdT65Sbgm+QmLolIHQLjysZHZwmpRg==
X-Received: by 2002:a05:6214:53c4:b0:8cc:e8f4:1630 with SMTP id 6a1803df08f44-8cee614991fmr103632176d6.30.1780694360689;
        Fri, 05 Jun 2026 14:19:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 3/9] mm/memory_hotplug: export mhp_get_default_online_type
Date: Fri,  5 Jun 2026 22:19:05 +0100
Message-ID: <20260605211911.2160954-4-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:kernel-team@meta.com,m:linux-cxl@vger.kernel.org,m:linux-kselftest@vger.kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:akpm@linux-foundation.org,m:david@kernel.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:osalvador@suse.de,m:shuah@kernel.org,m:gourry@gourry.net,m:alison.schofield@intel.com,m:Smita.KoralahalliChannabasappa@amd.com,m:ira.weiny@intel.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14317-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[gourry.net];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gourry.net:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:mid,gourry.net:dkim,gourry.net:from_mime,gourry.net:email,lists.linux.dev:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 72CCE64B59D

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

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..f059025f8f8b 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -316,6 +316,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6833208cc17c..494257054095 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.54.0


