Return-Path: <nvdimm+bounces-14618-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id kEx5OT8NQGrCbQkAu9opvQ
	(envelope-from <nvdimm+bounces-14618-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 27 Jun 2026 19:49:51 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 404936D26DA
	for <lists+linux-nvdimm@lfdr.de>; Sat, 27 Jun 2026 19:49:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GTCL3n8B;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14618-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14618-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1904E3024523
	for <lists+linux-nvdimm@lfdr.de>; Sat, 27 Jun 2026 17:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AA0345CDD;
	Sat, 27 Jun 2026 17:49:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D94630E82B
	for <nvdimm@lists.linux.dev>; Sat, 27 Jun 2026 17:49:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782582571; cv=none; b=ourxOe5lNrNNF5ACUO0rKAAsRVQCkD1WFtn/tFzmAZCZ0LkvxquMgU9PBxrFmSiALG+Z4aZzBH1WBMVX6RcQSmL1K2sJhFtJZqFsLpivIVBeQDx5n3zK7nhte6cxKN5si+JqEYiQJiLaE6bqlx+y2vUMxOXWTrpg+F8TOWXqEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782582571; c=relaxed/simple;
	bh=YA+1i/UnBYMi612cEFEOy+3MzER+Xfj7iA6l8jGXb4M=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqBWml+sZkZLyg3tgy3QWUrv+O87pvRvuZ80rDtczf5Wgo6yto2O9I/3FkFj/I+vhxgFODDK2NfOTzrlCZA2Jf6Ma0Q2cxq0emG7r4fRbVPkP/4UBoQKuhzsPUWPYpC5apcJmHKqjk27WwGuY+hwyQUVSRZrQ70/uoTpSELuNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GTCL3n8B; arc=none smtp.client-ip=209.85.217.51
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-734dfaa3d9bso1368704137.3
        for <nvdimm@lists.linux.dev>; Sat, 27 Jun 2026 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782582569; x=1783187369; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+uflCN5dEoFADXWjqBtV9JZXNhAeBkbLG/4dD0z7b4I=;
        b=GTCL3n8BI5SgH0Vi2fqukut7FUDCw8IIqWMJlw17lHppfN63UhZCOKdp2yX+2GT+lr
         k4wgk/C7mNZQ41G8a+5oKzQF21CdOkuSrlCLw4qCkhuyvTqME2NkyNs/ZUrqsGXEhInG
         KpsmUA7AiVKBEC/MgqmqBbKUBKaeQ/uRZdqA0JMdQ1Rcjo4iADympJ8btajCPdyJe2eM
         XtKxNXwusVSwOvZtYNJA/MDSHZHUwIwfCIpKHPKlq2CbXqMC67KRpg63PEFgo9v3dyG0
         /pJDumKenO9KpAQhU6gZq/ZTT2TN9M1mV3tYe5wTshGzIUHsJV4kEzd8wyMV4NpTaFpN
         Umlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782582569; x=1783187369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+uflCN5dEoFADXWjqBtV9JZXNhAeBkbLG/4dD0z7b4I=;
        b=kc0i3fawwr98lkCO47/qNUdJxQNBKfjMcBnent9danuICV5emdRJX21lhArpja36iQ
         vrEXpXcXyc5glZy1ULCFfrpgzEUu4Kfk8V26LIvuG3TnQEG+5oOpNteKBcOMD2QXNfOs
         MmSERG2VBI2cLiLhD+u9IclNymFjIoJfnSQ/jvSK1hdB4lFE+PKm/Hy72glqzzyUwvlM
         DjsReideCQhIcBeYL7BBurOdkjjZqmDcB/Gc2qWkXJcioNuAPLMst3TSCJs/EEftsPPT
         Q/d9UdweDqUw62incALLqBV5NQU93L0NKPfDJMv0jj68JUb0N+pMjWXga7wrcoEpuJ2T
         UUqw==
X-Forwarded-Encrypted: i=1; AHgh+RqHj0sjnakBVAcvAUBWR8ZJp2nuMArP5ucUOLHMLHihrrbFLqUhVS7cIVctf9U6em/Eh7qmuMA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwF2HCXc2wdNIAnzis4YwcZgKbxxxprkPDdlneHz0M8c2HZLEMI
	WPD472IgCrjzghf2DVWnuaufA5hNu69lqPfGo6OzPARlm0BbyFEKHXnH
X-Gm-Gg: AfdE7cmviZEJOQ2ekFf30xjD6LyLmQ4FHykvojRBS6uwpWmfMkA7iMm1dMaCTFflRQQ
	om81noEkMLyCI2l8sKTIi74ZgTRKJ/k5dkkIYSoiB8y3/1mzeJU94J3GE0aJRq54AQxBXtPbjha
	WHhB0Y6+6jg7x5Ng95OpUdb3icR3lTpNNCWFu0RO9LuGt5hC53q9nC5nHoKUefWvHHqgsFJjEHv
	wazCMzSgtWTuvtx1mPy3a6n17B24h/fsJmNucwJ8C3s6BiAO/FwAI9tWKruSxjbWgKJTvbYEA4H
	wZWc1dqTffM9c2g/+4j+yv8WVwZMRChAUZ5VcMk4rw4sryF10g+2ZtvjR3KOAzXOB51KYfpIahq
	es7R+gsN4GfEVSupwdMkmuw6tv1F3vc6X5oZt5yKSC1U2vchklk7Q4N7h7nPxwckjowpXBsLzhi
	sbsDMHYb0AkM9He9umrZre+iVFwSmwO4DGlb5tH8m8VbB/
X-Received: by 2002:a05:6102:440f:b0:730:db02:1d08 with SMTP id ada2fe7eead31-73434452fd5mr5471882137.10.1782582569056;
        Sat, 27 Jun 2026 10:49:29 -0700 (PDT)
Received: from localhost (d-24-145-72-22.fl.cpe.atlanticbb.net. [24.145.72.22])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-96916e5b10dsm2811280241.4.2026.06.27.10.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 10:49:28 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
Date: Sat, 27 Jun 2026 13:49:27 -0400
To: David Laight <david.laight.linux@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Will Deacon <will@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Xu Yang <xu.yang_2@nxp.com>, Linu Cherian <lcherian@marvell.com>,
	Gowthami Thiagarajan <gthiagarajan@marvell.com>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	Khuong Dinh <khuong@os.amperecomputing.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	Yury Norov <yury.norov@gmail.com>, Kees Cook <kees@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Besar Wicaksono <bwicaksono@nvidia.com>, Ma Ke <make24@iscas.ac.cn>,
	Chengwen Feng <fengchengwen@huawei.com>,
	linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-perf-users@vger.kernel.org, linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org,
	linux-rdma@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-cxl@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 13/16] perf: Use sysfs_emit() for cpumask show callbacks
Message-ID: <akANJ-AT7nHpRMq-@yury>
References: <20260528183625.870813-1-ynorov@nvidia.com>
 <20260528183625.870813-14-ynorov@nvidia.com>
 <7e980b99-1e4e-408b-8ebd-4d28116e7ad5@arm.com>
 <20260529130619.12f24264@pumpkin>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529130619.12f24264@pumpkin>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14618-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:david.laight.linux@gmail.com,m:robin.murphy@arm.com,m:akpm@linux-foundation.org,m:linux@rasmusvillemoes.dk,m:linux@armlinux.org.uk,m:Frank.Li@nxp.com,m:s.hauer@pengutronix.de,m:kernel@pengutronix.de,m:festevam@gmail.com,m:maddy@linux.ibm.com,m:mpe@ellerman.id.au,m:npiggin@gmail.com,m:chleroy@kernel.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:mark.rutland@arm.com,m:alexander.shishkin@linux.intel.com,m:jolsa@kernel.org,m:irogers@google.com,m:adrian.hunter@intel.com,m:james.clark@linaro.org,m:tglx@kernel.org,m:bp@alien8.de,m:dave.hansen@linux.intel.com,m:hpa@zytor.com,m:rafael@kernel.org,m:lenb@kernel.org,m:gregkh@linuxfoundation.org,m:dakr@kernel.org,m:cw00.choi@samsung.com,m:myungjoo.ham@samsung.com,m:kyungmin.park@samsung.com,m:heiko@sntech.de,m:lpieralisi@kernel.org,m:yilun.xu@intel.com,m:trix@redhat.com,m:mdf@kernel.org,m:yangyicong@hisilicon.com,m:jic23@kernel.org,m:dennis.dalessandro@cornelisnetworks.com,m:jgg
 @ziepe.ca,m:leon@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:bhelgaas@google.com,m:xueshuai@linux.alibaba.com,m:will@kernel.org,m:jiucheng.xu@amlogic.com,m:neil.armstrong@linaro.org,m:khilman@baylibre.com,m:jbrunet@baylibre.com,m:martin.blumenstingl@googlemail.com,m:renyu.zj@linux.alibaba.com,m:xu.yang_2@nxp.com,m:lcherian@marvell.com,m:gthiagarajan@marvell.com,m:jisheng.teoh@starfivetech.com,m:khuong@os.amperecomputing.com,m:daniel.lezcano@kernel.org,m:rui.zhang@intel.com,m:lukasz.luba@arm.com,m:yury.norov@gmail.com,m:kees@kernel.org,m:thomas.weissschuh@linutronix.de,m:aboorvad@linux.ibm.com,m:ritesh.list@gmail.com,m:ilkka@os.amperecomputing.com,m:bwicaksono@nvidia.com,m:make24@iscas.ac.cn,m:fengchengwen@huawei.com,m:linux-arm-kernel@lists.infradead.org,m:imx@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linuxppc-dev@lists.ozlabs.org,m:linux-perf-users@vger.kernel.org,m:linux-acpi@vger.kernel.org,m:driver-core@lists.linu
 x.dev,m:linux-pm@vger.kernel.org,m:linux-rockchip@lists.infradead.org,m:linux-fpga@vger.kernel.org,m:linux-rdma@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-pci@vger.kernel.org,m:linux-amlogic@lists.infradead.org,m:linux-cxl@vger.kernel.org,m:linux-arm-msm@vger.kernel.org,m:davidlaightlinux@gmail.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[yurynorov@gmail.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[arm.com,linux-foundation.org,rasmusvillemoes.dk,armlinux.org.uk,nxp.com,pengutronix.de,gmail.com,linux.ibm.com,ellerman.id.au,kernel.org,infradead.org,redhat.com,linux.intel.com,google.com,intel.com,linaro.org,alien8.de,zytor.com,linuxfoundation.org,samsung.com,sntech.de,hisilicon.com,cornelisnetworks.com,ziepe.ca,linux.alibaba.com,amlogic.com,baylibre.com,googlemail.com,marvell.com,starfivetech.com,os.amperecomputing.com,linutronix.de,nvidia.com,iscas.ac.cn,huawei.com,lists.infradead.org,lists.linux.dev,vger.kernel.org,lists.ozlabs.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_GT_50(0.00)[90];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yurynorov@gmail.com,nvdimm@lists.linux.dev];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,yury:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 404936D26DA

On Fri, May 29, 2026 at 01:06:19PM +0100, David Laight wrote:
> On Fri, 29 May 2026 12:05:08 +0100
> Robin Murphy <robin.murphy@arm.com> wrote:
> 
> > On 2026-05-28 7:36 pm, Yury Norov wrote:
> > > These callbacks are sysfs show paths.
> > > 
> > > Use sysfs_emit() and cpumask_pr_args() to emit the masks.
> > > 
> > > This prepares for removing cpumap_print_to_pagebuf().  
> > 
> > TBH, looking at this diff I think it only shows the value of having a 
> > helper to abstract the boilerplate...
> > 
> > I'm not sure I agree with the argument of removing something entirely 
> > just because it may occasionally be misused, but could we at least have 
> > something like:
> > 
> > #define sysfs_emit_cpumask(buf, mask) \
> > 	sysfs_emit((buf), "%*pbl\n", cpumask_pr_args(mask))
> >
> > to save the mess in all the many places where the current 
> > cpumap_print_to_pagebuf() usage _is_ entirely appropriate?

This way you have to add 2 wrappers:

 #define sysfs_emit_cpulist(buf, mask) \
 	sysfs_emit((buf), "%*pbl\n", cpumask_pr_args(mask))

 and

 #define sysfs_emit_cpumask(buf, mask) \
 	sysfs_emit((buf), "%*pb\n", cpumask_pr_args(mask))

There are people who complain even about DIV_ROUND_UP(), how hard it is
to keep all that helpers in memory, and all that things.

https://lore.kernel.org/all/20260304124805.GB2277644@noisy.programming.kicks-ass.net/

Disagree about DIV_ROUND_UP() (because yeah, I'm bad in math), but
this sysfs_emit_cpumask() is a complete syntax redundancy.

Once we have it, people will do this type of things:

        tmp = kmalloc(PAGE_SIZE);
        sysfs_emit_cpumask(tmp, mask);
        sysfs_emit(buf, "my prefix: %s\n", tmp);
        kfree(tmp);

Patch #1 in this series is one example. My series that removes
bitmap_print_to_pagebuf() will give you more:

https://lore.kernel.org/all/20260303200842.124996-2-ynorov@nvidia.com/

It doesn't mean that *you* will misuse the API. It means that *I* will
have to inspect the codebase for that type of bugs periodically.

So, the overall state is simple: we've got well-established
printf()-like functions that people know and understand, and we also
have exotic APIs here and there with a non-standard interface and a
clear potential to misuse. In this case, they have historical roots,
but now we don't need them.

> That has the advantage of letting you change how it is done (again)
> without having to find all the callers.

You mean things like silencing the prints or adding a prefix?

If you believe that perf subsystem would benefit from it - that's
OK. Just please keep it local. The kernel globally doesn't need to
'change how it is done' beyond the lib/vsprintf.  The kernel really
needs people to use something that the other people are familiar with.

Thanks,
Yury

