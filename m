Return-Path: <nvdimm+bounces-1822-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A43445966
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 19:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 619881C0F33
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 18:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9AB2C9A;
	Thu,  4 Nov 2021 18:11:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2883C2C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X/zx02lrok+YXE3fHYCnesmy30oZEd5gQFjWswEssO8=; b=Sbg76vqBUrKRwSH8VKRkJgiUCC
	r1oyKJ79d1QE9fOCCZaLTLXMc2ew6uKuULTjgBflx8d78VPVr2homn7rL3kQVHvP7Ak9/wM0MbpSy
	YSrJUXTFHpxtX4i3XpHfoy8u4fm08G+Cx16cTwYn/LBCFS7Lv3f39xVI6zKCrHqps5FJzI6XW50qi
	8xgjF5t15JvLZTKg6czUDnDkLd8NyrCoKV5fYiMDj6WPdVlgUuSxgdjCS10DIR/kWUthyM54DNI3M
	3ulIl7eI4ED25BAW7Mc3MlXqYoWF5f6UgyROaM1IDdmMYVmXaRrN/V/m7JIC73SF58NYKDj27R5M0
	Cc4GufhA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mih7J-0062bO-LC; Thu, 04 Nov 2021 18:06:22 +0000
Date: Thu, 4 Nov 2021 18:05:37 +0000
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
Message-ID: <YYQg8X9VAuWYekD4@casper.infradead.org>
References: <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org>
 <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
 <YYK/tGfpG0CnVIO4@infradead.org>
 <CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
 <YYOaOBKgFQYzT/s/@infradead.org>
 <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
 <YYQbu6dOCVB7yS02@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYQbu6dOCVB7yS02@infradead.org>

On Thu, Nov 04, 2021 at 10:43:23AM -0700, Christoph Hellwig wrote:
> Well, the answer for other interfaces (at least at the gold plated
> cost option) is so strong internal CRCs that user visible bits clobbered
> by cosmic rays don't realisticly happen.  But it is a problem with the
> cheaper ones, and at least SCSI and NVMe offer the error list through
> the Get LBA status command (and I bet ATA too, but I haven't looked into
> that).  Oddly enough there has never been much interested from the
> fs community for those.

"don't realistically happen" is different when you're talking about
"doesn't happen within the warranty period of my laptop's SSD" and
"doesn't happen on my fleet of 10k servers before they're taken out of
service".  There's also a big difference in speeds between an NVMe drive
(7GB/s) and a memory device (20-50GB/s).  The UBER being talked about
when I was still at Intel was similar to / slightly better than DRAM,
but that's still several failures per year across an entire data centre
that's using pmem flat-out.

