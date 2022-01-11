Return-Path: <nvdimm+bounces-2423-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED69248AF0D
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jan 2022 15:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F20AD1C0557
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jan 2022 14:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC58B2CA5;
	Tue, 11 Jan 2022 14:01:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A442829CA
	for <nvdimm@lists.linux.dev>; Tue, 11 Jan 2022 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LF/mpBO5j1rUYISJ5kTuyMtADrx3r6gpROrYNypLtkw=; b=ve3hDqC3IqQ2LgppYwfdzXoY6L
	94cU5qrji9ovRx53/JbeLkUzFgUGK/W5Ml4v53FUWv9U64eXrdTIFJjrlU50FtLUjA0HLjJukmRgP
	oSiTNGxKDnbCl1OcOgro86+aPljLxTeQf7TUyiQldEqqNwih2GdrvLilg3TIf1m0UOaQlpNfJ6nz4
	GTzVHHf8oeSCEvM4W5SHosSz4c7kAW9OtkN3pugOIguBCf4/YzktoWpU0xZpi/4EWan+TDW8LS2zQ
	v8KaAtChv4JZF7/TsQ3TVSBIKkMEb48fzI/9DBiN0KYxGZc2Rx9IVODfiXezpHiOc0ns/oOiiS7I5
	TCQdL+ag==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n7Hi9-003Ipl-Pe; Tue, 11 Jan 2022 14:01:17 +0000
Date: Tue, 11 Jan 2022 14:01:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <Yd2NraXh3ka8PdrQ@casper.infradead.org>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>

On Tue, Jan 11, 2022 at 12:17:18AM -0800, John Hubbard wrote:
> Zooming in on the pinning aspect for a moment: last time I attempted to
> convert O_DIRECT callers from gup to pup, I recall wanting very much to
> record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
> or some non-FOLL_PIN method. Because at the end of the IO, it is not
> easy to disentangle which pages require put_page() and which require
> unpin_user_page*().
> 
> And changing the bio_vec for *that* purpose was not really acceptable.
> 
> But now that you're looking to change it in a big way (and with some
> spare bits avaiable...oohh!), maybe I can go that direction after all.
> 
> Or, are you looking at a design in which any phyr is implicitly FOLL_PIN'd
> if it exists at all?

That.  I think there's still good reasons to keep a single-page (or
maybe dual-page) GUP around, but no reason to mix it with ranges.

> Or any other thoughts in this area are very welcome.

That's there's no support for unpinning part of a range.  You pin it,
do the IO, unpin it.  That simplifies the accounting.


