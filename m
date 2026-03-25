Return-Path: <nvdimm+bounces-13741-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GIXeLoXBw2kRtwQAu9opvQ
	(envelope-from <nvdimm+bounces-13741-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 12:05:41 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CABD0323776
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 12:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 14A7F3017DCF
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 11:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF2E3C7DF7;
	Wed, 25 Mar 2026 11:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKfbEpL+"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5D13C4577;
	Wed, 25 Mar 2026 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436554; cv=none; b=rOMAlIKR3sQaIZUhbFRYlffFqOQqKhlFzKb0KDohNy/sa1eHdi0nDYJBRYST5uPZajOqRDMYNoH1LbhK4t3BfM73TkjdxcM6ESIEPyLZ9Xex4kzs+ZPrRnoCEbc3qUm7jG9PUIqXcJ/WoV59fBB4FoGSBHcHVtF5UTougyJx/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436554; c=relaxed/simple;
	bh=tHxS02jyuJdc7xck1OGm67X7JRYetEgUpHsHG3XgLZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUS9IHSn6w7w9bVCH3TXG8GkvIG3ZIlyTd3Yf+1w0/BwUbCN7+SXQKPcW9z3MqKdIenG8Imbl4MGUu9xDtrDysRBkK1aM/tzNZGcZRV2dYEWdG7vK1hFyF9wsRZg0+o91AgAsv5hoD1sC9Y01phb7bm640XkqPZqvLkP52Tlqhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKfbEpL+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A3EC2BCB0;
	Wed, 25 Mar 2026 11:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774436553;
	bh=tHxS02jyuJdc7xck1OGm67X7JRYetEgUpHsHG3XgLZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKfbEpL+QwqITDp7zft06nKiR08zsFI8szKsw2URrZAwiwXqMmi0+tBx1TGvpubXE
	 l1nTkzHyAQbNEBGfQ4nGrX3sKCiFHLJaYrjm5zqZQQQEwtQa6RkpNjHFptlR4PAZ9U
	 IpJ5JeE+RAZ2E9J1YM6Elt355aSIZj/LzRVBQ1/n1qqoMs/OD0sRpg05BMFqsbhi1S
	 Shw3TorVIm0rtJXQ5yVWpZX5z65od1QSnOK7gT/YAbbvBwHnt++ki1xhQcLDAMvu/F
	 g11ayMJaLiBZ/F7XKSiKEpI8doQgK5UkRrJQpjVo/DBAKu4Y4jcyhpVjyAsHbayxPG
	 UmZoSLixBLjOg==
Date: Wed, 25 Mar 2026 11:02:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <887da31d-96d0-493f-a248-28ae82925c4d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <d0111a86-7fc9-4e2f-b652-9ecbb894ada5@kernel.org>
 <9203050e-eda6-49a1-97b6-a134da2da313@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9203050e-eda6-49a1-97b6-a134da2da313@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13741-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linux-foundation.org,arndb.de,linuxfoundation.org,intel.com,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lucifer.local:mid]
X-Rspamd-Queue-Id: CABD0323776
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 09:58:53AM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 08:31, Vlastimil Babka (SUSE) wrote:
> > On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> >> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> >> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> >> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> >> it.
> >>
> >> While we're here, update the helper function comments to be more
> >> consistent.
> >>
> >> Also add the same to the VMA test headers.
> >>
> >> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > I thought I saw David review all of the series and so focused on other
> > stuff, didn't notice he skipped this one :)
>
> I think I skipped it because it looked too mechanical when scanning and
> I was like "ofc I trust Lorenzo on that one blindly". So I missed to reply.
>
> Tag provided now if it helps.

Thanks guys! Appreciated.

