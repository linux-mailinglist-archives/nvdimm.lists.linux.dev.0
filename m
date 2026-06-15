Return-Path: <nvdimm+bounces-14425-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ZRchEqMjMGrvOgUAu9opvQ
	(envelope-from <nvdimm+bounces-14425-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 18:09:07 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFFF68820D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 18:09:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=jagalactic.com header.s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq header.b=S6Av9iqh;
	dkim=pass header.d=amazonses.com header.s=224i4yxa5dv7c2xz3womw6peuasteono header.b=SzHNErM2;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14425-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14425-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=jagalactic.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C0B0F30759A3
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 16:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8BE408609;
	Mon, 15 Jun 2026 16:06:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from a48-181.smtp-out.amazonses.com (a48-181.smtp-out.amazonses.com [54.240.48.181])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F97A33C507
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:06:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539594; cv=none; b=cO+/+kF5PnYnYOVCnjIpxgfKt5v7c4zA6it0lyjb0Gr6eXQIRWqqHQTfNWF367DCtnHF99wHFfeXBB2LsENIaKbymuNiXhHMjfAeK/eH51uyE7f4S7xX66gRIFKYQ0TKJmWutS1pD7WVKwYZ05VoJ9J/3u5F/UzSbCSqIfSnGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539594; c=relaxed/simple;
	bh=0D2vsHVhsLnCLb5vX1vq37DUvRSsoFNwdckeMn+P4sc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=jQ9apHq3aCTT2b1qXbXI03aod6jhNawqN1K+Pyy4A/HrWsOmmljBHS9An6oOC3hu1vNfuy3zV9cM+iuNscgaPENob/BHNgNuhciowOR6DX81ZRCd4IPURGyND9LX3bQpQLdzxs5PgKmYpVQUNGWt+WH6g/5ImyngSWjaDna9wQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=S6Av9iqh; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=SzHNErM2; arc=none smtp.client-ip=54.240.48.181
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539592;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=0D2vsHVhsLnCLb5vX1vq37DUvRSsoFNwdckeMn+P4sc=;
	b=S6Av9iqhANZoqlgBNdD4Xm6gtXBLLFqH6mYxcVoZiV7liDJMWmcLp2jBHz3X9ynJ
	SmZwUrOu6EQd45tPp9a1Xw1Mr02JrS+FVW8Q/ZtKp2i1jdoHtSCXQwRPNtuum+HfJwf
	+tdfpRjW/TQXlSEgHb5lLT+9hJk2C08mp8+rIthM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539592;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=0D2vsHVhsLnCLb5vX1vq37DUvRSsoFNwdckeMn+P4sc=;
	b=SzHNErM2DnZ3V54pKyqzEYg30p8k5KEY8iJSmCH8KKyqbb0gTFd6a1Y7QRFpl/v3
	SeASGTiuybzFSvx6r/y5Txe1cAAZkOrediM+q1ga9W6gjD0HR9eQM9sePJUuBW6xBC2
	EOqfvLVxDt7c4Ebs69udN9XzqtenAfrotLGDeb5Y=
Subject: [PATCH V6 02/10] dax/fsdev: fix multi-range offset in memory_failure
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
Date: Mon, 15 Jun 2026 16:06:32 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
References: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com> 
 <20260615160626.17473-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAAB+YC
Thread-Topic: [PATCH V6 02/10] dax/fsdev: fix multi-range offset in
 memory_failure handler
X-Wm-Sent-Timestamp: 1781539590
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc08d74f-ec0d09b8-11e9-4e5b-af48-8c6d382af486-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.48.181
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_RECIPIENTS(0.00)[m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:john@groves.net,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14425-lists,linux-nvdimm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EXCESS_QP(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[jagalactic.com:dkim,jagalactic.com:from_mime,email.amazonses.com:mid,lists.linux.dev:from_smtp,groves.net:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,amazonses.com:dkim,intel.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: AEFFF68820D

From: John Groves <John@Groves.net>

Fix memory_failure offset calculation for multi-range devices. The old
code subtracted ranges[0].range.start from the faulting PFN's physical
address, which produces an incorrect (inflated) logical offset when the
PFN falls in ranges[1] or beyond due to physical gaps between ranges.
Add fsdev_pfn_to_offset() to walk the range list and compute the correct
device-linear byte offset relative to ranges[0].start (the device data
start) -- the base the holder (xfs, famfs) maps from -- for both static
and dynamic devices.

V5 walked the pagemap's immutable pgmap->ranges[] instead, to avoid
reading the mutable dev_dax->ranges[] from this callback. That had a
different problem: it regressed static devices, where pgmap->ranges[0].start
can sit data_offset below the data start, so the reported offset came out
data_offset too high and the holder would act on the wrong blocks. For
dynamic devices the two arrays are identical, so pgmap->ranges[] only ever
helped the dynamic case while breaking the static one. Walk
dev_dax->ranges[] instead. (Richard Cheng spotted the static regression.)

Reading dev_dax->ranges[] here may race a concurrent krealloc() of the
range array via sysfs (mapping_store(), under dax_region_rwsem, which
this ->memory_failure callback does not hold). That exposure is
pre-existing -- the original single-range code read dev_dax->ranges[0]
locklessly as well -- so this patch does not make it worse; a proper fix
(locking or snapshotting) belongs in a separate change.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
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


