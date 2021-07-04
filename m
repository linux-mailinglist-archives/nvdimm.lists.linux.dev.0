Return-Path: <nvdimm+bounces-355-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0CB3BAD38
	for <lists+linux-nvdimm@lfdr.de>; Sun,  4 Jul 2021 15:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 36B691C0E3A
	for <lists+linux-nvdimm@lfdr.de>; Sun,  4 Jul 2021 13:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD762FAD;
	Sun,  4 Jul 2021 13:56:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com [47.88.44.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053C670
	for <nvdimm@lists.linux.dev>; Sun,  4 Jul 2021 13:56:42 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UeeMavo_1625406659;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UeeMavo_1625406659)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 04 Jul 2021 21:51:05 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	nvdimm@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Liu Bo <bo.liu@linux.alibaba.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Liu Jiang <gerry@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [RFC PATCH 0/2] erofs: dio/dax support for non-tailpacking cases
Date: Sun,  4 Jul 2021 21:50:54 +0800
Message-Id: <20210704135056.42723-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This patchset mainly adds preliminary EROFS iomap dio/dax support
for non-tailpacking uncompressed cases.

Direct I/O is useful in certain scenarios for uncompressed files.
For example, double pagecache can be avoid by direct I/O when
loop device is used for uncompressed files containing upper layer
compressed filesystem.

Also, DAX is quite useful for some VM use cases in order to
save guest memory extremely by using the minimal lightweight EROFS.

Tail-packing inline iomap support will be handled later since
currently iomap doesn't support such data pattern, which is
independent to non-tailpacking cases.

Comments are welcome. Thanks for your time on reading this!

Thanks,
Gao Xiang

Gao Xiang (1):
  erofs: dax support for non-tailpacking regular file

Huang Jianan (1):
  erofs: iomap support for non-tailpacking DIO

 fs/erofs/Kconfig    |   1 +
 fs/erofs/data.c     | 143 +++++++++++++++++++++++++++++++++++++++++++-
 fs/erofs/inode.c    |  10 +++-
 fs/erofs/internal.h |   3 +
 fs/erofs/super.c    |  20 ++++++-
 5 files changed, 173 insertions(+), 4 deletions(-)

-- 
2.24.4


