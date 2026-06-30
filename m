Return-Path: <nvdimm+bounces-14665-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9Jx6C36MQ2qnbAoAu9opvQ
	(envelope-from <nvdimm+bounces-14665-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 11:29:34 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 983216E2306
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 11:29:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Siatnupv;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14665-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14665-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4B7CC308BCD2
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 09:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A403E9585;
	Tue, 30 Jun 2026 09:24:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D613E8330;
	Tue, 30 Jun 2026 09:24:21 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811464; cv=pass; b=WQRrK/K2VKVTBoJoOHL0Tp7sI5QqFv2I5J/udV6cAV/pkp/HSaTS624Dl7i0cX/r3YMTe0DbrY3bQ6MF3KBIIeojKTHl71wrY+neRAS2N2pCXB35HcyY6CS5vc8/wv+QqJkM55GtsBgIML8josmGUYQqvtCM6QMzccebaXaA6B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811464; c=relaxed/simple;
	bh=yNGrEJlXC/3Kj2L50w8PBQwDVtyNG/aExJYIOATyaIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMrUVbKOVk7ZoHeSIRwPIMOB/uf23oIIwM89vLAT3MephNBpnrvxC4bKJjQAvOak3t8phHe+EWXyLziOh4Anxrg2lAptNplUm2sSSiEopyBJfq9ZtWF4caXgTSKua08IW0mt+Z42R+s4zqCWU63fLMX0+oOceN4KM82pcJ1vqyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Siatnupv; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782811443; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=L+u6Fmf2x2oguNaTRPIbxb/0O2OSThKtr9jFDt/qeJmustvvlpc9AMwXnvu6P0BBa8gLFIJmfd7TPKpL0TB/9suDAJKtuzqbDNKygY/m9L4UhLRJE3XptneDO3bkSt5235ZqHKFJ0cvDMCOKAXKR9uR1vsp3qfW1Nedzr89tHcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811443; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=l+TairmX9egfA9LqMO7TzDhHCGZIpaTe4WqZKhyGKds=; 
	b=APF269aS7WsZWebC+0+JRQqpPRPnUmaEmvRnezKxVju6O2EPbewg5gqDJK6B5D00z5QRUnpqFAeaayeAfqGFbWOphUFb8agw+hTVoNU6nA8qfM8vqtBuwLGTd7tbdA3TG3O7bcbNGwxouS2Yhlaqo7+6IGi7cwSaWxOP51D4g68=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811443;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=l+TairmX9egfA9LqMO7TzDhHCGZIpaTe4WqZKhyGKds=;
	b=Siatnupv6204YrPK2svoEN0Ri0CaRkZBfNJzV6FT0QG0A/ychuoP8afQsGxJB4J2
	SRfF8mECDE3GQ7hwc7hZoYNvg9VXcxIH74a6LnMq7yDKssNUzxo0/IOMYztr7uUB2yF
	5RDake7BadOXomPuaxUSyzLlhXf6CzritrWE3Dmw=
Received: by mx.zohomail.com with SMTPS id 1782811441310821.0554398994373;
	Tue, 30 Jun 2026 02:24:01 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 02/12] nvdimm: pmem: keep PREFLUSH before data writes
Date: Tue, 30 Jun 2026 17:23:27 +0800
Message-ID: <20260630092338.2094628-3-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14665-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,intel.com,lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS(0.00)[m:pankaj.gupta.linux@gmail.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:me@linux.beauty,m:pankajguptalinux@gmail.com,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 983216E2306

pmem_submit_bio() records a REQ_PREFLUSH error, but continues to copy the
bio data and can later overwrite the error with a successful REQ_FUA flush.
That lets data writes run after a failed preflush and can complete the bio
successfully despite the failed ordering barrier.

Run the REQ_PREFLUSH flush synchronously before touching the bio data and
complete the bio with the flush error if it fails. Keep asynchronous flush
chaining for REQ_FUA. At that point, data copy has completed and the parent
bio can wait for the chained flush bio.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v5:
- New patch.

 drivers/nvdimm/pmem.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 92c67fbbc1c85..05d3de33e2706 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -208,8 +208,14 @@ static void pmem_submit_bio(struct bio *bio)
 	struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
 	struct nd_region *nd_region = to_region(pmem);
 
-	if (bio->bi_opf & REQ_PREFLUSH)
-		ret = nvdimm_flush(nd_region, bio);
+	if (bio->bi_opf & REQ_PREFLUSH) {
+		ret = nvdimm_flush(nd_region, NULL);
+		if (ret) {
+			bio->bi_status = errno_to_blk_status(ret);
+			bio_endio(bio);
+			return;
+		}
+	}
 
 	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
@@ -229,7 +235,7 @@ static void pmem_submit_bio(struct bio *bio)
 	if (do_acct)
 		bio_end_io_acct(bio, start);
 
-	if (bio->bi_opf & REQ_FUA)
+	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
 		ret = nvdimm_flush(nd_region, bio);
 
 	if (ret)
-- 
2.52.0

