Return-Path: <nvdimm+bounces-5889-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFBC6C5FED
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 07:48:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CA99280A89
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 06:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA65E23CD;
	Thu, 23 Mar 2023 06:48:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB23423C3
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 06:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1679554117; i=@fujitsu.com;
	bh=4Ji5iOeGj1sImY9DQL0Wwp9iTAdvBigTe0fFfY/aGx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=YcgTSHTk42dMzZ9sQvULjC+NjFlFrvbf8wMy40oAsa3F35TMGRsl89dBvJTQGHFR8
	 lhx94mZ+uf3rE3QrU68VjMp7CDKkrvvIfJipJWSzHE6GLVNBY97rnfm725OAdCWZxg
	 niymDcWAW63EvTo/ngB6x9nFRej7rVlOSOJMWn8RMvOOHKaoOC9kvEOri+Cz+11i2n
	 G/ayR3uVTqP4YDbuwKmMx8JPFCZccOu/gOovEXqkcNQ5FvBqSgPeoCH2Zwc5vqll2r
	 WIYKerYfpQWEFdo73Fl8Veq0W0EGsqXc4nLonrZf6wvqybGEFfoVoBz9C3AcKoXzl0
	 /StbxXTbW4mMg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleJIrShJLcpLzFFi42Kxs+GYpOv8TTr
  FoG+CvsWc9WvYLKZPvcBoMXt6M5PFnr0nWSxW/vjDavH7xxw2BzaPzSu0PBbvecnkcWLGbxaP
  F5tnMnqcWXCE3ePzJrkAtijWzLyk/IoE1oxF3/awFjxlreja0MnewPiLpYuRi0NIYAujREPvF
  MYuRk4gZzmTxPN+WQh7G6PEhU/MIDavgJ1E04n3YDUsAqoSD9fdZIGIC0qcnPkEzBYVSJY4dr
  6VDcQWFvCTWL2qhxXEFhHQlVj1fBczyDJmgUZGiYsz25ggNjczShw/sRRsKpuAjsSFBX/BOjg
  FvCUmL1oNFmcWsJBY/OYgO4QtL9G8dTbYRRICShIXv95hhbArJBqnH2KCsNUkrp7bxDyBUWgW
  kgNnIRk1C8moBYzMqxhNi1OLylKLdE31kooy0zNKchMzc/QSq3QT9VJLdctTi0t0DfUSy4v1U
  ouL9Yorc5NzUvTyUks2MQKjKaWYxWwHY3vfX71DjJIcTEqivBKh0ilCfEn5KZUZicUZ8UWlOa
  nFhxhlODiUJHj5vgLlBItS01Mr0jJzgJENk5bg4FES4W1/CZTmLS5IzC3OTIdInWJUlBLnff0
  FKCEAksgozYNrgyWTS4yyUsK8jAwMDEI8BalFuZklqPKvGMU5GJWEeQ1AtvNk5pXATX8FtJgJ
  aHHcDAmQxSWJCCmpBqbt75LvrVbetEv7t+Yft3IOc4a+tJ2K6nvLU+/J80sdXaexY9WvGrEDE
  Sl/1C9YZ79JT78bc+raYe5bWZ9PKv8xCF1V4jRFfYPBFP3efXZvNptwcYhdyNx0MnzKsqQGh8
  22Z+ZtEFlz/vfM22IhQlPTyvX3ZP4JM9HYJPhCuPWJx9UVcycVdM94pxb1bfX6h+oVD+LrebR
  c1214prm/q+TNC+Ub++yLPNdHrbojV6ZbI1m+1StD1C6YL0XoK9faMJdLvhq/d/ps2xJm4Ppr
  5+bzel+z9vkdWWHSYucxe5LIueeObmz22wsOLPvsNOUtv8SO/6vMmy1ll4j8XuZe4nDGbZtvy
  IWjL7fMVw9QWmSnxFKckWioxVxUnAgAjlJR0aEDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-8.tower-591.messagelabs.com!1679554115!176067!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30912 invoked from network); 23 Mar 2023 06:48:35 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-8.tower-591.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 23 Mar 2023 06:48:35 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id 5711010032D;
	Thu, 23 Mar 2023 06:48:35 +0000 (GMT)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 5337E10032B;
	Thu, 23 Mar 2023 06:48:35 +0000 (GMT)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Thu, 23 Mar 2023 06:48:32 +0000
Message-ID: <0d219eb0-0f58-e667-0d86-be158ea2030f@fujitsu.com>
Date: Thu, 23 Mar 2023 14:48:25 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fsdax: dedupe should compare the min of two iters' length
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>
References: <1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <20230322161236.f90c21c8f668f551ee19d80b@linux-foundation.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20230322161236.f90c21c8f668f551ee19d80b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP



在 2023/3/23 7:12, Andrew Morton 写道:
> On Wed, 22 Mar 2023 07:25:58 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> 
>> In an dedupe corporation iter loop, the length of iomap_iter decreases
>> because it implies the remaining length after each iteration.  The
>> compare function should use the min length of the current iters, not the
>> total length.
> 
> Please describe the user-visible runtime effects of this flaw, thanks.

This patch fixes fail of generic/561, with test config:

export TEST_DEV=/dev/pmem0
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/pmem1
export SCRATCH_MNT=/mnt/scratch
export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
export MOUNT_OPTIONS="-o dax"
export XFS_MOUNT_OPTIONS="-o dax"


--
Thanks,
Ruan.

