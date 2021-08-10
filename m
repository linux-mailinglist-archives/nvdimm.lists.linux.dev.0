Return-Path: <nvdimm+bounces-750-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E68F3E3FA0
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E42153E0FE8
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B9D2FB8;
	Mon,  9 Aug 2021 06:15:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1911E17F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=0Nao+RxLA/qmwg3nqZhQDWwDvpu8vEfnXEfqdNUieUA=; b=Uhm+bZQuY34LeUOanFzg+6rGuI
	oLvpTItLzBqgE3VjUPeFEMbTB7xMU8Hs6H8RE1z7s1XqVhemSQvuSWNkUBM56fLycOAQY2k5hXBDs
	DpL1T2f9gWcLDNALgMSVXmRAT/PVZtgXQUy41ARsQlXeM0VAOmatv/FmD9r5Vw/JvMHS8c71mPnhk
	FIyxf6/1XS6qIIp1ffLs26eIrcap5aH1vNTjuFcpFvy2RnTVm+/tRe8ITmlx67a0XLRDv10mZqb9d
	ii+w2627a2yHhLJbOhMlmaQm9RwKgrl1vkLaXDKmjQJIPzAPCzAHkZlM14NMe/5E4k905JBpJnR/S
	j3bmwAgw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyXu-00AgNQ-EZ; Mon, 09 Aug 2021 06:14:07 +0000
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
Subject: [PATCH 02/30] iomap: remove the iomap arguments to ->page_{prepare,done}
Date: Mon,  9 Aug 2021 08:12:16 +0200
Message-Id: <20210809061244.1196573-3-hch@lst.de>
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

These aren't actually used by the only instance implementing the methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/gfs2/bmap.c         | 5 ++---
 fs/iomap/buffered-io.c | 6 +++---
 include/linux/iomap.h  | 5 ++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index ed8b67b2171817..5414c2c3358092 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1002,7 +1002,7 @@ static void gfs2_write_unlock(struct inode *inode)
 }
 
 static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
-				   unsigned len, struct iomap *iomap)
+				   unsigned len)
 {
 	unsigned int blockmask = i_blocksize(inode) - 1;
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1013,8 +1013,7 @@ static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
 }
 
 static void gfs2_iomap_page_done(struct inode *inode, loff_t pos,
-				 unsigned copied, struct page *page,
-				 struct iomap *iomap)
+				 unsigned copied, struct page *page)
 {
 	struct gfs2_trans *tr = current->journal_info;
 	struct gfs2_inode *ip = GFS2_I(inode);
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 586d9d078ce10e..8a7746433bc719 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -615,7 +615,7 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 		return -EINTR;
 
 	if (page_ops && page_ops->page_prepare) {
-		status = page_ops->page_prepare(inode, pos, len, iomap);
+		status = page_ops->page_prepare(inode, pos, len);
 		if (status)
 			return status;
 	}
@@ -648,7 +648,7 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 
 out_no_page:
 	if (page_ops && page_ops->page_done)
-		page_ops->page_done(inode, pos, 0, NULL, iomap);
+		page_ops->page_done(inode, pos, 0, NULL);
 	return status;
 }
 
@@ -724,7 +724,7 @@ static size_t iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	if (old_size < pos)
 		pagecache_isize_extended(inode, old_size, pos);
 	if (page_ops && page_ops->page_done)
-		page_ops->page_done(inode, pos, ret, page, iomap);
+		page_ops->page_done(inode, pos, ret, page);
 	put_page(page);
 
 	if (ret < len)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index b8ec145b2975c1..72696a55c137f1 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -126,10 +126,9 @@ static inline bool iomap_inline_data_valid(struct iomap *iomap)
  * associated page could not be obtained.
  */
 struct iomap_page_ops {
-	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len,
-			struct iomap *iomap);
+	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len);
 	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
-			struct page *page, struct iomap *iomap);
+			struct page *page);
 };
 
 /*
-- 
2.30.2


