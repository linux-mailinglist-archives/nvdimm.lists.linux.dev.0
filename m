Return-Path: <nvdimm+bounces-13995-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cILNCCUU+mmlJAMAu9opvQ
	(envelope-from <nvdimm+bounces-13995-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 05 May 2026 18:00:37 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C374D0CB6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 05 May 2026 18:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6DD47300D682
	for <lists+linux-nvdimm@lfdr.de>; Tue,  5 May 2026 15:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD410481FBD;
	Tue,  5 May 2026 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NYCsE1KM"
X-Original-To: nvdimm@lists.linux.dev
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712323DEAD5
	for <nvdimm@lists.linux.dev>; Tue,  5 May 2026 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996583; cv=none; b=B08eXm13EWgivOArlLgAo3DeWTU5grH6etuNdg8IFWf1Mitjmh1rDX6vMiHtR1JW1MdCae60B7FBWnvR3CNi0aWQFaFPkXB0PAHj1oNnjMCDQ5GTrktfzOvk6EV+LdsbL7NOzObxzRK1yOVqv0jOhRhIJrgw8inwN6RCe+1fP7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996583; c=relaxed/simple;
	bh=kvJeHu3YGkMrq2Vupe9NLww3ryBGHfmI7ERF9HH9Xuk=;
	h=From:To:Subject:CC:Date:Message-ID:MIME-Version:Content-Type; b=kzZE2KPrDAf7NtHEi03hyoiXLcWP+8CQjMuGjJcXKJ72+LwTRtEu8A1SJVPdEmQFX7+7KitP1+BvChSuqQoJd/AXAd/k6bEZceujau22bT5putxVA4zKL0hXPGH6RcN/5fse23DOB0YJ58AajlIEMbnxYdXzjXyXxRlBKfflzUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NYCsE1KM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B3B62681;
	Tue,  5 May 2026 08:56:14 -0700 (PDT)
Received: from GX9GF4H4XN (unknown [10.1.25.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A67CE3F836;
	Tue,  5 May 2026 08:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777996579; bh=kvJeHu3YGkMrq2Vupe9NLww3ryBGHfmI7ERF9HH9Xuk=;
	h=From:To:Subject:CC:Date:From;
	b=NYCsE1KM5DeKUXhyKa+C+1z08/dxT/RHr2cHuIiKwpOq5paO/igWgTvFZaRPWJtxC
	 DY/V/H95uIy4lACZiBSae6XEjGRiptbTk9eg7M17HILbTl2MYCFX+FPujEcYyw/bID
	 8y/DXb4+X7jKxMxxv3c/417/Qd5Zm7xtJTFCHbFE=
From: Seunguk Shin <seunguk.shin@arm.com>
To: <linux-kernel@vger.kernel.org>, <dan.j.williams@intel.com>
Subject: [PATCH v3] fs/dax: check zero or empty entry before converting
 xarray entry
CC: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <jack@suse.cz>, <willy@infradead.org>, <Nick.Connolly@arm.com>,
 <ffidencio@nvidia.com>, <seunguk.shin@arm.com>
Date: Tue, 05 May 2026 16:56:08 +0100
Message-ID: <m2jythetpj.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 88C374D0CB6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13995-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seunguk.shin@arm.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,suse.cz:email,nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

dax_associate_entry(), dax_disassociate_entry(), and dax_busy_page()
call dax_to_folio(entry) before checking whether entry is a zero or
empty xarray entry.

That ordering is wrong because zero and empty entries are not folio
entries. Commit 98c183a4fccf ("fs/dax: don't disassociate zero page
entries") added guards in the associate and disassociate paths, but the
guards still come after dax_to_folio(entry), and dax_busy_page() still
has the same problem.

Move the zero/empty checks before dax_to_folio(entry) in all three helpers.

Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Signed-off-by: Seunguk Shin <seunguk.shin@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
---
Changes in v3:
- Rebase on current upstream
- Update the changelog for the current code state
- Link to v2: https://lore.kernel.org/all/m2jyv11mqe.fsf@arm.com/
Changes in v2:
- Add Fixes and Reviewed-by tags.
- Rebase on the latest.
- Link to v1: https://lore.kernel.org/all/18af3213-6c46-4611-ba75-da5be5a1c9b0@arm.com/
---
 fs/dax.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..4bca6e2bc342 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 				unsigned long address, bool shared)
 {
 	unsigned long size = dax_entry_size(entry), index;
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	index = linear_page_index(vma, address & ~(size - 1));
 	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
 		if (folio->mapping)
@@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 				bool trunc)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	dax_folio_put(folio);
 }
 
 static struct page *dax_busy_page(void *entry)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return NULL;
 
+	folio = dax_to_folio(entry);
 	if (folio_ref_count(folio) - folio_mapcount(folio))
 		return &folio->page;
 	else
-- 
2.34.1

