Return-Path: <nvdimm+bounces-5229-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D62B637C17
	for <lists+linux-nvdimm@lfdr.de>; Thu, 24 Nov 2022 15:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0659E280A7E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 24 Nov 2022 14:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DE3291C;
	Thu, 24 Nov 2022 14:55:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601E12585
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1669301711; i=@fujitsu.com;
	bh=alQ7R5Jh0NErV3HrxzICAC/+0mUOPP9X/aFaPsHC9FA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=FLsiwZGfCHP45lQpVpgj6eO4NpEeQgX9uPYR97QjHyJ5ijI+t2qWitMp4oPx8cWQ9
	 D7GNOe11wh9E4pAw5dMsmHAZe8FcbNfU9XQo/Cyn7+Fr6L8onY9A7+2xc5VmfTihua
	 uhDeiNt52ackZGCTBCzl3iHQlpHJIZIkZWDknRUPVmzdCmyM3ykPmSLx+M103Egb9G
	 SM6IBsbOxg5JDvO9RWJnGZhFyQU40Th3w7798NQRN6d2xfrLIQPawKhJDdkDDC0aq1
	 VknjI7wEnzfkG8QwmPSHJckUsgx7KygMZZngVfOWissO0FlB+0r7TuaSE55e6f6aLN
	 +DcT1/B2a02Kg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRWlGSWpSXmKPExsViZ8ORpHu+tT7
  ZYEMTp8X0qRcYLbYcu8docfkJn8WevSdZLC7vmsNmsevPDnaLlT/+sDqwe5xaJOGxeM9LJo9N
  qzrZPF5snsno8XmTXABrFGtmXlJ+RQJrxq4b7AXfOCturNzO2sDYwdHFyMUhJLCRUWLq+eeME
  M4SJok/G95AOXsZJSY8/s7axcjJwSagI3FhwV8gm4NDRKBa4tZSNpAws4CXxNrXG5hBbGEBE4
  lNa2aC2SwCqhLTV30Hs3kFXCQ+Xp3BBGJLCChITHn4HiouKHFy5hMWiDkSEgdfvGAGGS8hoCQ
  xszseorxCYtasNqhWNYmr5zYxT2Dkn4WkexaS7gWMTKsYzYpTi8pSi3QNzfSSijLTM0pyEzNz
  9BKrdBP1Ukt1y1OLS3SN9BLLi/VSi4v1iitzk3NS9PJSSzYxAsM8pVhx6w7GG8v+6B1ilORgU
  hLlvZVTnyzEl5SfUpmRWJwRX1Sak1p8iFGGg0NJgtejHignWJSanlqRlpkDjDmYtAQHj5IIr3
  s5UJq3uCAxtzgzHSJ1itGYY23Dgb3MHJP+XNvLLMSSl5+XKiXO+7IJqFQApDSjNA9uECwVXGK
  UlRLmZWRgYBDiKUgtys0sQZV/xSjOwagkzKvRAjSFJzOvBG7fK6BTmIBOeapTB3JKSSJCSqqB
  6Shj+s97PB/L3Vev+1p0PC3pW5py+qmkd7OrL1qVvz0lO6m4brt+7FH3fNbUL6pb79+cwvp1R
  /qquOeOmy0fu2zZafxbPTUn7UThTa6GK39v6a28cDkmLKvh7Q+vs1s4b957YPvUymD39gQJpS
  SxB/aHLM+05xu3lgnWLv3j//uUuZufE+/Kbb/9DmUfZvpg63jh0Upd8+cpF93cJfh6ghZKbVA
  Xkaj0fH74+L5a+8cn9jY27G5PWcq/3+hJ4/k1ifOn2c5xdLoUNCNqv/3VszmO89bcXdCQJLgr
  rOesSUOFRNPZ2KTlSqZtG3IOLbB/EtsscE02gH1O+oWJ64sV68v/ZelzaKX/MJv2cG5WmxJLc
  UaioRZzUXEiAPCOJaKAAwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-16.tower-565.messagelabs.com!1669301710!39516!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16235 invoked from network); 24 Nov 2022 14:55:11 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-16.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 24 Nov 2022 14:55:11 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id C9C411AE;
	Thu, 24 Nov 2022 14:55:10 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id BE7F41AD;
	Thu, 24 Nov 2022 14:55:10 +0000 (GMT)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 24 Nov 2022 14:55:07 +0000
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <david@fromorbit.com>, <dan.j.williams@intel.com>
Subject: [PATCH 0/2] fsdax,xfs: fix warning messages
Date: Thu, 24 Nov 2022 14:54:52 +0000
Message-ID: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP

Many testcases failed in dax+reflink mode with warning message in dmesg.
This also effects dax+noreflink mode if we run the test after a
dax+reflink test.  So, the most urgent thing is solving the warning
messages.

Patch 1 fixes some mistakes and adds handling of CoW cases not
previously considered (srcmap is HOLE or UNWRITTEN).
Patch 2 adds the implementation of unshare for fsdax.

With these fixes, most warning messages in dax_associate_entry() are
gone.  But honestly, generic/388 will randomly failed with the warning.
The case shutdown the xfs when fsstress is running, and do it for many
times.  I think the reason is that dax pages in use are not able to be
invalidated in time when fs is shutdown.  The next time dax page to be
associated, it still remains the mapping value set last time.  I'll keep
on solving it.

The warning message in dax_writeback_one() can also be fixed because of
the dax unshare.


Shiyang Ruan (2):
  fsdax,xfs: fix warning messages at dax_[dis]associate_entry()
  fsdax,xfs: port unshare to fsdax

 fs/dax.c             | 166 ++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_iomap.c   |   6 +-
 fs/xfs/xfs_reflink.c |   8 ++-
 include/linux/dax.h  |   2 +
 4 files changed, 129 insertions(+), 53 deletions(-)

-- 
2.38.1


