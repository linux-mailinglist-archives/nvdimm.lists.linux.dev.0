Return-Path: <nvdimm+bounces-14398-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id JMrCHVX2Kmph0AMAu9opvQ
	(envelope-from <nvdimm+bounces-14398-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 19:54:29 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AFF674312
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 19:54:28 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=jagalactic.com header.s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq header.b=cwFHIrxx;
	dkim=pass header.d=amazonses.com header.s=224i4yxa5dv7c2xz3womw6peuasteono header.b=Mz7cGpc5;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14398-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14398-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=jagalactic.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4CA034ED49A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9903D408034;
	Thu, 11 Jun 2026 17:31:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from a11-32.smtp-out.amazonses.com (a11-32.smtp-out.amazonses.com [54.240.11.32])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78486397352
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:31:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199114; cv=none; b=Ix+A71MzczzlfpzosnwloSzLIF9sOL4n0BFZRDvEBF1gwgHEvxnW01wyYc4gao7ie3n6u3Lmct7WMRtic57g+y+Eo8icSJTlsb08r50uzUwQ0CqOuwepoOFvq5rCGtBRYRfCCMaTKiuQnzUxLm9vTYtX6TRps70aZTQk6FPs2oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199114; c=relaxed/simple;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=n048HdPqN+Bk08O68JP+JZEfuwzAJ+WZyWAfWTauc0xQfGJxSuV/EBEX82J5Zk3GCmfMnXhLSr5WnGOAVFsykuszIlqk8rnRkwd/+1FCGVFth8AOWpQ3d22qQdoX5bwkpTn7j6wr64g1PwSGJh6KpHaHrMzE94Ymb2BQItFxqNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=cwFHIrxx; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Mz7cGpc5; arc=none smtp.client-ip=54.240.11.32
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781199110;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	b=cwFHIrxxQmFA73cFNJRxmAIg4rmiuVq1Wew6e9eQ00e2u/e+96cb6SUhgIMilFqz
	2UFzu8pMAnV5GBMZGfex5P7M/Vq1R+RX6Hw+frxGpJWx1wnlewgvDiNDOV3KwabbF2E
	P1Up6dZvCzlHD5hz7jVxBE5Bvk0dXldcTyTCkDj4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781199110;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	b=Mz7cGpc5d/q1zW4YK+tf4x3TpcqiBqqcODc+q5QGGJXS4ypD+1UhcUQSZdyTXi4l
	JgN9ohM3k7aEmVk7aYLUqSDA6EQBOMjxlE0TXVaYqBD11C8bTKHlRMKT0hAUlB7avO7
	u3jKFEtr3GXnuXlWra92f6ccrUuTFJ5nfnNzDoBM=
Subject: [PATCH V5 1/9] dax: fix misleading comment about share/index union
 in dax_folio_reset_order()
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
Date: Thu, 11 Jun 2026 17:31:50 +0000
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
 <20260611173142.65888-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc+cgurO76MEFiTUm2OqQBov9Lcg==
Thread-Topic: [PATCH V5 1/9] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
X-Wm-Sent-Timestamp: 1781199108
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019eb7bd8020-e207035e-a112-4c27-a9c9-2537a73cd8da-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.11-54.240.11.32
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-14398-lists,linux-nvdimm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lists.linux.dev:from_smtp,jagalactic.com:dkim,jagalactic.com:from_mime,email.amazonses.com:mid,intel.com:email,amazonses.com:dkim,groves.net:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C7AFF674312

From: John Groves <John@Groves.net>

The comment in dax_folio_reset_order() claims that DAX maintains an
invariant where folio->share != 0 only when folio->mapping == NULL,
implying folio->share is zero whenever mapping is non-NULL. This is
misleading because folio->share and folio->index are a union -- for
non-shared folios with mapping != NULL, reading folio->share returns
the file page offset (folio->index), which is typically non-zero.

Reword the comment to accurately describe the union aliasing: the
assignment clears whichever interpretation of the union word is active
(index for non-shared folios, share for shared folios), which is correct
because the folio is being released in either case.

No functional change -- the code was already correct, only the
justification was wrong.

Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")

Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/dax.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99b..df19c9317d10e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -392,12 +392,12 @@ int dax_folio_reset_order(struct folio *folio)
 	int order = folio_order(folio);
 
 	/*
-	 * DAX maintains the invariant that folio->share != 0 only when
-	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
-	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
-	 * Callers ensure share has been decremented to zero before
-	 * calling here, so unconditionally clearing both fields is
-	 * correct.
+	 * Clear the mapping and the index/share union word. folio->share
+	 * and folio->index occupy the same union in struct folio. For
+	 * non-shared folios (mapping != NULL), the union holds folio->index
+	 * (file page offset); for shared folios (mapping == NULL), it holds
+	 * folio->share (reference count). Either way, we are releasing the
+	 * folio and both fields should be zeroed.
 	 */
 	folio->mapping = NULL;
 	folio->share = 0;
-- 
2.53.0


