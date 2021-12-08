Return-Path: <nvdimm+bounces-2196-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E11446DDDC
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Dec 2021 22:49:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C071A1C0A22
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Dec 2021 21:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FD22CBD;
	Wed,  8 Dec 2021 21:48:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0CE2CA6
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 21:48:53 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 133so3199221pgc.12
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 13:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pr04vC42Xgru+ljjY2RIXTIfLjbNYKZ9r1zFIGxcXoY=;
        b=k/wNAZ/AuybVkjvZk0AVbEel9i/byaYc0RHKeJ2Onbw5Ljfcu6Xnyj+9LI990TvN17
         gXDf3i6QbS3XX7dPGW+YLDZbyI3mtMNb6MFuI6VkXJ2O5oQe1Uo9Lyl0tVWguuywJCFa
         mHqOkMKQ7PqxaxmziyGmPdBP2mwA1hnS8p5uWaBGotrHYNv/cjDPcj+3Mak8UWIy7h20
         QRoBVpj+nzyt0Aw0Gbh3QeSkhPXMsa+KU1FHYIgJauwm8Rp5LV1wfW7uL+xJ1Uc7JCNu
         JH5dQF7u7GU18e7C5LWtAiUmjGqBiEBBNuc1jv2kxcgrVTM4eUd3S52SC7tCDUm8G3Ny
         089w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pr04vC42Xgru+ljjY2RIXTIfLjbNYKZ9r1zFIGxcXoY=;
        b=O+qejhW7T09AacUK7bWb3K9RNTmyCtovwi9visTZxE0BUIuFGJ0TjPCdgUQRxqrE/K
         d81XnYpEBcxehAy7rvNIuiKdlGMtcSQ2a23LyoF035ai7xp6TYOq4sc692h79f1np8r4
         aQBsoruSs/STv0pfPhDUd4GOl62JRaC/tphx8TxG49ElDn3TFwFL52rRfqmmT8sHhLv4
         FouPWstimFeIgmkw2T/SkDa6VsPbmPabwBjvtajZEbikzB40KWKI4HyG+Nffoqifs/4y
         brAoWo+o994jS9OaUPJDzmFn90ii3RwWeqMYafNP2myjQcAAUDaNCt59SwAgLn15eC7W
         6zgw==
X-Gm-Message-State: AOAM533FS/lVMLvE1CW0rx39yyiQWkbbzYjX9usi/aJgRNVovHyUxspZ
	v/YisBlnQKy0Zcv9rfaJtKLZLdOpwZmLch9PxtESPA==
X-Google-Smtp-Source: ABdhPJyR8HxRMlchkpapJ77FARKKVoLd64B+ycsQJWSJBfxEQeHzFBWEMLWxEhfU9LC4+bG+JKAfBHE7ba+GqV1gsMg=
X-Received: by 2002:a63:c052:: with SMTP id z18mr28178057pgi.74.1639000132680;
 Wed, 08 Dec 2021 13:48:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-7-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 13:47:57 -0800
Message-ID: <CAPcyv4guhW3=JAyZ1o4cwRWCZzrUyzdqGqtc4ZtCFwwStoxhzA@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 06/12] ndctl: Update ndctl.spec.in for 'ndctl.conf'
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The new config system introduces and installs a sample config file
> called ndctl.conf. Update the RPM spec to include this in the %files
> section for ndctl.

Modulo new ndctl.conf.d directory name:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl.spec.in | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 0563b2d..07c36ec 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -118,6 +118,7 @@ make check
>  %{_sysconfdir}/modprobe.d/nvdimm-security.conf
>
>  %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
> +%config(noreplace) %{_sysconfdir}/ndctl/ndctl.conf
>
>  %files -n daxctl
>  %defattr(-,root,root)
> --
> 2.33.1
>

