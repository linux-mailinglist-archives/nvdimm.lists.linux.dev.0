Return-Path: <nvdimm+bounces-2771-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4224A66C7
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 22:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 9F1EF1C0BDE
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 21:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C7D2CA1;
	Tue,  1 Feb 2022 21:04:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F82F27
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 21:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KkpyPZF9boWkW2C3+gaN7IFNLv6yOkPRKRtBS9SK16U=; b=ZNs211dcxa+SVltpBuL6iy9T/4
	CUXhbiS46KQ0D5YIcD1Lz3PnMwgkP56pFexGfL1tVvPrP0irHxJOt5MEDbRH/lGgpB4hVpC/GY+7g
	gy/pFuMz/TOxJHN67i/pZPgwmMSfiPbrUmo7tobxqr3QZ8CGfA7sS+Y9ZI0JfBhu5l0aL+i+iHnfs
	5VW6IaBsdRwsHpnN5fabQhpoHLB5nOaKSeVW/kogT7BY0iKOID7MpDdzGaAzbWOGSAGS3eVFIV/0g
	Cy2dvYYFqiVJyw4sWt5J0atMatSR95LG/M38OYJ1/bLw3z9nQ7iW+6kCewMpAgpIkQQJliER0oKj5
	+dN7KYwA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nF0Jb-00D6Pa-6l; Tue, 01 Feb 2022 21:03:51 +0000
Date: Tue, 1 Feb 2022 21:03:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v10 2/9] mm: factor helpers for memory_failure_dev_pagemap
Message-ID: <YfmgNyG3mfxD/3nS@casper.infradead.org>
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-3-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127124058.1172422-3-ruansy.fnst@fujitsu.com>

On Thu, Jan 27, 2022 at 08:40:51PM +0800, Shiyang Ruan wrote:
> +static int mf_generic_kill_procs(unsigned long long pfn, int flags,
> +		struct dev_pagemap *pgmap)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	LIST_HEAD(to_kill);
> +	dax_entry_t cookie;
> +
> +	/*
> +	 * Prevent the inode from being freed while we are interrogating
> +	 * the address_space, typically this would be handled by
> +	 * lock_page(), but dax pages do not use the page lock. This
> +	 * also prevents changes to the mapping of this pfn until
> +	 * poison signaling is complete.
> +	 */
> +	cookie = dax_lock_page(page);
> +	if (!cookie)
> +		return -EBUSY;
> +
> +	if (hwpoison_filter(page))
> +		return 0;
> +
> +	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
> +		/*
> +		 * TODO: Handle HMM pages which may need coordination
> +		 * with device-side memory.
> +		 */
> +		return -EBUSY;
> +	}
> +
> +	/*
> +	 * Use this flag as an indication that the dax page has been
> +	 * remapped UC to prevent speculative consumption of poison.
> +	 */
> +	SetPageHWPoison(page);
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a
> +	 * different physical page at a given virtual address, so all
> +	 * userspace consumption of ZONE_DEVICE memory necessitates
> +	 * SIGBUS (i.e. MF_MUST_KILL)
> +	 */
> +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +	collect_procs(page, &to_kill, true);
> +
> +	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
> +	dax_unlock_page(page, cookie);
> +	return 0;
> +}

There's an assumption here that fsdax only has order-0 pages.
pfn_to_page() is going to return the precise page for that pfn, but then
page->mapping and page->index are not valid for tail pages.

I'm currently trying to folio-ise memory-failure.c, and it is not
going well!  There are several places where it's hard to tell
what should happen.


