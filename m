Return-Path: <nvdimm+bounces-423-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9907E3C1C37
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 Jul 2021 01:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 35F533E1088
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Jul 2021 23:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917FE2F80;
	Thu,  8 Jul 2021 23:43:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2684F70
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 23:43:10 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 077191044DD7;
	Fri,  9 Jul 2021 09:16:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1m1dG5-004Kod-Un; Fri, 09 Jul 2021 09:16:41 +1000
Date: Fri, 9 Jul 2021 09:16:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"rgoldwyn@suse.de" <rgoldwyn@suse.de>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"willy@infradead.org" <willy@infradead.org>
Subject: Re: [PATCH v6.1 6/7] fs/xfs: Handle CoW for fsdax write() path
Message-ID: <20210708231641.GQ664593@dread.disaster.area>
References: <OSBPR01MB2920A2BCD568364C1363AFA6F4369@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20210615072147.73852-1-ruansy.fnst@fujitsu.com>
 <OSBPR01MB2920D2D275EB0DB15C37D079F4079@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20210625221855.GG13784@locust>
 <OSBPR01MB2920922639112230407000E9F4039@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20210628050919.GL13784@locust>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628050919.GL13784@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
	a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
	a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
	a=_EmLEX5E1_FSfXe-uIgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Sun, Jun 27, 2021 at 10:09:19PM -0700, Darrick J. Wong wrote:
> > > I had imagined that you'd create a struct dax_iomap_ops to wrap all the extra
> > > functionality that you need for dax operations:
> > > 
> > > struct dax_iomap_ops {
> > > 	struct iomap_ops	iomap_ops;
> > > 
> > > 	int			(*end_io)(inode, pos, length...);
> > > };
> > > 
> > > And alter the four functions that you need to take the special dax_iomap_ops.
> > > I guess the downside is that this makes iomap_truncate_page and
> > > iomap_zero_range more complicated, but maybe it's just time to split those into
> > > DAX-specific versions.  Then we'd be rid of the cross-links betwee
> > > fs/iomap/buffered-io.c and fs/dax.c.
> > 
> > This seems to be a better solution.  I'll try in this way.  Thanks for your guidance.
> 
> I started writing on Friday a patchset to apply this style cleanup both
> to the directio and dax paths.  The cleanups were pretty straightforward
> until I started reading the dax code paths again and realized that file
> writes still have the weird behavior of mapping extents into a file,
> zeroing them, then issuing the actual write to the extent.  IOWs, a
> double-write to avoid exposing stale contents if crash.
> 
> Apparently the reason for this was that dax (at least 6 years ago) had
> no concept paralleling the page lock, so it was necessary to do that to
> avoid page fault handlers racing to map pfns into the file mapping?
> That would seem to prevent us from doing the more standard behavior of
> allocate unwritten, write data, convert mapping... but is that still the
> case?  Or can we get rid of this bad quirk?

Yeah, so that was the deciding factor in getting rid of unwritten
extent allocation in DAX similar to the DIO path. However, we were
already considering getting rid of it for another reason: write
performance.

That is, doing two extent tree manipulation transactions per write
is way more expensive than the double memory write for small IOs.
IIRC, for small writes (4kB) the double memroy write version we now
have was 2-3x faster than the {unwritten allocation, write, convert}
algorithm we had originally.

I don't think we want to go back to the unwritten allocation
behaviour - it sucked when it was first done because all DAX write
IO is synchronous, and it will still suck now because DAX writes are
still synchronous. What we really want to do here is copy the data
into the new extent before we commit the allocation transaction....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

