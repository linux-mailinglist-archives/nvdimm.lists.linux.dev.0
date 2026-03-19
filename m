Return-Path: <nvdimm+bounces-13614-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOD2LWtRu2lMigIAu9opvQ
	(envelope-from <nvdimm+bounces-13614-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 02:29:15 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 434112C46F0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 02:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3BC9302BA6E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 01:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C766C272816;
	Thu, 19 Mar 2026 01:28:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F711274B28
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883722; cv=none; b=tx1BiJVF29V79LhX0kHNe0xpJhyq4vhbCLsmM/2+q6ieSIGK9lrs3WPhXywz7LTJauPby3kvDRiuHJOsdJo+Kn5m3pjg+k9M68zWmjxF/Clqwv9by+nEi37eDLzFXP9PQAjkq+tvkQChUgWfyZbbzMopE1GjGmur7jj22htngA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883722; c=relaxed/simple;
	bh=Ry6ZwT2wcK2EVliZ6GUD3Ky5ZHSkdkjw/auIlV0cCvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wd7TcFsHMPa0/VMdyEBV0WshSARK6NYooh9Ff5XVgz82wpM0DNz5bHDYMOJucTzZOI0iJ9ldFFaI2RLc4mJc1fStgoHZP7dVCYsj5cOZ3n3mE4nG5WvQOp7eKmMDyAuTCantwZnZOBDELITDjCYGRlKAvbwC/uvhCqquZbL2SO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7051C1473;
	Thu, 19 Mar 2026 01:28:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf01.hostedemail.com (Postfix) with ESMTPA id 124C860011;
	Thu, 19 Mar 2026 01:28:21 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	John Groves <john@groves.net>
Subject: [PATCH V8 2/8] dax: Factor out dax_folio_reset_order() helper
Date: Wed, 18 Mar 2026 20:28:20 -0500
Message-ID: <20260319012820.4420-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318202737.4344.dax@groves.net>
References: <20260318202737.4344.dax@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7jfuk6j51u3nexgxzqcigmkhm6c3yu93
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX193/2KCMcDN1qObYg7IwfiEoGyzE3Mk658=
X-HE-Tag: 1773883701-112408
X-HE-Meta: U2FsdGVkX1+1VGfp9NQnPzohqKLhLXTmEFvKc1+zZIX4U7QqCLAY72FbBM/05Vv/nQQ0RDpc8hlaZag9axLqmDhnsYs8jYlc8F9Ptb/jalAyGraq27Wz6TUz347vPnyvVEaSZh0JvbQ02c0irK/1y6X1BGjUPTyrHHt5cyiZD1yiBv4OGsyiKeWck+oIdhbH2zZFNW5lNiXFKCjEKsNjV3ID0dNHIGKxzk3HkeqYjuG+hDl1vAVKW9TfuG4tLhaXA2s7VqGT8ntf+iPDHedLc35wjfAAnrFG0AB+4Ac5o47NGsTe9I5ytxn4u7DhQpVO0SRCcCdeiQYKYJHjPOsrpH09uBWcJQ6ce99XeNKa6FiNWXppkhKVVzZ/axrrvXQZ
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[42];
	FREEMAIL_CC(0.00)[micron.com,lwn.net,linuxfoundation.org,intel.com,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev,groves.net];
	TAGGED_FROM(0.00)[bounces-13614-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[groves.net];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.385];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,groves.net:email,groves.net:mid,intel.com:email]
X-Rspamd-Queue-Id: 434112C46F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: John Groves <John@Groves.net>

Both fs/dax.c:dax_folio_put() and drivers/dax/fsdev.c:
fsdev_clear_folio_state() (the latter coming in the next commit after this
one) contain nearly identical code to reset a compound DAX folio back to
order-0 pages. Factor this out into a shared helper function.

The new dax_folio_reset_order() function:
- Clears the folio's mapping and share count
- Resets compound folio state via folio_reset_order()
- Clears PageHead and compound_head for each sub-page
- Restores the pgmap pointer for each resulting order-0 folio
- Returns the original folio order (for callers that need to advance by
  that many pages)

This simplifies fsdev_clear_folio_state() from ~50 lines to ~15 lines while
maintaining the same functionality in both call sites.

Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/dax.c | 60 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 289e6254aa30..7d7bbfb32c41 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -378,6 +378,45 @@ static void dax_folio_make_shared(struct folio *folio)
 	folio->share = 1;
 }
 
+/**
+ * dax_folio_reset_order - Reset a compound DAX folio to order-0 pages
+ * @folio: The folio to reset
+ *
+ * Splits a compound folio back into individual order-0 pages,
+ * clearing compound state and restoring pgmap pointers.
+ *
+ * Returns: the original folio order (0 if already order-0)
+ */
+int dax_folio_reset_order(struct folio *folio)
+{
+	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
+	int order = folio_order(folio);
+	int i;
+
+	folio->mapping = NULL;
+	folio->share = 0;
+
+	if (!order) {
+		folio->pgmap = pgmap;
+		return 0;
+	}
+
+	folio_reset_order(folio);
+
+	for (i = 0; i < (1UL << order); i++) {
+		struct page *page = folio_page(folio, i);
+		struct folio *f = (struct folio *)page;
+
+		ClearPageHead(page);
+		clear_compound_head(page);
+		f->mapping = NULL;
+		f->share = 0;
+		f->pgmap = pgmap;
+	}
+
+	return order;
+}
+
 static inline unsigned long dax_folio_put(struct folio *folio)
 {
 	unsigned long ref;
@@ -391,28 +430,13 @@ static inline unsigned long dax_folio_put(struct folio *folio)
 	if (ref)
 		return ref;
 
-	folio->mapping = NULL;
-	order = folio_order(folio);
-	if (!order)
-		return 0;
-	folio_reset_order(folio);
+	order = dax_folio_reset_order(folio);
 
+	/* Debug check: verify refcounts are zero for all sub-folios */
 	for (i = 0; i < (1UL << order); i++) {
-		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
 		struct page *page = folio_page(folio, i);
-		struct folio *new_folio = (struct folio *)page;
 
-		ClearPageHead(page);
-		clear_compound_head(page);
-
-		new_folio->mapping = NULL;
-		/*
-		 * Reset pgmap which was over-written by
-		 * prep_compound_page().
-		 */
-		new_folio->pgmap = pgmap;
-		new_folio->share = 0;
-		WARN_ON_ONCE(folio_ref_count(new_folio));
+		WARN_ON_ONCE(folio_ref_count((struct folio *)page));
 	}
 
 	return ref;
-- 
2.53.0


