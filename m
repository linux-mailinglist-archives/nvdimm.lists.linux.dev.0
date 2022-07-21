Return-Path: <nvdimm+bounces-4404-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0E857CA76
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Jul 2022 14:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1B60280D3D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Jul 2022 12:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F45D3C20;
	Thu, 21 Jul 2022 12:13:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116E23C1D
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 12:12:57 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7DFBC1F7AB;
	Thu, 21 Jul 2022 12:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1658405575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPcy6Gp1GOyN4ObveEW3sVEEkPtC27DjwM9E97PCoRg=;
	b=2Q7OlpyrShH600l/Hm5Jg+Nxk0X0DVwZLssWTyujQGVVTQYZWcR3k3yzXCW7JFqIDNxtoG
	nR+2w6skKG1ptTg9Z9rzddhL16smVMFz/xOnguBCuKBmAkDclSxbEd7r98qYXOeabxD+FR
	/zKnlvdLit+SxLxhFZBrJI5ajQKHXoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1658405575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPcy6Gp1GOyN4ObveEW3sVEEkPtC27DjwM9E97PCoRg=;
	b=7QdM/thnfvOzjZPXSpWsmOTxNKc3Dz62BSvck+ei69GlEb5h3v5BGHJeU8tcK7hJre5B/B
	DXrGYEIV2apnoJDg==
Received: from localhost.localdomain (unknown [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 2D0FF2C14B;
	Thu, 21 Jul 2022 12:12:46 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: linux-block@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH v6 7/7] test: user space code to test badblocks APIs
Date: Thu, 21 Jul 2022 20:11:52 +0800
Message-Id: <20220721121152.4180-8-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220721121152.4180-1-colyli@suse.de>
References: <20220721121152.4180-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the user space test code to verifiy badblocks API, not part of
kernel patch, don't review this patch.

Except for badblocks_show(), the rested code logic for badblocks_set(),
badblocks_clear(), badblocks_check() are identical to the kernel code.

The basic idea of the testing code follows the following steps,
1) Generate a random bad blocks range (start offset and length), for
   random set or clear operation. See write_badblocks_file() for this.
2) Call badblocks_set() or badblocks_clear() APIs, and record the state
   in a log file named with seq- prefix. See write_badblocks_log() for
   this.
3) Write sectors into dummy disk file for the corresponding bad blocks
   range. E.g. the unacknowledged bad blocks setting writes value 1,
   the acknowledged bad blocks setting writes value 2, and the clear
   setting writes value 0. See _write_diskfile() for this.
4) Compare all bad blocks ranges with the dummy disk file, if the sector
   from the dummy disk file has unexpected value against the correspond-
   ing bad block range, stop the loop of testing and ask people to do
   manual verification from the seq-* log files. verify_badblocks_file()
   does the verification.

With this testing code, most of simple conditions are verified, only the
complicated situations require manual check.

There are 3 parameters can be modified in this test code,
- MAX_BB_TEST_TRIES
  How many times of the bad blocks set/clear and verification loop, the
loop may exit earlier if verify_badblocks_file() encounters unexpected
sector value and requires manual check.
- MAX_SET_SIZE
  The max size of random badblocks set range. A larger range may fill
up all 512 badblock slots earlier.
- MAX_CLN_SIZE
  The max size of random badblocks clear range. A larger range may
prevent all 512 badblock slots from being full filled.

Of course the testing code is not perfect, this is the try-best effort
to verify simple conditions of bad blocks setting/clearing with random
generated ranges. For complicated situations, manual check by people are
still necessary.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Geliang Tang <geliang.tang@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Richard Fan <richard.fan@suse.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Cc: Xiao Ni <xni@redhat.com>
---
 badblocks.c | 2256 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 2256 insertions(+)
 create mode 100644 badblocks.c

diff --git a/badblocks.c b/badblocks.c
new file mode 100644
index 0000000..e2a2f94
--- /dev/null
+++ b/badblocks.c
@@ -0,0 +1,2256 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Bad block management
+ *
+ * - Heavily based on MD badblocks code from Neil Brown
+ *
+ * Copyright (c) 2015, Intel Corporation.
+ *
+ * Improvement for handling multiple ranges by Coly Li <colyli@suse.de>
+ */
+
+#define _GNU_SOURCE             /* See feature_test_macros(7) */
+#include <stdlib.h>
+#include <linux/types.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <limits.h>
+#include <assert.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+extern int errno;
+
+#define PAGE_SIZE       4096
+typedef unsigned long long sector_t;
+typedef unsigned long long u64;
+typedef _Bool bool;
+
+#define BB_LEN_MASK     (0x00000000000001FFULL)
+#define BB_OFFSET_MASK  (0x7FFFFFFFFFFFFE00ULL)
+#define BB_ACK_MASK     (0x8000000000000000ULL)
+#define BB_MAX_LEN      512
+#define BB_OFFSET(x)    (((x) & BB_OFFSET_MASK) >> 9)
+#define BB_LEN(x)       (((x) & BB_LEN_MASK) + 1)
+#define BB_END(x)       (BB_OFFSET(x) + BB_LEN(x))
+#define BB_ACK(x)       (!!((x) & BB_ACK_MASK))
+#define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
+
+/* Bad block numbers are stored in a single page.
+ * 64bits is used for each block or extent.
+ * 54 bits are sector number, 9 bits are extent size,
+ * 1 bit is an 'acknowledged' flag.
+ */
+#define MAX_BADBLOCKS   (PAGE_SIZE/8)
+#define GFP_KERNEL      0
+#define true    1
+#define false   0
+
+#define WARN_ON(condition) ({ \
+		if (!!(condition)) \
+			printf("warning on %s:%d\n", __func__, __LINE__); \
+})
+
+#define BUG() ({printf("BUG on %s:%d\n", __func__, __LINE__); exit(1); })
+
+struct device {
+	int val;
+};
+
+struct badblocks {
+	struct device *dev;
+	int count;              /* count of bad blocks */
+	int unacked_exist;      /* there probably are unacknowledged
+				 * bad blocks.  This is only cleared
+				 * when a read discovers none
+				 */
+	int shift;              /* shift from sectors to block size
+				 * a -ve shift means badblocks are
+				 * disabled.
+				 */
+	u64 *page;              /* badblock list */
+	int changed;
+	unsigned long lock;
+	sector_t sector;
+	sector_t size;          /* in sectors */
+};
+
+struct badblocks_context {
+	sector_t start;
+	sector_t len;
+	sector_t orig_start;
+	sector_t orig_len;
+	int ack;
+	int first_prev;
+};
+
+int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
+		    sector_t *first_bad, int *bad_sectors);
+int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+		  int acknowledged);
+int badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
+void ack_all_badblocks(struct badblocks *bb);
+ssize_t badblocks_show(struct badblocks *bb, int unack);
+ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
+			int unack);
+int badblocks_init(struct badblocks *bb, int enable);
+void badblocks_exit(struct badblocks *bb);
+
+static inline void *kzalloc(int size, int flag)
+{
+	void *p = malloc(size);
+
+	memset(p, 0, size);
+	return p;
+}
+
+static inline void kfree(void *page)
+{
+	free(page);
+}
+
+#define roundup(x, y) (                                 \
+{                                                       \
+	typeof(y) __y = y;                              \
+	(((x) + (__y - 1)) / __y) * __y;                \
+}                                                       \
+)
+
+#define rounddown(x, y) (                               \
+{                                                       \
+	typeof(x) __x = (x);                            \
+	__x - (__x % (y));                              \
+}                                                       \
+)
+
+#define fallthrough     do{}while(0)
+
+/**
+ * min - return minimum of two values of the same or compatible types
+ * @x: first value
+ * @y: second value
+ */
+#define min(x, y)        ((x) < (y) ? (x) : (y))
+#define min_t(t, x, y) ((x) < (y) ? (x) : (y))
+
+#define write_seqlock_irqsave(_lock, _flags)	((_flags) = *(_lock))
+#define write_sequnlock_irqrestore(_lock, _flags) ((*(_lock)) = (_flags))
+#define write_seqlock_irq(lock) do{}while(0)
+#define write_sequnlock_irq(lock) do{}while(0)
+#define read_seqbegin(lock) 1
+#define read_seqretry(lock, seq)  (!!((seq) && 0))
+#define seqlock_init(lock) do{}while(0)
+#define EXPORT_SYMBOL_GPL(sym)
+
+static void *devm_kzalloc(struct device *dev, int size, int flags)
+{
+	void *buf = malloc(size);
+
+	if (buf)
+		memset(buf, 0, size);
+	return buf;
+}
+
+static void devm_kfree(struct device *dev, void *mem)
+{
+	free(mem);
+}
+
+static inline int badblocks_full(struct badblocks *bb)
+{
+	return (bb->count >= MAX_BADBLOCKS);
+}
+
+static inline int badblocks_empty(struct badblocks *bb)
+{
+	return (bb->count == 0);
+}
+
+static inline void set_changed(struct badblocks *bb)
+{
+	if (bb->changed != 1)
+		bb->changed = 1;
+}
+
+/*
+ * The purpose of badblocks set/clear is to manage bad blocks ranges which are
+ * identified by LBA addresses.
+ *
+ * When the caller of badblocks_set() wants to set a range of bad blocks, the
+ * setting range can be acked or unacked. And the setting range may merge,
+ * overwrite, skip the overlapped already set range, depends on who they are
+ * overlapped or adjacent, and the acknowledgment type of the ranges. It can be
+ * more complicated when the setting range covers multiple already set bad block
+ * ranges, with restrictions of maximum length of each bad range and the bad
+ * table space limitation.
+ *
+ * It is difficult and unnecessary to take care of all the possible situations,
+ * for setting a large range of bad blocks, we can handle it by dividing the
+ * large range into smaller ones when encounter overlap, max range length or
+ * bad table full conditions. Every time only a smaller piece of the bad range
+ * is handled with a limited number of conditions how it is interacted with
+ * possible overlapped or adjacent already set bad block ranges. Then the hard
+ * complicated problem can be much simpler to handle in proper way.
+ *
+ * When setting a range of bad blocks to the bad table, the simplified situations
+ * to be considered are, (The already set bad blocks ranges are naming with
+ *  prefix E, and the setting bad blocks range is naming with prefix S)
+ *
+ * 1) A setting range is not overlapped or adjacent to any other already set bad
+ *    block range.
+ *                         +--------+
+ *                         |    S   |
+ *                         +--------+
+ *        +-------------+               +-------------+
+ *        |      E1     |               |      E2     |
+ *        +-------------+               +-------------+
+ *    For this situation if the bad blocks table is not full, just allocate a
+ *    free slot from the bad blocks table to mark the setting range S. The
+ *    result is,
+ *        +-------------+  +--------+   +-------------+
+ *        |      E1     |  |    S   |   |      E2     |
+ *        +-------------+  +--------+   +-------------+
+ * 2) A setting range starts exactly at a start LBA of an already set bad blocks
+ *    range.
+ * 2.1) The setting range size < already set range size
+ *        +--------+
+ *        |    S   |
+ *        +--------+
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ * 2.1.1) If S and E are both acked or unacked range, the setting range S can
+ *    be merged into existing bad range E. The result is,
+ *        +-------------+
+ *        |      S      |
+ *        +-------------+
+ * 2.1.2) If S is unacked setting and E is acked, the setting will be denied, and
+ *    the result is,
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ * 2.1.3) If S is acked setting and E is unacked, range S can overwrite on E.
+ *    An extra slot from the bad blocks table will be allocated for S, and head
+ *    of E will move to end of the inserted range S. The result is,
+ *        +--------+----+
+ *        |    S   | E  |
+ *        +--------+----+
+ * 2.2) The setting range size == already set range size
+ * 2.2.1) If S and E are both acked or unacked range, the setting range S can
+ *    be merged into existing bad range E. The result is,
+ *        +-------------+
+ *        |      S      |
+ *        +-------------+
+ * 2.2.2) If S is unacked setting and E is acked, the setting will be denied, and
+ *    the result is,
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ * 2.2.3) If S is acked setting and E is unacked, range S can overwrite all of
+      bad blocks range E. The result is,
+ *        +-------------+
+ *        |      S      |
+ *        +-------------+
+ * 2.3) The setting range size > already set range size
+ *        +-------------------+
+ *        |          S        |
+ *        +-------------------+
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ *    For such situation, the setting range S can be treated as two parts, the
+ *    first part (S1) is as same size as the already set range E, the second
+ *    part (S2) is the rest of setting range.
+ *        +-------------+-----+        +-------------+       +-----+
+ *        |    S1       | S2  |        |     S1      |       | S2  |
+ *        +-------------+-----+  ===>  +-------------+       +-----+
+ *        +-------------+              +-------------+
+ *        |      E      |              |      E      |
+ *        +-------------+              +-------------+
+ *    Now we only focus on how to handle the setting range S1 and already set
+ *    range E, which are already explained in 2.2), for the rest S2 it will be
+ *    handled later in next loop.
+ * 3) A setting range starts before the start LBA of an already set bad blocks
+ *    range.
+ *        +-------------+
+ *        |      S      |
+ *        +-------------+
+ *             +-------------+
+ *             |      E      |
+ *             +-------------+
+ *    For this situation, the setting range S can be divided into two parts, the
+ *    first (S1) ends at the start LBA of already set range E, the second part
+ *    (S2) starts exactly at a start LBA of the already set range E.
+ *        +----+---------+             +----+      +---------+
+ *        | S1 |    S2   |             | S1 |      |    S2   |
+ *        +----+---------+      ===>   +----+      +---------+
+ *             +-------------+                     +-------------+
+ *             |      E      |                     |      E      |
+ *             +-------------+                     +-------------+
+ *    Now only the first part S1 should be handled in this loop, which is in
+ *    similar condition as 1). The rest part S2 has exact same start LBA address
+ *    of the already set range E, they will be handled in next loop in one of
+ *    situations in 2).
+ * 4) A setting range starts after the start LBA of an already set bad blocks
+ *    range.
+ * 4.1) If the setting range S exactly matches the tail part of already set bad
+ *    blocks range E, like the following chart shows,
+ *            +---------+
+ *            |   S     |
+ *            +---------+
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ * 4.1.1) If range S and E have same acknowledge value (both acked or unacked),
+ *    they will be merged into one, the result is,
+ *        +-------------+
+ *        |      S      |
+ *        +-------------+
+ * 4.1.2) If range E is acked and the setting range S is unacked, the setting
+ *    request of S will be rejected, the result is,
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ * 4.1.3) If range E is unacked, and the setting range S is acked, then S may
+ *    overwrite the overlapped range of E, the result is,
+ *        +---+---------+
+ *        | E |    S    |
+ *        +---+---------+
+ * 4.2) If the setting range S stays in middle of an already set range E, like
+ *    the following chart shows,
+ *             +----+
+ *             | S  |
+ *             +----+
+ *        +--------------+
+ *        |       E      |
+ *        +--------------+
+ * 4.2.1) If range S and E have same acknowledge value (both acked or unacked),
+ *    they will be merged into one, the result is,
+ *        +--------------+
+ *        |       S      |
+ *        +--------------+
+ * 4.2.2) If range E is acked and the setting range S is unacked, the setting
+ *    request of S will be rejected, the result is also,
+ *        +--------------+
+ *        |       E      |
+ *        +--------------+
+ * 4.2.3) If range E is unacked, and the setting range S is acked, then S will
+ *    inserted into middle of E and split previous range E into twp parts (E1
+ *    and E2), the result is,
+ *        +----+----+----+
+ *        | E1 |  S | E2 |
+ *        +----+----+----+
+ * 4.3) If the setting bad blocks range S is overlapped with an already set bad
+ *    blocks range E. The range S starts after the start LBA of range E, and
+ *    ends after the end LBA of range E, as the following chart shows,
+ *            +-------------------+
+ *            |          S        |
+ *            +-------------------+
+ *        +-------------+
+ *        |      E      |
+ *        +-------------+
+ *    For this situation the range S can be divided into two parts, the first
+ *    part (S1) ends at end range E, and the second part (S2) has rest range of
+ *    origin S.
+ *            +---------+---------+            +---------+      +---------+
+ *            |    S1   |    S2   |            |    S1   |      |    S2   |
+ *            +---------+---------+  ===>      +---------+      +---------+
+ *        +-------------+                  +-------------+
+ *        |      E      |                  |      E      |
+ *        +-------------+                  +-------------+
+ *     Now in this loop the setting range S1 and already set range E can be
+ *     handled as the situations 4), the rest range S2 will be handled in next
+ *     loop and ignored in this loop.
+ * 5) A setting bad blocks range S is adjacent to one or more already set bad
+ *    blocks range(s), and they are all acked or unacked range.
+ * 5.1) Front merge: If the already set bad blocks range E is before setting
+ *    range S and they are adjacent,
+ *                +------+
+ *                |  S   |
+ *                +------+
+ *        +-------+
+ *        |   E   |
+ *        +-------+
+ * 5.1.1) When total size of range S and E <= BB_MAX_LEN, and their acknowledge
+ *    values are same, the setting range S can front merges into range E. The
+ *    result is,
+ *        +--------------+
+ *        |       S      |
+ *        +--------------+
+ * 5.1.2) Otherwise these two ranges cannot merge, just insert the setting
+ *    range S right after already set range E into the bad blocks table. The
+ *    result is,
+ *        +--------+------+
+ *        |   E    |   S  |
+ *        +--------+------+
+ * 6) Special cases which above conditions cannot handle
+ * 6.1) Multiple already set ranges may merge into less ones in a full bad table
+ *        +-------------------------------------------------------+
+ *        |                           S                           |
+ *        +-------------------------------------------------------+
+ *        |<----- BB_MAX_LEN ----->|
+ *                                 +-----+     +-----+   +-----+
+ *                                 | E1  |     | E2  |   | E3  |
+ *                                 +-----+     +-----+   +-----+
+ *     In the above example, when the bad blocks table is full, inserting the
+ *     first part of setting range S will fail because no more available slot
+ *     can be allocated from bad blocks table. In this situation a proper
+ *     setting method should be go though all the setting bad blocks range and
+ *     look for chance to merge already set ranges into less ones. When there
+ *     is available slot from bad blocks table, re-try again to handle more
+ *     setting bad blocks ranges as many as possible.
+ *        +------------------------+
+ *        |          S3            |
+ *        +------------------------+
+ *        |<----- BB_MAX_LEN ----->|
+ *                                 +-----+-----+-----+---+-----+--+
+ *                                 |       S1        |     S2     |
+ *                                 +-----+-----+-----+---+-----+--+
+ *     The above chart shows although the first part (S3) cannot be inserted due
+ *     to no-space in bad blocks table, but the following E1, E2 and E3 ranges
+ *     can be merged with rest part of S into less range S1 and S2. Now there is
+ *     1 free slot in bad blocks table.
+ *        +------------------------+-----+-----+-----+---+-----+--+
+ *        |           S3           |       S1        |     S2     |
+ *        +------------------------+-----+-----+-----+---+-----+--+
+ *     Since the bad blocks table is not full anymore, re-try again for the
+ *     origin setting range S. Now the setting range S3 can be inserted into the
+ *     bad blocks table with previous freed slot from multiple ranges merge.
+ * 6.2) Front merge after overwrite
+ *    In the following example, in bad blocks table, E1 is an acked bad blocks
+ *    range and E2 is an unacked bad blocks range, therefore they are not able
+ *    to merge into a larger range. The setting bad blocks range S is acked,
+ *    therefore part of E2 can be overwritten by S.
+ *                      +--------+
+ *                      |    S   |                             acknowledged
+ *                      +--------+                         S:       1
+ *              +-------+-------------+                   E1:       1
+ *              |   E1  |    E2       |                   E2:       0
+ *              +-------+-------------+
+ *     With previous simplified routines, after overwriting part of E2 with S,
+ *     the bad blocks table should be (E3 is remaining part of E2 which is not
+ *     overwritten by S),
+ *                                                             acknowledged
+ *              +-------+--------+----+                    S:       1
+ *              |   E1  |    S   | E3 |                   E1:       1
+ *              +-------+--------+----+                   E3:       0
+ *     The above result is correct but not perfect. Range E1 and S in the bad
+ *     blocks table are all acked, merging them into a larger one range may
+ *     occupy less bad blocks table space and make badblocks_check() faster.
+ *     Therefore in such situation, after overwriting range S, the previous range
+ *     E1 should be checked for possible front combination. Then the ideal
+ *     result can be,
+ *              +----------------+----+                        acknowledged
+ *              |       E1       | E3 |                   E1:       1
+ *              +----------------+----+                   E3:       0
+ * 6.3) Behind merge: If the already set bad blocks range E is behind the setting
+ *    range S and they are adjacent. Normally we don't need to care about this
+ *    because front merge handles this while going though range S from head to
+ *    tail, except for the tail part of range S. When the setting range S are
+ *    fully handled, all the above simplified routine doesn't check whether the
+ *    tail LBA of range S is adjacent to the next already set range and not
+ *    merge them even it is possible.
+ *        +------+
+ *        |  S   |
+ *        +------+
+ *               +-------+
+ *               |   E   |
+ *               +-------+
+ *    For the above special situation, when the setting range S are all handled
+ *    and the loop ends, an extra check is necessary for whether next already
+ *    set range E is right after S and mergeable.
+ * 6.3.1) When total size of range E and S <= BB_MAX_LEN, and their acknowledge
+ *    values are same, the setting range S can behind merges into range E. The
+ *    result is,
+ *        +--------------+
+ *        |       S      |
+ *        +--------------+
+ * 6.3.2) Otherwise these two ranges cannot merge, just insert the setting range
+ *     S in front of the already set range E in the bad blocks table. The result
+ *     is,
+ *        +------+-------+
+ *        |  S   |   E   |
+ *        +------+-------+
+ *
+ * All the above 5 simplified situations and 3 special cases may cover 99%+ of
+ * the bad block range setting conditions. Maybe there is some rare corner case
+ * is not considered and optimized, it won't hurt if badblocks_set() fails due
+ * to no space, or some ranges are not merged to save bad blocks table space.
+ *
+ * Inside badblocks_set() each loop starts by jumping to re_insert label, every
+ * time for the new loop prev_badblocks() is called to find an already set range
+ * which starts before or at current setting range. Since the setting bad blocks
+ * range is handled from head to tail, most of the cases it is unnecessary to do
+ * the binary search inside prev_badblocks(), it is possible to provide a hint
+ * to prev_badblocks() for a fast path, then the expensive binary search can be
+ * avoided. In my test with the hint to prev_badblocks(), except for the first
+ * loop, all rested calls to prev_badblocks() can go into the fast path and
+ * return correct bad blocks table index immediately.
+ *
+ *
+ * Clearing a bad blocks range from the bad block table has similar idea as
+ * setting does, but much more simpler. The only thing needs to be noticed is
+ * when the clearing range hits middle of a bad block range, the existing bad
+ * block range will split into two, and one more item should be added into the
+ * bad block table. The simplified situations to be considered are, (The already
+ * set bad blocks ranges in bad block table are naming with prefix E, and the
+ * clearing bad blocks range is naming with prefix C)
+ *
+ * 1) A clearing range is not overlapped to any already set ranges in bad block
+ *    table.
+ *    +-----+         |          +-----+         |          +-----+
+ *    |  C  |         |          |  C  |         |          |  C  |
+ *    +-----+         or         +-----+         or         +-----+
+ *            +---+   |   +----+         +----+  |  +---+
+ *            | E |   |   | E1 |         | E2 |  |  | E |
+ *            +---+   |   +----+         +----+  |  +---+
+ *    For the above situations, no bad block to be cleared and no failure
+ *    happens, simply returns 0.
+ * 2) The clearing range hits middle of an already setting bad blocks range in
+ *    the bad block table.
+ *            +---+
+ *            | C |
+ *            +---+
+ *     +-----------------+
+ *     |         E       |
+ *     +-----------------+
+ *    In this situation if the bad block table is not full, the range E will be
+ *    split into two ranges E1 and E2. The result is,
+ *     +------+   +------+
+ *     |  E1  |   |  E2  |
+ *     +------+   +------+
+ * 3) The clearing range starts exactly at same LBA as an already set bad block range
+ *    from the bad block table.
+ * 3.1) Partially covered at head part
+ *         +------------+
+ *         |     C      |
+ *         +------------+
+ *         +-----------------+
+ *         |         E       |
+ *         +-----------------+
+ *    For this situation, the overlapped already set range will update the
+ *    start LBA to end of C and shrink the range to BB_LEN(E) - BB_LEN(C). No
+ *    item deleted from bad block table. The result is,
+ *                      +----+
+ *                      | E1 |
+ *                      +----+
+ * 3.2) Exact fully covered
+ *         +-----------------+
+ *         |         C       |
+ *         +-----------------+
+ *         +-----------------+
+ *         |         E       |
+ *         +-----------------+
+ *    For this situation the whole bad blocks range E will be cleared and its
+ *    corresponded item is deleted from the bad block table.
+ * 4) The clearing range exactly ends at same LBA as an already set bad block
+ *    range.
+ *                   +-------+
+ *                   |   C   |
+ *                   +-------+
+ *         +-----------------+
+ *         |         E       |
+ *         +-----------------+
+ *    For the above situation, the already set range E is updated to shrink its
+ *    end to the start of C, and reduce its length to BB_LEN(E) - BB_LEN(C).
+ *    The result is,
+ *         +---------+
+ *         |    E    |
+ *         +---------+
+ * 5) The clearing range is partially overlapped with an already set bad block
+ *    range from the bad block table.
+ * 5.1) The already set bad block range is front overlapped with the clearing
+ *    range.
+ *         +----------+
+ *         |     C    |
+ *         +----------+
+ *              +------------+
+ *              |      E     |
+ *              +------------+
+ *   For such situation, the clearing range C can be treated as two parts. The
+ *   first part ends at the start LBA of range E, and the second part starts at
+ *   same LBA of range E.
+ *         +----+-----+               +----+   +-----+
+ *         | C1 | C2  |               | C1 |   | C2  |
+ *         +----+-----+         ===>  +----+   +-----+
+ *              +------------+                 +------------+
+ *              |      E     |                 |      E     |
+ *              +------------+                 +------------+
+ *   Now the first part C1 can be handled as condition 1), and the second part C2 can be
+ *   handled as condition 3.1) in next loop.
+ * 5.2) The already set bad block range is behind overlaopped with the clearing
+ *   range.
+ *                 +----------+
+ *                 |     C    |
+ *                 +----------+
+ *         +------------+
+ *         |      E     |
+ *         +------------+
+ *   For such situation, the clearing range C can be treated as two parts. The
+ *   first part C1 ends at same end LBA of range E, and the second part starts
+ *   at end LBA of range E.
+ *                 +----+-----+                 +----+    +-----+
+ *                 | C1 | C2  |                 | C1 |    | C2  |
+ *                 +----+-----+  ===>           +----+    +-----+
+ *         +------------+               +------------+
+ *         |      E     |               |      E     |
+ *         +------------+               +------------+
+ *   Now the first part clearing range C1 can be handled as condition 4), and
+ *   the second part clearing range C2 can be handled as condition 1) in next
+ *   loop.
+ *
+ *   All bad blocks range clearing can be simplified into the above 5 situations
+ *   by only handling the head part of the clearing range in each run of the
+ *   while-loop. The idea is similar to bad blocks range setting but much
+ *   simpler.
+ */
+
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
+		if (a == s) {
+			ret = mid;
+			goto out;
+		}
+
+		if (a < s)
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
+	if ((s < BB_OFFSET(p[behind])) &&
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
+	WARN_ON(s >= BB_OFFSET(p[behind]));
+	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
+
+	if (s < BB_OFFSET(p[behind])) {
+		merged = BB_OFFSET(p[behind]) - s;
+		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
+
+		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
+	}
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
+static void badblocks_update_acked(struct badblocks *bb)
+{
+	bool unacked = false;
+	u64 *p = bb->page;
+	int i;
+
+	if (!bb->unacked_exist)
+		return;
+
+	for (i = 0; i < bb->count ; i++) {
+		if (!BB_ACK(p[i])) {
+			unacked = true;
+			break;
+		}
+	}
+
+	if (!unacked)
+		bb->unacked_exist = 0;
+}
+
+/* Do exact work to set bad block range into the bad block table */
+static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+			  int acknowledged)
+{
+	int retried = 0, space_desired = 0;
+	int orig_len, len = 0, added = 0;
+	struct badblocks_context bad;
+	int prev = -1, hint = -1;
+	sector_t orig_start;
+	unsigned long flags;
+	int rv = 0;
+	u64 *p;
+
+	if (bb->shift < 0)
+		/* badblocks are disabled */
+		return 1;
+
+	if (sectors == 0)
+		/* Invalid sectors number */
+		return 1;
+
+	if (bb->shift) {
+		/* round the start down, and the end up */
+		sector_t next = s + sectors;
+
+		rounddown(s, bb->shift);
+		roundup(next, bb->shift);
+		sectors = next - s;
+	}
+
+	write_seqlock_irqsave(&bb->lock, flags);
+
+	orig_start = s;
+	orig_len = sectors;
+	bad.ack = acknowledged;
+	p = bb->page;
+
+re_insert:
+	bad.start = s;
+	bad.len = sectors;
+	len = 0;
+
+	if (badblocks_empty(bb)) {
+		len = insert_at(bb, 0, &bad);
+		bb->count++;
+		added++;
+		goto update_sectors;
+	}
+
+	prev = prev_badblocks(bb, &bad, hint);
+
+	/* start before all badblocks */
+	if (prev < 0) {
+		if (!badblocks_full(bb)) {
+			/* insert on the first */
+			if (bad.len > (BB_OFFSET(p[0]) - bad.start))
+				bad.len = BB_OFFSET(p[0]) - bad.start;
+			len = insert_at(bb, 0, &bad);
+			bb->count++;
+			added++;
+			hint = 0;
+			goto update_sectors;
+		}
+
+		/* No sapce, try to merge */
+		if (overlap_behind(bb, &bad, 0)) {
+			if (can_merge_behind(bb, &bad, 0)) {
+				len = behind_merge(bb, &bad, 0);
+				added++;
+			} else {
+				len = BB_OFFSET(p[0]) - s;
+				space_desired = 1;
+			}
+			hint = 0;
+			goto update_sectors;
+		}
+
+		/* no table space and give up */
+		goto out;
+	}
+
+	/* in case p[prev-1] can be merged with p[prev] */
+	if (can_combine_front(bb, prev, &bad)) {
+		front_combine(bb, prev);
+		bb->count--;
+		added++;
+		hint = prev;
+		goto update_sectors;
+	}
+
+	if (overlap_front(bb, prev, &bad)) {
+		if (can_merge_front(bb, prev, &bad)) {
+			len = front_merge(bb, prev, &bad);
+			added++;
+		} else {
+			int extra = 0;
+
+			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
+				len = min_t(sector_t,
+					    BB_END(p[prev]) - s, sectors);
+				hint = prev;
+				goto update_sectors;
+			}
+
+			len = front_overwrite(bb, prev, &bad, extra);
+			added++;
+			bb->count += extra;
+
+			if (can_combine_front(bb, prev, &bad)) {
+				front_combine(bb, prev);
+				bb->count--;
+			}
+		}
+		hint = prev;
+		goto update_sectors;
+	}
+
+	if (can_merge_front(bb, prev, &bad)) {
+		len = front_merge(bb, prev, &bad);
+		added++;
+		hint = prev;
+		goto update_sectors;
+	}
+
+	/* if no space in table, still try to merge in the covered range */
+	if (badblocks_full(bb)) {
+		/* skip the cannot-merge range */
+		if (((prev + 1) < bb->count) &&
+		    overlap_behind(bb, &bad, prev + 1) &&
+		    ((s + sectors) >= BB_END(p[prev + 1]))) {
+			len = BB_END(p[prev + 1]) - s;
+			hint = prev + 1;
+			goto update_sectors;
+		}
+
+		/* no retry any more */
+		len = sectors;
+		space_desired = 1;
+		hint = -1;
+		goto update_sectors;
+	}
+
+	/* cannot merge and there is space in bad table */
+	if ((prev + 1) < bb->count &&
+	    overlap_behind(bb, &bad, prev + 1))
+		bad.len = min_t(sector_t,
+				bad.len, BB_OFFSET(p[prev + 1]) - bad.start);
+
+	len = insert_at(bb, prev + 1, &bad);
+	bb->count++;
+	added++;
+	hint = prev + 1;
+
+update_sectors:
+	s += len;
+	sectors -= len;
+
+	if (sectors > 0)
+		goto re_insert;
+
+	WARN_ON(sectors < 0);
+
+	/*
+	 * Check whether the following already set range can be
+	 * merged. (prev < 0) condition is not handled here,
+	 * because it's already complicatd enough.
+	 */
+	if (prev >= 0 &&
+	    (prev + 1) < bb->count &&
+	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
+	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
+	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
+		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
+				  BB_ACK(p[prev]));
+
+		if ((prev + 2) < bb->count)
+			memmove(p + prev + 1, p + prev + 2,
+				(bb->count -  (prev + 2)) * 8);
+		bb->count--;
+	}
+
+	if (space_desired && !badblocks_full(bb)) {
+		s = orig_start;
+		sectors = orig_len;
+		space_desired = 0;
+		if (retried++ < 3)
+			goto re_insert;
+	}
+
+out:
+	if (added) {
+		set_changed(bb);
+
+		if (!acknowledged)
+			bb->unacked_exist = 1;
+		else
+			badblocks_update_acked(bb);
+	}
+
+	write_sequnlock_irqrestore(&bb->lock, flags);
+
+	if (!added)
+		rv = 1;
+
+	return rv;
+}
+
+/*
+ * Clear the bad block range from bad block table which is front overlapped
+ * with the clearing range. The return value is how many sectors from an
+ * already set bad block range are cleared. If the whole bad block range is
+ * covered by the clearing range and fully cleared, 'delete' is set as 1 for
+ * the caller to reduce bb->count.
+ */
+static int front_clear(struct badblocks *bb, int prev,
+		       struct badblocks_context *bad, int *deleted)
+{
+	sector_t sectors = bad->len;
+	sector_t s = bad->start;
+	u64 *p = bb->page;
+	int cleared = 0;
+
+	*deleted = 0;
+	if (s == BB_OFFSET(p[prev])) {
+		if (BB_LEN(p[prev]) > sectors) {
+			p[prev] = BB_MAKE(BB_OFFSET(p[prev]) + sectors,
+					  BB_LEN(p[prev]) - sectors,
+					  BB_ACK(p[prev]));
+			cleared = sectors;
+		} else {
+			/* BB_LEN(p[prev]) <= sectors */
+			cleared = BB_LEN(p[prev]);
+			if ((prev + 1) < bb->count)
+				memmove(p + prev, p + prev + 1,
+				       (bb->count - prev - 1) * 8);
+			*deleted = 1;
+		}
+	} else if (s > BB_OFFSET(p[prev])) {
+		if (BB_END(p[prev]) <= (s + sectors)) {
+			cleared = BB_END(p[prev]) - s;
+			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+					  s - BB_OFFSET(p[prev]),
+					  BB_ACK(p[prev]));
+		} else {
+			/* Splitting is handled in front_splitting_clear() */
+			BUG();
+		}
+	}
+
+	return cleared;
+}
+
+/*
+ * Handle the condition that the clearing range hits middle of an already set
+ * bad block range from bad block table. In this condition the existing bad
+ * block range is split into two after the middle part is cleared.
+ */
+static int front_splitting_clear(struct badblocks *bb, int prev,
+				  struct badblocks_context *bad)
+{
+	u64 *p = bb->page;
+	u64 end = BB_END(p[prev]);
+	int ack = BB_ACK(p[prev]);
+	sector_t sectors = bad->len;
+	sector_t s = bad->start;
+
+	p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+			  s - BB_OFFSET(p[prev]),
+			  ack);
+	memmove(p + prev + 2, p + prev + 1, (bb->count - prev - 1) * 8);
+	p[prev + 1] = BB_MAKE(s + sectors, end - s - sectors, ack);
+	return sectors;
+}
+
+/* Do the exact work to clear bad block range from the bad block table */
+static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+{
+	struct badblocks_context bad;
+	int prev = -1, hint = -1;
+	int len = 0, cleared = 0;
+	int rv = 0;
+	u64 *p;
+
+	if (bb->shift < 0)
+		/* badblocks are disabled */
+		return 1;
+
+	if (sectors == 0)
+		/* Invalid sectors number */
+		return 1;
+
+	if (bb->shift) {
+		sector_t target;
+
+		/* When clearing we round the start up and the end down.
+		 * This should not matter as the shift should align with
+		 * the block size and no rounding should ever be needed.
+		 * However it is better the think a block is bad when it
+		 * isn't than to think a block is not bad when it is.
+		 */
+		target = s + sectors;
+		roundup(s, bb->shift);
+		rounddown(target, bb->shift);
+		sectors = target - s;
+	}
+
+	write_seqlock_irq(&bb->lock);
+
+	bad.ack = true;
+	p = bb->page;
+
+re_clear:
+	bad.start = s;
+	bad.len = sectors;
+
+	if (badblocks_empty(bb)) {
+		len = sectors;
+		cleared++;
+		goto update_sectors;
+	}
+
+
+	prev = prev_badblocks(bb, &bad, hint);
+
+	/* Start before all badblocks */
+	if (prev < 0) {
+		if (overlap_behind(bb, &bad, 0)) {
+			len = BB_OFFSET(p[0]) - s;
+			hint = prev;
+		} else {
+			len = sectors;
+		}
+		/*
+		 * Both situations are to clear non-bad range,
+		 * should be treated as successful
+		 */
+		cleared++;
+		goto update_sectors;
+	}
+
+	/* Start after all badblocks */
+	if ((prev + 1) >= bb->count && !overlap_front(bb, prev, &bad)) {
+		len = sectors;
+		cleared++;
+		goto update_sectors;
+	}
+
+	/* Clear will split a bad record but the table is full */
+	if (badblocks_full(bb) && (BB_OFFSET(p[prev]) < bad.start) &&
+	    (BB_END(p[prev]) > (bad.start + sectors))) {
+		len = sectors;
+		printf("Warn: no space to split for clear\n");
+		goto update_sectors;
+	}
+
+	if (overlap_front(bb, prev, &bad)) {
+		if ((BB_OFFSET(p[prev]) < bad.start) &&
+		    (BB_END(p[prev]) > (bad.start + bad.len))) {
+			/* Splitting */
+			if ((bb->count + 1) < MAX_BADBLOCKS) {
+				len = front_splitting_clear(bb, prev, &bad);
+				bb->count += 1;
+				cleared++;
+			} else {
+				/* No space to split, give up */
+				printf("Warn: no space to split for clear\n");
+				len = sectors;
+			}
+		} else {
+			int deleted = 0;
+
+			len = front_clear(bb, prev, &bad, &deleted);
+			bb->count -= deleted;
+			cleared++;
+			hint = prev;
+		}
+
+		goto update_sectors;
+	}
+
+	/* Not front overlap, but behind overlap */
+	if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1)) {
+		len = BB_OFFSET(p[prev + 1]) - bad.start;
+		hint = prev + 1;
+		/* Clear non-bad range should be treated as successful */
+		cleared++;
+		goto update_sectors;
+	}
+
+	/* Not cover any badblocks range in the table */
+	len = sectors;
+	/* Clear non-bad range should be treated as successful */
+	cleared++;
+
+update_sectors:
+	s += len;
+	sectors -= len;
+
+	if (sectors > 0)
+		goto re_clear;
+
+	WARN_ON(sectors < 0);
+
+	if (cleared) {
+		badblocks_update_acked(bb);
+		set_changed(bb);
+	}
+
+	write_sequnlock_irq(&bb->lock);
+
+	if (!cleared)
+		rv = 1;
+
+	return rv;
+}
+
+/* Do the exact work to check bad blocks range from the bad block table */
+static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
+			    sector_t *first_bad, int *bad_sectors)
+{
+	int unacked_badblocks, acked_badblocks;
+	int prev = -1, hint = -1, set = 0;
+	struct badblocks_context bad;
+	unsigned int seq;
+	int len, rv;
+	u64 *p;
+
+	WARN_ON(bb->shift < 0 || sectors == 0);
+
+	if (bb->shift > 0) {
+		sector_t target;
+
+		/* round the start down, and the end up */
+		target = s + sectors;
+		rounddown(s, bb->shift);
+		roundup(target, bb->shift);
+		sectors = target - s;
+	}
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+
+	p = bb->page;
+	unacked_badblocks = 0;
+	acked_badblocks = 0;
+
+re_check:
+	bad.start = s;
+	bad.len = sectors;
+
+	if (badblocks_empty(bb)) {
+		len = sectors;
+		goto update_sectors;
+	}
+
+	prev = prev_badblocks(bb, &bad, hint);
+
+	/* start after all badblocks */
+	if ((prev + 1) >= bb->count && !overlap_front(bb, prev, &bad)) {
+		len = sectors;
+		goto update_sectors;
+	}
+
+	if (overlap_front(bb, prev, &bad)) {
+		if (BB_ACK(p[prev]))
+			acked_badblocks++;
+		else
+			unacked_badblocks++;
+
+		if (BB_END(p[prev]) >= (s + sectors))
+			len = sectors;
+		else
+			len = BB_END(p[prev]) - s;
+
+		if (set == 0) {
+			*first_bad = BB_OFFSET(p[prev]);
+			*bad_sectors = BB_LEN(p[prev]);
+			set = 1;
+		}
+		goto update_sectors;
+	}
+
+	/* Not front overlap, but behind overlap */
+	if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1)) {
+		len = BB_OFFSET(p[prev + 1]) - bad.start;
+		hint = prev + 1;
+		goto update_sectors;
+	}
+
+	/* not cover any badblocks range in the table */
+	len = sectors;
+
+update_sectors:
+	s += len;
+	sectors -= len;
+
+	if (sectors > 0)
+		goto re_check;
+
+	WARN_ON(sectors < 0);
+
+	if (unacked_badblocks > 0)
+		rv = -1;
+	else if (acked_badblocks > 0)
+		rv = 1;
+	else
+		rv = 0;
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
+}
+
+/**
+ * badblocks_check() - check a given range for bad sectors
+ * @bb:		the badblocks structure that holds all badblock information
+ * @s:		sector (start) at which to check for badblocks
+ * @sectors:	number of sectors to check for badblocks
+ * @first_bad:	pointer to store location of the first badblock
+ * @bad_sectors: pointer to store number of badblocks after @first_bad
+ *
+ * We can record which blocks on each device are 'bad' and so just
+ * fail those blocks, or that stripe, rather than the whole device.
+ * Entries in the bad-block table are 64bits wide.  This comprises:
+ * Length of bad-range, in sectors: 0-511 for lengths 1-512
+ * Start of bad-range, sector offset, 54 bits (allows 8 exbibytes)
+ *  A 'shift' can be set so that larger blocks are tracked and
+ *  consequently larger devices can be covered.
+ * 'Acknowledged' flag - 1 bit. - the most significant bit.
+ *
+ * Locking of the bad-block table uses a seqlock so badblocks_check
+ * might need to retry if it is very unlucky.
+ * We will sometimes want to check for bad blocks in a bi_end_io function,
+ * so we use the write_seqlock_irq variant.
+ *
+ * When looking for a bad block we specify a range and want to
+ * know if any block in the range is bad.  So we binary-search
+ * to the last range that starts at-or-before the given endpoint,
+ * (or "before the sector after the target range")
+ * then see if it ends after the given start.
+ *
+ * Return:
+ *  0: there are no known bad blocks in the range
+ *  1: there are known bad block which are all acknowledged
+ * -1: there are bad blocks which have not yet been acknowledged in metadata.
+ * plus the start/length of the first bad section we overlap.
+ */
+int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
+			sector_t *first_bad, int *bad_sectors)
+{
+	return _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
+}
+EXPORT_SYMBOL_GPL(badblocks_check);
+
+/**
+ * badblocks_set() - Add a range of bad blocks to the table.
+ * @bb:		the badblocks structure that holds all badblock information
+ * @s:		first sector to mark as bad
+ * @sectors:	number of sectors to mark as bad
+ * @acknowledged: weather to mark the bad sectors as acknowledged
+ *
+ * This might extend the table, or might contract it if two adjacent ranges
+ * can be merged. We binary-search to find the 'insertion' point, then
+ * decide how best to handle it.
+ *
+ * Return:
+ *  0: success
+ *  1: failed to set badblocks (out of space)
+ */
+int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+			int acknowledged)
+{
+	return _badblocks_set(bb, s, sectors, acknowledged);
+}
+EXPORT_SYMBOL_GPL(badblocks_set);
+
+/**
+ * badblocks_clear() - Remove a range of bad blocks to the table.
+ * @bb:		the badblocks structure that holds all badblock information
+ * @s:		first sector to mark as bad
+ * @sectors:	number of sectors to mark as bad
+ *
+ * This may involve extending the table if we spilt a region,
+ * but it must not fail.  So if the table becomes full, we just
+ * drop the remove request.
+ *
+ * Return:
+ *  0: success
+ *  1: failed to clear badblocks
+ */
+int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+{
+	return _badblocks_clear(bb, s, sectors);
+}
+EXPORT_SYMBOL_GPL(badblocks_clear);
+
+/**
+ * ack_all_badblocks() - Acknowledge all bad blocks in a list.
+ * @bb:		the badblocks structure that holds all badblock information
+ *
+ * This only succeeds if ->changed is clear.  It is used by
+ * in-kernel metadata updates
+ */
+void ack_all_badblocks(struct badblocks *bb)
+{
+	if (bb->page == NULL || bb->changed)
+		/* no point even trying */
+		return;
+	write_seqlock_irq(&bb->lock);
+
+	if (bb->changed == 0 && bb->unacked_exist) {
+		u64 *p = bb->page;
+		int i;
+
+		for (i = 0; i < bb->count ; i++) {
+			if (!BB_ACK(p[i])) {
+				sector_t start = BB_OFFSET(p[i]);
+				int len = BB_LEN(p[i]);
+
+				p[i] = BB_MAKE(start, len, 1);
+			}
+		}
+		bb->unacked_exist = 0;
+	}
+	write_sequnlock_irq(&bb->lock);
+}
+EXPORT_SYMBOL_GPL(ack_all_badblocks);
+
+/**
+ * badblocks_show() - sysfs access to bad-blocks list
+ * @bb:		the badblocks structure that holds all badblock information
+ * @page:	buffer received from sysfs
+ * @unack:	weather to show unacknowledged badblocks
+ *
+ * Return:
+ *  Length of returned data
+ */
+ssize_t badblocks_show(struct badblocks *bb, int unack)
+{
+	size_t len;
+	int i;
+	u64 *p = bb->page;
+	char *_page;
+	int size = 64*4096;
+	unsigned int seq;
+
+	if (bb->shift < 0)
+		return 0;
+
+	_page = malloc(size);
+	if (!_page) {
+		printf("alloc _page failed\n");
+		return 0;
+	}
+	memset(_page, 0, size);
+retry:
+	seq = read_seqbegin(&bb->lock);
+
+	len = 0;
+	i = 0;
+
+	while (len < size && i < bb->count) {
+		sector_t s = BB_OFFSET(p[i]);
+		unsigned int length = BB_LEN(p[i]);
+		int ack = BB_ACK(p[i]);
+
+		i++;
+
+		if (unack && ack)
+			continue;
+
+		len += snprintf(_page+len, size - len, "%llu %u\n",
+				(unsigned long long)s << bb->shift,
+				length << bb->shift);
+	}
+	if (unack && len == 0)
+		bb->unacked_exist = 0;
+
+	printf("%s\n", _page);
+	free(_page);
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(badblocks_show);
+
+/**
+ * badblocks_store() - sysfs access to bad-blocks list
+ * @bb:		the badblocks structure that holds all badblock information
+ * @page:	buffer received from sysfs
+ * @len:	length of data received from sysfs
+ * @unack:	weather to show unacknowledged badblocks
+ *
+ * Return:
+ *  Length of the buffer processed or -ve error.
+ */
+ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
+			int unack)
+{
+	unsigned long long sector;
+	int length;
+	char newline;
+
+	switch (sscanf(page, "%llu %d%c", &sector, &length, &newline)) {
+	case 3:
+		if (newline != '\n')
+			return -EINVAL;
+		fallthrough;
+	case 2:
+		if (length <= 0)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (badblocks_set(bb, sector, length, !unack))
+		return -ENOSPC;
+	else
+		return len;
+}
+EXPORT_SYMBOL_GPL(badblocks_store);
+
+static int __badblocks_init(struct device *dev, struct badblocks *bb,
+		int enable)
+{
+	bb->dev = dev;
+	bb->count = 0;
+	if (enable)
+		bb->shift = 0;
+	else
+		bb->shift = -1;
+	if (dev)
+		bb->page = devm_kzalloc(dev, PAGE_SIZE, GFP_KERNEL);
+	else
+		bb->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!bb->page) {
+		bb->shift = -1;
+		return -ENOMEM;
+	}
+	seqlock_init(&bb->lock);
+
+	return 0;
+}
+
+/**
+ * badblocks_init() - initialize the badblocks structure
+ * @bb:		the badblocks structure that holds all badblock information
+ * @enable:	weather to enable badblocks accounting
+ *
+ * Return:
+ *  0: success
+ *  -ve errno: on error
+ */
+int badblocks_init(struct badblocks *bb, int enable)
+{
+	return __badblocks_init(NULL, bb, enable);
+}
+EXPORT_SYMBOL_GPL(badblocks_init);
+
+int devm_init_badblocks(struct device *dev, struct badblocks *bb)
+{
+	if (!bb)
+		return -EINVAL;
+	return __badblocks_init(dev, bb, 1);
+}
+EXPORT_SYMBOL_GPL(devm_init_badblocks);
+
+/**
+ * badblocks_exit() - free the badblocks structure
+ * @bb:		the badblocks structure that holds all badblock information
+ */
+void badblocks_exit(struct badblocks *bb)
+{
+	if (!bb)
+		return;
+	if (bb->dev)
+		devm_kfree(bb->dev, bb->page);
+	else
+		kfree(bb->page);
+	bb->page = NULL;
+}
+EXPORT_SYMBOL_GPL(badblocks_exit);
+
+
+/*
+ * Test case related
+ */
+char good_sector[512];
+char bad_unack_sector[512];
+char bad_acked_sector[512];
+
+#define BB_SET	0
+#define BB_CLN	1
+
+unsigned int rand_seed = 2;
+
+char bb_ops[] = {0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1};
+char bb_ack[] = {1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0};
+
+/* disk file length is 256MB */
+#define DISKFILE_SECTORS	((256 << 20) >> 9)
+#define MAX_SET_SIZE		(DISKFILE_SECTORS/8192)
+#define MAX_CLN_SIZE		(DISKFILE_SECTORS/8192)
+
+#define BUF_LEN	(8<<10)
+
+void write_badblocks_log(struct badblocks *bb, char *dir, unsigned long seq,
+			 sector_t bb_start, sector_t bb_len,
+			 int ops, int ack)
+{
+	char path[512];
+	char buf[8192];
+	u64 *p = bb->page;
+	int len, size, i;
+	int fd;
+
+
+	size = sizeof(buf);
+	memset(buf, 0, sizeof(buf));
+	len = 0;
+
+	len += snprintf(buf + len, size - len, "============ %lu ============\n\n", seq);
+	if (ops == BB_SET)
+		len += snprintf(buf + len, size - len, "set: start %llu, len %llu, ack %d\n",
+				bb_start, bb_len, ack);
+	else
+		len += snprintf(buf + len, size - len, "clear: start %llu, len %llu\n",
+				bb_start, bb_len);
+
+	len += snprintf(buf + len, size - len, "=============================\n\n");
+
+	i = 0;
+	while (len < size && i < bb->count) {
+		sector_t s = BB_OFFSET(p[i]);
+		unsigned int length = BB_LEN(p[i]);
+		int ack = BB_ACK(p[i]);
+
+		i++;
+
+		len += snprintf(buf + len, size - len, "%llu %u [%u]\n",
+				(unsigned long long)s << bb->shift,
+				length << bb->shift,
+				ack);
+	}
+
+	snprintf(path, 512, "%s/seq-%.8lu", dir ? dir : ".", seq);
+	unlink(path);
+	fd = open(path, O_CREAT|O_RDWR, 0644);
+	if (fd < 0) {
+		printf("fail to create file %s\n", path);
+		return;
+	}
+	write(fd, buf, len);
+	fsync(fd);
+	close(fd);
+}
+
+
+int verify_bad_sectors(sector_t start, sector_t len, int expected, int fd)
+{
+	int ret = 0;
+	char buf[BUF_LEN];
+	unsigned long offset = start << 9;
+	unsigned long unread = len << 9;
+
+	if ((start + len) > DISKFILE_SECTORS)
+		printf("Error: invalid verify range: s %llu, l %llu\n, limit %u\n",
+		       start, len, DISKFILE_SECTORS);
+
+	while (unread > 0) {
+		unsigned long read_bytes = min(unread, BUF_LEN);
+		unsigned long i;
+		ssize_t _ret;
+
+		memset(buf, 0, sizeof(buf));
+		_ret = pread(fd, buf, read_bytes, offset);
+		if (_ret != read_bytes) {
+			printf("Error: to read %lu bytes, return %lu bytes\n",
+			       read_bytes, _ret);
+		}
+
+		for (i = 0; i < read_bytes; i++) {
+			if (buf[i] != expected) {
+				printf("Unexpected sector value %u (should be %u) at sector %lu offset byte %lu\n",
+				       buf[i], expected, (offset+i) >> 9,
+				       (offset + i) % 512);
+				if (ret == 0)
+					ret = -EIO;
+				break;
+			}
+		}
+
+		if (ret)
+			goto out;
+
+		unread -= read_bytes;
+		offset += read_bytes;
+	}
+
+out:
+	return ret;
+}
+
+int verify_badblocks_file(struct badblocks *bb, int fd, unsigned long seq)
+{
+	int ret = 0;
+	sector_t size = DISKFILE_SECTORS;
+	u64 *p = bb->page;
+	int i = 0;
+	unsigned long prev_pos, pos;
+
+	prev_pos = pos = 0;
+	while ((size > 0) && (i < bb->count)) {
+		sector_t s = BB_OFFSET(p[i]);
+		unsigned int length = BB_LEN(p[i]);
+		int ack = BB_ACK(p[i]);
+
+		pos = s;
+
+		/* verify non-bad area */
+		if (pos > prev_pos) {
+			ret = verify_bad_sectors(prev_pos, pos - prev_pos, 0, fd);
+			if (ret < 0) {
+				printf("%s:%d fail to verify good sectors [%lu, %lu), error: %s, seq: %ld\n",
+				      __func__, __LINE__, prev_pos, pos,
+				      strerror(-ret), seq);
+				goto out;
+			}
+
+			size -= (pos - prev_pos);
+		}
+
+		/* verify bad area */
+		ret = verify_bad_sectors(pos, length, ack ? 2 : 1, fd);
+		if (ret < 0) {
+			printf("%s:%d fail to verify bad sectors [%lu, %u) ack %d, error: %s\n",
+			       __func__, __LINE__, pos, length, ack, strerror(ret));
+			goto out;
+		}
+
+		size -= length;
+		i++;
+		prev_pos = pos + length;
+	}
+
+	if (i < bb->count) {
+		printf("Error: total %d bad records, verified %d, left %d\n",
+		       bb->count, i, bb->count - i);
+		if (size)
+			printf("Error: still have %llu sectors not verified\n",
+			       size);
+		ret = -EIO;
+		goto out;
+	}
+
+	/* verify rested non-bad area */
+	if (size) {
+		pos = DISKFILE_SECTORS;
+		ret = verify_bad_sectors(prev_pos, pos - prev_pos, 0, fd);
+		if (ret < 0) {
+			printf("%s:%d fail to verify good sectors [%lu, %lu), error: %s\n",
+			      __func__, __LINE__, prev_pos, pos, strerror(-ret));
+			goto out;
+		}
+	}
+
+	printf("verify badblocks file successfully (seq %lu)\n", seq);
+out:
+	return ret;
+}
+
+
+int _write_diskfile(int fd, int ops,
+		    sector_t start, sector_t len, int ack)
+{
+	off_t pos = start << 9;
+	char sector[512];
+
+	if ((start + len) > DISKFILE_SECTORS)
+		len = DISKFILE_SECTORS - start;
+
+	if (len == 0) {
+		printf("Error: write diskfile zero-length at %llu len %llu\n",
+		       start, len);
+		return -EINVAL;
+	}
+
+	if (ops == BB_CLN) {
+		while (len > 0) {
+			pwrite(fd, good_sector, 512, pos);
+			pos += 512;
+			len--;
+		}
+		fsync(fd);
+		return 0;
+	}
+
+	/* badblocks set */
+	while (len > 0) {
+		pread(fd, sector, 512, pos);
+		if (!memcmp(sector, good_sector, 512)) {
+			if (ack)
+				pwrite(fd, bad_acked_sector, 512, pos);
+			else
+				pwrite(fd, bad_unack_sector, 512, pos);
+
+//			printf("write %d at sector %lu\n", ack ? 2 : 1, pos >> 9);
+		} else if (!memcmp(sector, bad_unack_sector, 512)) {
+			if (ack) {
+				pwrite(fd, bad_acked_sector, 512, pos);
+//				printf("overwrite 2 at unack sector %lu\n", pos >> 9);
+			} else {
+//				printf("avoid overwrite already unacked sector %lu\n", pos >> 9);
+			}
+		} else if (!memcmp(sector, bad_acked_sector, 512)) {
+//			if (ack)
+//				printf("avoid overwrite already acked sector %lu\n", pos >> 9);
+//			else
+//				printf("cannot overwrite acked sector %lu\n", pos >> 9);
+		} else {
+			printf("Error: unexpected sector at %lu\n", pos >> 9);
+		}
+
+		pos += 512;
+		len--;
+	}
+
+	fsync(fd);
+	return 0;
+}
+
+int fix_writing_length(struct badblocks *bb, int seq, int ops,
+		       sector_t *_bb_start, sector_t *_bb_len, int ack)
+{
+	sector_t bb_len = *_bb_len, bb_start = *_bb_start;
+	sector_t ret_len = 0, ret_start = bb_start;
+	int prev;
+	struct badblocks_context bad;
+	u64 *p = bb->page;
+
+	bad.orig_start = bb_start;
+	bad.orig_len = bb_len;
+	bad.start = bb_start;
+	bad.len = bb_len;
+	bad.ack = ack;
+
+
+	if (ops == BB_SET) {
+		prev = prev_badblocks(bb, &bad, -1);
+		if (prev < 0) {
+			printf("Unexpected: the set range is not in badblocks table (seq %d)\n",
+			       seq);
+			exit(1);
+		}
+
+		while (BB_END(p[prev]) <= bb_start) {
+			if ((prev + 1) >= bb->count) {
+				printf("Too complicated, please manually verify for seq %d\n",
+				       seq);
+				exit(1);
+			}
+
+			prev++;
+		}
+
+		if (BB_ACK(p[prev]) != ack) {
+			printf("Too complicated: unmatched ack type %d, bb_start %llu, bb_len %llu\n",
+			       ack, bb_start, bb_len);
+			printf("from badblocks table, prev: %d, BB_OFFSET: %llu, BB_END: %llu, ACK: %u\n",
+			       prev, BB_OFFSET(p[prev]), BB_END(p[prev]), BB_ACK(p[prev]));
+			printf("please manually verify for seq %d\n", seq);
+			exit(1);
+		}
+
+		if (BB_OFFSET(p[prev]) > bb_start) {
+			bb_len -= BB_OFFSET(p[prev]) - bb_start;
+			bb_start = BB_OFFSET(p[prev]);
+		}
+
+		ret_start = bb_start;
+
+		while (bb_len > 0) {
+			int seg;
+
+			if (BB_END(p[prev]) >= (bb_start + bb_len))
+				seg = bb_len;
+			else
+				seg = BB_END(p[prev]) - bb_start;
+
+			ret_len += seg;
+			bb_start += seg;
+			bb_len -= seg;
+
+			if (bb_len == 0)
+				break;
+
+			if ((prev + 1) >= bb->count ||
+			    BB_END(p[prev]) != BB_OFFSET(p[prev + 1]) ||
+			    BB_ACK(p[prev]) != BB_ACK(p[prev + 1]))
+				break;
+			prev++;
+		}
+	} else if (ops == BB_CLN) {
+		ret_len = bb_len;
+
+	}
+
+	if (bad.orig_start != ret_start || bad.orig_len != ret_len)
+		printf("Fix writing bb_start,bb_len from %llu,%llu to %llu,%llu\n",
+		       bad.orig_start, bad.orig_len, ret_start, ret_len);
+
+	*_bb_start = ret_start;
+	*_bb_len = ret_len;
+	return 0;
+}
+
+int write_badblocks_file(struct badblocks *bb, unsigned long seq, int fd)
+{
+	int ret;
+	sector_t bb_start, bb_len;
+	int ops, random;
+
+retry:
+	random = rand_r(&rand_seed);
+	ops = bb_ops[random % sizeof(bb_ops)];
+	random = rand_r(&rand_seed);
+	if (ops == BB_SET)
+		bb_len = random % MAX_SET_SIZE;
+	else
+		bb_len = random % MAX_CLN_SIZE;
+	random = rand_r(&rand_seed);
+	bb_start = random % DISKFILE_SECTORS;
+	if ((bb_start + bb_len) > DISKFILE_SECTORS)
+		bb_len = DISKFILE_SECTORS - bb_start;
+	if (bb_len == 0) {
+		printf("random bb_len is 0, re-generate\n");
+		goto retry;
+	}
+
+
+	if (ops == BB_SET) {
+		int ack;
+
+		random = rand_r(&rand_seed);
+		ack = bb_ack[random % sizeof(bb_ack)];
+
+		bb->changed = 0;
+		ret = badblocks_set(bb, bb_start, bb_len, ack);
+		write_badblocks_log(bb, NULL, seq, bb_start, bb_len, BB_SET, ack);
+		if (ret > 0) {
+			printf("NOTICE: no space or cannot overwwrite badblocks\n"
+			       "        for badblocks_set(s: %llu, l: %llu, a: %d).\n"
+			       "        Manual check might be necessary if\n"
+			       "        following verification failed.\n",
+			       bb_start, bb_len, ack);
+			return 1;
+		}
+
+		if (badblocks_full(bb) && bb->changed)
+			fix_writing_length(bb, seq, ops, &bb_start, &bb_len, ack);
+		ret = _write_diskfile(fd, ops, bb_start, bb_len, ack);
+	} else {
+		bb->changed = 0;
+		ret = badblocks_clear(bb, bb_start, bb_len);
+		write_badblocks_log(bb, NULL, seq, bb_start, bb_len, BB_CLN, -1);
+		if (ret > 0) {
+			printf("NOTICE: no space for badblocks_clear(s: %llu, l: %llu)\n"
+			       "        Manual check might be necessary if\n"
+			       "        following verification failed.\n",
+			       bb_start, bb_len);
+			return 1;
+		}
+
+		ret = _write_diskfile(fd, ops, bb_start, bb_len, -1);
+	}
+
+	return ret;
+}
+
+#define MAX_BB_TEST_TRIES	(1<<22)
+int do_test(struct badblocks *bb)
+{
+	int ret = 0;
+	unsigned long seq;
+	char diskfile_name[] = "./dummy_disk_file";
+	int diskfile_fd = -1;
+
+	srand(rand_seed);
+
+	unlink(diskfile_name);
+	diskfile_fd = open(diskfile_name, O_CREAT|O_RDWR, 0644);
+	if (diskfile_fd < 0) {
+		printf("fail to create %s, error %s\n",
+		       diskfile_name, strerror(errno));
+		goto out;
+	}
+	ret = fallocate(diskfile_fd, FALLOC_FL_ZERO_RANGE, 0, DISKFILE_SECTORS << 9);
+	if (ret < 0) {
+		printf("fail to allocate zero-filled file, error %s\n",
+		       strerror(errno));
+		goto out;
+	}
+
+	for (seq = 1; seq <= MAX_BB_TEST_TRIES; seq++) {
+		ret = write_badblocks_file(bb, seq, diskfile_fd);
+		if (ret < 0) {
+			printf("fail to generate bad blocks for seq %lu, error %s\n",
+			       seq, strerror(-ret));
+			goto out;
+		}
+		ret = verify_badblocks_file(bb, diskfile_fd, seq);
+		if (ret < 0) {
+			printf("fail to verify bad blocks for seq %lu, error %s\n",
+			       seq, strerror(-ret));
+			goto out;
+		}
+	}
+
+out:
+	if (diskfile_fd >= 0)
+		close(diskfile_fd);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct badblocks bblocks;
+	struct badblocks *bb = &bblocks;
+	int i;
+
+	for (i = 0; i < 512; i++) {
+		good_sector[i] = 0;
+		bad_unack_sector[i] = 1;
+		bad_acked_sector[i] = 2;
+	}
+
+	memset(bb, 0, sizeof(struct badblocks));
+	badblocks_init(bb, 1);
+
+	do_test(bb);
+
+	badblocks_exit(bb);
+	return 0;
+}
-- 
2.35.3


