Return-Path: <nvdimm+bounces-4967-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F77601730
	for <lists+linux-nvdimm@lfdr.de>; Mon, 17 Oct 2022 21:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E9228060F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 17 Oct 2022 19:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C691A46BA;
	Mon, 17 Oct 2022 19:17:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D05D2562
	for <nvdimm@lists.linux.dev>; Mon, 17 Oct 2022 19:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666034258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kaCjY2hZj87nOSRh8+EROgeUbXXpszvKIzH7avRKtC0=;
	b=QEZ4oAc5MJSFSDAz5Ickiwh5JBrVZ4wqyZGE8T+3HjbaX/iipJEGiHrHst0ATxkVTnl3zG
	4N23hrkODy12hwJEyJlgNgzyIhcw+I5wGMhQdzcPRujCdf8HsRcyTi/TE8cp+tz0XN3Fbe
	wDOj1BCUzJQz4FHZUssc/hSWEEMA6T4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-541-036Ah4HGObOUysrC5NFP4Q-1; Mon, 17 Oct 2022 15:17:37 -0400
X-MC-Unique: 036Ah4HGObOUysrC5NFP4Q-1
Received: by mail-qk1-f199.google.com with SMTP id h9-20020a05620a244900b006ee944ec451so10436129qkn.13
        for <nvdimm@lists.linux.dev>; Mon, 17 Oct 2022 12:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kaCjY2hZj87nOSRh8+EROgeUbXXpszvKIzH7avRKtC0=;
        b=H+nyjM0dU8BomO3UtE89xUng9xKQMWhAYmIsAy0HpOY8UcYz5xtj3v/mqcALtaHP+E
         9XPBb4gxnUHKFmQlEifH9/WafJP/n+OSACn1YcMpqQlkU3VRq7FML/1BmK06QwFu23lB
         2YoLfRu/A0I1XayrhwPR4/eoW7IAJIDF/iM+UdsVPuGu+wLIrLpxCGYrh7sfke/vE/jV
         jACLLbULSNVLWOlJWm3U/UGatCOK32toCuqATEy/nB7J+cJlbgzzAJCMCBxdxojmjO5N
         ZIjpuVPWW3yQtAVFblITvqJ3ZyuY/nJcWayX0ZLI+27ghQG48I2rWLxaVtpxJob5Ywoh
         xB9Q==
X-Gm-Message-State: ACrzQf2A//Rkxk8eUUA6m61smNe9mY3BJsUMeQon6OIm1I6c2sqNmtgZ
	mfSKwukEMWs2FZXmPVuO38B5WR1Nzx1P+IDTQQucM85img3qA6D1qWXZIOnxDxRfbBDyDWmV1Zo
	kPEmlHvGoq66FwZe+
X-Received: by 2002:a0c:8d07:0:b0:4b4:7b42:9f85 with SMTP id r7-20020a0c8d07000000b004b47b429f85mr9585863qvb.127.1666034255571;
        Mon, 17 Oct 2022 12:17:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5JcLXeZAIfDigOkgm395E6BKaxTQ+DbpFG078goeb45LS6KOEN0NrjI7T/E4XZcO+GQpb3Hw==
X-Received: by 2002:a0c:8d07:0:b0:4b4:7b42:9f85 with SMTP id r7-20020a0c8d07000000b004b47b429f85mr9585833qvb.127.1666034255343;
        Mon, 17 Oct 2022 12:17:35 -0700 (PDT)
Received: from ?IPv6:2600:4040:5c68:4300::feb? ([2600:4040:5c68:4300::feb])
        by smtp.gmail.com with ESMTPSA id w16-20020a05620a425000b006ce441816e0sm458193qko.15.2022.10.17.12.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:17:34 -0700 (PDT)
Message-ID: <90cc019b45c75c72955f73496147aa942ed1e67b.camel@redhat.com>
Subject: Re: [PATCH v3 22/25] mm/memremap_pages: Replace
 zone_device_page_init() with pgmap_request_folios()
From: Lyude Paul <lyude@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Darrick
 J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, John Hubbard
 <jhubbard@nvidia.com>,  Alistair Popple <apopple@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Felix Kuehling <Felix.Kuehling@amd.com>,  Alex
 Deucher <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>,  "Pan, Xinhui" <Xinhui.Pan@amd.com>, David
 Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Ben Skeggs
 <bskeggs@redhat.com>, Karol Herbst <kherbst@redhat.com>,
 =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev,  akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Mon, 17 Oct 2022 15:17:33 -0400
In-Reply-To: <166579194621.2236710.8168919102434295671.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
	 <166579194621.2236710.8168919102434295671.stgit@dwillia2-xfh.jf.intel.com>
Organization: Red Hat Inc.
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

For the nouveau bits:

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Fri, 2022-10-14 at 16:59 -0700, Dan Williams wrote:
> Switch to the common method, shared across all MEMORY_DEVICE_* types,
> for requesting access to a ZONE_DEVICE page. The
> MEMORY_DEVICE_{PRIVATE,COHERENT} specific expectation that newly
> requested pages are locked is moved to the callers.
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: "Jérôme Glisse" <jglisse@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c       |    3 ++-
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    3 ++-
>  drivers/gpu/drm/nouveau/nouveau_dmem.c   |    3 ++-
>  include/linux/memremap.h                 |    1 -
>  lib/test_hmm.c                           |    3 ++-
>  mm/memremap.c                            |   13 +------------
>  6 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index e2f11f9c3f2a..884ec112ad43 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -718,7 +718,8 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
>  
>  	dpage = pfn_to_page(uvmem_pfn);
>  	dpage->zone_device_data = pvt;
> -	zone_device_page_init(dpage);
> +	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
> +	lock_page(dpage);
>  	return dpage;
>  out_clear:
>  	spin_lock(&kvmppc_uvmem_bitmap_lock);
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> index 97a684568ae0..8cf97060122b 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -223,7 +223,8 @@ svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
>  	page = pfn_to_page(pfn);
>  	svm_range_bo_ref(prange->svm_bo);
>  	page->zone_device_data = prange->svm_bo;
> -	zone_device_page_init(page);
> +	pgmap_request_folios(page->pgmap, page_folio(page), 1);
> +	lock_page(page);
>  }
>  
>  static void
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> index 5fe209107246..1482533c7ca0 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> @@ -324,7 +324,8 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
>  			return NULL;
>  	}
>  
> -	zone_device_page_init(page);
> +	pgmap_request_folios(page->pgmap, page_folio(page), 1);
> +	lock_page(page);
>  	return page;
>  }
>  
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 98196b8d3172..3fb3809d71f3 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -187,7 +187,6 @@ static inline bool folio_is_device_coherent(const struct folio *folio)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -void zone_device_page_init(struct page *page);
>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>  void memunmap_pages(struct dev_pagemap *pgmap);
>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 67e6f83fe0f8..e4f7219ae3bb 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -632,7 +632,8 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
>  			goto error;
>  	}
>  
> -	zone_device_page_init(dpage);
> +	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
> +	lock_page(dpage);
>  	dpage->zone_device_data = rpage;
>  	return dpage;
>  
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 87a649ecdc54..c46e700f5245 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -518,18 +518,6 @@ void free_zone_device_page(struct page *page)
>  		put_dev_pagemap(page->pgmap);
>  }
>  
> -void zone_device_page_init(struct page *page)
> -{
> -	/*
> -	 * Drivers shouldn't be allocating pages after calling
> -	 * memunmap_pages().
> -	 */
> -	WARN_ON_ONCE(!percpu_ref_tryget_live(&page->pgmap->ref));
> -	set_page_count(page, 1);
> -	lock_page(page);
> -}
> -EXPORT_SYMBOL_GPL(zone_device_page_init);
> -
>  static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
>  			     int nr_folios)
>  {
> @@ -586,6 +574,7 @@ bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(pgmap_request_folios);
>  
>  void pgmap_release_folios(struct dev_pagemap *pgmap, struct folio *folio, int nr_folios)
>  {
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat


