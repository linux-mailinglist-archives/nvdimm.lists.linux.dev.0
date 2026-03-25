Return-Path: <nvdimm+bounces-13754-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EK1wNgf+w2lXvQQAu9opvQ
	(envelope-from <nvdimm+bounces-13754-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:23:51 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E94DC327DA4
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 938B231010C2
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 15:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9434035CF;
	Wed, 25 Mar 2026 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o5xu8osK"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0919C3E63B7;
	Wed, 25 Mar 2026 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450934; cv=none; b=O8urehb/9xfMuTUV82xk8H3CB0seakdINyjQPWX6HjfTHUBlaffhTVZTXaqiogFb94dUcsr1FsDdeswUgft60h5ZtlHmYPhaE0uRva2XGGBNtWucWS0rbQZ5HQLdzC6YiVy2635jrERGq2qrdWrCACrXoufmgJeulnjOtCsqAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450934; c=relaxed/simple;
	bh=ABEIty5HU/Iuw2OOS0KrKkDWBoGWz4KSwuxsAu6g60o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKRqXtysqIrGf+7D3Gcj9shxGI8v//TBrNQPcjrA2UD2dBTTp3rXiA27IFF+8FoBnAqVKpqAwMd9wPC3yQszRYMK80zISmZTV5fWLgIF8Jzaov5locwlriurFUQY1ldF8XUJwQNPpgWJzTS0SzTeOJc2zM3P3wSup0J2xDN13Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o5xu8osK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65A8C19423;
	Wed, 25 Mar 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450933;
	bh=ABEIty5HU/Iuw2OOS0KrKkDWBoGWz4KSwuxsAu6g60o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o5xu8osKy2dzrUDPwu5yoQjTng5YdYUL3822flT0paQIdg9e/BTFYyiUK9l+GQOaG
	 daL6PA8y7R/LiFqAwSF8+W30Ek/zrLCrpDZbuIxfPHWd722GOizks/sJQPO3WIHKiY
	 CfDNk4/1DVhqBnJgdYHY0uK3+4lwi7i9/0fMohc3KEBmauqq+wXvQYmkggDaiV/9jd
	 n0MQgsXT85KVQtgfFBS2M0U4e06lcMT25UiDWCpuonb6xPhwOwgSeYvD8zeYqx0TuD
	 fdzP7hlGmXznOEkuM8BsQ5FWz7XNoTgdBwslAWj6jJVjwgry1e8erDJNwQxk0gKP2h
	 dThIHrt9f4cog==
Date: Wed, 25 Mar 2026 15:02:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag
 test
Message-ID: <93f1aa28-1c1f-419e-ba9d-c4b9204336e6@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
 <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13754-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lucifer.local:mid]
X-Rspamd-Queue-Id: E94DC327DA4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 02:57:22PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:17AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
> > clear as to what we are in fact testing, we now have the opportunity to
> > bring vma_flags_test() back, but for explicitly testing a single VMA flag.
> >
> > This is useful, as often flag tests are against a single flag, and
> > vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
> > confusion.
> >
> > We use sparse to enforce that users won't accidentally pass vm_flags_t to
> > this function without it being flagged so this should make it harder to get
> > this wrong.
> >
> > Of course, passing vma_flags_t to the function is impossible, as it is a
> > struct.
> >
> > Also update the VMA tests to reflect this change.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> This is a lot nicer, though I am wondering if there is any difference in
> codegen as well...

Not that I could tell, this was more about cromulence.

>
> --
> Pedro

Thanks, Lorenzo

