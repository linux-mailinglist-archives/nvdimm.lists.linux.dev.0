Return-Path: <nvdimm+bounces-14393-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wwKVLPTZKmp4yAMAu9opvQ
	(envelope-from <nvdimm+bounces-14393-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:53:24 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AACBC673391
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:53:23 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRtpZ5ki;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14393-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14393-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B6794300CBE0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 15:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104C53839B7;
	Thu, 11 Jun 2026 15:53:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F96A329E79;
	Thu, 11 Jun 2026 15:53:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781193193; cv=none; b=Y/KW82Xv9RqqH1cO6KHexDCzUoIVvsElQ/DjWYxgEuixDl+a34fAX0uEcFEYYI37X6B+dq4kmMSXDXgs2bgoTIddB9rdb6dO9OAupRWtUSzt/ogU6tSZiV0XcV70yUaZkEPGbS/fRKPv7sqlscyJpV+1sJMdLsY6dHLktSRojEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781193193; c=relaxed/simple;
	bh=3tf8tVVdzCC9tsUBWHR2BG9ZmTnZKe5b69Q+i1FQsqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2ErlIgVclMD35+dztDLUSHX9cbWHyi7Y4vx6LPVLAXYpuxCuEOMWuqFAPwqVgHS4cw/HFoEDtwqreQj72Z5kxtI2p0kaTlKEwbfOI5S6ZZKMvHlbGVLN6+98gj5WPmjbKFevsM6TQbw4TKq+fAREfVl66Y9dIY3et1NP7uN3FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRtpZ5ki; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472281F00893;
	Thu, 11 Jun 2026 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781193191;
	bh=nWWQcnr5s3ZKYSOjuOdhQYovdi3ZfrWWs+mggmJcT0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iRtpZ5kieFw5S9ITnjIH6j0aWcKNh5JeuF+zK4u3Gb5BHGjXDX+63qYpICXZOqKKf
	 FMpn/eSPdZ3uUDY2hsCqbr+TZrG/QR3UZsXMiEpeUFOJx1TvgaWPpU2Sve9CrFxXl+
	 FPqFy7tIGDmG52exo9PstHq6ST6VxUMQd8EOxUjVYsICVz7IejXX1Gsp7Nm89bi+jK
	 mGw7lODaN60ngB2FLEwNaIgnCWslUjDqMZ+ZD+N8Eh+psAFgBJrySRm3icp1ZA6RjP
	 0zyMAq/g3K9uC6d61CATLKH+E8nSZtrkkgmOOG/Fc7JJu4bfrSi9nkah1Wa+lwiqQ1
	 d8kGPcHyRzcdA==
Date: Thu, 11 Jun 2026 16:52:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, mjguzik@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, linux@armlinux.org.uk, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	djbw@kernel.org, willy@infradead.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	james.clark@linaro.org, mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, jannh@google.com, pfalcato@suse.de, riel@surriel.com, 
	harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <airZn524Ip8VsWra@lucifer>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611061915.2354307-2-huangsj@hygon.cn>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14393-lists,linux-nvdimm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:huangsj@hygon.cn,m:akpm@linux-foundation.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:jack@suse.cz,m:muchun.song@linux.dev,m:osalvador@suse.de,m:david@kernel.org,m:surenb@google.com,m:mjguzik@gmail.com,m:liam@infradead.org,m:vbabka@kernel.org,m:shakeel.butt@linux.dev,m:rppt@kernel.org,m:mhocko@suse.com,m:corbet@lwn.net,m:skhan@linuxfoundation.org,m:linux@armlinux.org.uk,m:dinguyen@kernel.org,m:schuster.simon@siemens-energy.com,m:James.Bottomley@hansenpartnership.com,m:deller@gmx.de,m:djbw@kernel.org,m:willy@infradead.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:mark.rutland@arm.com,m:alexander.shishkin@linux.intel.com,m:jolsa@kernel.org,m:irogers@google.com,m:adrian.hunter@intel.com,m:james.clark@linaro.org,m:mhiramat@kernel.org,m:oleg@redhat.com,m:ziy@nvidia.com,m:baolin.wang@linux.alibaba.com,m:npache@redhat.com,m:ryan.roberts@arm.com,m:dev.jain@arm.com,m:baohua@kernel.org,m:lance.yang@linux.dev,m:linmiao
 he@huawei.com,m:nao.horiguchi@gmail.com,m:jannh@google.com,m:pfalcato@suse.de,m:riel@surriel.com,m:harry@kernel.org,m:will@kernel.org,m:brian.ruley@gehealthcare.com,m:rmk+kernel@armlinux.org.uk,m:dave.anglin@bell.net,m:linux-mm@kvack.org,m:linux-doc@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-arm-kernel@lists.infradead.org,m:linux-parisc@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:zhongyuan@hygon.cn,m:fangbaoshun@hygon.cn,m:yingzhiwei@hygon.cn,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux-foundation.org,zeniv.linux.org.uk,kernel.org,suse.cz,linux.dev,suse.de,google.com,gmail.com,infradead.org,suse.com,lwn.net,linuxfoundation.org,armlinux.org.uk,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,arm.com,linux.intel.com,intel.com,linaro.org,nvidia.com,linux.alibaba.com,huawei.com,surriel.com,gehealthcare.com,bell.net,kvack.org,vger.kernel.org,lists.infradead.org,lists.linux.dev,hygon.cn];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[ljs@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[65];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm,kernel];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[hygon.cn:email,lists.linux.dev:from_smtp,lucifer:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: AACBC673391

On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.
>
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Yeah as Pedro said this one could just be sent separately, and I in fact
suggest you do that :) So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  fs/hugetlbfs/inode.c | 4 ++--
>  mm/memory.c          | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 78d61bf2bd9b..216e1a0dd0b2 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
>
>  	i_size_write(inode, offset);
>  	i_mmap_lock_write(mapping);
> -	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
> +	if (mapping_mapped(mapping))
>  		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
>  				      ZAP_FLAG_DROP_MARKER);
>  	i_mmap_unlock_write(mapping);
> @@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>
>  	/* Unmap users of full pages in the hole. */
>  	if (hole_end > hole_start) {
> -		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
> +		if (mapping_mapped(mapping))
>  			hugetlb_vmdelete_list(&mapping->i_mmap,
>  					      hole_start >> PAGE_SHIFT,
>  					      hole_end >> PAGE_SHIFT, 0);
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..5335077765e2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *folio)
>  	details.zap_flags = ZAP_FLAG_DROP_MARKER;
>
>  	i_mmap_lock_read(mapping);
> -	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
> +	if (unlikely(mapping_mapped(mapping)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
>  					 last_index, &details);
>  	i_mmap_unlock_read(mapping);
> @@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  		last_index = ULONG_MAX;
>
>  	i_mmap_lock_read(mapping);
> -	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
> +	if (unlikely(mapping_mapped(mapping)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
>  					 last_index, &details);
>  	i_mmap_unlock_read(mapping);
> --
> 2.53.0
>
>

