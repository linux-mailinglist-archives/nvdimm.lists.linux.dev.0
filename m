Return-Path: <nvdimm+bounces-9601-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B8C59F99A5
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Dec 2024 19:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DECAD16D206
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Dec 2024 18:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F323421D5AA;
	Fri, 20 Dec 2024 18:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eHTgwNP3"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812521CA16
	for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734719981; cv=none; b=pGR+JPFIPT6vd+KREtDCpLSCBJG5RhU//rKoFQl30KBX/yc4AGLJVxhmBOqYL7VvWM4e5Tw/CfOYgQvU6pCVdQnPlETZ8qMs8rYQnvIU9ChNQzpKYfxuR38PTHN2ix1mWHnm5EU9fjn+uN084L9cnmOeB31naR0iZ073bBUPYpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734719981; c=relaxed/simple;
	bh=fUjC6s3SFHjne64QRCugWk3YriOBNMud5zFvNO6RalE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QMYiGWjAGFC2bYCcwsOmVDJgZsNUTO5hPCeID66WtQR3OHErfLO1kC5XdsmZOtKgQBwHQoofzp37tHWx1Wod2ofhOVfZhfkcusTJIJyY7ljtQudPvxbx/kPab+UU/14Y0SoqPKVlAtxK7Rnbdka5qiOwm1exYuHoK/uigjL4DNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eHTgwNP3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734719979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=73cgdGka2vtNQUgx27zyhGeElhKrYwaIMwbNLPjOvfk=;
	b=eHTgwNP3uHxpMvXgcREvHZHSLo0nTA7X6euUavZBT3lOdQb2HLZbBt2jyNiTZMLUBCwXlz
	YP+hv3WwAtrYZOzf5GKRjN+ZZoWyqDyYVBljaXoWSz0tZzjlfu5X4inwhW9h08gWf05Srp
	GO+UFa9c3w4y67u2suJGOhNvd+Xj5Bk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-lT6AHRJvMAGXyE65vofx7g-1; Fri, 20 Dec 2024 13:39:37 -0500
X-MC-Unique: lT6AHRJvMAGXyE65vofx7g-1
X-Mimecast-MFC-AGG-ID: lT6AHRJvMAGXyE65vofx7g
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38634103b0dso1338990f8f.2
        for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 10:39:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734719976; x=1735324776;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=73cgdGka2vtNQUgx27zyhGeElhKrYwaIMwbNLPjOvfk=;
        b=f2aScomBfG5PGoAzIXdfUfcUY2imq4jwTQS63LtYZUhW0y8fFoi0F0I11xG6ApHbA5
         ERkzm3WLtxGtjppnTD4DlGROd+q7b6Sk7lE3OU/E8YNfXgJlYpFZ/cONa5TehA67XGxX
         weSLXJ1RTWRsGImrmrxJYCvZXshtVGBK8fdqlgnUlshlf54DSeJgLU6kI+8gQCYt3fhH
         B6sOsvTktbNgSIsQMgBV9JYuByXI+xjPuBn8qsz0Smj4Ejh9QQa1BtgGcprkcpA8rffx
         ciPdykedmnVaEAPNA17UXdwVZHUaL4MUIfXERfBUMyk2IptCjIxMkTHJpbrFbKBFWqrn
         dTeg==
X-Forwarded-Encrypted: i=1; AJvYcCXd1/P6nVrCZOhcQAXcQcP24RBMpT8XEBLimDoVIHW6BAB5nOzI+dPR3EMohY+G5tBeUD939a4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkMLm90maicgOIJ7t0IVNZiLrxyZ9uzzmyifDhLfz7rMtD+xJu
	m4l0Z5qu8DZD+Tqm+hQqeEXtxNgL5349HGW1K/b0/JoXuKtkUuqOUmLdFd6nKi8C8q0+6/V0U52
	XqDctgSHcQbZE40pInTFfuP82RbL6ZoZf1lNsZngSzTK9JK0/ttV1gw==
X-Gm-Gg: ASbGncvYWI2ErsR8l0pILCiuTwmZmVemGXOLRc4g3OomLCFVReA9IolgLmyTmeblM0G
	p3uYL98ROlyD0WXi0R+l5YyuWMuyEF9BsxOh8JEDiquz2/0tQZQ+Md1oTIv3igNmf56mL4cWVsK
	vVfprU2AMPZAObeOz0Ir6KQz4ZVkBUf/JKf6ECGZNeMBXi6kuWfgnaPMKte+rbzo/FQcv+o1joi
	BY/zaROQiis5JVSWmm/+KnLXn4pMaUNxvD4Yly5QGs5T2QJGuCUebNMRN95bDmdNevwD6pGpjiP
	qTVvCT9qCBAFvATWCQNwUjzhKqlUrHyp/uN/ACh4rZqE5z/3COmIf6e0jUs7yyP10hbiYzc7P/z
	Ha9ZX9w/m
X-Received: by 2002:a05:6000:4b10:b0:385:f470:c2c6 with SMTP id ffacd0b85a97d-38a221e21a9mr4117815f8f.11.1734719976614;
        Fri, 20 Dec 2024 10:39:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvhkUUAwy/jfjax8Ta0r0eePu8K6jy/RVN3Di8xKdao+b/WOuUlqcSJ2seDg5AIrCl7BOxNw==
X-Received: by 2002:a05:6000:4b10:b0:385:f470:c2c6 with SMTP id ffacd0b85a97d-38a221e21a9mr4117794f8f.11.1734719976204;
        Fri, 20 Dec 2024 10:39:36 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:9d00:edd9:835b:4bfb:2ce3? (p200300cbc7089d00edd9835b4bfb2ce3.dip0.t-ipconnect.de. [2003:cb:c708:9d00:edd9:835b:4bfb:2ce3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e140sm4735396f8f.79.2024.12.20.10.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 10:39:35 -0800 (PST)
Message-ID: <65af8809-af14-46d1-a479-d82b9973e278@redhat.com>
Date: Fri, 20 Dec 2024 19:39:32 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/25] memremap: Add is_device_dax_page() and
 is_fsdax_page() helpers
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: lina@asahilina.net, zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
 will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
 dave.hansen@linux.intel.com, ira.weiny@intel.com, willy@infradead.org,
 djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, peterx@redhat.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 david@fromorbit.com
References: <cover.18cbcff3638c6aacc051c44533ebc6c002bf2bd9.1734407924.git-series.apopple@nvidia.com>
 <58ea909bd178d97bcc73997d6499880137d5e4ed.1734407924.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <58ea909bd178d97bcc73997d6499880137d5e4ed.1734407924.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 815wdl6GX_2IHCRjoWAuDtOtGzGLyTRuPG5LTwARf9s_1734719977
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.12.24 06:13, Alistair Popple wrote:
> Add helpers to determine if a page or folio is a device dax or fs dax
> page or folio.

... why is it "device_dax" but "fsdax" ? In particular because you wrote 
"fs dax" above.

I see "fsdax" getting used in some functions. But then, people usually 
say "devdax".

I'm fine either way (could be cleaned up later), just wondering about 
that slight "inconsistency".

So whatever you think is best, feel free to add

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


