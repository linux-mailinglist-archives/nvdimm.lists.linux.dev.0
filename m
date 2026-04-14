Return-Path: <nvdimm+bounces-13878-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGCrET1c3mlfCQAAu9opvQ
	(envelope-from <nvdimm+bounces-13878-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Apr 2026 17:24:45 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9266E3FBBFD
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Apr 2026 17:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BC813039CBF
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Apr 2026 15:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E2C3E9296;
	Tue, 14 Apr 2026 15:24:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7292D0C98
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180247; cv=none; b=Uvn/bknLflxbU2T6Pfw4ESwtfEFz/Zp64AIE8EzbxdP5GXpKc8aIPEiOIjUViJH0ZzPAzVVulmk2EGpC5jhG1PaFhg6asgFSNPG4qcMRnT5xqjN//hLldz939y32p6WHM/EXQu7ScJLQMz2UTgQ7bI1gGneJ+/XiZV4sN9nZhUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180247; c=relaxed/simple;
	bh=sDKLF81P7X0rSH9QLJyWkhlANiplPSnzbflXNreb7VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6E87UtiuCb+1qzsMqfYkfG1ivreYUisW6kDN7c4SppAWczeSG/92xAHNoZZmeA75ZAW6SDtbVbQJrrGeC15z8u8vkEPDGHLGAOfuanJRf8UTUz2TAU4odHkwGaEQJdDFtWdOuBa4xPZOduPXVTV/VYqO1x7hpHdBe8p77N1EB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1381350DCD;
	Tue, 14 Apr 2026 15:24:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf03.hostedemail.com (Postfix) with ESMTPA id D06246000A;
	Tue, 14 Apr 2026 15:23:49 +0000 (UTC)
Date: Tue, 14 Apr 2026 10:23:48 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <ad5bpK3h9woM9XgW@groves.net>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <CAJfpegsCoMMg-Ux3CbBh0d1uqDNg3Fu_8YE-LubwrQ6A-2Cggw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsCoMMg-Ux3CbBh0d1uqDNg3Fu_8YE-LubwrQ6A-2Cggw@mail.gmail.com>
X-Stat-Signature: xr8xh36476psstk8w4ckif649iyrphm6
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18ObgszvpeQJhZtO3GiUPb9fpEN5kDCcM0=
X-HE-Tag: 1776180229-353483
X-HE-Meta: U2FsdGVkX1/GjWD1QMH6GjnuMOs4TmlAbCvDMSWjC9e9EecvLnUXTz9QOvU7FTdli+62crx8/ao39hY9VJHu5ID2P8lHUBiq9eASND+NObUgsnB6PwXzrn4A0VyHo0aL2fNRb6i7jDKg1mwGLwkUpyEm9Dhq6HVM2C/UBjrAH5UobEmVMYOotsCR1r+bqSu9V6KE/c2fudY25mZGNybf9Ovn4Yh2r6QQgYhW3v7fR/W/T1KzAL73gCpirABiggJ3VsDuE6edjlL+XcXhOVXACKo1RPGRqcedKLZDU8/w0jT0dG9R9BPhA32ynLgquGl2tw1CmQuuzqjoniU7kVaYAFIOkMR489QEi7RmUsRqofbGrvNSmePTsLGhyZ65m2Bt
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,bsbernd.com,jagalactic.com,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13878-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[groves.net];
	RCPT_COUNT_TWELVE(0.00)[41];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,groves.net:mid,groves.net:email]
X-Rspamd-Queue-Id: 9266E3FBBFD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 26/04/14 04:18PM, Miklos Szeredi wrote:
> On Tue, 14 Apr 2026 at 15:41, John Groves <John@groves.net> wrote:
> 
> > My short response: Noooooooooo!!!!!!
> 
> :) Seems like this is a highly emotional topic...  I suggest that we
> go ahead with bpf experiments, then discuss results and path forward
> at LSM.
> 
> Thanks,
> Miklos

I think we need to try to emergency-add a session at LSFMM on this, with
fs/mm/bpf people. Any ideas on how to do this?

John


