Return-Path: <nvdimm+bounces-939-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BDA3F4AC3
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 14:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 944DD3E0FEE
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 12:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935203FCA;
	Mon, 23 Aug 2021 12:37:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF913FC8
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5C7whyWIKeHw98K7S+Dkt3BPS2eO5NS8RnNmkSn5luY=; b=T8y+XflmiyL+1t1HU/mAGh83W5
	LDSRNYJvsbli+/WTIDvmSK/Zz/SQyu4ldfylCSQprkefW+HqVJhWGuzFKLoC2BO/R70t7TRJjd3qg
	qdvi64yD2ZMP+RKhHkOW2vlhL4JCH2+KRpyWbuC6LOn/u6JYjZCvIallAAhcT5eox0e90Y2cP8CuQ
	1AmnzW2lhHG1ioWc26U1Nv9R2EbIyDrodZ+K3k3aEXWRT6LXRiV/nU8q3PBKm+aON3Mjp59eDWjOK
	d30/8OLsVpCsY9UI9sjvx+Zl1Vj6oN6Q7pYxSGxOqCMee8vPYLIOAzlFfGRDam8eFO99yhSBjA03M
	znn6Nt3w==;
Received: from [2001:4bb8:193:fd10:c6e8:3c08:6f8b:cbf0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mI9BD-009j1P-LH; Mon, 23 Aug 2021 12:36:10 +0000
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
Subject: [PATCH 1/9] fsdax: improve the FS_DAX Kconfig description and help text
Date: Mon, 23 Aug 2021 14:35:08 +0200
Message-Id: <20210823123516.969486-2-hch@lst.de>
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

Rename the main option text to clarify it is for file system access,
and add a bit of text that explains how to actually switch a nvdimm
to a fsdax capable state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/Kconfig | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index a7749c126b8e..37e4441119cf 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -43,7 +43,7 @@ source "fs/f2fs/Kconfig"
 source "fs/zonefs/Kconfig"
 
 config FS_DAX
-	bool "Direct Access (DAX) support"
+	bool "File system based Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
 	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
@@ -53,8 +53,19 @@ config FS_DAX
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
 	  then you can avoid using the pagecache to buffer I/Os.  Turning
-	  on this option will compile in support for DAX; you will need to
-	  mount the filesystem using the -o dax option.
+	  on this option will compile in support for DAX.
+
+	  For a DAX device to support file system access it needs to have
+	  struct pages.  For the nfit based NVDIMMs this can be enabled
+	  using the ndctl utility:
+
+		# ndctl create-namespace --force --reconfig=namespace0.0 \
+			--mode=fsdax --map=mem
+
+          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well.
+	  For most file systems DAX support needs to be manually enable
+	  globally or per-inode using a mount option as well.  See the
+	  file system documentation for details.
 
 	  If you do not have a block device that is capable of using this,
 	  or if unsure, say N.  Saying Y will increase the size of the kernel
-- 
2.30.2


