Return-Path: <nvdimm+bounces-538-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6212C3CD21B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7C3311C0E86
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5515E2FB6;
	Mon, 19 Jul 2021 10:42:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2F729D6
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=IVnh1SP/p9y49gxhVcv0uKCVfDciQP/EepWPo92LCdI=; b=VM29E3hQaGpu3mIuKVBOb81ilP
	4UUlPyD6Q84veOsS9zf2c2xj3W+nGb4Adc44mQnMk5lPRla9xyd5OCpl6z0Y6Wo1QdH9BIIUX6gm+
	dOpmY5lcWJSKPYHgcRy0sra64cxkxVSKv/Tm2bCTVhKYcYtW5dOodOKHjBM45JtGGLdobUtX4W+wu
	E4+cwmAVxfv/AlReoqiPBsUuZZIOofYImNT/SQ8ZVbzUoL1POC5YWHvGtJA2p6XUoEPh894yET49Y
	SOCWjy7CxED+xUJdVjtUwMlrpvEGmNKIwRUxCyhDRHbFr6ohF6Rbp0IrShxo3tIza/zQVTQ7XlH1T
	KqYpE3Iw==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5Qg5-006kgh-NS; Mon, 19 Jul 2021 10:39:34 +0000
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
Subject: [PATCH 05/27] fsdax: mark the iomap argument to dax_iomap_sector as const
Date: Mon, 19 Jul 2021 12:34:58 +0200
Message-Id: <20210719103520.495450-6-hch@lst.de>
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
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index da41f9363568e0..4d63040fd71f56 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1005,7 +1005,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
-- 
2.30.2


