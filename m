Return-Path: <nvdimm+bounces-5352-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFA763F3F7
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Dec 2022 16:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDD181C209A1
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Dec 2022 15:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339506FDB;
	Thu,  1 Dec 2022 15:31:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D606A6FD7
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1669908714; i=@fujitsu.com;
	bh=DwmuvltIcEZwsFYpJnduqk+5Mi19vbbqL3UVPwHv6IA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type;
	b=GUNhchbEYqDQg5nKnK2Rb676L2BzsMHVeuLJWYylN0YAVcdC5WaLPG63F1J1wspdx
	 N6cJAnil+pVslYr2ehL5kQruHi98wnc0hh06BYGABgka82tbs/oweLkeXMMKmWOvO7
	 DEcUvh5J6ft+cdE53f5IZGJtY5sY8DQtN0+Wc369quLHGMlpzV1kJKRi435C6i349j
	 TDmuMzm5yp0PASL0abVz3SCHiVr7wXq/be0PdmSoOfuaAA3aTzFFRuW+v1Wdqi8Y0R
	 JZeyboJYp7sBt5Y5fZebvdXGqYQ6No414Nqv8ZdmBcItaS0nt1BThkKsuUEBLpU+tO
	 t3K4mpdINYAyg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRWlGSWpSXmKPExsViZ8ORpPvyREe
  ywfLbBhZz1q9hs5g+9QKjxZZj9xgtLj/hs9iz9ySLxeVdc9gsdv3ZwW6x8scfVgcOj1OLJDwW
  73nJ5LFpVSebx4kZv1k8XmyeyejxeZNcAFsUa2ZeUn5FAmvGvkmFBds4K/bOecnSwHiavYuRi
  0NIYCOjRNuBLywQzhImiYOfp7JCOHsYJTb9e8rUxcjJwSagI3FhwV+gBAeHiEC1xK2lbCBhZo
  EMieNX/jCD2MICbhLPWqcwgpSwCKhI3PrgABLmFXCROH9+L1iJhICCxJSH78FsTgFXiZd/N7K
  D2EJANdebDzJD1AtKnJz5hAVivITEwRcvmEFGSggoSczsjocYUyExa1YbE4StJnH13CbmCYyC
  s5B0z0LSvYCRaRWjWXFqUVlqka6RgV5SUWZ6RkluYmaOXmKVbqJeaqlueWpxia6RXmJ5sV5qc
  bFecWVuck6KXl5qySZGYKSkFKtf3MHYueyP3iFGSQ4mJVFe7X0dyUJ8SfkplRmJxRnxRaU5qc
  WHGGU4OJQkeFP2AOUEi1LTUyvSMnOAUQuTluDgURLh5TsGlOYtLkjMLc5Mh0idYlSUEucNPA6
  UEABJZJTmwbXBEsUlRlkpYV5GBgYGIZ6C1KLczBJU+VeM4hyMSsK827YBTeHJzCuBm/4KaDET
  0OJIsTaQxSWJCCmpBibBN2zhWmnfRI8qygql/uz7ksV6dWr5InnZJqVzt1iPbOLynTTV8ceB3
  bcn7Xzt7JZWKtNUf1LINrSO5U5whprO46+u2plf5N48DWi/tdNkyq7yrtrXHbxvV6ydH1KnvK
  vxotuUeXt+p6lKP5WQb8/bJpA9nXNDROrc88XXznm+FzEL00qIPcE3N2LxrtvLfe0F979au1N
  IVniC6sQjhl2Nsuq7v3ja1Lq+sFL07FdQuHdTeLFC+Md3hfsPe64+X3O38se5xptmex8dZTeQ
  0zbla7JMOaadVBn4JPnNXb+O+TVBxXaytX0TdfxMJrcl9jvsLO5fVDTpmuN9r4ff9JcnxnOIy
  Yck/K/h+28zV4mlOCPRUIu5qDgRAJTqiO2PAwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-13.tower-565.messagelabs.com!1669908713!237383!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21145 invoked from network); 1 Dec 2022 15:31:53 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-13.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Dec 2022 15:31:53 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id 723ED1B5;
	Thu,  1 Dec 2022 15:31:53 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 65B421B6;
	Thu,  1 Dec 2022 15:31:53 +0000 (GMT)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Thu, 1 Dec 2022 15:31:50 +0000
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <david@fromorbit.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>
Subject: [PATCH v2 5/8] fsdax: dedupe: iter two files at the same time
Date: Thu, 1 Dec 2022 15:31:41 +0000
Message-ID: <1669908701-93-1-git-send-email-ruansy.fnst@fujitsu.com>
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

The iomap_iter() on a range of one file may loop more than once.  In
this case, the inner dst_iter can update its iomap but the outer
src_iter can't.  This may cause the wrong remapping in filesystem.  Let
them called at the same time.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f1eb59bee0b5..354be56750c2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1964,15 +1964,15 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		.len		= len,
 		.flags		= IOMAP_DAX,
 	};
-	int ret;
+	int ret, compared = 0;
 
-	while ((ret = iomap_iter(&src_iter, ops)) > 0) {
-		while ((ret = iomap_iter(&dst_iter, ops)) > 0) {
-			dst_iter.processed = dax_range_compare_iter(&src_iter,
-						&dst_iter, len, same);
-		}
-		if (ret <= 0)
-			src_iter.processed = ret;
+	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
+	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
+		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
+						  same);
+		if (compared < 0)
+			return ret;
+		src_iter.processed = dst_iter.processed = compared;
 	}
 	return ret;
 }
-- 
2.38.1


