Return-Path: <nvdimm+bounces-1804-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 057CD445318
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 13:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F273A1C0D66
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 12:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FD42C9D;
	Thu,  4 Nov 2021 12:32:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297EA2C85
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iQDesZV5L2mroTI3Kp4Q9Tkxn1uaR3bTz2ke0CiK9wE=; b=l05sE+7qLWw6hasWyI/n0sgCrx
	1gk2a/tDTo4hfhxCY2tx9KEeS3Me3gh5TO/MYJsvwrTQ7Uk2XzOQGVGEMRKLI0tl9ouAAsajZAYQQ
	qScYChjvl1Mx+k3w3OHPSsjy5wz1TeQFTAVbPl7mJTLC5cHnGIhKhN5wdbQ3QGtSMGeCl+zqA7hp2
	NUJ72xXrPItCUBAWEQGuvyeMknqkRWwyQVRjCFS2B/hFsjoTkXs0Y5uFTY1Z1L03Sl+V6x8ko9F25
	HEy9RYwqNe19PXKLzMA3IoGWaMQYYlH6x+koORZ53RoCD2TIuFZVTG2orIoah0SlzuiAe3oRIVf0i
	7wQ3cDPA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mibrf-005rYi-P5; Thu, 04 Nov 2021 12:29:31 +0000
Date: Thu, 4 Nov 2021 12:29:07 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <YYPSE4XACpqs21Yl@casper.infradead.org>
References: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org>
 <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
 <YYK/tGfpG0CnVIO4@infradead.org>
 <CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
 <YYOaOBKgFQYzT/s/@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYOaOBKgFQYzT/s/@infradead.org>

On Thu, Nov 04, 2021 at 01:30:48AM -0700, Christoph Hellwig wrote:
> Well, the whole problem is that we should not have to manage this at
> all, and this is where I blame Intel.  There is no good reason to not
> slightly overprovision the nvdimms and just do internal bad page
> remapping like every other modern storage device.

What makes you think they don't?

The problem is persuading the CPU to do writes without doing reads.
That's where magic instructions or out of band IO is needed.

