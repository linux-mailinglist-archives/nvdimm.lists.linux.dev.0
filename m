Return-Path: <nvdimm+bounces-5654-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CB367B85B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Jan 2023 18:22:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCA7D1C208F5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Jan 2023 17:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C746FAB;
	Wed, 25 Jan 2023 17:22:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFAC6FA5
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 17:22:36 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id m199so8144627ybm.4
        for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 09:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IqJXv+IInDU1mKTOWecSjx46uIp9RhIiEah7PjvPLrg=;
        b=QlZyecSvRJAlH7daZiVbTmdMCDJawwIkjqybbPcYd50INvCOOFwycJjGFsDCENBvPF
         JeBM9yeOQDknmaZC6LT0p7wlzLAJo3QYgAn7K1xQNCTJjPrh6oinOxgRNGwGedAqUfeH
         4EF6oknHwKU0N6BIZOc0CJi1hrgM4W0zxm3gicvvOuEGF7JC9HCNICDdMPEAz6Lz/B5y
         FN2dpyuojKkpe3r7ipsFxRIyHaJ4nJmkiiUGkQy6aOsuBhBZ3WzwUsGkq0uXDlGTKFEH
         iRh4N/trPN148wcbBUC1DmqB3ErHQLF9n9pkmMXooLK6oXyXf0aS41iIJv2buhnN7zSu
         X8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqJXv+IInDU1mKTOWecSjx46uIp9RhIiEah7PjvPLrg=;
        b=76Q9yKMFff767hQSTe9FrKt1w0R7LHFdWTvxL/90LdjYfygEcpXiS48HaoE6tu0k3e
         ctxZuKU2o3RfuxWpfv0an/COQ/UhBQNh6CULe1+N+MaTVwoyH7Vz46goeFKdb7M4QuYS
         iZP0HZnaD6cwr7oQAqB/KaJVaWn+1jaND0ArIAP9a6GD/fHjgIDlj2dnkQfUj08rnvRH
         q2G387EBdUiK5YExdMS4qu6e0KlTYWsb18e2kMNSagESXUVJDNFrCjmiEB02cEXDYpdN
         2b/agT4OuaP5y+SwrSnH3qyOuERo4XFHfyJJ6xsYm4h3dpsD/05Deb3dqikTlEaEN1sx
         Zskw==
X-Gm-Message-State: AFqh2kqzJIfU0HEMMHD/a50+sQ8TmFtJKrMyAj8dX5IDk+pKWMtRxZO5
	EJHlfAzR45IQFykfk4rruANgKI8Jn0mjTXtJL3AwGA==
X-Google-Smtp-Source: AMrXdXv634nY3BrnZ3PlTUGlyUi8i7L3YenO2gMgxW5qJ4tF6Xha6yZp+2FFeWeU8OQrXrCFeHpomo5nr++haHZW7UI=
X-Received: by 2002:a25:a408:0:b0:800:28d4:6936 with SMTP id
 f8-20020a25a408000000b0080028d46936mr2303639ybi.431.1674667354997; Wed, 25
 Jan 2023 09:22:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230125083851.27759-1-surenb@google.com> <20230125083851.27759-5-surenb@google.com>
 <Y9D4rWEsajV/WfNx@dhcp22.suse.cz> <CAJuCfpGd2eG0RSMte9OVgsRVWPo+Sj7+t8EOo8o_iKzZoh1MXA@mail.gmail.com>
 <Y9Fh9joU3vTCwYbX@dhcp22.suse.cz>
In-Reply-To: <Y9Fh9joU3vTCwYbX@dhcp22.suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 25 Jan 2023 09:22:23 -0800
Message-ID: <CAJuCfpEJ1U2UHBNhLx4gggN3PLZKP5RejiZL_U5ZLxU_wdviVg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] mm: replace vma->vm_flags indirect modification in ksm_madvise
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, michel@lespinasse.org, jglisse@google.com, 
	vbabka@suse.cz, hannes@cmpxchg.org, mgorman@techsingularity.net, 
	dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, 
	peterz@infradead.org, ldufour@linux.ibm.com, paulmck@kernel.org, 
	luto@kernel.org, songliubraving@fb.com, peterx@redhat.com, david@redhat.com, 
	dhowells@redhat.com, hughd@google.com, bigeasy@linutronix.de, 
	kent.overstreet@linux.dev, punit.agrawal@bytedance.com, lstoakes@gmail.com, 
	peterjung1337@gmail.com, rientjes@google.com, axelrasmussen@google.com, 
	joelaf@google.com, minchan@google.com, jannh@google.com, shakeelb@google.com, 
	tatashin@google.com, edumazet@google.com, gthelen@google.com, 
	gurua@google.com, arjunroy@google.com, soheil@google.com, 
	hughlynch@google.com, leewalsh@google.com, posk@google.com, will@kernel.org, 
	aneesh.kumar@linux.ibm.com, npiggin@gmail.com, chenhuacai@kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, richard@nod.at, anton.ivanov@cambridgegreys.com, 
	johannes@sipsolutions.net, qianweili@huawei.com, wangzhou1@hisilicon.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	airlied@gmail.com, daniel@ffwll.ch, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, l.stach@pengutronix.de, 
	krzysztof.kozlowski@linaro.org, patrik.r.jakobsson@gmail.com, 
	matthias.bgg@gmail.com, robdclark@gmail.com, quic_abhinavk@quicinc.com, 
	dmitry.baryshkov@linaro.org, tomba@kernel.org, hjc@rock-chips.com, 
	heiko@sntech.de, ray.huang@amd.com, kraxel@redhat.com, sre@kernel.org, 
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com, tfiga@chromium.org, 
	m.szyprowski@samsung.com, mchehab@kernel.org, dimitri.sivanich@hpe.com, 
	zhangfei.gao@linaro.org, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	dgilbert@interlog.com, hdegoede@redhat.com, mst@redhat.com, 
	jasowang@redhat.com, alex.williamson@redhat.com, deller@gmx.de, 
	jayalk@intworks.biz, viro@zeniv.linux.org.uk, nico@fluxnic.net, 
	xiang@kernel.org, chao@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	miklos@szeredi.hu, mike.kravetz@oracle.com, muchun.song@linux.dev, 
	bhe@redhat.com, andrii@kernel.org, yoshfuji@linux-ipv6.org, 
	dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com, perex@perex.cz, 
	tiwai@suse.com, haojian.zhuang@gmail.com, robert.jarzmik@free.fr, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	linux-graphics-maintainer@vmware.com, linux-ia64@vger.kernel.org, 
	linux-arch@vger.kernel.org, loongarch@lists.linux.dev, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-acpi@vger.kernel.org, 
	linux-crypto@vger.kernel.org, nvdimm@lists.linux.dev, 
	dmaengine@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org, 
	linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-rockchip@lists.infradead.org, 
	linux-tegra@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	xen-devel@lists.xenproject.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-accelerators@lists.ozlabs.org, sparclinux@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev, 
	target-devel@vger.kernel.org, linux-usb@vger.kernel.org, 
	netdev@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-aio@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, devel@lists.orangefs.org, 
	kexec@lists.infradead.org, linux-xfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com, 
	selinux@vger.kernel.org, alsa-devel@alsa-project.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 25, 2023 at 9:08 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 25-01-23 08:57:48, Suren Baghdasaryan wrote:
> > On Wed, Jan 25, 2023 at 1:38 AM 'Michal Hocko' via kernel-team
> > <kernel-team@android.com> wrote:
> > >
> > > On Wed 25-01-23 00:38:49, Suren Baghdasaryan wrote:
> > > > Replace indirect modifications to vma->vm_flags with calls to modifier
> > > > functions to be able to track flag changes and to keep vma locking
> > > > correctness. Add a BUG_ON check in ksm_madvise() to catch indirect
> > > > vm_flags modification attempts.
> > >
> > > Those BUG_ONs scream to much IMHO. KSM is an MM internal code so I
> > > gueess we should be willing to trust it.
> >
> > Yes, but I really want to prevent an indirect misuse since it was not
> > easy to find these. If you feel strongly about it I will remove them
> > or if you have a better suggestion I'm all for it.
>
> You can avoid that by making flags inaccesible directly, right?

Ah, you mean Peter's suggestion of using __private? I guess that would
cover it. I'll drop these BUG_ONs in the next version. Thanks!

>
> --
> Michal Hocko
> SUSE Labs

