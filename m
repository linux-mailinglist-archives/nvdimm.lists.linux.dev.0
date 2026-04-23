Return-Path: <nvdimm+bounces-13950-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILlVHIpR6mkhxgIAu9opvQ
	(envelope-from <nvdimm+bounces-13950-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 19:06:18 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 505C3455521
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 19:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE575309F44D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Apr 2026 17:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E01D386C2A;
	Thu, 23 Apr 2026 17:02:33 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AC434887E;
	Thu, 23 Apr 2026 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963753; cv=none; b=XgQqAdwxW2SvGDzmZL/T6EoQ4N+PTq0j91wUjafBUSJetg0Osa4E6cQb8ELnMZpllr0h6G7iqtMLslOCumdt7hqoMf6+/HMQQKJO+5Juo8YD8e+OyFTt3THORUb5XEYsHdsSFjcKG2uJAlHRAeUg86S3ht2XQwmufJeiM57MCmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963753; c=relaxed/simple;
	bh=T310uf4jz11RIrONTOHWttLa76u0CTn+M60lbyZmhV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDv+syuvYbcZpCN0y90SPU/AnNbV6WA+nzeJt0jB8OWAXmq7ZMXKVfSVBkZ3qOYeASW2uH90AbeDV/fMQMVO/1LpXJppmknwFsJXkFqeSWmibtkS5OYcNalba0VPgfn2Uk3Telo0wN9li6/JTNyPH7oNcamB/ZOj6jvHeEPOxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0606C2BCAF;
	Thu, 23 Apr 2026 17:02:32 +0000 (UTC)
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
Subject: [RFC PATCH 08/12] fs: allow char dev to go through fallocate
Date: Thu, 23 Apr 2026 10:02:15 -0700
Message-ID: <20260423170219.281618-9-dave.jiang@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[intel.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13950-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:email]
X-Rspamd-Queue-Id: 505C3455521
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Allow a device DAX device to execute fallocate.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 fs/open.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index f328622061c5..7f74604566ac 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -322,7 +322,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (S_ISDIR(inode->i_mode))
 		return -EISDIR;
 
-	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode) &&
+	    !S_ISCHR(inode->i_mode))
 		return -ENODEV;
 
 	/* Check for wraparound */
-- 
2.53.0


