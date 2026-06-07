Return-Path: <nvdimm+bounces-14328-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mOmkI5HHJWoVLwIAu9opvQ
	(envelope-from <nvdimm+bounces-14328-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 07 Jun 2026 21:33:37 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 338D36515F3
	for <lists+linux-nvdimm@lfdr.de>; Sun, 07 Jun 2026 21:33:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=jagalactic.com header.s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq header.b="BKGBF0f/";
	dkim=pass header.d=amazonses.com header.s=224i4yxa5dv7c2xz3womw6peuasteono header.b=lQZshmQw;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14328-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14328-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=jagalactic.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E52493002324
	for <lists+linux-nvdimm@lfdr.de>; Sun,  7 Jun 2026 19:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7EA13101D8;
	Sun,  7 Jun 2026 19:33:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from a11-131.smtp-out.amazonses.com (a11-131.smtp-out.amazonses.com [54.240.11.131])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD8831E826
	for <nvdimm@lists.linux.dev>; Sun,  7 Jun 2026 19:33:31 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780860812; cv=none; b=dXZ8TPkd60Lc7p26qk1+kLZvnTTmOUW8/BeHZWM3TIp0HELSROfabY/Ki17BpEghsmi0IZ5iuA6bqMwb6vdtJz9vyO34RzmCppg83BHhxE/96DNE8y1occCzxn0nmaSwUVZ7td/djLT1acLUKkV/ukaSd4y2a1kXOxjRFG+1o7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780860812; c=relaxed/simple;
	bh=4tanUO3miWAURhJritZbKxZlEXb0a0H/iJgHp+eqKpA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=FF4HQS1/nZ8Lc1t2XZdLF+kFaIKE/68nUqVmNQDuGMqQ5+YAWMfZM7P4Zged5LF6oeusz6gvF2cUZP7nQ1/dwlGEFSofwJW+8lQhbr11v8RU1fDbpblbm3nH80uvpi1RCdscoWIi8APF1mxGR9+aRMBQ+4AI0KZ0FD567vci46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=BKGBF0f/; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=lQZshmQw; arc=none smtp.client-ip=54.240.11.131
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780860810;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=4tanUO3miWAURhJritZbKxZlEXb0a0H/iJgHp+eqKpA=;
	b=BKGBF0f/zu7Uhv+90Nk65lcPrPGDO1B+cxRMw8ZbHlq0nmvdKU1ze6QQ7ODOPcu8
	GA9MWs4PoClKN/8q1PsZoHZKKnbFpjBKMbomS7MhyWc50L8EugO2CBWGGGnhdmL0mVm
	/FYXgvcboN5Nr063A6/JsTiMDcjf6yxXTohx/C7M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780860810;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=4tanUO3miWAURhJritZbKxZlEXb0a0H/iJgHp+eqKpA=;
	b=lQZshmQwfQe1NRbAeYpco5Gxt7XpqEOaOSyd88LzecFGXeoT3hvDaPoxnMNgnWcc
	Rii0WPI55dbyC0pu3OrN4dSUtu8CHOn549HvRuuzgJI5GY0+0JTw8rHbZm8n0UIu5V9
	dtBHHY6fu49QB/5PxV7pNjAGdMMlwWBDzY6ThgJU=
Subject: [PATCH V4 3/9] dax/fsdev: clear vmemmap_shift when binding static
 pgmap
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
Date: Sun, 7 Jun 2026 19:33:30 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
References: 
 <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com> 
 <20260607193322.94309-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc9rRhSPXw4ZdTQtuvnkZG9OrQIgAACNCS
Thread-Topic: [PATCH V4 3/9] dax/fsdev: clear vmemmap_shift when binding
 static pgmap
X-Wm-Sent-Timestamp: 1780860809
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ea39374a8-bfa199e6-bd3a-45c6-acf1-9212be962224-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.07-54.240.11.131
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
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
	TAGGED_FROM(0.00)[bounces-14328-lists,linux-nvdimm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[amazonses.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,jagalactic.com:from_mime,jagalactic.com:dkim,groves.net:email,email.amazonses.com:mid,lists.linux.dev:from_smtp,intel.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 338D36515F3

From: John Groves <John@Groves.net>

Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
device from device_dax (which may set vmemmap_shift based on alignment) to
fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
zero it before devm_memremap_pages() so the vmemmap is built for order-0
folios as fsdev requires.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index f315533b299e9..dbd722ed7ab05 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 
 		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
 	} else {
 		size_t pgmap_size;
 
-- 
2.53.0


