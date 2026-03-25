Return-Path: <nvdimm+bounces-13752-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CZcOysFxGnOvQQAu9opvQ
	(envelope-from <nvdimm+bounces-13752-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:54:19 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B55D3287E6
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 16:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2935732EE13D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 15:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D668F3FE359;
	Wed, 25 Mar 2026 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IhruEwm7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pyz7FTFK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IhruEwm7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pyz7FTFK"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296653CF663
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450733; cv=none; b=McOvaDA9vVyFyQ7rjzRe3FRyDEa/X6KhGkyJR21CHvdPv5Gs5wbvApSAifm8BYLlNZzDiOLz4+4rET3XXfuZnYi204oJGvov7yMm6+lUO2u2EocvK/OfEkisZIsgkhrFp/n5Tbp4n98xtWOfnzLHXp4OLvHGC6FiaABqWfr3Tm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450733; c=relaxed/simple;
	bh=F1JvlcFjmOzNOcvH/pBiGie9jQZ4EwHJltK/maFZIvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bla4M3tvGjb87Oi77biHDCb1A5jIz+yDyjEwr7qpSuSiZe+i9CKG9n3MHZCyPMJgMfGFqsdqHeNe9zBQyRRtZ6pb9bD5L9Ryb5VuKqyOdZdqPiw25AP719ybZpgPBnjMUYBpQmPMZ0RKYjT3iKxYMluQpa8jJvbQqgOEbqJeWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IhruEwm7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pyz7FTFK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IhruEwm7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pyz7FTFK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E3734D247;
	Wed, 25 Mar 2026 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=IhruEwm7GYgYiYdj14/ihXFaqlkQSYC9mJzbZEysOgULoLEYc2th5nMp30ovZGWxl6scH9
	VdKlgBokFm+JYe99fBAmGMdwcFB/jXWuYdNtgJ0Kp4Q2puyNmhT7wAu5U/54EYpY7SC3QQ
	8kJnz33VQL3afgG9AY4l6hrcUQuCiEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=pyz7FTFKDSPa38IybHttOLNkOCxY8GUGNa+tVSLpg0w3uGkk7fONUm1DgIECQNVtgiV0pG
	s838nfi0QtNQzJBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IhruEwm7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pyz7FTFK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=IhruEwm7GYgYiYdj14/ihXFaqlkQSYC9mJzbZEysOgULoLEYc2th5nMp30ovZGWxl6scH9
	VdKlgBokFm+JYe99fBAmGMdwcFB/jXWuYdNtgJ0Kp4Q2puyNmhT7wAu5U/54EYpY7SC3QQ
	8kJnz33VQL3afgG9AY4l6hrcUQuCiEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=pyz7FTFKDSPa38IybHttOLNkOCxY8GUGNa+tVSLpg0w3uGkk7fONUm1DgIECQNVtgiV0pG
	s838nfi0QtNQzJBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B017944466;
	Wed, 25 Mar 2026 14:58:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gDSRJyf4w2mXZwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:58:47 +0000
Date: Wed, 25 Mar 2026 14:58:46 +0000
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
Subject: Re: [PATCH 5/6] mm: reintroduce vma_desc_test() as a singular flag
 test
Message-ID: <kci3actvfoj2rc2i6znf2ff24yu5q7ewgo2byqegmhjiv7ptzy@4ppp3xt5mwq2>
References: <cover.1772704455.git.ljs@kernel.org>
 <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13752-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6B55D3287E6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 05, 2026 at 10:50:18AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Similar to vma_flags_test(), we have previously renamed vma_desc_test() to
> vma_desc_test_any(). Now that is in place, we can reintroduce
> vma_desc_test() to explicitly check for a single VMA flag.
> 
> As with vma_flags_test(), this is useful as often flag tests are against a
> single flag, and vma_desc_test_any(flags, VMA_READ_BIT) reads oddly and
> potentially causes confusion.
> 
> As with vma_flags_test() a combination of sparse and vma_flags_t being a
> struct means that users cannot misuse this function without it getting
> flagged.
> 
> Also update the VMA tests to reflect this change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Similarly LGTM.

-- 
Pedro

