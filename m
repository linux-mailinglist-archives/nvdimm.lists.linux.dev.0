Return-Path: <nvdimm+bounces-9598-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7A59F9981
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Dec 2024 19:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2D20169CF7
	for <lists+linux-nvdimm@lfdr.de>; Fri, 20 Dec 2024 18:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614B021D5B0;
	Fri, 20 Dec 2024 18:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nv3nag2O"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8772521A43A
	for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734719367; cv=none; b=FRo24rlthqfHXAbALPopHFiZAC1TenIALWeC0Eb7NGx4rqqMxhiv+2/lH7SoHIjuxFACU/Yqu8rOhomilXVg+YVRrKta5wc+CWg+5o3Gr8GOqOsVK5EW25VoHgnfLBlXU3Yu+mRvHc8ChJqZ2d9wIRILyD1HSrHriQiWHJZUexs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734719367; c=relaxed/simple;
	bh=Q6SF3tekiNZltEf69RdSkr40RY1p4SR17YuXy/ZBfwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BB3fh92lRLNgo/4qLXLYCXaTMuOgnZ4lmTZ+78Em/VD0Oy4zdjDHcmmYTuF/WFb8BLMciHo0mF8BAGxf6Z5P7qaIodRJj5QvdlOWG9+YCdnqgdPmE8lIp3HmM+LU/OQFndvbblSKRqVr5dqubWdEERxuBcg59jWWuqJr/n8Ir+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nv3nag2O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734719364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ShuO3TfEMw80wDehD7G0N/FfiqkQn0QjW6tjkfqEvXA=;
	b=Nv3nag2ONqN9wr5gUrNzI4yz5bzuF/TgGFoBIG887ioWrLG7qj+yddc6C5jC5p2HXZ57dA
	K+qPXUhv35PCPl5bFJBiAissgHxCXyRfiUqOTS2hFniCeZvGp/G760yIg8emwxY4UUCssa
	JS6nMTCR3oQqFn4/ZpOfvwxXkLGKrYQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-ck6vKKLINFWRyxUD4pjv7Q-1; Fri, 20 Dec 2024 13:29:23 -0500
X-MC-Unique: ck6vKKLINFWRyxUD4pjv7Q-1
X-Mimecast-MFC-AGG-ID: ck6vKKLINFWRyxUD4pjv7Q
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385d80576abso1424130f8f.3
        for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 10:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734719362; x=1735324162;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ShuO3TfEMw80wDehD7G0N/FfiqkQn0QjW6tjkfqEvXA=;
        b=MfNn52WDWzUQhgEPBx5NufgtG1yAHz0FhWE+q+o3fYSrwZwlnbXdaTZRjVyFLi0H2P
         nTt5s7Fu8fe3BBNkmQ/Je53EsWMMXLRZZVlal9pXBTrF542OgfiB8C8KGTDbBByCMZWq
         fj2sbTPI98epZbT04WxwwnpisUR+YkI+YTgas6rfPsBHWGlOwqR2BaoIs5BG0cQEZeeq
         X+YKJmChaVrl2/LgUDFsKja2G6E7jnHAAw8+GVTOSpKfEfruMVHHhiBbtn+bDiV7bQxs
         C09jUn7rF0tZZaJRkaf8mR39O2MIp62RAPkYczpjUrPeFa3eoUO5tLe2cRny4GLQrIm7
         U5pw==
X-Forwarded-Encrypted: i=1; AJvYcCXc8x/DeVsAvv1MZDo/QSNZ1xCc0LrqSa7SIS09P2RgeLzQ4nppO1889cpmVltJOZ7/+X8sHXI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3CLriX7yV48T6MNpZScUYuy1udW9f4m+XmzgQ9s268PO57yRI
	o+Xjd0hk2ZUiCkyp7hZF+sHRHo0Mh+vWKsn8tsPdcRfWDzIz56B2/Gf6oxiZjDhNJO7JHnhW+4Q
	0PDCAvCA7eXU86aDwr0mulRHyJK2QP59flL25PYe3cdiH64dRtCoItQ==
X-Gm-Gg: ASbGncvxKkj3Hf5G4Z8tM9wHPuVGYwSKXCrV8m9UZJgTJL4XJqFdoD3dIcob8l6yDKH
	NyHYeCsK5mGb1ozrFgLSfNPQLSOXp1VlIOY96f2tNBUdUbQalbGFMXxckAYS7q+Z54c6UH3307w
	j8xUrIKOLOXXX3580iPsNANCxxiNuX/tpWC2AzzAsac9Fpe2kStC0OqtQb9WjTUWXoWXXVpzoQS
	KjZ7YW2BOwYr2Rl8XzlgbM/JLc8zW5+BgwAaqWxG84ALD8lrKcCeNAITfBU4YrqaL2GwEKLNztN
	ckr+vydS6I2VifHnNRxDkNW3vjYFKpBUcC5VwMNmBw0X3fb7cU2xl2OxQuUVUV2LUbFZfYUgXyN
	/RGXq6eIm
X-Received: by 2002:a05:6000:18a9:b0:386:3835:9fff with SMTP id ffacd0b85a97d-38a22406d43mr4852357f8f.59.1734719362343;
        Fri, 20 Dec 2024 10:29:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4GC48OmfJNltY6Ek7vleCwhpqJySNAWqKHGuZFUvMe2tCVDpmaDR4IIQ/DXZtWNsmnqadZA==
X-Received: by 2002:a05:6000:18a9:b0:386:3835:9fff with SMTP id ffacd0b85a97d-38a22406d43mr4852317f8f.59.1734719361985;
        Fri, 20 Dec 2024 10:29:21 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:9d00:edd9:835b:4bfb:2ce3? (p200300cbc7089d00edd9835b4bfb2ce3.dip0.t-ipconnect.de. [2003:cb:c708:9d00:edd9:835b:4bfb:2ce3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b441bbsm85576885e9.40.2024.12.20.10.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 10:29:20 -0800 (PST)
Message-ID: <4446a9c9-613b-4303-9a06-686fb10af363@redhat.com>
Date: Fri, 20 Dec 2024 19:29:18 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/25] mm/mm_init: Move p2pdma page refcount
 initialisation to p2pdma
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, linux-mm@kvack.org,
 lina@asahilina.net, zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
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
 <aaa23e6f315a2d9b30a422c3769100cdfa42e85a.1734407924.git-series.apopple@nvidia.com>
 <359a1cf2-c5b0-4682-ba3c-980d77c4cfdb@redhat.com>
 <bk6cmiubwvor6gevit3wgl4k66xxpfcv6swmfrtvxnjnuojqkx@yow3pmyuxozw>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <bk6cmiubwvor6gevit3wgl4k66xxpfcv6swmfrtvxnjnuojqkx@yow3pmyuxozw>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7mQ0kILG8CVWYooaqt8tVXENQQSELXPB9WQzqplX1Ns_1734719362
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>>
>>
>> But that's a bit weird: we call __init_single_page()->init_page_count() to
>> initialize it to 1, to then set it back to 0.
>>
>>
>> Maybe we can just pass to __init_single_page() the refcount we want to have
>> directly? Can be a patch on top of course.
> 
> Once the dust settles on this series we won't need the pgmap->type check at
> all because all ZONE_DEVICE pages will get an initial count of 0. I have some
> follow up clean-ups for after this series is applied (particularly with regards
> to pgmap refcounts), so if it's ok I'd rather do this as a follow-up.

Sure. For ordinary memory hotplug I'll also convert it to start with 
refcount=0 soonish, so there we're also simply pass 0 to __init_single_page.

-- 
Cheers,

David / dhildenb


