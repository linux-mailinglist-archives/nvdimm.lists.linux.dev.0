Return-Path: <nvdimm+bounces-13678-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Ef8Ok16wWkQTQQAu9opvQ
	(envelope-from <nvdimm+bounces-13678-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Mar 2026 18:37:17 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C157A2FA152
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Mar 2026 18:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3E077308B3F6
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Mar 2026 17:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A1F3C73D8;
	Mon, 23 Mar 2026 17:21:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DBD3C1409
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286494; cv=none; b=dbLWyw3UpKyce8l0lc225MTWbwyH4p29eKcGM9NvlcfxP7aLV3v+rWHmWTBCJsOiD8XrR0DhZU8JrL2oxlDNTzSXJ6sFJ3Z5Nt3vFRx14q3wMR/s3o9llSxbxgad8B1obatu9O7qEPnGVv8JNjzXS4kv0HcA2gb79cBdPuBP4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286494; c=relaxed/simple;
	bh=cK5crSIbq3v6eBqTicknSYTbc2z0ScWMd5hriD/IKUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEt2oem6NImUoC8mrzq5aqhscvKfSyQio/mE5fM8PpOxQglFZFSnFWtje8IgiJlmTPEv0afQdf+9rNIpli8qr4xyGgk8okbSBvsnUP6O2GU/zkC5Blv2RsrZtXYQ9zL+FrZ0QvJL2BM21zluSTiFXuC5m6PnFW7dtV6NHIoSlUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04404160614;
	Mon, 23 Mar 2026 17:21:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf08.hostedemail.com (Postfix) with ESMTPA id 4B16C20028;
	Mon, 23 Mar 2026 17:21:11 +0000 (UTC)
Date: Mon, 23 Mar 2026 12:21:09 -0500
From: John Groves <john@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V8 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <acF1vWQGB_EoRWVi@groves.net>
References: <20260318202737.4344.dax@groves.net>
 <20260319012837.4443-1-john@groves.net>
 <20260319122057.00004503@huawei.com>
 <ab3nFoKxirEgoS_v@groves.net>
 <20260323121250.00004402@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323121250.00004402@huawei.com>
X-Stat-Signature: bxdg8a6ie1w9ircu3df6dzukx13pabjz
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1809opFCnBO7f651BPCBxwJ49nYJRohtOQ=
X-HE-Tag: 1774286471-505091
X-HE-Meta: U2FsdGVkX18TNbiNbjQAlQ4GJFRHGyldIttWpgr1j2rn5VyzyRd0i4qZeR9hoDHZQrdYZOJsFUs7jBmX0NYdmy9tTcx06VRGCaHpJJs4XTh8Jn0HmLGTXgasXh9eeCPDB0C1DZToGpaBktv/5DIvVHzJ98Fw6r20OUNvOn0seum3ZxpleT06MJ5yW2bE4tn/un93ch7n4iWUxOKSd928b+Pmpd6PQzeplKif+4UHE1m0W4VgErxI0jFkID+MJlzoj5u9kg1P6xVcqrmYoM1Fc+Gc7T4/4TxKxsyF1jTZPZAIbFiSEjEXJC9n3l/Ittkb
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[szeredi.hu,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-13678-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[groves.net];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@groves.net,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C157A2FA152
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 26/03/23 12:12PM, Jonathan Cameron wrote:
> 
> > > > diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> > > > index 5ed5c39857c8..3bae252fd1bf 100644
> > > > --- a/drivers/dax/Makefile
> > > > +++ b/drivers/dax/Makefile
> > > > @@ -5,10 +5,16 @@ obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
> > > >  obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
> > > >  obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
> > > >  
> > > > +# fsdev_dax: fs-dax compatible devdax driver (needs DEV_DAX and FS_DAX)
> > > > +ifeq ($(CONFIG_FS_DAX),y)
> > > > +obj-$(CONFIG_DEV_DAX) += fsdev_dax.o
> > > > +endif  
> > > 
> > > Why not throw in a new CONFIG_FSDAX_DEV and handle the dependencies
> > > in Kconfig?    
> > 
> > At one point I had another config parameter, but I'm trying not to
> > gratuitously add them. The fsdev driver is pretty small, and including it
> > whenever FS_DAX is enabled felt reasonable to me. I'm willing to change it
> > if there's a consensus that way.
> 
> You can make the build do exactly the same thing with a separate Kconfig
> option. Just moves where the dependency tracking is. I'd prefer Kconfig
> because that's generally where I'd look for something like this.
> 
> 
> Jonathan

OK, will do. It will be CONFIG_DEV_DAX_FSDEV for naming consistency.

V9 coming within 24 hours...

John


