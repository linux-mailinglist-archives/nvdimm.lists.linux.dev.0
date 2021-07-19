Return-Path: <nvdimm+bounces-540-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C3E3CD224
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7CA6F1C0F11
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED952FB3;
	Mon, 19 Jul 2021 10:44:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDCF168
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4xDAFG58FBQ6OYFgDPj9OQJz0LEGp6VMc+9ZWmE7SNY=; b=GYC171KoAwX2LD6CcnHWvMY1bO
	HzRaW1BtQkY7c9AVBsdY86AKvkKqiQXfrp+DBRzGZHm0Lg7x9DbTXHM6DkmyCSAHDN8YIDH2b6wYf
	cp59gb3cYVuDD2tH2bB8d5Ervx+L2uFK5vpzVI7duQAbsYojgbajpp7QPmis0ulSgXaISfaqlLsNq
	iru6gpAOGTBntUhboz3VbCXEGYRJ7+x2HCakhCUnsEiet6meL2vS/y/hUBMfd0yLrREfd7ZM4zYdv
	6kYyDbmLGQISsvD6OmG9yoJ9MFQq2lR2ynCujJBR60KaTq9LPX6PzKrcjeB7K+5h32Lm3NZ4+cR9E
	w65R7k9A==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5QiZ-006kqc-Us; Mon, 19 Jul 2021 10:41:57 +0000
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
Subject: [PATCH 07/27] iomap: mark the iomap argument to iomap_read_page_sync const
Date: Mon, 19 Jul 2021 12:35:00 +0200
Message-Id: <20210719103520.495450-8-hch@lst.de>
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

iomap_read_page_sync never modifies the passed in iomap, so mark
it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e47380259cf7e1..8c26cf7cbd72b0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -535,7 +535,7 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 
 static int
 iomap_read_page_sync(loff_t block_start, struct page *page, unsigned poff,
-		unsigned plen, struct iomap *iomap)
+		unsigned plen, const struct iomap *iomap)
 {
 	struct bio_vec bvec;
 	struct bio bio;
-- 
2.30.2


