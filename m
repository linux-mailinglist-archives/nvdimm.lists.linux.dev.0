Return-Path: <nvdimm+bounces-2323-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE4347F73B
	for <lists+linux-nvdimm@lfdr.de>; Sun, 26 Dec 2021 15:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 52D353E0EBF
	for <lists+linux-nvdimm@lfdr.de>; Sun, 26 Dec 2021 14:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EECAE2CAA;
	Sun, 26 Dec 2021 14:35:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D16A2CA0
	for <nvdimm@lists.linux.dev>; Sun, 26 Dec 2021 14:35:11 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3A1XeuS6zo15RuEmLWzzl6t+dcxyrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApDIng2YPyDcXXTuCa6qMZmf2Kd53bNi3/E4EsJfXzYNqHQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9kfF3oTJ9yEmjPjSHOSkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhhc14zs5c85K2U?=
 =?us-ascii?q?hsBMLDOmfgGTl9TFCQW0ahuoeaWfCbk4ZPNp6HBWz62qxl0N2k6NJMZ9s55G2Z?=
 =?us-ascii?q?L8uYSKSxLZReG78q2y7KTS+9inM0vIcDneoQFtRlIwTjfS/RgXpHHR6TD4MRw3?=
 =?us-ascii?q?TEsi8QIFvHbD+IVayVoahvoYBBVPFoTTpUkk4+Agnj5bi0drVe9prQ+6GuVyxZ?=
 =?us-ascii?q?+uJDrLtbUf9miQcROgl3eomPA4nS/DhwEXPSdwDyItHmsm8fIhyrwXI9UH7q9n?=
 =?us-ascii?q?tZugVuO1ikdExEbS1a/iee2h1T4WN9FLUEQvC00osAa8E2tU8m4XBCipnOAlgA?=
 =?us-ascii?q?TVsAWEOAg7gyJjK3O7G6xAmkCUy4EeNI9nNE5SCZs1VKTmd7tQzt1v9Wopdi1n?=
 =?us-ascii?q?luPhWrqf3FLcilZPmlZJTbpKuLL+Okb5i8jhP4+eEJtsuDIJA=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A7DIomaiYtD5HfAR6m/Rs/3Dgg3BQXuYji2hC?=
 =?us-ascii?q?6mlwRA09TyX4rbHLoB1/73LJYVkqNk3I5urrBEDtexLhHP1OkOws1NWZLWrbUQ?=
 =?us-ascii?q?KTRekM0WKI+UyDJ8SRzI5g/JYlW61/Jfm1NlJikPv9iTPSL/8QhPWB74Ck7N2z?=
 =?us-ascii?q?80tQ?=
X-IronPort-AV: E=Sophos;i="5.88,237,1635177600"; 
   d="scan'208";a="119563876"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Dec 2021 22:35:10 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 359634D146EF;
	Sun, 26 Dec 2021 22:35:05 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 26 Dec 2021 22:35:03 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 26 Dec 2021 22:35:03 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v9 05/10] fsdax: fix function description
Date: Sun, 26 Dec 2021 22:34:34 +0800
Message-ID: <20211226143439.3985960-6-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 359634D146EF.A01DC
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

The function name has been changed, so the description should be updated
too.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1f46810d4b68..2ee2d5a525ee 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -390,7 +390,7 @@ static struct page *dax_busy_page(void *entry)
 }
 
 /*
- * dax_lock_mapping_entry - Lock the DAX entry corresponding to a page
+ * dax_lock_page - Lock the DAX entry corresponding to a page
  * @page: The page whose entry we want to lock
  *
  * Context: Process context.
-- 
2.34.1




