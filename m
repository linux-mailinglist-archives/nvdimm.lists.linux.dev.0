Return-Path: <nvdimm+bounces-1889-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D80D44A939
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:35:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 03CDA3E14C8
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A4E3FF5;
	Tue,  9 Nov 2021 08:34:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2F03FDB
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=MXGD12IFQiPIgRI0Itg3oPg0/PrYJfJKLbGb1AHaSYE=; b=C+VTgBN6OaB4FOKzOMHiXYb6a4
	VmjKp24i3P1aKDD1TpBY2CxvsrcgSghSt+oxTAFu5eG4ePniZcV7WCJQw7KhXb72zja6AMvUVxvda
	+FIF0O7hpA4GXT5t19yMCcELpZIhJbyyjwXodRpfDSGXJAvRt0VyXxOR4WcXqR/Crvkr/XT7jsYo2
	abhLzyJIJbPmMPiMtm2yw9llcYIc6ZH44vOKXXJN1TJ7MtfZGuLIk8WpYxKSYUEuiw1BhlYr7wmx0
	jn1sMrHIH0aCu3T5Y61E5aPOP0iQmm4G5iNp7BE5+Kmbyxo7mKH+1q5iBokUN3oAIIncEgPYnHAIy
	OZWT+MTA==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZf-000s6w-UD; Tue, 09 Nov 2021 08:33:49 +0000
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
	virtualization@lists.linux-foundation.org
Subject: [PATCH 20/29] ext4: cleanup the dax handling in ext4_fill_super
Date: Tue,  9 Nov 2021 09:33:00 +0100
Message-Id: <20211109083309.584081-21-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
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
---
 fs/ext4/super.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb4df43abd76e..b60401bb1c310 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3879,7 +3879,6 @@ static void ext4_setup_csum_trigger(struct super_block *sb,
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
@@ -3910,12 +3909,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if ((data && !orig_data) || !sbi)
 		goto out_free_base;
 
-	sbi->s_daxdev = dax_dev;
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock)
 		goto out_free_base;
 
+	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
 	sb->s_fs_info = sbi;
 	sbi->s_sb = sb;
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
@@ -4300,7 +4299,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	if (dax_dev) {
+	if (sbi->s_daxdev) {
 		if (blocksize == PAGE_SIZE)
 			set_bit(EXT4_FLAGS_BDEV_IS_DAX, &sbi->s_ext4_flags);
 		else
@@ -5096,10 +5095,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
+	fs_put_dax(sbi->s_daxdev );
 out_free_base:
 	kfree(sbi);
 	kfree(orig_data);
-	fs_put_dax(dax_dev);
 	return err ? err : ret;
 }
 
-- 
2.30.2


