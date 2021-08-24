Return-Path: <nvdimm+bounces-970-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 610E63F588E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Aug 2021 08:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 3200E1C0F74
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Aug 2021 06:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0076D3FCB;
	Tue, 24 Aug 2021 06:55:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313FD3FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 06:55:49 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 77C0D68AFE; Tue, 24 Aug 2021 08:55:46 +0200 (CEST)
Date: Tue, 24 Aug 2021 08:55:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/9] fsdax: improve the FS_DAX Kconfig description and
 help text
Message-ID: <20210824065546.GA24465@lst.de>
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-2-hch@lst.de> <CAPcyv4h0QdHi10ngaXtuisxeZ+66wd-oy0F7r9C0FjJmyXBOFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h0QdHi10ngaXtuisxeZ+66wd-oy0F7r9C0FjJmyXBOFg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 23, 2021 at 11:45:52AM -0700, Dan Williams wrote:
> On Mon, Aug 23, 2021 at 5:37 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Rename the main option text to clarify it is for file system access,
> > and add a bit of text that explains how to actually switch a nvdimm
> > to a fsdax capable state.
> >
> 
> Looks good, nice improvement. A couple suggestions below.

Does this looks ok?

---
From c69617137a1e6b67122c871c946e7aa00b03978b Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 23 Aug 2021 10:57:37 +0200
Subject: fsdax: improve the FS_DAX Kconfig description and help text

Rename the main option text to clarify it is for file system access,
and add a bit of text that explains how to actually switch a nvdimm
to a fsdax capable state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/Kconfig | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index a7749c126b8e..bd21535a7620 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -43,7 +43,7 @@ source "fs/f2fs/Kconfig"
 source "fs/zonefs/Kconfig"
 
 config FS_DAX
-	bool "Direct Access (DAX) support"
+	bool "File system based Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
 	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
@@ -53,8 +53,23 @@ config FS_DAX
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
 	  then you can avoid using the pagecache to buffer I/Os.  Turning
-	  on this option will compile in support for DAX; you will need to
-	  mount the filesystem using the -o dax option.
+	  on this option will compile in support for DAX.
+
+	  For a DAX device to support file system access it needs to have
+	  struct pages.  For the nfit based NVDIMMs this can be enabled
+	  using the ndctl utility:
+
+		# ndctl create-namespace --force --reconfig=namespace0.0 \
+			--mode=fsdax --map=mem
+
+	  See the 'create-namespace' man page for details on the overhead of
+	  --map=mem:
+	  https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace
+
+          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
+	  file systems DAX support needs to be manually enabled globally or
+	  per-inode using a mount option as well.  See the file documentation in
+	  Documentation/filesystems/dax.rst for details.
 
 	  If you do not have a block device that is capable of using this,
 	  or if unsure, say N.  Saying Y will increase the size of the kernel
-- 
2.30.2


