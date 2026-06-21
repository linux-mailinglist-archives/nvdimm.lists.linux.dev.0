Return-Path: <nvdimm+bounces-14469-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zhUSCTjhN2qFVAcAu9opvQ
	(envelope-from <nvdimm+bounces-14469-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:03:52 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 122066AACF1
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:03:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=i4EOrt9z;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14469-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14469-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F09F13007212
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 13:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D92236729C;
	Sun, 21 Jun 2026 13:03:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108B3366DA4;
	Sun, 21 Jun 2026 13:03:24 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047005; cv=pass; b=cYtSRE6sS6bMerl1rDr/Q5LB1NniWOYFnbBAkurSaeQXtbYMZgK2jNXTB8Oo8B/gOKVkpIt/PK4jj04jMeRrdfSqv23q7d3KM/kE3t9FtBmpwxKeU82+TNdRdCma2EMxFOlgS/nOxLJY048W9shA9rXlArVRP/T7hI3gYDhbhYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047005; c=relaxed/simple;
	bh=itjLrkKJEW81RURIxDECsGtTLBhbeI004y7GPmhHinc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGaLpc+S+tmjOvInEMlEUygj9+JL33K9+2p8hC2r6LcytcmzutA1m14EY7/JzOO28yrdmPhrqesmdn+6dCLPrfWgv5wtPu9QwrYwPdBDiOoaIlzEW7G/aQXFLYUUcXunjtNhyurJIOiAGzAQpYJndwiNO4h1mFyxj9mRDCpqsZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=i4EOrt9z; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782046996; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YDIit72m4ticVGIAgvj14rN8bamQK7mkEwYY0VamG9eXaKwuHPHhbNf8jO1otq08XxmaccpQK5t0IXn76O2qWH2an/ZXKkQHyZomJ/qo29LsZMOOyffVj5kmbOUmJGlyhE4fRgAw7SotOd9tyr3sNA5rRhy7w/y2gzFcWpZB8Qg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782046996; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=c0EOLBoih0cc+8cnP+Tzr7COxL+v2rD15YCFnpCQMeg=; 
	b=P5nsVLzpjoFEAV1jpyShma37Cm/s2PayE5pzX8wrhmEqdMj86uWLdv0f+c+JSNlIFDT4CxXL4QYYaQfbujkFmSaYCmlrmce8ifY+Ov1DaeoENo/zVTi/FGEbDsWT0xcT2fQ5A+Y9653Zd48LbgpAb6ohatPh5sJuOJZXs+ep4PU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782046996;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=c0EOLBoih0cc+8cnP+Tzr7COxL+v2rD15YCFnpCQMeg=;
	b=i4EOrt9zfwk3FQH38nO2rWjQ1fHF/8lYPI/Cgz4CgJRU49Sax6afXjZ3tN2SQcHS
	UdUslO8hV40hjDC4FYUVr/NpXQR1agoBCGAYSLpgbMtqsYkaNF4gWxUl6FTEaywVNp+
	UokEd9QyDR0SQssNmDsClbR+ClBKbS42qVfB3eXY=
Received: by mx.zohomail.com with SMTPS id 1782046992618983.5404623082977;
	Sun, 21 Jun 2026 06:03:12 -0700 (PDT)
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
Subject: [PATCH v6 03/12] nvdimm: pmem: guard data loop for dataless bios
Date: Sun, 21 Jun 2026 21:02:34 +0800
Message-ID: <20260621130246.2973254-4-me@linux.beauty>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14469-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 122066AACF1

pmem_submit_bio() handles flush-only bios before and after the data
loop. Keep dataless bios out of bio_for_each_segment() so the data path
only walks bios that actually carry bvec data.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- New patch.

 drivers/nvdimm/pmem.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 05d3de33e2706..82ee1ddb3a445 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -217,23 +217,29 @@ static void pmem_submit_bio(struct bio *bio)
 		}
 	}
 
-	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
-	if (do_acct)
-		start = bio_start_io_acct(bio);
-	bio_for_each_segment(bvec, bio, iter) {
-		if (op_is_write(bio_op(bio)))
-			rc = pmem_do_write(pmem, bvec.bv_page, bvec.bv_offset,
-				iter.bi_sector, bvec.bv_len);
-		else
-			rc = pmem_do_read(pmem, bvec.bv_page, bvec.bv_offset,
-				iter.bi_sector, bvec.bv_len);
-		if (rc) {
-			bio->bi_status = rc;
-			break;
+	if (bio_has_data(bio)) {
+		do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
+		if (do_acct)
+			start = bio_start_io_acct(bio);
+		bio_for_each_segment(bvec, bio, iter) {
+			if (op_is_write(bio_op(bio)))
+				rc = pmem_do_write(pmem, bvec.bv_page,
+						   bvec.bv_offset,
+						   iter.bi_sector,
+						   bvec.bv_len);
+			else
+				rc = pmem_do_read(pmem, bvec.bv_page,
+						  bvec.bv_offset,
+						  iter.bi_sector,
+						  bvec.bv_len);
+			if (rc) {
+				bio->bi_status = rc;
+				break;
+			}
 		}
+		if (do_acct)
+			bio_end_io_acct(bio, start);
 	}
-	if (do_acct)
-		bio_end_io_acct(bio, start);
 
 	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
 		ret = nvdimm_flush(nd_region, bio);
-- 
2.52.0

