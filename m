Return-Path: <nvdimm+bounces-4736-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0935BA481
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 04:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CB221C20985
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 02:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41D617FE;
	Fri, 16 Sep 2022 02:04:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4021617F1
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1663293870; i=@fujitsu.com;
	bh=MKgrvRvXEJpI7FWhTNNOtD4+3DVoFHPIteq1VyQCAVA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=VPdl7ZSPuoiHKRwX7OtxBTmXw1z63RUwoWF3GZX3P/7RxU7tuhRyfiM31AJkGuNUx
	 35TN9andfFzN3L5t+mg3n3nIEcpse3N/naaR4ZZK82qSARFUVnd9E9yPZqE60UF8IU
	 fFBN+lWlFpeHYU6FgAFA/1K3iF67ht9nB54AQ7dclaI5gtoULiROiimE92Ij4ch0ze
	 uc5bQ1ZDaVxm+jCJ8x2O8IQ9/qHS5nMsd0Lex9guj+FSCG3nGtA0zLEgWoAgOeUvLI
	 L9Lx1o0eT3D+KlvhJMkp/4BmmO/mVmmji+/PQdkwU7PBOypbsZi8KumrBfLZABhRtU
	 rXDOYli3pmXCg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRWlGSWpSXmKPExsViZ8ORqLv2pnK
  ywc15shbvPldZbDl2j9Hi8hM+i9MTFjFZ7Nl7ksXi8q45bBa7/uxgt1j54w+rA4fHqUUSHptX
  aHlsWtXJ5vFi80xGj/f7rrJ5fN4kF8AWxZqZl5RfkcCacfzDfqaCiboVZ+8/Z2tg/KnaxcjFI
  SSwhVHiYtcidghnOZPEz+2NUM42RolzN3exdDFycvAK2ElMv38byObgYBFQlVh1LBoiLChxcu
  YTsBJRgSSJqxvusoLYwgK+Ems39TGD2GwCjhLzZm1kA7FFBMokfv5+zAQyn1lgErPE6jnLWSC
  WvWGWeNizkB2kilPAXmL6qq1gk5gFLCQWvznIDmHLSzRvnQ02VUJAUaJtyT92CLtConH6ISYI
  W03i6rlNzBMYhWYhOXAWklGzkIxawMi8itEqqSgzPaMkNzEzR9fQwEDX0NBU19hY19xEL7FKN
  1EvtVS3PLW4RNdIL7G8WC+1uFivuDI3OSdFLy+1ZBMjMM5SihW9djC+WvFT7xCjJAeTkijvY3
  PlZCG+pPyUyozE4oz4otKc1OJDjDIcHEoSvB1XgXKCRanpqRVpmTnAmIdJS3DwKInwmh4BSvM
  WFyTmFmemQ6ROMRpznN+5fy8zx7zZ//YzC7Hk5eelSonzKt8AKhUAKc0ozYMbBEtFlxhlpYR5
  GRkYGIR4ClKLcjNLUOVfMYpzMCoJ8866DjSFJzOvBG7fK6BTmIBO4TUAO6UkESEl1cBk8qPzW
  fbdhsPtnz6tbebvLizt6p6XOlNA8VSwSnEcexP3e+XMmTmnLtzN+1sjvV9nm4MhG2v7lIeNfn
  ls+bk/SypmsR0JOhacxZL6xD/oxIP7WrycUdYFsU2d84+0BsxaOfFC+AFdTd02s9y7ngECv6y
  XsLnfqO5OaeJesDP7OwN/YuSekqmT1jE51WuZ/2he/8vynZDkRba1qx7sP/1uwdM9b66XnhKc
  9d3h9KeU7/u82C89ePGp+f+tKWvVZ5y54pV1ulvY4dK1XYXzJx0+02XrJvNvluP0AunIBWkv7
  0Y3N15dt6nHR3jR19nr/kWc6JuvfZ2Xp/ICs+Jn38ILgW7Odf92Hkx7ZvqL6baOEktxRqKhFn
  NRcSIANZ4tr8ADAAA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-23.tower-565.messagelabs.com!1663293869!518947!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 14286 invoked from network); 16 Sep 2022 02:04:29 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-23.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 16 Sep 2022 02:04:29 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 236D2100191;
	Fri, 16 Sep 2022 03:04:29 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 172E5100043;
	Fri, 16 Sep 2022 03:04:29 +0100 (BST)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Fri, 16 Sep 2022 03:04:24 +0100
Message-ID: <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
Date: Fri, 16 Sep 2022 10:04:17 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
From: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
	"hch@infradead.org" <hch@infradead.org>
CC: =?UTF-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, "hch@infradead.org"
	<hch@infradead.org>
References: <Ytl7yJJL1fdC006S@magnolia>
 <7fde89dc-2e8f-967b-d342-eb334e80255c@fujitsu.com>
 <YuNn9NkUFofmrXRG@magnolia>
 <0ea1cbe1-79d7-c22b-58bf-5860a961b680@fujitsu.com>
 <YusYDMXLYxzqMENY@magnolia>
 <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com> <Yxs5Jb7Yt2c6R6eW@bfoster>
 <7fdc9e88-f255-6edb-7964-a5a82e9b1292@fujitsu.com>
 <76ea04b4-bad7-8cb3-d2c6-4ad49def4e05@fujitsu.com> <YyHKUhOgHdTKPQXL@bfoster>
 <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
In-Reply-To: <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

On 2022/9/15 18:14, Yang, Xiao/杨 晓 wrote:
> On 2022/9/15 0:28, Darrick J. Wong wrote:
>> On Wed, Sep 14, 2022 at 08:34:26AM -0400, Brian Foster wrote:
>>> On Wed, Sep 14, 2022 at 05:38:02PM +0800, Yang, Xiao/杨 晓 wrote:
>>>> On 2022/9/14 14:44, Yang, Xiao/杨 晓 wrote:
>>>>> On 2022/9/9 21:01, Brian Foster wrote:
>>>>>> Yes.. I don't recall all the internals of the tools and test, but 
>>>>>> IIRC
>>>>>> it relied on discard to perform zeroing between checkpoints or 
>>>>>> some such
>>>>>> and avoid spurious failures. The purpose of running on dm-thin was
>>>>>> merely to provide reliable discard zeroing behavior on the target 
>>>>>> device
>>>>>> and thus to allow the test to run reliably.
>>>>> Hi Brian,
>>>>>
>>>>> As far as I know, generic/470 was original designed to verify
>>>>> mmap(MAP_SYNC) on the dm-log-writes device enabling DAX. Due to the
>>>>> reason, we need to ensure that all underlying devices under
>>>>> dm-log-writes device support DAX. However dm-thin device never 
>>>>> supports
>>>>> DAX so
>>>>> running generic/470 with dm-thin device always returns "not run".
>>>>>
>>>>> Please see the difference between old and new logic:
>>>>>
>>>>>             old logic                          new logic
>>>>> ---------------------------------------------------------------
>>>>> log-writes device(DAX)                 log-writes device(DAX)
>>>>>               |                                       |
>>>>> PMEM0(DAX) + PMEM1(DAX)       Thin device(non-DAX) + PMEM1(DAX)
>>>>>                                             |
>>>>>                                           PMEM0(DAX)
>>>>> ---------------------------------------------------------------
>>>>>
>>>>> We think dm-thin device is not a good solution for generic/470, is 
>>>>> there
>>>>> any other solution to support both discard zero and DAX?
>>>>
>>>> Hi Brian,
>>>>
>>>> I have sent a patch[1] to revert your fix because I think it's not 
>>>> good for
>>>> generic/470 to use thin volume as my revert patch[1] describes:
>>>> [1] 
>>>> https://lore.kernel.org/fstests/20220914090625.32207-1-yangx.jy@fujitsu.com/T/#u 
>>>>
>>>>
>>>
>>> I think the history here is that generic/482 was changed over first in
>>> commit 65cc9a235919 ("generic/482: use thin volume as data device"), and
>>> then sometime later we realized generic/455,457,470 had the same general
>>> flaw and were switched over. The dm/dax compatibility thing was probably
>>> just an oversight, but I am a little curious about that because it 
>>> should
>>
>> It's not an oversight -- it used to work (albeit with EXPERIMENTAL
>> tags), and now we've broken it on fsdax as the pmem/blockdev divorce
>> progresses.
> Hi
> 
> Do you mean that the following patch set changed the test result of 
> generic/470 with thin-volume? (pass => not run/failure)
> https://lore.kernel.org/linux-xfs/20211129102203.2243509-1-hch@lst.de/
> 
>>
>>> have been obvious that the change caused the test to no longer run. Did
>>> something change after that to trigger that change in behavior?
>>>
>>>> With the revert, generic/470 can always run successfully on my 
>>>> environment
>>>> so I wonder how to reproduce the out-of-order replay issue on XFS v5
>>>> filesystem?
>>>>
>>>
>>> I don't quite recall the characteristics of the failures beyond that we
>>> were seeing spurious test failures with generic/482 that were due to
>>> essentially putting the fs/log back in time in a way that wasn't quite
>>> accurate due to the clearing by the logwrites tool not taking place. If
>>> you wanted to reproduce in order to revisit that, perhaps start with
>>> generic/482 and let it run in a loop for a while and see if it
>>> eventually triggers a failure/corruption..?
>>>
>>>> PS: I want to reproduce the issue and try to find a better solution 
>>>> to fix
>>>> it.
>>>>
>>>
>>> It's been a while since I looked at any of this tooling to semi-grok how
>>> it works.
>>
>> I /think/ this was the crux of the problem, back in 2019?
>> https://lore.kernel.org/fstests/20190227061529.GF16436@dastard/
> 
> Agreed.
> 
>>
>>> Perhaps it could learn to rely on something more explicit like
>>> zero range (instead of discard?) or fall back to manual zeroing?
>>
>> AFAICT src/log-writes/ actually /can/ do zeroing, but (a) it probably
>> ought to be adapted to call BLKZEROOUT and (b) in the worst case it
>> writes zeroes to the entire device, which is/can be slow.
>>
>> For a (crass) example, one of my cloudy test VMs uses 34GB partitions,
>> and for cost optimization purposes we're only "paying" for the cheapest
>> tier.  Weirdly that maps to an upper limit of 6500 write iops and
>> 48MB/s(!) but that would take about 20 minutes to zero the entire
>> device if the dm-thin hack wasn't in place.  Frustratingly, it doesn't
>> support discard or write-zeroes.
> 
> Do you mean that discard zero(BLKDISCARD) is faster than both fill 
> zero(BLKZEROOUT) and write zero on user space?

Hi Darrick, Brian and Christoph

According to the discussion about generic/470. I wonder if it is 
necessary to make thin-pool support DAX. Is there any use case for the 
requirement?

Best Regards,
Xiao Yang
> 
> Best Regards,
> Xiao Yang
>>
>>> If the
>>> eventual solution is simple and low enough overhead, it might make some
>>> sense to replace the dmthin hack across the set of tests mentioned
>>> above.
>>
>> That said, for a *pmem* test you'd expect it to be faster than that...
>>
>> --D
>>
>>> Brian
>>>
>>>> Best Regards,
>>>> Xiao Yang
>>>>
>>>>>
>>>>> BTW, only log-writes, stripe and linear support DAX for now.
>>>>
>>>

