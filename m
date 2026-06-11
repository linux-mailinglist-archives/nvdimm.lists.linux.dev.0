Return-Path: <nvdimm+bounces-14392-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id TOz6KgbZKmosyAMAu9opvQ
	(envelope-from <nvdimm+bounces-14392-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:49:26 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 212A5673322
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:49:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6EF6FgH;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14392-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14392-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61D1B30F74F3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 15:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CC93E173B;
	Thu, 11 Jun 2026 15:48:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5283C3E1232;
	Thu, 11 Jun 2026 15:48:31 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781192912; cv=none; b=b3bglH/C3+AoJ4Zmixs0MqiIha1n08tBnSXst85CxL3II/ph0Ix2u4YuMqZisfWwaij2ODQpojffN0wHrKKALZlAB0uDumns0YrDN3CHfr5/2w6TrNNhSdQd4jEav2OJ0lC/qG7tfAE2e0D5hld9MqphvlgLY/SzqUC75QwkBiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781192912; c=relaxed/simple;
	bh=AusiidLJ4BcR6Vf/GqBMRYHsS7ncfvlwxVRfd9iGWDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qq7YHT6PjBI+IENCM+9x945Sp1wZHOE5DGCuwTjkgrb7lu6qKB2cc7WR1xuheaKiWkjOd4Im6MU7KTQ1PuBOk+ibAuvQvfzaIUILqOjg5fwPn4RLBhBYhfjwE1h11J+mVWKoGo26JGt+y14VnLaOM+l3IeGxiGpwhuoOehlJSTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6EF6FgH; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17AF1F00893;
	Thu, 11 Jun 2026 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781192911;
	bh=HBvAqwwTuPGJHrKKc5GFDgJPlZ5f0pQvznn9wCUyMaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6EF6FgHYrs/31xuVF51ER+noevDG4Op75I4vqpITfj3S2EEx77ei3Z89Wuqrs8nr
	 QjDS6ioCpl5RGVDAgKPOU6K+H4M+ZifNQRlRdnKKvX8aKqx4A9W5C/FSUA+vfmdWxo
	 hH9lBYYZDgif0UlMMeqvq+nh8XUOA6nUrABTeRH06wfDtG+DAy8l5DFTKkL21AVqv2
	 6f98I0HO/mmOd4zqei8T8mkUF31udInZf/k0URqi3hkCwVW7y9NYOPQcOTqZ2OVf4m
	 r6dR+8WZjlbfUW57TJs65TavBKzMMzL57us7e0Y87G/VmSlJivMqyxBKlEkGN3OEGd
	 RnI7QWJNtyPgw==
Date: Thu, 11 Jun 2026 16:48:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, muchun.song@linux.dev, 
	osalvador@suse.de, david@kernel.org, surenb@google.com, mjguzik@gmail.com, 
	liam@infradead.org, vbabka@kernel.org, shakeel.butt@linux.dev, rppt@kernel.org, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, linux@armlinux.org.uk, 
	dinguyen@kernel.org, schuster.simon@siemens-energy.com, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, djbw@kernel.org, willy@infradead.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, james.clark@linaro.org, 
	mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linmiaohe@huawei.com, nao.horiguchi@gmail.com, jannh@google.com, 
	riel@surriel.com, harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 3/4] mm/fs: split the file's i_mmap tree
Message-ID: <airVLmVdVRDOlZm4@lucifer>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-4-huangsj@hygon.cn>
 <aiqFgGbIo1Psy3pI@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiqFgGbIo1Psy3pI@pedro-suse.lan>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14392-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:huangsj@hygon.cn,m:pfalcato@suse.de,m:akpm@linux-foundation.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:jack@suse.cz,m:muchun.song@linux.dev,m:osalvador@suse.de,m:david@kernel.org,m:surenb@google.com,m:mjguzik@gmail.com,m:liam@infradead.org,m:vbabka@kernel.org,m:shakeel.butt@linux.dev,m:rppt@kernel.org,m:mhocko@suse.com,m:corbet@lwn.net,m:skhan@linuxfoundation.org,m:linux@armlinux.org.uk,m:dinguyen@kernel.org,m:schuster.simon@siemens-energy.com,m:James.Bottomley@hansenpartnership.com,m:deller@gmx.de,m:djbw@kernel.org,m:willy@infradead.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:mark.rutland@arm.com,m:alexander.shishkin@linux.intel.com,m:jolsa@kernel.org,m:irogers@google.com,m:adrian.hunter@intel.com,m:james.clark@linaro.org,m:mhiramat@kernel.org,m:oleg@redhat.com,m:ziy@nvidia.com,m:baolin.wang@linux.alibaba.com,m:npache@redhat.com,m:ryan.roberts@arm.com,m:dev.jain@arm.com,m:baohua@kernel.org,m:lance.yang@
 linux.dev,m:linmiaohe@huawei.com,m:nao.horiguchi@gmail.com,m:jannh@google.com,m:riel@surriel.com,m:harry@kernel.org,m:will@kernel.org,m:brian.ruley@gehealthcare.com,m:rmk+kernel@armlinux.org.uk,m:dave.anglin@bell.net,m:linux-mm@kvack.org,m:linux-doc@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-arm-kernel@lists.infradead.org,m:linux-parisc@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:zhongyuan@hygon.cn,m:fangbaoshun@hygon.cn,m:yingzhiwei@hygon.cn,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[suse.de,linux-foundation.org,zeniv.linux.org.uk,kernel.org,suse.cz,linux.dev,google.com,gmail.com,infradead.org,suse.com,lwn.net,linuxfoundation.org,armlinux.org.uk,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,arm.com,linux.intel.com,intel.com,linaro.org,nvidia.com,linux.alibaba.com,huawei.com,surriel.com,gehealthcare.com,bell.net,kvack.org,vger.kernel.org,lists.infradead.org,lists.linux.dev,hygon.cn];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[ljs@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[65];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm,kernel];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lucifer:mid,lists.linux.dev:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 212A5673322

On Thu, Jun 11, 2026 at 12:11:27PM +0100, Pedro Falcato wrote:
> Hi,
>
> On Thu, Jun 11, 2026 at 02:18:59PM +0800, Huang Shijie wrote:
> > In the UnixBench tests, there is a test "execl" which tests
> > the execve system call.
> >   For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > When we test our server with "./Run -c 384 execl",
> > the test result is not good enough. The i_mmap locks contended heavily on
> > "libc.so" and "ld.so". The i_mmap tree for "libc.so" can be
> > over 6000 VMAs, all the VMAs can be in different NUMA mode. The insert/remove
> > operations do not run quickly enough.
>
> I _really_ would have appreciated some coordination here, because I said I was
> going to take a look at it. I have something that I think is much simpler

Agreed, this is the second (or in fact third?) time in recent weeks that
I'm aware of where publicly discussed work has been duplicated with a
series that came in later.

It's really important, when doing work that impact core stuff to have a
look around and see if others are looking at it, as there's nothing more
frustrating than to work on something, discuss it publicly, only to find
somebody sends a competing series.

It can be tricky, as sometimes it's not obvious, or it might not be so
easily found, but I would strongly suggest always making an effort on that
front.

But you didn't even try to send this as an RFC either :)

> in practice. These patches are also way too complex to be dropped just before
> the merge window.

This late in the cycle means -> next cycle. So you'd have needed to resend
it at rc1 in a couple weeks anyway.

>
> Some comments:
>
> >
> >  In order to reduce the competition of the i_mmap lock, this patch does
> > following:
> >    1.) Split the single i_mmap tree into several sibling trees:
> >        Each tree has a lock. The CONFIG_SPLIT_I_MMAP is used to
> >        turn on/off this feature.
>
> There is no need for a config option. This needs to Just Work.

Yeah, this is just a no-go. We don't add config options for changes to core
rmap code.

>
> >    2.) Introduce a new field "tree_idx" for vm_area_struct to save the
> >        sibling tree index for this VMA.
>
> This is possibly contentious, but there are holes in vm_area_struct.
> So I think this is fine.

Yeah no thanks for the extra field, I already have plans for those gaps in
vm_area_struct.

I am in fact writing code right now that uses them...

>
> >    3.) Introduce a new field "vma_count" for address_space.
> >        The new mapping_mapped() will use it.
> >    4.) Rewrite the vma_interval_tree_foreach()

I also intend to send a series that does a bunch of changes in the rmap
code that this would conflict with.

So let's all coordinate please.

> >    5.) Rewrite the lock functions.

Yeah looping on file rmap lock/unlock is gross.

> >
> >  After this patch, the VMA insert/remove operations will work faster,
> > and we can get over 400% performance improvement with the above test.
> >
> > Signed-off-by: Huang Shijie <huangsj@hygon.cn>

I had a look through and this code is really overwrought and you're putting
a bunch of confusing open-coded all over the codebase without comments.

This isn't upstreamable quality and you really should have sent this as an
RFC first so we could discuss the approach.

Thanks, Lorenzo

