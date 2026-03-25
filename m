Return-Path: <nvdimm+bounces-13746-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGGaDEv8w2lXvQQAu9opvQ
	(envelope-from <nvdimm+bounces-13746-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:16:27 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C66B4327AE9
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F5BE33594A9
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 14:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35243F99C5;
	Wed, 25 Mar 2026 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HWmOZ5Fg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u14cIhOK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HWmOZ5Fg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u14cIhOK"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE023FE665
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450278; cv=none; b=FNnKAPHIIgXp7HoXr8iCoqPGo56xhFpuBMl9EfPZdyEyvFa3pTyXetO3fBbfJ9GVzblYcVaqYPlhxJvrgrMv9Rn02yp0ibBqH904u+4G5cJUHl8Dj+YD7aMVP42K+1pU/JQSoNXhUYX+c8b1UJmelzgoknTf6wSdp1+pGsHqhNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450278; c=relaxed/simple;
	bh=l2Lc7ADbwtGwZrTrSy5HTL6YFd1Zh1tOw1yK+YRZ9MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSZwp9XrRiaqDjqIHhCrVz/f0ghQRgeDWTYazyG5F1j5AMzfYNY7NX0FNCEJdKciHVeuLAEB7V0kbHEYvgC0GEdxRMBfBmeFZ+vaiuGZikwI5Tt24qLQY9z/pPGj4LvgQkeoB3+7PYoZtgDHb0Kly1d4UxNPsL6C7JHYBybv2Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HWmOZ5Fg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u14cIhOK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HWmOZ5Fg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u14cIhOK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63F235BD52;
	Wed, 25 Mar 2026 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=HWmOZ5FgwDtrteSM2Ew5PXqlKiEfNmaAxZwNcrDu5cm7qqyNqx+T4KuS+fzLrhGhLe0BMw
	4jK5lnRLUqHsAlBFQz+I+hBfsPpC3uQ9V4D0BKTscU6LcEG3GYwivCMcvxhC1hemevb4sH
	uOKbUkmNtRHNhlJlq6nBbg/lY2lzSfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=u14cIhOKRc22D/k23HZ0bIZUBPARER5TAWoWA++mI3iuA8hY3F7HH/iLi3+LZe1XvB+eno
	2GHcX4DZFxOCZCDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=HWmOZ5FgwDtrteSM2Ew5PXqlKiEfNmaAxZwNcrDu5cm7qqyNqx+T4KuS+fzLrhGhLe0BMw
	4jK5lnRLUqHsAlBFQz+I+hBfsPpC3uQ9V4D0BKTscU6LcEG3GYwivCMcvxhC1hemevb4sH
	uOKbUkmNtRHNhlJlq6nBbg/lY2lzSfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=u14cIhOKRc22D/k23HZ0bIZUBPARER5TAWoWA++mI3iuA8hY3F7HH/iLi3+LZe1XvB+eno
	2GHcX4DZFxOCZCDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7C9A4445E;
	Wed, 25 Mar 2026 14:51:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zMJkKVr2w2nWXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:51:06 +0000
Date: Wed, 25 Mar 2026 14:51:04 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
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
Message-ID: <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
References: <cover.1772704455.git.ljs@kernel.org>
 <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13746-lists,linux-nvdimm=lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pfalcato@suse.de,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.de:dkim,suse.de:email]
X-Rspamd-Queue-Id: C66B4327AE9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 05, 2026 at 10:50:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On reflection, it's confusing to have vma_flags_test() and
> vma_desc_test_flags() test whether any comma-separated VMA flag bit is set,
> while also having vma_flags_test_all() and vma_test_all_flags() separately
> test whether all flags are set.
> 
> Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
> confusion.

Hmm. The names are getting longer. We should fix this One Day.

> 
> Secondly, since the VMA descriptor flag functions are becoming rather
> cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
> rename vma_desc_test_flags() to vma_desc_test_any().

> 
> Finally, rename vma_test_all_flags() to vma_test_all() to keep the
> VMA-specific helper consistent with the VMA descriptor naming convention
> and to help avoid confusion vs. vma_flags_test_all().
> 
> While we're here, also update whitespace to be consistent in helper
> functions.

Extremely amazing patch! you were truly inspired!


> Suggested-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

