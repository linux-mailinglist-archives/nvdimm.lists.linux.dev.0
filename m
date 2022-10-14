Return-Path: <nvdimm+bounces-4948-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 115FA5FF752
	for <lists+linux-nvdimm@lfdr.de>; Sat, 15 Oct 2022 01:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31D6B1C2083A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Oct 2022 23:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7A0469E;
	Fri, 14 Oct 2022 23:58:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5E14694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791901; x=1697327901;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K1aq+/q+FuOiZcIjOjX1lseJ32olR7LP6wPKxMz7epE=;
  b=WUuca+n4lMWeTc33xoNsYRrswvGkanVlUZukT2YbO778D+0rXe0Shk81
   u410fbHTDxg+MAfxnveyX1smmVgtLf1jwZbgwKxjbXvPEFaXskxb6anUu
   5LDEG9Jd/iuGiIK9Lcr3WGogpPoCPPyfsSsQ2lFGnLyGe/m7yih1EZ8zh
   19i7nWL906tQP5T0eS/rv+gpthaaXNbgLFfnXAo7TlNkyWOO85LwycTyZ
   f0Ow4g2RvA3ZLAV9o07McjeuKPPxJ1TofWYZoH9F24lRa8MDWXXDlIY9N
   B9vqt7ZHBWUI4bCZrSMSF+2JV1sLqF1U97db0bmTdN/00gX/cS3cYr22l
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="292862078"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="292862078"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113492"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113492"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:20 -0700
Subject: [PATCH v3 14/25] devdax: Fix sparse lock imbalance warning
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: kernel test robot <lkp@intel.com>, david@fromorbit.com, hch@lst.de,
 nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:20 -0700
Message-ID: <166579190012.2236710.846739337067413538.stgit@dwillia2-xfh.jf.intel.com>
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

Annotate dax_read_{lock,unlock} with their locking expectations to fix
this sparse report:

drivers/dax/super.c:45:5: sparse: warning: context imbalance in 'dax_read_lock' - wrong count at exit
drivers/dax/super.c: note: in included file (through include/linux/notifier.h, include/linux/memory_hotplug.h, include/linux/mmzone.h, include/linux/gfp.h, include/linux/mm.h, include/linux/pagemap.h):
./include/linux/srcu.h:189:9: sparse: warning: context imbalance in 'dax_read_unlock' - unexpected unlock

Reported-by: kernel test robot <lkp@intel.com>
Link: http://lore.kernel.org/r/202210091141.cHaQEuCs-lkp@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 4909ad945a49..41342e47662d 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -42,13 +42,13 @@ static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 
-int dax_read_lock(void)
+int dax_read_lock(void) __acquires(&dax_srcu)
 {
 	return srcu_read_lock(&dax_srcu);
 }
 EXPORT_SYMBOL_GPL(dax_read_lock);
 
-void dax_read_unlock(int id)
+void dax_read_unlock(int id) __releases(&dax_srcu)
 {
 	srcu_read_unlock(&dax_srcu, id);
 }


