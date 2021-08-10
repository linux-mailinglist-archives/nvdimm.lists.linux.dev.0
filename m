Return-Path: <nvdimm+bounces-751-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CC73E3FA6
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 6FD751C0F36
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BBE2FBF;
	Mon,  9 Aug 2021 06:16:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A102FB6
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Wr5j7XIH32W7TXDAP4E3ZO40CXVukSchgwaRL3qYAAQ=; b=MtFhwQ8jmDdNMkJnVtJpsAcaYA
	OTFcbmcENPSWTyZHgy/1lQtWj507dyi8ZZqxxBZiO7noAHoU07UdgUA91+BLQabetZ4+JBhJ0g5uj
	Bk8oTsnYaT8iJ661pe30/HFZt+D2Td7tKCJNHsLFYjdx+7wUo3vARgtLJDIDoHFETw6/O7eeJ9lQl
	f4N6Wuo+gbOawpEaq8wYUvVSU53uzrwJN4p0qHLbvU6HgDWnREPTUoFH+ofVBqpMpmxwBtzLQB94F
	07CMRpMhAwLS7VRJoRRA/0MOd2UkMY0n6r/6SwjynbyUIYtiAhD/fn7E5A4qgemsD4Dd5a9F7AAG4
	WohrYm5w==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyYN-00AgPp-F0; Mon, 09 Aug 2021 06:14:39 +0000
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
Subject: [PATCH 03/30] iomap: mark the iomap argument to iomap_sector const
Date: Mon,  9 Aug 2021 08:12:17 +0200
Message-Id: <20210809061244.1196573-4-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux/iomap.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 72696a55c137f1..8030483331d17f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -91,8 +91,7 @@ struct iomap {
 	const struct iomap_page_ops *page_ops;
 };
 
-static inline sector_t
-iomap_sector(struct iomap *iomap, loff_t pos)
+static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
 }
-- 
2.30.2


