Return-Path: <nvdimm+bounces-2225-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0CB470539
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Dec 2021 17:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id DB09E1C0A9D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Dec 2021 16:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0112CB2;
	Fri, 10 Dec 2021 16:05:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086E52CA3
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 16:05:22 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 6FDA521110;
	Fri, 10 Dec 2021 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1639152320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PwVGINUVqHAId1PKuLIr3OxtqoUakx6UY/6c5besVNo=;
	b=iBfhZQlEFruDj4/vvSk0TFWwssr3Wy5jed/Nk4jxsAEy4/eaHsRUBcs8QnbtAJJST9TPA2
	k2VDb6TSNzt+GTDpM2H9GSFZRVlDlpZRErs97yC/6jTwT8BZFu7bdOY1gJviG0LdNy8oH3
	AIiZPtw+KwlicO9FodYjwdxMrhkQLSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1639152320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PwVGINUVqHAId1PKuLIr3OxtqoUakx6UY/6c5besVNo=;
	b=5l/GtzQL7cNt2ee4q6ce/kmaiHkTLyXTdpcVGOXYM3C0iulOXXn7f90C+0MKe1Rw4FP7tG
	+SOO8liH5IIyRUAg==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 96040A3B91;
	Fri, 10 Dec 2021 16:05:17 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: nvdimm@lists.linux.dev,
	linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v5 2/6] badblocks: add helper routines for badblock ranges handling
Date: Sat, 11 Dec 2021 00:04:51 +0800
Message-Id: <20211210160456.56816-3-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210160456.56816-1-colyli@suse.de>
References: <20211210160456.56816-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds several helper routines to improve badblock ranges
handling. These helper routines will be used later in the improved
version of badblocks_set()/badblocks_clear()/badblocks_check().

- Helpers prev_by_hint() and prev_badblocks() are used to find the bad
  range from bad table which the searching range starts at or after.

- The following helpers are to decide the relative layout between the
  manipulating range and existing bad block range from bad table.
  - can_merge_behind()
    Return 'true' if the manipulating range can backward merge with the
    bad block range.
  - can_merge_front()
    Return 'true' if the manipulating range can forward merge with the
    bad block range.
  - can_combine_front()
    Return 'true' if two adjacent bad block ranges before the
    manipulating range can be merged.
  - overlap_front()
    Return 'true' if the manipulating range exactly overlaps with the
    bad block range in front of its range.
  - overlap_behind()
    Return 'true' if the manipulating range exactly overlaps with the
    bad block range behind its range.
  - can_front_overwrite()
    Return 'true' if the manipulating range can forward overwrite the
    bad block range in front of its range.

- The following helpers are to add the manipulating range into the bad
  block table. Different routine is called with the specific relative
  layout between the manipulating range and other bad block range in the
  bad block table.
  - behind_merge()
    Merge the manipulating range with the bad block range behind its
    range, and return the number of merged length in unit of sector.
  - front_merge()
    Merge the manipulating range with the bad block range in front of
    its range, and return the number of merged length in unit of sector.
  - front_combine()
    Combine the two adjacent bad block ranges before the manipulating
    range into a larger one.
  - front_overwrite()
    Overwrite partial of whole bad block range which is in front of the
    manipulating range. The overwrite may split existing bad block range
    and generate more bad block ranges into the bad block table.
  - insert_at()
    Insert the manipulating range at a specific location in the bad
    block table.

All the above helpers are used in later patches to improve the bad block
ranges handling for badblocks_set()/badblocks_clear()/badblocks_check().

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Geliang Tang <geliang.tang@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---
 block/badblocks.c | 376 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 376 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index d39056630d9c..30958cc4469f 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -16,6 +16,382 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
+/*
+ * Find the range starts at-or-before 's' from bad table. The search
+ * starts from index 'hint' and stops at index 'hint_end' from the bad
+ * table.
+ */
+static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
+{
+	int hint_end = hint + 2;
+	u64 *p = bb->page;
+	int ret = -1;
+
+	while ((hint < hint_end) && ((hint + 1) <= bb->count) &&
+	       (BB_OFFSET(p[hint]) <= s)) {
+		if ((hint + 1) == bb->count || BB_OFFSET(p[hint + 1]) > s) {
+			ret = hint;
+			break;
+		}
+		hint++;
+	}
+
+	return ret;
+}
+
+/*
+ * Find the range starts at-or-before bad->start. If 'hint' is provided
+ * (hint >= 0) then search in the bad table from hint firstly. It is
+ * very probably the wanted bad range can be found from the hint index,
+ * then the unnecessary while-loop iteration can be avoided.
+ */
+static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
+			  int hint)
+{
+	sector_t s = bad->start;
+	int ret = -1;
+	int lo, hi;
+	u64 *p;
+
+	if (!bb->count)
+		goto out;
+
+	if (hint >= 0) {
+		ret = prev_by_hint(bb, s, hint);
+		if (ret >= 0)
+			goto out;
+	}
+
+	lo = 0;
+	hi = bb->count;
+	p = bb->page;
+
+	while (hi - lo > 1) {
+		int mid = (lo + hi)/2;
+		sector_t a = BB_OFFSET(p[mid]);
+
+		if (a <= s)
+			lo = mid;
+		else
+			hi = mid;
+	}
+
+	if (BB_OFFSET(p[lo]) <= s)
+		ret = lo;
+out:
+	return ret;
+}
+
+/*
+ * Return 'true' if the range indicated by 'bad' can be backward merged
+ * with the bad range (from the bad table) index by 'behind'.
+ */
+static bool can_merge_behind(struct badblocks *bb, struct badblocks_context *bad,
+			     int behind)
+{
+	sector_t sectors = bad->len;
+	sector_t s = bad->start;
+	u64 *p = bb->page;
+
+	if ((s <= BB_OFFSET(p[behind])) &&
+	    ((s + sectors) >= BB_OFFSET(p[behind])) &&
+	    ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
+	    BB_ACK(p[behind]) == bad->ack)
+		return true;
+	return false;
+}
+
+/*
+ * Do backward merge for range indicated by 'bad' and the bad range
+ * (from the bad table) indexed by 'behind'. The return value is merged
+ * sectors from bad->len.
+ */
+static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
+			int behind)
+{
+	sector_t sectors = bad->len;
+	sector_t s = bad->start;
+	u64 *p = bb->page;
+	int merged = 0;
+
+	WARN_ON(s > BB_OFFSET(p[behind]));
+	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
+
+	if (s < BB_OFFSET(p[behind])) {
+		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
+
+		merged = min_t(sector_t, sectors, BB_OFFSET(p[behind]) - s);
+		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
+	} else {
+		merged = min_t(sector_t, sectors, BB_LEN(p[behind]));
+	}
+
+	WARN_ON(merged == 0);
+
+	return merged;
+}
+
+/*
+ * Return 'true' if the range indicated by 'bad' can be forward
+ * merged with the bad range (from the bad table) indexed by 'prev'.
+ */
+static bool can_merge_front(struct badblocks *bb, int prev,
+			    struct badblocks_context *bad)
+{
+	sector_t s = bad->start;
+	u64 *p = bb->page;
+
+	if (BB_ACK(p[prev]) == bad->ack &&
+	    (s < BB_END(p[prev]) ||
+	     (s == BB_END(p[prev]) && (BB_LEN(p[prev]) < BB_MAX_LEN))))
+		return true;
+	return false;
+}
+
+/*
+ * Do forward merge for range indicated by 'bad' and the bad range
+ * (from bad table) indexed by 'prev'. The return value is sectors
+ * merged from bad->len.
+ */
+static int front_merge(struct badblocks *bb, int prev, struct badblocks_context *bad)
+{
+	sector_t sectors = bad->len;
+	sector_t s = bad->start;
+	u64 *p = bb->page;
+	int merged = 0;
+
+	WARN_ON(s > BB_END(p[prev]));
+
+	if (s < BB_END(p[prev])) {
+		merged = min_t(sector_t, sectors, BB_END(p[prev]) - s);
+	} else {
+		merged = min_t(sector_t, sectors, BB_MAX_LEN - BB_LEN(p[prev]));
+		if ((prev + 1) < bb->count &&
+		    merged > (BB_OFFSET(p[prev + 1]) - BB_END(p[prev]))) {
+			merged = BB_OFFSET(p[prev + 1]) - BB_END(p[prev]);
+		}
+
+		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+				  BB_LEN(p[prev]) + merged, bad->ack);
+	}
+
+	return merged;
+}
+
+/*
+ * 'Combine' is a special case which can_merge_front() is not able to
+ * handle: If a bad range (indexed by 'prev' from bad table) exactly
+ * starts as bad->start, and the bad range ahead of 'prev' (indexed by
+ * 'prev - 1' from bad table) exactly ends at where 'prev' starts, and
+ * the sum of their lengths does not exceed BB_MAX_LEN limitation, then
+ * these two bad range (from bad table) can be combined.
+ *
+ * Return 'true' if bad ranges indexed by 'prev' and 'prev - 1' from bad
+ * table can be combined.
+ */
+static bool can_combine_front(struct badblocks *bb, int prev,
+			      struct badblocks_context *bad)
+{
+	u64 *p = bb->page;
+
+	if ((prev > 0) &&
+	    (BB_OFFSET(p[prev]) == bad->start) &&
+	    (BB_END(p[prev - 1]) == BB_OFFSET(p[prev])) &&
+	    (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <= BB_MAX_LEN) &&
+	    (BB_ACK(p[prev - 1]) == BB_ACK(p[prev])))
+		return true;
+	return false;
+}
+
+/*
+ * Combine the bad ranges indexed by 'prev' and 'prev - 1' (from bad
+ * table) into one larger bad range, and the new range is indexed by
+ * 'prev - 1'.
+ */
+static void front_combine(struct badblocks *bb, int prev)
+{
+	u64 *p = bb->page;
+
+	p[prev - 1] = BB_MAKE(BB_OFFSET(p[prev - 1]),
+			      BB_LEN(p[prev - 1]) + BB_LEN(p[prev]),
+			      BB_ACK(p[prev]));
+	if ((prev + 1) < bb->count)
+		memmove(p + prev, p + prev + 1, (bb->count - prev - 1) * 8);
+}
+
+/*
+ * Return 'true' if the range indicated by 'bad' is exactly forward
+ * overlapped with the bad range (from bad table) indexed by 'front'.
+ * Exactly forward overlap means the bad range (from bad table) indexed
+ * by 'prev' does not cover the whole range indicated by 'bad'.
+ */
+static bool overlap_front(struct badblocks *bb, int front,
+			  struct badblocks_context *bad)
+{
+	u64 *p = bb->page;
+
+	if (bad->start >= BB_OFFSET(p[front]) &&
+	    bad->start < BB_END(p[front]))
+		return true;
+	return false;
+}
+
+/*
+ * Return 'true' if the range indicated by 'bad' is exactly backward
+ * overlapped with the bad range (from bad table) indexed by 'behind'.
+ */
+static bool overlap_behind(struct badblocks *bb, struct badblocks_context *bad,
+			   int behind)
+{
+	u64 *p = bb->page;
+
+	if (bad->start < BB_OFFSET(p[behind]) &&
+	    (bad->start + bad->len) > BB_OFFSET(p[behind]))
+		return true;
+	return false;
+}
+
+/*
+ * Return 'true' if the range indicated by 'bad' can overwrite the bad
+ * range (from bad table) indexed by 'prev'.
+ *
+ * The range indicated by 'bad' can overwrite the bad range indexed by
+ * 'prev' when,
+ * 1) The whole range indicated by 'bad' can cover partial or whole bad
+ *    range (from bad table) indexed by 'prev'.
+ * 2) The ack value of 'bad' is larger or equal to the ack value of bad
+ *    range 'prev'.
+ *
+ * If the overwriting doesn't cover the whole bad range (from bad table)
+ * indexed by 'prev', new range might be split from existing bad range,
+ * 1) The overwrite covers head or tail part of existing bad range, 1
+ *    extra bad range will be split and added into the bad table.
+ * 2) The overwrite covers middle of existing bad range, 2 extra bad
+ *    ranges will be split (ahead and after the overwritten range) and
+ *    added into the bad table.
+ * The number of extra split ranges of the overwriting is stored in
+ * 'extra' and returned for the caller.
+ */
+static bool can_front_overwrite(struct badblocks *bb, int prev,
+				struct badblocks_context *bad, int *extra)
+{
+	u64 *p = bb->page;
+	int len;
+
+	WARN_ON(!overlap_front(bb, prev, bad));
+
+	if (BB_ACK(p[prev]) >= bad->ack)
+		return false;
+
+	if (BB_END(p[prev]) <= (bad->start + bad->len)) {
+		len = BB_END(p[prev]) - bad->start;
+		if (BB_OFFSET(p[prev]) == bad->start)
+			*extra = 0;
+		else
+			*extra = 1;
+
+		bad->len = len;
+	} else {
+		if (BB_OFFSET(p[prev]) == bad->start)
+			*extra = 1;
+		else
+		/*
+		 * prev range will be split into two, beside the overwritten
+		 * one, an extra slot needed from bad table.
+		 */
+			*extra = 2;
+	}
+
+	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
+		return false;
+
+	return true;
+}
+
+/*
+ * Do the overwrite from the range indicated by 'bad' to the bad range
+ * (from bad table) indexed by 'prev'.
+ * The previously called can_front_overwrite() will provide how many
+ * extra bad range(s) might be split and added into the bad table. All
+ * the splitting cases in the bad table will be handled here.
+ */
+static int front_overwrite(struct badblocks *bb, int prev,
+			   struct badblocks_context *bad, int extra)
+{
+	u64 *p = bb->page;
+	sector_t orig_end = BB_END(p[prev]);
+	int orig_ack = BB_ACK(p[prev]);
+
+	switch (extra) {
+	case 0:
+		p[prev] = BB_MAKE(BB_OFFSET(p[prev]), BB_LEN(p[prev]),
+				  bad->ack);
+		break;
+	case 1:
+		if (BB_OFFSET(p[prev]) == bad->start) {
+			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+					  bad->len, bad->ack);
+			memmove(p + prev + 2, p + prev + 1,
+				(bb->count - prev - 1) * 8);
+			p[prev + 1] = BB_MAKE(bad->start + bad->len,
+					      orig_end - BB_END(p[prev]),
+					      orig_ack);
+		} else {
+			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+					  bad->start - BB_OFFSET(p[prev]),
+					  BB_ACK(p[prev]));
+			/*
+			 * prev +2 -> prev + 1 + 1, which is for,
+			 * 1) prev + 1: the slot index of the previous one
+			 * 2) + 1: one more slot for extra being 1.
+			 */
+			memmove(p + prev + 2, p + prev + 1,
+				(bb->count - prev - 1) * 8);
+			p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
+		}
+		break;
+	case 2:
+		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+				  bad->start - BB_OFFSET(p[prev]),
+				  BB_ACK(p[prev]));
+		/*
+		 * prev + 3 -> prev + 1 + 2, which is for,
+		 * 1) prev + 1: the slot index of the previous one
+		 * 2) + 2: two more slots for extra being 2.
+		 */
+		memmove(p + prev + 3, p + prev + 1,
+			(bb->count - prev - 1) * 8);
+		p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
+		p[prev + 2] = BB_MAKE(BB_END(p[prev + 1]),
+				      orig_end - BB_END(p[prev + 1]),
+				      BB_ACK(p[prev]));
+		break;
+	default:
+		break;
+	}
+
+	return bad->len;
+}
+
+/*
+ * Explicitly insert a range indicated by 'bad' to the bad table, where
+ * the location is indexed by 'at'.
+ */
+static int insert_at(struct badblocks *bb, int at, struct badblocks_context *bad)
+{
+	u64 *p = bb->page;
+	int len;
+
+	WARN_ON(badblocks_full(bb));
+
+	len = min_t(sector_t, bad->len, BB_MAX_LEN);
+	if (at < bb->count)
+		memmove(p + at + 1, p + at, (bb->count - at) * 8);
+	p[at] = BB_MAKE(bad->start, len, bad->ack);
+
+	return len;
+}
+
 /**
  * badblocks_check() - check a given range for bad sectors
  * @bb:		the badblocks structure that holds all badblock information
-- 
2.31.1


