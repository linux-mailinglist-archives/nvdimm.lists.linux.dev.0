Return-Path: <nvdimm+bounces-10215-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E82EA8757C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Apr 2025 03:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8944B188657D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Apr 2025 01:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0701A8403;
	Mon, 14 Apr 2025 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C/i6Wx+E"
X-Original-To: nvdimm@lists.linux.dev
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E3F1A3175
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 01:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595153; cv=none; b=NNZaivgD5Gd8tC2ZjXHh4fV/146k8WJZ6dVnfRipgn+pYXMIPYEZZUwaOUGVyC42+u1RC+B+j4JN+vD8ulqimovL1MCFuT1OU1I9ZV/C2N51k22AS3AJ3+S6J08vEges5GwXkXtK0qxD1PYlwB8AdV/pRHB8AYzZU/WO17l3yE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595153; c=relaxed/simple;
	bh=VZckwGgBqeyJPiuj1COjAFk16qUJWiOt/jKHpfPHaeY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmydMGjkzc2sFRvaH6kUJVHB55OdBQtnFZvt/sporWzjT8qYlBvV31Feq0fcA5j0Va/sg9okPLY2BJRO+90++dyS1500HGEtxhfl7Sakr4Y+d3/gDyd+cNC6UevwBeCSveHWnLNQ9REZL7VThGFmhor2q3cS55o5cR/To3Ig/I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C/i6Wx+E; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PERYZnF60Rueh79zQCyZ/qsBqw4mzIQTx9IQaNEQUms=;
	b=C/i6Wx+ErnwGPEqGJu/SrAxhuhTnZfDXOMlPYevcCKw7vkKWFW49gFdj+7ffV0NLC5ZkBq
	OlbFnEgiNdDwPQ8cGkfnXDQthmnXSZSvoY5e0PaAJbXEGMVsMTxFjcHZeyJ1D+SkUqIqZV
	XWFClSRYVDfxftkxAd950hyOMHimr1Q=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	gregory.price@memverge.com,
	John@groves.net,
	Jonathan.Cameron@Huawei.com,
	bbhushan2@marvell.com,
	chaitanyak@nvidia.com,
	rdunlap@infradead.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [RFC PATCH 07/11] pcache: introduce cache_key infrastructure for persistent metadata management
Date: Mon, 14 Apr 2025 01:45:01 +0000
Message-Id: <20250414014505.20477-8-dongsheng.yang@linux.dev>
In-Reply-To: <20250414014505.20477-1-dongsheng.yang@linux.dev>
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This patch adds a comprehensive cache key management module to pcache.
Cache keys represent a mapping between logical offsets and cached data in
persistent memory. The new implementation provides functions for:

  - Allocation and initialization of cache keys with reference counting,
    using kmem_cache for efficient memory management.
  - Encoding cache keys into an on-media format (struct pcache_cache_key_onmedia)
    that stores offset, length, segment information (segment ID and offset),
    generation number, and flags, with optional data CRC for integrity.
  - Decoding on-media cache keys and validating their integrity, reporting
    errors if mismatches occur.
  - Appending keys to ksets and handling kset flush when a kset becomes full,
    including support for appending a “last kset” marker for segment chaining.
  - Insertion of cache keys into the cache tree (implemented as an RB-tree),
    including custom overlap fixup functions (fixup_overlap_tail, fixup_overlap_head,
    fixup_overlap_contain, fixup_overlap_contained) to handle various overlapping
    scenarios during key insertion.
  - Cache tree traversal and search functions (cache_subtree_walk, cache_subtree_search)
    for efficient key management and garbage collection, along with a background
    cleanup routine (clean_fn) to remove invalid keys.

This cache_key infrastructure is a key part of the pcache metadata system,
enabling persistent, crash-consistent tracking of cached data locations and
facilitating recovery and garbage collection.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/cache_key.c | 885 +++++++++++++++++++++++++++++++
 1 file changed, 885 insertions(+)
 create mode 100644 drivers/block/pcache/cache_key.c

diff --git a/drivers/block/pcache/cache_key.c b/drivers/block/pcache/cache_key.c
new file mode 100644
index 000000000000..d68055ae8c2f
--- /dev/null
+++ b/drivers/block/pcache/cache_key.c
@@ -0,0 +1,885 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cache.h"
+#include "backing_dev.h"
+
+struct pcache_cache_kset_onmedia pcache_empty_kset = { 0 };
+
+void cache_key_init(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key)
+{
+	kref_init(&key->ref);
+	key->cache_tree = cache_tree;
+	INIT_LIST_HEAD(&key->list_node);
+	RB_CLEAR_NODE(&key->rb_node);
+}
+
+struct pcache_cache_key *cache_key_alloc(struct pcache_cache_tree *cache_tree)
+{
+	struct pcache_cache_key *key;
+
+	key = kmem_cache_zalloc(cache_tree->key_cache, GFP_NOWAIT);
+	if (!key)
+		return NULL;
+
+	cache_key_init(cache_tree, key);
+
+	return key;
+}
+
+/**
+ * cache_key_get - Increment the reference count of a cache key.
+ * @key: Pointer to the pcache_cache_key structure.
+ *
+ * This function increments the reference count of the specified cache key,
+ * ensuring that it is not freed while still in use.
+ */
+void cache_key_get(struct pcache_cache_key *key)
+{
+	kref_get(&key->ref);
+}
+
+/**
+ * cache_key_destroy - Free a cache key structure when its reference count drops to zero.
+ * @ref: Pointer to the kref structure.
+ *
+ * This function is called when the reference count of the cache key reaches zero.
+ * It frees the allocated cache key back to the slab cache.
+ */
+static void cache_key_destroy(struct kref *ref)
+{
+	struct pcache_cache_key *key = container_of(ref, struct pcache_cache_key, ref);
+	struct pcache_cache_tree *cache_tree = key->cache_tree;
+
+	kmem_cache_free(cache_tree->key_cache, key);
+}
+
+void cache_key_put(struct pcache_cache_key *key)
+{
+	kref_put(&key->ref, cache_key_destroy);
+}
+
+void cache_pos_advance(struct pcache_cache_pos *pos, u32 len)
+{
+	/* Ensure enough space remains in the current segment */
+	BUG_ON(cache_seg_remain(pos) < len);
+
+	pos->seg_off += len;
+}
+
+static void cache_key_encode(struct pcache_cache *cache,
+			     struct pcache_cache_key_onmedia *key_onmedia,
+			     struct pcache_cache_key *key)
+{
+	key_onmedia->off = key->off;
+	key_onmedia->len = key->len;
+
+	key_onmedia->cache_seg_id = key->cache_pos.cache_seg->cache_seg_id;
+	key_onmedia->cache_seg_off = key->cache_pos.seg_off;
+
+	key_onmedia->seg_gen = key->seg_gen;
+	key_onmedia->flags = key->flags;
+
+	if (cache_data_crc_on(cache))
+		key_onmedia->data_crc = cache_key_data_crc(key);
+}
+
+int cache_key_decode(struct pcache_cache *cache,
+			struct pcache_cache_key_onmedia *key_onmedia,
+			struct pcache_cache_key *key)
+{
+	key->off = key_onmedia->off;
+	key->len = key_onmedia->len;
+
+	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
+	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
+
+	key->seg_gen = key_onmedia->seg_gen;
+	key->flags = key_onmedia->flags;
+
+	if (cache_data_crc_on(cache) &&
+			key_onmedia->data_crc != cache_key_data_crc(key)) {
+		backing_dev_err(cache->backing_dev, "key: %llu:%u seg %u:%u data_crc error: %x, expected: %x\n",
+				key->off, key->len, key->cache_pos.cache_seg->cache_seg_id,
+				key->cache_pos.seg_off, cache_key_data_crc(key), key_onmedia->data_crc);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void append_last_kset(struct pcache_cache *cache, u32 next_seg)
+{
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+
+	kset_onmedia = get_key_head_addr(cache);
+	kset_onmedia->flags |= PCACHE_KSET_FLAGS_LAST;
+	kset_onmedia->next_cache_seg_id = next_seg;
+	kset_onmedia->magic = PCACHE_KSET_MAGIC;
+	kset_onmedia->crc = cache_kset_crc(kset_onmedia);
+	cache_pos_advance(&cache->key_head, sizeof(struct pcache_cache_kset_onmedia));
+}
+
+int cache_kset_close(struct pcache_cache *cache, struct pcache_cache_kset *kset)
+{
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 kset_onmedia_size;
+	int ret;
+
+	kset_onmedia = &kset->kset_onmedia;
+
+	if (!kset_onmedia->key_num)
+		return 0;
+
+	kset_onmedia_size = struct_size(kset_onmedia, data, kset_onmedia->key_num);
+
+	spin_lock(&cache->key_head_lock);
+again:
+	/* Reserve space for the last kset */
+	if (cache_seg_remain(&cache->key_head) < kset_onmedia_size + sizeof(struct pcache_cache_kset_onmedia)) {
+		struct pcache_cache_segment *next_seg;
+
+		next_seg = get_cache_segment(cache);
+		if (!next_seg) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		/* clear outdated kset in next seg */
+		memcpy_flushcache(next_seg->segment.data, &pcache_empty_kset,
+					sizeof(struct pcache_cache_kset_onmedia));
+		append_last_kset(cache, next_seg->cache_seg_id);
+		cache->key_head.cache_seg = next_seg;
+		cache->key_head.seg_off = 0;
+		goto again;
+	}
+
+	kset_onmedia->magic = PCACHE_KSET_MAGIC;
+	kset_onmedia->crc = cache_kset_crc(kset_onmedia);
+
+	/* clear outdated kset after current kset */
+	memcpy_flushcache(get_key_head_addr(cache) + kset_onmedia_size, &pcache_empty_kset,
+				sizeof(struct pcache_cache_kset_onmedia));
+
+	/* write current kset into segment */
+	memcpy_flushcache(get_key_head_addr(cache), kset_onmedia, kset_onmedia_size);
+	memset(kset_onmedia, 0, sizeof(struct pcache_cache_kset_onmedia));
+	cache_pos_advance(&cache->key_head, kset_onmedia_size);
+
+	ret = 0;
+out:
+	spin_unlock(&cache->key_head_lock);
+
+	return ret;
+}
+
+/**
+ * cache_key_append - Append a cache key to the related kset.
+ * @cache: Pointer to the pcache_cache structure.
+ * @key: Pointer to the cache key structure to append.
+ *
+ * This function appends a cache key to the appropriate kset. If the kset
+ * is full, it closes the kset. If not, it queues a flush work to write
+ * the kset to media.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int cache_key_append(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	struct pcache_cache_kset *kset;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	struct pcache_cache_key_onmedia *key_onmedia;
+	u32 kset_id = get_kset_id(cache, key->off);
+	int ret = 0;
+
+	kset = get_kset(cache, kset_id);
+	kset_onmedia = &kset->kset_onmedia;
+
+	spin_lock(&kset->kset_lock);
+	key_onmedia = &kset_onmedia->data[kset_onmedia->key_num];
+	cache_key_encode(cache, key_onmedia, key);
+
+	/* Check if the current kset has reached the maximum number of keys */
+	if (++kset_onmedia->key_num == PCACHE_KSET_KEYS_MAX) {
+		/* If full, close the kset */
+		ret = cache_kset_close(cache, kset);
+		if (ret) {
+			kset_onmedia->key_num--;
+			goto out;
+		}
+	} else {
+		/* If not full, queue a delayed work to flush the kset */
+		queue_delayed_work(cache->backing_dev->task_wq, &kset->flush_work, 1 * HZ);
+	}
+out:
+	spin_unlock(&kset->kset_lock);
+
+	return ret;
+}
+
+/**
+ * cache_subtree_walk - Traverse the cache tree.
+ * @cache: Pointer to the pcache_cache structure.
+ * @ctx: Pointer to the context structure for traversal.
+ *
+ * This function traverses the cache tree starting from the specified node.
+ * It calls the appropriate callback functions based on the relationships
+ * between the keys in the cache tree.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int cache_subtree_walk(struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache_key *key_tmp, *key;
+	struct rb_node *node_tmp;
+	int ret;
+
+	key = ctx->key;
+	node_tmp = ctx->start_node;
+
+	while (node_tmp) {
+		if (ctx->walk_done && ctx->walk_done(ctx))
+			break;
+
+		key_tmp = CACHE_KEY(node_tmp);
+		/*
+		 * If key_tmp ends before the start of key, continue to the next node.
+		 * |----------|
+		 *              |=====|
+		 */
+		if (cache_key_lend(key_tmp) <= cache_key_lstart(key)) {
+			if (ctx->after) {
+				ret = ctx->after(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			goto next;
+		}
+
+		/*
+		 * If key_tmp starts after the end of key, stop traversing.
+		 *	  |--------|
+		 * |====|
+		 */
+		if (cache_key_lstart(key_tmp) >= cache_key_lend(key)) {
+			if (ctx->before) {
+				ret = ctx->before(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			break;
+		}
+
+		/* Handle overlapping keys */
+		if (cache_key_lstart(key_tmp) >= cache_key_lstart(key)) {
+			/*
+			 * If key_tmp encompasses key.
+			 *     |----------------|	key_tmp
+			 * |===========|		key
+			 */
+			if (cache_key_lend(key_tmp) >= cache_key_lend(key)) {
+				if (ctx->overlap_tail) {
+					ret = ctx->overlap_tail(key, key_tmp, ctx);
+					if (ret)
+						goto out;
+				}
+				break;
+			}
+
+			/*
+			 * If key_tmp is contained within key.
+			 *    |----|		key_tmp
+			 * |==========|		key
+			 */
+			if (ctx->overlap_contain) {
+				ret = ctx->overlap_contain(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+
+			goto next;
+		}
+
+		/*
+		 * If key_tmp starts before key ends but ends after key.
+		 * |-----------|	key_tmp
+		 *   |====|		key
+		 */
+		if (cache_key_lend(key_tmp) > cache_key_lend(key)) {
+			if (ctx->overlap_contained) {
+				ret = ctx->overlap_contained(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			break;
+		}
+
+		/*
+		 * If key_tmp starts before key and ends within key.
+		 * |--------|		key_tmp
+		 *   |==========|	key
+		 */
+		if (ctx->overlap_head) {
+			ret = ctx->overlap_head(key, key_tmp, ctx);
+			if (ret)
+				goto out;
+		}
+next:
+		node_tmp = rb_next(node_tmp);
+	}
+
+	if (ctx->walk_finally) {
+		ret = ctx->walk_finally(ctx);
+		if (ret)
+			goto out;
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * cache_subtree_search - Search for a key in the cache tree.
+ * @cache_subtree: Pointer to the cache tree structure.
+ * @key: Pointer to the cache key to search for.
+ * @parentp: Pointer to store the parent node of the found node.
+ * @newp: Pointer to store the location where the new node should be inserted.
+ * @delete_key_list: List to collect invalid keys for deletion.
+ *
+ * This function searches the cache tree for a specific key and returns
+ * the node that is the predecessor of the key, or first node if the key is
+ * less than all keys in the tree. If any invalid keys are found during
+ * the search, they are added to the delete_key_list for later cleanup.
+ *
+ * Returns a pointer to the previous node.
+ */
+struct rb_node *cache_subtree_search(struct pcache_cache_subtree *cache_subtree, struct pcache_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list)
+{
+	struct rb_node **new, *parent = NULL;
+	struct pcache_cache_key *key_tmp;
+	struct rb_node *prev_node = NULL;
+
+	new = &(cache_subtree->root.rb_node);
+	while (*new) {
+		key_tmp = container_of(*new, struct pcache_cache_key, rb_node);
+		if (cache_key_invalid(key_tmp))
+			list_add(&key_tmp->list_node, delete_key_list);
+
+		parent = *new;
+		if (key_tmp->off >= key->off) {
+			new = &((*new)->rb_left);
+		} else {
+			prev_node = *new;
+			new = &((*new)->rb_right);
+		}
+	}
+
+	if (!prev_node)
+		prev_node = rb_first(&cache_subtree->root);
+
+	if (parentp)
+		*parentp = parent;
+
+	if (newp)
+		*newp = new;
+
+	return prev_node;
+}
+
+/**
+ * fixup_overlap_tail - Adjust the key when it overlaps at the tail.
+ * @key: Pointer to the new cache key being inserted.
+ * @key_tmp: Pointer to the existing key that overlaps.
+ * @ctx: Pointer to the context for walking the cache tree.
+ *
+ * This function modifies the existing key (key_tmp) when there is an
+ * overlap at the tail with the new key. If the modified key becomes
+ * empty, it is deleted. Returns 0 on success, or -EAGAIN if the key
+ * needs to be reinserted.
+ */
+static int fixup_overlap_tail(struct pcache_cache_key *key,
+			       struct pcache_cache_key *key_tmp,
+			       struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	int ret;
+
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	cache_key_cutfront(key_tmp, cache_key_lend(key) - cache_key_lstart(key_tmp));
+	if (key_tmp->len == 0) {
+		cache_key_delete(key_tmp);
+		ret = -EAGAIN;
+
+		/*
+		 * Deleting key_tmp may change the structure of the
+		 * entire cache tree, so we need to re-search the tree
+		 * to determine the new insertion point for the key.
+		 */
+		goto out;
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * fixup_overlap_contain - Handle case where new key completely contains an existing key.
+ * @key: Pointer to the new cache key being inserted.
+ * @key_tmp: Pointer to the existing key that is being contained.
+ * @ctx: Pointer to the context for walking the cache tree.
+ *
+ * This function deletes the existing key (key_tmp) when the new key
+ * completely contains it. It returns -EAGAIN to indicate that the
+ * tree structure may have changed, necessitating a re-insertion of
+ * the new key.
+ */
+static int fixup_overlap_contain(struct pcache_cache_key *key,
+				  struct pcache_cache_key *key_tmp,
+				  struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	cache_key_delete(key_tmp);
+
+	return -EAGAIN;
+}
+
+/**
+ * fixup_overlap_contained - Handle overlap when a new key is contained in an existing key.
+ * @key: The new cache key being inserted.
+ * @key_tmp: The existing cache key that overlaps with the new key.
+ * @ctx: Context for the cache tree walk.
+ *
+ * This function adjusts the existing key if the new key is contained
+ * within it. If the existing key is empty, it indicates a placeholder key
+ * that was inserted during a miss read. This placeholder will later be
+ * updated with real data from the backing_dev, making it no longer an empty key.
+ *
+ * If we delete key or insert a key, the structure of the entire cache tree may change,
+ * requiring a full research of the tree to find a new insertion point.
+ */
+static int fixup_overlap_contained(struct pcache_cache_key *key,
+	struct pcache_cache_key *key_tmp, struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache_tree *cache_tree = ctx->cache_tree;
+	int ret;
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	if (cache_key_empty(key_tmp)) {
+		/* If key_tmp is empty, don't split it;
+		 * it's a placeholder key for miss reads that will be updated later.
+		 */
+		cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+		if (key_tmp->len == 0) {
+			cache_key_delete(key_tmp);
+			ret = -EAGAIN;
+			goto out;
+		}
+	} else {
+		struct pcache_cache_key *key_fixup;
+		bool need_research = false;
+
+		/* Allocate a new cache key for splitting key_tmp */
+		key_fixup = cache_key_alloc(cache_tree);
+		if (!key_fixup) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		cache_key_copy(key_fixup, key_tmp);
+
+		/* Split key_tmp based on the new key's range */
+		cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+		if (key_tmp->len == 0) {
+			cache_key_delete(key_tmp);
+			need_research = true;
+		}
+
+		/* Create a new portion for key_fixup */
+		cache_key_cutfront(key_fixup, cache_key_lend(key) - cache_key_lstart(key_tmp));
+		if (key_fixup->len == 0) {
+			cache_key_put(key_fixup);
+		} else {
+			/* Insert the new key into the cache */
+			ret = cache_key_insert(cache_tree, key_fixup, false);
+			if (ret)
+				goto out;
+			need_research = true;
+		}
+
+		if (need_research) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * fixup_overlap_head - Handle overlap when a new key overlaps with the head of an existing key.
+ * @key: The new cache key being inserted.
+ * @key_tmp: The existing cache key that overlaps with the new key.
+ * @ctx: Context for the cache tree walk.
+ *
+ * This function adjusts the existing key if the new key overlaps
+ * with the beginning of it. If the resulting key length is zero
+ * after the adjustment, the key is deleted. This indicates that
+ * the key no longer holds valid data and requires the tree to be
+ * re-researched for a new insertion point.
+ */
+static int fixup_overlap_head(struct pcache_cache_key *key,
+	struct pcache_cache_key *key_tmp, struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 * |--------|		key_tmp
+	 *   |==========|	key
+	 */
+	/* Adjust key_tmp by cutting back based on the new key's start */
+	cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+	if (key_tmp->len == 0) {
+		/* If the adjusted key_tmp length is zero, delete it */
+		cache_key_delete(key_tmp);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * cache_insert_fixup - Fix up overlaps when inserting a new key.
+ * @cache_tree: Pointer to the cache_tree structure.
+ * @key: The new cache key to insert.
+ * @prev_node: The last visited node during the search.
+ *
+ * This function initializes a walking context and calls the
+ * cache_subtree_walk function to handle potential overlaps between
+ * the new key and existing keys in the cache tree. Various
+ * fixup functions are provided to manage different overlap scenarios.
+ */
+static int cache_insert_fixup(struct pcache_cache_tree *cache_tree,
+	struct pcache_cache_key *key, struct rb_node *prev_node)
+{
+	struct pcache_cache_subtree_walk_ctx walk_ctx = { 0 };
+
+	/* Set up the context with the cache, start node, and new key */
+	walk_ctx.cache_tree = cache_tree;
+	walk_ctx.start_node = prev_node;
+	walk_ctx.key = key;
+
+	/* Assign overlap handling functions for different scenarios */
+	walk_ctx.overlap_tail = fixup_overlap_tail;
+	walk_ctx.overlap_head = fixup_overlap_head;
+	walk_ctx.overlap_contain = fixup_overlap_contain;
+	walk_ctx.overlap_contained = fixup_overlap_contained;
+
+	/* Begin walking the cache tree to fix overlaps */
+	return cache_subtree_walk(&walk_ctx);
+}
+
+/**
+ * cache_key_insert - Insert a new cache key into the cache tree.
+ * @cache_tree: Pointer to the cache_tree structure.
+ * @key: The cache key to insert.
+ * @fixup: Indicates if this is a new key being inserted.
+ *
+ * This function searches for the appropriate location to insert
+ * a new cache key into the cache tree. It handles key overlaps
+ * and ensures any invalid keys are removed before insertion.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int cache_key_insert(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key, bool fixup)
+{
+	struct rb_node **new, *parent = NULL;
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key_tmp = NULL, *key_next;
+	struct rb_node *prev_node = NULL;
+	LIST_HEAD(delete_key_list);
+	int ret;
+
+	cache_subtree = get_subtree(cache_tree, key->off);
+	key->cache_subtree = cache_subtree;
+search:
+	prev_node = cache_subtree_search(cache_subtree, key, &parent, &new, &delete_key_list);
+	if (!list_empty(&delete_key_list)) {
+		/* Remove invalid keys from the delete list */
+		list_for_each_entry_safe(key_tmp, key_next, &delete_key_list, list_node) {
+			list_del_init(&key_tmp->list_node);
+			cache_key_delete(key_tmp);
+		}
+		goto search;
+	}
+
+	if (fixup) {
+		ret = cache_insert_fixup(cache_tree, key, prev_node);
+		if (ret == -EAGAIN)
+			goto search;
+		if (ret)
+			goto out;
+	}
+
+	/* Link and insert the new key into the red-black tree */
+	rb_link_node(&key->rb_node, parent, new);
+	rb_insert_color(&key->rb_node, &cache_subtree->root);
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * clean_fn - Cleanup function to remove invalid keys from the cache tree.
+ * @work: Pointer to the work_struct associated with the cleanup.
+ *
+ * This function cleans up invalid keys from the cache tree in the background
+ * after a cache segment has been invalidated during cache garbage collection.
+ * It processes a maximum of PCACHE_CLEAN_KEYS_MAX keys per iteration and holds
+ * the tree lock to ensure thread safety.
+ */
+void clean_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, clean_work);
+	struct pcache_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct pcache_cache_key *key;
+	int i, count;
+
+	for (i = 0; i < cache->req_key_tree.n_subtrees; i++) {
+		cache_subtree = &cache->req_key_tree.subtrees[i];
+
+again:
+		if (cache->state == PCACHE_CACHE_STATE_STOPPING)
+			return;
+
+		/* Delete up to PCACHE_CLEAN_KEYS_MAX keys in one iteration */
+		count = 0;
+		spin_lock(&cache_subtree->tree_lock);
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+			if (cache_key_invalid(key)) {
+				count++;
+				cache_key_delete(key);
+			}
+
+			if (count >= PCACHE_CLEAN_KEYS_MAX) {
+				/* Unlock and pause before continuing cleanup */
+				spin_unlock(&cache_subtree->tree_lock);
+				usleep_range(1000, 2000);
+				goto again;
+			}
+		}
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+}
+
+/*
+ * kset_flush_fn - Flush work for a cache kset.
+ *
+ * This function is called when a kset flush work is queued from
+ * cache_key_append(). If the kset is full, it will be closed
+ * immediately. If not, the flush work will be queued for later closure.
+ *
+ * If cache_kset_close detects that a new segment is required to store
+ * the kset and there are no available segments, it will return an error.
+ * In this scenario, a retry will be attempted.
+ */
+void kset_flush_fn(struct work_struct *work)
+{
+	struct pcache_cache_kset *kset = container_of(work, struct pcache_cache_kset, flush_work.work);
+	struct pcache_cache *cache = kset->cache;
+	int ret;
+
+	spin_lock(&kset->kset_lock);
+	ret = cache_kset_close(cache, kset);
+	spin_unlock(&kset->kset_lock);
+
+	if (ret) {
+		/* Failed to flush kset, schedule a retry. */
+		queue_delayed_work(cache->backing_dev->task_wq, &kset->flush_work, 0);
+	}
+}
+
+static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_key *key;
+	int ret;
+	int i;
+
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = cache_key_alloc(&cache->req_key_tree);
+		if (!key) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			cache_key_put(key);
+			goto err;
+		}
+
+		/* Mark the segment as used in the segment map. */
+		set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
+
+		/* Check if the segment generation is valid for insertion. */
+		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
+			cache_key_put(key);
+		} else {
+			ret = cache_key_insert(&cache->req_key_tree, key, true);
+			if (ret) {
+				cache_key_put(key);
+				goto err;
+			}
+		}
+
+		cache_seg_get(key->cache_pos.cache_seg);
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
+int cache_replay(struct pcache_cache *cache)
+{
+	struct pcache_cache_pos pos_tail;
+	struct pcache_cache_pos *pos;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 count = 0;
+	int ret = 0;
+	void *addr;
+
+	cache_pos_copy(&pos_tail, &cache->key_tail);
+	pos = &pos_tail;
+
+	/* Mark the segment as used in the segment map. */
+	set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
+
+	while (true) {
+		addr = cache_pos_addr(pos);
+
+		kset_onmedia = (struct pcache_cache_kset_onmedia *)addr;
+		if (kset_onmedia->magic != PCACHE_KSET_MAGIC ||
+				kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+			break;
+		}
+
+		if (kset_onmedia->crc != cache_kset_crc(kset_onmedia))
+			break;
+
+		/* Process the last kset and prepare for the next segment. */
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			struct pcache_cache_segment *next_seg;
+
+			backing_dev_debug(cache->backing_dev, "last kset replay, next: %u\n", kset_onmedia->next_cache_seg_id);
+
+			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+
+			pos->cache_seg = next_seg;
+			pos->seg_off = 0;
+
+			set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
+			continue;
+		}
+
+		/* Replay the kset and check for errors. */
+		ret = kset_replay(cache, kset_onmedia);
+		if (ret)
+			goto out;
+
+		/* Advance the position after processing the kset. */
+		cache_pos_advance(pos, get_kset_onmedia_size(kset_onmedia));
+		if (++count > 512) {
+			cond_resched();
+			count = 0;
+		}
+	}
+
+	/* Update the key_head position after replaying. */
+	spin_lock(&cache->key_head_lock);
+	cache_pos_copy(&cache->key_head, pos);
+	spin_unlock(&cache->key_head_lock);
+
+out:
+	return ret;
+}
+
+int cache_tree_init(struct pcache_cache *cache, struct pcache_cache_tree *cache_tree, u32 n_subtrees)
+{
+	int ret;
+	u32 i;
+
+	cache_tree->cache = cache;
+	cache_tree->n_subtrees = n_subtrees;
+
+	cache_tree->key_cache = KMEM_CACHE(pcache_cache_key, 0);
+	if (!cache_tree->key_cache) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	/*
+	 * Allocate and initialize the subtrees array.
+	 * Each element is a cache tree structure that contains
+	 * an RB tree root and a spinlock for protecting its contents.
+	 */
+	cache_tree->subtrees = kvcalloc(cache_tree->n_subtrees, sizeof(struct pcache_cache_subtree), GFP_KERNEL);
+	if (!cache_tree->n_subtrees) {
+		ret = -ENOMEM;
+		goto destroy_key_cache;
+	}
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		struct pcache_cache_subtree *cache_subtree = &cache_tree->subtrees[i];
+
+		cache_subtree->root = RB_ROOT;
+		spin_lock_init(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+
+destroy_key_cache:
+	kmem_cache_destroy(cache_tree->key_cache);
+err:
+	return ret;
+}
+
+void cache_tree_exit(struct pcache_cache_tree *cache_tree)
+{
+	struct pcache_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct pcache_cache_key *key;
+	u32 i;
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		cache_subtree = &cache_tree->subtrees[i];
+
+		spin_lock(&cache_subtree->tree_lock);
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+
+			cache_key_delete(key);
+		}
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+	kvfree(cache_tree->subtrees);
+	kmem_cache_destroy(cache_tree->key_cache);
+}
-- 
2.34.1


