Return-Path: <nvdimm+bounces-13862-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WK43EghH3WkrbwkAu9opvQ
	(envelope-from <nvdimm+bounces-13862-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Apr 2026 21:42:00 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CDC3F2D41
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Apr 2026 21:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C831C30387E5
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Apr 2026 19:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E063E317B;
	Mon, 13 Apr 2026 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="U3ttVhTV"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561553E3154
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 19:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109304; cv=none; b=FCvgEtwGIsV7IUUwJtmLaQDh5PovHxqg4z9FJnaIAc7HbbyImiqBI7TskxEK5xTcpLvxPA3xGfyszBQYFYJr4zdPvu+m5enXC2x+stmwm3VPPfUkG6Ge20xSsjri7SiceHZ5JW4MicOVhsAaPFCsh4WBS9VLq5UaMMPX8mD643k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109304; c=relaxed/simple;
	bh=6hRiNGqvtOWKux9ylwRAer4046Lz3jBPnR8zW37UMoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyN0rvyaL42ByoupZqxUqL1ZswXnYYUVz+vyRpeVojYiOhn2rB6SFqOBLQe741WOFTwC/5aAysmVvHqk6KljasVokXM6/Sat8xv8oOpoNZPoJwInLX2i9weLMhshwT0vSaQMqwa4Sz7krKFJbj6Z24TLH1eXbkoimqlb7/QEPts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=U3ttVhTV; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8d68f702851so766204585a.0
        for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 12:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776109302; x=1776714102; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ANyztBlS8ASp9MHR198GNmIsfqkyGsWGhTyu9QD8TKg=;
        b=U3ttVhTVLGMEyrEceDihMHnHsRN5dzSc7rXtaXVch2yoWOPYSNEjWz4UHLNtdZYHIe
         vJM4G9bRSjz4+hkQPygf2v6zWi/moJyrd1n0ZinTkgqDM/BjNDTai7A8eFIjvtgnpuLy
         BkEwyrmiN1aCfzTwDR7KKtGPoXj0jQYUDPMA+g7uAjbTquofvVy/4JQ6rfmLxGXrg4I9
         SxflA4zcUpSHkLjXzfArNZExyXJv9D1jcPAYa8qMZnKlPlyHJYRCv8N7v8/9yIZl1t03
         a8ExV0toVHl7chj5fqbxXyAskisin/6Trglv3bI7UuWC3oIYJhljp1tGzpKTtwzCfEZd
         qmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109302; x=1776714102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANyztBlS8ASp9MHR198GNmIsfqkyGsWGhTyu9QD8TKg=;
        b=A8QwPlle7UKgdREM75+V1POMyjfYs3M6x30hTQfdTIOhUPgWYnDQ1D1JrUOmpjUuS+
         vX04zbgqXUnP2KMG8e5pwu+NTOZm0FKxQGTDJre8QY+sfnIMJjjUQVMIfYOO07FRZD5+
         tpXwPoSTpay3t+aHNsMgRrdRYRQdZrYFCuV/Ty2eh9zKXKU5u3ssBpe0vEEr0IroVDSB
         SkiSYEt6rTP7CKvLq3P27JSMqUkkG8yNdX7REn7MXOUvtHNWdtHT0OrfcBYkPy48S24M
         /UVLJfox15i+X/Dbr1b/ASfCDJqLqa7PMx5NDNzc4Mj34fgwX7PVKjh8ScedWtLHpJWP
         EFMA==
X-Forwarded-Encrypted: i=1; AFNElJ/XgCES5E9MRcQ7xvPKBNXuKGsOddtOu40jGYsSe67Ys+csyoG52T3UptpPYg5fu+JlcqFJkQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcwCbnNy+pfgskaeRnW2g2tyeL02yOLHgreZIbPKc8bOG2Vn7p
	pEAsKstuYuOOYcHU+v9FfCE9+tnpLb4nVTTNz5c/Ani4ysW99251W5BDRTrJuKc4G3c=
X-Gm-Gg: AeBDieufhyEGzvXOFSdDXWnZzSFLMcLcoYugrCCi6pHTI/Xgjf2F6gFq1L1063zpTML
	MtP20H8NDx/5EOII1zZ+pQGkJ2VmFQ2AFD72rRjQFs7aC64lZRaZK+bSt1NbCDdrs8jG1ggyQW9
	9K/AEwonNaM1pYdxPxFGP+5baLf/q9rt3itm1nsGaas36BKo6luzVHnVCH9wKCKZuSYsacisEnx
	f1b/x5gjXRvYKywQ+sFrSgoGR1NAB8UkQVRb5T2QmaXm3qJ8a01P6SEnWERr/Sy2dN+dtEyDOOR
	KLH2W9N1FMA8mzZ72hchoDG5+D/U6yMPd271hKES9/6z37IQ3QQ5z0NN4du0zcMs84CEnC9EwUt
	hanafBXtb2Iml8fcNptyLh6w8Vjpg+HFeuZ0xDvS8z4WEltfAu8qz3x0+JGSKEa7fmbR6VbACN5
	71c68nU7ELvx4fyq3EX1gpBzPVTOZ0dfUyX6f48h8iiqfgcqMCzpsSjTy/MldD4ap1JXWBQ2zXb
	Xz3KsjmeGBGY6jhzl4y2hC5GohUg4XJNA==
X-Received: by 2002:a05:620a:440c:b0:8cd:8320:3359 with SMTP id af79cd13be357-8ddcd024831mr2080049985a.9.1776109302203;
        Mon, 13 Apr 2026 12:41:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb5f88c82sm901067685a.2.2026.04.13.12.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:41:41 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:41:39 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, osalvador@suse.de,
	dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm/memory-tiers: consolidate memory type dedup into
 mt_get_memory_type()
Message-ID: <ad1G84KdvOmKSRNM@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321150404.3288786-2-gourry@gourry.net>
 <e0e48659-8ce1-496d-8b5a-f6d4416f2ea0@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0e48659-8ce1-496d-8b5a-f6d4416f2ea0@kernel.org>
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[gourry.net];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13862-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gourry.net:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,gourry.net:dkim]
X-Rspamd-Queue-Id: B2CDC3F2D41
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 13, 2026 at 05:06:35PM +0200, David Hildenbrand (Arm) wrote:
> On 3/21/26 16:03, Gregory Price wrote:
> > Replace per-driver memory type list infrastructure with a single
> > mt_get_memory_type(adist) that deduplicates against the global
> > default_memory_types list under memory_tier_lock.
> > 
> > The per-driver lists (mutex + list_head + find/put wrappers) provided
> > dedup within a single driver, but not across drivers or with the core.
> > Since the number of distinct adist values is bounded and types on
> > default_memory_types are never freed anyway, the per-driver cleanup
> > on module unload was not useful.
> > 
> > Add MEMTIER_DEFAULT_LOWTIER_ADISTANCE to replace the default DAX
> > adistance, since it was really used as a standin for all kmem hotplugged
> > memory.  This at least makes the default tier relationship clearer to
> > other drivers and they can see where to put their memory in relation to
> > the default lower tier.
> 
> Very confusing code.
> 
> What's the purpose of kref_get/kref_put if "the types on
> default_memory_types are never freed anyway" ?
> 

Mostly trying to retain existing functionality rather than delete it.

I think the entire memory_type() infrastructure in memory-tiers.c is
generally very confusing and of dubious value - but i don't know who
out there still depends on it.

> IOW, couldn't init_node_memory_type()/clear_node_memory_type() just
> consume the "adist", and lookup the memory type itself?
> 
> All you'd need is some way in the driver to verify that there is a
> memory type for the given adist, as some kind of prepare step.
> 
> Alternatively, let init_node_memory_type() return an error to get a
> clean interface? :)
> 

tl;dr: yes all of this is true and I will rework it.

~Gregory

