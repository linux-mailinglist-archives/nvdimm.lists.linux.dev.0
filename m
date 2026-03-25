Return-Path: <nvdimm+bounces-13758-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UG/RHp8OxGk+vgQAu9opvQ
	(envelope-from <nvdimm+bounces-13758-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 17:34:39 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0246532916E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 17:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AECF231C6DBE
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1133F0AB5;
	Wed, 25 Mar 2026 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSBG0LH7"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405083EE1D3;
	Wed, 25 Mar 2026 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774455845; cv=none; b=SZWSYval928w+ZZO9Lm93I41r3+3Y/eNxtm3sGYqHkmk+dpaJh73BlsAyI0WIOd7Qky4ouu6W/BjUAOYOhe7xGTwcdvVLU48ADMHZeU0tIMOCNjOU/cLQGO2lDA3KEQfjNp61JOU4dIScwPKFLtxRI1dnbv43dqQT3PPFdv9phI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774455845; c=relaxed/simple;
	bh=6GGVqV2Zd7+GdOihEp+etPbPztUZ47vsPoYBsuWNUJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToHDzpl1/w9croN3/Yt6iOwn0Do4s/TGUnZY+kNXSKPsSKodVHZnm8xgAP2u6FcE+HI2viYOzTNZdNu7o4ynNMxYpMPpgZSnCGb3gjwPfMjML0NH8TPd9OwXnk72mvhUNr26+U3od+b/mc37eHZsQP01juSBGaxtKko16sbp7iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSBG0LH7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D21C19423;
	Wed, 25 Mar 2026 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455844;
	bh=6GGVqV2Zd7+GdOihEp+etPbPztUZ47vsPoYBsuWNUJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSBG0LH7Uew3Sjq4jNxlJrWFyT3Tna+tc7X4kVxxF6w8nzX8eer3lHMZB4zswcXfP
	 xjHkzOmcSkmxm5eq/3iXOohApbujl5UruoOAbbfHvSjozo44xQoYWVhODuTf8D4ju/
	 nswtqxxY1kL35DBhTNfPo8+tdKnNJWFnrh75P90LL0UiKYaoZJsqSgFN8aWmgBP6Yd
	 Jo+unrnO+Cm3t2c9upMUBSuKZyea42E3Gj+JOALgQJRcR8Hg2sh+qphdGAvmbalo2h
	 LRQWxtM1B5CccqDCpGhuKpefdNbdPDiDGiXiEOVqRKqyR2IZ20vieNQOs5dGac3Dbc
	 dhKvxI1+xXZ4A==
Date: Wed, 25 Mar 2026 16:23:53 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
 <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
 <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13758-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lucifer.local:mid]
X-Rspamd-Queue-Id: 0246532916E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 09:09:49AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 14:58:14 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> > > On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > > > macro) always being inline, as we rely on the compiler converting this
> > > > function into meaningful.
> > > 		meaningful what?
> >
> > 'into the equivalent compile-time constant code' probably fine.
> >
> > Andrew - could you update that if there's time?
>
>
> np
>
>
> : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> : macro) always being inline, as we rely on the compiler converting this
> : function into the equivalent compile-time constant code.
>
> what does "compile-time constant code" actually mean?  That constants
> within the code are evaluated at compile-time?

Yeah, so effectively the compiler rewrites:

x = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);

To:

x = (1UL << VMA_READ_BIT) | (1UL << VMA_WRITE_BIT);

And then:

x = 3;

Various efforts at checking generated assembly has confirmed this.


Maybe 'into an inline constant value' is better?

Thanks, Lorenzo

