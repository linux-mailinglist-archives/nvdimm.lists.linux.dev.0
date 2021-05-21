Return-Path: <nvdimm+bounces-33-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F0638BE3D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D2F7C1C0E5A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E746D36;
	Fri, 21 May 2021 05:52:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2876D1A
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9gxzUTksSCPmzNu3uikLvND31EJ5aydX0p4jRS3yWUM=; b=hQ935sAL5428xOK5g3d57WQyEz
	nh68qg6eMmErNuHz/MRa0ELXgEszKLPVM31ef3SugWspRAaNYnPTPGax6lAf9hW5umji1yI9L0r9q
	zqB9wajpkl4QOrF5LKPCE5QHEs3C8NFjfTJoLe1kqUzFDFr5Wkf1bzleebN141ybNQ7ct85qIw46U
	SZWrAsyFjKaGWQagXOdQM2MsN5rkD0C9nKWtwK8XCfXJh6IfaHEW/ltD4Rgh6KNlYzOMlOn3j1x0U
	I4AtrUAheMMI1zVQMhZG72WLBfzFTPQS89jlunzjjceu3/rS5fqmFLNZ2NCs6uRTOpVd4bqw95DTy
	QjJuMyyA==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4N-00Gpy6-5p; Fri, 21 May 2021 05:51:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>,
	Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>,
	Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-block@vger.kernel.org,
	dm-devel@redhat.com,
	linux-m68k@lists.linux-m68k.org,
	linux-xtensa@linux-xtensa.org,
	drbd-dev@lists.linbit.com,
	linuxppc-dev@lists.ozlabs.org,
	linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [PATCH 05/26] block: add blk_alloc_disk and blk_cleanup_disk APIs
Date: Fri, 21 May 2021 07:50:55 +0200
Message-Id: <20210521055116.1053587-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add two new APIs to allocate and free a gendisk including the
request_queue for use with BIO based drivers.  This is to avoid
boilerplate code in drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 35 +++++++++++++++++++++++++++++++++++
 include/linux/genhd.h | 22 ++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index e4974af3d729..6d4ce962866d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1302,6 +1302,25 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 }
 EXPORT_SYMBOL(__alloc_disk_node);
 
+struct gendisk *__blk_alloc_disk(int node)
+{
+	struct request_queue *q;
+	struct gendisk *disk;
+
+	q = blk_alloc_queue(node);
+	if (!q)
+		return NULL;
+
+	disk = __alloc_disk_node(0, node);
+	if (!disk) {
+		blk_cleanup_queue(q);
+		return NULL;
+	}
+	disk->queue = q;
+	return disk;
+}
+EXPORT_SYMBOL(__blk_alloc_disk);
+
 /**
  * put_disk - decrements the gendisk refcount
  * @disk: the struct gendisk to decrement the refcount for
@@ -1319,6 +1338,22 @@ void put_disk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(put_disk);
 
+/**
+ * blk_cleanup_disk - shutdown a gendisk allocated by blk_alloc_disk
+ * @disk: gendisk to shutdown
+ *
+ * Mark the queue hanging off @disk DYING, drain all pending requests, then mark
+ * the queue DEAD, destroy and put it and the gendisk structure.
+ *
+ * Context: can sleep
+ */
+void blk_cleanup_disk(struct gendisk *disk)
+{
+	blk_cleanup_queue(disk->queue);
+	put_disk(disk);
+}
+EXPORT_SYMBOL(blk_cleanup_disk);
+
 static void set_disk_ro_uevent(struct gendisk *gd, int ro)
 {
 	char event[] = "DISK_RO=1";
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a5443f0b139d..03aa12730634 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -278,6 +278,28 @@ extern void put_disk(struct gendisk *disk);
 
 #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
 
+/**
+ * blk_alloc_disk - allocate a gendisk structure
+ * @node_id: numa node to allocate on
+ *
+ * Allocate and pre-initialize a gendisk structure for use with BIO based
+ * drivers.
+ *
+ * Context: can sleep
+ */
+#define blk_alloc_disk(node_id)						\
+({									\
+	struct gendisk *__disk = __blk_alloc_disk(node_id);		\
+	static struct lock_class_key __key;				\
+									\
+	if (__disk)							\
+		lockdep_init_map(&__disk->lockdep_map,			\
+			"(bio completion)", &__key, 0);			\
+	__disk;								\
+})
+struct gendisk *__blk_alloc_disk(int node);
+void blk_cleanup_disk(struct gendisk *disk);
+
 int __register_blkdev(unsigned int major, const char *name,
 		void (*probe)(dev_t devt));
 #define register_blkdev(major, name) \
-- 
2.30.2


