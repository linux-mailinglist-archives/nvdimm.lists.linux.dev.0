Return-Path: <nvdimm+bounces-7862-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33FB2894B55
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Apr 2024 08:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F81E1F2332A
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Apr 2024 06:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40676199A1;
	Tue,  2 Apr 2024 06:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b27jE85r"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24017BBA
	for <nvdimm@lists.linux.dev>; Tue,  2 Apr 2024 06:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712039079; cv=none; b=lmOBZD7gJLscuAdy8Hf9IeaU55/Xsf5fra1HPcUPo+0PJqgHdJO3/XXZ5ZX2t8VCxAn0D6I7P8rnzzDoYbLub3BkBrgzkOJgEUsmf2RAcVnTPLLjs3/mXNkR31N3GH4wKxrSGBF3i0OxV0Pc9GfDd2h3m80k8RPftS6zFjQdiSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712039079; c=relaxed/simple;
	bh=Avcgwic9to73qYuJOM9j0RdxPlc4XVJ76Q8h7Wk8SVw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=TtDMGbAZr3CjqCOrx6IBq8ENGOmL5N1My89aUQj19W/wbdIh/LJcg5JM1GpCBhiWvDEnn2cKYvn/vYGgvCrWpFGdqYwzDfXNRbIb8XZSAvic4Schtjx1B2p1MSR4FvjRgfT9iezeWE1d0v0JyIhVf+6i3svydJ5dc6oclPSTV0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b27jE85r; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712039078; x=1743575078;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=Avcgwic9to73qYuJOM9j0RdxPlc4XVJ76Q8h7Wk8SVw=;
  b=b27jE85rimEtydns06rOqz73TOGE5LtJPzUqoE/vPCCtKBo2WiGkGxLx
   2ljsSdn6hAJvBsEYxhthBE1v1q+X7vCtMe8b/Q9jQeIgtJDXIuy5uKGIT
   DRD/mMPLW7Q4AOnyEN0Z+Rxkk0SwlLv/ETt0sxJbNrHlsqvz0x33AZuXF
   9fdIraWPdS9VlgCKgC/pMCsM0A7t3c/Q4qDRbyGIgN1EEiNEFRlqYuHls
   jDJO9ybt4/Y6jDn089vYA28VzLTZht1noVztDQGmIRJxzZuVZwmtQLEY+
   ztfHQ3YFOQYw1OFo7l35mSS2W1TnZsfagM68Ev6e3YQyZr43E1pwevnqO
   g==;
X-CSE-ConnectionGUID: FvdKfjMyRvOIHaamkMQHeQ==
X-CSE-MsgGUID: iElVvoCcRUOkNRKhaPuFTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7044665"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="7044665"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:24:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="18040555"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.66.53])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:24:37 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 02 Apr 2024 00:24:28 -0600
Subject: [PATCH] dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240402-vv-dax_abi_fixes-v1-1-c3e0fdbafba5@intel.com>
X-B4-Tracking: v=1; b=H4sIAJukC2YC/x3LTQqAIBBA4avIrBNs+iG6SoRMOdZsKhRECO+et
 Px4vBciB+EIs3ohcJIo91XRNgr2k66DtbhqQIO96Q3qlLSjbGkT6yVz1BP5bhu9Rx4I6vYE/kO
 9lrWUD3zE2/hiAAAA
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=5236;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Avcgwic9to73qYuJOM9j0RdxPlc4XVJ76Q8h7Wk8SVw=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGncSxb4pTYHHd8tzN3jmrJ/kapw7kyTslmLJiQqZjJY7
 0t7ztLWUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgIlk3Gf4H8U1qX8DWxHjF+ut
 uqpvupjfJrvse8Wd3n+sUZnz9r+e9wx/5a8v4ZjPGzlToPeKjPel6sxFvMIa529F1DqbCFcka9/
 kAwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In [1], Dan points out that all of the WARN_ON_ONCE() usage in the
referenced patch should be replaced with lockdep_assert_held(_write)().

Replace those, and additionally, replace a couple of other
WARN_ON_ONCE() introduced in the same patch for actual failure
cases (i.e. when acquiring a semaphore fails in a remove / unregister
path) with dev_WARN_ONCE() as is the precedent here.

Recall that previously, unregistration paths was implicitly protected by
overloading the device lock, which the patch in [1] sought to remove.
This meant adding a semaphore acquisition in these unregistration paths.
Since that can fail, and it doesn't make sense to return errors from
these paths, retain the two instances of (now) dev_WARN_ONCE().

Link: https://lore.kernel.org/r/65f0b5ef41817_aa222941a@dwillia2-mobl3.amr.corp.intel.com.notmuch [1]
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 797e1ebff299..d89c8c3b62f7 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -192,7 +192,7 @@ static u64 dev_dax_size(struct dev_dax *dev_dax)
 	u64 size = 0;
 	int i;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held(&dax_dev_rwsem);
 
 	for (i = 0; i < dev_dax->nr_range; i++)
 		size += range_len(&dev_dax->ranges[i].range);
@@ -302,7 +302,7 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 	resource_size_t size = resource_size(&dax_region->res);
 	struct resource *res;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held(&dax_region_rwsem);
 
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
@@ -447,7 +447,7 @@ static void trim_dev_dax_range(struct dev_dax *dev_dax)
 	struct range *range = &dev_dax->ranges[i].range;
 	struct dax_region *dax_region = dev_dax->region;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
 		(unsigned long long)range->start,
 		(unsigned long long)range->end);
@@ -471,6 +471,7 @@ static void __unregister_dev_dax(void *dev)
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	lockdep_assert_held_write(&dax_region_rwsem);
 	kill_dev_dax(dev_dax);
 	device_del(dev);
 	free_dev_dax_ranges(dev_dax);
@@ -482,7 +483,8 @@ static void unregister_dev_dax(void *dev)
 	if (rwsem_is_locked(&dax_region_rwsem))
 		return __unregister_dev_dax(dev);
 
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
+	if (dev_WARN_ONCE(dev, down_write_killable(&dax_region_rwsem) != 0,
+			  "unable to acquire region rwsem\n"))
 		return;
 	__unregister_dev_dax(dev);
 	up_write(&dax_region_rwsem);
@@ -507,7 +509,7 @@ static int __free_dev_dax_id(struct dev_dax *dev_dax)
 	struct dax_region *dax_region;
 	int rc = dev_dax->id;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held_write(&dax_dev_rwsem);
 
 	if (!dev_dax->dyn_id || dev_dax->id < 0)
 		return -1;
@@ -713,7 +715,7 @@ static void __unregister_dax_mapping(void *data)
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
@@ -726,7 +728,8 @@ static void unregister_dax_mapping(void *data)
 	if (rwsem_is_locked(&dax_region_rwsem))
 		return __unregister_dax_mapping(data);
 
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
+	if (dev_WARN_ONCE(data, down_write_killable(&dax_region_rwsem) != 0,
+			  "unable to acquire region rwsem\n"))
 		return;
 	__unregister_dax_mapping(data);
 	up_write(&dax_region_rwsem);
@@ -830,7 +833,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	struct device *dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
 				"region disabled\n"))
@@ -876,7 +879,7 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 	struct resource *alloc;
 	int i, rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	/* handle the seed alloc special case */
 	if (!size) {
@@ -935,7 +938,7 @@ static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *res, r
 	struct device *dev = &dev_dax->dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
 		return -EINVAL;

---
base-commit: 39cd87c4eb2b893354f3b850f916353f2658ae6f
change-id: 20240402-vv-dax_abi_fixes-8af3b6ff2e5a

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


