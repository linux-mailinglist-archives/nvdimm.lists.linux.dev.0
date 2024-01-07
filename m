Return-Path: <nvdimm+bounces-7143-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52EA782636F
	for <lists+linux-nvdimm@lfdr.de>; Sun,  7 Jan 2024 09:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3881D1C20C66
	for <lists+linux-nvdimm@lfdr.de>; Sun,  7 Jan 2024 08:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4E612B87;
	Sun,  7 Jan 2024 08:48:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07A112B70;
	Sun,  7 Jan 2024 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rMOpW-0004Wt-AP; Sun, 07 Jan 2024 09:48:26 +0100
Message-ID: <9a2884bf-8ab4-4f42-8ebc-bfc92aafdfb5@leemhuis.info>
Date: Sun, 7 Jan 2024 09:48:25 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug in commit aa511ff8218b ("badblocks: switch to the improved
 badblock handling
Content-Language: en-US, de-DE
From: "Linux regression tracking #update (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
To: Linux kernel regressions list <regressions@lists.linux.dev>
Cc: linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>,
 Linux regressions mailing list <regressions@lists.linux.dev>
References: <6585d5fda5183_9f731294b9@iweiny-mobl.notmuch>
 <3035e75a-9be0-4bc3-8d4a-6e52c207f277@leemhuis.info>
In-Reply-To: <3035e75a-9be0-4bc3-8d4a-6e52c207f277@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1704617309;6eed9177;
X-HE-SMSGID: 1rMOpW-0004Wt-AP

On 23.12.23 09:35, Linux regression tracking #adding (Thorsten Leemhuis)
wrote:
> On 22.12.23 19:31, Ira Weiny wrote:
>> Coly,
>>
>> Yesterday I noticed that a few of our nvdimm tests were failing.  I bisected
>> the problem to the following commit.
>>
>> aa511ff8218b ("badblocks: switch to the improved badblock handling code") 
>>
>> Reverting this patch fixed our tests.
>
> #regzbot ^introduced aa511ff8218b

#regzbot introduced 3ea3354cb9f0
#regzbot fix: 146e843f6b0927
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

