Return-Path: <nvdimm+bounces-1791-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE739444659
	for <lists+linux-nvdimm@lfdr.de>; Wed,  3 Nov 2021 17:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C06D31C05D2
	for <lists+linux-nvdimm@lfdr.de>; Wed,  3 Nov 2021 16:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443292C9D;
	Wed,  3 Nov 2021 16:53:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787B32C98
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ySf8hnRGgcGBFPw1OqHjYfFXWjAWp6d1U3iHxpW19Ys=; b=ldSzTLqtpw/28nPKVoQb8qdoIl
	adNO9XYwY4XgBBEak4LtLCfJawj4TSHN1Zs1ixHSOgc9FVO2phfzsIPyw7GhYQHx9Ip/VTlSKHepv
	9JoeYyoxUB8qpgUiLTH+CFDqvflsyuoCMgCWDQpoOgmRvESUSiaGVSm90mSXGWiG0rQrXPd6eq2n/
	WS0RM0xU89huiOSx4wU5D5N+09BOBbDCOjPyDYyOQOMcTnikykET90sbRn+DNK8WXwWQDTswR1iTL
	RUddkojWuOMhQTYIT33jxUp03PILjo25IBZW8Nj6+xtkJ2LboKVAHqbZyfpfKgaj83OHbb/24fWJM
	1v8+APyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1miJVt-005rED-HI; Wed, 03 Nov 2021 16:53:25 +0000
Date: Wed, 3 Nov 2021 09:53:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
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
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <YYK+hfmB05URYO75@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <CAPcyv4hK18DetEf9+NcDqM5y07Vp-=nhysHJ3JSnKbS-ET2ppw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hK18DetEf9+NcDqM5y07Vp-=nhysHJ3JSnKbS-ET2ppw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 02, 2021 at 09:03:55AM -0700, Dan Williams wrote:
> > why devices are built to handle them.  It is just the Intel-style
> > pmem interface to handle them which is completely broken.
> 
> No, any media can report checksum / parity errors. NVME also seems to
> do a poor job with multi-bit ECC errors consumed from DRAM. There is
> nothing "pmem" or "Intel" specific here.

If you do get data corruption from NVMe (which yes can happen despite
the typical very good UBER rate) you just write over it again.  You
don't need to magically whack the underlying device.  Same for hard
drives.

> > Well, my point is doing recovery from bit errors is by definition not
> > the fast path.  Which is why I'd rather keep it away from the pmem
> > read/write fast path, which also happens to be the (much more important)
> > non-pmem read/write path.
> 
> I would expect this interface to be useful outside of pmem as a
> "failfast" or "try harder to recover" flag for reading over media
> errors.

Maybe we need to sit down and define useful semantics then?  The problem
on the write side isn't really that the behavior with the flag is
undefined, it is more that writes without the flag have horrible
semantics if they don't just clear the error.

