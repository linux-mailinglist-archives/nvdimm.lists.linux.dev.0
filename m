Return-Path: <nvdimm+bounces-14403-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ExH8ON7zKmrZzwMAu9opvQ
	(envelope-from <nvdimm+bounces-14403-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 19:43:58 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1856741BE
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 19:43:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=jagalactic.com header.s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq header.b="s6Jm/CMg";
	dkim=pass header.d=amazonses.com header.s=224i4yxa5dv7c2xz3womw6peuasteono header.b=qRjO2O21;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14403-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14403-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=jagalactic.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3847935F4FF3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130DC3E1D1B;
	Thu, 11 Jun 2026 17:32:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from a48-180.smtp-out.amazonses.com (a48-180.smtp-out.amazonses.com [54.240.48.180])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C9C4963D8
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:32:39 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199163; cv=none; b=bH6Ws1fKOK6CEEbSvvFeYmeQEeaNvXP9+zcR4KPsAzM57oUZAWV8i+sjthpyFMY06MwnTEIsu/cOBpFd7laFh/mUFxVDxwSIid4qtr4bWpwIFAr3L0d4o6hjiB4Lwyd5WhhObt0OISur7ioRHjljClcP007AyhSScK0OxuWuS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199163; c=relaxed/simple;
	bh=xmS/VRyD3DJzB0A9eEPUMDKNlVXDkbLaDU89X6lOSCs=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=WdnYMfvgK0gej55WxgIZ/8Rz5B22KfVJP4Aa3tihgn4I0igIg45wqfEKeebdro9ecWcRxZzjWj152Q3takIMfULL7HcOW+g+2KDasIDo98dKWAGAtSYBnX5Z4mHDwHV/9lJmp27jaUMjwkpSC7Pu9MLNJkqHfDa9RKj+9NNLwD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=s6Jm/CMg; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=qRjO2O21; arc=none smtp.client-ip=54.240.48.180
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781199158;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=xmS/VRyD3DJzB0A9eEPUMDKNlVXDkbLaDU89X6lOSCs=;
	b=s6Jm/CMgKV+R7OK5X4e0dvE/boQT97cZpn64z7Mm15SfUPxNFP/O3uqtG6ZZpMtB
	UloLvsQgg39CZReCNab0reGrQo+4i565Cyjn76hoTScYduZ8//ilIvi1Jujn7OMYIL1
	+xb/t4hDObeTGXq6Fak2WXIDGXX6LKnzU82Guk/4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781199158;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=xmS/VRyD3DJzB0A9eEPUMDKNlVXDkbLaDU89X6lOSCs=;
	b=qRjO2O2178Iscytaw1cUGyLTyO2PE8NED3NkyZeHT4hf70ZsY5l7aKxFl8kW5cZW
	ThWETvJz1xa08EmvhJ0F8XWmC9tbqlG+Nn2MAOuROvpcI5JNYabhEFtcLb5eO7JSIoe
	a6wSRWV5w0npmNWkJ7AvW7vx9W8lNT9G4bLQyXxI=
Subject: [PATCH V5 6/9] dax/fsdev: fail probe on invalid pgmap offset
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
Date: Thu, 11 Jun 2026 17:32:38 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
References: 
 <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com> 
 <20260611173225.66002-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc+chLnsTTxCDfT7mYrzYAUg07eQ==
Thread-Topic: [PATCH V5 6/9] dax/fsdev: fail probe on invalid pgmap offset
X-Wm-Sent-Timestamp: 1781199157
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019eb7be3bc2-972d848b-bc38-4b24-9ee1-f0dd5610355f-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.11-54.240.48.180
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
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_RECIPIENTS(0.00)[m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:john@groves.net,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14403-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[jagalactic.com:dkim,jagalactic.com:from_mime,intel.com:email,lists.linux.dev:from_smtp,email.amazonses.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,groves.net:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4E1856741BE

From: John Groves <John@Groves.net>

Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
condition means the remapped region starts after the device's data
region, which is an impossible state. Previously the probe continued
with data_offset=0, leaving virt_addr silently misaligned. Now probe
returns -EINVAL with a diagnostic message.

Fixes: 759455848df0b ("dax: Save the kva from memremap")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 07de6bfbbf673..71d2bee1e2805 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -320,8 +320,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
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


