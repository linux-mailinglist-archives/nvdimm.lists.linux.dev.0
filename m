Return-Path: <nvdimm+bounces-10493-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAA1ACAB71
	for <lists+linux-nvdimm@lfdr.de>; Mon,  2 Jun 2025 11:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AD9B189A59C
	for <lists+linux-nvdimm@lfdr.de>; Mon,  2 Jun 2025 09:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC5E1E1A3D;
	Mon,  2 Jun 2025 09:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnchK/z1"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C61E0DD8
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748856798; cv=none; b=lWW10l4LrEAJyzpE6GElqkeYzDSZLECobb1Vf/jnZVSC+8TTIs5i5wjw5qjOXGvLD+Vo3JesszEn8qS1nLHYYlDC4F/Gu77EbH9IR/SpStVKBgXsu4Cpu1Fj/StpOeArF9BVclmVNKZg9IkuvyzpmodJwGYAQryX6KWDNyVxDAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748856798; c=relaxed/simple;
	bh=kr8ir0FlQZkNNUQWtY9nCCtXCkYhvIjW8kc5hvNIuKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T+NIJsU0ipmCnWX+39zNwjQx9VN391CMS7PtwpStEyXR0to8f3EjNjayqrl5ruA4S6l67sGXrlwmyGZ53iMN6ViYijWYFAnjKgkgS5PRzR0GJcn2F5Hl63j8au0bhVzfP1Fh6VpjxPT22c/vP1K6CCVVkmlTj6cRFtT2yoShddo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnchK/z1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748856795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AGFrAeg+YrLg6JnrL0SvX9pGyMf+6/YBqcb6y1L9Yas=;
	b=CnchK/z1RPw7XZD+TXQ2droU71WLx6Ufg41pzIPhIJIenZtAhfQfj2TEXNZ03Q5VzuccTK
	a130o84/3EosXvRAL9rd5MiSNZrEP5qlkfbmDJhgfShk4fch4nGQOe07joUOXmPKBgmKTq
	+hGqL410B1urx4HlEicVkg3zpDACZ1M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-HoNsH381NDq4408m_VZVPw-1; Mon, 02 Jun 2025 05:33:12 -0400
X-MC-Unique: HoNsH381NDq4408m_VZVPw-1
X-Mimecast-MFC-AGG-ID: HoNsH381NDq4408m_VZVPw_1748856791
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-441c122fa56so21259705e9.2
        for <nvdimm@lists.linux.dev>; Mon, 02 Jun 2025 02:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748856790; x=1749461590;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AGFrAeg+YrLg6JnrL0SvX9pGyMf+6/YBqcb6y1L9Yas=;
        b=fOiO1x3xurzyIANq6ss57iGiiEfw9Lr1D2A/waX0LLgpscNilHq5J0OaGldoMnx0yv
         iDtuzpchgOhdzcUg8E2FAaqU6/kmbIWH6JLD0QOtBV/uPNC7mFtnzAIOQ3vdaEA/yuNf
         oSU6XNJSzS1oeyy1lc5qgeFd11ewYenl5Q2m1whwcXNmiCO9KUGlr0Nk84Th33Q7hwom
         rICh34/WdMarT7Gp0N1pH20arREc5B/1LaWiPpu8S1g3CFkiV92PVWquzDOtE9mPeZip
         +V32Bi6ecRxTGneW8XA4Xfu8BBsZ4472svYdHFyjcq3ZlkPiZBN40M6dl1/ktgRClf3/
         V7Mw==
X-Forwarded-Encrypted: i=1; AJvYcCUvi9SU+KqnI9eUJ6AnwoJrREakGRT/H79KjNNktwEDFBOnqzZHDziInfyP268REsjdRL34jzw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAudI3E9t2t6ffo2NfwWhdSqVFi5U5Gj52WxE/jpXdkk+lwMC3
	EwFxQqCmUBLwtBronZW3KVR/TDW4vH7LRQh3WIr9a5vWrJt7r8rv1bPGcFWm3DYUNxPt/Apwbc1
	46eoSVLUiDGcuBE4SHkeK7vNy8aIwI9UmeontcjgqSNqRWllpmPw8iDkLvA==
X-Gm-Gg: ASbGncv9TVTQT/8ug1RuYNp4+ItN2/2AEk+gozTTsT2CFHkTMqs4e11fiaUGELJ3XBr
	+wsMHAIHF6S5iAMAXyd/leUFGVxD1Zpl6wS7K7UMnxiAuH+1/lTRfjldrU9ZJN+WUB9Thz38T2t
	tp69IVmo2nGO+jUiAMVaEsg+npq6MceSEcAVRx6SRsuF8weQjxuO/mVEnueyRexOkWve7fzbM/H
	RNUQaFKQBzrt6PGT6RO8GruYbtUcoHz28Xhd3ESf4v/4FbjrVekIXoOIWdu5JbApsCJUqW+8lmD
	T0SwE1Rhuyf156anekLTB3xaBErVefv+9juc0s3kNkQTDPFeX3urvMKgDdl4OmBvkX6HdTeLbW0
	AUWfPdk03p+cNS75zYRobzH52I9RYf/9kcN+MVv4=
X-Received: by 2002:a7b:c008:0:b0:451:dee4:cd08 with SMTP id 5b1f17b1804b1-451dee4d1b6mr8272015e9.23.1748856790638;
        Mon, 02 Jun 2025 02:33:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkU7ZRpR1NEtSY/JfKM4+YPIoKTdq1NhU5Keu1p6sA2PS3/gG8eXtp9j/HneCiN7kQj1M6xw==
X-Received: by 2002:a7b:c008:0:b0:451:dee4:cd08 with SMTP id 5b1f17b1804b1-451dee4d1b6mr8271525e9.23.1748856789835;
        Mon, 02 Jun 2025 02:33:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:a300:1c2c:f35e:e8e5:488e? (p200300d82f34a3001c2cf35ee8e5488e.dip0.t-ipconnect.de. [2003:d8:2f34:a300:1c2c:f35e:e8e5:488e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fc1b60sm117663315e9.34.2025.06.02.02.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 02:33:09 -0700 (PDT)
Message-ID: <9c465b24-8775-4852-9618-0873cbf2aaf7@redhat.com>
Date: Mon, 2 Jun 2025 11:33:07 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] mm: Remove redundant pXd_devmap calls
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca,
 willy@infradead.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <2ee5a64581d2c78445e5c4180d7eceed085825ca.1748500293.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <2ee5a64581d2c78445e5c4180d7eceed085825ca.1748500293.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zfmVKtTb99nWiZ8qAgvBjwFJD_KF2FWf1lM_kloH1II_1748856791
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1398,10 +1398,7 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>   	}
>   
>   	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
> -	if (pfn_t_devmap(pfn))
> -		entry = pmd_mkdevmap(entry);
> -	else
> -		entry = pmd_mkspecial(entry);
> +	entry = pmd_mkspecial(entry);
>   	if (write) {


I just stumbled over this, and I think there is something off here in 
the PMD/PUD case.

vmf_insert_folio_pmd() does a folio_get() + folio_add_file_rmap_pmd().

But then, we go ahead and turn this into a special mapping by setting it 
pmd_mkdevmap()/pmd_mkspecial().

Consequently, vm_normal_page_pmd() would ignore them, not following the 
rules documented for vm_normal_page() and behaving differently than 
vmf_insert_page_mkwrite()->insert_page().


folio_add_file_rmap_pmd() should never set these things special/devmap 
in the first place :/

What am I missing?

Note that fs/dax.c calls vmf_insert_folio_pmd() for PMDs and 
vmf_insert_page_mkwrite() for PTEs.

Consequently, PTEs will never be marked special (corner case, shared 
zeropage), but PMDs would always.

Hm?

-- 
Cheers,

David / dhildenb


