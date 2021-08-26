Return-Path: <nvdimm+bounces-1029-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA033F8997
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 16:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 91B983E10B1
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 14:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A1A3FCB;
	Thu, 26 Aug 2021 14:00:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917F03FC0
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xsgIFzxQcm7/75yk92P3+DjSD9vC4RZ+TXwp6UhKe3M=; b=PNHWaM6ldrtGq8lNZSRanVORBt
	8Qv4vpsL6DawDYhdSMaSDIixgGGOqnS7vZbaODeQl7TMGtGwfmkhQK5HI/b8S31Dw3kPYcKgRvgfm
	3kXNMDS9ze8QxvKaqXR83qnFLvSC/2mp9Cg7tkoBqcEkL3IjxffpYfabLnIVQdi3CeT/PDwcn9awG
	O05RnaeACziZmFROZbx66xe+Fz9Tu+Wg0eOet7QTTfXCKlWOq7zaaXJmXUSRxpgPAhhIyOzi+kBii
	1sC9Tu3QWvG72aElKbplMkpbz8EB7eBwI74mYZ3p1ANgH6zxVnK3c/joyYjxRxlTwNj+Xs8q1O5RC
	wUptimng==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJFt0-00DM9a-1Y; Thu, 26 Aug 2021 13:58:06 +0000
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
Date: Thu, 26 Aug 2021 15:55:04 +0200
Message-Id: <20210826135510.6293-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826135510.6293-1-hch@lst.de>
References: <20210826135510.6293-1-hch@lst.de>
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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


