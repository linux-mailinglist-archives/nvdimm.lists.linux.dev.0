Return-Path: <nvdimm+bounces-2205-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFDD46E2B0
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Dec 2021 07:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 0ACE41C0A08
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Dec 2021 06:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3083B2FB2;
	Thu,  9 Dec 2021 06:38:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD8C2CB6
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 06:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FsKxqxdl8RTXcrCs1taUxZX0xPB0YfyR2WAofanQv4c=; b=tzpxlQNVdQARHgzFox9EjzDlBK
	9P+xRXtYPujeFPWYpeurA29pUG8mUzk/k+CsiWYISNnVPI59NE+rItNPJgjpZg0Xx3JLa0GYYmREE
	U83TqGcX5d0wkYMpkNMh6n2Yi19PKjrCihpuwh+hSzjDj48DKutqXSiJegcVKMgKIW4oON55iiGuG
	DucCpb6/XVUxO2AdqunqblMHeGV0z8ZwK355niJbK9AmVZwYlgw+6pevLVykXYDS9I/L6fuXzp97h
	Gpe9msGNLo8vCUCSYqouP8FiqLWO23mfMta22uYbqShgkg4TL1+KUI4oAPkooooZrdJYp/3kINKRi
	PSDwAhBg==;
Received: from [2001:4bb8:180:a1c8:2d0e:135:af53:41f8] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mvD4W-0096hM-8N; Thu, 09 Dec 2021 06:38:29 +0000
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
Subject: devirtualize kernel access to DAX
Date: Thu,  9 Dec 2021 07:38:23 +0100
Message-Id: <20211209063828.18944-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Hi Dan,

this series cleans up a few loose end ends and then removes the
copy_from_iter and copy_to_iter dax_operations methods in favor of
straight calls.

Diffstat:
 drivers/dax/bus.c             |    3 +
 drivers/dax/super.c           |   40 ++++++++++++++-------
 drivers/md/dm-linear.c        |   20 ----------
 drivers/md/dm-log-writes.c    |   80 ------------------------------------------
 drivers/md/dm-stripe.c        |   20 ----------
 drivers/md/dm.c               |   52 ---------------------------
 drivers/nvdimm/pmem.c         |   27 +-------------
 drivers/s390/block/dcssblk.c  |   18 +--------
 fs/dax.c                      |    5 --
 fs/fuse/virtio_fs.c           |   20 +---------
 include/linux/dax.h           |   28 +++-----------
 include/linux/device-mapper.h |    4 --
 include/linux/uio.h           |   20 ----------
 13 files changed, 44 insertions(+), 293 deletions(-)

