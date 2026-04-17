Return-Path: <nvdimm+bounces-13912-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAhgELDt4WmKzgAAu9opvQ
	(envelope-from <nvdimm+bounces-13912-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 10:22:08 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B684C418961
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 10:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 041A930A2DAF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 08:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2A83A8FE6;
	Fri, 17 Apr 2026 08:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oYU8Zvda"
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2183612D7;
	Fri, 17 Apr 2026 08:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776413847; cv=none; b=Qajsg1zX4qaH+P8Xe3X8axK8i/eJ7oiLUkgeszMX4HvnRbB8+fyEByIVw+LVKhFcIIAPYEjwtIwx4yHGhskXci7j+5hkkZeQhOfpVDrOpzZHNbGumK5TI7fNi9ebIyDBkgTG+em3IPVFCWSIXkGtiETX/B0xlSGMPhOWig2mUNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776413847; c=relaxed/simple;
	bh=mzb8UU2eqL5wE6R0P13zhu23wKqG0YMMBvEMOIq+0II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5ymNN9Uj0lgU5X9AsS1sn4JGQ644kvGl7KYf3KQgN3ADxvaVj42r3GwPXmIH+QVfPObDAe2cRPviOqq5q85ruXiu09ZmKxJ7gDOImFU/vXYOr1eXSQ3EnYbyTC1jYsQEMDzMa5/3sh9Rtj1cxPNd2c4btpbT1R1yuCDO6T8P28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oYU8Zvda; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M/v3KzlzWpzc+0rVbqdkthI/wwUljAyXLO9ixYYVrak=; b=oYU8Zvda0McizEYpiaxqU4xdv3
	ZRqaF5nPbAicumLmGdXyvcR80aFPmYZ1wp62kUuM4KZaWiDe+/ZL6fROUPWWZou0syiJcDfIyhqYt
	nRYl0MpxX0/61spnDfw+3YzrGJObcs8M3E0ay9cKrcZgvjmr8seznX/iK7OIObc8hcVxhf+KHC/eB
	JL1yGKTAydgH3F7GMmqyvLKuTAIPGHMD4u7+0z0sAgPtMl8i1gAVUWDg3KWxyEfa1opUkr0slmCXH
	mrLaIsi2Hn+A8q/x9DdKfLk8ZhmBUHzLVYQC/3z8HFA0wO/cz+gNf2+cd8eurX0kAjVo6YVZSA1jA
	UAuOTCVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDeNz-00000003fBo-0aLx;
	Fri, 17 Apr 2026 08:17:11 +0000
Date: Fri, 17 Apr 2026 01:17:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Dan Williams <djbw@kernel.org>,
	Gregory Price <gourry@gourry.net>, John Groves <John@groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan J Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeHsh3swBp2IZ4cX@infradead.org>
References: <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
 <20260416224331.GD114184@frogsfrogsfrogs>
 <CAJnrk1Y78UGLyAGVjiQ10PERTz1d2qcimok6bqCquy7jQYaXag@mail.gmail.com>
 <20260417054031.GA7727@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417054031.GA7727@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,gourry.net,groves.net,szeredi.hu,bsbernd.com,jagalactic.com,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,vger.kernel.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-13912-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Queue-Id: B684C418961
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 10:40:31PM -0700, Darrick J. Wong wrote:
> > > ...the memory interleaving is a rather interesting quality of famfs.
> > > There's no good way to express a formulaic meta-mapping in traditional
> > > iomap parlance, and famfs needs that to interleave across memory
> > > controllers/dimm boxen/whatever.  Throwing individual iomaps at the
> > > kernel is a very inefficient way to do that.  So I don't think there's a
> > > good reason to get rid of GET_FMAP at this time...
> > 
> > So could we make the interleaving part generic then? Striped /
> > interleaved layouts are used elsewhere (eg RAID-0, md-stripe, etc.) -
> > could we add a generic interleave descriptor to the uapi and use that
> > for what famfs needs?
> 
> I doubt it.  md-raid presents a unified LBA address space, which means
> that the filesystem doesn't have to know anything about whatever
> translations might happen underneath it.

Unless that translation happens in the file system.  It does for btrfs
right now, and it does for pNFS blocklayout.  The former is using iomap
for direct I/O (and has old code and vague plans for using it for
buffered I/O maybe eventually), the latter does not currently but would
benefit a lot, although wiring it through the NFS code will be painful.

> Most filesystems that implement striping themselves don't restrict
> themselves to monotonically increasing LBA ranges rotored across each
> device like md-raid0 does.

Mappings can be more flexible, but they usually would not in a single
iomap iteration.

> But for whatever reason, pmem/dax don't have remapping layers like
> md/dm so filesystems have to do that on their own if the hardware
> doesn't do it for them.

DM actually supports DAX.  I don't think that's a very good way as it
adds a lot of overhead for little gain for striping.


