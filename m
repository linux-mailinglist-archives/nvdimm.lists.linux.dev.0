Return-Path: <nvdimm+bounces-11371-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1720EB29C45
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Aug 2025 10:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8B4317DEA0
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Aug 2025 08:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AE823A58B;
	Mon, 18 Aug 2025 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5k9MU/B"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E21FE444
	for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755505880; cv=none; b=I2ocBDSsWzw+YTDzLqXk/lHmgUH5cTWMHH1iDjPWlOkuEBI1mD+jxD3OSKv1N5aHrmDVkn5AmrJoJxEwoR8aQcTX4ETlmTrXIELb6/e+iz5B/k9d4w1rJ1cTXwhIjXJpJOZw5324shNy2/JwHKgiBG0VW2Z1joTp2rI93SJPbN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755505880; c=relaxed/simple;
	bh=IQbIw12wuNp+2ELSWXXkEq76fTBfm0sHim361qJEUhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=snJcAwMuUS0bIPvcL9XDuVcpKq/Kq50NHw9lCGapQAa9GG1TebTuAbFNhATlVvK6Tbm9UkcwEn+4bcO4xWd0WeZJg5SZlbNz9Zv24chPMJhldxKr2Du9vOU2/VL658wK0wMqJ2QrBkwkxOEAR1a4w28MKYmuvIysazb0TwAuWjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E5k9MU/B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755505878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IrBtZYA5Z28bn60ohedxv6GlFgI1zXS/Odi0JqkPxhE=;
	b=E5k9MU/BF7RTf/ZDvNdCXxi4Jt/lvDsAKkrgGTh9kuPfpf+b65NBVHpZWOV+JKEo7/Bgf2
	0f2QCH3zTZ8wzhfNpyx02uxDN6kfJvqy8pFuf6/prwkhL5pM1VC6nt7vLjqeG5AbIN+SWr
	15xP3F4LOsaNhYqkbY/+iLrMM0+rvK8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-tC21Q1wcMPiHH503m7nptg-1; Mon, 18 Aug 2025 04:31:16 -0400
X-MC-Unique: tC21Q1wcMPiHH503m7nptg-1
X-Mimecast-MFC-AGG-ID: tC21Q1wcMPiHH503m7nptg_1755505876
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so22786965e9.0
        for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 01:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755505875; x=1756110675;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrBtZYA5Z28bn60ohedxv6GlFgI1zXS/Odi0JqkPxhE=;
        b=PxxuATeKfq0CSd8kaLtA09+v3OKD+7DwoQcrfN9L2ORywBGmDoZVj3bCm+L3y1Sfgf
         u2HQ2riboikqOcfjqewTqjLgldUucDImQkU8oP0lpt1rYwB6q4VIyfYWY/MC7kH9HiUW
         LxIi8gSLR6cah5TPZFV5hiIpiwOQMom0GEZd6Fmk8haatY8oDzkUXAmeYeNthdFHBRFc
         BPTDwJ+IYh+uZoUb0bEYgtREshF//bnN+gyr0+riiQfGZBM1h3NlcP+RdzPIJRfcq7dJ
         BP/YcOSFwSm4O66Y2ltzTDpiY7H29C/0iI0DlgiY6KUZpjRn3rDbW9AVrmTPrb1JMlRB
         AguA==
X-Forwarded-Encrypted: i=1; AJvYcCWhl097nov4moOQIhnU6QGlGVF+0YBkCrX9qeKGqApa515U0rxje0SDRSrk9giNZrwwuyPPrsU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLpKotiaZSiy44c7OaUIkPixqOoOwlqrqdiWmcSfse6ROUqazb
	adRPzNcw+eWDthAGYW6RhgbPJcCsXaQ1VdUyzE3QgVeXdvItQ07AW9hARkUdipbGC3z91S7w9MW
	FFU0gVPyOGOCyAl4USX6Z/oylw/riNf/WRDs+yaLjS6mJHloP2yD80vsYZg==
X-Gm-Gg: ASbGncs9kKlZ7dcGpWOvHkOMsWz67px/yc2bNgsnwA2LZCTzPphAlToo2mGd03wo8vf
	Fqjd5bywr1YbMT9tY9NmNmU7srjiU7O7YOznA839g2DL8eAQ0+Nyh8niaeX2Vdu9mV/0H5WYZ9a
	DZemm5vciBhRK6emX+VYGP6xvG2N1OHtaAnJJr2Lu2HVDBNTdRNGbK4Q/Kbo109Haw8qRK9xGx+
	Vd3VZemwrvXjskl7tPTIVGODp322hXLX7DKRXNMgA/XkIo/1UX+eGG4Do9aFxK1eQNPjQddGpjq
	NFIgjBdZaNzknVwiTEMgliV51oLYC7D81Qd9PeV5cXqFUeRh/cZMn2us8eonM2RtT3DZNRhRN+a
	I5kNmSFUmpvSv+Ya4R6OJMKBvL5B7RqlrRRMi+kF4cBYnbzoxfYZ0oZ0TY8Y7DGBa
X-Received: by 2002:a05:600c:a43:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45a21839edbmr81793165e9.22.1755505875232;
        Mon, 18 Aug 2025 01:31:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUJ0JHZagWj9XCwRsqfc1oqsDUPxyV3bXjzLuhESOGbYeY8B2myjjJBUZ0Oh+caqJMAY5Uow==
X-Received: by 2002:a05:600c:a43:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45a21839edbmr81792535e9.22.1755505874765;
        Mon, 18 Aug 2025 01:31:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64a40c3asm12015938f8f.14.2025.08.18.01.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 01:31:14 -0700 (PDT)
Message-ID: <63082884-1fe2-4740-8e6a-e1d06aa5e239@redhat.com>
Date: Mon, 18 Aug 2025 10:31:12 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to
 memory_get_phys_to_nid
To: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Pankaj Gupta
 <pankaj.gupta.linux@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
 <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
 <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MwBO0QPtMz3VsW7k0_OWf9qJXe-nSxWhGDmyiB_Vtjk_1755505876
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.08.25 10:27, Pratyush Brahma wrote:
> On Mon, Aug 18, 2025 at 12:29 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
>>> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
>>>
>>> The function `memory_add_physaddr_to_nid` seems a misnomer.
>>> It does not to "add" a physical address to a NID mapping,
>>> but rather it gets the NID associated with a given physical address.
>>
>> You probably misunderstood what the function is used for: memory hotplug
>> aka "memory_add".
> Thanks for your feedback. I get the part about memory hotplug here but
> using memory_add still seems a little odd as it doesn't truly reflect
> what this api is doing.
> However, I agree that my current suggestion
> may not be the perfect choice for the name, so I'm open to suggestions.
> 
> Perhaps, something like "memory_add_get_nid_by_phys" may work here?

I don't think this name is really any better and worth the churn :(

-- 
Cheers

David / dhildenb


