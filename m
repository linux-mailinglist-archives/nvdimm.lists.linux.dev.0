Return-Path: <nvdimm+bounces-11589-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21617B52C53
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Sep 2025 10:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BF7B1BC6F59
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Sep 2025 08:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13162638AF;
	Thu, 11 Sep 2025 08:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H06dORKL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0iIQ+Ipq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H06dORKL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0iIQ+Ipq"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D592E7185
	for <nvdimm@lists.linux.dev>; Thu, 11 Sep 2025 08:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757580952; cv=none; b=RDYOXQypHEX8vCgzvWMxwgmy3ftm92lS+3k3712hRUkflS/Vd0RyWL+d9i3glX3RWysZBfCX9vN6OFiYUNrWnxXCSiWbV/pNCVQHwtyWaFBNj5G2A+GODBlKyFdtUaDtKu7xy45NIsTvU3uDdrtLhB02dv/gLRrpy+sxk6Se1jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757580952; c=relaxed/simple;
	bh=g8rjLkGZDz8l75aKfZa7HlbA3xNuO5qdMG27VMFj5qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaEBONNJuzhJe99taGaNTSU1hYk6MBTFzHNYCKnMrQxnoaoDR1AwrbFyKlU0jRRcEvuzgQsk8x8NWoBQLg3Eh1yDhTMYfRhOwehpVMoRwypwoZGpPQrCRh5E7uC8YpjSbLpl0YXZDHJPbJZVoutdnALiCtYS41KvVXjhJ9qBWAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H06dORKL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0iIQ+Ipq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H06dORKL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0iIQ+Ipq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B730E68010;
	Thu, 11 Sep 2025 08:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757580946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=H06dORKLeqy9oLKCwBAyy8KbyMMgBGmw2umEdwRHB5t4//gwrPu6p/UqepgBh+cqtCMGYj
	gu16/N0MH0OUE8I2dmmLR/foB3LQlqym6FvW7Qq9xnnjWKvZeFtm5D+PPNO1HxnjqxADHx
	R9Jg+XWpXeRhDFWLoByfZA9usPYkdhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757580946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=0iIQ+Ipqu9W5Px/nULTByH8LjK8QRRM8NgGXedpdy+DrzCu/JG3h5fU1YWI+FWRaeWdOMk
	PDTOzamFaGTIDVCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757580946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=H06dORKLeqy9oLKCwBAyy8KbyMMgBGmw2umEdwRHB5t4//gwrPu6p/UqepgBh+cqtCMGYj
	gu16/N0MH0OUE8I2dmmLR/foB3LQlqym6FvW7Qq9xnnjWKvZeFtm5D+PPNO1HxnjqxADHx
	R9Jg+XWpXeRhDFWLoByfZA9usPYkdhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757580946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=0iIQ+Ipqu9W5Px/nULTByH8LjK8QRRM8NgGXedpdy+DrzCu/JG3h5fU1YWI+FWRaeWdOMk
	PDTOzamFaGTIDVCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7DA113301;
	Thu, 11 Sep 2025 08:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pmj1KJKOwmjpeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Sep 2025 08:55:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F916A0A2D; Thu, 11 Sep 2025 10:55:42 +0200 (CEST)
Date: Thu, 11 Sep 2025 10:55:42 +0200
From: Jan Kara <jack@suse.cz>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, kexec@lists.infradead.org, kasan-dev@googlegroups.com, 
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 09/16] doc: update porting, vfs documentation for
 mmap_prepare actions
Message-ID: <xbz56k25ftkjbjpjpslqad5b77klaxg3ganckhbnwe3mf6vtpy@3ytagvaq4gk5>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <e50e91a6f6173f81addb838c5049bed2833f7b0d.1757534913.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e50e91a6f6173f81addb838c5049bed2833f7b0d.1757534913.git.lorenzo.stoakes@oracle.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,lwn.net,infradead.org,kernel.org,alpha.franken.de,linux.ibm.com,davemloft.net,gaisler.com,arndb.de,linuxfoundation.org,intel.com,fluxnic.net,linux.dev,suse.de,redhat.com,paragon-software.com,arm.com,zeniv.linux.org.uk,suse.cz,oracle.com,google.com,suse.com,linux.alibaba.com,gmail.com,vger.kernel.org,lists.linux.dev,kvack.org,lists.infradead.org,googlegroups.com,nvidia.com];
	R_RATELIMIT(0.00)[to_ip_from(RLizrtjkoytmmoj3iud1rzij51)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[59];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,oracle.com:email,suse.cz:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30

On Wed 10-09-25 21:22:04, Lorenzo Stoakes wrote:
> Now we have introduced the ability to specify that actions should be taken
> after a VMA is established via the vm_area_desc->action field as specified
> in mmap_prepare, update both the VFS documentation and the porting guide to
> describe this.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/porting.rst | 5 +++++
>  Documentation/filesystems/vfs.rst     | 4 ++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 85f590254f07..6743ed0b9112 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1285,3 +1285,8 @@ rather than a VMA, as the VMA at this stage is not yet valid.
>  The vm_area_desc provides the minimum required information for a filesystem
>  to initialise state upon memory mapping of a file-backed region, and output
>  parameters for the file system to set this state.
> +
> +In nearly all cases, this is all that is required for a filesystem. However, if
> +a filesystem needs to perform an operation such a pre-population of page tables,
> +then that action can be specified in the vm_area_desc->action field, which can
> +be configured using the mmap_action_*() helpers.
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 486a91633474..9e96c46ee10e 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1236,6 +1236,10 @@ otherwise noted.
>  	file-backed memory mapping, most notably establishing relevant
>  	private state and VMA callbacks.
>  
> +	If further action such as pre-population of page tables is required,
> +	this can be specified by the vm_area_desc->action field and related
> +	parameters.
> +
>  Note that the file operations are implemented by the specific
>  filesystem in which the inode resides.  When opening a device node
>  (character or block special) most filesystems will call special
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

