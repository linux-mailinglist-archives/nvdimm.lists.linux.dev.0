Return-Path: <nvdimm+bounces-5257-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD58E63A8DF
	for <lists+linux-nvdimm@lfdr.de>; Mon, 28 Nov 2022 14:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED41E1C20936
	for <lists+linux-nvdimm@lfdr.de>; Mon, 28 Nov 2022 13:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F52E8BF2;
	Mon, 28 Nov 2022 13:03:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318F333F3
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 13:03:09 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 203AE401D753;
	Mon, 28 Nov 2022 07:53:52 -0500 (EST)
Message-ID: <103666d5-3dcf-074c-0057-76b865f012a6@cs.umass.edu>
Date: Mon, 28 Nov 2022 07:53:52 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: moss@cs.umass.edu
Subject: Re: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Content-Language: en-US
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
 "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
References: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
From: Eliot Moss <moss@cs.umass.edu>
In-Reply-To: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2022 7:04 AM, lizhijian@fujitsu.com wrote:
> Hi folks,
> 
> I'm going to make crash coredump support pmem region. So
> I have modified kexec-tools to add pmem region to PT_LOAD of vmcore.
> 
> But it failed at makedumpfile, log are as following:
> 
> In my environment, i found the last 512 pages in pmem region will cause the error.

I wonder if an issue I reported is related: when set up to map
2Mb (huge) pages, the last 2Mb of a large region got mapped as
4Kb pages, and then later, half of a large region was treated
that way.

I've seen no response to the report, but assume folks have
been busy with other things or perhaps giving this lower
priority since it does not exactly *fail*, just not work as
a user might think it should.

Regards - Eliot Moss

