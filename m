Return-Path: <nvdimm+bounces-13735-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qL7IJbqKw2nJrQQAu9opvQ
	(envelope-from <nvdimm+bounces-13735-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 08:11:54 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2BA9320875
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 08:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02D9F307308A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 07:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFFC363C52;
	Wed, 25 Mar 2026 07:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+fi7yjA"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF3824336D;
	Wed, 25 Mar 2026 07:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774422514; cv=none; b=GkvqCiZFnazCMAhiofCezCTz5kHP1FqA5TrFkNrvfvqjabrV0r9bnbmNJpzEYAif1bh67mowGW477j1ocYvioaHltWdp6lKviaCjrP0zImikma4ubtzObfpa4Zt+7EcSigzZrl14qHPkVjzBJvMke6YneRtnE2QXGBOPJdi5hZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774422514; c=relaxed/simple;
	bh=wloUbny5iGf241ZcwoWfGI1G4epwXCE04slEJFNkwPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdqAmkzBdJvrLyNXyP5zi4CjywHwiM8HdqgAfYgXECPEz+BJBYxbvzVaoazsvSaAXZr4mvDmxAOtNIGqMrCc+LU6NwPOsSoBnQZ0RT58DURwb5sU6vUyTwrss9aI16GLf9fJ4CYN9szyxCLCHRBDNQpzMKLfpeCbFL+6bzCTuEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+fi7yjA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C979DC2BC9E;
	Wed, 25 Mar 2026 07:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774422514;
	bh=wloUbny5iGf241ZcwoWfGI1G4epwXCE04slEJFNkwPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+fi7yjAY4ZcZaA8Wmq+9ofwJ01X6R5BUulVmOdBiUMiJNXdz/KWVyrUVBvzgPCdG
	 2iIJ4CGzZ7IBbErqBjmBCXGf1CFvx3+fKZ147WGar3VzjtyTzRvfbEBNSup+q0+J7b
	 aPb6Ft2C7ojmFs8B8ou4LrMK94BCHWXKBqtTOB/U0rh+I+z+hMFm7l2vh+tpqjhKHZ
	 E1o19EK9/Tp01KDDdBMfljviCTxMfaIATpKElMbeNcU09W7rcU882ncXoUehokpWFR
	 /05zR6R0eEOzCsZDKcOave4LUSm3OuHObd65uQKuOZ1OkoMCXMj2iTdIe1ov7xt5cF
	 KwF5Hpr6IdeEQ==
Date: Wed, 25 Mar 2026 07:08:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
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
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13735-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lucifer.local:mid]
X-Rspamd-Queue-Id: F2BA9320875
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > it.
> >
> > While we're here, update the helper function comments to be more
> > consistent.
> >
> > Also add the same to the VMA test headers.
>
> fwiw, we have no review tags on this one.

Based on the discussion we had about this previously I was under the impression
if submitted by a maintainer that wasn't required?

I'll nag people, but I'm a bit surprised if this is why you haven't moved this
to mm-stable, given how trivially obviously correct this patch is.

Lorenzo

