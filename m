Return-Path: <nvdimm+bounces-1684-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7102B436FA3
	for <lists+linux-nvdimm@lfdr.de>; Fri, 22 Oct 2021 03:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id DE9553E1066
	for <lists+linux-nvdimm@lfdr.de>; Fri, 22 Oct 2021 01:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D982C9F;
	Fri, 22 Oct 2021 01:58:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EF268
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 01:58:18 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED74B610A4;
	Fri, 22 Oct 2021 01:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1634867898;
	bh=c8L9yqtOQno8QSB3ULMQffUkwUDJVg6kdYBJfcJdcMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g96XX9a9mSzi+2Kx8RQ65PHbUXgZ2eHNAQIWuMSIRrTBzOUvQPgi5vg7LPK9jBGam
	 lhTH6OnHe8C4q0Z0fffRat2tjJm11r4Xl3d1NN3AtZ/bcJsob4EBmVShieUBmddcQC
	 JnE8VxHAUpAJ2fpmr//vA/LJG/GzeUD+AyrZnVWFMo1H4oneozj04Es+3/SQuZ0S6a
	 TYQiwROwM/MjigR9TyUx0DfDMbS1p67KpKym7AGZUF/QgzOdMtAyXjl99x9/YoDQuo
	 Y7iuj0g//1S/3IbkzGZ2auNMbJoHshMwMUyWtSyav15RFt3KksZ4m+wBYIA/tMw03e
	 UIYh/NQ7wXFUg==
Date: Thu, 21 Oct 2021 18:58:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
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
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <20211022015817.GY24307@magnolia>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>

On Fri, Oct 22, 2021 at 01:37:28AM +0000, Jane Chu wrote:
> On 10/21/2021 4:31 AM, Christoph Hellwig wrote:
> > Looking over the series I have serious doubts that overloading the
> > slow path clear poison operation over the fast path read/write
> > path is such a great idea.

Why would data recovery after a media error ever be considered a
fast/hot path?  A normal read/write to a fsdax file would not pass the
flag, which skips the poison checking with whatever MCE consequences
that has, right?

pwritev2(..., RWF_RECOVER_DATA) should be infrequent enough that
carefully stepping around dax_direct_access only has to be faster than
restoring from backup, I hope?

> Understood, sounds like a concern on principle. But it seems to me
> that the task of recovery overlaps with the normal write operation
> on the write part. Without overloading some write operation for
> 'recovery', I guess we'll need to come up with a new userland
> command coupled with a new dax API ->clear_poison and propagate the
> new API support to each dm targets that support dax which, again,
> is an idea that sounds too bulky if I recall Dan's earlier rejection
> correctly.
> 
> It is in my plan though, to provide pwritev2(2) and preadv2(2) man pages
> with description about the RWF_RECOVERY_DATA flag and specifically not
> recommending the flag for normal read/write operation - due to potential
> performance impact from searching badblocks in the range.

Yes, this will help much. :)

> That said, the badblock searching is turned on only if the pmem device
> contains badblocks(i.e. bb->count > 0), otherwise, the performance
> impact is next to none. And once the badblock search starts,
> it is a binary search over user provided range. The unwanted impact
> happens to be the case when the pmem device contains badblocks
> that do not fall in the user specified range, and in that case, the
> search would end in O(1).

(I wonder about improving badblocks to be less sector-oriented and not
have that weird 16-records-max limit, but that can be a later
optimization.)

--D

> Thanks!
> -jane
> 
> 

