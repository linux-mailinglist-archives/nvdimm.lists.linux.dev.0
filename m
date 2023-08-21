Return-Path: <nvdimm+bounces-6541-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FDE47828E4
	for <lists+linux-nvdimm@lfdr.de>; Mon, 21 Aug 2023 14:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE8A2280E7C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 21 Aug 2023 12:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33A85661;
	Mon, 21 Aug 2023 12:21:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8217185B
	for <nvdimm@lists.linux.dev>; Mon, 21 Aug 2023 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5IiWcS1pGUM8RhlF+xFAzuOei17PLjfs94NmDiNvo6g=; b=MR/QHwNqCgmOxVS7c6EPkcvTOM
	ewCAH+I5VyIrZrxJzwYfZLZdCgL8s90TQvZ+npslaTk64GCHlebjy/zTEFSP1XKvpvz0F1mp04dGb
	Q4Mw4xNqTcDxevU3YZo9ZuZG7u7901KOLFAZQFBrfJj6DTvFoLmKqeOrbe9EGAWJD80G+5oUvjC9E
	GE7/tDN7WYGjkchDeLjeoEXqx63p+j9VqmffpAwOVP34B8h7G2NH+m2Ijbr5WZl9m60lEmymGlSTH
	3KMB/ugwe8njVx8yVWKJI7O8kZmYJA5QdxgWpCri1u728bx/fA3oJh+UCaWAdHAzd3/DRUeZhFvtJ
	MESTOvHA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qY3tZ-00A7pc-KQ; Mon, 21 Aug 2023 12:20:33 +0000
Date: Mon, 21 Aug 2023 13:20:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Xueshi Hu <xueshi.hu@smartx.com>, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, jayalk@intworks.biz,
	daniel@ffwll.ch, deller@gmx.de, bcrl@kvack.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, miklos@szeredi.hu,
	mike.kravetz@oracle.com, muchun.song@linux.dev, djwong@kernel.org,
	akpm@linux-foundation.org, hughd@google.com, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: clean up usage of noop_dirty_folio
Message-ID: <ZONWka8NpDVGzI8h@casper.infradead.org>
References: <20230819124225.1703147-1-xueshi.hu@smartx.com>
 <20230821111643.5vxtktznjqk42cak@quack3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821111643.5vxtktznjqk42cak@quack3>

On Mon, Aug 21, 2023 at 01:16:43PM +0200, Jan Kara wrote:
> On Sat 19-08-23 20:42:25, Xueshi Hu wrote:
> > In folio_mark_dirty(), it will automatically fallback to
> > noop_dirty_folio() if a_ops->dirty_folio is not registered.
> > 
> > As anon_aops, dev_dax_aops and fb_deferred_io_aops becames empty, remove
> > them too.
> > 
> > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> 
> Yeah, looks sensible to me but for some callbacks we are oscilating between
> all users having to provide some callback and providing some default
> behavior for NULL callback. I don't have a strong opinion either way so
> feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> But I guess let's see what Matthew thinks about this and what plans he has
> so that we don't switch back again in the near future. Matthew?

I was hoping Christoph would weigh in ;-)  I don't have a strong
feeling here, but it seems to me that a NULL ->dirty_folio() should mean
"do the noop thing" rather than "do the buffer_head thing" or "do the
filemap thing".  In 0af573780b0b, the buffer_head default was removed.
I think enough time has passed that we're OK to change what a NULL
->dirty_folio means (plus we also changed the name of ->set_page_dirty()
to ->dirty_folio())

So Ack to the concept.  One minor change I'd request:

-bool noop_dirty_folio(struct address_space *mapping, struct folio *folio)
+static bool noop_dirty_folio(struct address_space *mapping, struct folio *folio)
 {
 	if (!folio_test_dirty(folio))
 		return !folio_test_set_dirty(folio);
 	return false;
 }
-EXPORT_SYMBOL(noop_dirty_folio);

Please inline this into folio_mark_dirty() instead of calling it.

