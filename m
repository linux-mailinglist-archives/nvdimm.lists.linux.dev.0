Return-Path: <nvdimm+bounces-4863-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCAB5E709E
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Sep 2022 02:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06B6F280D74
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Sep 2022 00:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C103F15A3;
	Fri, 23 Sep 2022 00:18:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90CB7B
	for <nvdimm@lists.linux.dev>; Fri, 23 Sep 2022 00:18:56 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E8D961100D8A;
	Fri, 23 Sep 2022 10:18:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1obWP0-00AzJe-Gk; Fri, 23 Sep 2022 10:18:46 +1000
Date: Fri, 23 Sep 2022 10:18:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 05/18] xfs: Add xfs_break_layouts() to the inode
 eviction path
Message-ID: <20220923001846.GX3600936@dread.disaster.area>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
 <166329933874.2786261.18236541386474985669.stgit@dwillia2-xfh.jf.intel.com>
 <20220918225731.GG3600936@dread.disaster.area>
 <632894c4738d8_2a6ded294a@dwillia2-xfh.jf.intel.com.notmuch>
 <20220919212959.GL3600936@dread.disaster.area>
 <6329ee04c9272_2a6ded294bf@dwillia2-xfh.jf.intel.com.notmuch>
 <20220921221416.GT3600936@dread.disaster.area>
 <YyuQI08LManypG6u@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyuQI08LManypG6u@nvidia.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=632cfb6a
	a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
	a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=7-415B0cAAAA:8
	a=mUMTuxm4VeeAs60aVCsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Sep 21, 2022 at 07:28:51PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 22, 2022 at 08:14:16AM +1000, Dave Chinner wrote:
> 
> > Where are these DAX page pins that don't require the pin holder to
> > also hold active references to the filesystem objects coming from?
> 
> O_DIRECT and things like it.

O_DIRECT IO to a file holds a reference to a struct file which holds
an active reference to the struct inode. Hence you can't reclaim an
inode while an O_DIRECT IO is in progress to it. 

Similarly, file-backed pages pinned from user vmas have the inode
pinned by the VMA having a reference to the struct file passed to
them when they are instantiated. Hence anything using mmap() to pin
file-backed pages (i.e. applications using FSDAX access from
userspace) should also have a reference to the inode that prevents
the inode from being reclaimed.

So I'm at a loss to understand what "things like it" might actually
mean. Can you actually describe a situation where we actually permit
(even temporarily) these use-after-free scenarios?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

