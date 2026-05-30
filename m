Return-Path: <nvdimm+bounces-14245-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDUGKiUWG2pV/AgAu9opvQ
	(envelope-from <nvdimm+bounces-14245-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 18:53:57 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE2460E8EE
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 18:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC591303D714
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 16:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB6639478D;
	Sat, 30 May 2026 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="iOVmuAt0";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="teMyf9am"
X-Original-To: nvdimm@lists.linux.dev
Received: from a11-173.smtp-out.amazonses.com (a11-173.smtp-out.amazonses.com [54.240.11.173])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E2C331A56
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159844; cv=none; b=mX/gjPs8/fDqbMn4iD7/h8hYQdQnRheLSjD1TMz7nVZ6ZiMwd2yfMRRth+v+MTNLocA+VB5RQZnYRA6rpVT8X8daBSvk6Kg4IGfCUwgpCw46VuZrP1M205Kl5OrRCsbThVu6Ke8ROpFVaqftQ3uU4SgTJJF6ammKtXZ3dK+8T8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159844; c=relaxed/simple;
	bh=XSjPuy1P2iMqKDcloi332EG/hJu8ryswc23bfqxsHeY=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=dgnTZ9dRl8IewtQ6oKJk684tfu6af8fwYa5JRxOlvgbWH0cQoS/zo0QNuD99Ol+u5ErG+505RMS+sg03tGfowVCANP92d2pjzKcgix/o+uEa76k6WyUzCoarRE/hinYaW3jld6KagB67NpOvtaeyFSv2FxLAOdxieEM41VrwX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=iOVmuAt0; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=teMyf9am; arc=none smtp.client-ip=54.240.11.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159842;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=XSjPuy1P2iMqKDcloi332EG/hJu8ryswc23bfqxsHeY=;
	b=iOVmuAt0DhRCLBDuRcjbxE3j0C0X78qcgQtyNENoNh4Fz9A5vXH1CUeuiXqhV5gl
	z2FncnuEZcwoBFQB+rc1Ml1934olAZoCnROt2DxtlMH/wwkRf2ab824TwrcHfemiTf7
	UzvMH0n5gD7EVu9z79Fi6rD3UCeuYZMbC+LVI3rE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159842;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=XSjPuy1P2iMqKDcloi332EG/hJu8ryswc23bfqxsHeY=;
	b=teMyf9amSC/zKaMP0MtdraS2GRLgur2YIMuQoWGZTGPqSF8cvwehDKghvVacLxpz
	s96N1diKyKPV52i/y4NoNxRU3B5tcwwQp6VZ9ONROFHyPOuH6MF4AhLitBY/uqH7BNs
	1wS8JSuuIBVOgghMTwCh3Hxd0EGXCpEJj/fg/jUE=
Subject: [PATCH V3 2/9] dax/fsdev: fix multi-range offset in memory_failure
 handler
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sat, 30 May 2026 16:50:42 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
References: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com> 
 <20260530165037.6619-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAABjf9
Thread-Topic: [PATCH V3 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
X-Wm-Sent-Timestamp: 1780159841
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cb8953-e505a8dc-63a4-4bc3-a9bd-3b86ec081838-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.11.173
X-Spamd-Result: default: False [0.75 / 15.00];
	CC_EXCESS_QP(1.20)[];
	TO_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TAGGED_FROM(0.00)[bounces-14245-lists,linux-nvdimm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_EXCESS_QP(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCPT_COUNT_TWELVE(0.00)[18];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 0DE2460E8EE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: John Groves <John@Groves.net>

Fix memory_failure offset calculation for multi-range devices. The old code
subtracted ranges[0].range.start from the faulting PFN's physical address,
which produces an incorrect (inflated) logical offset when the PFN falls in
ranges[1] or beyond due to physical gaps between ranges. Add
fsdev_pfn_to_offset() to walk the range list and compute the correct
device-linear byte offset.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 188b2526bee45..f315533b299e9 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
  * The core mm code in free_zone_device_folio() handles the wake_up_var()
  * directly for this memory type.
  */
+static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
+{
+	phys_addr_t phys = PFN_PHYS(pfn);
+	u64 offset = 0;
+
+	for (int i = 0; i < dev_dax->nr_range; i++) {
+		struct range *range = &dev_dax->ranges[i].range;
+
+		if (phys >= range->start && phys <= range->end)
+			return offset + (phys - range->start);
+		offset += range_len(range);
+	}
+	return -1ULL;
+}
+
 static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
 		unsigned long pfn, unsigned long nr_pages, int mf_flags)
 {
 	struct dev_dax *dev_dax = pgmap->owner;
-	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
+	u64 offset = fsdev_pfn_to_offset(dev_dax, pfn);
 	u64 len = nr_pages << PAGE_SHIFT;
 
 	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
-- 
2.53.0


