Return-Path: <nvdimm+bounces-9586-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B62B39F5970
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Dec 2024 23:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D829E1886298
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Dec 2024 22:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7C61F9F6E;
	Tue, 17 Dec 2024 22:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbqKdGNe"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57771D90A7
	for <nvdimm@lists.linux.dev>; Tue, 17 Dec 2024 22:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734473194; cv=none; b=cLxY5hRrYg+2GnmoBtLzgMg823M9zona4fLVeIHnPs7PCdc9dOy6NlhEmTbkX5ddcpFTzJlbHAgSGnL4GHZPKbZG614SoI9z2pQxk42qZLx9RMw7ii8kXXIZtOfMoUK0LMtkWmYUtXY3SdIveFzJaX07FoBwdsBDodN0LaNMLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734473194; c=relaxed/simple;
	bh=CFFVeeJGulFiZAVQoOwWWmr2t17+p50wNCCr0sMnZu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGoI0ZupRlueF2p7E8mXZS+xbNlVe1vPw2ubisHPKI1A5sRGhwnjLMR6iXh9i+mxFPct6kS4rHJiaahwog9WOYwVRb1vgdogZlLcDHJFNanE/skyzQbjYG9tnyoz0ByHQxLybuciu4Pcn74kBwxc2vtFPSvduTpxRJTMXAvS0N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cbqKdGNe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734473190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OSLYMoWvHcnkmKFurx8SkgSXyiJyqs7HoLAYTVGYrAc=;
	b=cbqKdGNePEHVnCEnSroUIs4pU47mslv31s5mtcL2m8KIGfzZj4rq4J68wSG3D97yI6sctT
	Xs8lFETmNOtOuD2tKBlUvuI430FUK90gzY/bX24cg9PzOCuk5Cc9wMJ+a19cA7n6zPB6Jn
	xWGN3COc8AOgvbQhTgKjOjxKiRIjjr8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-AOHQVqp_Mv2DBTwzAvfPGQ-1; Tue, 17 Dec 2024 17:06:29 -0500
X-MC-Unique: AOHQVqp_Mv2DBTwzAvfPGQ-1
X-Mimecast-MFC-AGG-ID: AOHQVqp_Mv2DBTwzAvfPGQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385df115288so2427929f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 17 Dec 2024 14:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734473188; x=1735077988;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OSLYMoWvHcnkmKFurx8SkgSXyiJyqs7HoLAYTVGYrAc=;
        b=XI/wE6sLEbKiQ4IrFR/glCWw2Mzvf6yIhpSM/b7ADzP6/SS64rc88N7dB8pwFh3kMJ
         KKb7+j3hZBogyAGjtA4iIhELLWGiS1PNbrRO9F8Xv51TnXmRQGRCeQdrbWrXjZZMl7Pq
         nDcd3irTisBsqdw957S0vEElH20X6yJE8Vbuvv8/W5426rEnHG/JmTSQMnViZ1s+QBTc
         /xYy0hxL3wklUidjBaVOFSb1fW2v+VmP7F6faBkCptcyvCHygqzUeyk+YSlLkWgrYAAo
         sYHDQykIrL+AP0FWeVMHCz/DN8yuJWYl7a1v+3HY2A54PHu3OWkJxUt+q4p2DwffMwPM
         3WuA==
X-Forwarded-Encrypted: i=1; AJvYcCUigmVlmj1D/NVpiO2gQ9j06k7daD3M4bohfxjcO+lkiEyBmwXTGYiKbSqj/0WzbzUExoJ7Gd0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwR5HZovafVi+Tdgn1gHwjWTTeonuvFKco6uAvfQVQvApsmo0+s
	ApMaLy3UcM5mOx3iLzd2SbbVQnhZgPAj/hNik+umYTe4vyC8n2/1AHTt6/hEjnjL2ewmzE95gCq
	dXghDZE7y7hmt3nbN3wHwvdcBDx/NhNn2Q/udQRE9l/u1cJMMhk8Y2Q==
X-Gm-Gg: ASbGncvIBr36SjYm9IR225lTqk6YgRMnajmlB55LTHmstqELlZhJk98BBZraCK+pP1c
	W0SZqIO6JVF91wE+I7Tq0LoPiQMUOhzhFbG1yn9n7xFvNlUvgGbF+ys3KwFC78f7MJk6z52nJOp
	XaOMsfgtXROVwShu8kezFWBTQMEZdoX++fq6orvt+TimAT6sjIgpgNrZhIHAxgjXVEiMwILSomB
	weWmtoV033TdgwfLMgt3EtbqZwIPGAKfTFYqvMXWtzvA7YvZR8yrI8RY0V6DvhDnBICh5DWC2ya
	KpFp7pNIXSdkiX6GG1f594Ox+HrK0JGe8x+ABZfXWOXlj8rlBMn8oGCWHxxA1nTq4d1KcOgjqOV
	ejOLLYGTo
X-Received: by 2002:a05:6000:461a:b0:385:eecb:6f02 with SMTP id ffacd0b85a97d-388e4d8b688mr358653f8f.28.1734473188371;
        Tue, 17 Dec 2024 14:06:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEefTx+5wwgHu5Lo3QBynYxK4sBxxlYTWobNsuzYzh7kr1/3xagCl49eAlHDCo53GInNei+Aw==
X-Received: by 2002:a05:6000:461a:b0:385:eecb:6f02 with SMTP id ffacd0b85a97d-388e4d8b688mr358632f8f.28.1734473188043;
        Tue, 17 Dec 2024 14:06:28 -0800 (PST)
Received: from ?IPV6:2003:cb:c73b:5600:c716:d8e0:609d:ae92? (p200300cbc73b5600c716d8e0609dae92.dip0.t-ipconnect.de. [2003:cb:c73b:5600:c716:d8e0:609d:ae92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8012112sm12401862f8f.11.2024.12.17.14.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 14:06:27 -0800 (PST)
Message-ID: <ea6eda57-f150-47ea-97b8-fc8eeaf81bd3@redhat.com>
Date: Tue, 17 Dec 2024 23:06:25 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/25] mm/gup.c: Remove redundant check for PCI P2PDMA
 page
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
 david@fromorbit.com, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.18cbcff3638c6aacc051c44533ebc6c002bf2bd9.1734407924.git-series.apopple@nvidia.com>
 <3f20b8d258d4eb72e1eadd5926d892bc61f0e0d4.1734407924.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <3f20b8d258d4eb72e1eadd5926d892bc61f0e0d4.1734407924.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KcQA-V46iAM8z-qPpYv4ViQKpXq5bkWxl154n0oXvXE_1734473188
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.12.24 06:12, Alistair Popple wrote:
> PCI P2PDMA pages are not mapped with pXX_devmap PTEs therefore the
> check in __gup_device_huge() is redundant. Remove it
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Wiliams <dan.j.williams@intel.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

Nit: patch subject should start with "mm/gup: ...".

-- 
Cheers,

David / dhildenb


