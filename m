Return-Path: <nvdimm+bounces-14430-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id WbQ8M6IkMGo6OwUAu9opvQ
	(envelope-from <nvdimm+bounces-14430-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 18:13:22 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 308746882F8
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 18:13:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=jagalactic.com header.s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq header.b=aZIBquln;
	dkim=pass header.d=amazonses.com header.s=224i4yxa5dv7c2xz3womw6peuasteono header.b=TyNkrgAA;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14430-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14430-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=jagalactic.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03CDC315AECD
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 16:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F05408638;
	Mon, 15 Jun 2026 16:07:24 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from a11-121.smtp-out.amazonses.com (a11-121.smtp-out.amazonses.com [54.240.11.121])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6ED408005
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:07:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539644; cv=none; b=Oz41o07/HhT+oIdv/ZzNQYOu/1Ow9ukVq1mjsn4dzG1Z6djcYSFn2AqxptRaX5XCe8/NnxLDCaSNxlSPqjnA2l8/kC25cP44+7PgDPJQH08d506oYUyWNIR0UMe6tD7mX5opYzqpUOfrbi40ePMlkUQQV+FAdvmD1edVtrFj4ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539644; c=relaxed/simple;
	bh=Rmq+YvTkFCZBIZoHnHHQCa+fKuJcDptbmVPQTA5zk70=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=gfHhUvYYjQI3KAIy2PnFRDtMlVd/Z9Jaa/WCcuI1WeCfT2fZwAsEwuVaOyAYZQUj/OHPQOsFPIWlAJwiVTPgrvmFBnjYYsSjvFFiC1vfVa69V4c/50HtryA7rj2s4X2XhfUOP8QAHeAeD/XX8497W7ThhcxEaYCeHP3UZky6ZMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=aZIBquln; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=TyNkrgAA; arc=none smtp.client-ip=54.240.11.121
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539642;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Rmq+YvTkFCZBIZoHnHHQCa+fKuJcDptbmVPQTA5zk70=;
	b=aZIBqulntmFM5axdapNl1y/dzRmIzvaQfv4Vml/ZMGFcr6NcJn8RusUfNT5i3Mm4
	oUx3Us5QPfcwH2gm2Jg09qCAmkVS6agzMicXW0b/YqDykWGWzyXM7D9YnylyeyaKmqB
	79neBFhxpGb2tI4aNVR5y0XY6MvuYhvlxre0Eb9U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539642;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Rmq+YvTkFCZBIZoHnHHQCa+fKuJcDptbmVPQTA5zk70=;
	b=TyNkrgAAvCClsdEiW23Ja8pCl6oD9C1IthHjYHv5WWfx9ZmM7WtrywKAdOFBKum4
	IXNsk7JHdTWPpDF/OXll35KwPmWh31yZqKZ+GngTwiwhP+xLiLhFJX5vIdEEPXXUo9z
	VLv8imH/4MmYeMfdyBoNrBgaqqtMs/R9uF2GIm0c=
Subject: [PATCH V6 07/10] dax/fsdev: fail probe on invalid pgmap offset
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
	=?UTF-8?Q?Pankaj_Gupta?= <pankaj.gupta@amd.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 15 Jun 2026 16:07:21 +0000
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
 <20260615160713.17567-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAAD0CF
Thread-Topic: [PATCH V6 07/10] dax/fsdev: fail probe on invalid pgmap offset
X-Wm-Sent-Timestamp: 1781539640
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc0999fa-97574544-8b6b-46cf-9f33-423abdbeee7f-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.11.121
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FORGED_RECIPIENTS(0.00)[m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:pankaj.gupta@amd.com,m:john@groves.net,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14430-lists,linux-nvdimm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,email.amazonses.com:mid,amd.com:email,jagalactic.com:dkim,jagalactic.com:from_mime,intel.com:email,amazonses.com:dkim,groves.net:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 308746882F8

From: John Groves <John@Groves.net>

Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
condition means the remapped region starts after the device's data
region, which is an impossible state. Previously the probe continued
with data_offset=0, leaving virt_addr silently misaligned. Now probe
returns -EINVAL with a diagnostic message.

Fixes: 759455848df0b ("dax: Save the kva from memremap")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 57c589e19b539..d50891d6dc135 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -342,8 +342,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		u64 phys = dev_dax->ranges[0].range.start;
 		u64 pgmap_phys = pgmap[0].range.start;
 
-		if (!WARN_ON(pgmap_phys > phys))
-			data_offset = phys - pgmap_phys;
+		if (pgmap_phys > phys) {
+			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
+				pgmap_phys, phys);
+			return -EINVAL;
+		}
+		data_offset = phys - pgmap_phys;
 
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
-- 
2.53.0


