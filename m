Return-Path: <nvdimm+bounces-2143-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6885465FFB
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Dec 2021 09:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id AA5403E0F28
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Dec 2021 08:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9872CB7;
	Thu,  2 Dec 2021 08:50:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730132CA6
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 08:50:21 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AdXWASKoSZNmG7pwV+jQyX1vYGzFeBmJzZBIvgKr?=
 =?us-ascii?q?LsJaIsI5as4F+vmAfD2+EaP+MNGv9e9l/bo+3oB8CsZWEm9NgHgE//3w0QiMRo?=
 =?us-ascii?q?6IpJ/zDcB6oYHn6wu4v7a5fx5xHLIGGdajYd1eEzvuWGuWn/SYUOZ2gHOKmUbe?=
 =?us-ascii?q?eYnopHGeIdQ964f5ds79g6mJXqYjha++9kYuaT/z3YDdJ6RYtWo4nw/7rRCdUg?=
 =?us-ascii?q?RjHkGhwUmrSyhx8lAS2e3E9VPrzLEwqRpfyatE88uWSH44vwFwll1418SvBCvv?=
 =?us-ascii?q?9+lr6WkYMBLDPPwmSkWcQUK+n6vRAjnVqlP9la7xHMgEK49mKt4kZJNFlr4G5T?=
 =?us-ascii?q?xw4eKPKg/g1XQRaEj1lIOtN/7qvzX2X6JXDlBSXKiKwqxlpJARsVWECwc57CH9?=
 =?us-ascii?q?P+dQWMjcIaQqJhv7wy7W+IsFsjcQLLc/lJooTt3hsizbDAp4OTZnFBaeM+t5c2?=
 =?us-ascii?q?DY5g9tmHPDCas5fYj1qBDzMYQJIPFg/C58kmuqswH7lfFVwrFOTuLpy5m37zxJ?=
 =?us-ascii?q?427urN8DaEvSMW8lUm0OwomPd43+/BhAcKczZxTebmlquj+nC2yj7RaoVDrSz8?=
 =?us-ascii?q?vMsi1qWrkQXCRsLRR61uvW0lEO6c8xQJlZS+Sc0q6U2skuxQbHVWxy+vW7BvRM?=
 =?us-ascii?q?GXddUO/M15RvLyafO5QudQG8eQVZpbN0gqd9zVTIx/kGGksmvBjF1trCRD3WH+?=
 =?us-ascii?q?d+pQZmaUcQOBTZaI3ZaEk1euJ++yLzfRynnFr5LeJNZRPWocd0o/w23kQ=3D?=
 =?us-ascii?q?=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AcjlupKnfX2IkJjrHdHw2T1GfUgbpDfIQ3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fw9vre+MjzsCWYtN9/Yh8dcK+7UpVoLUm8yXcX2/h1AV7BZniEhI?=
 =?us-ascii?q?LAFugLgrcKqAeQeREWmNQ86Y5QN4B6CPDVSWNxlNvG5mCDeOoI8Z2q97+JiI7l?=
 =?us-ascii?q?o0tQcQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.87,281,1631548800"; 
   d="scan'208";a="118319114"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Dec 2021 16:49:10 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 739B74D13A1C;
	Thu,  2 Dec 2021 16:49:05 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 2 Dec 2021 16:49:07 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 2 Dec 2021 16:49:03 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>
Subject: [PATCH v8 7/9] dax: add dax holder helper for filesystems
Date: Thu, 2 Dec 2021 16:48:54 +0800
Message-ID: <20211202084856.1285285-8-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 739B74D13A1C.A1DDA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Add these helper functions, and export them for filesystem use.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 drivers/dax/super.c | 19 +++++++++++++++++++
 include/linux/dax.h | 15 +++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index a19fcc0a54f3..acbe7078ce4c 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -114,6 +114,25 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off)
 	return dax_dev;
 }
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
+
+void fs_dax_register_holder(struct dax_device *dax_dev, void *holder,
+		const struct dax_holder_operations *ops)
+{
+	dax_set_holder(dax_dev, holder, ops);
+}
+EXPORT_SYMBOL_GPL(fs_dax_register_holder);
+
+void fs_dax_unregister_holder(struct dax_device *dax_dev)
+{
+	dax_set_holder(dax_dev, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(fs_dax_unregister_holder);
+
+void *fs_dax_get_holder(struct dax_device *dax_dev)
+{
+	return dax_get_holder(dax_dev);
+}
+EXPORT_SYMBOL_GPL(fs_dax_get_holder);
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
 enum dax_device_flags {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 500d048d444e..15a0ad4c248d 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -140,6 +140,10 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 	put_dax(dax_dev);
 }
+void fs_dax_register_holder(struct dax_device *dax_dev, void *holder,
+		const struct dax_holder_operations *ops);
+void fs_dax_unregister_holder(struct dax_device *dax_dev);
+void *fs_dax_get_holder(struct dax_device *dax_dev);
 #else
 static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
 {
@@ -156,6 +160,17 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev,
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 }
+static inline void fs_dax_register_holder(struct dax_device *dax_dev,
+		void *holder, const struct dax_holder_operations *ops)
+{
+}
+static inline void fs_dax_unregister_holder(struct dax_device *dax_dev)
+{
+}
+static inline void *fs_dax_get_holder(struct dax_device *dax_dev)
+{
+	return NULL;
+}
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
 #if IS_ENABLED(CONFIG_FS_DAX)
-- 
2.34.0




