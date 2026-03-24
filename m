Return-Path: <nvdimm+bounces-13731-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKSrGIMaw2kuoQQAu9opvQ
	(envelope-from <nvdimm+bounces-13731-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 00:13:07 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB78D31DA7E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 00:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55C513040445
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 23:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7673CA484;
	Tue, 24 Mar 2026 23:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLTwz3SH"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B21E3C7DF4;
	Tue, 24 Mar 2026 23:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774393935; cv=none; b=QOtMkMeQW2kiJJST9laz+vTkIjSbSYaDT0Ef85SsQZQr+47pyeXsqXL6VUCKHqjAYrrp0lrjfIPhVF6LmiWe4xuL++6j7GBO1F959yeFFYdqAaO4x/w5v4OzetJV6y50JeIVfAU7i4Br3DUO5MRF0Cvkj0GvI7oUUAIfOzr8xps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774393935; c=relaxed/simple;
	bh=ptwwHbLCf3qQFNvLf2dqckDDyShAhKmxD+qHZ2Ems8w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=NnuqjZnFPrUZWa4Csh4idqvFOFSziILSRHoa/QiMksnqieDciSsxb0aUtmf5W13PK0AyshTPLKfn4jIGloy4Gtcu43cAS/8e3ptvyh/m7HBF+RfgvqkWHLMTNqrW/7AxEKaGVHYi8I43Ebc1GPu3SDolba7rXNuD0TsP0rKfvYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLTwz3SH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B43C2BCB1;
	Tue, 24 Mar 2026 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774393934;
	bh=ptwwHbLCf3qQFNvLf2dqckDDyShAhKmxD+qHZ2Ems8w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QLTwz3SHw1yDMUT8EK0RImQOiTezzgyIr6GaoUCK96d78VHIYEHGoiZrsBICY0RY4
	 prdPg7dDS7EU+/v8oFdgaCjXtOnqW1Knnhb837S/tRUqZeShz4gGiX5ErTjUgItBsG
	 VAlZfcP28RfcIDXSiBthAZwtM/tBDNz0XMg79lmI=
Date: Tue, 24 Mar 2026 16:12:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-Id: <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
	<568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[linux-foundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13731-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[akpm@linux-foundation.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[linux-foundation.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux-foundation.org:dkim,linux-foundation.org:mid]
X-Rspamd-Queue-Id: BB78D31DA7E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.

fwiw, we have no review tags on this one.

