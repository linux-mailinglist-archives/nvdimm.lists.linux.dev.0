Return-Path: <nvdimm+bounces-8743-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAC6954CBF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Aug 2024 16:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D33A28A90F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Aug 2024 14:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CACB1C230C;
	Fri, 16 Aug 2024 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jm6TUdBC"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033261BF31A
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 14:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723819472; cv=none; b=bmSM0Euq5DexNQtrs0mqeA1W5cOkudIeIrhVUMfrZ6SjWs3bG03AxTn94unDGYP2wcn8OOFgOc6jGaX9lWHJ6fr6ZgNae6kxTmUY03LvgsKc7LRqIKPD09YyEI1CJShuJQAxzrRQPW35HF+fdfMcM9F0Bdn+N/78+P37MWS/7iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723819472; c=relaxed/simple;
	bh=5VkggrFXyoRX+xFMFtPbi/ymdAmy5/e3QrX+vM16NIA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RmZS6OJPBs9Mk1bMkcENcLtQRhi6ZXRH33D1+YOVXaoEFalplyyzoSF2YvvdhqQs/ssHGaU+J4S7x8gT/VW7KEV6EtVo4Z705UPAaZ/gCJYXmBo9sitNSNp5vUENRmN6kDdONNg4cmDydIdPq/LU80BJIrACi1rHV759xM0IDRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jm6TUdBC; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723819469; x=1755355469;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=5VkggrFXyoRX+xFMFtPbi/ymdAmy5/e3QrX+vM16NIA=;
  b=jm6TUdBC0GItp9/YQ7p1FCrXDiO/jSP4xhLXuSub6hSmdGH+RryPKAJn
   l5zb/CnLmW+SYZdSIrtc2uZQlCxbvQT/l7pg0VhLu051gzvmIc7iHkSlW
   +uDKpAjiR++mDpPWJhLkP7DJZsvZG9Lhhd9K7UqAoaLfbWEeI7Kg+HmlI
   2+Ue+aJsgbrhlHUbnoGhkr/qeiswAsJmEpsuc9HS0f8aYPaJYgaOmnv7U
   UboEB0wMb/+VrafYrDHBRJK6LnEG//r0w5cCHsOYRCl1iIPQGgFAf/qqP
   Q4mMaMazNAaOgf2X1VdZ9wcI5wn9zdq7aQGwQ/eNaRxOy0rBt/cGIONJu
   w==;
X-CSE-ConnectionGUID: bP/ElOpPSgSqw4DZUM6jNg==
X-CSE-MsgGUID: GPrkMiEBQOymbvV9B1+0yw==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="32753029"
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="32753029"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 07:44:28 -0700
X-CSE-ConnectionGUID: Vg0Q0IITTIqDdX72RH4ByQ==
X-CSE-MsgGUID: bk3/DhnPQZexI2ZGDWq3Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="64086939"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.125.111.52])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 07:44:27 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 16 Aug 2024 09:44:11 -0500
Subject: [PATCH v3 03/25] dax: Document dax dev range tuple
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240816-dcd-type2-upstream-v3-3-7c9b96cba6d7@intel.com>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>, 
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1723819455; l=1068;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=5VkggrFXyoRX+xFMFtPbi/ymdAmy5/e3QrX+vM16NIA=;
 b=dqn+/sYA0d6QfVn4nRQItm4pESDvQWH27evpeIYLF1KGTOVYPxe9VXmBocf16Ii4OmSAMPDmt
 8uQeFUdJS+CD52Y782Ei8KPckQ5QkWDIUlj6SgNZu23+JOBJR20M1sa
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

The device DAX structure is being enhanced to track additional DCD
information.

The current range tuple was not fully documented.  Document it prior to
adding information for DC.

Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: move to start of series]
---
 drivers/dax/dax-private.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 446617b73aea..ccde98c3d4e2 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -58,7 +58,10 @@ struct dax_mapping {
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @nr_range: size of @ranges
- * @ranges: resource-span + pgoff tuples for the instance
+ * @ranges: range tuples of memory used
+ * @pgoff: page offset
+ * @range: resource-span
+ * @mapping: device to assist in interrogating the range layout
  */
 struct dev_dax {
 	struct dax_region *region;

-- 
2.45.2


