Return-Path: <nvdimm+bounces-4741-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5465D5BA533
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 05:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 094381C20970
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 03:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B941D2102;
	Fri, 16 Sep 2022 03:35:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5662B20FB
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299334; x=1694835334;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JMW9u8fUfl6xVouZZpm8FHKzsQjwv8MqqGLA900GgrQ=;
  b=Xuf6d6X+UD9QkxwoTrdhGwNEY5nkE0zeG8RgtOVR+iRm2S2fK2B6sW+h
   vTVMGbUyPoVN9/cmVTb/+z2BuQkZee8JczkIqG7Ff7Y7Q5IeBWkBZUZz+
   278XDmxGX/OO4n7EK0rhct6OYNkQAsYNviEWEPrBKHLpggeoL3AltTG9Q
   BrvM4KtIBzGams+B8hdakgtb0nc/aS6Z/bBF7lB3gspnaXdcTVuN3SGhc
   bvzC8nrHA2FlE4XUwgtpndDndn5/bLNmtdUx79NJ3bBFJth07zgwHQ9s1
   nECNpPi5WqRbOC1ZgnZs6aR671UVYsyM1318+0HJQyGgC6c/2lT6GoJpo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="297624942"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="297624942"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="792961823"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:33 -0700
Subject: [PATCH v2 04/18] ext4: Add ext4_break_layouts() to the inode
 eviction path
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:33 -0700
Message-ID: <166329933305.2786261.13953404062673878108.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for moving DAX pages to be 0-based rather than 1-based
for the idle refcount, the fsdax core wants to have all mappings in a
"zapped" state before truncate. For typical pages this happens naturally
via unmap_mapping_range(), for DAX pages some help is needed to record
this state in the 'struct address_space' of the inode(s) where the page
is mapped.

That "zapped" state is recorded in DAX entries as a side effect of
ext4_break_layouts(). Arrange for it to be called before all truncation
events which already happens for truncate() and PUNCH_HOLE, but not
truncate_inode_pages_final(). Arrange for ext4_break_layouts() before
truncate_inode_pages_final().

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 478ec6bc0935..326269ad3961 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -207,7 +207,11 @@ void ext4_evict_inode(struct inode *inode)
 			jbd2_complete_transaction(journal, commit_tid);
 			filemap_write_and_wait(&inode->i_data);
 		}
+
+		filemap_invalidate_lock(inode->i_mapping);
+		ext4_break_layouts(inode);
 		truncate_inode_pages_final(&inode->i_data);
+		filemap_invalidate_unlock(inode->i_mapping);
 
 		goto no_delete;
 	}
@@ -218,7 +222,11 @@ void ext4_evict_inode(struct inode *inode)
 
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
+
+	filemap_invalidate_lock(inode->i_mapping);
+	ext4_break_layouts(inode);
 	truncate_inode_pages_final(&inode->i_data);
+	filemap_invalidate_unlock(inode->i_mapping);
 
 	/*
 	 * For inodes with journalled data, transaction commit could have


