Return-Path: <nvdimm+bounces-754-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C453E3FB5
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 627C01C0F59
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE912FB8;
	Mon,  9 Aug 2021 06:19:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974F417F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ThiQ8H5/4+7FSm/zS61UmRD/4q2DLtoqXT61QRXsDbI=; b=fMCI1cR2vF5GqLz1niocPpHvst
	Lc+u/DO6ldrIRmL+11jbUOAmbS/2sqjd9cUbLxGuwZvPchRWAoXz0tVuBgVt9St3YbeQxjT1WbMEb
	GG4bdY0oIZnzfREU+R7EMM7nENodnnXVBKy6hR9DIK5dpBv2ogcit3nzSdjhjrPeEzi142Czmp4SP
	e1RQ5sUitZ8L7u8bc4YCNgBxsw9PItmsoBbN4ujg+Db3ZWnQQjh20vizq4mUQm56xvT/JI1ZUVgpZ
	y7QPcmkFUe+z/0JOI3Bcl+f++Hati/D6+JGjv3wxGjeTD9hHALkRmVFArPhNuxbp5wU4hXrL5b8OZ
	5gLV1xLg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyb7-00Agb9-0j; Mon, 09 Aug 2021 06:17:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	cluster-devel@redhat.com
Subject: [PATCH 06/30] fs: mark the iomap argument to __block_write_begin_int const
Date: Mon,  9 Aug 2021 08:12:20 +0200
Message-Id: <20210809061244.1196573-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809061244.1196573-1-hch@lst.de>
References: <20210809061244.1196573-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

__block_write_begin_int never modifies the passed in iomap, so mark it
const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/buffer.c   | 4 ++--
 fs/internal.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6290c3afdba488..bd6a9e9fbd64c9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1912,7 +1912,7 @@ EXPORT_SYMBOL(page_zero_new_buffers);
 
 static void
 iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
-		struct iomap *iomap)
+		const struct iomap *iomap)
 {
 	loff_t offset = block << inode->i_blkbits;
 
@@ -1966,7 +1966,7 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 }
 
 int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
-		get_block_t *get_block, struct iomap *iomap)
+		get_block_t *get_block, const struct iomap *iomap)
 {
 	unsigned from = pos & (PAGE_SIZE - 1);
 	unsigned to = from + len;
diff --git a/fs/internal.h b/fs/internal.h
index 82e8eb32ff3dd8..54c2928d39ec72 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -48,8 +48,8 @@ static inline int emergency_thaw_bdev(struct super_block *sb)
 /*
  * buffer.c
  */
-extern int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
-		get_block_t *get_block, struct iomap *iomap);
+int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
+		get_block_t *get_block, const struct iomap *iomap);
 
 /*
  * char_dev.c
-- 
2.30.2


