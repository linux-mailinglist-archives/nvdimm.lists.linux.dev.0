Return-Path: <nvdimm+bounces-4947-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 180865FF750
	for <lists+linux-nvdimm@lfdr.de>; Sat, 15 Oct 2022 01:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A31C2280C64
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Oct 2022 23:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0330946A0;
	Fri, 14 Oct 2022 23:58:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4494694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791895; x=1697327895;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OlpG3VRQCEZ3qIcp9NWr5Pa3mRwDZ2m4hWtsSsuZz64=;
  b=e+43mofv2FK9mSM+nxTd4fQoiP2KHF2BCK6ILBTpvhsH2aw1ZoaOiCSB
   3oU0ZnyaHAs65phZpVX2O74Z+ezfsT3dN5JAGOwLUYntQeMEllDntJzot
   bt5B64JH9uDwerJ3nsrnJQALZwk9MESuXNRAkxo0SCOeqEE8dSJO4wyBH
   +h7rR1FSG8ilyh4ENp9rIWcuvxehQVv2SXtUa7tSxfdUhmRt3oWucgpRp
   Sgwpa1N5/bxCK0opkwtwOyy8HbB32EKV+ZKEqdw+2VUBTZ8wvyJKt4NsJ
   xSfF8rCVc9M+QOTKcbipuKW8nX4Iwq7osbn1sywxACw8PurlNViyOCvTQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="306580636"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="306580636"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:15 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113460"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113460"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:14 -0700
Subject: [PATCH v3 13/25] devdax: Minor warning fixups
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: david@fromorbit.com, hch@lst.de, nvdimm@lists.linux.dev,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:14 -0700
Message-ID: <166579189421.2236710.9800883307049200257.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Fix a missing prototype warning for dev_dax_probe(), and fix
dax_holder() comment block format. These are holdover fixes that are now
being addressed as some fsdax infrastructure is being moved into the dax
core.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax-private.h |    1 +
 drivers/dax/super.c       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 1c974b7caae6..202cafd836e8 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -87,6 +87,7 @@ static inline struct dax_mapping *to_dax_mapping(struct device *dev)
 }
 
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
+int dev_dax_probe(struct dev_dax *dev_dax);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline bool dax_align_valid(unsigned long align)
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9b5e2a5eb0ae..4909ad945a49 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(put_dax);
 /**
  * dax_holder() - obtain the holder of a dax device
  * @dax_dev: a dax_device instance
-
+ *
  * Return: the holder's data which represents the holder if registered,
  * otherwize NULL.
  */


