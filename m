Return-Path: <nvdimm+bounces-2041-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B10845B237
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Nov 2021 03:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D9A6F1C0F33
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Nov 2021 02:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC65D2C94;
	Wed, 24 Nov 2021 02:49:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAF12C82
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 02:49:17 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id x131so1174915pfc.12
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 18:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9SdtjSRKyAYQmT41K4AZZGwYb4w19IPMcYn2fMN2dE=;
        b=ic6A7wlPP4NKkUtI3F1gI85ivlPVa2/lSDRF8Q7wubnSu6f7h04uQc/NmShkxWWq1R
         5YVX5PyQS6icvNDeSu+Q5SAFIyD1yWrEohSPRHGAM0U80r/1UVrc1M5tkOzbuMom4O54
         1FLUzZRSXGaQAUxBGkDtbRBlcgI/X1q34NCzbxL0/h1k+OT0m2DEdJxNf5uYBo+yQUWi
         tmtbKwN0VhChOm0hu6sUiBfGI5twjAA/MYoygg7APmhPoWaH/03oMqUw/a4XtP1nLkRy
         COKRo5xekU2xjc7aQKQeECLQQpxXtktld4XRoPYuhnzVfHtuR3OjCxP0rbhzS8FBgJxr
         bd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9SdtjSRKyAYQmT41K4AZZGwYb4w19IPMcYn2fMN2dE=;
        b=uYbFsm26yFFi4HlERLAYJ9ykEjQUPK2DTF8/QvltJaLHYHefV3gx860v0tpS+UpQQh
         +t4iXCdiNf+HRuNl8p9zZxaUuF4SDfO0yLN3Dl8Ipr5KmCkvSlIQ4p0OC4NVSo6okYyW
         +Eziycs9C7IxGKi7FiyeAlszjbjZRbRbaCPGiZ8z6CoFkbtVfPH1hovFeONnPNp/WRSj
         ZRn34iwfH1p72ebvQrN+so7+SuCuWI+TCFJMFPeGaru9i/uxdxvxFgzgmhCHSSdj1Ge5
         3VTqDOi0R+vJRG59kqoR1A3dVFmffr3t8g/cANIBztlIwI9xH9DVGWjL/5ZS1vqeazYp
         eJlQ==
X-Gm-Message-State: AOAM532Wv8GM5BkeZMBRzHCI/dw9hN2N25X6MRWOpB5jGiV8QnuxwmJA
	16kDBHqv0ekdQyKckOfLVrMqujhyD5SAEwxrZ9JrHg==
X-Google-Smtp-Source: ABdhPJzS8LHGzaz1OBnNTW7y/EU5nRSgH9NtL2R6nqEjsoFplqiXZU89WIILPbZV7BRWoAlxpdKj2qQGIACFTFGS2MI=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr2420437pfu.61.1637722157095; Tue, 23
 Nov 2021 18:49:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-24-hch@lst.de>
In-Reply-To: <20211109083309.584081-24-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 18:49:06 -0800
Message-ID: <CAPcyv4gVTAddA2cGFKgt5yJVTozxfQgstj3kicZAk2mZX+E1Og@mail.gmail.com>
Subject: Re: [PATCH 23/29] xfs: use IOMAP_DAX to check for DAX mappings
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use the explicit DAX flag instead of checking the inode flag in the
> iomap code.

It's not immediately clear to me why this is a net benefit, are you
anticipating inode-less operations? With reflink and multi-inode
operations a single iomap flag seems insufficient, no?

