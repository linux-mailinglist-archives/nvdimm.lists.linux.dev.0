Return-Path: <nvdimm+bounces-3703-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDCA50E526
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Apr 2022 18:06:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 3F0B12E0A12
	for <lists+linux-nvdimm@lfdr.de>; Mon, 25 Apr 2022 16:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B2E2586;
	Mon, 25 Apr 2022 16:06:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6162562
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 16:06:05 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id h1so15191090pfv.12
        for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 09:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oLqZ9c6sJzKGVM/TrMqjVTTMcQElvmSe6MdCuYk9x8Q=;
        b=Kl/Kuw7/AEkG7eQdk9S+05HGcLyCpNWYXhVVB2IJqCWiZn0qCxth0QAUBN9WCYGH2q
         KHTEkQv5NB1gyhlYsq6fcoAXcZ0sRGVJXqSy7uVnctT4IqSt3J1KbZRLh+A3HXd+1/Xw
         L/AWrHjhnCxxeO37Au6NcgvAFiJb7bb5OscK0lO8/zR5Jmgy5u2l0TORiJXO5ixPoHMs
         zJRugmb3sdUUlbc5NmqLDWJWTqRas9qlraFQhD1G/O0KFHutPKqzNv2r2OeI/vsg/+ZD
         e3vmoXhZeqIkne7m4mg69eNcbIJNjLoNtx+dAWKp3hxEIQHDBp+9uqGTn87ys0zkwJWp
         yD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oLqZ9c6sJzKGVM/TrMqjVTTMcQElvmSe6MdCuYk9x8Q=;
        b=knamz6JZaZEBrdi4uN7rZQELypoC39BMXbaqJQU2CHNp+Z5wpjiAopS47kA3k/Rwlo
         z4eUP3TvXlqBoIuC3j8aw9Dih7eueqMHKBwFopPbTWR/l3U7YB3ZDgtKqqoecE1dkhzQ
         2mbiF6uopciZ4slKowhA6s1z97QexdU99T5eLkzj1YwMJqjt4ij8BqRge4X/AITyOTqu
         7SywDA42tcyu+sDLwCRXtpI5q8cnazHWt3cdKxf8ldSY7lDBRnXbbeMxbMZoHJKXmlRe
         BhwAmDRo2yQK6+VuHu4kHo4qVD0u/rBPWh8+zBgL9/HXWDhFwF3gQpkw1Nkh+zazTzTC
         iGIw==
X-Gm-Message-State: AOAM531/P9HJe5q1EbRU5lzjdYZtJ5gXIF/KIGXc0ubNJYsZWOctuzei
	oF/Ssb1IWx6sIS8Q6p4Gq/d2UsBL+2K5ZFOlf257Pg==
X-Google-Smtp-Source: ABdhPJwFK8ld7Fwmr2XzFlKxbva0mlpLg8j05RBrmyALHC9dgyLruIqa1nUtcD2iqd9rDwtnLmR2eEiosc52IWwKarM=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr15676482pgb.74.1650902764645; Mon, 25
 Apr 2022 09:06:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YmNBJBTxUCvDHMbw@iweiny-desk3> <CAPcyv4jtNgfjWLyu6MtBAjwUiqe2qEBW802AzZZeg2gZ_wU9AQ@mail.gmail.com>
 <CAPcyv4hhD5t-qm_c_=bRjbJZFg9Mjkzbvu_2MEJB87fKy3hh-g@mail.gmail.com> <20220425103307.GI2731@worktop.programming.kicks-ass.net>
In-Reply-To: <20220425103307.GI2731@worktop.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2022 09:05:53 -0700
Message-ID: <CAPcyv4i9ONW5w6p2P+E5rpw25_kmzpYf6SbmRM4+eP5hK4si-A@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] cxl/acpi: Add root device lockdep validation
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-cxl@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 25, 2022 at 3:33 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sat, Apr 23, 2022 at 10:27:52AM -0700, Dan Williams wrote:
>
> > ...so I'm going to drop it and just add a comment about the
> > expectations. As Peter said there's already a multitude of ways to
> > cause false positive / negative results with lockdep so this is just
> > one more area where one needs to be careful and understand the lock
> > context they might be overriding.
>
> One safe-guard might be to check the class you're overriding is indeed
> __no_validate__, and WARN if not. Then the unconditional reset is
> conistent.
>
> Then, if/when, that WARN ever triggers you can revisit all this.

Ok, that does seem to need a dummy definition of lockdep_match_class()
in the CONFIG_LOCKDEP=n case, but that seems worth it to me for the
sanity check.

