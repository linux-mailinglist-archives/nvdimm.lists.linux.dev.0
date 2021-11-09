Return-Path: <nvdimm+bounces-1891-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DA544A93B
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 14F9E1C1036
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E897A2C9B;
	Tue,  9 Nov 2021 08:34:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145C33FEA
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=brXsiud4Cc0AgfRTr4nbCZuEA3TzdfnPNyojG8VnBfw=; b=b+PYedIIgGjCdMCp9JN/B8B1Fz
	nzGeNiytbR6ImqRNS4vswOWH638cDm5VRSAitO6lGR+yV/I/Mz2iufYPGI1Y1GX1IfNXWO7JHC4ld
	fEzA52mVx4lCysgJIIwa69LyDX4hyeuPdKgbYC8DhqLL6Y8vrE5UVY453IQYCupw9RKT4TsXvf2ce
	j+ewr0bulk+Ez7yJgzAmbWDuIKmcUNTufJ5ljbdNaEC9XUayw1afVZIMZLjhbdRsIoNb6B7m+WiJa
	HgAsWfZs/0KGoArpevAcNfqJzQStr/V52bfoKMqM4fyX+hMXZKusk/jwOEJCnVmIpMa7W4rq6AHIj
	j82xNF8w==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZm-000sAK-3U; Tue, 09 Nov 2021 08:33:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: [PATCH 24/29] xfs: use xfs_direct_write_iomap_ops for DAX zeroing
Date: Tue,  9 Nov 2021 09:33:04 +0100
Message-Id: <20211109083309.584081-25-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

While the buffered write iomap ops do work due to the fact that zeroing
never allocates blocks, the DAX zeroing should use the direct ops just
like actual DAX I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8cef3b68cba78..704292c6ce0c7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1324,7 +1324,7 @@ xfs_zero_range(
 
 	if (IS_DAX(inode))
 		return dax_zero_range(inode, pos, len, did_zero,
-				      &xfs_buffered_write_iomap_ops);
+				      &xfs_direct_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
 				&xfs_buffered_write_iomap_ops);
 }
@@ -1339,7 +1339,7 @@ xfs_truncate_page(
 
 	if (IS_DAX(inode))
 		return dax_truncate_page(inode, pos, did_zero,
-					&xfs_buffered_write_iomap_ops);
+					&xfs_direct_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
 				   &xfs_buffered_write_iomap_ops);
 }
-- 
2.30.2


