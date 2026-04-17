Return-Path: <nvdimm+bounces-13909-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iARuN7jb4WkXzAAAu9opvQ
	(envelope-from <nvdimm+bounces-13909-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 09:05:28 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C2D417A66
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 09:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 181E5308E43F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 07:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC58C3396F4;
	Fri, 17 Apr 2026 07:00:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF0B1B4F0A
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 06:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776409212; cv=none; b=oIErM8NQlAHMHHmywx87z+z5B/yo9yzjHYDALqj1Ntkm4d55tGMNs6VIyRf7wcrbI2Rx7xAK/se/B39GHqlzeEfMYP2+aua9pCkbpStf6qa5i0PeroXhNGzVivjl27LmYlyrCKlpZ6B/aT4WaQZGLIKxCdT2RWq0tY3YoLlayDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776409212; c=relaxed/simple;
	bh=2Qm1k46QeaCwP3PmXiD2vvdZ0MLoC5zsmI9lok6yqpc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGB/uIFGXUWHW9hc9gS2JChprkghtXCkPpNsa1dep87wvKvfkq0C2n4XNyEp6H7tE7VcLb909cLsn4N4BZno9xgC4kbSE0VsPFSA2h0F4I0Wp3zUupXuRM75OREanuJ7veTECWNqHzVY5dFaJrIMUWRFFjnVWPyYdGqq6zbeueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fxm355c3TzwvXZ;
	Fri, 17 Apr 2026 14:59:45 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fxm342Yk4zvkdy;
	Fri, 17 Apr 2026 14:59:44 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1F23A16E2;
	Fri, 17 Apr 2026 14:59:44 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 17 Apr
 2026 14:59:42 +0800
Date: Fri, 17 Apr 2026 14:59:41 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Mateusz Guzik <mjguzik@gmail.com>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <aeHaXXB2+mla7u2F@hsj-2U-Workstation>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[hygon.cn : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13909-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[huangsj@hygon.cn,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 61C2D417A66
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > In the UnixBench tests, there is a test "execl" which tests
> > the execve system call.
> > 
> >   When we test our server with "./Run -c 384 execl",
> > the test result is not good enough. The i_mmap locks contended heavily on
> > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > The insert/remove operations do not run quickly enough.
> > 
> > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > patch 3 splits the i_mmap into sibling trees, and we can get better 
> > performance with this patch set:
> >     we can get 77% performance improvement(10 times average)
> > 
> 
> To my reading you kept the lock as-is and only distributed the protected
> state.
> 
> While I don't doubt the improvement, I'm confident should you take a
> look at the profile you are going to find this still does not scale with
> rwsem being one of the problems (there are other global locks, some of
> which have experimental patches for).
> 
> Apart from that this does nothing to help high core systems which are
> all one node, which imo puts another question mark on this specific
> proposal.
> 
> Of course one may question whether a RB tree is the right choice here,
> it may be the lock-protected cost can go way down with merely a better
> data structure.
> 
> Regardless of that, for actual scalability, there will be no way around
> decentralazing locking around this and partitioning per some core count
> (not just by numa awareness).
> 
> Decentralizing locking is definitely possible, but I have not looked
> into specifics of how problematic it is. Best case scenario it will
> merely with separate locks. Worst case scenario something needs a fully
> stabilized state for traversal, in that case another rw lock can be
> slapped around this, creating locking order read lock -> per-subset
> write lock -- this will suffer scalability due to the read locking, but
> it will still scale drastically better as apart from that there will be
> no serialization. In this setting the problematic consumer will write
> lock the new thing to stabilize the state.
For your proposal in no-numa, I hope you can create a patch set for it.
I can test it in our machine.

Thanks
Huang Shijie


