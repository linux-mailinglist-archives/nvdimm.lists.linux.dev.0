Return-Path: <nvdimm+bounces-1026-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D433F8979
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 15:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 720801C0FB2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Aug 2021 13:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F3D3FCB;
	Thu, 26 Aug 2021 13:56:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB1E3FC0
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ARgc5BTNEQt9FG8904QxPv30VGpYKOfYo9r3bA9lDKg=; b=sJcv+fRhJ8wMQ1h4dYWzAjuxP4
	a2W6/6f0CbTXS8adqHIIO+TZwOii8PY1HhPlRupHAjSorxQy7BaG9b/UKABzt9lP9mLnrXon/FsYK
	xNPwIYNqIjGU62SSu7X5dg1mHvYU3dxhARShm6jxkokd3Axzst3u57Ub7xu63PeaInhNUSoNQrZa5
	tOICHTwtZtC5jr6DuVb1fdPUmRcytQhPuPHsV3NPQpK+BuTbIBPfDfHvgeLkzd49XJ+B2y/BfzDWn
	PrCQ2QL6//R3GVtJUozgGCdfQz69TLJJVL4qQftgYNYDdQBsHlqUYCH4F7+daSksRLeagRV0IKXK6
	+FhoZ+nw==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJFqZ-00DM13-72; Thu, 26 Aug 2021 13:55:40 +0000
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
Subject: dax_supported() related cleanups v2
Date: Thu, 26 Aug 2021 15:55:01 +0200
Message-Id: <20210826135510.6293-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series first clarifies how to use fsdax in the Kconfig help a bit,
and then untangles the code path that checks if fsdax is supported.

Changes since v1:
 - improve the FS_DAX Kconfig help text further
 - write a proper commit log for a patch missing it

Diffstat
 drivers/dax/super.c   |  191 +++++++++++++++++++-------------------------------
 drivers/md/dm-table.c |    9 --
 drivers/md/dm.c       |    2 
 fs/Kconfig            |   21 ++++-
 fs/ext2/super.c       |    3 
 fs/ext4/super.c       |    3 
 fs/xfs/xfs_super.c    |   16 +++-
 include/linux/dax.h   |   41 +---------
 8 files changed, 117 insertions(+), 169 deletions(-)

