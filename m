Return-Path: <nvdimm+bounces-941-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5803F4AD5
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 14:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 17B451C0AF3
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 12:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7AD3FCA;
	Mon, 23 Aug 2021 12:39:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B813FC4
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xg5OmsoeQHl0C0xvc3OpoA+4OGNwVNPbjgeIqfQrN10=; b=I3oOCZz6PJ4VfMKrLxQ6YSJ6vt
	1KrjioZ599LLasOm8Cq1/Z2z94LD9RybnhG2oxgposyMo6uTO17CXf3l2yAQRGNzEGkIShZTNsA67
	29GlFapLqspbRCvEyEKmhsRwwSRAKg+eT1KpmKxSJKl4tHBbSvjYfrSXJVeQSGMrmlz2pYmHSYKUM
	imI+214+O1ehqMoACL+8/FBDjIdCPp1HbImf+B6ij8vsJ7PUNfpDrvFiLvlug8kNKKEsth0gIfv5z
	C8XNtolek3RA8EEa02iaaqsH8gRhDn0aE7tP7Fs17raxeFHuYlmI8DQvMnyglL95Eup3u57SQZcru
	d1v43eKg==;
Received: from [2001:4bb8:193:fd10:c6e8:3c08:6f8b:cbf0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mI9CE-009j6D-Vw; Mon, 23 Aug 2021 12:37:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
Date: Mon, 23 Aug 2021 14:35:10 +0200
Message-Id: <20210823123516.969486-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823123516.969486-1-hch@lst.de>
References: <20210823123516.969486-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

There is no point in trying to finding the dax device if the DAX flag is
not set on the queue as none of the users of the device mapper exported
block devices could make use of the DAX capability.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2c5f9e585211..465714341300 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -650,7 +650,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
 	}
 
 	td->dm_dev.bdev = bdev;
-	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev);
 	return 0;
 }
 
-- 
2.30.2


