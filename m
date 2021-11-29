Return-Path: <nvdimm+bounces-2109-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9EB46125C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Nov 2021 11:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 440633E102D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Nov 2021 10:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F722FB2;
	Mon, 29 Nov 2021 10:22:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2DA2C95
	for <nvdimm@lists.linux.dev>; Mon, 29 Nov 2021 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=zD/HXhciUyG9/+3ZZWalAQ9G/73Tl0D4bOXK8TN7K4k=; b=Fey6yeKxtDXlGwd0VBFiu2ErVR
	Zrrmqpwah4nDOKUfTpI5uoTu2Xb3OW5xV9l8MThOhiPP2cGBG3cpMeg1lKXKEaWkM3gZZnGDfanvG
	C2Tr6Slixt1gB6RIbjQyXfT0LV5Ymu9WNwXbsrEzKjMh0eh6CrlBDx2L8cNMhpm/pBYuxglWQO+tn
	MBdBg6SSjViJVclmD8otGLwrqvT1z2DyFgK9S1R5yAFMPEPZX3zrpecK1561osGXb3Xom4wo+gjOs
	JJiAwzHCeo2Gl5bNA6uniryh2Yj2uBxIvkf+fIg/Ht+IaJKVbpkQlBwH/+8ejJETfD2+l61RN8FXa
	pLpb2Tzg==;
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnq-0073SH-3A; Mon, 29 Nov 2021 10:22:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 19/29] ext2: cleanup the dax handling in ext2_fill_super
Date: Mon, 29 Nov 2021 11:21:53 +0100
Message-Id: <20211129102203.2243509-20-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Only call fs_dax_get_by_bdev once the sbi has been allocated and remove
the need for the dax_dev local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/ext2/super.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index a964066a80aa7..7e23482862e69 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -802,7 +802,6 @@ static unsigned long descriptor_loc(struct super_block *sb,
 
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
 	struct buffer_head * bh;
 	struct ext2_sb_info * sbi;
 	struct ext2_super_block * es;
@@ -822,17 +821,17 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		goto failed;
+		return -ENOMEM;
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		goto failed;
+		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
-	sbi->s_daxdev = dax_dev;
+	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
 
 	spin_lock_init(&sbi->s_lock);
 	ret = -EINVAL;
@@ -946,7 +945,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (test_opt(sb, DAX)) {
-		if (!dax_dev) {
+		if (!sbi->s_daxdev) {
 			ext2_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
 			clear_opt(sbi->s_mount_opt, DAX);
@@ -1201,11 +1200,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 failed_mount:
 	brelse(bh);
 failed_sbi:
+	fs_put_dax(sbi->s_daxdev);
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-failed:
-	fs_put_dax(dax_dev);
 	return ret;
 }
 
-- 
2.30.2


