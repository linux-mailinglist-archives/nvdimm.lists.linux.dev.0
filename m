Return-Path: <nvdimm+bounces-10172-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB14A85682
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Apr 2025 10:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEB2F4C7A70
	for <lists+linux-nvdimm@lfdr.de>; Fri, 11 Apr 2025 08:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D204329615D;
	Fri, 11 Apr 2025 08:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RKIthJDS"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3111A296152
	for <nvdimm@lists.linux.dev>; Fri, 11 Apr 2025 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360134; cv=none; b=FwgnH8bUViqYJdqsrJyuk5nKcsfkUjDywXlCCFf5nQnEfDckNxEvsfsv6RmMGQOiXd34tOjlbDqK0LVG4Ix9cispP0Z8zz31ulJa1SsDdMCHiG5EX5wZ8BEGhV9wtB+LomfoCgZc+KR+ZO030ghHG8KNE7r2hBdOmT778ou/TTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360134; c=relaxed/simple;
	bh=IPJ9leNQutDhEP9ib8MPyBs4WWbKIFSdy8oKo97gtOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1W1/kr37+XAxcB9kfYUFTW0fF2CpuTbGlZw2QAU6Sl4BT6ZlOyew77SUOeRVDnzOZgdjFztU6wg+6plGcV/B5STDdVuk2ZqoqItGjRwx6E8U15dbHUQ50EBv2MDA0NR3Nd5+vfx/Zw2iPPkQ+kuj41IIL6ptqAiWygoYvo32vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RKIthJDS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744360131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=piFXN2Xmgkl5Go6hnTamk9rAqCYYBNHXThULQUqJm2Y=;
	b=RKIthJDSI6AxixKJcSHQR6AOiGbj3oS/YTl/JGjjnKI6OCa2giAfMTlYdXu/L8GrMJYW4g
	K6UH5K4waWCd0O4LqN8M3dySizTVhoGX8kb5zhUdyJAczD+OkMYJIi/4hRvmAX7BUKRyAN
	CXGW2vcCku4pBxgcOszKtrNAhp0CkmE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-FNv32BsyO3CXh6xJrVB12Q-1; Fri, 11 Apr 2025 04:28:46 -0400
X-MC-Unique: FNv32BsyO3CXh6xJrVB12Q-1
X-Mimecast-MFC-AGG-ID: FNv32BsyO3CXh6xJrVB12Q_1744360126
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3913f546dfdso926201f8f.1
        for <nvdimm@lists.linux.dev>; Fri, 11 Apr 2025 01:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744360125; x=1744964925;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=piFXN2Xmgkl5Go6hnTamk9rAqCYYBNHXThULQUqJm2Y=;
        b=mhtVfZU1usWRfF3ek2iPRu93YIiL5QLFz+FtjI3T3GIvK1oVr7u57SofkofFZCMKDM
         yzg4YOpiCcLpet1r4ZUlTpTB8do6NR84sos5iheBGJv75gt+bynUhUJpL1BP8QYAJrXj
         dBfsBQqQ/qEm8fef3gQmdEGWueIQY0muIACTciN+rBw7so0e3Vw53BI0FiD2GK9RzwVI
         NJmIK9hNLdLOqLcBBRlxDH0VRh+zOROp10K+/6BUhuPhXwi4kICaDte2CrMZZf2PHXk9
         uQyPghETWRZ+tpM0ODe6o87zbRIE1smdcnFpPj/xHTSFhmOsnxeqypr9CpJASom/YdQ5
         blgw==
X-Forwarded-Encrypted: i=1; AJvYcCU8FS6cunkzpplQ3gkZu/xSV0yV3QqkiTYKkIivnnhSTdDgXPSLyrAltUOlayw7LKw4nMCG3A8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxilta70N+vdIrSOz7l+OoJo1E78PyXMwS3xvqjOyrzpiA4KjJ8
	o7ZTfLIyLTmDRVe/LW2Q0XJSdBos+sZRd+Zg+kR+vQo7iwwQknWNPZaIHII0lZyC6PL+sXIDZXJ
	QmY8x74PBOL9utsXpmC9VNu0yYkAo3xZ5Tu2lxknxIo5634B6FG3WvQ==
X-Gm-Gg: ASbGncuhG8egpCmXDNeT5yKVSB6H9PZwYdLoRbA/n1AdeAZ9frjq9VwvgU+veGTKPzp
	0So6GjtGKJuNzbs4rRRcY7w/vfFLvlOs0S9NC4PkklLakMxXq6GKv+UqrKTCDJSaBNCQx4yyHHr
	tEDI9izdE+/vTRGXf7HHRmfuhun7iWr976xE0+MRyfPrTfe7kVTZaGT3+WLsEtQ9jwv/HH2JCzr
	LId4607VGG/DM6zVb+5hTUcamp43f6b27I15QkeVkl/sEi578GEMxvSdEcMwR7JI0LV5LcHYGqx
	qHNbjaGdazaTcP0rTF5DwIq5Fftpw8xKrrAOkzE0hDL2Zi0FhE5pEuOY/J+pQ21rVTrS+W1ZFIK
	rnT7qCBBdiOOSvwWhnffebhSt69KaWQdXrRnm
X-Received: by 2002:a5d:5f52:0:b0:39c:12ce:67d with SMTP id ffacd0b85a97d-39ea51d0fd7mr1386418f8f.9.1744360125639;
        Fri, 11 Apr 2025 01:28:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqKQS5VC4HKoM191qR3Wdcx5gkeIGy866+SSbMwJcYUe3advyTAL/vnXDLNSIEGMLmRJ8WcA==
X-Received: by 2002:a5d:5f52:0:b0:39c:12ce:67d with SMTP id ffacd0b85a97d-39ea51d0fd7mr1386387f8f.9.1744360125295;
        Fri, 11 Apr 2025 01:28:45 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:6800:7ddf:5fc:2ee5:f08a? (p200300cbc72668007ddf05fc2ee5f08a.dip0.t-ipconnect.de. [2003:cb:c726:6800:7ddf:5fc:2ee5:f08a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae979620sm1315106f8f.52.2025.04.11.01.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 01:28:44 -0700 (PDT)
Message-ID: <e6962a09-5d98-4860-b21e-0c8b25293cca@redhat.com>
Date: Fri, 11 Apr 2025 10:28:43 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fs/dax: fix folio splitting issue by resetting old
 folio order + _nr_pages
To: Matthew Wilcox <willy@infradead.org>,
 Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 Alison Schofield <alison.schofield@intel.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, Christoph Hellwig <hch@infradead.org>
References: <20250410091020.119116-1-david@redhat.com>
 <67f826cbd874f_72052944e@dwillia2-xfh.jf.intel.com.notmuch>
 <Z_gotADO2ba-Qz9Z@casper.infradead.org>
 <67f82e0e234ea_720529471@dwillia2-xfh.jf.intel.com.notmuch>
 <Z_g-Chjk12ijqf9O@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z_g-Chjk12ijqf9O@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S93hs5ndEfVOKxuJsEM7_LOgwZq_MAcOXJvjMbKj4Oo_1744360126
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.25 23:54, Matthew Wilcox wrote:
> On Thu, Apr 10, 2025 at 01:46:06PM -0700, Dan Williams wrote:
>> Matthew Wilcox wrote:
>>> On Thu, Apr 10, 2025 at 01:15:07PM -0700, Dan Williams wrote:
>>>> For consistency and clarity what about this incremental change, to make
>>>> the __split_folio_to_order() path reuse folio_reset_order(), and use
>>>> typical bitfield helpers for manipulating _flags_1?
>>>
>>> I dislike this intensely.  It obfuscates rather than providing clarity.
>>
>> I'm used to pushing folks to use bitfield.h in driver land, but will not
>> push it further here.
> 
> I think it can make sense in places.  Just not here.
> 
>> What about this hunk?
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2a47682d1ab7..301ca9459122 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3404,7 +3404,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>   	if (new_order)
>>   		folio_set_order(folio, new_order);
>>   	else
>> -		ClearPageCompound(&folio->page);
>> +		folio_reset_order(folio);
>>   }
> 
> I think that's wrong.  We're splitting this folio into order-0 folios,
> but folio_reset_order() is going to modify folio->_flags_1 which is in
> the next page.

Right, clearing in this context might only make sense at the very start.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2a47682d1ab77..4cd8b394b83a5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3312,6 +3312,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
         long nr_pages = 1 << old_order;
         long i;
  
+       folio_reset_order(folio);
+
         /*
          * Skip the first new_nr_pages, since the new folio from them have all
          * the flags from the original folio.


While it looks cleaner, it's in practice not required here, because

1) We handle _nr_pages overlay by setting new_folio->memcg_data

	new_folio->memcg_data = folio->memcg_data;

2) We handle the order by setting new_folio->flags

	new_folio->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;

That should clear all flags (excluding hwpoison), including the order.


It's worth noting that in free_pages_prepare(), we handle both using

if (compound) {
	page[1].flags &= ~PAGE_FLAGS_SECOND;
#ifdef NR_PAGES_IN_LARGE_FOLIO
	folio->_nr_pages = 0;
#endif


-- 
Cheers,

David / dhildenb


