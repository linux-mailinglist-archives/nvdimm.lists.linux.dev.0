Return-Path: <nvdimm+bounces-5526-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6CA1649937
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Dec 2022 08:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CD1C280C0F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Dec 2022 07:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504721FC6;
	Mon, 12 Dec 2022 07:06:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454D7B;
	Mon, 12 Dec 2022 07:06:18 +0000 (UTC)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1p4ctE-00035Q-2R; Mon, 12 Dec 2022 08:06:16 +0100
Message-ID: <beedcb6f-5d72-da1b-993a-36de38a144c1@leemhuis.info>
Date: Mon, 12 Dec 2022 08:06:15 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages #forregzbot
Content-Language: en-US, de-DE
From: Thorsten Leemhuis <regressions@leemhuis.info>
To: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Cc: "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
 <da90b96d-ef1e-4827-b983-15d103a3a1ef@leemhuis.info>
In-Reply-To: <da90b96d-ef1e-4827-b983-15d103a3a1ef@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1670828778;c9cbaeab;
X-HE-SMSGID: 1p4ctE-00035Q-2R

On 30.11.22 11:30, Thorsten Leemhuis wrote:
> [Note: this mail is primarily send for documentation purposes and/or for
> regzbot, my Linux kernel regression tracking bot. That's why I removed
> most or all folks from the list of recipients, but left any that looked
> like a mailing lists. These mails usually contain '#forregzbot' in the
> subject, to make them easy to spot and filter out.]
> 
> On 24.11.22 15:54, Shiyang Ruan wrote:
>> Many testcases failed in dax+reflink mode with warning message in dmesg.
>> This also effects dax+noreflink mode if we run the test after a
>> dax+reflink test.  So, the most urgent thing is solving the warning
>> messages.
> 
> Darrick in https://lore.kernel.org/all/Y4bZGvP8Ozp+4De%2F@magnolia/
> wrote "dax and reflink are totally broken on 6.1". Hence, add this to
> the tracking to be sure it's not forgotten.
> 
> #regzbot ^introduced 35fcd75af3ed
> #regzbot title xfs/dax/reflink are totally broken on 6.1
> #regzbot ignore-activity

#regzbot inconclusive complex issue; fixes with backports apparently
planed to be merged for 6.2

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

