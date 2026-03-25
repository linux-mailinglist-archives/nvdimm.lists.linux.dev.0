Return-Path: <nvdimm+bounces-13756-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEn0NVAOxGk+vgQAu9opvQ
	(envelope-from <nvdimm+bounces-13756-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 17:33:20 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 545BF329131
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 17:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6A3AD315E098
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2EB3EC2C4;
	Wed, 25 Mar 2026 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yu2nTqTr"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C635DA46;
	Wed, 25 Mar 2026 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774454991; cv=none; b=SlBPBkF9djCT/6K2pLu2WY+SfuTEKbymR5wENWIRLkHCsJUb+T8Kqo23JT9SGY7J/C4VH46PgbXOzYmpZ9Sm8sbPbuK2TKOExEeZOcgp5133kPhkc3p4n5e8a5dTmMlUqPCFMZ0oxwjGO91cPhaUFnPToqurEatTm+haD3btawM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774454991; c=relaxed/simple;
	bh=CpwACGnKbmh8bnL86Y86WsKuJUxg5abhUqwLWbX/48s=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZMRlEBEEP3Dr9JHGc2/npb4LH/invUrAbiCm+mXFlI2PKuBx2JlwWHaJS/pHKezbSdv7AZvYT08LrxCymTXSVZImEDl+RaeIcPQRSOPusLI7WxNKGb9kI1nr2YdhXSopokB+HGL8FOxBHeZCK+xVbsHGt1Hu3rFZIRN+fTrY5lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yu2nTqTr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBA3C4CEF7;
	Wed, 25 Mar 2026 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774454991;
	bh=CpwACGnKbmh8bnL86Y86WsKuJUxg5abhUqwLWbX/48s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yu2nTqTr+4Ixa0aIK77JmVd/k21R9kBHnAAnN62dMDBskTZPMj6ItigXaNiPWYaDN
	 owILDdRj9CR94Ne+mlXhFs0xeZET+j+BL7Wc2PyC7Y5JlWmPDlJwczr1b4LsYZy2nY
	 cP83/jsCsjO9VMlXX+z1yugQE+WA+BNaE8wcuZeA=
Date: Wed, 25 Mar 2026 09:09:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
In-Reply-To: <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[linux-foundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13756-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[suse.de,arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[akpm@linux-foundation.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[linux-foundation.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux-foundation.org:dkim,linux-foundation.org:mid]
X-Rspamd-Queue-Id: 545BF329131
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 25 Mar 2026 14:58:14 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> > On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > > macro) always being inline, as we rely on the compiler converting this
> > > function into meaningful.
> > 		meaningful what?
> 
> 'into the equivalent compile-time constant code' probably fine.
> 
> Andrew - could you update that if there's time?


np


: Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
: macro) always being inline, as we rely on the compiler converting this
: function into the equivalent compile-time constant code.

what does "compile-time constant code" actually mean?  That constants
within the code are evaluated at compile-time?

