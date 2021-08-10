Return-Path: <nvdimm+bounces-752-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 822583E3FAB
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 417F43E0FE8
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DB92FB9;
	Mon,  9 Aug 2021 06:17:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C2429D6
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=D1DrTl7p0ZP9ybZiGeaO0Rt2UyAZRiquLkgdxcnWHpw=; b=hWqyNP4eNGgZKXb5qSQfA/DvDw
	kz82MY+mNhamxb+284ckFoHQcxRRbiyGUQufd6EQeRRPqjEjvc2tMkHmi5t7Xqn5S+x0He8RpvVjV
	1W0Uh+cEcU78qB3VMfJf1dfmZkoZ9f/2SmWcnVBQUDPMLuvz+p3e/X6sa6WGET1mFBQQ2g8HshcpR
	DQJFbC8nZ7XeIU3oW9vdyTkGnwXWjFR8sh4eWdE+68d6lx+JMcJwVrdv9WCEVOKXAe6cjhsqYu5+B
	mPp4HGq0ozDPTEUnAd1KE5aBKXgnwsnNsZw10n8nHGxlT/sCP+ilbvmLyHuYWEQ9jSXoJocW62I72
	Z9+b8O5Q==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyZ1-00AgS0-Tp; Mon, 09 Aug 2021 06:15:37 +0000
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
Subject: [PATCH 04/30] iomap: mark the iomap argument to iomap_inline_data const
Date: Mon,  9 Aug 2021 08:12:18 +0200
Message-Id: <20210809061244.1196573-5-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/iomap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8030483331d17f..560247130357b5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -99,7 +99,7 @@ static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
 /*
  * Returns the inline data pointer for logical offset @pos.
  */
-static inline void *iomap_inline_data(struct iomap *iomap, loff_t pos)
+static inline void *iomap_inline_data(const struct iomap *iomap, loff_t pos)
 {
 	return iomap->inline_data + pos - iomap->offset;
 }
-- 
2.30.2


