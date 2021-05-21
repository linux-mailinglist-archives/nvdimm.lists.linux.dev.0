Return-Path: <nvdimm+bounces-48-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCE438BEB1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 07:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 772BB1C0F6A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 05:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C56C2BDE;
	Fri, 21 May 2021 05:52:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0E72BCA
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vGGmPVsg0Hwe3PzyV/3vzWDaoNkxLSJwA2Ye8FU/Xsg=; b=IhLQ/YsNSSUaMfPV9LePQHzZG2
	Iy11LbmI1sSm+9idhhzNqC6Gfvduf0n7DD/sJemhA0c1G6gZtAPG+NgPwB14oKpDsHbFSv6wqBGYD
	z9NlRBYO7hqe4boYDX3qNLCP4SbaTEyoaFArMuKVD/E5z3RyTZPfs0Ksre+VjArTMK0OCsTLRsl3e
	k+gZcg+pC3d86mLa4BbUNZHOAO14SQUeiC907RPGSCiihb8QAhmciozca1qxluSs9Fr70l2NacxpU
	YduJVosXj+jsBg92Mla8olP9CbCdZKujA0wBD8gEQetNm/e7QvJTi8aCRsmG8S2/DYpea4hjHjssP
	FETQIesg==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy5C-00GqC1-R7; Fri, 21 May 2021 05:52:27 +0000
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
Subject: [PATCH 21/26] n64cart: convert to blk_alloc_disk
Date: Fri, 21 May 2021 07:51:11 +0200
Message-Id: <20210521055116.1053587-22-hch@lst.de>
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

Convert the n64cart driver to use the blk_alloc_disk helper to simplify
gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/n64cart.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
index 3dae4b631dea..7b4dd10af9ec 100644
--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -132,14 +132,10 @@ static int __init n64cart_probe(struct platform_device *pdev)
 	if (!reg_base)
 		return -EINVAL;
 
-	disk = alloc_disk(0);
+	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
 		return -ENOMEM;
 
-	disk->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!disk->queue)
-		return -ENOMEM;
-
 	disk->first_minor = 0;
 	disk->flags = GENHD_FL_NO_PART_SCAN;
 	disk->fops = &n64cart_fops;
-- 
2.30.2


