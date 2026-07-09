Return-Path: <nvdimm+bounces-14803-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 8bjQDkrHT2oPoQIAu9opvQ
	(envelope-from <nvdimm+bounces-14803-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 18:07:38 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AEAC7334C7
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 18:07:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=Izkg+ycr;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14803-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14803-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4968230FE7B8
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 15:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C44428463;
	Thu,  9 Jul 2026 15:57:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDC940BCA2
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:57:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612639; cv=none; b=kL/Tc9NEe5VLTbBBY9eHjJ+PKzqK2E2JT0iyVOfN8/tei2n7QHAQIJcxxMNXe4V0nak9Km5uHt7oT+NdY5OClioZEz64tAy6ZMp7Kq1LjhPRzEIGSP/B3X6VGVWwut1vPOYGT8AJOgnk7wBfD+YImSh2gob/+O/LC1h1r4XsU3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612639; c=relaxed/simple;
	bh=zOqJj5IGDkUHkuE0A0VjkQNttgCPQIdWlZYAcSbicnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqywsLQGB01ctpOSHBmkg+nzvXhtp39CNwDI8g5CyOGNrayYh2i31zBuTYujdNe9AngF+FtCYuktZaV2/yX40PDCLZSuEa9rEkp9ZmfVvxaStK+bo11q46Exb7gFl1AzbS0rD+RDe/7j3MM1/SdJ4q5KYMiMzvhMtHcQJuMlKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Izkg+ycr; arc=none smtp.client-ip=209.85.219.54
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8eff5ce3b95so365066d6.3
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612635; x=1784217435; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
        b=Izkg+ycrCyOCViNSSPP/Do+d2sLA2EbH3MqgIZTEDTFkrkUvu/G73aUE9BG838DnCz
         d8SeMg/+eL9LHO2TTmHHr7EI/RId1lnfvYqGUP4Zn+Lce14iR++fdUk5txF4BaOd2ZNA
         olB8K/d6X+nxsp50jZE1vvNelvP52BBoQiRp1uLU4BsqCxBOkMjRl/j3iOhiHgzCM1Xo
         WyWLvXMG+yWXNKbR2BVjz1sb+4B93DutWF9UzcPAgrJGnWS5Ybu9WwAhDcfc151WlE8v
         kYZ0vZf7SM7aUWX3j1ITaakgXJy4NQYi6RZGSSaPBlU8druHLboOHcLj4cuiWJIuOtZy
         hESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612635; x=1784217435;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
        b=I2yITyrWNhGg4kHRBkpFpfa5FFCyIUPqYQap8LXzC/nTX87GWCJeV4eJotbxpL/RWy
         MOSRHVsUyDoG7yt10buz/Y2zaNQF7OTACEjSb92cdIhufX5A87xROUAaOBBoYd4TwMQo
         yBZY0Iz4ph1tL2utr3s4waZGY65tkYCf3towYqIGvdkZXg0LDm86H2G2Z+toTzByBJRZ
         88OaFEgwXBdUe1UHs4qJ8fd203ZpYBlVxAuLhQQxugJryFsBPuReVjn2dW/TYXgrNwrg
         4A+L8WQ/dUGCeBYWcoYj76Q6lkAXIDkBwRMxE4B+2Ez7xFcRcys1Q01aODK4V0kzDK7G
         FZRg==
X-Forwarded-Encrypted: i=1; AHgh+RqFNv/aFDlu0nz0EeCBUW6zdstzzDofc1959DnvMroteQb6KSfFjKCR4+GrR4wq/OEaWSq8xgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBLeWBqbqm7VmtuvgjhI/s7zFIjW1rxHBJglTCtC8x4NOV2CYd
	8Xl075riMHUHtcsYtf4xPpgxGRbpbNVHbyVvpcxjokx0andm//+Cu8j+sKmyg8H0G8Q=
X-Gm-Gg: AfdE7ck78zDKAkQD6SpD/ihqBk+yY1S6cYewux+RURad995sm1YIJvQU/LghCj8bxzY
	t7K1X/Iot9JtjfaE3u9hqJcmdedfSYcCm1pdOBgotn5lyRDlIP4fL8GY0cvMoojNQOd1pig0HeA
	ey6QLbi0A4q3ItoVm561InDjRle7J9+CKEPZNpj2Y8zp30ZgXL5xhIrIHD9raDfNQgsZtk/aOzy
	GDlPAD8UbtDp27p3iabBVhbjmSyn1P9k3rBh7vz7IdfIGvEVsQ+5qFvxBYZT2qUSeWOhGhx3xGR
	v/7VPJH5n2WdIfGeaL1L59peUCiIDwDc4UUgwpA69bzmvG4s5UueT2+MNpSLgZ3lKAnUncpTjyI
	dqlSAKt1koh1xJ3AleKxupP6t8RYj6mWI35owVHAWZbK67uMLD0TVldJc4XUdOlv3zaYotm2Ahi
	mrRPPpQtO6GMO3lRrtjDk51rA/6Paw/9VsXg5bWx351sU10qXxlQXNcZ2Ai7l2Bi/5qPBjNGPgb
	iyWoSk=
X-Received: by 2002:a05:6214:2aa6:b0:8f3:e0ce:6119 with SMTP id 6a1803df08f44-8fec0ead52amr91789316d6.21.1783612635560;
        Thu, 09 Jul 2026 08:57:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd86d43e2sm20317526d6.43.2026.07.09.08.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:57:15 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:57:09 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
Message-ID: <ak_E1Y-D2Twykusr@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
 <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14803-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:ljs@kernel.org,m:akpm@linux-foundation.org,m:linux@armlinux.org.uk,m:dinguyen@kernel.org,m:schuster.simon@siemens-energy.com,m:James.Bottomley@hansenpartnership.com,m:deller@gmx.de,m:jarkko@kernel.org,m:tglx@kernel.org,m:mingo@redhat.com,m:bp@alien8.de,m:dave.hansen@linux.intel.com,m:x86@kernel.org,m:abbotti@mev.co.uk,m:hsweeten@visionengravers.com,m:l.stach@pengutronix.de,m:airlied@gmail.com,m:simona@ffwll.ch,m:patrik.r.jakobsson@gmail.com,m:maarten.lankhorst@linux.intel.com,m:mripard@kernel.org,m:tzimmermann@suse.de,m:robin.clark@oss.qualcomm.com,m:lumag@kernel.org,m:tomi.valkeinen@ideasonboard.com,m:thierry.reding@kernel.org,m:mperttunen@nvidia.com,m:jonathanh@nvidia.com,m:christian.koenig@amd.com,m:ray.huang@amd.com,m:ankita@nvidia.com,m:alex@shazbot.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:djbw@kernel.org,m:muchun.song@linux.dev,m:osalvador@suse.de,m:david@kernel.org,m:surenb@google.com,m:liam@infradead.org,m:willy@infradead.org,m:m.szyprow
 ski@samsung.com,m:peterz@infradead.org,m:acme@kernel.org,m:namhyung@kernel.org,m:mhiramat@kernel.org,m:oleg@redhat.com,m:rostedt@goodmis.org,m:sj@kernel.org,m:linmiaohe@huawei.com,m:hughd@google.com,m:rppt@kernel.org,m:kees@kernel.org,m:pbonzini@redhat.com,m:linux-kernel@vger.kernel.org,m:linux-arm-kernel@lists.infradead.org,m:linux-parisc@vger.kernel.org,m:linux-sgx@vger.kernel.org,m:etnaviv@lists.freedesktop.org,m:dri-devel@lists.freedesktop.org,m:linux-arm-msm@vger.kernel.org,m:freedreno@lists.freedesktop.org,m:linux-tegra@vger.kernel.org,m:kvm@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-mm@kvack.org,m:iommu@lists.linux.dev,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:kasan-dev@googlegroups.com,m:damon@lists.linux.dev,m:pfalcato@suse.de,m:riel@surriel.com,m:harry@kernel.org,m:jannh@google.com,m:patrikrjakobsson@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[gourry.net];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[gourry.net:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[76];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry-fedora-PF4VCD3F:mid,gourry.net:from_mime,gourry.net:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8AEAC7334C7

On Thu, Jul 09, 2026 at 11:55:54AM -0400, Gregory Price wrote:
> > @@ -2462,7 +2463,7 @@ static int comedi_vm_access(struct vm_area_struct *vma, unsigned long addr,
> >  {
> >  	struct comedi_buf_map *bm = vma->vm_private_data;
> >  	unsigned long offset =
> > -	    addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> > +	    addr - vma->vm_start + (vma_start_pgoff(vma) << PAGE_SHIFT);
> >  
> 
> Obviously correct, but was this intended for a different patch?
> 
> ~Gregory

bleh already caught, sorry for the noise :]

