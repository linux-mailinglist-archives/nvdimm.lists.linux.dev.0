Return-Path: <nvdimm+bounces-14781-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id KqzgEtEqTWpAwAEAu9opvQ
	(envelope-from <nvdimm+bounces-14781-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 07 Jul 2026 18:35:29 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9426671DE73
	for <lists+linux-nvdimm@lfdr.de>; Tue, 07 Jul 2026 18:35:28 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=qXqjB2VL;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14781-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14781-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFA2D30E8389
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Jul 2026 16:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8AF8434E4E;
	Tue,  7 Jul 2026 16:26:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C87F434E29
	for <nvdimm@lists.linux.dev>; Tue,  7 Jul 2026 16:26:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783441568; cv=none; b=gtKrkdXh8UyavSemjQ1lsfh6JRmPSMCLWA01YLFxVo++M/E9S42F62vKHrR4fk1Zu43XpCi7v5uMiHCtJKhy/byJQpkgojcwxcmGKwA/BB6EMJfXXFuxPMsbOE64WnTkX6bsdbIrdAnbCzptWgq2ZpLE//x4TPCzOyPmqyEB2Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783441568; c=relaxed/simple;
	bh=lrYSArpP0iVuUgDVG3d1222jafWM2daRLlBprnwN79M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHpBnTLquCq5pNTSYMuZDra01ZbXuvn1TfK0sMbL3cva1JBzaAb0k5fkO7eQtV2mFL9fpjFm+gpAE+OMTiOnu60KXkAjKNoAeWd+weS8FKIUeYllkaTVqTeMZV5mWC6jQVADX9JONh1ipdVaUxKf62EIbCrxBRqd2jaZsEsX6pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qXqjB2VL; arc=none smtp.client-ip=209.85.219.50
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so33290236d6.3
        for <nvdimm@lists.linux.dev>; Tue, 07 Jul 2026 09:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783441564; x=1784046364; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Abd7yWEQE6Vuyzvr8uj66ic6dsI9yDvEtRp+r0f0v0Y=;
        b=qXqjB2VLktT7tWfv4MytgFOAlT42LGEDu9zLMVKSlBpLgozC5MZXASm1CArSwhGpIz
         TX3i0YMt6Ob+kjTkKCfhCjPrYrOwYwEUznyrSwVr5grDjxDjs2a9vM8u7pNYeG8VfKaR
         nJJNip0q168rQo4w6k+CSwly51q1Bupd/rVkI0Kbx7CLyjhaERrxZtYa1k5SkREjewfn
         vI09f5PwVGwxnGjX8ya7VozjDQcosx0hB7lbLHH2UU2NIuXoCjjOiEkm2O/iJl4ThcL5
         Q3UEebgNkyRBLPHBCP7qRaW+QNRzYUk5i1nzetCXo+y3WXrR2FZlZgOlEXvKz0ILyO2X
         ZWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783441564; x=1784046364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Abd7yWEQE6Vuyzvr8uj66ic6dsI9yDvEtRp+r0f0v0Y=;
        b=Mxl/Z7EJ1/CO9r/jfJFWZ3LmyWWR8mvGONVCAtQSL24Hz15wlQMaWnwkapcJETxc5R
         9XVVuGNk2UrLt2YGjvtYyWy9lpS3eTo2pkJpcTXFanGtY5756ipC1IbgtG54cwKHWxMs
         kjrFmiZRmPxbg3UbAxqXnupyIMzxds8NZikqXodfbgjphxSoAf0Y9a8YVm6Cn5AUaSc0
         QYqBQNu655KsSuydXl0VwcsFb8ZZSglyzldKPZPB7pDuNp0pSbmBOMAM+IpMLdWrlXvy
         rRKb5JGpIFzL5GS7ETBsxHxuxGwYOCoj/NHSRyRw751Jsf6npgnvmFdD2zMNRt845hyC
         koDg==
X-Forwarded-Encrypted: i=1; AHgh+RpT64ZR9aNyXIl/7S/Quzc7LKjvupa1E09FJxpLDwsVWZnvEL2tw2LNINNjPBsIHiH0n9jhO6M=@lists.linux.dev
X-Gm-Message-State: AOJu0YypUrGzE6ftXqfO7DozgVugm65LqY+AvjmVdK36DX52V8lxbCUq
	C7dKvGmOdf6yPmOsL8yMIA80vNhmgbGNkwRgzsJ5Ke9Lb1PyOiaUUHUwTkR7WUqCF0g=
X-Gm-Gg: AfdE7cljmqpPJXxMUKRoCXO3ZcG2zYyOzfbXVgY289WA4rjbskfeuvRuTEUXiyZo5ms
	p1ZKlobjSm7OvaWhy59uGOPnJY+YunDrLMDzpNzDgSlfjZ7kDZ61u7RWNRCoNaGdI3HsvuMQhpD
	FhB8j19NLzOBwDOi7auoR5GZdqVzHAOJOvo7WkJVEyqTdKH87qupsPr7vQjJZVLSaMq1OJ4okKD
	RyObXvxb22ORNXzrtU6wLOhmh0U+fvXdew0Qt6/dzfsWov8mf8P281HlWZyXV/qIkQDaeNx4A1i
	AGxdf53BomhICraKVBLFBIPBlsrQzZvSNzIAo5c82J3ZSz8v5lyeMCyHWyXpQNg+h5upbBYk8rK
	V/xVmscMQip4uaBenPHZZlp7yZv9sIxwAEoEv5witEkca+p9iz80qUKBZ941kSzYRcEnqZvXBTy
	aROcER/Nr+1IZTVrkSU3eEiXnoymUuss5pj72NQuGTpogS45Fh0gh8CpJRV5G7y+0yTz9+O3Kag
	eiaEJM=
X-Received: by 2002:a05:6214:6011:b0:8fd:6de3:bbaa with SMTP id 6a1803df08f44-8fd6de3be6emr28372996d6.64.1783441563961;
        Tue, 07 Jul 2026 09:26:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f46f306123sm181382626d6.20.2026.07.07.09.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:26:03 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:25:58 -0400
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
Subject: Re: [PATCH 11/30] mm/vma: introduce and use vmg_pages(), vmg_[start,
 end]_pgoff()
Message-ID: <ak0olp9zA6ERCXtO@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14781-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry-fedora-PF4VCD3F:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gourry.net:from_mime,gourry.net:email,gourry.net:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9426671DE73

On Mon, Jun 29, 2026 at 01:23:22PM +0100, Lorenzo Stoakes wrote:
> In the VMA logic we often need to determine the number of pages in the
> specified merge range, as well as the start and end page offsets of that
> range.
> 
> Introduce and use helpers for these purposes.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

