Return-Path: <nvdimm+bounces-10730-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7B2ADC6E4
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Jun 2025 11:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 487447A468B
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Jun 2025 09:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE722BEC5A;
	Tue, 17 Jun 2025 09:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HzkAvfQ5"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A71293C71
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153478; cv=none; b=Y2SLc0TNlnzWJTq361L3S1BEgEGpGKoSd78E6i0PC0qYKaaUHgTlRMbk1yA2cy69J2rZcLLq8dpUiYZSs8APGwiFV0ODs1JNpY10fSHrrxYOIHpdD8z5FMYfslxwozKFo0QfQlJdksoHoKZmC/vnGZ8oeWMGK9herw8cVxTLu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153478; c=relaxed/simple;
	bh=SEIeerzS0thI+z5d6kA6cGgH8szp0nPEZ+WNtrQjWT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dcg2ddK1ptLwfmoUgYwcYpRtnAV6Lxu4CwT+56I7C9j7d9xoH1KRQZnKC2SHB5f1Sxfz1ZyM0QDu3+z6Mn/7IXEFyxMQkk60AViBzk8pW1z/0Jc22apgsOVQ8AbBVHCrITG/PIHUHmVK+bjhtbTatU2SholEgHUF+z0t7p8cO8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HzkAvfQ5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750153475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sdEh9cEys/eVA2SD9wfMRib1+LZeWMxS5mffwDFqNgM=;
	b=HzkAvfQ5MxcdicUALf8x+HJQ6rSnG6en5uVXFbpN5p7IIQg8wsyrYNKbvGRIfahqmatl66
	bdDS32JdHJKsv+TlHV1MoFmk8t6EJwDoD1XHnrdkQ5k7lovxogAD7ftAczwnfDO7+nAEcm
	F5e1O3jlh6AtTAu8gH/HK6fOh8tf/5o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-sKIF3uzzOAysdxz7r-bK2Q-1; Tue, 17 Jun 2025 05:44:34 -0400
X-MC-Unique: sKIF3uzzOAysdxz7r-bK2Q-1
X-Mimecast-MFC-AGG-ID: sKIF3uzzOAysdxz7r-bK2Q_1750153473
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a58939191eso193186f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 02:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750153473; x=1750758273;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sdEh9cEys/eVA2SD9wfMRib1+LZeWMxS5mffwDFqNgM=;
        b=UwcbcdGdfRhtS59mreO9neLTyjMUe3wJ4RQlvdRov99Ot7FOmz8gxk0XXE3tqYnTit
         Pdd2V4JhH8yHxpuBvCtLvZ6+BZn1RGeGiIeWiZjpPlmVf04cSdgnomfTfkaR6co0DKfb
         Cgka+gBKgeSZJ9NvrRJC+wjg2bThPbFpCwF+Z/HTWG4FGePTdpV785/T4VhWISGXfyON
         v8RnHHfmvpDmYY50EvFIkXrH+oJtOy0x+w+QVlQ2BD9YFaXS1f621hodW5Feydz9nxbW
         LFwtTL85+WXCmMd3R95KJAxouECw7DDFNvyS7PU7kNJQnVeYhdxk98HAVbTAcXkjOCvW
         CI3A==
X-Forwarded-Encrypted: i=1; AJvYcCXS0kinBZRwRXHYRhXkyQ+CCrYYJQ7K5OGXUe3YS+taOEMk3v2YLm9XIFesWY25tRw1VuhMiqM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhH+iK3CDyxWm06xN3qnVnSVQgoRJOa89WtcJbQLnvdAC5jfgw
	TcJe01XJ7MD30wUJ7e/i6rKAAhLFS7KBdcG76i3ZGDwwjhAxp6UrWYE7sK4xBkXH4HbPBZS0fbk
	ntySFsWSLMqVpfIriVPkP+0Ht08GXlF64+Vb2aJOw5nKflhMhiUow+j1+FA==
X-Gm-Gg: ASbGncsJaOPMkgbyIZAqAqU8ZmmsiL4IVbbK9aRVE4f5udPyDt/gNPftBpvuJkd61Wf
	ioFbdiAcsaKA4xUwwsvz2DeqKWUwKpQ4I4mIOYNiocfv0jhvpRucpZxCYJIkIOs8JfyWruQzl3F
	o8q7FeLU2V5+3Tadul1AhnujXLHqjODmJkuadKuLQVlYeNn0pf/32NBGu/9sLWqAIQb0XsjxOTK
	HoeZhQwHXNG+8jNzK2qbky7a3P2VNJxdOTwhSOtDq/m1lSMHWceKfl5fHg17MXqpU6kVg1cS7k9
	UyOpYOD3vDa5Pt58KQNNdEyqyR7YS640iBelz8871vwFItBKqbbxxGr0SJDn3bMlWKKzpd+g78Q
	4OBjsKBRBRMnQ0y8K5QwvDvBfejT/EsTs5xGvk34qLujqJlA=
X-Received: by 2002:a05:6000:65a:b0:3a5:88e9:a54f with SMTP id ffacd0b85a97d-3a588e9a99bmr1291328f8f.1.1750153473106;
        Tue, 17 Jun 2025 02:44:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHQpVd3mwZ+TEDjCXC20DL1F3MMRYh4Y/yZHPnb93a/Bf/b7RyUJmn1/nXnnPCK9NELoBd4w==
X-Received: by 2002:a05:6000:65a:b0:3a5:88e9:a54f with SMTP id ffacd0b85a97d-3a588e9a99bmr1291288f8f.1.1750153472667;
        Tue, 17 Jun 2025 02:44:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b4b67bsm13257644f8f.83.2025.06.17.02.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:44:31 -0700 (PDT)
Message-ID: <31bdbfcf-bbfa-46b7-a427-806d42d88cec@redhat.com>
Date: Tue, 17 Jun 2025 11:44:30 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/14] mm/khugepaged: Remove redundant pmd_devmap()
 check
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
 dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net,
 m.szyprowski@samsung.com, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.8d04615eb17b9e46fc0ae7402ca54b69e04b1043.1750075065.git-series.apopple@nvidia.com>
 <d4aa84277015fe21978232ed4ac91bd7270e9ee0.1750075065.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <d4aa84277015fe21978232ed4ac91bd7270e9ee0.1750075065.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tBAftW6MMZmZ6mVAK8WhjBp3ct1VvzBm-MroRjjSmio_1750153473
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:58, Alistair Popple wrote:
> The only users of pmd_devmap were device dax and fs dax. The check for
> pmd_devmap() in check_pmd_state() is therefore redundant as callers
> explicitly check for is_zone_device_page(), so this check can be dropped.
> 

Looking again, is this true?

If we return "SCAN_SUCCEED", we assume there is a page table there that 
we can map and walk.

But I assume we can drop that check because nobody will ever set 
pmd_devmap() anymore?

So likely just the description+sibject of this patch should be adjusted.

FWIW, I think check_pmd_state() should be changed to work on pmd_leaf() 
etc, but that's something for another day.

-- 
Cheers,

David / dhildenb


