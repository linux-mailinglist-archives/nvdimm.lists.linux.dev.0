Return-Path: <nvdimm+bounces-13769-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDPiHyCQxmlLLwUAu9opvQ
	(envelope-from <nvdimm+bounces-13769-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Mar 2026 15:11:44 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 06361345D2C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Mar 2026 15:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 29EE930E82A4
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Mar 2026 14:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2501E3F1649;
	Fri, 27 Mar 2026 14:07:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836533EB7FC
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620434; cv=none; b=Oqn7J77BfE1O+SVC/yT+9edUdD2ZkYNMzLariqhbqUD77vH8DK30syWwG08pDe72IDRKFA3qgYbbnQw7nkLxBYHji9FVXewD4OkxXQH8d4JDf1lrpJ+SofHSkrg7qGtYKNbkKus1GYxo4KynpBelO6sW5TN9iJRFY5CeH4WLE0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620434; c=relaxed/simple;
	bh=AggJWbzXgAJW8nJRhQGxWDobjA7ATMqWYFMZpxSl+TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSCsFpO8O35JJZclvu2h9vxxpcWWhlNsNVmdfgvbQ1a4Exdqhqb+nSdgH4LZh1otbOCfDBZi2T0fYPtyBNpmEIBaLVPimh2of/Mqc0WX0UfJHsBrFc2zTwjpJGwMGiNupYOe2Ft3jq+gEbokABD04gKxJPx5Yp3z3s9YQnxkx8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FF49E0F30;
	Fri, 27 Mar 2026 14:07:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf06.hostedemail.com (Postfix) with ESMTPA id D41B82000F;
	Fri, 27 Mar 2026 14:06:55 +0000 (UTC)
Date: Fri, 27 Mar 2026 09:06:53 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 5/8] dax: Add dax_operations for use by fs-dax on
 fsdev dax
Message-ID: <acaOzmCYOZHr_Ia1@groves.net>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003851.5045-1-john@jagalactic.com>
 <0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
 <593b2b5c-779b-4e29-8b03-12ce743b10b4@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <593b2b5c-779b-4e29-8b03-12ce743b10b4@intel.com>
X-Stat-Signature: 7dqy4jynbesstz9697ot4cz4cexh86pu
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19u88rI/RZbOnBIHfsRi86A2mDPG8VKxsA=
X-HE-Tag: 1774620415-652695
X-HE-Meta: U2FsdGVkX1+FrBjZnrpIbH0kvez85SGTcc2xxECCcDS+nAaDETophnfrphfd5mO9QQhYEdXOx92QLbEWRoJ9nDerbKGHUDtoN6YOsp7jWLzV7JSuDVRjE9A0MCbpn2Khfo5hWKqQiiTbEVX6AdSqGR2bRTk7OUuaByYUZz87MIOrwNJOhx0cn4b79EikkIiwmb+rJrYWJzPe5qRFV23oiY2dfKw1Anv3CmCHgBuMsQ/u4t5n5dwjt5d6SGNbPQTtnGHdoaSqLW6mO4xqMEAMhO3CFDaqGw3eQWKEQUX4xUcyefn0zqY+lXxLNiuUeL1+MpKiV07znBajEkTfCZ37KHMxl5M/SKjM4wW8yo1/nxVslThUrFIeDiyokY3c/6GG
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[jagalactic.com,szeredi.hu,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13769-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[groves.net];
	RCPT_COUNT_TWELVE(0.00)[39];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,groves.net:email,groves.net:mid]
X-Rspamd-Queue-Id: 06361345D2C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 26/03/25 02:28PM, Dave Jiang wrote:
> 
> 
> On 3/23/26 5:39 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > fsdev: Add dax_operations for use by famfs.
> > 
> > This replicates the functionality from drivers/nvdimm/pmem.c that
> > conventional fs-dax file systems (e.g. xfs) use to support dax
> > read/write/mmap to a daxdev - without which famfs can't sit atop a
> > daxdev.
> > 
> > - These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c
> > - fsdev_dax_direct_access() returns the hpa, pfn and kva. The kva was
> >   newly stored as dev_dax->virt_addr by dev_dax_probe().
> > - The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
> >   for read/write (dax_iomap_rw())
> > - fsdev_dax_recovery_write() and dev_dax_zero_page_range() have not been
> >   tested yet. I'm looking for suggestions as to how to test those.
> > - dax-private.h: add dev_dax->cached_size, which fsdev needs to
> >   remember. The dev_dax size cannot change while a driver is bound
> >   (dev_dax_resize returns -EBUSY if dev->driver is set). Caching the size
> >   at probe time allows fsdev's direct_access path can use it without
> >   acquiring dax_dev_rwsem (which isn't exported anyway).
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/dax-private.h |  1 +
> >  drivers/dax/fsdev.c       | 84 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 85 insertions(+)
> > 
> > diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> > index 7a3727d76a68..ee8f3af8387f 100644
> > --- a/drivers/dax/dax-private.h
> > +++ b/drivers/dax/dax-private.h
> > @@ -85,6 +85,7 @@ struct dev_dax {
> >  	struct dax_region *region;
> >  	struct dax_device *dax_dev;
> >  	void *virt_addr;
> > +	u64 cached_size;
> 
> Just caught this. Need a kdoc entry.
> 
> DJ

Thank you! Added for v10

John


