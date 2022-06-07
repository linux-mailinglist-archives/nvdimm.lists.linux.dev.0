Return-Path: <nvdimm+bounces-3892-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E92540273
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Jun 2022 17:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 793E52E0A27
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Jun 2022 15:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62972909;
	Tue,  7 Jun 2022 15:31:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5868628FB
	for <nvdimm@lists.linux.dev>; Tue,  7 Jun 2022 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654615910; x=1686151910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x+VtFWdXpux7/W9Qk2tMxPNhs7vkk3dWzPjYVSKAWwY=;
  b=lHAKYIm6ErL44ZM9gh8IWxkhHrKUpmyvQZ+VwHJBnAs9scHUSVuLBh6K
   MdYpANmIgyj1Kr7/kaJJd6sk9DR5JGec1bEtd5A1cLx0altU6SlSa0GZO
   ajgXHdPy7DYkt5YcVQ4XEnERWgwwMsPHUegODalvvZTGviZ3e5K7a4tbr
   HREYBUjqEBuPWk9fzi0qSllDyAhrV4a8DhkmUdNOb1OHwno6opogctDNO
   xE3M2nWmCv0/yHrAWU1pu3FOS/2QUAiayvddFjVYu6u1+bLBjXWgGDQCB
   0dWcdkqbIhSM1F6v3T39Mw+etCIKYMfwXjZf+4Dc0XiRW6BGwoSxYX5iu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="259570048"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="259570048"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 08:25:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="584242600"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jun 2022 08:25:27 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 50040109; Tue,  7 Jun 2022 18:25:30 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] nvdimm/namespace: return uuid_null only once in nd_dev_to_uuid()
Date: Tue,  7 Jun 2022 18:25:25 +0300
Message-Id: <20220607152525.33468-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor nd_dev_to_uuid() in order to make code shorter and cleaner
by joining conditions and hence returning uuid_null only once.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index bf4f5c09d9b1..3dae17c90e8c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -170,15 +170,12 @@ EXPORT_SYMBOL(nvdimm_namespace_disk_name);
 
 const uuid_t *nd_dev_to_uuid(struct device *dev)
 {
-	if (!dev)
-		return &uuid_null;
-
-	if (is_namespace_pmem(dev)) {
+	if (dev && is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
 		return nspm->uuid;
-	} else
-		return &uuid_null;
+	}
+	return &uuid_null;
 }
 EXPORT_SYMBOL(nd_dev_to_uuid);
 
-- 
2.35.1


