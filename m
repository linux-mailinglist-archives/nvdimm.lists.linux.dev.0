Return-Path: <nvdimm+bounces-7413-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5001A84EB78
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 23:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADEB4285D69
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 22:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E70F4F89C;
	Thu,  8 Feb 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="unli8gQl"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7C14F60E;
	Thu,  8 Feb 2024 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707430595; cv=none; b=afdK7gH7yYaExfStc4oWhVJJi5SZOJ8cR4Sqh/320lgcD5RTfjgvL08oHKHUQ1qHL/Y317fRJH//9TtOoGd/QH0xl6GSQHgn+a/NFNVJ9POIxUstiqri6fZPuRv5m7hB5p1tQq70Gs9jpR1yCq09reDGx1CIECknOpxnMhry/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707430595; c=relaxed/simple;
	bh=kqCS9Thshp0iE8PcR/yVThjuePxfrFwB07IeI7fP/OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CsPW3iUGogaFTqpzt37XYh3ozWCu6j2pdRjRV+SmTVttfvKJuueDa9PuCZTxwP3WpsmGM+HHQRaVSlMSIA0lPPSSENs4LTxiC015JMsORy6oW2svgsuuD+E9gN66CWs0NsLhM9sumyjnIF4A+pYsIfHiyq5RE0fkj/LPBUiGMmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=unli8gQl; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707430593;
	bh=kqCS9Thshp0iE8PcR/yVThjuePxfrFwB07IeI7fP/OE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=unli8gQlUjWoGhpCcGsqDZavVQBelWtdA1krO4EBFVLQLK53/4n/DlHkutP2lizzM
	 R9KSI7dt0IeHHqRJfBo/FPWAuEvHbUjqhTxc7fE1Y5TXLbM7yvHI4pcDi5q6xbqXl6
	 +N3/n+LNGGFcSIjmrzFvCNBmxlMQ93n8JzNzlbRZZ/RItzkgakmq3XpW9L/SDtFvwR
	 KSewUrPzDb6wNunUKpZkSjQ31YYkpeGFmEPFKD9V4HQqg+5auIGVNbzP3874hgu7xJ
	 OKSJSGcJupcf+82TnWOUDw/lmdlDOYuDtuNnV8AsaMK0DC9fTADI2PzFBAQ5qHDJSJ
	 cMxVXu5ce1Kmg==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TWBCj2xVYzY0Q;
	Thu,  8 Feb 2024 17:16:33 -0500 (EST)
Message-ID: <646293de-608c-497f-9beb-d5da38b3cd3a@efficios.com>
Date: Thu, 8 Feb 2024 17:16:39 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] nvdimm/pmem: Fix leak on dax_add_host() failure
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Arnd Bergmann <arnd@arndb.de>,
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Russell King <linux@armlinux.org.uk>,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-s390@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
 <20240208184913.484340-2-mathieu.desnoyers@efficios.com>
 <20240208132112.b5e82e1720e80da195ef0927@linux-foundation.org>
 <acb2ca39-412a-4115-95c5-f15e979a43bb@efficios.com>
 <20240208141209.a73f4d3221f9573468729b8f@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20240208141209.a73f4d3221f9573468729b8f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-02-08 17:12, Andrew Morton wrote:
> On Thu, 8 Feb 2024 17:04:52 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

[...]

>> Should I keep this patch 01/12 within the series for v5 or should I
>> send it separately ?
> 
> Doesn't matter much, but perfectionism does say "standalone patch please".

Will do. I plan to add the following statement to the commit message
to make it clear that there is a dependency between the patch series
and this fix:

[ Based on commit "nvdimm/pmem: Fix leak on dax_add_host() failure". ]

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


