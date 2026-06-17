Return-Path: <nvdimm+bounces-14447-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id f16IKN2TMmpg2QUAu9opvQ
	(envelope-from <nvdimm+bounces-14447-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Jun 2026 14:32:29 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 221A5699BB5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Jun 2026 14:32:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=ewXxRX03;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14447-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14447-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE685314E293
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Jun 2026 12:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447E53F8EBE;
	Wed, 17 Jun 2026 12:25:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32781F91E3;
	Wed, 17 Jun 2026 12:25:35 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699138; cv=pass; b=fhBTH8LQI3hxsZJEyKe1daTIhjl66IKP83YRPSmaRDthu3PaooAzTtjRwy5slHU2HKNLlrwjM7T4HxGsBjP43pQUxHmExxC9Z38w+GLKxFaN4gMAt9hIDwWfROjRb7YVuza5/uRgrvzkilLfymNKu9vz+YWTmg2wxbFKgS9Vrb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699138; c=relaxed/simple;
	bh=0IknSZs+CZ2aWmgORtDW0RLrqT1UT710/Y0X+nmzfrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLP+bg1C289vQY0pjoxIY8M5h4l9X1xeswffICEZ9iMGNjQMDhIbQN1W9Pbf1dYB0KE6MNbsmgPic2kQKF68pDf08AY/hC+y0b1DvljVdVpcbnRuCZpR+c//lAWlSxkIB9fhTQdnV1GXgytQ4LwGUsqpx54f6Lipa0M/mg9zwjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ewXxRX03; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1781699114; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PEbrA/y38ehDPU7bVtrHPf/LulBQx3HkjMAD3ztOKGPLn3m/62QRfk0d/WS48c0rSqFZiUtvwntMJ6u42hy366+ukQ8zCFfAtsQQbpEmdk6ZbAxBBODZKqjn3JStJFFlYr2/pN2cmMimuxe0HEowkh47SxtZaOGQSuKVig7nPsU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699114; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=gPpF3KoeRkWvCn/WAd7dxNBXjTnxN4iFAXPZPuhQ5Bc=; 
	b=ImvaK0vBxmubG5cMihQazdNWq3G7UrSU+KjXQf0SUCZKcc38KLOLK42qqEvxddD8GHi3TvQTWIkeEOTsaQeuVzRo05cpyAa2Fsjqv+X/mQARP0xlHpUq1StO9Uo7SR3tcRPv+5r4GRh+4pDthhhVpDc8lZLYaCztzfFXEW3Q2OE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699114;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=gPpF3KoeRkWvCn/WAd7dxNBXjTnxN4iFAXPZPuhQ5Bc=;
	b=ewXxRX03WYHBKOheqvuvRSL0cGdq4IRRhdKnaDrfUnaHey4LoPB1LKoaSlaeyn3k
	QwaUbZXgZ9wsTUdl1ghKS9uQllhtTZ6HrNjhS10OeUUGqrufomOpfbm+O97soLqjgGy
	PZOG3TQbMnBUNwcC9jSJ4ZA+jLkmyGGe+8FGeAKc=
Received: by mx.zohomail.com with SMTPS id 1781699112062181.5672867241185;
	Wed, 17 Jun 2026 05:25:12 -0700 (PDT)
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
Subject: [PATCH v5 3/8] nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
Date: Wed, 17 Jun 2026 20:24:35 +0800
Message-ID: <20260617122442.2118957-4-me@linux.beauty>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14447-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:from_smtp,linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 221A5699BB5

async_pmem_flush() can allocate a child flush bio from filesystem flush
and writeback paths. GFP_ATOMIC is unnecessarily restrictive there and can
make the allocation fail under pressure, which then propagates -ENOMEM to
the flush caller.

A local virtio-pmem mkfs sanity test hit a flush failure before this
change:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

The debug log showed async_pmem_flush() was entered and nvdimm_flush()
returned -EIO. With GFP_NOIO, the same test reached mkfs_rc=0, mount_rc=0,
and umount_rc=0.

Use GFP_NOIO instead. The path may sleep, but it must not recurse into
filesystem I/O reclaim while it is already servicing a flush request.

Signed-off-by: Li Chen <me@linux.beauty>
---
v3->v4:
- New patch.

 drivers/nvdimm/nd_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4176046627beb..081370aac6317 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -117,7 +117,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 	if (bio && bio->bi_iter.bi_sector != -1) {
 		struct bio *child = bio_alloc(bio->bi_bdev, 0,
 					      REQ_OP_WRITE | REQ_PREFLUSH,
-					      GFP_ATOMIC);
+					      GFP_NOIO);
 
 		if (!child)
 			return -ENOMEM;
-- 
2.52.0

