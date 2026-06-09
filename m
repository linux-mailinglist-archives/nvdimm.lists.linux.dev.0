Return-Path: <nvdimm+bounces-14365-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 79EXFGEvKGoJ/wIAu9opvQ
	(envelope-from <nvdimm+bounces-14365-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 17:21:05 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D544661AB0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 17:21:04 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=cerTw9pg;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14365-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14365-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87E4F3024CA9
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Jun 2026 15:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA7347DD76;
	Tue,  9 Jun 2026 15:12:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D866481224
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 15:12:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781017960; cv=none; b=PQrcM0uDQOqJFQAOS6tWCDxopBMLcSeOneUzV4Y7EiVWOnpn7lrgC+s9rDXf1NBY3aSfmZRlQnaAUpyf9uUn5mJOQn/tMjnTImWHruAOJyisk9zzXJkRT/njJvionsfGNwNTZdpkl1OT/K8QRFM73MKCN5cAdW5ylhqrCrne7wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781017960; c=relaxed/simple;
	bh=0bY3+VnKsZDDkii4NqRrIp5qMNrkGIBYkCIcna1PA6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1e9ZMuEMA+RrWvFUrKRZ66wbXNtGLeXAb/lR6TaYhV2u/xFopoGWVTLv5cgF1J2BZeDTccFiA+tJfRGisNI3hIdA7GxAe8aOh8shj7IddXrJ0vQofNC7/MCMufMC4J3gHy5NcZ5nq1YD8zxVyU/NZISE0+nKn9SEzbnpyUZC+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=cerTw9pg; arc=none smtp.client-ip=209.85.222.173
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-915d17e2721so284241685a.3
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 08:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781017952; x=1781622752; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PSHte4tw4Fe/hwOe0BydbVQDJ1bfJM9PJbtvHiFr8Bw=;
        b=cerTw9pgD/d7sUpYWHCzd04mDeEZcvRLRbXwIv3FctH0DMDoiThfI+ANviIJx66EKQ
         zRwAcylN7rH+CXuaH+s4MxpRi0vYHIfjYqPd4EqlqNN9TYZoOrIMd+sQsCARSaZGnrtf
         4rgKI/4SEHnTce1zFeJFx6Q/cKycdAwceGfO1les/n6+30PVXGtJ1MRBUdubVCTZp4v1
         +2mHrJ+lVAi5i96ET/oUix9u+sTopGUywjS2yCyI7+bCkMnGO1XFk5psOZiTebT785nu
         a/NXZNgmvwmr1Eoi/TZn73Z1rUZxvmfVchW8ISw58vbOYr1TqcIJtkqBtQedTXL4KS4G
         V2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017952; x=1781622752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSHte4tw4Fe/hwOe0BydbVQDJ1bfJM9PJbtvHiFr8Bw=;
        b=hXBUVqPhayF00z0dpJmIX4A47SAHXa7R+c+7TqQmRgD1ZybX+fM9aBCKXRSUj5vcm1
         jHQnffbuoRqXLsxtNCo9+ylf6QXyo1l06yQFBWphi9uXs4SjYnEwavUM/oI5hUoClNEe
         y3CL4jVu9AH7cHOP6V3vmPTPyJhOr7fn6vd+5K+ufxOGSXoFBdmGzNOCRvUBTLy/bHAP
         CJOK6nXvbcbewuPp9HrDX4+vRKKpblZ+v63k5nxLhaUQ9vTzopuKoBUfpvDfoPz+mTz3
         88V78RtLilmjMgp5USPYAHTgd/2NSJ+NGYLQTadCIm2fvhkkiiB8O/kelGS9jubkXz1W
         Oq2g==
X-Forwarded-Encrypted: i=1; AFNElJ+uNtE4NBbZEXUdrOuQX/P2L//8Yb4jkfVPsAC9YQIa/1opfvS2q27gvyK0JSkocjtnFuYdr7E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuQN52hUNvqNgOcVVYLephmekhkseA5gIRSjVxNZ3k5Q25ANeb
	VyU5yqvRm6PJ1nU5cZCvZBFo3J9jL0Jax0a4L0Lyyawdz/VCT+zoNCEiKDK98XKrHr0=
X-Gm-Gg: Acq92OEB/WYSCJwDeberP1IlesJTwZY3AXLCtPCGXHTuWTqsC9CuNP8g8ggz5F8zamo
	D81+xKAthY8gJbrtWwr9pj2yjGzDRzM2Lr97wFicD5NfxCkuH+j63ZzyyYOS9bqFa29pz5ZcUl3
	4hFAgweoyVY2/R78mzofmD/Yq8VlW69blh0+gpb7fNwpI094DPjFgAh53OEfrhqNF563InKL2Wl
	raQcXmuduR5uw6TS9+46+oxYAofQvCUhHfOLwbuoeE3wiH5c1hTi0CfxpC/6CBHIx+S+AxHzNSz
	9RCk2BWw7DYHWdY7/pHX6VVAw5g6vBdUPYhwZYrFO4hXCcRaj0NMqxZBa5lKPJUqAYDzo6UijuN
	9GrOKseIpePJSp6g7YAWjl4MkHCBidZacLjlOwHdtiff03O9ZlD5X9l2G6Uo80g3MQzLfXgBaFk
	byJa53K+pycYexZ41qhLWHKwkToZl+xr/eCBR/ZCh6QAWd8AJHQgcJOGXEqi1WY4D5yFknj3t19
	zcb8XrKx2xXke5miQ==
X-Received: by 2002:a05:620a:2587:b0:915:9c4b:fdae with SMTP id af79cd13be357-915a9cb2d33mr3324652285a.21.1781017952150;
        Tue, 09 Jun 2026 08:12:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a411333sm2261055685a.46.2026.06.09.08.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:12:31 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:12:29 -0400
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
Subject: Re: [PATCH v4 4/9] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
Message-ID: <aigtXQsFhJ4SB39t@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-5-gourry@gourry.net>
 <9361f783-5af4-4380-a901-8d330370491a@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9361f783-5af4-4380-a901-8d330370491a@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
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
	TAGGED_FROM(0.00)[bounces-14365-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:dkim,gourry.net:from_mime,lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,gourry-fedora-PF4VCD3F:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9D544661AB0

On Tue, Jun 09, 2026 at 11:55:24AM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> > 
> > diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> > index f059025f8f8b..d3edeb80aadb 100644
> > --- a/include/linux/memory_hotplug.h
> > +++ b/include/linux/memory_hotplug.h
> > @@ -294,6 +294,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
> >  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
> >  extern int add_memory_resource(int nid, struct resource *resource,
> >  			       mhp_t mhp_flags);
> > +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> > +				const char *resource_name, mhp_t mhp_flags,
> > +				enum mmop online_type);
> 
> We prefer two-tab indent on second parameter line while touching code / adding
> new code.
> 
> Same applies to the other instances below.
> 

Will fix on next spin, thanks!

> 
> Apart from that (still) LGTM.
> 
> -- 
> Cheers,
> 
> David

