Return-Path: <nvdimm+bounces-13943-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMyPOHlT6mkhxgIAu9opvQ
	(envelope-from <nvdimm+bounces-13943-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 19:14:33 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EE9455635
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 19:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 20803305646E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 17:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26BD388370;
	Thu, 23 Apr 2026 17:02:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E7438735A;
	Thu, 23 Apr 2026 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963742; cv=none; b=I2YYul7WUN0Xs3MIbGpoqa2359NJo55iuxM00q8UeKD1cBulBWvyeNzagUDumEpe3wJMbx6jkPxRZ3U5NWksVC13YfkWxSYeyRuE08D7gfBY7GzSTOnuYOW0GdhW7Jb5iR86wgI/d4nfNK2qNUigyldtwuXfDxoa+xeFMiR4EuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963742; c=relaxed/simple;
	bh=ypyApHnZEKpoHVLOvakqXzDqjboOFWYPgK/w4Tdo4Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDFFJ8H6C/Tc9hwr5vfjZhxj6Y89fBfhrR6aE4TU8HaeLOPjt+8LKG7R+RGeJcDfMBxCF8D6F7vn3IrHqHcT7W0InHe4Sd93SxHVFOMlFY6947kZfpQpPOWJpgIIAg2u+AU7pRQIVj0f4mLTun7kzx8x12kBZ64VRLBMrTJUgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356E9C2BCAF;
	Thu, 23 Apr 2026 17:02:22 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 01/12] dax: rate limit dev_dax_huge_fault() output
Date: Thu, 23 Apr 2026 10:02:08 -0700
Message-ID: <20260423170219.281618-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[intel.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13943-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:email]
X-Rspamd-Queue-Id: 45EE9455635
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Use dev_dbg_ratelimited() to rate limit the output of
dev_dax_huge_fault() in order to not flood the dmesg output.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 22999a402e02..62206bcb63a6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -244,9 +244,11 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf, unsigned int order)
 	int id;
 	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dev_dax->dev, "%s: op=%s addr=%#lx order=%d\n", current->comm,
-		(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
-		vmf->address & ~((1UL << (order + PAGE_SHIFT)) - 1), order);
+	dev_dbg_ratelimited(&dev_dax->dev, "%s: op=%s addr=%#lx order=%d\n",
+			    current->comm,
+			    (vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
+			    vmf->address & ~((1UL << (order + PAGE_SHIFT)) - 1),
+			    order);
 
 	id = dax_read_lock();
 	if (order == 0)
-- 
2.53.0


