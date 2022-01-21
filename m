Return-Path: <nvdimm+bounces-2527-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id BE45D495A7D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 Jan 2022 08:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 6FE363E0E66
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 Jan 2022 07:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18422CA9;
	Fri, 21 Jan 2022 07:16:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE0929CA
	for <nvdimm@lists.linux.dev>; Fri, 21 Jan 2022 07:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sww/wwaWy03hlZ/EaFDFfo+1Npwvs31lVzyDCnqKm+M=; b=3z9uw5j+S2pf6nD2ooQW91WtxK
	aPSDnO2M+uQJBElEk9lMsC/znXs6RQZ6CJhLkqIX0Iu9skcFdAY+ejjQCQyV/feQLF6NPePEK3nVR
	yBYKmHkRI/ytKK50oeZOBQQZJsGHb9Fyni/SDutvloNOoHUSGtQWStctL2Cmrw4ER5WnVDqZolW4G
	jDUhKW0OAwKdvwZIOp2Wlc0EK/QsfKDkbxW1gbf+VRxbSNt+YBfz54NvNhNFMzeX8OilBhT4XCMZt
	5P7RkYEOjRPDUpOG8w2WElZiTVMC9hv/8WWSQIRDecZcHs4YOP4XvDyiiTJEZSq71XQvOKhYbCfIT
	KmYItTGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nAo9l-00E2By-OP; Fri, 21 Jan 2022 07:16:21 +0000
Date: Thu, 20 Jan 2022 23:16:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, dan.j.williams@intel.com, david@fromorbit.com,
	jane.chu@oracle.com
Subject: Re: [PATCH v9 10/10] fsdax: set a CoW flag when associate reflink
 mappings
Message-ID: <YepdxZ+XrAZYv1dX@infradead.org>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-11-ruansy.fnst@fujitsu.com>
 <YekkYAJ+QegoDKCJ@infradead.org>
 <70a24c20-d7ee-064c-e863-9f012422a2f5@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70a24c20-d7ee-064c-e863-9f012422a2f5@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 21, 2022 at 10:33:58AM +0800, Shiyang Ruan wrote:
> > 
> > But different question, how does this not conflict with:
> > 
> > #define PAGE_MAPPING_ANON       0x1
> > 
> > in page-flags.h?
> 
> Now we are treating dax pages, so I think its flags should be different from
> normal page.  In another word, PAGE_MAPPING_ANON is a flag of rmap mechanism
> for normal page, it doesn't work for dax page.  And now, we have dax rmap
> for dax page.  So, I think this two kinds of flags are supposed to be used
> in different mechanisms and won't conflect.

It just needs someone to use folio_test_anon in a place where a DAX
folio can be passed.  This probably should not happen, but we need to
clearly document that.

> > Either way I think this flag should move to page-flags.h and be
> > integrated with the PAGE_MAPPING_FLAGS infrastucture.
> 
> And that's why I keep them in this dax.c file.

But that does not integrate it with the infrastructure.  For people
to debug things it needs to be next to PAGE_MAPPING_ANON and have
documentation explaining why they are exclusive.

