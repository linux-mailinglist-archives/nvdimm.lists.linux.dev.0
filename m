Return-Path: <nvdimm+bounces-14467-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id VMucLBjhN2p8VAcAu9opvQ
	(envelope-from <nvdimm+bounces-14467-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:03:20 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F8B6AACDF
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:03:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=k+jt0Rnn;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14467-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14467-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 82BCD3003D1C
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 13:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333CE367284;
	Sun, 21 Jun 2026 13:03:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D232E3655D1;
	Sun, 21 Jun 2026 13:03:13 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046995; cv=pass; b=ZH0nLlmkOj1sfba5aY7mxeKqV384MntGqptDuYFLHaCXPJullyL7sm9qimNOfIcbjZ9FXmRwTUbF/2B7NgTUvpp5ZUlHGvzK+flJhkCFP1bGrE+9BJHpqE60VWc2UDWel/wldyyFivukS6h/f5Wl8Z2u15KNU1BIPuLXaZsw2T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046995; c=relaxed/simple;
	bh=BObJGRZzmtRxVfVzdFlLpRgDXZJViibwtMW5khQwtNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kr45H6q/HqxIx3VM8XugPQBHYmjLuZsS/XTHbHglBkznsHQG+43AiqFJ+oT+CsqY/isV414jAI3k79c7bbtSP4hBsBfQB9eBhS5IMiSp2d+mIjEV7NQEfnJIyzewvLRrezp1JptP1hjzjD3S2N+sXGqlEyI4YxOoVXe2w34dysQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=k+jt0Rnn; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782046988; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FwjkGTc6hYYIgB9wwvkVKiUrXYQmqd9TgZwNDcg9I3ftcB1vTmiNW6RZVjJVK+cvZsvqRTGOM1PqcqX0F2x80xmUrmU/rnjusRC8X4qADO6EvhT8OoMxQwD/aYe1l3gw18V1w73/2NmzEO+/pPsNxynzcpnpcwUIkEkFs9xA2oM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782046988; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Kkm6b8v9HrmRxgveYsXGJWG4c5oEBQ3malO2AScRBME=; 
	b=WSwjrjm9SXUuh4K8H3gNf72vApLE5G9bqLvRFGI/V0aJ+68fMM+DDHau+MMQQ3ELnqn9fCaOkn6yXXdnwRr74OMqTqadyw4aviuemmv47vzgoEPp3SpMAs7ygxeOD20zNl37d4CfDHgV31DTq5JxgibFWHpvMSDxHqhXunbBFI4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782046988;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Kkm6b8v9HrmRxgveYsXGJWG4c5oEBQ3malO2AScRBME=;
	b=k+jt0RnnZHpeMTck8WP3eoK+qJPoaxDXW4+cfJIDj3MSpoLZgOAKaTD7HLrc8KuS
	w/25Trckyg2V9iI251BcN/q/OyePYCiyHMg7aQVtuHb4DkvuoRkQwnplolE5m79oZ6z
	uc8q2SabJ0xwJNosUhWp/arhpCRfYe6IwI3ZayXQ=
Received: by mx.zohomail.com with SMTPS id 1782046985587100.80729899755318;
	Sun, 21 Jun 2026 06:03:05 -0700 (PDT)
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
Subject: [PATCH v6 01/12] nvdimm: preserve flush callback errors
Date: Sun, 21 Jun 2026 21:02:32 +0800
Message-ID: <20260621130246.2973254-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621130246.2973254-1-me@linux.beauty>
References: <20260621130246.2973254-1-me@linux.beauty>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14467-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 53F8B6AACDF

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

