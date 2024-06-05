Return-Path: <nvdimm+bounces-8097-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A27D8FC371
	for <lists+linux-nvdimm@lfdr.de>; Wed,  5 Jun 2024 08:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 255FB2820E2
	for <lists+linux-nvdimm@lfdr.de>; Wed,  5 Jun 2024 06:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F653DABF4;
	Wed,  5 Jun 2024 06:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oc+9qpf3"
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABEC61FE9;
	Wed,  5 Jun 2024 06:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569046; cv=none; b=ROC4Q/6RscyEqbOH2hHI8Inzas6y+AIIa8MnMCs6R3EQwtSD1WeWEjIFjrWootA/dkELHHghgmR5MSGyVe5wF+SSbRG8irdrNnhQjevC6k/B+t23n43rNKqvZTl8C80UC8aA97pxlvs+8E9aXD6GIwPil5+mys/bTaFRtYGHbUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569046; c=relaxed/simple;
	bh=qyAVkiwtWWdjBxmiE/fAs6E5PXT1YTmGgBCse0NKDA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u0T/6yw+0u32vgl4wBsBYQ7A0x4/A0GcPxnYl49lC6/TXyQnwi6d91uiTBJB4E3D7tTNvXkutt7je5yUlumJhKp11AYtNCkT4sdYrrE4gquZbDPr0cNt2WX+XVuRqk1rc+o977+o+yH5iRekLh/2o3NlPesoSW4mim30fpwGsyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oc+9qpf3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gaIx1WxRLwp7xMDbfUYp9Y8Ppe/7l8SW7mt5TiBUriI=; b=oc+9qpf3k+s4JvfTt1JTU81fRo
	4PtUqPs3+ADC+zZHpsNI0gFNlpcT3d99PKR5wuhT+/8W516isssYtQ0UcJZQrlZEnxMSrOYAhxo7u
	M1PgIpDm/49EJ+xtSPzJhliepwEblxWopoLIHSbO7Emp6z55cFKDvPBOd80TfoSD18VvW3YvryOId
	bW5hAAmyWx5t+uciabUvCOpg7IQ1e3U5d7w2+9TgAL8uy2+Lg43TSpp5RnE5/+xWhVtouYsvWV7tq
	ugKWiZxjuo3z+euO1ALzjymCx54ER2BNlbTcC1aWE0RBrY/9EvxkA6X0veDu/pGxf0RRQH7ekf2td
	osDwJbnA==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAM-00000004mUX-27zr;
	Wed, 05 Jun 2024 06:30:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: move integrity settings to queue_limits
Date: Wed,  5 Jun 2024 08:28:29 +0200
Message-ID: <20240605063031.3286655-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens, hi Martin,

this series converts the blk-integrity settings to sit in the queue
limits and be updated through the atomic queue limits API.

I've mostly tested this with nvme, scsi is only covered by simple
scsi_debug based tests.

For MD I found an pre-existing error handling bug when combining PI
capable devices with not PI capable devices.  The fix was posted here
(and is included in the git branch below):

   https://lore.kernel.org/linux-raid/20240604172607.3185916-1-hch@lst.de/

For dm-integrity my testing showed that even the baseline fails to create
the luks-based dm-crypto with dm-integrity backing for the authentication
data.  As the failure is non-fatal I've not addressed it here.

Note that the support for native metadata in dm-crypt by Mikulas will
need a rebase on top of this, but as it already requires another
block layer patch and the changes in this series will simplify it a bit
I hope that is ok.

The series is based on top of my previously sent "convert the SCSI ULDs
to the atomic queue limits API v2" API.

A git tree is available here:

   git://git.infradead.org/users/hch/block.git block-integrity-limits

Gitweb:

   http://git.infradead.org/?p=users/hch/block.git;a=shortlog;h=refs/heads/block-integrity-limits

Diffstat:
 Documentation/block/data-integrity.rst |   49 ------
 block/Kconfig                          |    8 -
 block/Makefile                         |    3 
 block/bio-integrity.c                  |   36 ++---
 block/blk-integrity.c                  |  232 +++++++++-----------------------
 block/blk-mq.c                         |   13 -
 block/blk-settings.c                   |  118 +++++++++++++++-
 block/blk.h                            |    8 +
 block/t10-pi.c                         |  236 ++++++++++-----------------------
 drivers/md/dm-core.h                   |    1 
 drivers/md/dm-crypt.c                  |    4 
 drivers/md/dm-integrity.c              |   47 +-----
 drivers/md/dm-table.c                  |  161 +++-------------------
 drivers/md/md.c                        |   72 ++--------
 drivers/md/md.h                        |    5 
 drivers/md/raid0.c                     |    7 
 drivers/md/raid1.c                     |   10 -
 drivers/md/raid10.c                    |   10 -
 drivers/md/raid5.c                     |    2 
 drivers/nvdimm/btt.c                   |   13 -
 drivers/nvme/host/Kconfig              |    1 
 drivers/nvme/host/core.c               |   71 +++++----
 drivers/nvme/host/multipath.c          |    3 
 drivers/nvme/target/Kconfig            |    1 
 drivers/nvme/target/io-cmd-bdev.c      |   16 +-
 drivers/scsi/Kconfig                   |    1 
 drivers/scsi/sd.c                      |   28 +--
 drivers/scsi/sd.h                      |   12 -
 drivers/scsi/sd_dif.c                  |   48 ++----
 drivers/target/target_core_iblock.c    |   49 +++---
 include/linux/bio.h                    |    7 
 include/linux/blk-integrity.h          |   74 ++++------
 include/linux/blkdev.h                 |   19 +-
 include/linux/t10-pi.h                 |   20 --
 34 files changed, 524 insertions(+), 861 deletions(-)

