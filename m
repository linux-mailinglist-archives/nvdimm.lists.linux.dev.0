Return-Path: <nvdimm+bounces-1815-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6221F4458DA
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 18:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 8DD5E1C0F2A
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 17:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C55F2C9A;
	Thu,  4 Nov 2021 17:43:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4E52C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tpfTM33t7i1Dy0/MirwuyrZHtl/M5zJb53zksLaIaww=; b=izhOhuQ7+o/FPLVHvFRYe7dOmO
	EKtpQ0CBDnMKmuXKOe/Zlh3NIONEezpxzTNpDKYTwr2pABanbXIUtTny/VMaNObE/41bPRgqEE1uC
	cJRKfVaWHcbVX0BuZoBaOgRR/QHe11HLcQ1i7+xflfuFOu2PIxtSyoHEzWKTqfAypcc0omMUWaqIi
	wkJHvA25mPsBegAiAH8kwFuGnFD2JvXc+tPH335MDjyWcR+/l22fT7b3i51K+5SAj73ghFlbVcP7g
	vB5RMzB4fuLnjRRi8+4CN9cEcAaZrhSCOTkqBD6gjg+TXUwTbfhTswKMHe6JQ4Skm4Kb2uT9qmp78
	l/43M2oQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migln-009hiW-DT; Thu, 04 Nov 2021 17:43:23 +0000
Date: Thu, 4 Nov 2021 10:43:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
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
Message-ID: <YYQbu6dOCVB7yS02@infradead.org>
References: <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org>
 <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
 <YYK/tGfpG0CnVIO4@infradead.org>
 <CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
 <YYOaOBKgFQYzT/s/@infradead.org>
 <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 04, 2021 at 09:24:15AM -0700, Dan Williams wrote:
> No, the big difference with every other modern storage device is
> access to byte-addressable storage. Storage devices get to "cheat"
> with guaranteed minimum 512-byte accesses. So you can arrange for
> writes to always be large enough to scrub the ECC bits along with the
> data. For PMEM and byte-granularity DAX accesses the "sector size" is
> a cacheline and it needed a new CPU instruction before software could
> atomically update data + ECC. Otherwise, with sub-cacheline accesses,
> a RMW cycle can't always be avoided. Such a cycle pulls poison from
> the device on the read and pushes it back out to the media on the
> cacheline writeback.

Indeed.  The fake byte addressability is indeed the problem, and the
fix is to not do that, at least on the second attempt.

> I don't understand what overprovisioning has to do with better error
> management? No other storage device has seen fit to be as transparent
> with communicating the error list and offering ways to proactively
> scrub it. Dave and Darrick rightly saw this and said "hey, the FS
> could do a much better job for the user if it knew about this error
> list". So I don't get what this argument about spare blocks has to do
> with what XFS wants? I.e. an rmap facility to communicate files that
> have been clobbered by cosmic rays and other calamities.

Well, the answer for other interfaces (at least at the gold plated
cost option) is so strong internal CRCs that user visible bits clobbered
by cosmic rays don't realisticly happen.  But it is a problem with the
cheaper ones, and at least SCSI and NVMe offer the error list through
the Get LBA status command (and I bet ATA too, but I haven't looked into
that).  Oddly enough there has never been much interested from the
fs community for those.

> > So far out of the low instrusiveness options Janes' previous series
> > to automatically retry after calling a clear_poison operation seems
> > like the best idea so far.  We just need to also think about what
> > we want to do for direct users of ->direct_access that do not use
> > the mcsafe iov_iter helpers.
> 
> Those exist? Even dm-writecache uses copy_mc_to_kernel().

I'm sorry, I have completely missed that it has been added.  And it's
been in for a whole year..

