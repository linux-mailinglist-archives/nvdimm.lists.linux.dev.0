Return-Path: <nvdimm+bounces-5353-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC53963F3FC
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Dec 2022 16:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C842280C74
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Dec 2022 15:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3A86FDB;
	Thu,  1 Dec 2022 15:32:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B76FD7
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1669908744; i=@fujitsu.com;
	bh=JjMcfKen5VZCgTZ82chMW2jTyW7XOSibUTqR+JCgv6E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type;
	b=F6FPe0vPKYARkkBfBNWIrO2wwURKUo00B4sm6BNbela+9AxFfmRGoOSlGvcFrQMSP
	 K01kod0KmjTn+cAMF3pEGTY82ojdxWbtZHCUnD8CFrRFdWkcBxcn6aaQ6GQO0kumqG
	 EKvV9IzU1ofKXyiv4E7CBOrqJIrLRbTRCn49y3e8wZreGZoRFI4WyrZNgv5VEy7Hxj
	 Y+8QanT4Y7IONz3wvFMIOhgBcQr7BWuiHbkxp1W2dJ7lDVnrzJUrPBoFK9Mf5NvAlb
	 vIeasW7o6qoIxzq7JhCe19OXpTur5cJJ/7+u7w7UYS3EAuk2ilkJXwgelh9SsZ/GXZ
	 6aTte5nKR3aug==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileJIrShJLcpLzFFi42Kxs+HYrMt+siP
  ZYM5MKYs569ewWUyfeoHRYsuxe4wWl5/wWezZe5LF4vKuOWwWu/7sYLdY+eMPqwOHx6lFEh6L
  97xk8ti0qpPN48SM3yweLzbPZPT4vEkugC2KNTMvKb8igTVj6tJTzAU72SsWvNvG1sA4i62Lk
  YtDSGAjo8T0I6+YIZwlTBIfbtxkhXD2MEpcW30KyOHkYBPQkbiw4C+QzcEhIlAtcWspG0iYWS
  BD4viVP8wgtrCAj8TyM8vZQWwWARWJPbcugcV5BVwlJr2fAWZLCChITHn4HszmBIq//LsRrF5
  IwEXievNBqHpBiZMzn7BAzJeQOPjiBTPIWgkBJYmZ3fEQYyokZs1qY4Kw1SSuntvEPIFRcBaS
  7llIuhcwMq1iNCtOLSpLLdI1NNBLKspMzyjJTczM0Uus0k3USy3VLU8tLtE10kssL9ZLLS7WK
  67MTc5J0ctLLdnECIyWlGKVvh2Mb5f90TvEKMnBpCTKq72vI1mILyk/pTIjsTgjvqg0J7X4EK
  MMB4eSBG/KHqCcYFFqempFWmYOMHJh0hIcPEoivHzHgNK8xQWJucWZ6RCpU4y6HGsbDuxlFmL
  Jy89LlRLnDTwOVCQAUpRRmgc3ApZELjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5t22DWgK
  T2ZeCdymV0BHMAEdESnWBnJESSJCSqqBKWaj8/t58aVf9tZ1VN7fe34+u+XZo++0f2yb+Pxi1
  u6ee6LCzVU98kHt4UyNeo37P5qbSvYcZmv80PbuQ9gWUcMLP0Ibz+8tOq3x8PSDXttfy15ov6
  vjXWr9WYrj8O17TGksW3bpekddnvzU7FIzi870Xzs22myedGV5kO2faL4Xu40Wlk/K3PJr4r5
  7k7bdqr2eLqHNE9EpvorNXf/JbO3HEWsrS3+f46/Y13Xxq8PnlQLXGF/VX3bTnMb3ceZ/7onF
  m2W+aD1WVIiZ8k0pw/+ApK5eSHB0zAQFTy6R1zZHpoosyPjAzP2Vf23OtPVn/ASWmmpIveHN1
  jk35c0K8bsqp66pnnx8VeJ+anKa4iwlluKMREMt5qLiRACtlAd/nQMAAA==
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-6.tower-548.messagelabs.com!1669908743!72999!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 24259 invoked from network); 1 Dec 2022 15:32:23 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-6.tower-548.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Dec 2022 15:32:23 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id 1EF7315A;
	Thu,  1 Dec 2022 15:32:23 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id 1233E153;
	Thu,  1 Dec 2022 15:32:23 +0000 (GMT)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Thu, 1 Dec 2022 15:32:19 +0000
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <david@fromorbit.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>
Subject: [PATCH v2 6/8] xfs: use dax ops for zero and truncate in fsdax mode
Date: Thu, 1 Dec 2022 15:32:10 +0000
Message-ID: <1669908730-131-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669908538-55-1-git-send-email-ruansy.fnst@fujitsu.com>
References: <1669908538-55-1-git-send-email-ruansy.fnst@fujitsu.com>
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

Zero and truncate on a dax file may execute CoW.  So use dax ops which
contains end work for CoW.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 881de99766ca..d9401d0300ad 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1370,7 +1370,7 @@ xfs_zero_range(
 
 	if (IS_DAX(inode))
 		return dax_zero_range(inode, pos, len, did_zero,
-				      &xfs_direct_write_iomap_ops);
+				      &xfs_dax_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
 				&xfs_buffered_write_iomap_ops);
 }
@@ -1385,7 +1385,7 @@ xfs_truncate_page(
 
 	if (IS_DAX(inode))
 		return dax_truncate_page(inode, pos, did_zero,
-					&xfs_direct_write_iomap_ops);
+					&xfs_dax_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
 				   &xfs_buffered_write_iomap_ops);
 }
-- 
2.38.1


