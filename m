Return-Path: <nvdimm+bounces-7919-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8E78A163E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Apr 2024 15:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B846A1F22119
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Apr 2024 13:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9356E14D449;
	Thu, 11 Apr 2024 13:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X1cTHVTL"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32CB14D428
	for <nvdimm@lists.linux.dev>; Thu, 11 Apr 2024 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712843244; cv=none; b=a3qF4GDchY4bGl4ODSkcC8Fgr6fsUkuyPjcaMlWWYFOIJX6vC9wGCAa+6T7NCLfAdRZoaDZChdLJ7Eix//ApZWgSjMMIYfCxUrZuttspPuU1KMzYEV6EewZ8QZCRSA5M4FO0n8IXoUx4im8TLISFYPiqXaQzNyWxq6lTsahH6Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712843244; c=relaxed/simple;
	bh=tR42a/PNa1+TcvF8KzBvBv45MQqrwY8wYoE/XwnNkhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y31J/BDWZILQJKRk5IF3wc67qnWGLOsCpadNvMDCb5HXI0oteFQZ/uKLDeHPHEDApqQ6l+lSEIL1zuij0bitZjKHrRODCc+EMhB8RmPSajfl5zob16OI1hTXJSkCvjs9wQ1xQna5IbSTpQqV5TEQHM4GYU9QCHzjkBkxzI4qIq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X1cTHVTL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712843241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9FUpUc2CBhEdAjjelkAsFFJf9cxoKp2w6Fokfr9S7kU=;
	b=X1cTHVTLZNP/riy0XoaoLDY5SFUPDopxYKgRR2UhYhryBDI4Lna6gao7XHaWSsRqlNpCBV
	VfLwR8vththVsM58G+zdlqu9SAq+XpFG68dOJZ7GMgDqvU+t1KUIFGMBAYoplvnL8Lcqgo
	Rv6PO+yyJ+puJfHyY3q1t5oFnwMrt9c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-8U5SBYnCMomiYoPkxf1e5Q-1; Thu, 11 Apr 2024 09:47:20 -0400
X-MC-Unique: 8U5SBYnCMomiYoPkxf1e5Q-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-416ac21981dso5157145e9.1
        for <nvdimm@lists.linux.dev>; Thu, 11 Apr 2024 06:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712843239; x=1713448039;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9FUpUc2CBhEdAjjelkAsFFJf9cxoKp2w6Fokfr9S7kU=;
        b=L13c1CKwjPh6pRWMpmFrzeH3wzHEnmm82g0QFHsx6wGdJPqhNQ0Fc8WPBZ1aAY7bIp
         r2txtkuo3Dl5i8yiBS28ap1kkNe5FHaqkESw0nMy2CrzqxTgi1MYh7zMdj/8/eoC0vXf
         eu7sIdt0mg9TEPLC+359wFQAKsNC6RXhyEg0uEyUVtFpp74fCnT1oojm7UgWNlSHTVOi
         9ul/awLDp/KyhX0DTb9gC+awOCdS5RuAcEb1DbKjPkYzrJm+esp92JqPlGqC9kDWRWJD
         zqiM/0uCvmmdyGTgSvWu7D1MqSP1MRRZuxM+/vr1aDk95osxDuqZ5ZlQ659Y2VLxl8HC
         PxNA==
X-Forwarded-Encrypted: i=1; AJvYcCXaGxwcxJWEvK5Hf0rDkyG1UY0mgJ7Q+ykH1SOVDgQ7bTPrf2TWfi7cDPQWWew4PSLJWfbYtz5R9hRht87ejkZ1ttnVSV1z
X-Gm-Message-State: AOJu0YwWXyMEIwSm8aMJhH1PEqFk1E+wzGeEoCnLb6KtbANb+n6IikUK
	VWeIKahjA+WxlBeknGFRUAKPRIIJ3E6GiI62mxq8x5J0hdsK4Lw7kadujs09KwDa/lxzG0T7j0t
	Ok/UB72vpE5iVOtePBEm7BtR+WE8NVqpjW/OxrDVRTekV1BeSbSsgpQ==
X-Received: by 2002:a05:600c:1551:b0:416:71ac:1bef with SMTP id f17-20020a05600c155100b0041671ac1befmr2329377wmg.13.1712843239120;
        Thu, 11 Apr 2024 06:47:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsUg5D0wDfuE+2Th+yVLoNTpM+9hW6exsncRgch5xzlNK868N2M64XkuZ7+meRE1F7o4ccqQ==
X-Received: by 2002:a05:600c:1551:b0:416:71ac:1bef with SMTP id f17-20020a05600c155100b0041671ac1befmr2329358wmg.13.1712843238774;
        Thu, 11 Apr 2024 06:47:18 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:4300:430f:1c83:1abc:1d66? (p200300cbc7244300430f1c831abc1d66.dip0.t-ipconnect.de. [2003:cb:c724:4300:430f:1c83:1abc:1d66])
        by smtp.gmail.com with ESMTPSA id h15-20020adff4cf000000b003432ffc3aeasm1818104wrp.56.2024.04.11.06.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 06:47:18 -0700 (PDT)
Message-ID: <f3b38a24-d252-49ea-88ea-ac12fab3c121@redhat.com>
Date: Thu, 11 Apr 2024 15:47:17 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/10] mm/gup.c: Remove redundant check for PCI P2PDMA page
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: david@fromorbit.com, dan.j.williams@intel.com, jhubbard@nvidia.com,
 rcampbell@nvidia.com, willy@infradead.org, jgg@nvidia.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, djwong@kernel.org, hch@lst.de,
 ruansy.fnst@fujitsu.com, nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jglisse@redhat.com
References: <cover.fe275e9819458a4bbb9451b888cafb88af8867d4.1712796818.git-series.apopple@nvidia.com>
 <ffd72e934eeae28639b636e1e61a9c5109808420.1712796818.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ffd72e934eeae28639b636e1e61a9c5109808420.1712796818.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.04.24 02:57, Alistair Popple wrote:
> PCI P2PDMA pages are not mapped with pXX_devmap PTEs therefore the
> check in __gup_device_huge() is redundant. Remove it
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   mm/gup.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 2f8a2d8..a9c8a09 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2683,11 +2683,6 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>   			break;
>   		}
>   
> -		if (!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
> -			undo_dev_pagemap(nr, nr_start, flags, pages);
> -			break;
> -		}
> -
>   		SetPageReferenced(page);
>   		pages[*nr] = page;
>   		if (unlikely(try_grab_page(page, flags))) {

Rebasing on mm-unstable, you'll notice some minor conflicts, but nothing 
earth shattering :)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


