Return-Path: <nvdimm+bounces-3899-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6C1547D08
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Jun 2022 02:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3847280A6B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Jun 2022 00:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C6BEC4;
	Mon, 13 Jun 2022 00:10:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13557EA0
	for <nvdimm@lists.linux.dev>; Mon, 13 Jun 2022 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/eT01oHM8scLQTOGBAnJYt6o46Km3/nksV0jfD6gFIo=; b=kEGYdqXk+xMJqu3h8BdUHNwdHJ
	9CIwbIdhL5ZWRQwqTv6MxoC/juVD+xrbIPG55VRgqM2hHZ+sMrYV/SKNTEWlEO4WC100pNDBLAONE
	TT3PaEKU0Pr4loNF4cfYKncrBqfuu5OnGLZ8PfS/ylp3GnWiWcOXNEj1AiVrcR7WZ6yQ/DqR3GcIo
	YJWRtWv6N8ZH12pgkks4F6+xKC1sha28tQqSzpShqsuPxGVlf3uF19M6ejZLXFFr5adDeIBEskoQ8
	vEVwAWUX8cQGet5iER2lqBddGWFOeRr7lySwgKZLlsMA35T5ewAybPLEs3lsQ9Wve3xxmaFeFLRZK
	Ny1hIDvw==;
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1o0Xey-006ZFh-1h; Mon, 13 Jun 2022 00:10:24 +0000
Date: Mon, 13 Jun 2022 00:10:24 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [RFC][PATCH] fix short copy handling in copy_mc_pipe_to_iter()
Message-ID: <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

[commit in question sits in vfs.git#fixes]

Unlike other copying operations on ITER_PIPE, copy_mc_to_iter() can
result in a short copy.  In that case we need to trim the unused
buffers, as well as the length of partially filled one - it's not
enough to set ->head, ->iov_offset and ->count to reflect how
much had we copied.  Not hard to fix, fortunately...

I'd put a helper (pipe_discard_from(pipe, head)) into pipe_fs_i.h,
rather than iov_iter.c - it has nothing to do with iov_iter and
having it will allow us to avoid an ugly kludge in fs/splice.c.
We could put it into lib/iov_iter.c for now and move it later,
but I don't see the point going that way...

Fixes: ca146f6f091e "lib/iov_iter: Fix pipe handling in _copy_to_iter_mcsafe()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index cb0fd633a610..4ea496924106 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -229,6 +229,15 @@ static inline bool pipe_buf_try_steal(struct pipe_inode_info *pipe,
 	return buf->ops->try_steal(pipe, buf);
 }
 
+static inline void pipe_discard_from(struct pipe_inode_info *pipe,
+		unsigned int old_head)
+{
+	unsigned int mask = pipe->ring_size - 1;
+
+	while (pipe->head > old_head)
+		pipe_buf_release(pipe, &pipe->bufs[--pipe->head & mask]);
+}
+
 /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 0b64695ab632..2bf20b48a04a 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -689,6 +689,7 @@ static size_t copy_mc_pipe_to_iter(const void *addr, size_t bytes,
 	struct pipe_inode_info *pipe = i->pipe;
 	unsigned int p_mask = pipe->ring_size - 1;
 	unsigned int i_head;
+	unsigned int valid = pipe->head;
 	size_t n, off, xfer = 0;
 
 	if (!sanity(i))
@@ -702,11 +703,17 @@ static size_t copy_mc_pipe_to_iter(const void *addr, size_t bytes,
 		rem = copy_mc_to_kernel(p + off, addr + xfer, chunk);
 		chunk -= rem;
 		kunmap_local(p);
-		i->head = i_head;
-		i->iov_offset = off + chunk;
-		xfer += chunk;
-		if (rem)
+		if (chunk) {
+			i->head = i_head;
+			i->iov_offset = off + chunk;
+			xfer += chunk;
+			valid = i_head + 1;
+		}
+		if (rem) {
+			pipe->bufs[i_head & p_mask].len -= rem;
+			pipe_discard_from(pipe, valid);
 			break;
+		}
 		n -= chunk;
 		off = 0;
 		i_head++;

