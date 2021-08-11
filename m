Return-Path: <nvdimm+bounces-856-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 065B03E9889
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 21:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 8375A3E14E3
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 19:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B948E2FB2;
	Wed, 11 Aug 2021 19:18:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5EB72
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 19:18:00 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734C160EB9;
	Wed, 11 Aug 2021 19:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628709480;
	bh=cqWXqkb6ob+gfCb7sASelKlI0tGSx6yt25qoqywUXLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u70QOf/HBbRzHm4laVrflmiaknhZglXEsFVA0TyBOFtZuZ6SpVEThFivpYX4wtpFl
	 zVKr15SRFjjZZdUhu7delLe5EOeIaorcTqFfeoeBRorSa7ybv5G+CSwNrUT/BR5GXL
	 HKgsUqqmq246ON/gJyEBC1XfvqwTC6ZueBARZEP4RHNmKUtYDsZEROSHupn6kgkCNu
	 Uq3bf3JUnV3t9XLbIG2GvUxodaWD2HUf0IhVzFJxZgDu6cOTntuiwn9BDk239g+OV1
	 B+0ZBSKPVCjlq30XCnFSQlXtC5Q7oCVxHUtIzpi1I3HmWnpCwOJCkTdFbLyz27JO1I
	 ZBjBtQLmabTBg==
Date: Wed, 11 Aug 2021 12:18:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: [PATCH v2.1 19/30] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210811191800.GH3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-20-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-20-hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Rewrite the ->bmap implementation based on iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[djwong: restructure the loop to make its behavior a little clearer]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/fiemap.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index acad09a8c188..66cf267c68ae 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -92,37 +92,32 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
-static loff_t
-iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap, struct iomap *srcmap)
-{
-	sector_t *bno = data, addr;
-
-	if (iomap->type == IOMAP_MAPPED) {
-		addr = (pos - iomap->offset + iomap->addr) >> inode->i_blkbits;
-		*bno = addr;
-	}
-	return 0;
-}
-
 /* legacy ->bmap interface.  0 is the error return (!) */
 sector_t
 iomap_bmap(struct address_space *mapping, sector_t bno,
 		const struct iomap_ops *ops)
 {
-	struct inode *inode = mapping->host;
-	loff_t pos = bno << inode->i_blkbits;
-	unsigned blocksize = i_blocksize(inode);
+	struct iomap_iter iter = {
+		.inode	= mapping->host,
+		.pos	= (loff_t)bno << mapping->host->i_blkbits,
+		.len	= i_blocksize(mapping->host),
+		.flags	= IOMAP_REPORT,
+	};
+	const unsigned int blkshift = mapping->host->i_blkbits - SECTOR_SHIFT;
 	int ret;
 
 	if (filemap_write_and_wait(mapping))
 		return 0;
 
 	bno = 0;
-	ret = iomap_apply(inode, pos, blocksize, 0, ops, &bno,
-			  iomap_bmap_actor);
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
+		if (iter.iomap.type == IOMAP_MAPPED)
+			bno = iomap_sector(&iter.iomap, iter.pos) >> blkshift;
+		/* leave iter.processed unset to abort loop */
+	}
 	if (ret)
 		return 0;
+
 	return bno;
 }
 EXPORT_SYMBOL_GPL(iomap_bmap);

