Return-Path: <nvdimm+bounces-10907-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EAEAE5DF6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Jun 2025 09:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3E683AC175
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Jun 2025 07:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E20E25B680;
	Tue, 24 Jun 2025 07:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="deZ+NlV1"
X-Original-To: nvdimm@lists.linux.dev
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A8E25B30F
	for <nvdimm@lists.linux.dev>; Tue, 24 Jun 2025 07:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750750494; cv=none; b=C/SDE0tOCNxRQfV/mo1dTzpdkoWMwjmLI7kfKqx2LHPxFtnDZVvCutD3+m0yvlIsAhBQCHtMlXmCsB670qQ34/wcU2xN80kOIy+ibsYuD6BMCx/16gCdK3morP/xMP/EMqI/qnWVx5aEFHK8laY+3IoUoogBBQxpkluUaqBrkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750750494; c=relaxed/simple;
	bh=lSYg45Yhl+/XJ9Xyhp6MzXltkSAgowiF8QPXGp6UU+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlhHMpqeyK9O81QJx15FoHpZWPpYwxEJ8yMAfqyzEuiBBFrmyMO7+FJl8nvhLCv2gfLmRBQgM6cfaPYUWdPBcNvvrMty6axh0YeKp29cRe7rw9XV99rk3TeiasnbBAhw2GmCDtjRqTiZIUYrADP+xbU7LIaVifD13DebK6nmT+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=deZ+NlV1; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750750491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B4b1j7aRbbtr+Qpa+97KDO5u0wR5NoSEDsbjmBBgy1o=;
	b=deZ+NlV1Avv1qpZHqUHeCiOzvPEQ7G56GjfDhxXen6JJHHJcG1k1pu2RYJfjuDbzA63U3Y
	5QBxk4nYA2jYLdqnvvdKihCXkgqP2LJLR7qa4Bm9eyxF/8/Pcs8ywngery/H8I6lr/z9E4
	MhKrYnS4UaoqfqhjV5pikhezf2eM2DQ=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	Jonathan.Cameron@Huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v1 07/11] dm-pcache: add cache_gc
Date: Tue, 24 Jun 2025 07:33:54 +0000
Message-ID: <20250624073359.2041340-8-dongsheng.yang@linux.dev>
In-Reply-To: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Introduce cache_gc.c, a self-contained engine that reclaims cache
segments whose data have already been flushed to the backing device.
Running in the cache workqueue, the GC keeps segment usage below the
user-configurable *cache_gc_percent* threshold.

* need_gc() – decides when to trigger GC by checking:
  - *dirty_tail* vs *key_tail* position,
  - kset integrity (magic + CRC),
  - bitmap utilisation against the gc-percent threshold.

* Per-key reclamation
  - Decodes each key in the target kset (`cache_key_decode()`).
  - Drops the segment reference with `cache_seg_put()`, allowing the
    segment to be invalidated once all keys are gone.
  - When the reference count hits zero the segment is cleared from
    `seg_map`, making it immediately reusable by the allocator.

* Scheduling
  - `pcache_cache_gc_fn()` loops until no more work is needed, then
    re-queues itself after *PCACHE_CACHE_GC_INTERVAL*.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_gc.c | 170 ++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)
 create mode 100644 drivers/md/dm-pcache/cache_gc.c

diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
new file mode 100644
index 000000000000..a122d95c8f46
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+/**
+ * cache_key_gc - Releases the reference of a cache key segment.
+ * @cache: Pointer to the pcache_cache structure.
+ * @key: Pointer to the cache key to be garbage collected.
+ *
+ * This function decrements the reference count of the cache segment
+ * associated with the given key. If the reference count drops to zero,
+ * the segment may be invalidated and reused.
+ */
+static void cache_key_gc(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	cache_seg_put(key->cache_pos.cache_seg);
+}
+
+static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_tail, struct pcache_cache_pos *key_tail)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	void *dirty_addr, *key_addr;
+	u32 segs_used, segs_gc_threshold, to_copy;
+	int ret;
+
+	dirty_addr = cache_pos_addr(dirty_tail);
+	key_addr = cache_pos_addr(key_tail);
+	if (dirty_addr == key_addr) {
+		pcache_dev_debug(pcache, "key tail is equal to dirty tail: %u:%u\n",
+				dirty_tail->cache_seg->cache_seg_id,
+				dirty_tail->seg_off);
+		return false;
+	}
+
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->gc_kset_onmedia_buf;
+
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - key_tail->seg_off);
+	ret = copy_mc_to_kernel(kset_onmedia, key_addr, to_copy);
+	if (ret) {
+		pcache_dev_err(pcache, "error to read kset: %d", ret);
+		return false;
+	}
+
+	/* Check if kset_onmedia is corrupted */
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
+		pcache_dev_debug(pcache, "gc error: magic is not as expected. key_tail: %u:%u magic: %llx, expected: %llx\n",
+					key_tail->cache_seg->cache_seg_id, key_tail->seg_off,
+					kset_onmedia->magic, PCACHE_KSET_MAGIC);
+		return false;
+	}
+
+	/* Verify the CRC of the kset_onmedia */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		pcache_dev_debug(pcache, "gc error: crc is not as expected. crc: %x, expected: %x\n",
+					cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return false;
+	}
+
+	segs_used = bitmap_weight(cache->seg_map, cache->n_segs);
+	segs_gc_threshold = cache->n_segs * pcache_cache_get_gc_percent(cache) / 100;
+	if (segs_used < segs_gc_threshold) {
+		pcache_dev_debug(pcache, "segs_used: %u, segs_gc_threshold: %u\n", segs_used, segs_gc_threshold);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * last_kset_gc - Advances the garbage collection for the last kset.
+ * @cache: Pointer to the pcache_cache structure.
+ * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
+ */
+static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_segment *cur_seg, *next_seg;
+
+	cur_seg = cache->key_tail.cache_seg;
+
+	next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+
+	mutex_lock(&cache->key_tail_lock);
+	cache->key_tail.cache_seg = next_seg;
+	cache->key_tail.seg_off = 0;
+	cache_encode_key_tail(cache);
+	mutex_unlock(&cache->key_tail_lock);
+
+	pcache_dev_debug(pcache, "gc advance kset seg: %u\n", cur_seg->cache_seg_id);
+
+	spin_lock(&cache->seg_map_lock);
+	clear_bit(cur_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+}
+
+void pcache_cache_gc_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, gc_work.work);
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_pos dirty_tail, key_tail;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_key *key;
+	int ret;
+	int i;
+
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->gc_kset_onmedia_buf;
+
+	while (true) {
+		if (pcache_is_stopping(pcache) || atomic_read(&cache->gc_errors))
+			return;
+
+		/* Get new tail positions */
+		mutex_lock(&cache->dirty_tail_lock);
+		cache_pos_copy(&dirty_tail, &cache->dirty_tail);
+		mutex_unlock(&cache->dirty_tail_lock);
+
+		mutex_lock(&cache->key_tail_lock);
+		cache_pos_copy(&key_tail, &cache->key_tail);
+		mutex_unlock(&cache->key_tail_lock);
+
+		if (!need_gc(cache, &dirty_tail, &key_tail))
+			break;
+
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			/* Don't move to the next segment if dirty_tail has not moved */
+			if (dirty_tail.cache_seg == key_tail.cache_seg)
+				break;
+
+			last_kset_gc(cache, kset_onmedia);
+			continue;
+		}
+
+		for (i = 0; i < kset_onmedia->key_num; i++) {
+			struct pcache_cache_key key_tmp = { 0 };
+
+			key_onmedia = &kset_onmedia->data[i];
+
+			key = &key_tmp;
+			cache_key_init(&cache->req_key_tree, key);
+
+			ret = cache_key_decode(cache, key_onmedia, key);
+			if (ret) {
+				/* return without re-arm gc work, and prevent future
+				 * gc, because we can't retry the partial-gc-ed kset
+				 */
+				atomic_inc(&cache->gc_errors);
+				pcache_dev_err(pcache, "failed to decode cache key in gc\n");
+				return;
+			}
+
+			cache_key_gc(cache, key);
+		}
+
+		pcache_dev_debug(pcache, "gc advance: %u:%u %u\n",
+			key_tail.cache_seg->cache_seg_id,
+			key_tail.seg_off,
+			get_kset_onmedia_size(kset_onmedia));
+
+		mutex_lock(&cache->key_tail_lock);
+		cache_pos_advance(&cache->key_tail, get_kset_onmedia_size(kset_onmedia));
+		cache_encode_key_tail(cache);
+		mutex_unlock(&cache->key_tail_lock);
+	}
+
+	queue_delayed_work(cache_get_wq(cache), &cache->gc_work, PCACHE_CACHE_GC_INTERVAL);
+}
-- 
2.43.0


