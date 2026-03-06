Return-Path: <nvdimm+bounces-13558-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CL0mD6ldq2mmcQEAu9opvQ
	(envelope-from <nvdimm+bounces-13558-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 07 Mar 2026 00:05:13 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B92442287D2
	for <lists+linux-nvdimm@lfdr.de>; Sat, 07 Mar 2026 00:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB8B8301691A
	for <lists+linux-nvdimm@lfdr.de>; Fri,  6 Mar 2026 23:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9AFC34AB06;
	Fri,  6 Mar 2026 23:05:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2025345CA1;
	Fri,  6 Mar 2026 23:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838309; cv=none; b=Pm1WYrkWbX4bA+hboVMxJ6vVr9Hk30FLMLcy9oC6D6tabnjgxP2ic7JJVe99c7WJknQWGt87Rr+w5YNDZdxMsyDT7i+IMFSUDsfC8gr79Z7K6ATEvy8kGfQHM/rD1bIIEgLA72XuxGpoTetrs98BCX9OJXU9GITSJ0831AtSTVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838309; c=relaxed/simple;
	bh=1T19RrjSbynvoB0taZha6rszp7DUVkE7wsJUoX9iLT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GMJ98HD7xqmTajv6pkBYh4bRU/GtJBBuz42OIJ+Ef6lSJhWdy61p3Kr+CEGwhgAkFwjMwQ80WsHLmQPphdSh41NTdFqv3CLb8DH8upeBNXzRIKxQyhXS4jKXYVvgbod/e7NhhEtQbdWSLEv2/JlLzqp32Q6or1CP3yzJcRJfMgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF0C4CEF7;
	Fri,  6 Mar 2026 23:05:09 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com
Subject: [PATCH] dax: Add direct_access() callback check for dax_direct_access()
Date: Fri,  6 Mar 2026 16:05:07 -0700
Message-ID: <20260306230507.2149965-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B92442287D2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[intel.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13558-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.396];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:mid,intel.com:email]
X-Rspamd-Action: no action

__devm_create_dev_dax() calls alloc_dax() with the ops parameter passed
in as NULL. Therefore the ops pointer in dev_dax can be NULL. Add a
check in dax_direct_access() for ops and ops->direct_access() before
calling ops->direct_access().

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c00b9dff4a06..5cebaf11a58e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -160,6 +160,9 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 	if (nr_pages < 0)
 		return -EINVAL;
 
+	if (!dax_dev->ops || !dax_dev->ops->direct_access)
+		return -EOPNOTSUPP;
+
 	avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
 			mode, kaddr, pfn);
 	if (!avail)

base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0


