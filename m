Return-Path: <nvdimm+bounces-4623-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1209F5AAC95
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Sep 2022 12:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AD1D280C1E
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Sep 2022 10:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10F91869;
	Fri,  2 Sep 2022 10:36:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017FD139C
	for <nvdimm@lists.linux.dev>; Fri,  2 Sep 2022 10:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1662114996; i=@fujitsu.com;
	bh=5IDXemfHxETHCWqCLUiIKux1ffJ8/B2RvV4DalAoB1U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type;
	b=oXBgAJelAtuWWE+9v0Dulxr9fwsWZ+RComPS5JUXjWDfM65xoQlEbfiyisDR8VpnY
	 37sTl4NhadrCRdjPzdjfkJ1yKLBXcpDmn7gLdjsoKsPAcoE2PxjQQ3Cae8DK8sXZEA
	 7YxcFTHtWqIlTRX3J1+bvwkurUgsdvXddPkw0PpXVUfttpAIw3NS9MQEzOZ+ROZBmc
	 Im9vB3WzfXP5MFBJHou/xKVMygn2cPSsCBq12FYdOrZjPthewikg+A+AqkpQZ5bpjQ
	 M+hWHAvMK8EIT40I94/1H7GVw+XDJm151+UUTypfrmOPGLm44bMhu2q+6PibGmqHT5
	 B+smEyLg4gqGQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRWlGSWpSXmKPExsViZ8ORqLvyjmC
  ywcWJehbTp15gtNhy7B6jxeUnfBanJyxistj9+iabxZ69J1ksLu+aw2Zxb81/Votdf3awW6z8
  8YfVgcvj1CIJj80rtDwW73nJ5LFpVSebx6ZPk9g9Xmyeyejx8ektFo/Pm+QCOKJYM/OS8isSW
  DNOrLAquMBRcW5fTAPjD7YuRi4OIYEtjBJ/urtYIJzlTBJLL5xlgnD2MEp8fd3A2MXIycEmoC
  NxYcFfVpCEiMAkRoljN24ygySYBcol9m+8wQZiCwt4SrT232UFsVkEVCQWPDvKAmLzCrhI3Pn
  4HywuIaAgMeXhe7BeTgF7iUXnfzOB2EICdhLfj81jgqgXlDg58wkLxHwJiYMvXgDVcwD1KknM
  7I6HGFMh0Tj9EBOErSZx9dwm5gmMgrOQdM9C0r2AkWkVo3VSUWZ6RkluYmaOrqGBga6hoamus
  ZGuoYWlXmKVbqJeaqlueWpxia6RXmJ5sV5qcbFecWVuck6KXl5qySZGYHSlFCvs3cF4eeVPvU
  OMkhxMSqK8ibcEk4X4kvJTKjMSizPii0pzUosPMcpwcChJ8PKD5ASLUtNTK9Iyc4CRDpOW4OB
  REuENA0nzFhck5hZnpkOkTjHqcqxtOLCXWYglLz8vVUqc9wVIkQBIUUZpHtwIWNK5xCgrJczL
  yMDAIMRTkFqUm1mCKv+KUZyDUUmY9xnIFJ7MvBK4Ta+AjmACOmL6TH6QI0oSEVJSDUxhmXF88
  6IMt6208/x64fYyT+mtJ0TmH4po9fy2aLIyr3bZ9ptn5+/pjqh+mNb1kLXK3uxVq3nC/meXON
  gOzjKa0BShu33F353cL7lLXYNPtqp9mDzxwflLUxbnVibXpt3VyA7m89zh93tp967f7iu/L/t
  bpaN51mfxhyObdRzdFx83bOx/X243QeSlyouLbEG7Ly6Y1Se8xCGlylfAjrP4Mfs8r+xTHztZ
  7nVeb7qQqP6n333DnF8W+yNXKXkujVkV+GChjLby37shwb/azuutunfdv4+9/AK/ocyXMNc9M
  jP7nmfMctAXtVF9od2xn6eFict05sw5j7Oy++eqantu/PJA3u/4e7/rxefPuUsqsRRnJBpqMR
  cVJwIAr4PfWrUDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-20.tower-548.messagelabs.com!1662114985!2086!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 22685 invoked from network); 2 Sep 2022 10:36:25 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-20.tower-548.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 2 Sep 2022 10:36:25 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 5D1FC1001A1;
	Fri,  2 Sep 2022 11:36:25 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 4DFA21001A0;
	Fri,  2 Sep 2022 11:36:25 +0100 (BST)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Fri, 2 Sep 2022 11:36:21 +0100
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v8 0/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Date: Fri, 2 Sep 2022 10:35:58 +0000
Message-ID: <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

Changes since v7:
  1. Add P1 to fix calculation mistake
  2. Add P2 to move drop_pagecache_sb() to super.c for xfs to use
  3. P3: Add invalidate all mappings after sync.
  4. P3: Set offset&len to be start&length of device when it is to be removed.
  5. Rebase on 6.0-rc3 + Darrick's patch[1] + Dan's patch[2].

Changes since v6:
  1. Rebase on 6.0-rc2 and Darrick's patch[1].

[1]: https://lore.kernel.org/linux-xfs/Yv5wIa2crHioYeRr@magnolia/
[2]: https://lore.kernel.org/linux-xfs/166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com/

Shiyang Ruan (3):
  xfs: fix the calculation of length and end
  fs: move drop_pagecache_sb() for others to use
  mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind

 drivers/dax/super.c         |  3 ++-
 fs/drop_caches.c            | 33 ---------------------------------
 fs/super.c                  | 34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_notify_failure.c | 31 +++++++++++++++++++++++++++----
 include/linux/fs.h          |  1 +
 include/linux/mm.h          |  1 +
 6 files changed, 65 insertions(+), 38 deletions(-)

-- 
2.37.2


