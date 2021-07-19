Return-Path: <nvdimm+bounces-536-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB9A3CD215
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 371723E1027
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CE62FB6;
	Mon, 19 Jul 2021 10:39:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4AC29D6
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=3v1eAlXcJTzkiBY7xr6VnHSJGGh1jdArlOsDvTzzCcA=; b=ehISl62Ccvj3pUinsa2VLti8BZ
	HOIbC5bpn+Clu15Tql0whSnHUcr1i7YCsf6il7NCvWpTDyYcyzq96TNlTgz5/vuL/lPHStN67wzbp
	7Tbq4JDqtLh/ukeuElfUbssvdPQm6LUxnnbsRnznFN3O4n6qkslI4Vvtua6xhnXWYmJW4FCW6evBP
	j42vqU4ndgpaGW2dxC+ZrVMporAHbQHGq++jkSvUMtiT9qXwVI3zsIDIBAqzha/SDT+ZOS3NCwbO9
	icqyeCBXIOcPt4hFLZVJ+SifU4LPjhoo+lFHFlDFZ6+sr4HGZLA9Yr8F6b/0PUxOaCFYmMYoJhTb+
	oyy9to0Q==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5Qee-006kbA-Ic; Mon, 19 Jul 2021 10:37:56 +0000
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
Subject: [PATCH 03/27] iomap: mark the iomap argument to iomap_sector const
Date: Mon, 19 Jul 2021 12:34:56 +0200
Message-Id: <20210719103520.495450-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
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
 include/linux/iomap.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 093519d91cc9cc..f9c36df6a3061b 100644
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


