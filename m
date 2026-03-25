Return-Path: <nvdimm+bounces-13748-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHG7G4b7w2k/vQQAu9opvQ
	(envelope-from <nvdimm+bounces-13748-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:13:10 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C193279E1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E9F833002B7A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 15:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6F73CEBBC;
	Wed, 25 Mar 2026 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvHMKGo7"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B2F3BBA05;
	Wed, 25 Mar 2026 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450411; cv=none; b=mK07xH2gzQLzz9uUPLiik8MY+V6AwgDbSaLmN4ePkzldlYAXp11H62CPTboekZWEyXJiwFZdjttvAqU3djUIHjeKeVlqE4QvXmvy1+928/CEDjUetAvkrQ2O/hbolW+WXy0Bkh2onjEw5HSdhiZdI0Ouz0zPSvvTfvX0p4iYQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450411; c=relaxed/simple;
	bh=pg9BGRjMnJsXPkM0swwEs/eI5ok+Dj8gFwFH1IOCh5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPvztXY0vqDgUBz1v6Lt/aDsjuZxvDLFsdHjBlc4kRQ06WqHqk32cKt6dfZIo+V9GIipoX9OfzcPF+3kddvJcPWoEF/hpBYQQn+Z1fB4vuBAtYIV8/liiJ4q3Uk97SePLxY9Cd2f8FNjDw6mFpRYA3QHfxPePXMijjDDssIdGp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvHMKGo7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1631AC4CEF7;
	Wed, 25 Mar 2026 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450411;
	bh=pg9BGRjMnJsXPkM0swwEs/eI5ok+Dj8gFwFH1IOCh5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvHMKGo7C2FvWUchrPoeFaP+aBjxBO1iDfBDPu1ftOdOR9CZZDLVUFhCz/c7WGA7e
	 why6Yw24IOjuRI1p2bP95VB6ClN3gKVLzT0jfMnfC6i/nYozQuCobhRSSwOyXF1N3e
	 byo4/RyWBj3jJuX+8109h+cusNOVoW1YRJJbnkzrjTlLtysvhWEr4e7NJhA0wos2+k
	 fx1cPkStcPHCC3jsOhMQDS1F6pwJ6xb82zQvvaulOqpwhrnvUJ/5TyvKvTmDP6MVMS
	 pJz6XV1MltczUwUgLDYNLrOBFtEIandUJarxRBC8UrloEnhtM8rgFwrglv5AFfDkkq
	 NMz0cLZrxbpPA==
Date: Wed, 25 Mar 2026 14:53:14 +0000
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
Subject: Re: [PATCH 1/6] mm: rename VMA flag helpers to be more readable
Message-ID: <f72132e1-a2a3-4445-80ec-adeb525dcfff@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
 <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13748-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,lucifer.local:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 63C193279E1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 02:51:04PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On reflection, it's confusing to have vma_flags_test() and
> > vma_desc_test_flags() test whether any comma-separated VMA flag bit is set,
> > while also having vma_flags_test_all() and vma_test_all_flags() separately
> > test whether all flags are set.
> >
> > Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
> > confusion.
>
> Hmm. The names are getting longer. We should fix this One Day.

:) yeha it's a bit of a trade-off still. But for now keeping it (fairly)
straightforward.

>
> >
> > Secondly, since the VMA descriptor flag functions are becoming rather
> > cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
> > rename vma_desc_test_flags() to vma_desc_test_any().
>
> >
> > Finally, rename vma_test_all_flags() to vma_test_all() to keep the
> > VMA-specific helper consistent with the VMA descriptor naming convention
> > and to help avoid confusion vs. vma_flags_test_all().
> >
> > While we're here, also update whitespace to be consistent in helper
> > functions.
>
> Extremely amazing patch! you were truly inspired!
>
>
> > Suggested-by: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

:) thanks, I don't know who could have suggested such an amazing idea, well I
won't read the tags to check + spoil the surprise... :>)

>
> --
> Pedro

Cheers, Lorenzo

