Return-Path: <nvdimm+bounces-60-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 6679938CBDC
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 19:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 2B9963E0F54
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 May 2021 17:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29136D0D;
	Fri, 21 May 2021 17:18:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054B70
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 17:18:09 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id g24so11293287pji.4
        for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 10:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PKUzbY5iIGLiRwydllRSQJCscB+6IrSLbJrzulbqCPE=;
        b=AXwML37JZffV002kpyYotuWlkznrZ0cviUiiVdIktr0yQwKR/r3o4lp2yKKrqcrUZy
         B+8eIdNpG9/9mEBtkB+AFvE7BrR+iDd5ZUhepcYVDnJaVscmnYa1T9fzSmFoQ4u8cFeD
         mDEqekjIzI1QXzSRWLOfSrRsa3drqUQh4j2b3LYQ+9W856re9ekMlhqAYxrgF9MVf7AS
         S+Q7F4UU4BQcYnaugduRH8oyvQMP4Kevmy3r8wc4IZBPGR4SCrqLlRKPkNNDPXH40joZ
         1Hl0LuXLPcN4IwFjkqAsIosJyJx7mXaqgTHt0lBrp5T4fCbb9D4Ncjje82phklWHCvzO
         pzbA==
X-Gm-Message-State: AOAM531hYG8rMXv2/R2e+wkXmbCTGs1YVbmXaBpuC8nDktfXNM04xR/y
	1oCpSQybF345Bme5idS5S3Q=
X-Google-Smtp-Source: ABdhPJwK8NtIAa5B5/oxZS0IR7nB67qYtN97nOKjvFJRfkRjUCvWO1h3QwEBBuBpXaKTLAx6Ca3tYw==
X-Received: by 2002:a17:903:30c4:b029:f0:ad43:4ca with SMTP id s4-20020a17090330c4b02900f0ad4304camr12902892plc.70.1621617489433;
        Fri, 21 May 2021 10:18:09 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id f5sm9178273pjp.37.2021.05.21.10.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:18:08 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id 29A6B423A3; Fri, 21 May 2021 17:18:07 +0000 (UTC)
Date: Fri, 21 May 2021 17:18:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 02/26] block: move the DISK_MAX_PARTS sanity
 check into __device_add_disk
Message-ID: <20210521171807.GA25090@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-3-hch@lst.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521055116.1053587-3-hch@lst.de>

On Fri, May 21, 2021 at 07:50:52AM +0200, Christoph Hellwig wrote:
> Keep this together with the first place that actually looks at
> ->minors and prepare for not passing a minors argument to
> alloc_disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

