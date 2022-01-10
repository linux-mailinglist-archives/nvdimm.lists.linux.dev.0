Return-Path: <nvdimm+bounces-2416-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2DE48A20F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 10 Jan 2022 22:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id D01FF3E0F74
	for <lists+linux-nvdimm@lfdr.de>; Mon, 10 Jan 2022 21:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE032CA4;
	Mon, 10 Jan 2022 21:42:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D87173
	for <nvdimm@lists.linux.dev>; Mon, 10 Jan 2022 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=D2CDLhpjsz7o31CCd9ppZAmOhMYse76ti3BtARyxTwo=; b=ZfvzTlxBNw+cAPkCZ0pN//I3lE
	Ly13DkZ5GGFAXytOrGG4ZQHuoea73RT84n84CykknGVi3kw8wtzO7ogUIdy2nTJ5sY527HD/drciM
	h12QJU2pyqle6PZSlBPc50236N3dblSHNZWg08pZqM2ne5TXmmAD9pGnWizd/SMp6O8X823S2leJ7
	v5MQJPFXvgUQFmH62wketZe/oM3UXFGFoRwkk3EYw8AVdHaU1WvQEXcxl3Fo6ZbPOwSkyzIti/FXZ
	tw4dHHiCoanes2d1H5hOTAI7fs7kWw62R/zPFjP+n1ll8kPAkYMy4eY2Y4Pwn6NEe6tDN//it/L2c
	Sdrw6p3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n72Qh-002k3m-Hr; Mon, 10 Jan 2022 21:42:15 +0000
Date: Mon, 10 Jan 2022 21:42:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] iomap for 5.17
Message-ID: <YdyoN7RU/JMOk/lW@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I know these requests usually come from Darrick, and we had intended
that they would come that route.  Between the holidays and various
things which Darrick needed to work on, he asked if I could send the
pull request directly.  There weren't any other iomap patches pending
for this release, which probably also played a role.

There is a conflict between this tree and the nvdimm tree.  We've done
our best to make the resolution easy for you with the last patch in this
series ("Inline __iomap_zero_iter into its caller").  If you'd rather just
resolve the entire conflict yourself, feel free to drop that last patch.

The resolution Stephen has been carrying is here:
https://lore.kernel.org/all/20211224172421.3f009baa@canb.auug.org.au/

The following changes since commit 2585cf9dfaaddf00b069673f27bb3f8530e2039c:

  Linux 5.16-rc5 (2021-12-12 14:53:01 -0800)

are available in the Git repository at:

  git://git.infradead.org/users/willy/linux.git tags/iomap-5.17

for you to fetch changes up to 4d7bd0eb72e5831ddb1288786a96448b48440825:

  iomap: Inline __iomap_zero_iter into its caller (2021-12-21 13:51:08 -0500)

----------------------------------------------------------------
Convert xfs/iomap to use folios

This should be all that is needed for XFS to use large folios.
There is no code in this pull request to create large folios, but
no additional changes should be needed to XFS or iomap once they
are created.

----------------------------------------------------------------
Matthew Wilcox (Oracle) (26):
      block: Add bio_add_folio()
      block: Add bio_for_each_folio_all()
      fs/buffer: Convert __block_write_begin_int() to take a folio
      iomap: Convert to_iomap_page to take a folio
      iomap: Convert iomap_page_create to take a folio
      iomap: Convert iomap_page_release to take a folio
      iomap: Convert iomap_releasepage to use a folio
      iomap: Add iomap_invalidate_folio
      iomap: Pass the iomap_page into iomap_set_range_uptodate
      iomap: Convert bio completions to use folios
      iomap: Use folio offsets instead of page offsets
      iomap: Convert iomap_read_inline_data to take a folio
      iomap: Convert readahead and readpage to use a folio
      iomap: Convert iomap_page_mkwrite to use a folio
      iomap: Allow iomap_write_begin() to be called with the full length
      iomap: Convert __iomap_zero_iter to use a folio
      iomap: Convert iomap_write_begin() and iomap_write_end() to folios
      iomap: Convert iomap_write_end_inline to take a folio
      iomap,xfs: Convert ->discard_page to ->discard_folio
      iomap: Simplify iomap_writepage_map()
      iomap: Simplify iomap_do_writepage()
      iomap: Convert iomap_add_to_ioend() to take a folio
      iomap: Convert iomap_migrate_page() to use folios
      iomap: Support large folios in invalidatepage
      xfs: Support large folios
      iomap: Inline __iomap_zero_iter into its caller

 Documentation/core-api/kernel-api.rst |   1 +
 block/bio.c                           |  22 ++
 fs/buffer.c                           |  23 +-
 fs/internal.h                         |   2 +-
 fs/iomap/buffered-io.c                | 551 +++++++++++++++++-----------------
 fs/xfs/xfs_aops.c                     |  24 +-
 fs/xfs/xfs_icache.c                   |   2 +
 include/linux/bio.h                   |  56 +++-
 include/linux/iomap.h                 |   3 +-
 9 files changed, 389 insertions(+), 295 deletions(-)


