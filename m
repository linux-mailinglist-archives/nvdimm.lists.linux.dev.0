Return-Path: <nvdimm+bounces-14796-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0x93CxO+T2qpngIAu9opvQ
	(envelope-from <nvdimm+bounces-14796-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 17:28:19 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9D2732E30
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 17:28:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=QoZv94y7;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14796-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14796-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 554A4303C28C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 15:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00EE36D51D;
	Thu,  9 Jul 2026 15:20:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36783672BF
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:20:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783610455; cv=none; b=mjJcenQHOYJeTrk7WL3raZ5QUGl4RzM6niM9vkQHliAJAsE4uzLi143BuL4wFvCJO3scyr9hJLVXaGwOBgwe7AzEos74AD5Xx45IbNq2NvtETwgHCoTcIPQ6MoWVZb0+h2PXAom4baPXik9oz9sesub7T2MY6jWA7PNGqC7GvY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783610455; c=relaxed/simple;
	bh=bI1J+cBiMa2SCkpHmKrJG+azHdWZ7mPEOFo5aU/4c1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpZflH4UuqgbxRsCqStEjWw9ZPCjHjR+5kLHa2EPRP+np4RHScJSys4LcczxCvhQASiJW0X5NMfSWD4Ctf+L4r1rrVs5yL15q2H3e+CN2TTIWzaqCujBJ0x/oUmN4cMZMu9KprZfFeTl2SeEh+8faommwUBUp3FIyF/6l6gX+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=QoZv94y7; arc=none smtp.client-ip=209.85.222.175
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e65e18969so79762285a.1
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783610452; x=1784215252; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3aG5hxu0JYH7EcM/cq6JX5Yef1RoVI9XARU/q8dKmL4=;
        b=QoZv94y77dZDEK1LHmTl5TBOFaD/R3F9YpP4Zh0FcZAj8RnxXtWW7YCKe1HnZ3Ss7Y
         6NR6bD6mFOTxqooMFHm/e4mHnjsAkvqPwhrpdlszh3th+w/42grdcTD/zwnQGA/MUmWB
         DVpjEVXxRea9UIUwe43FRT7lwH0Z+ruya2nZSWZdZPBlwN9OOr1JEhyGlB6V+mJn1p94
         oGW9iRApa1LL2IEBXtCHgPgvCY2WSOGBuktpWItmmj8V+mV1TUrw/r49lXqVRh3qo57P
         NL4cXF5gtepj71gSODldLfOHIKl1sNMgrjhOKvWvfD97uJ6zEOERub7X0TDEjV0cUhuE
         0Vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783610452; x=1784215252;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aG5hxu0JYH7EcM/cq6JX5Yef1RoVI9XARU/q8dKmL4=;
        b=DBsrm4Se/M2CdX9VRHmKFpq7FU8niQtok7DgaOHwYLKMTyqZ52ixMO53v+Pm12Jgm0
         DAkcqqyfV/RTcF5m4tGRGMbz9OESABpsbZDgdeqCJowrjUZrHhQJIOTYmlh8yTPbrGmD
         yY5ySv0p/m9k/QBCgsm3ZdGSSaaMoHduJ9MuldkWR9b6YRTE77MR14NRogQCvjkupXX2
         f1mKRV6iRw+9sJh+Q21+AjeUvXrr8Luw3rA5ASneJyHvkSno4zz/KW5+D9LOdosFa5ky
         rd+LxWNaKkYcEFTviLwnkfnG0z6gPQp3VjYwDy5jAPZDbhtr/DWme7kNf/vo5MTxiEAl
         oSDQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8cyNTsVqNNpYijexfWV8NMbz+fl2LZQEa644mbwqBs6tcVoMKmpdWZIyjtlxIk3GT61MQyHY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+TGUzJYZFVEV+bfEIh/wII/77g3B6yqEJP8w5wqDN53T3o9SS
	s9L5L7Eft9EmFLRrN5JPYHMy9JfVZmFgiRAho1VMdO9AhUG5Z6j3rOpKbNOeqrE400I=
X-Gm-Gg: AfdE7ckFQ7KMPTsK7fsFyNZDbUcbVeVOGtWbunjLS0AMV2pAIsWLeY/un9ptry2PzVA
	p3exRGF9liTHndXWrrQmA4XQKRkzcjbd32AlimvZZKjCPQqA+NtfYhKIzYvHgwX1aSblZbws0eX
	/MHVO+FnfDLlqH0enS0DdAoTij+7pYauX2f74v0YC7EQ5ePs0RAx7Bm+TFssC6IYS/2Xe7RX3EE
	OOplzVJvLr4dHsnaTW02ykxeJluEApklbrFlajfttepGEglHw+XyHKun4SLH9iGBaNL6APvJI/N
	QfTLnz6WShnp0o+4qPVnptZenfHTrucLzsHsTW3coFUFwnGZze5GWJPTnk4X82h7mDI/6kj/6g8
	Vxb3hz6UDlroZwHp1NQr1l8OeZ2pxrToGfaepQ8GV8pwhqv6BZckkSeXjq5N2myo5uzns24Aunw
	dpYrNf61dH9Es6EdRf9/ldbCTOTbSKrvLUmHjqQcKzjQtwtzO9OHxFTYtT/DKXYlSOZLOQ
X-Received: by 2002:a05:620a:179e:b0:92a:f74f:904 with SMTP id af79cd13be357-92edab23ef2mr337298385a.1.1783610451142;
        Thu, 09 Jul 2026 08:20:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90ca90a5sm1652288685a.32.2026.07.09.08.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:20:49 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:20:44 -0400
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
Subject: Re: [PATCH 14/30] mm/vma: minor cleanup of expand_[upwards,
 downwards]()
Message-ID: <ak-8TKDC1GBOeMOM@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b24f70b72f0a9e2a37b904e5b59d80b88bd42e4a.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b24f70b72f0a9e2a37b904e5b59d80b88bd42e4a.1782735110.git.ljs@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-14796-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry-fedora-PF4VCD3F:mid,lists.linux.dev:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,gourry.net:from_mime,gourry.net:email,gourry.net:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: AB9D2732E30

On Mon, Jun 29, 2026 at 01:23:25PM +0100, Lorenzo Stoakes wrote:
> Adjust the stack expansion functions expand_upwards() and
> expand_downwards() such that they are expressed in terms of named constant
> values, and make use of vma_start_pgoff().
> 
> This clearly documents that we are referencing the page offset of the start
> of the VMA.
> 
> Additionally this cleans up the overflow check in expand_upwards().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


