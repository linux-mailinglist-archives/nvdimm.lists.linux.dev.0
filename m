Return-Path: <nvdimm+bounces-11519-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 903D8B49262
	for <lists+linux-nvdimm@lfdr.de>; Mon,  8 Sep 2025 17:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16E75203A29
	for <lists+linux-nvdimm@lfdr.de>; Mon,  8 Sep 2025 15:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB6D30CD88;
	Mon,  8 Sep 2025 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TT9jDVnx"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5270730C61A
	for <nvdimm@lists.linux.dev>; Mon,  8 Sep 2025 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343843; cv=none; b=haigswI9rxH2BVaa8sjgKJd6GwB7d3/OfGGH6KBR3a0MT2nwhA4Ri/+Bd81C8i2VHzMLdvDlz2ffvzdCKeDq2w4IEjYCGExPw95mZHnE0NZJ5hNQDdgf0Imz8rLqu1oQRxqUKhYbGc/oGpqqGyITys27f+VZ3Fm2bFOGrjuME1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343843; c=relaxed/simple;
	bh=WedO6y+Lqel0NKnDPLLhxSuPraSM1tEc/pIWpfWwI1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5/L8huXYl0r4qXRkKv77djibId+ZD21hLUQHaU7BafoFBrWJrbPKOo59APX8W1J9enLh8corz+XYkD/dbCFc+XTJVp/1Z2WLOpA10oWYMbySB23jsceC1m7XniScT5acdcvaKXIcFRQJf10FOiO0X6qPIRpUATInAdpqaAdGCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TT9jDVnx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757343840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QDJIN7zG3W3mljseXZ/jACk2q/AyQF9T/9Te0n2aogQ=;
	b=TT9jDVnxByCPBYuSupFCNDXABmwC3BtGV5bK9hgS/UlZvcn/fdtN1tzQP8C1Xdscb8ZxKj
	85tRqaUZPeEaepV00OIFVxwrzcv1VHkiAN0fan9KrnyMkGomG4h9IRAHTd6YW9qgzTSQ9P
	/opOMDE5UyJTmmbUAh+kztf3g36Wg3k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-UzjpElOAOFqrgbvK2dIJbA-1; Mon, 08 Sep 2025 11:03:59 -0400
X-MC-Unique: UzjpElOAOFqrgbvK2dIJbA-1
X-Mimecast-MFC-AGG-ID: UzjpElOAOFqrgbvK2dIJbA_1757343838
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso28276285e9.2
        for <nvdimm@lists.linux.dev>; Mon, 08 Sep 2025 08:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343838; x=1757948638;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDJIN7zG3W3mljseXZ/jACk2q/AyQF9T/9Te0n2aogQ=;
        b=WERfpHfulEPUUy/FJ/CSAgA8DEuQ9jV1qnDN8+5fcKKIL6LDMMpvTrt1HXkfgYefZ/
         qyZtaiPZpD7wKh+7Oa88acoz0TyiTsCWvRKe+AEvxzfuqps+582eh/sS8i1zdrHdYw47
         hYVUGGk1yLVTXhnMO2BlHaUTDvp7Tb6ftiOrs59NBQ+iDjKEWFhofdAMMgHhdCDsQx5A
         TSXf3kr4ZzU4beIkmJbHTq8wOzB5mi1I1WBQvc02Xy6ktbWLrtU3DzYD1Os40XOEHT5o
         zFlq35Pso/27rxE6lkbG5SbV/td3OooaASJOgthmXKkmY6weaXw/tfVPO00TbI8cGxw5
         H0CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKyoUzE20pdAkGGy/CEbCWPtAYFAwZbPRXK/frsSvruvTKJfFMfWq9MRH7HfHFkgy2/etLHZY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1Y0jzQL5NgF4G/fXY511hU3IWCdjISUqfvL1nllcgsHDzw/dB
	SmlCGzAD41/wCjBaOw9Xlji8g9JZi+6urvU+oMpYtLzHATib/mF8Qp2IROfI3FbAk9fi0ODAoPC
	J/HORqqWrEM4YNMA+/5UXaQjdIYPosA6MDeKM8dEXHfHvmAOZU+yfApxLsw==
X-Gm-Gg: ASbGncvDMaD1nZd4WomuC5KSUaRLS/hzYEcC97iU52lnVjT5PvD8YMMvmelJZcgNio1
	11AGjDpW8qyAeZ2owCkiXZezXU8WJRqOTBUWMlRq3Gt8fcloJqL6l+IsOfmXAWd4i7FC/1XV3jm
	hYR0DwMLX3ZRVA1uCXLNwewVWA9WAVHckt7cp5pdupn4QWKctruUgpVMzhe3NYsOLiKnx2omkO5
	ycWR3e14Jb7sigf4fQxP4+5FLD7AnlLRSwbEEp4sh/ULpTFNrT5BQbHaJFYwPFBWbzJvAKbE1zV
	FAkL5D0taFqfb0xnCyPXSmbCkn79gJHbKZmXgd06iO/imuLeKwC3KPrsSf3DSL2bwlF3K6ZuLuB
	Cxtk+oRf2iBaCQCjkUArjK5xSN9uVBeo3/+/T12U+UvoxQIA7UyRq8j8R/No7nJl7
X-Received: by 2002:a05:600c:45ca:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-45dddee902cmr75155945e9.19.1757343837749;
        Mon, 08 Sep 2025 08:03:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcYhKukj/qnNSUjtTjXPQvR6FO4J24oSYFDG6OuWaoCp94GzEZWcRix/Ms1WkzMyuueQOJNg==
X-Received: by 2002:a05:600c:45ca:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-45dddee902cmr75154915e9.19.1757343837183;
        Mon, 08 Sep 2025 08:03:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e115c4f755sm17147156f8f.39.2025.09.08.08.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:03:56 -0700 (PDT)
Message-ID: <e9f2a694-29b0-4761-ad7a-88c4b24b90b7@redhat.com>
Date: Mon, 8 Sep 2025 17:03:54 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] device/dax: update devdax to use mmap_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <85681b9c085ee723f6ad228543c300b029d49cbc.1757329751.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85681b9c085ee723f6ad228543c300b029d49cbc.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2GMIayqQsucVmcy6Hku5SVTZD1FelEg7-x-U4AOdj_Y_1757343838
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> The devdax driver does nothing special in its f_op->mmap hook, so
> straightforwardly update it to use the mmap_prepare hook instead.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   drivers/dax/device.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 2bb40a6060af..c2181439f925 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -13,8 +13,9 @@
>   #include "dax-private.h"
>   #include "bus.h"
>   
> -static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> -		const char *func)
> +static int __check_vma(struct dev_dax *dev_dax, vm_flags_t vm_flags,
> +		       unsigned long start, unsigned long end, struct file *file,
> +		       const char *func)

In general

Acked-by: David Hildenbrand <david@redhat.com>

The only thing that bugs me is __check_vma() that does not check a vma.

Maybe something along the lines of

"check_vma_properties"

Not sure.

-- 
Cheers

David / dhildenb


