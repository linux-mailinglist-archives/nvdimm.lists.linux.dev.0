Return-Path: <nvdimm+bounces-14373-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Xo60I65cKGr6CgMAu9opvQ
	(envelope-from <nvdimm+bounces-14373-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 20:34:22 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ACE96635AC
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 20:34:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b="s3JzB/wT";
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14373-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14373-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C5ACA304CFD9
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Jun 2026 18:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4B94C77DA;
	Tue,  9 Jun 2026 18:34:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6EE31E83B
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 18:33:58 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781030040; cv=none; b=ux7HstU4wFv+iQNizU34k5WAJYmybPlx/2Z7rg/+4V3saVFauWICjvx5Inbom41fITYmu3wBcely3ba4OulLnNtlgHHTrqRQ8kKqcLsglsBeEIr6kI82pUmrvDU9kcjZ37RmCHl4A6pzl02uoJmqhjIn13XctuourCE9f+NiR18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781030040; c=relaxed/simple;
	bh=YPBILIJB/sXgdKpxBDocoTsa5FDZwh7jmpWEGCgXIzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWC44Ty/3llEwFIKOVozdwNKKOj8cMh8iNJd5bdi9eFYtlNTWFW8gQVJuybOJC7YpOJpPVQ5MjRzuKCGHkpFb99jKj6GNLl2s82SaGDNhLbWgZq4Po/ZNtgt5Tj46WGqekoji/rh/gTNomeOsPuyy1cHPr4n6y8fonMktm3elA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=s3JzB/wT; arc=none smtp.client-ip=209.85.222.169
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9157b94a07aso686806185a.0
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 11:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781030038; x=1781634838; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OySD+ExhHPCEiw9aOnLHfgmqMe+Ca/7oT+zDoVBuOjM=;
        b=s3JzB/wTJjFaIlfeOetfPUNExB+n2/PrPDavnjHO1q0YFCI2DrbClwWBXs/FKRbCkV
         CwK57Qe4qZO9qwmDjqeKkImJ3x1THEx0R8bGfknhA+ttyb+AcUj4EQxgkGhplLBJedX2
         aquMTZGf+uIN0xHvjV1WEcE9JPbkqUmZlM38p7OH5OpOjXvgdBGMpchZa74NCBe8qReV
         iKDmsbH7IJ+gdG+dNcttaU8JL+ntNOrPY8hx7Sa4iUUIU0rDv3PeqxkJsRoTbVPHLpw7
         R7gWPyNVADjozbo0b29fV7hHTNozpigizfzAg5sgShut/5o6OTE00tt0J9SivD25YwnX
         T66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781030038; x=1781634838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OySD+ExhHPCEiw9aOnLHfgmqMe+Ca/7oT+zDoVBuOjM=;
        b=cC20+06nFz2ufm98Es9dgdU+YdO1dBiu70ZU6F30p5DYkc9ynF+e/cPtLMFzk5mCxQ
         mn+ZZkbGyaaanyl1a0Fmg08G+MR0fD6fmKFQK4GjyYKxvu2nws1pN8mB88xCags0r2h3
         CXLwbhQd1m3enbnMj+IFV9sgb9aRxa4bDxS9DQzxJ/H+EcglwwoF+GueIkGXogs9fJUS
         ACJFyZSklHDUtSDVDsAzTQBvdYlCvk01i69gfzDaE847UcoBKUM3APeXR3LXx0zqh/39
         UWDXalKSvf3Jv02VfFQYVdcq4U7k2cv4/xYK4LdIovBgkue01ykWsbHDbuXVZ2frUQw/
         dUWA==
X-Forwarded-Encrypted: i=1; AFNElJ9hkWiZWeUDhO9MgwMEO7AK1wf7tmQl+qsS82PQ4Q2+QR00RLU2lEAt6ZuCRANypBZ0oa5gmRY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvMpdyd+2hRzqfaGIbSIZrGITvyxbBYKprLWtbwgLMf5KbGRzy
	KudWj/AdV4jeRnq9GTLu138FdmUi7VYy5zslGwN69Qyfj2Fg1aXucfJwAEj0iF+bP6g=
X-Gm-Gg: Acq92OEcoBbE2jZtalwv/zsByFHnItqwq9QDf1ZoB+wwRukjza3mah0PkEJiLN11Lzt
	7Wp3I0VmVYIJ+dKAsa71S7hQvJxQdcwv0/pv0r26vha2vLg574xqsW0Gob3TdAj5Vu4LdWIo1LM
	JxWu9Gfrb18VZ9CnEZuBZs/SoKvWQQ2cbpYneMG+RepebqP7mFJ5CJABaJxWi3G8zEi7bK1O91b
	MSU29mNe3F15x8IZQyxQ5DgB7zbfxkQMlXzHBn5Ych7q4w0dE7r+9Sd6TvQxk/IPCGFKeqSJG0v
	+r2BiLeVM82hzF35j/VtgRd5SE0Y7WBp7t7f5jHdpH9O9N7pve2j8orOm0/wOywwWlzSLdRt5lp
	yW85+BkG2l3L9oIV86bL646AnTSEZReo5ebGZUtSYwTzp+DHeSJWWmx960l3djaG24yITDlvnAB
	wdKzNB2WjWz6CYceHcae/jI9cgVMlMHWSqX5EBz5X+caDRaHueCOyqDujKxTGAvS2ddbYxWSQqU
	0P/vk1vaegS0RzWMA==
X-Received: by 2002:a05:620a:1d01:b0:915:9e84:85ee with SMTP id af79cd13be357-915a9ca7655mr3263727985a.15.1781030037611;
        Tue, 09 Jun 2026 11:33:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3eea49sm2158492985a.44.2026.06.09.11.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 11:33:57 -0700 (PDT)
Date: Tue, 9 Jun 2026 14:33:55 -0400
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
	ira.weiny@intel.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Message-ID: <aihck-U9nyne98H0@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
 <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
 <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
 <aihZG8WKVSvA86mA@gourry-fedora-PF4VCD3F>
 <06bcee07-5e56-4a82-95ff-2a8e75b7154d@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06bcee07-5e56-4a82-95ff-2a8e75b7154d@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:david@kernel.org,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:kernel-team@meta.com,m:linux-cxl@vger.kernel.org,m:linux-kselftest@vger.kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:osalvador@suse.de,m:shuah@kernel.org,m:alison.schofield@intel.com,m:Smita.KoralahalliChannabasappa@amd.com,m:ira.weiny@intel.com,m:apopple@nvidia.com,m:hare@suse.de,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[gourry.net];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[24];
	TAGGED_FROM(0.00)[bounces-14373-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0ACE96635AC

On Tue, Jun 09, 2026 at 08:22:20PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 20:19, Gregory Price wrote:
> > On Tue, Jun 09, 2026 at 08:11:42PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/9/26 17:35, Gregory Price wrote:
> > 
> > Was going to propose this, but then I thought... well if CXL detactes
> > itself from dax and does this same pattern, maybe MMOP_UNPLUGGED makes
> > sense.
> > 
> > But i'll leave that for another day and do as you suggest.
> 
> Let me sleep over it :)
> 

Have some other sets i'm trying to break out of private-nodes anyway,
i'll let this bake for the week.

~Gregory

