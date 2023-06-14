Return-Path: <nvdimm+bounces-6093-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB227173A7
	for <lists+linux-nvdimm@lfdr.de>; Wed, 31 May 2023 04:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FBA41C20E1D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 31 May 2023 02:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326481C10;
	Wed, 31 May 2023 02:21:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40E91850
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 02:21:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="120056232"
X-IronPort-AV: E=Sophos;i="6.00,205,1681138800"; 
   d="scan'208";a="120056232"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:19:50 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id ECEBCC68E8
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:47 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 365C6CF7D1
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:47 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 84D0E68957;
	Wed, 31 May 2023 11:19:46 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 4/6] cxl/monitor: always log started message
Date: Wed, 31 May 2023 10:19:34 +0800
Message-Id: <20230531021936.7366-5-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230531021936.7366-1-lizhijian@fujitsu.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27662.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27662.004
X-TMASE-Result: 10--12.232700-10.000000
X-TMASE-MatchedRID: fqEte1jlzl/mh3qTH3T2BBlxrtI3TxRkTfK5j0EZbyt9hFikHEFf1nER
	bS7OZpEDwKkZaLNGSWov47gJfywVWSfB+/OOFhyOTuctSpiuWyUUi4Ehat05499RlPzeVuQQE0o
	8W+GU3zDOG+e9aAIpHqepbdVIZ/l3HxPMjOKY7A/+HHE8LDNSg8RB0bsfrpPIfiAqrjYtFiRAzV
	rWwNWPwOq11iEZvCJi7mcbYkc9NgBKL3Fna1bs1X7cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Tell people monitor is starting rather only daemon mode will log this
message before. It's a minor fix so that whatever stdout or logfile
is specified, people can see a *normal* message.

After this patch
 # cxl monitor
 cxl monitor started.
 ^C
 # cxl monitor -l standard.log
 ^C
 # cat standard.log
 [1684735993.704815571] [818499] cxl monitor started.
 # cxl monitor --daemon -l /var/log/daemon.log
 # cat /var/log/daemon.log
 [1684736075.817150494] [818509] cxl monitor started.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: commit log updated # Dave
---
 cxl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 179646562187..0736483cc50a 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -205,8 +205,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 			err(&monitor, "daemon start failed\n");
 			goto out;
 		}
-		info(&monitor, "cxl monitor daemon started.\n");
 	}
+	info(&monitor, "cxl monitor started.\n");
 
 	rc = monitor_event(ctx);
 
-- 
2.29.2


