Return-Path: <nvdimm+bounces-13027-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKPbLXzKhWlAGgQAu9opvQ
	(envelope-from <nvdimm+bounces-13027-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 06 Feb 2026 12:03:24 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0843BFCF86
	for <lists+linux-nvdimm@lfdr.de>; Fri, 06 Feb 2026 12:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C73FC303DAEF
	for <lists+linux-nvdimm@lfdr.de>; Fri,  6 Feb 2026 11:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A5323E358;
	Fri,  6 Feb 2026 11:01:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771A232AAA0
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 11:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375702; cv=none; b=jUicjzH5rpYl93yFT+G3jEi0CUOz8rV5mxlUS65/XvGbpPKp2Ztjs2idJIyA/ktbs09O/UW1H57tLY6skpQlpad+kpPcAIy67Yuz7hOxJSB9Yo6Ey+VxRroHoltIInV8cEyJ/uQ7VcemzG9PNAlWgCPG7g9EeIf9EB3kTuPh8TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375702; c=relaxed/simple;
	bh=vQHDCHR79QOm8eSGZ/66eecyUpRaGnAyjLWS5Z+MS0o=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADWnEV7e9WO2wh8zwnUkK0V2sFak6bhTDy0Mj3uGFrtVDZzAWlpcTbvIoNbUIK9iwQDN0+yd2Dv8v9sIG5SiokgmdJpz56buave4KX9aCrZF8KE1P78M/P9r1vsJDps1pZwzr9OjFeZay7c/E/+apuinQY/yO5RsjfZhCXpgKtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6rjV3drJzJ46CH;
	Fri,  6 Feb 2026 19:00:46 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id ACA5540584;
	Fri,  6 Feb 2026 19:01:38 +0800 (CST)
Received: from localhost (10.47.70.160) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 11:01:37 +0000
Date: Fri, 6 Feb 2026 11:01:30 +0000
From: Alireza Sanaee <alireza.sanaee@huawei.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <20260206110130.00005fc2.alireza.sanaee@huawei.com>
In-Reply-To: <20260205174847.000065a4@huawei.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
	<698270e76775_44a22100c4@iweiny-mobl.notmuch>
	<aYNh-m8BEiOHKr9h@gourry-fedora-PF4VCD3F>
	<6983888e76bcc_58e211005e@iweiny-mobl.notmuch>
	<aYOVm6PVfmQdZvlI@gourry-fedora-PF4VCD3F>
	<20260205174847.000065a4@huawei.com>
Organization: Huawei
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.04 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[huawei.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-13027-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alireza.sanaee@huawei.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.985];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:mid,huawei.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0843BFCF86
X-Rspamd-Action: no action

On Thu, 5 Feb 2026 17:48:47 +0000
Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

Hi Jonathan,

Thanks for the clarifications.

Quick thought inline.

> > > I'm not clear if sysram could be used for virtio, or even needed.  I'm
> > > still figuring out how virtio of simple memory devices is a gain.
> > >     
> > 
> > Jonathan mentioned that he thinks it would be possible to just bring it
> > online as a private-node and inform the consumer of this.  I think
> > that's probably reasonable.  
> 
> Firstly VM == Application.  If we have say a DB that wants to do everything
> itself, it would use same interface as a VM to get the whole memory
> on offer. (I'm still trying to get that Application Specific Memory term
> adopted ;) 
> 
> This would be better if we didn't assume anything to do with virtio
> - that's just one option (and right now for CXL mem probably not the
> sensible one as it's missing too many things we get for free by just
> emulating CXL devices - e.g. all the stuff you are describing here
> for the host is just as valid in the guest.) We have a path to
> get that emulation and should have the big missing piece posted shortly
> (DCD backed by 'things - this discussion' that turn up after VM boot).
> 
> The real topic is memory for a VM and we need a way to tie a memory
> backend in qemu to, so that whatever the fabric manager provided for
> that VM is given to the VM and not used for anything else.
> 
> If it's for a specific VM, then it's tagged as otherwise how else
> do we know the intent? (lets ignore random other out of band paths).
> 
> Layering wise we can surface as many backing sources as we like at
> runtime via 1+ emulated DCD devices (to give perf information etc).
> They each show up in the guest as contiguous (maybe tagged) single
> extent and then we apply what ever comes out of the rest of this
> discussion on top of that.
> 
> So all we care about is how the host presents it.
> 
> Bunch of things might work for this.
> 
> 1. Just put it in a numa node that requires specific selection to allocate
>    from.  This is nice because it just looks like normal memory and we
>    can apply any type of front end on top of that.  Not good if we have a lot
>    of these coming and going.
> 
> 2. Provide it as something with an fd we can memmap. I was fine with Dax for
>    this but if it's normal ram just for a VM anything that gives me a handle
>    that I can memmap is fine. Just need a way to know which one (so tag).

I think both of these approaches are OK, but looking from developers
perspective, if someone wants a specific memory for their workload, they
should rather get a fd and play with it in whichever way they want. NUMA may
not give that much flexibility. As a developer it would prefer 2. Though you
may say oh dax then? not sure!
> 
> It's pretty similar for shared cases. Just need a handle to memmap.
> In that case, tag goes straight up to guest OS (we've just unwound the
> extent ordering in the host and presented it as a contiguous single
> extent).
> 
> Assumption here is we always provide all that capacity that was tagged
> for the VM to use to the VM.   Things may get more entertaining if we have
> a bunch of capacity that was tagged to provide extra space for a set of
> VMs (e.g. we overcommit on top of the DCD extents) - to me that's a
> job for another day.
> 
> So I'm not really envisioning anything special for the VM case, it's
> just a dedicate allocation of memory for a user who knows how to get it.
> We will want a way to get perf info though so we can provide that
> in the VM.  Maybe can figure that out from the CXL HW backing it without
> needing anything special in what is being discussed here.
> 
> Jonathan
> 
> > 
> > ~Gregory  
> 

