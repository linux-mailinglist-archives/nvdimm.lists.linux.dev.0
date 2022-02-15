Return-Path: <nvdimm+bounces-3031-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 372914B7B62
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Feb 2022 00:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id A91373E03AC
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Feb 2022 23:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49BA1847;
	Tue, 15 Feb 2022 23:51:43 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5E1B8F
	for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 23:51:41 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id c3so632750pls.5
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 15:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eOQl//KosZ4qvPRlYricOYzhur4w9CDxToybs/1HwUw=;
        b=n0fGEseKpeTJVBRLcU6aOW671FkkrGG1F12nn1nnKRlJSzRZlYdwGVuHrmkdAKwDsH
         2cgJ5x2nv5213DNiH3E5nWepZkSaeaQKiuoAqOILeyvtCV8UCAoqLCu7atcHC0pXWnJR
         x2tovGc4IH5J1oixDaAKekf3001ZtzDQDBFHrtmqFm1lHS1VVhV9AE4yNHV++T1KOkrq
         iIMPbPYw42SG+YdhpVwAMKgFAfvopVFbd2r/lUHxnzCyTokFTZHp7i43RcoioymXx936
         ywuUZN1RyKYYOnf6usErLJkp+q/V3IzojWctav49gN1CbN8yk8vRuUOmjEtrZfhnAGYx
         UYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eOQl//KosZ4qvPRlYricOYzhur4w9CDxToybs/1HwUw=;
        b=PUqWCNbtm6LP7zdZKBbBBUkMD+Z0gf1SIAahOkrrpXicVGvHmbQcrxn03bDaehTNX7
         aXVBtWtEAeQ/fq/WOChCfUJ40F0rcsjydml3I5SFhFlLXjrJ+RdHVs5goOFPYg8CrOtj
         RAWhF1fhG6XrtUHwgmg10MGuwz2s/Jn8CeaInyHS0Zb92qEz9gXOCqAx4ZwCPKXQ4HU8
         awcR6CJ6s7Qzhem6PJ16Me0Jun2dMZSxgrHTnXgb3R0O8m4YJU5nf3efsL7G4a3Z+xiV
         nfOJGy3Zo5VYptzqB5NelBfkuinuf2R/1qn28EgOAcpGecHMf1V6hUaGnIwAwVi4a3Yo
         QoKA==
X-Gm-Message-State: AOAM532ayyxukfufJrMtVTle0IufqwnWS865/mSsZCgIMhjrSWvhSPCB
	IhWxN1jSxhSLoxUYApG1m2fETP66ROWBrIJhYfnZEQ==
X-Google-Smtp-Source: ABdhPJzxjD3vKy3YyT+OCGwXU78ebjUah2EKpMfMibU0VWDXa+asOUJ5+9r/BPJajQyQWY0zQRe+xjGaYgcQFwMYr/U=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr251082pll.132.1644969101356; Tue, 15
 Feb 2022 15:51:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-5-ruansy.fnst@fujitsu.com> <YfqBTDp0XEbExOyy@infradead.org>
In-Reply-To: <YfqBTDp0XEbExOyy@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 15:51:35 -0800
Message-ID: <CAPcyv4jFMf_YSSgxoHJk=-0UMZeNO+PHP1sjkvXUmKfXvGaw1A@mail.gmail.com>
Subject: Re: [PATCH v10 4/9] fsdax: fix function description
To: Christoph Hellwig <hch@infradead.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Jane Chu <jane.chu@oracle.com>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 2, 2022 at 5:04 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> Dan, can you send this to Linus for 5.17 to get it out of the queue?

Sure.

