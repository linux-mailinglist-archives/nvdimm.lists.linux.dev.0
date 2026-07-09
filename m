Return-Path: <nvdimm+bounces-14784-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id gkh1BmvmTmp4WQIAu9opvQ
	(envelope-from <nvdimm+bounces-14784-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 02:08:11 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C81A72B4DD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 02:08:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=google.com header.s=20251104 header.b=mhJVIkM4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14784-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14784-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F386302EE87
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 00:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C7133985;
	Thu,  9 Jul 2026 00:06:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3101E4AF
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 00:06:05 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555568; cv=pass; b=Th9XI8bT0HfbbhMbXsXQ1P/pU1D7lx8NQY6AFtYdbx52elrVUD0Tfr14xZ0VitY5oIyRg2PCZkXF18rwytA7jj2Nd3FQ+bnyl0VwJAlMoxMcHf7NhuaxpwVAMGa+EAFuK/s59Mcrut/wUT6qjxJ1+nojrynGxePGtrFHET6NCx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555568; c=relaxed/simple;
	bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xr8I7gO+FBZwTiL8OSr00MP+2+VWZooOFx912C0lL86rIGo2mBSyp540K2GSgFj8qb3BhxqLjFM0s/A8e5kA9Mu+WIO4IgR5FbHTESxTpmY0WZu3Evb69KzgQiwJ7rjJN+fIHul5UObb8eal5IhQe27HjmpuYpdAmm6PauxsI6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mhJVIkM4; arc=pass smtp.client-ip=209.85.210.171
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8478fe07f65so1274622b3a.0
        for <nvdimm@lists.linux.dev>; Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783555565; cv=none;
        d=google.com; s=arc-20260327;
        b=YSURwTc8ixvfY7F6Ca6Sf4I/eyZIG6F/2UPwtn2GLiVBET3QkINUDEoKnae6Figlvc
         5oN21GI7yWJvkiUoXf/Gwbdp3McKPxqBv19SbnlgNFRPon6b3jGYIHo4VVfySTSQHm3k
         GJADdNueL1ZBCMaD8YUTKMbS2yPyu5FEAPvE9ovFdbqb9MIDw/g7A+aUjTujFhqL0F5b
         psKfc89YJgMVdg++yg0eoueZekLTEodHj+dlXTmpbH2Vz4JUluyrvHNLK3tTYT4cZzB/
         ZG4OTPjye+/Q/2FqBUElb//vj7kgAR2xEQQRq8xtXwcj1QtTtdUUIDisne3E2HOPnGWi
         YxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        fh=gLNcFHgeQREuW/TqizE/LKvC42DyKn0MLKrHTzdxsWo=;
        b=n9JrI9KJd8l4meQNsci4r0MkdNIM1xbl6tf/A29MFMny3fSLNFN39zMz+lpCuSbn49
         ceG7fgE1uzCutV+f87PyRpPd3qGiQgwJAj4OrF6oKIGONmJhyMexjoXtn3KLnxFNFWyg
         PZa7S67wSNaBAC6b12aEfW+sSZ4sbpsxaq9XmffdPC0u3FoD0rsLGjxOYvSSQ0ggXuDo
         Y35G55tvwRbTPggLkMH/5K8AmqViYiHpIlMNfGoV4Ah4TWZ0Wzu2XAustf/uF0Gu91kA
         pirpiE4QqtX/0f1wjZ0wzmkCCX4mboF3AZJwTJjNYprm1Or5sVpR2t8WCGXPCDNXKm3U
         v6jg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783555565; x=1784160365; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        b=mhJVIkM45OUDuijRQhJCGxMcU4BVaSp09AqI2hnS8Ki6Y6RNFNMGZ4/s5R5c1f5k7g
         ziB/d0CifLhaaoJPcgMNTX2C4Y5sePITm80rllyzjo18F1N2XBSAFdelBGxCML25Dr+H
         i/IOXVXIVf4nt32cpdS6iwjJ9QA/wGCnpVxulS7vrXczeqHIgpKYKq7NRz8vrh98O7KN
         EUt7H5pa/xxqvKGKFJcdpcFeD/+SbVJVYdZwcEFNbf2iwKW/Kn2h13I/J4BZ13eC0LT4
         DRrg1nj9suGX18iFVRUHlOkjYa0e75X9oxIKH+8iJ8QKKqjLU0//McufwrR9QMK1tg7x
         /CXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555565; x=1784160365;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        b=QRbDkZ5IJYzo8y/ufQa5ZFyzXwdt2g9fKLQjhqa5q/LtLvx5JcrTZCL1yt4lelZKDf
         3sufMI1+CGiVRB0ASPRLJg79uM7eq6LfhIF36sgTWICnQInbuCeFPcZp/BCd5J3OcOND
         ShPclR6v3mR5KDMzwL6SEr4dmyb3KSIXIBtB0OFaU+w2BXCraxo57lBRclzGUWpncVw1
         o1M7JyuU065RvlpKd22ETV4PkhTVOyCfDrpfEX2Lz5gpq5TDvnp9fP0kfIDdZK36yVDV
         ZeM6OEFD6Jl6CjTv2HA2SNF0VNi2X570VxLV2T7qvjDmFzbZFzSbX58PasEFQHInJtFh
         pg5g==
X-Forwarded-Encrypted: i=1; AHgh+RoqHvYiy9e7MnBsKC7szHK67vqxlc+pv133yPjjVjfx3KONA7ygPbxs9iO1nUdj+ENSsJPnbQE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3eOunzeesTu69szO7PfKhK704IAKmO6o6GbdvpcmdMvDgbZd+
	QCx8qxHDp5T8pE0BlBpWgveYR7drCTL0iTe2NgTVzOBtM0EldFjALf0jusO6khiSMXEstG66pdA
	ZjJp6ME70J6CnznnN+hxSYpHcAR2+jlQiym7oU4i2
X-Gm-Gg: AfdE7cmbZNQpMSPMYDn7PI45J0yRoPulPmbJJFaCrtB/XL9qNb8MvLHQl/KlOM6RSWn
	Gbta0eiOsTrqCnAY4IVDWrHxn7zGWhSJeIYUnzFy2LRb/vcEHRUW6W359LTRC86/UomE+E7ScxY
	c+1LJ0q27Rhz0q9i6kMBRYJQendLx8OEYAW+XPOyX+Kh27f8aR680LMzV093glQMacLG9iUgTIo
	0jDWNR+H9xDjfVb/cnr11eqLDJDF9leKJdXErdJCaehHwGaz1pjICGDCwkA+bhc/thM0KXri8Sw
	z3T9R6h2eMQgO7sgdbDP9BIcDh53uWxhjxY/OMRSFQWSLPvCoKkRAfWPtwWTxHjKnByTTw==
X-Received: by 2002:a05:6a21:7482:b0:3b4:669c:ee32 with SMTP id
 adf61e73a8af0-3c0bcbc1353mr5760887637.37.1783555564841; Wed, 08 Jul 2026
 17:06:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org> <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 8 Jul 2026 17:06:03 -0700
X-Gm-Features: AVVi8Ceg-PSWltTScKU18ZF0mdbBsNHDv0s-VKhIaqzjwQ-q80D6zfZMKk_VWII
Message-ID: <CAEvNRgE-JJAzC0jp+bY8+e1+gYSH+MjT6JqX_DfCcpaxOM-Dtw@mail.gmail.com>
Subject: Re: [PATCH 15/30] mm: introduce and use linear_page_delta()
To: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>, 
	Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, 
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	TAGGED_FROM(0.00)[bounces-14784-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[ackerleytng@google.com,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:ljs@kernel.org,m:akpm@linux-foundation.org,m:linux@armlinux.org.uk,m:dinguyen@kernel.org,m:schuster.simon@siemens-energy.com,m:James.Bottomley@hansenpartnership.com,m:deller@gmx.de,m:jarkko@kernel.org,m:tglx@kernel.org,m:mingo@redhat.com,m:bp@alien8.de,m:dave.hansen@linux.intel.com,m:x86@kernel.org,m:abbotti@mev.co.uk,m:hsweeten@visionengravers.com,m:l.stach@pengutronix.de,m:airlied@gmail.com,m:simona@ffwll.ch,m:patrik.r.jakobsson@gmail.com,m:maarten.lankhorst@linux.intel.com,m:mripard@kernel.org,m:tzimmermann@suse.de,m:robin.clark@oss.qualcomm.com,m:lumag@kernel.org,m:tomi.valkeinen@ideasonboard.com,m:thierry.reding@kernel.org,m:mperttunen@nvidia.com,m:jonathanh@nvidia.com,m:christian.koenig@amd.com,m:ray.huang@amd.com,m:ankita@nvidia.com,m:alex@shazbot.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:djbw@kernel.org,m:muchun.song@linux.dev,m:osalvador@suse.de,m:david@kernel.org,m:surenb@google.com,m:liam@infradead.org,m:willy@infradead.org,m:m.szyprow
 ski@samsung.com,m:peterz@infradead.org,m:acme@kernel.org,m:namhyung@kernel.org,m:mhiramat@kernel.org,m:oleg@redhat.com,m:rostedt@goodmis.org,m:sj@kernel.org,m:linmiaohe@huawei.com,m:hughd@google.com,m:rppt@kernel.org,m:kees@kernel.org,m:pbonzini@redhat.com,m:linux-kernel@vger.kernel.org,m:linux-arm-kernel@lists.infradead.org,m:linux-parisc@vger.kernel.org,m:linux-sgx@vger.kernel.org,m:etnaviv@lists.freedesktop.org,m:dri-devel@lists.freedesktop.org,m:linux-arm-msm@vger.kernel.org,m:freedreno@lists.freedesktop.org,m:linux-tegra@vger.kernel.org,m:kvm@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-mm@kvack.org,m:iommu@lists.linux.dev,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:kasan-dev@googlegroups.com,m:damon@lists.linux.dev,m:pfalcato@suse.de,m:riel@surriel.com,m:harry@kernel.org,m:jannh@google.com,m:patrikrjakobsson@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[76];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5C81A72B4DD

Lorenzo Stoakes <ljs@kernel.org> writes:

> It's often useful to obtain the number of pages a given address lies at
> within a VMA.
>
> Add linear_page_delta() to determine this and update linear_page_index() to
> make use of it.
>
> Add comments to describe both linear_page_delta() and linear_page_index().
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>
> [...snip...]
>

