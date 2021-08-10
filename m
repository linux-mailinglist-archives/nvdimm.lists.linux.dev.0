Return-Path: <nvdimm+bounces-757-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5517C3E3FC5
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 80F0C1C05D3
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C012FBF;
	Mon,  9 Aug 2021 06:21:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A13029D6
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=0jwSqDlw705sVTusKaT0PBreeftKviX8VMT3qlT9gus=; b=ojg9OncCLLFCtaLi6ZKutZy9g1
	u6g6geKfouedy2Yx424TC82A4BZU44oZXzxPKRQTcSXeUGiFfv3G64jiSaeaDNSUzb8e1xS9+J3Iv
	z8NMIcWzRGbHjzTZxgCYN9QTy8pfPLQLwFQOMfM4o3UyKRsZDnqMT2csBHlpvtCIoxQ6zckDqjsXO
	GP13KJMydolByv3IgbbWel01mWyBPVXGxAY4Q6VcgbUi1+VbbLJ9dBVe0qeyhCeYhcZbP6w2ep7KP
	PTXPsLRkHkCorvVE679Qh7L6s0jni53prnJJRI17dFM6OfXNSpB2X9f30a77JvQTLIXXzyCIvxviy
	exgUiABg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCydC-00AgmY-9F; Mon, 09 Aug 2021 06:19:38 +0000
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
Subject: [PATCH 09/30] iomap: mark the iomap argument to iomap_read_page_sync const
Date: Mon,  9 Aug 2021 08:12:23 +0200
Message-Id: <20210809061244.1196573-10-hch@lst.de>
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

iomap_read_page_sync never modifies the passed in iomap, so mark
it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index eda8892b8c5741..44587209e6d7c7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -531,7 +531,7 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 
 static int
 iomap_read_page_sync(loff_t block_start, struct page *page, unsigned poff,
-		unsigned plen, struct iomap *iomap)
+		unsigned plen, const struct iomap *iomap)
 {
 	struct bio_vec bvec;
 	struct bio bio;
-- 
2.30.2


