Return-Path: <nvdimm+bounces-4701-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4305B3871
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 Sep 2022 15:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A31B7280CE5
	for <lists+linux-nvdimm@lfdr.de>; Fri,  9 Sep 2022 13:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA0C2590;
	Fri,  9 Sep 2022 13:01:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51D581B
	for <nvdimm@lists.linux.dev>; Fri,  9 Sep 2022 13:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662728493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7roVqgiLTtD9K+hJlFUdG9Wb1smDN31yGHEloDLRN0o=;
	b=TswIDIgLz+yNZk7RdTzkXhGOchJqmSPMZCcnBS/npq80Rvd9uGLIt2kObNbBvV6zW7H+WC
	Ib2YExifaxGgnIpeTDHg5ma3FBvV3jjreLSMclsDmgAzq3SXqizeXUZQYAXnDN0VruV2rH
	rSwoqSjwyU1JG9zOxL7/OZ8brpsswcY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383--boKi_ECNTCjx63avAIiPA-1; Fri, 09 Sep 2022 09:01:31 -0400
X-MC-Unique: -boKi_ECNTCjx63avAIiPA-1
Received: by mail-qk1-f200.google.com with SMTP id g6-20020a05620a40c600b006bbdeb0b1f2so1356267qko.22
        for <nvdimm@lists.linux.dev>; Fri, 09 Sep 2022 06:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=7roVqgiLTtD9K+hJlFUdG9Wb1smDN31yGHEloDLRN0o=;
        b=gKZhiTYSVE19vCQ86sfgXts9BtAYOs5/knBCf9UFUUHii9Q9qAF6W2XmI4H7R6aDAn
         u5VAf6ZzG76wfjqTDykJ2BybWj38Th6/FZEtBtiYxEIqxYN+W4lDi5LPAxVdRgBO37wm
         pptlXhr9WinQ8iiFwzlChxzS0HFhZJW0NDU0JypfJWJVqspbrO+UmFFXom5nabZvoDXd
         3DZARk7erN4Xult++4EUJzX8HlFcnBQKmOfWZMOzbNEw0QoOp+DwxtLCfDbvFLQbliJR
         HvdE5Af14loEK3XlaYcTujTkVuYAGDCKia0IYI3an6ckdsTde1GXtdLTjXfUYtx+ZgKK
         PXoQ==
X-Gm-Message-State: ACgBeo0+KLsIoJ3oHZkTJjp6kbjB6TksYo9wX6uD+DgWkm4gzOTkbD+y
	cxE3IJ3XWf/L/PofRCg8OelJbWeO1yx/OG+U+17P8ajPgV+d/n54PZJoXyYsyT9eI0vR27D7XIL
	LP2zB8o2cnRbcKOQH
X-Received: by 2002:a0c:e103:0:b0:4aa:b54b:e396 with SMTP id w3-20020a0ce103000000b004aab54be396mr11039013qvk.42.1662728490186;
        Fri, 09 Sep 2022 06:01:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7A0i1+JhxQx9EsIr4UP9K7Sqz06e67+5wJ5s4maBLPeuImTnuNnbKxlFxyWzpKAPruI184vg==
X-Received: by 2002:a0c:e103:0:b0:4aa:b54b:e396 with SMTP id w3-20020a0ce103000000b004aab54be396mr11038913qvk.42.1662728489147;
        Fri, 09 Sep 2022 06:01:29 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id r8-20020ac87ee8000000b0034355a352d1sm306127qtc.92.2022.09.09.06.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 06:01:28 -0700 (PDT)
Date: Fri, 9 Sep 2022 09:01:25 -0400
From: Brian Foster <bfoster@redhat.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@infradead.org" <hch@infradead.org>,
	=?utf-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <Yxs5Jb7Yt2c6R6eW@bfoster>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
 <Yr5AV5HaleJXMmUm@magnolia>
 <74b0a034-8c77-5136-3fbd-4affb841edcb@fujitsu.com>
 <Ytl7yJJL1fdC006S@magnolia>
 <7fde89dc-2e8f-967b-d342-eb334e80255c@fujitsu.com>
 <YuNn9NkUFofmrXRG@magnolia>
 <0ea1cbe1-79d7-c22b-58bf-5860a961b680@fujitsu.com>
 <YusYDMXLYxzqMENY@magnolia>
 <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 08, 2022 at 09:46:04PM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2022/8/4 8:51, Darrick J. Wong 写道:
> > On Wed, Aug 03, 2022 at 06:47:24AM +0000, ruansy.fnst@fujitsu.com wrote:
> 
> ...
> 
> > > > > > > 
> > > > > > > BTW, since these patches (dax&reflink&rmap + THIS + pmem-unbind) are
> > > > > > > waiting to be merged, is it time to think about "removing the
> > > > > > > experimental tag" again?  :)
> > > > > > 
> > > > > > It's probably time to take up that question again.
> > > > > > 
> > > > > > Yesterday I tried running generic/470 (aka the MAP_SYNC test) and it
> > > > > > didn't succeed because it sets up dmlogwrites atop dmthinp atop pmem,
> > > > > > and at least one of those dm layers no longer allows fsdax pass-through,
> > > > > > so XFS silently turned mount -o dax into -o dax=never. :(
> > > > > 
> > > > > Hi Darrick,
> > > > > 
> > > > > I tried generic/470 but it didn't run:
> > > > >      [not run] Cannot use thin-pool devices on DAX capable block devices.
> > > > > 
> > > > > Did you modify the _require_dm_target() in common/rc?  I added thin-pool
> > > > > to not to check dax capability:
> > > > > 
> > > > >            case $target in
> > > > >            stripe|linear|log-writes|thin-pool)  # add thin-pool here
> > > > >                    ;;
> > > > > 
> > > > > then the case finally ran and it silently turned off dax as you said.
> > > > > 
> > > > > Are the steps for reproduction correct? If so, I will continue to
> > > > > investigate this problem.
> > > > 
> > > > Ah, yes, I did add thin-pool to that case statement.  Sorry I forgot to
> > > > mention that.  I suspect that the removal of dm support for pmem is
> > > > going to force us to completely redesign this test.  I can't really
> > > > think of how, though, since there's no good way that I know of to gain a
> > > > point-in-time snapshot of a pmem device.
> > > 
> > > Hi Darrick,
> > > 
> > >   > removal of dm support for pmem
> > > I think here we are saying about xfstest who removed the support, not
> > > kernel?
> > > 
> > > I found some xfstests commits:
> > > fc7b3903894a6213c765d64df91847f4460336a2  # common/rc: add the restriction.
> > > fc5870da485aec0f9196a0f2bed32f73f6b2c664  # generic/470: use thin-pool
> > > 
> > > So, this case was never able to run since the second commit?  (I didn't
> > > notice the not run case.  I thought it was expected to be not run.)
> > > 
> > > And according to the first commit, the restriction was added because
> > > some of dm devices don't support dax.  So my understanding is: we should
> > > redesign the case to make the it work, and firstly, we should add dax
> > > support for dm devices in kernel.
> > 
> > dm devices used to have fsdax support; I think Christoph is actively
> > removing (or already has removed) all that support.
> > 
> > > In addition, is there any other testcase has the same problem?  so that
> > > we can deal with them together.
> > 
> > The last I checked, there aren't any that require MAP_SYNC or pmem aside
> > from g/470 and the three poison notification tests that you sent a few
> > days ago.
> > 
> > --D
> > 
> 
> Hi Darrick, Brian
> 
> I made a little investigation on generic/470.
> 
> This case was able to run before introducing thin-pool[1], but since that,
> it became 'Failed'/'Not Run' because thin-pool does not support DAX.  I have
> checked the log of thin-pool, it never supports DAX.  And, it's not someone
> has removed the fsdax support.  So, I think it's not correct to bypass the
> requirement conditions by adding 'thin-pool' to _require_dm_target().
> 
> As far as I known, to prevent out-of-order replay of dm-log-write, thin-pool
> was introduced (to provide discard zeroing).  Should we solve the
> 'out-of-order replay' issue instead of avoiding it by thin-pool? @Brian
> 

Yes.. I don't recall all the internals of the tools and test, but IIRC
it relied on discard to perform zeroing between checkpoints or some such
and avoid spurious failures. The purpose of running on dm-thin was
merely to provide reliable discard zeroing behavior on the target device
and thus to allow the test to run reliably.

Brian

> Besides, since it's not a fsdax problem, I think there is nothing need to be
> fixed in fsdax.  I'd like to help it solved, but I'm still wondering if we
> could back to the original topic("Remove Experimental Tag") firstly? :)
> 
> 
> [1] fc5870da485aec0f9196a0f2bed32f73f6b2c664 generic/470: use thin volume
> for dmlogwrites target device
> 
> 
> --
> Thanks,
> Ruan.
> 
> 


