Return-Path: <nvdimm+bounces-13948-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yN2kFIdR6mkhxgIAu9opvQ
	(envelope-from <nvdimm+bounces-13948-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 19:06:15 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C7B45550A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 19:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10D58309A6B1
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 17:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E7D386C2A;
	Thu, 23 Apr 2026 17:02:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79534887E;
	Thu, 23 Apr 2026 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963750; cv=none; b=QeQPS8vQsS/HBDMtcUsgXELShNNBqyERNkTWqJQzbCHiDz6TU3EdGGZSPV5Cxhfwb7dwhIQlknIjIeFVnvqsSAH93ai//7qIgPGUweiVLQtrrWVS6JQ4iJc1+6ABIsS3+8eNn7mic/w8tNtfImIM9XASnbVOwlCkl5WRLkk2Ly8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963750; c=relaxed/simple;
	bh=GWmOwp8QYp1AcydTYqNbCRTEjcWKB6GeAsZZVnHI8ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnENy3B5Hc3BeBdhtLUCKcIVKi+F3CFt+lVFuXbfphKhTXMSVRg5Gk6zWqolShstNT1VjDcG468Gd7lP9vn81HtlCVJckHIkpT1ztB7SaqAolLYAsJ+XLkq5pfSoA4tmVyoIAVXjLzodKXI1c4XHSYJGg68TwlRTYUnp01/Onis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02B9C2BCB3;
	Thu, 23 Apr 2026 17:02:29 +0000 (UTC)
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
Subject: [RFC PATCH 06/12] dax: Add helper to determine if a 'struct file' supports dax
Date: Thu, 23 Apr 2026 10:02:13 -0700
Message-ID: <20260423170219.281618-7-dave.jiang@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[intel.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13948-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 03C7B45550A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a helper function that checks of the file_operations is dax.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 include/linux/dax.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9d624f4d9df6..a5e1a3ca1a0d 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -311,4 +311,11 @@ static inline void hmem_register_resource(int target_nid, struct resource *r)
 typedef int (*walk_hmem_fn)(struct device *dev, int target_nid,
 			    const struct resource *res);
 int walk_hmem_resources(struct device *dev, walk_hmem_fn fn);
+
+extern const struct file_operations dax_fops;
+static inline bool is_file_dax(struct file *file)
+{
+	return file->f_op == &dax_fops;
+}
+
 #endif
-- 
2.53.0


