Return-Path: <nvdimm+bounces-7483-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACEB858228
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Feb 2024 17:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0AAD284325
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Feb 2024 16:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033F312FF75;
	Fri, 16 Feb 2024 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="J33MIMhw"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F20612FB15;
	Fri, 16 Feb 2024 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708099943; cv=none; b=OZgUvP3SD6yxteynT/xmdDPDloImBu2ne5/8PMQTdA5EXyt+LJ8X+LiLu3bAf5yPX0pmdaE+3ieGEe1P6Za2SCWwXAYfjjI6RG42lCKEFVzdr3swSP79e06fg3Lw816/PyssL4TGuNlTobULGm74v1KefUd2MIsMBK+z/qTlXlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708099943; c=relaxed/simple;
	bh=j5ltBz0S3ICkzCrc/XcApSY34K9YqHdS5mIysJ7Jd74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rlw2Ikd41+XozJeY6gzvo2FfdMBqjIr/IThW6mu5Mrn8bZe1eeiBivk6Rv2elRPOXC2u+d4PN9km92oRyUXELf1GkfUWZsdBl73a3hb3ighQu6WzNaass0jCxvEV/Gd6dz8dcVAxSY7BjqM/kOGxNG9yPejhf31FS1plJ74IRR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=J33MIMhw; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1708099932;
	bh=j5ltBz0S3ICkzCrc/XcApSY34K9YqHdS5mIysJ7Jd74=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J33MIMhwZk5o7KEheMPmr1d83pdskjJ17R8laWareJbgXesmkpn6RDFWFkNHcr5Wp
	 mVpzGv2eFlPhGyKG76pJU7J4ctLWrAqNaDaCe9dnQm572yvxl2Tgf31z1dmiapsKhu
	 37bHMZ6hPN6Sffp+H0HvNh8icfMjLkUhwv38wV2Uqs1YIfPLJZo9S/D4NnPVUOoduG
	 H2Y1cTYPGukbVxjb7OuZSzVb9AOhBDLrPLkaxMyaOE7vrsEDvJWZYI8mTfQ+0PD1Pv
	 WRvy5/PoG7SI9yl9QyYpSAJfFX+l4RQRSyzi8rXEYkPpnZxN5l+D6O4UAG6DmQi48R
	 56MVY5X4U/yEg==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4Tbxlc1zQxzZmV;
	Fri, 16 Feb 2024 11:12:12 -0500 (EST)
Message-ID: <8a5ca852-1c83-4479-8e4d-5a274482df25@efficios.com>
Date: Fri, 16 Feb 2024 11:12:11 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm/pmem: Fix leak on dax_add_host() failure
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Russell King <linux@armlinux.org.uk>,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>,
 Arnd Bergmann <arnd@arndb.de>
References: <20240215144324.95436-1-mathieu.desnoyers@efficios.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20240215144324.95436-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-02-15 09:43, Mathieu Desnoyers wrote:
> Fix a leak on dax_add_host() error, where "goto out_cleanup_dax" is done
> before setting pmem->dax_dev, which therefore issues the two following
> calls on NULL pointers:

Hi Andrew,

I notice that you should update the patch you have in your tree
(https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch)
with this updated version which includes additional Reviewed-by tags and
removes unneeded context that appears to be taken from the previous cover
letter.

Following your request, I have extracted this patch from the series.

Thanks,

Mathieu

> 
> out_cleanup_dax:
>          kill_dax(pmem->dax_dev);
>          put_dax(pmem->dax_dev);
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arch@vger.kernel.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-xfs@vger.kernel.org
> Cc: dm-devel@lists.linux.dev
> Cc: nvdimm@lists.linux.dev
> ---
> Changes since v1:
> - Add Reviewed-by tags.
> ---
>   drivers/nvdimm/pmem.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 4e8fdcb3f1c8..9fe358090720 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -566,12 +566,11 @@ static int pmem_attach_disk(struct device *dev,
>   	set_dax_nomc(dax_dev);
>   	if (is_nvdimm_sync(nd_region))
>   		set_dax_synchronous(dax_dev);
> +	pmem->dax_dev = dax_dev;
>   	rc = dax_add_host(dax_dev, disk);
>   	if (rc)
>   		goto out_cleanup_dax;
>   	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
> -	pmem->dax_dev = dax_dev;
> -
>   	rc = device_add_disk(dev, disk, pmem_attribute_groups);
>   	if (rc)
>   		goto out_remove_host;

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


