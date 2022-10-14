Return-Path: <nvdimm+bounces-4941-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9A05FF746
	for <lists+linux-nvdimm@lfdr.de>; Sat, 15 Oct 2022 01:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F39B1C2094B
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Oct 2022 23:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0334699;
	Fri, 14 Oct 2022 23:57:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1D94694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791869; x=1697327869;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yd85VDxCtKyxeZdpNqoca3KmUlvyPqntXffUSxCk3NA=;
  b=kyJPVGzG3SPzafZXcdz49PeLxwyOSQJaEmi14Tj+jqk9r3NS1GrdjGPM
   KGVfMAc1WkewcQ6YfeDw6ZAzZ4wW9jTwli5Cxqnwi4V5Vc2DPE5e7FIJB
   m6pdmI8zvV5BFAE9/3Q/Xb9GV4RRUTVeqkIwSyeSGW5r+eEqYq37FYQ5r
   ZTs0mMh/jlZB6bDl+sliabi8wd1h2yRDh8ZoOXgaAyd2OzSyNkBEjHplv
   aFPzN3Pobdf1krXMImbfBxzpjMIyYbgMj+f5eeM/gW/DjsR/i/yp3hQBi
   weIc9ZLKWTPqghP/AcHzHTn7qoTnKXwuxF6zBOG1Z4JA+3yk+mzcZLRFE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="292861981"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="292861981"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:38 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113270"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113270"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:37 -0700
Subject: [PATCH v3 07/25] fsdax: Hold dax lock over mapping insertion
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:37 -0700
Message-ID: <166579185727.2236710.8711235794537270051.stgit@dwillia2-xfh.jf.intel.com>
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

In preparation for dax_insert_entry() to start taking page and pgmap
references ensure that page->pgmap is valid by holding the
dax_read_lock() over both dax_direct_access() and dax_insert_entry().

I.e. the code that wants to elevate the reference count of a pgmap page
from 0 -> 1 must ensure that the pgmap is not exiting and will not start
exiting until the proper references have been taken.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1d4f0072e58d..6990a6e7df9f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1107,10 +1107,9 @@ static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
 		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	int id, rc = 0;
 	long length;
+	int rc = 0;
 
-	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
 				   DAX_ACCESS, kaddr, pfnp);
 	if (length < 0) {
@@ -1135,7 +1134,6 @@ static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
 	if (!*kaddr)
 		rc = -EFAULT;
 out:
-	dax_read_unlock(id);
 	return rc;
 }
 
@@ -1588,7 +1586,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
 	bool write = iter->flags & IOMAP_WRITE;
 	unsigned long entry_flags = pmd ? DAX_PMD : 0;
-	int err = 0;
+	int err = 0, id;
 	pfn_t pfn;
 	void *kaddr;
 
@@ -1608,11 +1606,15 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 		return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
 	}
 
+	id = dax_read_lock();
 	err = dax_iomap_direct_access(iomap, pos, size, &kaddr, &pfn);
-	if (err)
+	if (err) {
+		dax_read_unlock(id);
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
+	}
 
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
+	dax_read_unlock(id);
 
 	if (write &&
 	    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {


