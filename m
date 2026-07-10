Return-Path: <nvdimm+bounces-14838-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NkXQKfdBUWqFBQMAu9opvQ
	(envelope-from <nvdimm+bounces-14838-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Jul 2026 21:03:19 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9FF73D819
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Jul 2026 21:03:19 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=qj3hG3K5;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14838-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14838-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F5D7302F9BB
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Jul 2026 19:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16402380FDD;
	Fri, 10 Jul 2026 19:02:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E56C382398
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 19:02:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783710126; cv=none; b=bUWCIfMuTEYHZr9O3w86eP1hkMF5TLyl7kFPwXQpOTn/SFGnYt+uQZ2PSL6NgSexLoxELDLDK+jp56306/820o1WLIe7/r7nwKSGCJJgm4lMVV96hL7jGU/e3g/1APa50A2OPWygJ45kvZH5ncKpKsdiBp8FV+fqSfTMTzknPZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783710126; c=relaxed/simple;
	bh=47yOZh0uL9PiUmgaP7WAHRIYSRvyXRhMxAEwOuVsgWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEz0i/sOtyyr3+khdj+CibkIagJ6aYraiZOhTwvUof7AjXx0gOofwiClH1WZNbqeqFvVLEe0w9vAK25aygdT4rZJo/C50yncbfUphKATDbsmGK+KZXihPMU90b0OPZLsnUW4VEqSUfRqe8RxhqyLvNZD56CDBP4bpC/JviUrghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qj3hG3K5; arc=none smtp.client-ip=209.85.217.54
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-73a75f251a7so369038137.2
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 12:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783710124; x=1784314924; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pC/3U7Ftz6dY/QSNTLtw6DNyhuKVUlnEMcNANT8zsUU=;
        b=qj3hG3K5GJstRdx4P8mI49geBnx1AwKrEXmFU9weImfE+s8EwYAtVGpMhdHjEF6ULC
         OjFldmI/TWaGd6/W3ciKhkslBUhns04lhs8Xr3V/dVqM8TgxVZkNVIsugi1I4kD9y1Yn
         TsE0ZotCu9FjdZ4ljyYy8vXSS/Ft0QWVcvPNZSPELYD118Te5rgAkDAnpEu/weIfq9uD
         Eo02S4mYfywvXXY60z1BnaLFgT6Efj04lKJOAz82AkDRhgMbS0mdZaZXccngwx1pgJs9
         B4CclEhOyx2CgTKTnJaieib4uy3SQGOSRc6LuWwWVAthKPG6Q1WfGDU5Y21OeOZdYjg0
         xJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783710124; x=1784314924;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pC/3U7Ftz6dY/QSNTLtw6DNyhuKVUlnEMcNANT8zsUU=;
        b=FDLLmsjLB68ckTmScYHxvS57kvjfnDlifWsZFKbu1gQXKv67Z9b3zSRnGO8fcDYJmT
         u/ob2QgWe0Zvh7GV4vd7t+f4NcP9J3szGxTSyR+pthic2phHVWo+ScY6+6U+GejxlYQ3
         Qs08KioSxTamknDYzge6DP5lzpDI+wtDVIhnGduzMBq2Id5fm36PkwZtRaY8aanxaaxy
         igFiQHUGTjJ/KLdqqH0QmfkG4qrTZT3FTOTlD5iqhVN2krtpLXyM0N/EN8xfDQv7hd+R
         vCW679MXUGuegKhMjSUefJ5c9QzA2jJLzxupra/5YgPAJ0A7C+ndoGRFBKXWXig8umyf
         MtFQ==
X-Forwarded-Encrypted: i=1; AHgh+RpbCg0r+qU2dDRxIjEmpyNhbLzeBdgVjcj7S63PnU+Z1ERkMRze5gWrUPCfp5mjwvvRoTqlouE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0wEzAoSimfxWrFpph2Rue3/6+fY5uuz1GoJgQhpGjW988YXW0
	smRO6I/aO2haAX8agjB1t0iBa9aHnpvZX3Ap81SGa9da5bLNiB++q5V3kq0tXMXnG6g=
X-Gm-Gg: AfdE7cklSGU7JU+3M6O+dLGyD9ODA+Nuf1fuVhRcpNRK1JEjXAB3ToxeciN22FclShi
	m9TWzg8K7j7RmTABrGS47eKiuAX2FjgQElKvJ7HkN5GOUMu5yMY1pXXMsrDg2QXTpZ2Zv4zgQSn
	KNc9KRDvnZMxtCpaZkfRu0kQibOSd78txQTWmeI318PWEgGsqeTQqEQTuyPDGFNK8+wFJeOtYIP
	GQCukWI7Z5Z+JP4uo/XTyrnMf833nPvXDaNr+8JdZ844fkqYiUNzsavtGzsBqipb5DZvUUXFqjv
	UFqhHVh/LgBZ0/Gpghi6lNjdepc6Ja9kKtL660C4X+grL/6RdJN+GRnABBoh58Q5viPARyYs8WZ
	S3nER+D7TVjKzvLqqzznuJws9T7+htUX+J673kewK+7sraZxkHEFf/eHHmnM8Azc6Aane1FjNIs
	VO0jn6zp+C59HCJVhd+gfO1UQpgaJc/2qwATrlROyZp1YoV4euPyIZkbG4TbchGk/LYe6L
X-Received: by 2002:a05:6102:689c:b0:739:5f55:3c3c with SMTP id ada2fe7eead31-74533d66217mr325833137.13.1783710114831;
        Fri, 10 Jul 2026 12:01:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56c4b91sm48074036d6.19.2026.07.10.12.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:01:54 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:01:49 -0400
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
Subject: Re: [PATCH 21/30] mm/vma: add and use vma_[add/sub]_pgoff()
Message-ID: <alFBnZ8RcRN1hlk5@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14838-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:ljs@kernel.org,m:akpm@linux-foundation.org,m:linux@armlinux.org.uk,m:dinguyen@kernel.org,m:schuster.simon@siemens-energy.com,m:James.Bottomley@hansenpartnership.com,m:deller@gmx.de,m:jarkko@kernel.org,m:tglx@kernel.org,m:mingo@redhat.com,m:bp@alien8.de,m:dave.hansen@linux.intel.com,m:x86@kernel.org,m:abbotti@mev.co.uk,m:hsweeten@visionengravers.com,m:l.stach@pengutronix.de,m:airlied@gmail.com,m:simona@ffwll.ch,m:patrik.r.jakobsson@gmail.com,m:maarten.lankhorst@linux.intel.com,m:mripard@kernel.org,m:tzimmermann@suse.de,m:robin.clark@oss.qualcomm.com,m:lumag@kernel.org,m:tomi.valkeinen@ideasonboard.com,m:thierry.reding@kernel.org,m:mperttunen@nvidia.com,m:jonathanh@nvidia.com,m:christian.koenig@amd.com,m:ray.huang@amd.com,m:ankita@nvidia.com,m:alex@shazbot.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:djbw@kernel.org,m:muchun.song@linux.dev,m:osalvador@suse.de,m:david@kernel.org,m:surenb@google.com,m:liam@infradead.org,m:willy@infradead.org,m:m.szyprow
 ski@samsung.com,m:peterz@infradead.org,m:acme@kernel.org,m:namhyung@kernel.org,m:mhiramat@kernel.org,m:oleg@redhat.com,m:rostedt@goodmis.org,m:sj@kernel.org,m:linmiaohe@huawei.com,m:hughd@google.com,m:rppt@kernel.org,m:kees@kernel.org,m:pbonzini@redhat.com,m:linux-kernel@vger.kernel.org,m:linux-arm-kernel@lists.infradead.org,m:linux-parisc@vger.kernel.org,m:linux-sgx@vger.kernel.org,m:etnaviv@lists.freedesktop.org,m:dri-devel@lists.freedesktop.org,m:linux-arm-msm@vger.kernel.org,m:freedreno@lists.freedesktop.org,m:linux-tegra@vger.kernel.org,m:kvm@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-mm@kvack.org,m:iommu@lists.linux.dev,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:kasan-dev@googlegroups.com,m:damon@lists.linux.dev,m:pfalcato@suse.de,m:riel@surriel.com,m:harry@kernel.org,m:jannh@google.com,m:patrikrjakobsson@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[gourry.net];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[gourry.net:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[76];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0E9FF73D819

On Mon, Jun 29, 2026 at 01:23:32PM +0100, Lorenzo Stoakes wrote:
> Add helpers for adding or subtracting to a VMA's page offset, exposed
> internally for VMA users within mm in mm/vma.h.
> 
> This is to lay the foundations for tracking anonymous page offset for
> MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> value must be reflected in both the file and anonymous offsets.
> 
> These are used on VMA split and downward stack expansion.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


