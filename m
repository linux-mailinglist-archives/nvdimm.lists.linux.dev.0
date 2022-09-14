Return-Path: <nvdimm+bounces-4723-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E335B8CFB
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Sep 2022 18:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D3ED1C2094C
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Sep 2022 16:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B4A3FFB;
	Wed, 14 Sep 2022 16:28:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA493FC2
	for <nvdimm@lists.linux.dev>; Wed, 14 Sep 2022 16:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE64C433D7;
	Wed, 14 Sep 2022 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663172913;
	bh=gDxM+S092LlNnnNChSxCoMsXY2G5IgcT89F8QnyFbu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=urDFRWS+xAAvRnRIuH6YprPix4N88yxNN1jBRkcwXf/AYlrDNpfKuDvX7QjnnfSdI
	 3/p77+Vc5Uf8GC8KyCyOu2mRjLKwYBmoJy/Ud2nEFJPu2EHEU/oT1gh/KlaqUbW1qO
	 fPk6gNKiE5vqpgbTXKqHfFULqK4riGnlLlREVZf7jxAxYAXyqO+Hup90dVv6jfaF6Y
	 goc+24pqcUO4geb+EVUXAGZKri/ShdPT3kX0uHQig4xjTFeee7A3XdSaBF1puAeK/8
	 63D6iBRfXPg1tPbNHvmE5v3g8Jfk3DHCBWQjHgk9VU8H5gMIWFxGPt0C7MHkgSF7Qx
	 HOxi4rpZ5w+WA==
Date: Wed, 14 Sep 2022 09:28:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: =?utf-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
	=?utf-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <YyIBMJzmbZsUBHpy@magnolia>
References: <Ytl7yJJL1fdC006S@magnolia>
 <7fde89dc-2e8f-967b-d342-eb334e80255c@fujitsu.com>
 <YuNn9NkUFofmrXRG@magnolia>
 <0ea1cbe1-79d7-c22b-58bf-5860a961b680@fujitsu.com>
 <YusYDMXLYxzqMENY@magnolia>
 <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com>
 <Yxs5Jb7Yt2c6R6eW@bfoster>
 <7fdc9e88-f255-6edb-7964-a5a82e9b1292@fujitsu.com>
 <76ea04b4-bad7-8cb3-d2c6-4ad49def4e05@fujitsu.com>
 <YyHKUhOgHdTKPQXL@bfoster>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyHKUhOgHdTKPQXL@bfoster>

On Wed, Sep 14, 2022 at 08:34:26AM -0400, Brian Foster wrote:
> On Wed, Sep 14, 2022 at 05:38:02PM +0800, Yang, Xiao/杨 晓 wrote:
> > On 2022/9/14 14:44, Yang, Xiao/杨 晓 wrote:
> > > On 2022/9/9 21:01, Brian Foster wrote:
> > > > Yes.. I don't recall all the internals of the tools and test, but IIRC
> > > > it relied on discard to perform zeroing between checkpoints or some such
> > > > and avoid spurious failures. The purpose of running on dm-thin was
> > > > merely to provide reliable discard zeroing behavior on the target device
> > > > and thus to allow the test to run reliably.
> > > Hi Brian,
> > > 
> > > As far as I know, generic/470 was original designed to verify
> > > mmap(MAP_SYNC) on the dm-log-writes device enabling DAX. Due to the
> > > reason, we need to ensure that all underlying devices under
> > > dm-log-writes device support DAX. However dm-thin device never supports
> > > DAX so
> > > running generic/470 with dm-thin device always returns "not run".
> > > 
> > > Please see the difference between old and new logic:
> > > 
> > >            old logic                          new logic
> > > ---------------------------------------------------------------
> > > log-writes device(DAX)                 log-writes device(DAX)
> > >              |                                       |
> > > PMEM0(DAX) + PMEM1(DAX)       Thin device(non-DAX) + PMEM1(DAX)
> > >                                            |
> > >                                          PMEM0(DAX)
> > > ---------------------------------------------------------------
> > > 
> > > We think dm-thin device is not a good solution for generic/470, is there
> > > any other solution to support both discard zero and DAX?
> > 
> > Hi Brian,
> > 
> > I have sent a patch[1] to revert your fix because I think it's not good for
> > generic/470 to use thin volume as my revert patch[1] describes:
> > [1] https://lore.kernel.org/fstests/20220914090625.32207-1-yangx.jy@fujitsu.com/T/#u
> > 
> 
> I think the history here is that generic/482 was changed over first in
> commit 65cc9a235919 ("generic/482: use thin volume as data device"), and
> then sometime later we realized generic/455,457,470 had the same general
> flaw and were switched over. The dm/dax compatibility thing was probably
> just an oversight, but I am a little curious about that because it should

It's not an oversight -- it used to work (albeit with EXPERIMENTAL
tags), and now we've broken it on fsdax as the pmem/blockdev divorce
progresses.

> have been obvious that the change caused the test to no longer run. Did
> something change after that to trigger that change in behavior?
> 
> > With the revert, generic/470 can always run successfully on my environment
> > so I wonder how to reproduce the out-of-order replay issue on XFS v5
> > filesystem?
> > 
> 
> I don't quite recall the characteristics of the failures beyond that we
> were seeing spurious test failures with generic/482 that were due to
> essentially putting the fs/log back in time in a way that wasn't quite
> accurate due to the clearing by the logwrites tool not taking place. If
> you wanted to reproduce in order to revisit that, perhaps start with
> generic/482 and let it run in a loop for a while and see if it
> eventually triggers a failure/corruption..?
> 
> > PS: I want to reproduce the issue and try to find a better solution to fix
> > it.
> > 
> 
> It's been a while since I looked at any of this tooling to semi-grok how
> it works.

I /think/ this was the crux of the problem, back in 2019?
https://lore.kernel.org/fstests/20190227061529.GF16436@dastard/

> Perhaps it could learn to rely on something more explicit like
> zero range (instead of discard?) or fall back to manual zeroing?

AFAICT src/log-writes/ actually /can/ do zeroing, but (a) it probably
ought to be adapted to call BLKZEROOUT and (b) in the worst case it
writes zeroes to the entire device, which is/can be slow.

For a (crass) example, one of my cloudy test VMs uses 34GB partitions,
and for cost optimization purposes we're only "paying" for the cheapest
tier.  Weirdly that maps to an upper limit of 6500 write iops and
48MB/s(!) but that would take about 20 minutes to zero the entire
device if the dm-thin hack wasn't in place.  Frustratingly, it doesn't
support discard or write-zeroes.

> If the
> eventual solution is simple and low enough overhead, it might make some
> sense to replace the dmthin hack across the set of tests mentioned
> above.

That said, for a *pmem* test you'd expect it to be faster than that...

--D

> Brian
> 
> > Best Regards,
> > Xiao Yang
> > 
> > > 
> > > BTW, only log-writes, stripe and linear support DAX for now.
> > 
> 

