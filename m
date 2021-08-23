Return-Path: <nvdimm+bounces-951-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 477963F4B82
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 15:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id DE8EA3E0F73
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 13:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E9573FCB;
	Mon, 23 Aug 2021 13:16:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B793FC8
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 13:16:45 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id AABAC67357; Mon, 23 Aug 2021 15:16:42 +0200 (CEST)
Date: Mon, 23 Aug 2021 15:16:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v7 6/8] fsdax: Dedup file range to use a compare
 function
Message-ID: <20210823131642.GD15536@lst.de>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-7-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816060359.1442450-7-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 16, 2021 at 02:03:57PM +0800, Shiyang Ruan wrote:
> +	id = dax_read_lock();
> +	while ((ret = iomap_iter2(&it_src, &it_dest, ops)) > 0) {
> +		it_src.processed = it_dest.processed =
> +			dax_range_compare_iter(&it_src, &it_dest, same);
> +	}
> +	dax_read_unlock(id);

I think it would be better to move the DAX locking into
dax_range_compare_iter to avoid very long hold times.

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dax_dedupe_file_range_compare);

No need for the export.

> +EXPORT_SYMBOL(dax_remap_file_range_prep);

EXPORT_SYMBOL_GPL, please.

Attached is a totally untested patch that just has two levels of
iterations instead of the new iter2 helper:


diff --git a/fs/dax.c b/fs/dax.c
index 0e0536765a7efc..2b65471785290d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1885,6 +1885,7 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 	loff_t len = min(smap->length, dmap->length);
 	void *saddr, *daddr;
 	int ret;
+	int id;
 
 	if (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE) {
 		*same = true;
@@ -1896,47 +1897,56 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 		return 0;
 	}
 
+	id = dax_read_lock();
 	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
 				      &saddr, NULL);
 	if (ret < 0)
-		return -EIO;
+		goto out_unlock;
 
 	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
 				      &daddr, NULL);
 	if (ret < 0)
-		return -EIO;
+		goto out_unlock;
 
 	*same = !memcmp(saddr, daddr, len);
 	if (!*same)
-		return 0;
+		len = 0;
+	dax_read_unlock(id);
 	return len;
+
+out_unlock:
+	dax_read_unlock(id);
+	return -EIO;
 }
 
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
-		struct inode *dest, loff_t destoff, loff_t len, bool *same,
+		struct inode *dst, loff_t dstoff, loff_t len, bool *same,
 		const struct iomap_ops *ops)
 {
-	struct iomap_iter it_src = {
+	struct iomap_iter src_iter = {
 		.inode		= src,
 		.pos		= srcoff,
 		.len		= len,
 	};
-	struct iomap_iter it_dest = {
-		.inode		= dest,
-		.pos		= destoff,
+	struct iomap_iter dst_iter = {
+		.inode		= dst,
+		.pos		= dstoff,
 		.len		= len,
 	};
-	int id, ret;
+	int ret;
 
-	id = dax_read_lock();
-	while ((ret = iomap_iter2(&it_src, &it_dest, ops)) > 0) {
-		it_src.processed = it_dest.processed =
-			dax_range_compare_iter(&it_src, &it_dest, same);
+	while ((ret = iomap_iter(&src_iter, ops)) > 0) {
+		while ((ret = iomap_iter(&dst_iter, ops)) > 0) {
+			dst_iter.processed = dax_range_compare_iter(&src_iter,
+					&dst_iter, same);
+			if (dst_iter.processed > 0)
+				src_iter.processed += dst_iter.processed;
+			else if (!src_iter.processed)
+				src_iter.processed = dst_iter.processed;
+		}
 	}
-	dax_read_unlock(id);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dax_dedupe_file_range_compare);
 
 int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
@@ -1946,4 +1956,4 @@ int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
 					       pos_out, len, remap_flags, ops);
 }
-EXPORT_SYMBOL(dax_remap_file_range_prep);
+EXPORT_SYMBOL_GPL(dax_remap_file_range_prep);

