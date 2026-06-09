Return-Path: <nvdimm+bounces-14364-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ZKd4HS4zKGoHAAMAu9opvQ
	(envelope-from <nvdimm+bounces-14364-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 17:37:18 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCFD661D6A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 17:37:17 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b="R9xW4m/P";
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14364-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14364-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EB3A63095A79
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Jun 2026 15:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C8047DD63;
	Tue,  9 Jun 2026 15:11:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45F450904
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 15:11:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781017917; cv=none; b=m6aT1ggS+7kEPelCOG4mZTvJrMWaQwxSUJux6whgp12ZUPpccH9eBDB0M5Lk6983OvokFYDMz033TxpcoQo6y10o3NcY+zm5fB20WC+rNDc+s9W18TeTKnKYJC6P9uv4Xe041YSDt/FldZ0V79eMnbUC3U22tnDyakgDW6/8OJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781017917; c=relaxed/simple;
	bh=2N6jjPNXS8KHkA9ELWAn9DU9QeobkpuL9vsk9iqxtB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3ScyqfJ1J0SKqIr8XaKp6Uz2YhZs6g9OHAsKzjlXTTUG56JfxHuOFvlkXCA/5ufnnFsYSlq9yvk91sWNrmWrgOqZdZD5YpFwMOlQGDo1YwltdKLOGzgiAqwqAJdwSSmd5p8DQjzxNXM76PHpkTcGgCczUOornxbJrlooqcCr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=R9xW4m/P; arc=none smtp.client-ip=209.85.222.177
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-91562bf6c12so692714285a.2
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781017914; x=1781622714; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
        b=R9xW4m/Pgphf3jsKvhmPQbYPRDpZPkldJ78spTv0BRWTfxfb8EfHXummaBg/MldD7g
         kSr94wJC41K/uuwYQ2JRZcqpA8XsFZFUeMXUNg2wplzlJC+YDOco2hVWzt5HSaFwZHwA
         dSUM7XPPoM13OKFaVt6bPfIzoo5O6SASlVVrfVwIwa3Q4pYrSHBieSCw4b8JubM/3+kR
         rxwURyBlsxUWrJsfLtCwb+rqFNtZP6lIKFEvZjvFNfMu63r98qNCdwfok5uHuyJo3O7L
         w7e5y9mAWD+7mKnmW1Nn1PubO5ft1RBD/OMtmmlMG4zLzRiu+MWoDrGcYyzO7zZRzgCa
         14Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017914; x=1781622714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
        b=S1Mv81tn9/0mlmslmpmKsQxnU4bZLP+gFrVY+yDM1rypnJYPPOFD7HDGPOGlvGppZP
         bjvd+m225NCfiwNq1ffZv2dx/hym7yJ7PqyjQrwXQzbV/H+T8TIEN+YRdzPpOmiK2Uqi
         oyyYON6TOOG56WqCXQGgMADkzA0c4ETvOuHT8WFa9ZQGzC9Ek/hbpRolq5l/kpbSkeuA
         j7U30ad/BALDgEi9SaQVES8i9KnkgBl6WwjMrjFRphCdc2dCbaiRlxAiyhs1WQfKllvE
         hMWGNHAwFnddEuCNaL6UO7p3zbN6Vn2gJGPCOeGhjhmayQCFlXl+p1EVUqwajR3cvXOU
         jViw==
X-Forwarded-Encrypted: i=1; AFNElJ8zsF4lTTYvIFWedvdg51wakNt5PPuvkKJ3Awz2kWjECRNJa4VA2UjpRd9lw21OIKkEbsQojJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTRyvbhVOmX/RGNXVh8YOk+2i5DhT4Sdc66gjDoqFgF/X/Jigp
	yXFmIHE+WjjxPbdLznDxeQnwvwrIxmxGhPi7VwNhGa7pCBYR8k8PAtwWJBLTDCzBkSQ=
X-Gm-Gg: Acq92OEUxyPjzpcsd3dDElkCN3BwL3GTaqHGhFA5BQvFZixb5fEht3uB6HC6+WW6WRK
	tQRqh5JkbhQZtMKArhwDlv2aRDRYKXsOVZNzXlsH7TpAy7eYV8AQzanQnPCDmfCKC0y2Fv68lND
	D5qIkp9Bd7U3N9DwoqnpeO+x5XfuNtPb4hDCdZoA8UyAurfNnSGAAfK9unwOPEwELuhnRDUKsDz
	ZkQlblX7zojGmLLXajsw2Bb1KioD2gCQb4KxHWzTXXINPoF3BF4jbWnlWNd3UEGSZzJ8mEKTSdZ
	HL14Y330abUqqymrV0QQETlUfpRCsNFQMxcxEFj12wJnc/DN4/5q2TZT25DNdFenxYOHmG5q5Iu
	hfhPTkJXPrVWxGnGr1uoF8unkOuOD4U85VcRR8Ty4N63MagbmpeAU/CuAQm3kpZ60eqxWLpSEI8
	ILO3RSA5rJc3VBojA+wS6sxTN1saj6Rpm+ZiAb7AfyBWY1/fD6cFN+L/bvwcJL5x97H20iyVQSS
	uB7w+u504WMe4yxpQ==
X-Received: by 2002:a05:620a:4546:b0:915:cf88:1e3b with SMTP id af79cd13be357-915cf882096mr1578753385a.47.1781017914136;
        Tue, 09 Jun 2026 08:11:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a237330sm2207058485a.16.2026.06.09.08.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:11:53 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:11:51 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com
Subject: Re: [PATCH v4 3/9] mm/memory_hotplug: export
 mhp_get_default_online_type
Message-ID: <aigtN28XUvHyCSkG@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-4-gourry@gourry.net>
 <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:david@kernel.org,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:kernel-team@meta.com,m:linux-cxl@vger.kernel.org,m:linux-kselftest@vger.kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:osalvador@suse.de,m:shuah@kernel.org,m:alison.schofield@intel.com,m:Smita.KoralahalliChannabasappa@amd.com,m:ira.weiny@intel.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[gourry.net];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_FROM(0.00)[bounces-14364-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gourry.net:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,gourry-fedora-PF4VCD3F:mid,gourry.net:dkim,gourry.net:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7DCFD661D6A

On Tue, Jun 09, 2026 at 11:52:21AM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> > Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> > and the mhp_get_default_online_type function for hotplug use cases.
> > 
> > Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> > the same driver code, and chose the dax_kmem path as the default driver
> > path - making it difficult to require hotplug as a predicate to building
> > the overall driver (it may break other non-hotplug use-cases).
> > 
> > Export mhp_get_default_online_type function to allow these drivers to
> > build when hotplug is disabled and still use the DAX use case.
> > 
> > In the built-out case we simply return MMOP_OFFLINE as it's
> 
> Ah, you mean without CONFIG_MEMORY_HOTPLUG
> 

Yeah i'll update the commit message, thanks!

> > non-destructive.  The internal function can never return -1 either,
> > so we choose this to allow for defining the function with 'enum mmop'.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

