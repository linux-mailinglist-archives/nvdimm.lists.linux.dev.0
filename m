Return-Path: <nvdimm+bounces-5528-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 396FD64A9F2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Dec 2022 23:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACEF280AC4
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Dec 2022 22:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D22B7471;
	Mon, 12 Dec 2022 22:07:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE856FD9
	for <nvdimm@lists.linux.dev>; Mon, 12 Dec 2022 22:07:41 +0000 (UTC)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1p4qxO-0002Kj-6x; Mon, 12 Dec 2022 23:07:30 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1p4qxL-0046gk-6A; Mon, 12 Dec 2022 23:07:27 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1p4qxL-004bmJ-0z; Mon, 12 Dec 2022 23:07:27 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: [PATCH] dax/hmem: Drop empty platform remove function
Date: Mon, 12 Dec 2022 23:07:25 +0100
Message-Id: <20221212220725.3778201-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=856; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=YhSbY8UQAb9rmdMMS7pvVmbF98yOuu6f/TXb+2WGuQ0=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjl6YaHW2rk/tgsW4GaYxmNVWIcKWooXeQSyWLnh9Z 1A20dAOJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY5emGgAKCRDB/BR4rcrsCYQDCA CPDrWPIlVVdVE93JwSQ8wVt+l+ykaRkR3RePKpU3+7l9/Ujr0/WgpUjOpny93IKicT/qa00rJ5HIdG EMhUkm76/VazLHwUa70g3COVI7CJBbHrjnkHNLvA+w0HfmbvQKrOjIKYUeWvYrNknCVec1vH66s7OX HZjUD4LREV2hP/lOrLD+W613sdZT5N+6gAbMIX6O9kTMW2V43jQopt7/FEGgEQNgZm3yMK8uBePzbZ QqztW7qRKgh9BrlwmbEXoKECxRJUAEMLognmCFk6mC0l2waQQmn49ISQnKFDooAfReXR2wWA5J3i7P wyWk5thzusgwxqyXHRMD5vNjIWWAuh
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev

A remove callback just returning 0 is equivalent to no remove callback
at all. So drop the useless function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/dax/hmem/hmem.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1bf040dbc834..c7351e0dc8ff 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -44,15 +44,8 @@ static int dax_hmem_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int dax_hmem_remove(struct platform_device *pdev)
-{
-	/* devm handles teardown */
-	return 0;
-}
-
 static struct platform_driver dax_hmem_driver = {
 	.probe = dax_hmem_probe,
-	.remove = dax_hmem_remove,
 	.driver = {
 		.name = "hmem",
 	},

base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
-- 
2.38.1


