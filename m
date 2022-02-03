Return-Path: <nvdimm+bounces-2851-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6E44A856E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 14:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 9A5EF1C0C60
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 13:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE272CA1;
	Thu,  3 Feb 2022 13:42:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B6E2F23
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Eub9mVW6PyMZS6D3bkxgG0H0TJDAAx12nqT4lxyCz64=; b=FlR5FmaWz2cUfG9to3RMgfeT9m
	vemsfOiYBDClBhczNpu2+Nn1sZQzpIOT8rJLq3j+J/LJ2Y8ogUmD2cWgmo+fLrYw5MXKIKtMhvd5L
	TuSfrLWwEGNWQXmOjKvojwiDPPY3QsTWPn3dd+zKZ3Ba8mamhv2QU6SoRYO3lv2zvXHgCgJZHPYfe
	RYDvB6PsGcEcsaSU6K/MDMymO6iefFhrC4onWQ3zJxEEWfkMx5M1l1yw51ITz5LMpvgzGGFzCtttd
	euHWkG6a1nq8uA884WE6bLE2Nap9N0L0wZ4KKeKWcJGqFL+NgYpIGGopCRxlpdoAfJMOqwzc2kOY5
	vlBS2kCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFcNc-001Sfi-KY; Thu, 03 Feb 2022 13:42:32 +0000
Date: Thu, 3 Feb 2022 05:42:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v5 1/7] mce: fix set_mce_nospec to always unmap the whole
 page
Message-ID: <YfvbyKdu812To3KY@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
 <20220128213150.1333552-2-jane.chu@oracle.com>
 <YfqFWjFcdJSwjRaU@infradead.org>
 <d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
 <950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 02, 2022 at 11:07:37PM +0000, Jane Chu wrote:
> On 2/2/2022 1:20 PM, Jane Chu wrote:
> >> Wouldn't it make more sense to move these helpers out of line rather
> >> than exporting _set_memory_present?
> > 
> > Do you mean to move
> >     return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
> > into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
> > If so, sure I'll do that.
> 
> Looks like I can't do that.  It's either exporting 
> _set_memory_present(), or exporting change_page_attr_set().  Perhaps the 
> former is more conventional?

These helpers above means set_mce_nospec and clear_mce_nospec.  If they
are moved to normal functions instead of inlines, there is no need to
export the internals at all.

