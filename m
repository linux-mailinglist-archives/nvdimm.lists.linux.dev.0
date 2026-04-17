Return-Path: <nvdimm+bounces-13915-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLgRA61Y4mn65AAAu9opvQ
	(envelope-from <nvdimm+bounces-13915-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 17:58:37 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9777041CDC9
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 17:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A4972301F2A3
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 15:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD3B349AFF;
	Fri, 17 Apr 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSj4pF6p"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9907063CB;
	Fri, 17 Apr 2026 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776441506; cv=none; b=uk1JS5rXYHBGwiZMLgGxTo5LvEK5SmSLu4FbEXa9INibkIr/1y0LwvOD92yg4+N/Id4wlr0Rvnhyg+qFWYx4sfp4aI9lGEoesdCkHemPwvSk7v1h8F5hwkysgF4xe3sbKoreGwgWV67XO642zkKhL1HOtsfp0XO05hZObiqRv0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776441506; c=relaxed/simple;
	bh=RWwR6uXkMPCg3c+IP0E47phCQB0xWxT+MTd7hLknM8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QChHfhniS1l+TVcCoiqfL8hsaDIgVfNaRiWIXEgZ1B+JBTINMfiAOkEd4UUlQj0oT1oKZtLtSStgyXrIXeG1QLqkx3TTe59UP8cl4pvAH7qWnuDe03OZSmEAsJEmGSE96Aaw4C7GGMHXD+kJvptdVVaTnVH9y3kChEvPoh2kRNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSj4pF6p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C01BC19425;
	Fri, 17 Apr 2026 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776441506;
	bh=RWwR6uXkMPCg3c+IP0E47phCQB0xWxT+MTd7hLknM8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nSj4pF6pEStATHHvFcao6ZgutHlzZxxYiSQhkIF/ihZWLfl6b4BDIePrGypwc7Y7n
	 S0a1+GnAmfAW2K8RVhcgrbF5swCfcbZ/lOb1TUeszgAHRhtQWYerJrVjOF3x75xnus
	 8kJ0/qbcVjX8K39nLIY2Z7xIELn6xkJtXz3mrWuiYA90f5aXbVpTE27oRWn2xxL081
	 t7qEbuBJgcDa+4ArZDaBXZ9npbd6fNPOi7HD4tB2IvRoLnp8Qb4+8JFA049U0CVayA
	 a+sriPOflWJqt2aB3F2008TF2jG+h0vx0RCAc+Jo3efVH80ny6o+ypycLQM3C1AFhf
	 sSFXvg8kbKlfQ==
Date: Fri, 17 Apr 2026 08:58:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
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
Message-ID: <20260417155825.GB7727@frogsfrogsfrogs>
References: <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
 <20260416224331.GD114184@frogsfrogsfrogs>
 <CAJnrk1Y78UGLyAGVjiQ10PERTz1d2qcimok6bqCquy7jQYaXag@mail.gmail.com>
 <20260417054031.GA7727@frogsfrogsfrogs>
 <aeHsh3swBp2IZ4cX@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHsh3swBp2IZ4cX@infradead.org>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13915-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,gourry.net,groves.net,szeredi.hu,bsbernd.com,jagalactic.com,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[42];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9777041CDC9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 01:17:11AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 16, 2026 at 10:40:31PM -0700, Darrick J. Wong wrote:
> > > > ...the memory interleaving is a rather interesting quality of famfs.
> > > > There's no good way to express a formulaic meta-mapping in traditional
> > > > iomap parlance, and famfs needs that to interleave across memory
> > > > controllers/dimm boxen/whatever.  Throwing individual iomaps at the
> > > > kernel is a very inefficient way to do that.  So I don't think there's a
> > > > good reason to get rid of GET_FMAP at this time...
> > > 
> > > So could we make the interleaving part generic then? Striped /
> > > interleaved layouts are used elsewhere (eg RAID-0, md-stripe, etc.) -
> > > could we add a generic interleave descriptor to the uapi and use that
> > > for what famfs needs?
> > 
> > I doubt it.  md-raid presents a unified LBA address space, which means
> > that the filesystem doesn't have to know anything about whatever
> > translations might happen underneath it.
> 
> Unless that translation happens in the file system.  It does for btrfs
> right now, and it does for pNFS blocklayout.  The former is using iomap
> for direct I/O (and has old code and vague plans for using it for
> buffered I/O maybe eventually), the latter does not currently but would
> benefit a lot, although wiring it through the NFS code will be painful.

Not to mention a huge layering violation unless you're doing xraid. ;)

That said, the fuse-iomap patches have been waiting for a review since
October, and I'd really prefer to get the base enablement of iomap
merged before we start asking about things that existing fuse servers
and iomap client filesystems don't do, like in-filesystem raid.

> > Most filesystems that implement striping themselves don't restrict
> > themselves to monotonically increasing LBA ranges rotored across each
> > device like md-raid0 does.
> 
> Mappings can be more flexible, but they usually would not in a single
> iomap iteration.
> 
> > But for whatever reason, pmem/dax don't have remapping layers like
> > md/dm so filesystems have to do that on their own if the hardware
> > doesn't do it for them.
> 
> DM actually supports DAX.  I don't think that's a very good way as it
> adds a lot of overhead for little gain for striping.

Aha, it has long been my suspicion that looping through mapping layers
is a real performance pit for memory-based file stores.  Thanks for
saying that explicitly.

--D

