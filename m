Return-Path: <nvdimm+bounces-5890-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C4106C5FF2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 07:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D64A280A96
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 06:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C916523CD;
	Thu, 23 Mar 2023 06:51:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4AE23C3
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 06:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1679554257; i=@fujitsu.com;
	bh=o/iKE4v2gcdkKCLxoUcKXF+bk48Opm95KmFQUuZafyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=O7HxeKdhgaN5P0FsWhNGg8I0zxr6NhFr6uEjfmTAK8qalIur71jUQ1Xo2JQ1TvkWd
	 O9PQU2Gdsj+p3VrUFvPg5Sc8fQ0uXvbfFYX6YliN+m7yCsk/F/uSpTQNbVbdp52A3b
	 pCLsTUTtpetTzBVVzqAfjjuwThm24Xi2jVez7eA+1K46TXv3dfQQNGh0mTTgqu0OEw
	 sAWWWJ613ZPEzhqhnhaClf87e1WMjVNt86bUC9jBYn/lNHyg6QWnvzpm0T1bi9ph3u
	 hdDiJCFZva4DvToXCOh6bjjBFV4fb90+jYNqy3LDtlT7rK3Vz9s2/wQIdNiK6OkQqj
	 2F2bhgy+QrC1A==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRWlGSWpSXmKPExsViZ8OxWff4N+k
  Ug9dvuSzmrF/DZjF96gVGi8tP+CxmT29mstiz9ySLxcoff1gtfv+Yw+bA7rF5hZbH4j0vmTw2
  repk8zgx4zeLx4vNMxk9ziw4wu7xeZNcAHsUa2ZeUn5FAmvGi3+n2Qt6WCouHOFsYFzD3MXIx
  SEksJFRouH1dBYIZzGTxIv9F6GcbYwSuydNYOti5OTgFbCT+DR1LzuIzSKgKvFj1nwWiLigxM
  mZT8BsUYFkiWPnW4HqOTiEBUIljq5xBAmLCOhKrHq+C2wbs8B0RolJTS2MIAkhgWagBRd9QGw
  2AR2JCwv+soLYnALeEnOPrWUGsZkFLCQWvznIDmHLSzRvnQ0WlxBQkrj49Q4rhF0h0Tj9EBOE
  rSZx9dwm5gmMQrOQnDcLyahZSEYtYGRexWhWnFpUllqka2iql1SUmZ5RkpuYmaOXWKWbqJdaq
  lueWlyia6SXWF6sl1pcrFdcmZuck6KXl1qyiREYXynFihN2MF7s+6t3iFGSg0lJlFciVDpFiC
  8pP6UyI7E4I76oNCe1+BCjDAeHkgQv31egnGBRanpqRVpmDjDWYdISHDxKIrztL4HSvMUFibn
  FmekQqVOMilLivGkgfQIgiYzSPLg2WHq5xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmY1wBk
  Ck9mXgnc9FdAi5mAFsfNkABZXJKIkJJqYFIsY+HIPBymG9QT2H4j7jp7gv2Ry6X2p2fejFfNm
  8u7qnDVbqU3807orPz7K/1TzCf9f1785tNT3viWaLYxrmw7w7RrWpO05uGbvb0vudNTmHW4Hj
  DPYFqc5nTR/HtHNkMSVwe3xETd5dmH4/XP2bjy3vA7Nt1q19fdPNtyHjMUOGda71NdbZsdoXa
  hyntFk/KC47tvbjt338nX4oa28D7+d/cOn/gvennulkAh46L7d9ee/DZnp9i8V78LO0KLwrx7
  1HZF2BpuXMIfKhpy8CXjzFqOFfa3JVX4N27Ru68WuyHj1NYl9bHLH96+raHxYzFr18qncu6Kr
  I3THBsl2R46C1WmZj3wCutkvbXfSImlOCPRUIu5qDgRAExQwuiqAwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-2.tower-548.messagelabs.com!1679554247!34624!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6206 invoked from network); 23 Mar 2023 06:50:47 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-2.tower-548.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 23 Mar 2023 06:50:47 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id D2FD2150;
	Thu, 23 Mar 2023 06:50:46 +0000 (GMT)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id C60007C;
	Thu, 23 Mar 2023 06:50:46 +0000 (GMT)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Thu, 23 Mar 2023 06:50:43 +0000
Message-ID: <a41f0ea1-c704-7a2e-db6d-93e8bd4fcdea@fujitsu.com>
Date: Thu, 23 Mar 2023 14:50:38 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fsdax: unshare: zero destination if srcmap is HOLE or
 UNWRITTEN
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<djwong@kernel.org>
References: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <20230322160311.89efea3493db4c4ccad40a25@linux-foundation.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20230322160311.89efea3493db4c4ccad40a25@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP



在 2023/3/23 7:03, Andrew Morton 写道:
> On Wed, 22 Mar 2023 11:11:09 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> 
>> unshare copies data from source to destination. But if the source is
>> HOLE or UNWRITTEN extents, we should zero the destination, otherwise the
>> result will be unexpectable.
> 
> Please provide much more detail on the user-visible effects of the bug.
> For example, are we leaking kernel memory contents to userspace?

This fixes fail of generic/649.


--
Thanks,
Ruan.

> 
> Thanks.
> 
> 

