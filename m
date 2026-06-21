Return-Path: <nvdimm+bounces-14471-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id n5r+MznhN2qGVAcAu9opvQ
	(envelope-from <nvdimm+bounces-14471-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:03:53 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2F16AACF6
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:03:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=UyY9byqd;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14471-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14471-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2F4F73006805
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 13:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F165367293;
	Sun, 21 Jun 2026 13:03:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9F3366DA3;
	Sun, 21 Jun 2026 13:03:33 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047015; cv=pass; b=ZtruFhwrgb8CYdvTcbseyuOqsgFpcBetGbcG2UaYIKmRcEAzQ+6mX6Uslp8LVjz9ctzTqCpc/sOyXrnBByfGfK1/RlMRPXXNXLrKYSmL8DnW/HMefOAcnQ5uRvU1Byi/ZzSeAl8YRK23Ui78u+fXZCYnq/qSeDHyfOEI84zTBlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047015; c=relaxed/simple;
	bh=ewbtKz2hdslCFWnjQTPY4AnRMcpsvvM+zeJ55wqDaQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOBbW2BOGkcrIa24iO22zAohHAMljz4L6XvP5cZ8nHjOKsaFInRLDM55CG8ZAZcJFU9g1xjWFFK6Snha+xSyFY5CzqbDMdO/9UarVw6qktCq+//UpjZwucbN/YAO5KmKY07IOg4+DXTOtNOWfWAJwkIqt/i1+7vKelQOpaoO3m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=UyY9byqd; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782047002; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MxAYZL6+AXhvOvX5N5/u3vCCr9I9aX6oFOAWrO5i3jHw51QJFhebcx1iW1p0mqGQV3XeI6X2CkVTcsSrhlvKNoOvn8JjI4VCzgTa0pobvA9SUvdNbKoiI2vSZq8CDZzIFOnVTqEzHJ4b3rxfDTc8jqGKJam89YzCwDUypTMh1+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047002; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=W+o+IKys+lU/ZxFNZxi3pNHAmf/FkNcd7IUh/VLtXLU=; 
	b=JbSZg7FTX4uyoANvOZApavJ49Jeqe+gH4umI9MTO4ybfNxyCJmYr4Lzksm6JJQy9s61yr/jxupLB4aZRWops+lEKN3DCOvUAiX9wKmaV3jpJSnRTW+zA9D61ZsApKHTzMKqJf09TbFxEnLYQ68lGuZeGzZcjA2g4zApXcDMjBk4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047002;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=W+o+IKys+lU/ZxFNZxi3pNHAmf/FkNcd7IUh/VLtXLU=;
	b=UyY9byqdcuyB30IuQ4ltnwxAEZmGtNo3xN9LDYF0vaqgG/xVdbAWihEG0j+ai5jh
	Fg5spON+uD1FgC7I0uAcTkVHD+ad9XIf1LTJBZJfsX/rhD16n6MW0f5iUg63wVrhjxd
	Fz5BEwj4fEBVFJQZfJO/D+Cpel9NHnbYw0x48oyQ=
Received: by mx.zohomail.com with SMTPS id 1782046999373828.3231573844629;
	Sun, 21 Jun 2026 06:03:19 -0700 (PDT)
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
Subject: [PATCH v6 05/12] nvdimm: virtio_pmem: use GFP_NOIO for flush requests
Date: Sun, 21 Jun 2026 21:02:36 +0800
Message-ID: <20260621130246.2973254-6-me@linux.beauty>
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
	TAGGED_FROM(0.00)[bounces-14471-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7F2F16AACF6

virtio_pmem_flush() can run from pmem_submit_bio() while filesystem IO
is waiting on the flush completion. The request object allocation can
sleep, but it should not enter filesystem or block IO reclaim from this
flush path.

Use GFP_NOIO for the request allocation. The virtqueue descriptor
allocation still uses GFP_ATOMIC because it runs under pmem_lock.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- New patch; keep GFP_NOIO only for the virtio-pmem request allocation.

 drivers/nvdimm/nd_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4b2e9c47af0f5..91ca144607531 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -55,7 +55,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
-	req_data = kmalloc_obj(*req_data);
+	req_data = kmalloc_obj(*req_data, GFP_NOIO);
 	if (!req_data)
 		return -ENOMEM;
 
-- 
2.52.0

