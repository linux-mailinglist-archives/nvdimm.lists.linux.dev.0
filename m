Return-Path: <nvdimm+bounces-9589-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 860ED9F598A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Dec 2024 23:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 925587A3FA0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Dec 2024 22:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F9F1FA17A;
	Tue, 17 Dec 2024 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="emIE6wOT"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339171F943F
	for <nvdimm@lists.linux.dev>; Tue, 17 Dec 2024 22:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734474497; cv=none; b=AuoxPM6/3ywiHrU5eFGRDK+ao06S7ozumimbzua+sI7PbSwKguylSNIKTiO8yVvgZT7O8XUjNJTOAm2dnAyqQzBwvJz1YCYDlnlTwqiB75bQwqndEdSpdvwJDEfV2Hrj8ulXdrGhSp+XSAEMnB/m0Ym5F+roXvGvf7mDuTZcFCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734474497; c=relaxed/simple;
	bh=jrbdn2YwOSpYB6F7z51EZinxAGpXPm4mKSFgixxQ4a4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YkHYTdXE6q2kUheNa2kpJhJvvLZ+1QCSI22YP+wJy9v+rzy2OPQBOerZoZcGEa3/TsawjxayBEy4W4c/r1ap6CFPefb0SvvmLywIi+WCGnS1qktTUUDadz1sMDvzKXHpVcDMHCKGn7kyMn9PsHMcsRleLQyBOfDC9ybZC5zo1d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=emIE6wOT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734474495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SuUiDwN6JN9Q+rjTOZSr/qEq0VeE7EPwHe1HzzH1/V8=;
	b=emIE6wOTPlBPxReE+BUj0UC2/WNYQenVnFHWLt2+hbR4StiSf2kb8iF4ZRp3WcHZahfQqs
	LDhY9jc1lAbgy1QueqVby6n+0sjxkYBaN2dTL92OUcq3mm0TC7ARRRfgEGrUMsw9Et1MOQ
	j8C+1WnGbferbHtf6x73hf5lF0WONiI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-IaUmG8IONk29_JABfUhmbA-1; Tue, 17 Dec 2024 17:28:12 -0500
X-MC-Unique: IaUmG8IONk29_JABfUhmbA-1
X-Mimecast-MFC-AGG-ID: IaUmG8IONk29_JABfUhmbA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3862e986d17so2450418f8f.3
        for <nvdimm@lists.linux.dev>; Tue, 17 Dec 2024 14:28:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734474491; x=1735079291;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SuUiDwN6JN9Q+rjTOZSr/qEq0VeE7EPwHe1HzzH1/V8=;
        b=qP8zPfmhNPUER5O8uvNB6Hk6vh5l8xLvS8AVvdx9XSDJXQUc2JypWE0kTkcagLcMa7
         M3s1QO8kKzR8mgfR9bJ34+Cd6JnXW//iIiumhcnjl95VKdnmKRNZbGGqy4pSgr59abth
         TMK8qFypudGHQiRZKR6INRsK/WH4VF3RvilpyT3uiy/VjUL009ZkZITzJDzb+uefDJ7k
         CYj/Gm5O/1JPPB/PsAO8v1kk+y7AZKfoza/KlZezpT/Iq7DZ9PEYCuKVWDz7oC/+qFJW
         +S2YrMhe6Ajvn11iVrBwRkp8SaxTTwbkpqwmoAidjDxGwNOdtHLn5v3hxprwgriI0A/+
         jd0w==
X-Forwarded-Encrypted: i=1; AJvYcCW6GzSYI+MeJHOSrdSN9aNXCEpaMoQ6ncw06Yi9uWuV6ZDwYot8nv0ge9ymglP8AIaDzhIi/2M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyalJ/IrhzOpFFUmR4k7hmbYK9khP6F/FzCUPMcgApxbaXiF82q
	2b0MXlqWWdZi2zW1m2yWWgb9LfRm9NyWflFJVV/Q01SCA/tEMiGMXSAQz6ru/JA65leQoIxOVl6
	AL1Oz7WDdrB6DXXKoHq3uKquF+OiOBIddmBOAOXhTE+F56TZWVqMysw==
X-Gm-Gg: ASbGnctWYH5e36uU7hYAs9+YTL+zaZWDle8pOnoFDnVKM48IBKAawi3ir4VNRxZtJqG
	4NszJdI5W1OfUYdQBfZ9LUAkP0+HC1WTJfcvteXCENR6woWLQBy6b0g3MdvX566/ctUJ2RvYS8I
	cedyXlKdihJp7fms5bUPKGW4gq+EVOOWEvcZIurg8SNSz97CzoIiE206XRVBnXeb4hEgBt9s2X4
	ysEPLWxbV3jY9NDfE18/Tl/kRYae6Jtm1nB+rVkeLkelq/euA39RR7t3+AHfe8pLGzef+4d6unS
	pksoESSFsTFOgo8Wcpta0OmwmkTjTVBedSK0OCMH4Wn5Af22p9P1lcbQXWZwoMyVeGOCMeSdgfN
	Z59kGQkos
X-Received: by 2002:a05:6000:4a06:b0:388:c7c2:5bdb with SMTP id ffacd0b85a97d-388e4d6bc86mr490207f8f.2.1734474490923;
        Tue, 17 Dec 2024 14:28:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvTFVi7q0TnTvpbrbppzv+CwZ1GXbtoatrg/I2tIqfy/l4JTDnozGATbxCSGEYBCYXlyagPA==
X-Received: by 2002:a05:6000:4a06:b0:388:c7c2:5bdb with SMTP id ffacd0b85a97d-388e4d6bc86mr490194f8f.2.1734474490540;
        Tue, 17 Dec 2024 14:28:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c73b:5600:c716:d8e0:609d:ae92? (p200300cbc73b5600c716d8e0609dae92.dip0.t-ipconnect.de. [2003:cb:c73b:5600:c716:d8e0:609d:ae92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c801af46sm12218432f8f.61.2024.12.17.14.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 14:28:09 -0800 (PST)
Message-ID: <b5111052-4bc2-481c-8510-c1b86c70bf30@redhat.com>
Date: Tue, 17 Dec 2024 23:28:06 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/25] mm/mlock: Skip ZONE_DEVICE PMDs during mlock
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
 <e1fe10474fc06aaf24b17fcd916efffcc8c13f78.1734407924.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <e1fe10474fc06aaf24b17fcd916efffcc8c13f78.1734407924.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SGjaktcFU7yZQi57PCfHnlZ5vErhDnZBb5WBzlAvqXM_1734474491
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.12.24 06:13, Alistair Popple wrote:
> At present mlock skips ptes mapping ZONE_DEVICE pages. A future change
> to remove pmd_devmap will allow pmd_trans_huge_lock() to return
> ZONE_DEVICE folios so make sure we continue to skip those.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   mm/mlock.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index cde076f..3cb72b5 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -368,6 +368,8 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>   		if (is_huge_zero_pmd(*pmd))
>   			goto out;
>   		folio = pmd_folio(*pmd);
> +		if (folio_is_zone_device(folio))
> +			goto out;
>   		if (vma->vm_flags & VM_LOCKED)
>   			mlock_folio(folio);
>   		else

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


