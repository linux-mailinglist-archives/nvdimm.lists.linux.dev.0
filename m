Return-Path: <nvdimm+bounces-7290-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2079A847216
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Feb 2024 15:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B24AC1F2B798
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Feb 2024 14:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A0946B83;
	Fri,  2 Feb 2024 14:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="vygKGwH5"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D2246441;
	Fri,  2 Feb 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706884832; cv=none; b=Zlvwn+FpwNr67q5zASIOaI2fefgEFsjnwMU4ho8rd70M9me7FnKB1qdHRzns36hFNYqWgugpJpCf6mrlqlXgA8XKMFyJTHSkDrJmbBiL3beRbQOhnvcYZa1o49rMJtOAXfwHDLP1osA9qhNzs+E1Qkar7ozH12OggmB987iINrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706884832; c=relaxed/simple;
	bh=75xRr+Hh8XvCcTnldScx3u7vNNKbiPCXSVT3faG9PZY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cv1DeIGP1uEp3fGrOF/Z0wvODBDYETfBez2SgkNnT7pPTs4PBNJfvfpb3ifHetXGzrEqHVT0BkIWuNsbbphVbD324OzfHjWYR6MKBr1EKFhnCjuqAYN4GwYRQ3WBLpXSbMyaCiVR2OMfl7nnPDi59x9oQt1LC2FK3/RNx7NktIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=vygKGwH5; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1706884819;
	bh=75xRr+Hh8XvCcTnldScx3u7vNNKbiPCXSVT3faG9PZY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=vygKGwH5Oj72Vz0Ai3eQ8qhTXUCVBw5yan0ZsVxgZNCeP0yq73w6MH+HpicWZy5+u
	 BmL+qoc9jn/GD6Z+9V3g0sT5hZ4XR3tZG3tfcWPRfIiUKsDPGohjfGYtUZjUm+BIM9
	 byIhaYQlDp21cpVnX/T3UJmO3PfQL20DCBolr0waUkft+ctCw4B1JBsJOv5hT0aaHF
	 +ljaSkBLFUZu8Tl4qP7asELPgGvp3aoPRhBDBoNvOoxaTaOCu6bAzyIUHIZLbvCaiL
	 vzxr77H44QWgZDV6ev2C9Y7tEQsIBZgUxnbWnfgiR4yCILQdkzipROCj16VedDYrbT
	 +4YNXnsiyAjnw==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TRJN2717NzXBc;
	Fri,  2 Feb 2024 09:40:18 -0500 (EST)
Message-ID: <b28819f3-890f-4eac-befd-f9da1c77e34a@efficios.com>
Date: Fri, 2 Feb 2024 09:40:20 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 2/4] dax: Check for data cache aliasing at runtime
Content-Language: en-US
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>, Arnd Bergmann <arnd@arndb.de>,
 Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 linux-arch@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Russell King <linux@armlinux.org.uk>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@lists.linux.dev
References: <20240131162533.247710-1-mathieu.desnoyers@efficios.com>
 <20240131162533.247710-3-mathieu.desnoyers@efficios.com>
 <65bab567665f3_37ad2943c@dwillia2-xfh.jf.intel.com.notmuch>
 <0a38176b-c453-4be0-be83-f3e1bb897973@efficios.com>
 <65bac71a9659b_37ad29428@dwillia2-xfh.jf.intel.com.notmuch>
 <f1d14941-2d22-452a-99e6-42db806b6d7f@efficios.com>
In-Reply-To: <f1d14941-2d22-452a-99e6-42db806b6d7f@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-02-01 10:44, Mathieu Desnoyers wrote:
[...]
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 4e8fdcb3f1c8..b69c9e442cf4 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -560,17 +560,19 @@ static int pmem_attach_disk(struct device *dev,
>>       dax_dev = alloc_dax(pmem, &pmem_dax_ops);
>>       if (IS_ERR(dax_dev)) {
>>           rc = PTR_ERR(dax_dev);
>> -        goto out;
>> +        if (rc != -EOPNOTSUPP)
>> +            goto out;
> 
> If I compare the before / after this change, if previously
> pmem_attach_disk() was called in a configuration with FS_DAX=n, it would
> result in a NULL pointer dereference.

I was wrong. drivers/nvdimm/Kconfig has:

config BLK_DEV_PMEM
         select DAX

and

drivers/nvdimm/Makefile has:

obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
nd_pmem-y := pmem.o

which means that anything in pmem.c can assume that alloc_dax() is
implemented.

[...]
>> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
>> index 4b7ecd4fd431..f911e58a24dd 100644
>> --- a/drivers/s390/block/dcssblk.c
>> +++ b/drivers/s390/block/dcssblk.c
>> @@ -681,12 +681,14 @@ dcssblk_add_store(struct device *dev, struct 
>> device_attribute *attr, const char
>>       if (IS_ERR(dev_info->dax_dev)) {
>>           rc = PTR_ERR(dev_info->dax_dev);
>>           dev_info->dax_dev = NULL;
>> -        goto put_dev;
>> +        if (rc != -EOPNOTSUPP)
>> +            goto put_dev;
> 
> config DCSSBLK selects FS_DAX_LIMITED and DAX.
> 
> I'm not sure what selecting DAX is trying to achieve here, because the
> Kconfig option is "FS_DAX".
> 
> So depending on the real motivation behind this select, we may want to
> consider failure rather than success in the -EOPNOTSUPP case.
> 

I missed that alloc_dax() is implemented as not supported based on
CONFIG_DAX (not CONFIG_FS_DAX).

Therefore DCSSBLK Kconfig does the right thing and always selects DAX,
and thus an implemented version of alloc_dax().

This takes care of two of my open questions at least. :)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


