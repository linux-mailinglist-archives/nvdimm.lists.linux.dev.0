Return-Path: <nvdimm+bounces-2203-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21EEC46E2AE
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Dec 2021 07:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2EFCB1C0AD2
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Dec 2021 06:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA262CBB;
	Thu,  9 Dec 2021 06:38:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD9173
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 06:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=e/I3Z/fVcm8ka4/7bniQ5z4YGZD4AAd7c/qW0XirAZ0=; b=i2hlpPdNZAF/hm4qW1s8FKFDEF
	6t7Mpr8ZkJc3YEVm6S/h5xB7Wst5GfUBeGFc+s8+1Uqfls+HOzKeRqeMd1SumX+4QYxwl5N0xpHrB
	nRSX4gsuF2aEn++FK4s7wqTgBswNC5OcT97Ip3IetmDgJgFwGOMUx8akFcn93DPeZ5z/PBikxKIZu
	7Ai7Y6Qf51aB7twOPUE4CWL+s85DVLBRc+gjMbPpmza3WWUlzft52RhVFQYWRG9aXS1BgivWqvYeT
	W8vJ1lEmo6iVbu2v034XT44vZ7eGoqwicAfgdn0c2ORzD1pawsY0Sd+2w9nTJxnwMQgXmB9srFy0L
	/SA4MbRw==;
Received: from [2001:4bb8:180:a1c8:2d0e:135:af53:41f8] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mvD4Y-0096hS-Sr; Thu, 09 Dec 2021 06:38:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Matthew Wilcox <willy@infradead.org>,
	dm-devel@redhat.com,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: [PATCH 2/5] dax: simplify dax_synchronous and set_dax_synchronous
Date: Thu,  9 Dec 2021 07:38:25 +0100
Message-Id: <20211209063828.18944-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211209063828.18944-1-hch@lst.de>
References: <20211209063828.18944-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Remove the pointless wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c |  8 ++++----
 include/linux/dax.h | 12 ++----------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e7152a6c4cc40..e18155f43a635 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -208,17 +208,17 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
 
-bool __dax_synchronous(struct dax_device *dax_dev)
+bool dax_synchronous(struct dax_device *dax_dev)
 {
 	return test_bit(DAXDEV_SYNC, &dax_dev->flags);
 }
-EXPORT_SYMBOL_GPL(__dax_synchronous);
+EXPORT_SYMBOL_GPL(dax_synchronous);
 
-void __set_dax_synchronous(struct dax_device *dax_dev)
+void set_dax_synchronous(struct dax_device *dax_dev)
 {
 	set_bit(DAXDEV_SYNC, &dax_dev->flags);
 }
-EXPORT_SYMBOL_GPL(__set_dax_synchronous);
+EXPORT_SYMBOL_GPL(set_dax_synchronous);
 
 bool dax_alive(struct dax_device *dax_dev)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 87ae4c9b1d65b..3bd1fdb5d5f4b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -48,16 +48,8 @@ void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
-bool __dax_synchronous(struct dax_device *dax_dev);
-static inline bool dax_synchronous(struct dax_device *dax_dev)
-{
-	return  __dax_synchronous(dax_dev);
-}
-void __set_dax_synchronous(struct dax_device *dax_dev);
-static inline void set_dax_synchronous(struct dax_device *dax_dev)
-{
-	__set_dax_synchronous(dax_dev);
-}
+bool dax_synchronous(struct dax_device *dax_dev);
+void set_dax_synchronous(struct dax_device *dax_dev);
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
-- 
2.30.2


