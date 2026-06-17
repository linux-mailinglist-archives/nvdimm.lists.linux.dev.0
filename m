Return-Path: <nvdimm+bounces-14445-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id onwrBz6SMmok2QUAu9opvQ
	(envelope-from <nvdimm+bounces-14445-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Jun 2026 14:25:34 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AA401699B02
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Jun 2026 14:25:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=ggw+jbWG;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14445-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.232.135.74 as permitted sender) smtp.mailfrom="nvdimm+bounces-14445-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 229C6300A324
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Jun 2026 12:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94BA361DA9;
	Wed, 17 Jun 2026 12:25:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F23F5BCF;
	Wed, 17 Jun 2026 12:25:16 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699119; cv=pass; b=JXOIb0+/gFNB6cGmCJNNFpgevrxduVitEQVVqokJIVTvGfA+Z6W+HzYdIOBhgJXMnTWyplTcwvYULE4YTsiuHyySzwhIXZspwPpHC7AvJGzv3aEjOwtIdE/wKxfsqcdhN+KjEUQVQ8CMUX+a03EPCHHSvVmMD7XPzqCPuVKmU/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699119; c=relaxed/simple;
	bh=BObJGRZzmtRxVfVzdFlLpRgDXZJViibwtMW5khQwtNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ae/kiD2mbFC302Wxfsc4d8sbkf8p7aEt8OVqsWVA1fHdnJZp26HbeeOwVbcBZo2d8Llc3/i3SqMwpzE4wsk4u0WB43kGaf4OQy0Hgd0wFYLkHFUJQ4PcY5kjoI3RoLElzcGz6OgWe3oXS8GqNE456OpT5pluFN8sC76n+6aF6YQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ggw+jbWG; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1781699104; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bqCrnAaWEXsxzBgOsA33/YUA4szzbyAjLOz8PKaY6kTMZ2ocl9KL1ibSpJMFm1HXQq2CxyBoOpXB/9SXrcClbV4DrDQNrcWjrhkqfKGv5g+/QlzOQkmEu/T1fRll/ri4zWZY0XYQPDGPOlqNBLsZT3Wt8HMNNC5xilxYbvmWTQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699104; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Kkm6b8v9HrmRxgveYsXGJWG4c5oEBQ3malO2AScRBME=; 
	b=RCbuc9XOCPtMDBFZlYv/mLFbvNxIWrt90yn+rE+mclUJlhNUolmOp0DBwhPGCcVXScx+3sS1gF3NJ3sG6Wykq3kL/dcTztXfHpjcJXISH/W3BdEX4+OM8CwVjcJCdZMwmTp0QR9ngKmmokKYd9PVifm9hodyoEBfSMCinSLd0O8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699104;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Kkm6b8v9HrmRxgveYsXGJWG4c5oEBQ3malO2AScRBME=;
	b=ggw+jbWGzvYunGYVd9obD/54TvYSl2TWy1R3Q0ikPnchqeSknTuepBZlWaWaAEPw
	EgXALxj3XkIR/J3mHEAzOJg8a7sQPOxXY4qHWhVOmT+ut+1j2YMruaXv8InjyQ0/xiO
	o3QrAU9NmpqWg+3jpo0MZ7eRStCxS3Q6lnYeV2B0=
Received: by mx.zohomail.com with SMTPS id 1781699103031328.99526169070873;
	Wed, 17 Jun 2026 05:25:03 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v5 1/8] nvdimm: preserve flush callback errors
Date: Wed, 17 Jun 2026 20:24:33 +0800
Message-ID: <20260617122442.2118957-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260617122442.2118957-1-me@linux.beauty>
References: <20260617122442.2118957-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.beauty,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14445-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,intel.com,lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS(0.00)[m:pankaj.gupta.linux@gmail.com,m:dan.j.williams@intel.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:alison.schofield@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:me@linux.beauty,m:pankajguptalinux@gmail.com,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: AA401699B02

nvdimm_flush() currently converts any non-zero provider flush error to
-EIO. That loses useful errno values from provider callbacks.

A local virtio-pmem mkfs sanity test showed the masking clearly:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

The virtio-pmem callback can return -ENOMEM when async_pmem_flush() fails
to allocate a child flush bio, but nvdimm_flush() hides that as -EIO before
pmem_submit_bio() converts it to a block status.

Return the provider callback error directly. The generic flush path still
returns 0, and pmem_submit_bio() already handles errno-to-blk_status
conversion for bio completion.

Signed-off-by: Li Chen <me@linux.beauty>
---
v3->v4:
- New patch.

 drivers/nvdimm/region_devs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f0..0cd96503c0596 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1114,10 +1114,8 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 
 	if (!nd_region->flush)
 		rc = generic_nvdimm_flush(nd_region);
-	else {
-		if (nd_region->flush(nd_region, bio))
-			rc = -EIO;
-	}
+	else
+		rc = nd_region->flush(nd_region, bio);
 
 	return rc;
 }
-- 
2.52.0

