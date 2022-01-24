Return-Path: <nvdimm+bounces-2583-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 066D8497988
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jan 2022 08:34:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1C7651C0693
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jan 2022 07:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4792CAC;
	Mon, 24 Jan 2022 07:34:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2002429CA
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 07:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4MNVxTW9H1jXtPwmIwMoQW56SGaJAdlSmyToITo5YVc=; b=gtWEOwKsY5gdAbdEeRaHqZIlQa
	3gb/QEqstFd1g/EF7xV1tYMQnY0k9bDkDeYN8nLyNu+AbVPkOmY5QqWeHIKZ0++X+CJSER8lLYx7p
	NlFIvnNzV+n5HwOv9skzCd785iHghze3hSLCqM480dISVcKJRGFomcZE1403PfK83OFILkayCCaq5
	hBUH5HnfKiEdlWTmVtzOl8LX2ESZxAcGtrCITiUJEH/vn6YkpJHPJkljbvTG55otziLDtJ3K0nnyg
	P3BuLyaBZ/BK/aqkOoLO0mZZPXdzJGBzXvBjUUerw0YeYVbXD2l5QRfWRaUhSuI4/S/2vS5nEvsi+
	rsHWKgGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nBtrq-002V0m-SP; Mon, 24 Jan 2022 07:34:22 +0000
Date: Sun, 23 Jan 2022 23:34:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/5] mm: rmap: fix cache flush on THP pages
Message-ID: <Ye5WfvUdJBhZ3lME@infradead.org>
References: <20220121075515.79311-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121075515.79311-1-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 21, 2022 at 03:55:11PM +0800, Muchun Song wrote:
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b0fd9dc19eba..65670cb805d6 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -974,7 +974,7 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
>  			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
>  				continue;
>  
> -			flush_cache_page(vma, address, page_to_pfn(page));
> +			flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);

Do we need a flush_cache_folio here given that we must be dealing with
what effectively is a folio here?

Also please avoid the overly long line.


